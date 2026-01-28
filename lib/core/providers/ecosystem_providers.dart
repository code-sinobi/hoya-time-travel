import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/ecosystem_repository.dart';

part 'ecosystem_providers.g.dart';

@riverpod
Future<Map<String, int>> userTraits(Ref ref) {
  return ref.watch(ecosystemRepositoryProvider).getUserTraits();
}

@riverpod
Future<List<Map<String, dynamic>>> mentorHistory(Ref ref) {
  return ref.watch(ecosystemRepositoryProvider).getMentorHistory();
}

@riverpod
Future<List<Map<String, dynamic>>> activeEvents(Ref ref) {
  return ref.watch(ecosystemRepositoryProvider).getActiveEvents();
}
