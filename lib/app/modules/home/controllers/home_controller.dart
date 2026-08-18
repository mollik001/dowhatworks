import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/values/constants.dart';
import '../../../data/models/experiment_models.dart';
import '../../../data/repositories/experiment_repository.dart';
import '../../../data/services/storage_service.dart';

class HomeController extends GetxController {
  final _experimentRepo = ExperimentRepository();

  // Loading state
  final isLoading = true.obs;

  // Today's check-in
  final hasCheckedInToday = false.obs;
  final sleepValue = Rxn<double>();
  final focusValue = Rxn<double>();

  // Total completed logs across the active experiment
  final totalLogs = 0.obs;

  // Active experiment progress: e.g. "Day 3 of 7"
  final experimentDayLabel = ''.obs; // e.g. "Day 3 of 7"
  final experimentElapsed = 0.obs;
  final experimentDuration = 0.obs;

  // Active experiment (full object for protocol card + graph)
  final activeExperiment = Rxn<Experiment>();

  // Active experiment data for Performance History graph
  final activeExperimentLogs = <ExperimentLog>[].obs;
  final activeExperimentMetric = ''.obs;
  final activeExperimentStartDate = Rxn<String>();
  final activeExperimentDurationDays = 0.obs;

  // Beliefs & Attention baseline history
  final baselineHistory = <BaselineEntry>[].obs;

  // Onboarding belief answers for radar chart
  final onboardingData = Rxn<OnboardingData>();

  // Home section tab (0 = Metrics, 1 = Beliefs & Attention)
  final homeTabIndex = 0.obs;

  // Tab switching — listened to by MainScreen
  final selectedTabIndex = 0.obs;

  // Date display
  final dayLabel = ''.obs; // e.g. "Wednesday"

  void switchTab(int index) {
    selectedTabIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    _computeDayLabel();
    fetchData();
  }

  void _computeDayLabel() {
    const days = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday',
      'Friday', 'Saturday', 'Sunday'
    ];
    final now = DateTime.now();
    dayLabel.value = days[now.weekday - 1];
  }

  Future<void> fetchData() async {
    final token = StorageService.getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      isLoading.value = true;

      // Fire all requests in parallel
      final results = await Future.wait([
        ApiClient.get(ApiConstants.dailyCheckin, token: token),
        ApiClient.get('${ApiConstants.dailyCheckin}?history=true', token: token),
        _experimentRepo.getExperiments(),
        ApiClient.get(ApiConstants.baselineHistory, token: token),
        ApiClient.get(ApiConstants.onboarding, token: token),
      ]);

      final todayResponse      = results[0] as Map<String, dynamic>;
      final historyResponse    = results[1] as Map<String, dynamic>;
      final experiments        = results[2] as List;
      final baselineResponse   = results[3] as Map<String, dynamic>;
      final onboardingResponse = results[4] as Map<String, dynamic>;

      print('[Home] Today: $todayResponse');
      print('[Home] History: $historyResponse');

      // Onboarding / belief distribution
      if (onboardingResponse['answers'] != null) {
        onboardingData.value = OnboardingData.fromJson(onboardingResponse);
      }

      // Baseline history
      final rawBaseline = baselineResponse['data'] as List<dynamic>?
          ?? baselineResponse['results'] as List<dynamic>?
          ?? (baselineResponse.values.first is List
              ? baselineResponse.values.first as List<dynamic>
              : <dynamic>[]);
      baselineHistory.value = rawBaseline
          .map((e) => BaselineEntry.fromJson(e as Map<String, dynamic>))
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

      // Today's check-in
      hasCheckedInToday.value = todayResponse['has_checked_in_today'] == true;
      final checkin = todayResponse['checkin'];
      if (checkin is Map) {
        sleepValue.value = (checkin['sleep'] as num?)?.toDouble();
        focusValue.value = (checkin['focus'] as num?)?.toDouble();
      }

      // Active experiment: total completed logs + day progress + graph data
      final active = experiments.firstWhereOrNull((e) => e.isActive);
      if (active != null) {
        activeExperiment.value = active;
        totalLogs.value = active.completedLogsCount;
        experimentElapsed.value = active.elapsedDays;
        experimentDuration.value = active.durationDays;
        experimentDayLabel.value =
            'Day ${active.elapsedDays} of ${active.durationDays}';
        // Graph data
        activeExperimentLogs.value = active.logs;
        activeExperimentMetric.value = active.metric;
        activeExperimentStartDate.value = active.startDate;
        activeExperimentDurationDays.value = active.durationDays;
      } else {
        activeExperiment.value = null;
        totalLogs.value = 0;
        experimentElapsed.value = 0;
        experimentDuration.value = 0;
        experimentDayLabel.value = 'No active experiment';
        activeExperimentLogs.clear();
        activeExperimentMetric.value = '';
        activeExperimentStartDate.value = null;
        activeExperimentDurationDays.value = 0;
      }
    } catch (e) {
      print('[Home] Error fetching data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Called after a successful daily check-in so the UI refreshes.
  void onCheckinSubmitted() {
    fetchData();
  }

  String formatMetric(double? value) {
    if (value == null) return '-';
    return value == value.truncateToDouble()
        ? value.toInt().toString()
        : value.toStringAsFixed(1);
  }
}
