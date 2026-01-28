import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

part 'supabase_config.g.dart';

@Riverpod(keepAlive: true)
SupabaseConfig supabaseConfig(Ref ref) {
  return const SupabaseConfig(
    url: String.fromEnvironment('SUPABASE_URL', defaultValue: ''),
    anonKey: String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: ''),
  );
}

class SupabaseConfig {
  final String url;
  final String anonKey;

  const SupabaseConfig({required this.url, required this.anonKey});

  bool get isValid => url.isNotEmpty && anonKey.isNotEmpty;
}
