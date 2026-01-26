import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'openrouter_service.g.dart';

/// OpenRouter API Service
/// Uses the OpenRouter unified API for AI model access
/// Default model: GLM 4.5 Air (free)
@Riverpod(keepAlive: true)
OpenRouterService openRouterService(Ref ref) {
  const apiKey = String.fromEnvironment('OPENROUTER_API_KEY', defaultValue: '');

  if (apiKey.isEmpty) {
    debugPrint(
      'WARNING: OPENROUTER_API_KEY is missing. AI features will not work.',
    );
  }

  return OpenRouterService(apiKey);
}

class OpenRouterService {
  final String apiKey;
  static const String _baseUrl =
      'https://openrouter.ai/api/v1/chat/completions';
  static const String _defaultModel = 'z-ai/glm-4.5-air:free';

  // App attribution headers for OpenRouter leaderboards
  static const Map<String, String> _appHeaders = {
    'HTTP-Referer': 'https://hoya-app.com',
    'X-Title': 'Hoya - History\'s Own Your Adventure',
  };

  OpenRouterService(this.apiKey);

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
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
          ..._appHeaders,
        },
        body: jsonEncode({
          'model': model ?? _defaultModel,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': userPrompt},
          ],
          'temperature': 0.7,
          'max_tokens': 4096,
        }),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'OpenRouter Error: ${response.statusCode} - ${response.body}',
        );
        throw Exception('OpenRouter API error: ${response.statusCode}');
      }

      final jsonResponse = jsonDecode(response.body) as Map<String, dynamic>;

      debugPrint('OpenRouter Response: ${response.body}'); // DEBUG LOG

      // Extract the assistant's message content
      final choices = jsonResponse['choices'] as List?;
      if (choices == null || choices.isEmpty) {
        throw Exception('No response from OpenRouter');
      }

      final messageContent = choices[0]['message']['content'] as String;

      // Parse the JSON content from the response
      final cleanJson = _cleanJson(messageContent);
      return jsonDecode(cleanJson) as Map<String, dynamic>;
    } catch (e) {
      debugPrint('OpenRouter Error: $e');
      rethrow;
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
