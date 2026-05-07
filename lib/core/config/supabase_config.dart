import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'supabase_config.g.dart';

@Riverpod(keepAlive: true)
SupabaseConfig supabaseConfig(Ref ref) {
  return const SupabaseConfig(
    url: String.fromEnvironment('SUPABASE_URL'),
    anonKey: String.fromEnvironment('SUPABASE_ANON_KEY'),
  );
}

class SupabaseConfig {
  const SupabaseConfig({required this.url, required this.anonKey});
  final String url;
  final String anonKey;

  bool get isValid => url.isNotEmpty && anonKey.isNotEmpty;
}
