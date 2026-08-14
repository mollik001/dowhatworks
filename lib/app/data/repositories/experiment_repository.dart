import '../../../core/network/api_client.dart';
import '../../../core/values/constants.dart';
import '../models/experiment_models.dart';
import '../services/storage_service.dart';

class ExperimentRepository {
  String get _token => StorageService.getAccessToken() ?? '';

  /// POST /api/v1/experiments/
  Future<Experiment> createExperiment({
    required String hypothesis,
    required String action,
    required String metric,
    required int durationDays,
  }) async {
    print('[Experiment] createExperiment → POST ${ApiConstants.experiments}');
    final response = await ApiClient.post(
      ApiConstants.experiments,
      body: {
        'hypothesis': hypothesis,
        'action': action,
        'metric': metric,
        'duration_days': durationDays,
      },
      token: _token,
    );
    print('[Experiment] createExperiment response: $response');
    return Experiment.fromJson(response);
  }

  /// GET /api/v1/experiments/
  Future<List<Experiment>> getExperiments() async {
    print('[Experiment] getExperiments → GET ${ApiConstants.experiments}');
    final response = await ApiClient.get(ApiConstants.experiments, token: _token);
    print('[Experiment] getExperiments raw keys: ${response.keys.toList()}');

    // API returns a plain list — ApiClient wraps it as { "data": [...] }
    final rawList = response['data'] as List<dynamic>?
        ?? response['results'] as List<dynamic>?
        ?? <dynamic>[];

    return rawList
        .map((e) => Experiment.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/v1/experiments/templates/
  Future<List<ExperimentTemplate>> getTemplates() async {
    print('[Experiment] getTemplates → GET ${ApiConstants.experimentTemplates}');
    final response = await ApiClient.get(ApiConstants.experimentTemplates, token: _token);
    print('[Experiment] getTemplates raw keys: ${response.keys.toList()}');

    final rawList = response['data'] as List<dynamic>?
        ?? response['results'] as List<dynamic>?
        ?? <dynamic>[];

    return rawList
        .map((e) => ExperimentTemplate.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// GET /api/v1/experiments/{id}/
  Future<ExperimentDetail> getExperimentDetail(int id) async {
    final endpoint = ApiConstants.experimentDetail(id);
    print('[Experiment] getExperimentDetail → GET $endpoint');
    final response = await ApiClient.get(endpoint, token: _token);
    print('[Experiment] getExperimentDetail response id=${response['id']}');
    return ExperimentDetail.fromJson(response);
  }

  /// DELETE /api/v1/experiments/{id}/
  Future<void> deleteExperiment(int id) async {
    final endpoint = ApiConstants.experimentDetail(id);
    print('[Experiment] deleteExperiment → DELETE $endpoint');
    await ApiClient.delete(endpoint, token: _token);
    print('[Experiment] deleteExperiment success id=$id');
  }
  Future<ExperimentLog> logExperiment({
    required int experimentId,
    required double metricValue,
    required String notes,
    required String dailyObservation,
    String completed = 'yes',
  }) async {
    final endpoint = ApiConstants.experimentLogs(experimentId);
    print('[Experiment] logExperiment → POST $endpoint');

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final response = await ApiClient.post(
      endpoint,
      body: {
        'date': todayStr,
        'completed': completed,
        'metric_value': metricValue,
        'notes': notes,
        'daily_observation': dailyObservation,
        'logged_metrics': {},
      },
      token: _token,
    );
    print('[Experiment] logExperiment response: $response');
    return ExperimentLog.fromJson(response);
  }
}
