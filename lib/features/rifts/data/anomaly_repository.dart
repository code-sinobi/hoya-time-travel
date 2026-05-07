import 'package:supabase_flutter/supabase_flutter.dart';

import '../domain/anomaly.dart';

/// Repository for fetching and managing timeline anomalies from Supabase
class AnomalyRepository {
  AnomalyRepository(this._client);
  final SupabaseClient _client;

  /// Fetches all active anomalies, ordered by severity
  Future<List<Anomaly>> getActiveAnomalies() async {
    final response = await _client
        .from('anomalies')
        .select()
        .eq('is_active', true)
        .order('severity', ascending: true) // critical first
        .order('collapse_deadline', ascending: true, nullsFirst: false);

    return (response as List)
        .map((json) => Anomaly.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Fetches a single anomaly by ID
  Future<Anomaly?> getAnomalyById(String id) async {
    final response =
        await _client.from('anomalies').select().eq('id', id).maybeSingle();

    if (response == null) return null;
    return Anomaly.fromJson(response);
  }

  /// Fetches anomalies connected to a given anomaly via cascade
  Future<List<Anomaly>> getCascadeAnomalies(String anomalyId) async {
    final anomaly = await getAnomalyById(anomalyId);
    if (anomaly == null || anomaly.cascadeAnomalyIds.isEmpty) {
      return [];
    }

    final response = await _client
        .from('anomalies')
        .select()
        .inFilter('id', anomaly.cascadeAnomalyIds);

    return (response as List)
        .map((json) => Anomaly.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// Purges an anomaly - removes it from timeline (costs Temporal Energy)
  Future<bool> purgeAnomaly(String anomalyId, String userId) async {
    try {
      // Deduct TE cost and mark anomaly as purged
      await _client.rpc<dynamic>(
        'purge_anomaly',
        params: {
          'anomaly_id': anomalyId,
          'user_id': userId,
        },
      );
      return true;
    } on Object {
      return false;
    }
  }

  /// Stabilizes an anomaly - enters story mode to resolve it (costs Chronos)
  Future<bool> stabilizeAnomaly(String anomalyId, String userId) async {
    try {
      // Deduct Chronos cost and start story session
      await _client.rpc<dynamic>(
        'stabilize_anomaly',
        params: {
          'anomaly_id': anomalyId,
          'user_id': userId,
        },
      );
      return true;
    } on Object {
      return false;
    }
  }

  /// Stream of anomaly updates for real-time UI with robust fallback
  Stream<List<Anomaly>> watchAnomalies() async* {
    // 1. Immediate fetch via REST (Robustness Layer)
    // This ensures data loads even if Realtime is blocked/timeout
    List<Anomaly> currentData = [];
    try {
      currentData = await getActiveAnomalies();
      yield currentData;
    } on Object {
      // If REST fails, we might be offline, yield empty or rethrow based on strategy
      // For now, we continue to try streaming
    }

    // 2. Attempt Realtime subscription
    try {
      final stream = _client
          .from('anomalies')
          .stream(primaryKey: ['id'])
          .eq('is_active', true)
          .map(
            (data) => data.map(Anomaly.fromJson).toList()
              ..sort((a, b) {
                final severityCompare =
                    a.severity.index.compareTo(b.severity.index);
                if (severityCompare != 0) return severityCompare;
                if (a.collapseDeadline == null) return 1;
                if (b.collapseDeadline == null) return -1;
                return a.collapseDeadline!.compareTo(b.collapseDeadline!);
              }),
          );

      yield* stream;
    } on Object {
      // 3. Fallback: If socket fails, maintain the REST data
      // We log the error but don't crash the UI stream
      // print('Realtime connection failed: $e. Using polling/static data.');
      // In a more advanced version, we could set up a periodic timer here to poll
      // For now, yielding the REST data (already done) is sufficient to prevent the crash
    }
  }
}
