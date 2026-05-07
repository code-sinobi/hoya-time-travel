import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../utils/logger.dart';

part 'openrouter_service.g.dart';

/// OpenRouter API Service
/// Uses the OpenRouter unified API for AI model access
/// Default model: Gemma 3n E4B IT (free)
@Riverpod(keepAlive: true)
OpenRouterService openRouterService(Ref ref) {
  var apiKey = const String.fromEnvironment('OPENROUTER_API_KEY');

  if (apiKey.isEmpty && dotenv.isInitialized) {
    apiKey = dotenv.env['OPENROUTER_API_KEY'] ?? '';
  }

  if (apiKey.isEmpty) {
    debugPrint(
      'WARNING: OPENROUTER_API_KEY is missing. AI features will not work.',
    );
  }

  return OpenRouterService(apiKey);
}

class TokenUsage {
  TokenUsage({
    required this.promptTokens,
    required this.completionTokens,
    required this.totalTokens,
  });

  factory TokenUsage.fromJson(Map<String, dynamic> json) {
    return TokenUsage(
      promptTokens: (json['prompt_tokens'] as num?)?.toInt() ?? 0,
      completionTokens: (json['completion_tokens'] as num?)?.toInt() ?? 0,
      totalTokens: (json['total_tokens'] as num?)?.toInt() ?? 0,
    );
  }
  final int promptTokens;
  final int completionTokens;
  final int totalTokens;

  @override
  String toString() =>
      'Usage: $totalTokens tokens (P: $promptTokens, C: $completionTokens)';
}

class OpenRouterService {
  OpenRouterService(this.apiKey);
  final String apiKey;
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';

  // Model Tiers
  static const String modelFree = 'google/gemma-3n-e4b-it:free';
  static const String modelStandard = 'anthropic/claude-3-haiku';
  static const String modelPremium = 'anthropic/claude-3.5-sonnet';

  // Last usage stats
  TokenUsage? _lastUsage;
  TokenUsage? get lastUsage => _lastUsage;

  // App attribution headers for OpenRouter leaderboards
  static const Map<String, String> _appHeaders = {
    'HTTP-Referer': 'https://chrono-app.com',
    'X-Title': 'Chrono - History\'s Own Your Adventure',
  };

  /// Generate content using OpenRouter API
  /// Returns parsed JSON response from the AI model
  Future<Map<String, dynamic>> generateContent(
    String systemPrompt,
    String userPrompt, {
    String? model,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'OpenRouter API Key is missing. Set OPENROUTER_API_KEY in .env',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              ..._appHeaders,
            },
            body: jsonEncode({
              'model': model ?? modelFree,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': userPrompt},
              ],
              'temperature': 0.7,
              'max_tokens': 4096,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        debugPrint(
          'OpenRouter Error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('OpenRouter API error: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      // Track usage
      if (jsonResponse.containsKey('usage')) {
        _lastUsage =
            TokenUsage.fromJson(jsonResponse['usage'] as Map<String, dynamic>);
        AppLogger.debug('Token Usage: $_lastUsage');
      }

      // Extract the assistant's message content
      final choices = jsonResponse['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response from OpenRouter');
      }

      final firstChoice = choices[0] as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      final messageContent = message['content'] as String;

      // Parse the JSON content from the response
      final cleanJson = _cleanJson(messageContent);
      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } on Object catch (e) {
      AppLogger.error('Generation Error', error: e);

      // Basic fallback logic: if current model isn't the free one, try the free one
      if (model != modelFree) {
        AppLogger.info('Attempting fallback to free model...');
        return generateContent(systemPrompt, userPrompt, model: modelFree);
      }

      rethrow;
    }
  }

  /// Generate raw text content using OpenRouter API
  Future<String> generateText(
    String systemPrompt,
    String userPrompt, {
    String? model,
  }) async {
    if (apiKey.isEmpty) {
      throw Exception(
        'OpenRouter API Key is missing. Set OPENROUTER_API_KEY in .env',
      );
    }

    try {
      final response = await http
          .post(
            Uri.parse(_baseUrl),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $apiKey',
              ..._appHeaders,
            },
            body: jsonEncode({
              'model': model ?? modelFree,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': userPrompt},
              ],
              'temperature': 0.7,
              'max_tokens': 4096,
            }),
          )
          .timeout(const Duration(seconds: 60));

      if (response.statusCode != 200) {
        throw Exception('OpenRouter API error: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      // Track usage
      if (jsonResponse.containsKey('usage')) {
        _lastUsage =
            TokenUsage.fromJson(jsonResponse['usage'] as Map<String, dynamic>);
      }

      final choices = jsonResponse['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response from OpenRouter');
      }

      final firstChoice = choices[0] as Map<String, dynamic>;
      final message = firstChoice['message'] as Map<String, dynamic>;
      return message['content'] as String;
    } on Object catch (e) {
      AppLogger.error('Text Generation Error', error: e);
      if (model != modelFree) {
        return generateText(systemPrompt, userPrompt, model: modelFree);
      }
      rethrow;
    }
  }

  /// Generate content using OpenRouter API with Streaming (SSE)
  Stream<String> streamContent(
    String systemPrompt,
    String userPrompt, {
    String? model,
  }) async* {
    if (apiKey.isEmpty) {
      throw Exception(
        'OpenRouter API Key is missing. Set OPENROUTER_API_KEY in .env',
      );
    }

    final client = http.Client();
    try {
      final request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
        ..._appHeaders,
      });
      request.body = jsonEncode({
        'model': model ?? modelFree,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': userPrompt},
        ],
        'stream': true,
        'temperature': 0.7,
        'max_tokens': 4096,
      });

      final response = await client.send(request);

      if (response.statusCode != 200) {
        throw Exception('OpenRouter API error: ${response.statusCode}');
      }

      await for (final line in response.stream
          .transform(utf8.decoder)
          .transform(const LineSplitter())) {
        if (line.startsWith('data: ')) {
          final data = line.substring(6).trim();
          if (data == '[DONE]') break;

          try {
            final json = jsonDecode(data) as Map<String, dynamic>;
            final choices = json['choices'] as List?;
            if (choices != null && choices.isNotEmpty) {
              final firstChoice = choices[0] as Map<String, dynamic>;
              final delta = firstChoice['delta'] as Map<String, dynamic>?;
              if (delta != null && delta['content'] != null) {
                yield delta['content'] as String;
              }
            }
          } on Object catch (e) {
            AppLogger.error('Streaming chunk parse error', error: e);
          }
        }
      }
    } on Object catch (e) {
      AppLogger.error('Stream Error', error: e);
      rethrow;
    } finally {
      client.close();
    }
  }

  /// Clean up response to find the valid JSON object
  String _cleanJson(String text) {
    // 1. Try to find the first '{' and the last '}'
    final startIndex = text.indexOf('{');
    final endIndex = text.lastIndexOf('}');

    if (startIndex != -1 && endIndex != -1 && endIndex > startIndex) {
      return text.substring(startIndex, endIndex + 1);
    }

    // Fallback: Return original trimmed text if no braces found
    return text.trim();
  }
}
