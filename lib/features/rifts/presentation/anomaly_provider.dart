import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../data/anomaly_repository.dart';
import '../domain/anomaly.dart';

part 'anomaly_provider.g.dart';

/// Provides the AnomalyRepository instance
@riverpod
AnomalyRepository anomalyRepository(Ref ref) {
  return AnomalyRepository(Supabase.instance.client);
}

/// Fetches active anomalies as an async value
@riverpod
Future<List<Anomaly>> activeAnomalies(Ref ref) async {
  final repository = ref.watch(anomalyRepositoryProvider);
  return repository.getActiveAnomalies();
}

/// Streams anomalies for real-time updates
@riverpod
Stream<List<Anomaly>> anomaliesStream(Ref ref) async* {
  final repository = ref.watch(anomalyRepositoryProvider);
  int retryAttempts = 0;
  while (true) {
    try {
      yield* repository.watchAnomalies();
      break;
    } on Object {
      if (retryAttempts > 5) rethrow;
      retryAttempts++;
      await Future<void>.delayed(Duration(seconds: 2 * retryAttempts));
    }
  }
}

/// Controller for anomaly actions (purge, stabilize)
@riverpod
class AnomalyController extends _$AnomalyController {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  /// Purge multiple anomalies
  Future<bool> purgeAnomalies(List<String> anomalyIds) async {
    state = const AsyncLoading();
    try {
      final repository = ref.read(anomalyRepositoryProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id;
      if (userId == null) {
        state = AsyncError('Not authenticated', StackTrace.current);
        return false;
      }

      bool allSuccess = true;
      for (final id in anomalyIds) {
        final success = await repository.purgeAnomaly(id, userId);
        if (!success) allSuccess = false;
      }

      if (allSuccess) {
        ref.invalidate(activeAnomaliesProvider);
        state = const AsyncData(null);
      } else {
        state =
            AsyncError('Failed to purge some anomalies', StackTrace.current);
      }
      return allSuccess;
    } on Object catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Purge an anomaly from the timeline
  Future<bool> purgeAnomaly(String anomalyId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(anomalyRepositoryProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        state = AsyncError('Not authenticated', StackTrace.current);
        return false;
      }

      final success = await repository.purgeAnomaly(anomalyId, userId);

      if (success) {
        // Invalidate the anomalies list to refresh
        ref.invalidate(activeAnomaliesProvider);
        state = const AsyncData(null);
      } else {
        state = AsyncError('Failed to purge anomaly', StackTrace.current);
      }

      return success;
    } on Object catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }

  /// Stabilize an anomaly by entering story mode
  Future<bool> stabilizeAnomaly(String anomalyId) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(anomalyRepositoryProvider);
      final userId = Supabase.instance.client.auth.currentUser?.id;

      if (userId == null) {
        state = AsyncError('Not authenticated', StackTrace.current);
        return false;
      }

      final success = await repository.stabilizeAnomaly(anomalyId, userId);

      if (success) {
        ref.invalidate(activeAnomaliesProvider);
        state = const AsyncData(null);
      } else {
        state = AsyncError('Failed to stabilize anomaly', StackTrace.current);
      }

      return success;
    } on Object catch (e, st) {
      state = AsyncError(e, st);
      return false;
    }
  }
}

/// Fetches cascade-connected anomalies for a given anomaly
@riverpod
Future<List<Anomaly>> cascadeAnomalies(Ref ref, String anomalyId) async {
  final repository = ref.watch(anomalyRepositoryProvider);
  return repository.getCascadeAnomalies(anomalyId);
}
