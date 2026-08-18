import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/experiment_models.dart';
import '../../../data/repositories/experiment_repository.dart';
import '../../home/controllers/home_controller.dart';
import '../../results/controllers/results_controller.dart';

class ExperimentDetailController extends GetxController {
  final _repo = ExperimentRepository();

  final detail = Rxn<ExperimentDetail>();
  final isLoading = false.obs;

  // ── Log Today form state ──────────────────────────────────────────────────
  final logMetricValue = 5.0.obs;
  final logNotes = ''.obs;
  final logObservation = ''.obs;
  final isSubmittingLog = false.obs;

  @override
  void onInit() {
    super.onInit();
    final id = Get.arguments as int?;
    if (id != null) {
      fetchDetail(id);
    } else {
      print('[ExperimentDetail] No experiment id passed as argument');
    }
  }

  Future<void> fetchDetail(int id) async {
    isLoading.value = true;
    try {
      final result = await _repo.getExperimentDetail(id);
      detail.value = result;
      print('[ExperimentDetail] Loaded id=${result.id} logs=${result.logs.length}');
    } catch (e) {
      print('[ExperimentDetail] fetchDetail ERROR: $e');
      Get.snackbar(
        'Error',
        'Could not load experiment details.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Returns today's log entry (the one with today's date), or the first
  /// pending log if no exact date match, or null if all are done.
  ExperimentLog? get todayLog {
    final d = detail.value;
    if (d == null || d.logs.isEmpty) return null;

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Prefer exact date match
    try {
      return d.logs.firstWhere((l) => l.date == todayStr);
    } catch (_) {}

    // Fall back to first pending log
    try {
      return d.logs.firstWhere((l) => l.completed == 'pending');
    } catch (_) {}

    return null;
  }

  /// Whether today has already been logged.
  bool get todayAlreadyLogged {
    final d = detail.value;
    if (d == null) return false;
    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
    return d.logs.any((l) => l.date == todayStr && l.completed != 'pending');
  }

  Future<void> deleteExperiment() async {
    final d = detail.value;
    if (d == null) return;

    final confirmed = await Get.dialog<bool>(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delete experiment?',
          style: TextStyle(
              color: Colors.white,
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 16),
        ),
        content: const Text(
          'This will permanently delete the experiment and all its logs.',
          style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontFamily: 'IBM Plex Sans',
              fontSize: 13,
              height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: const Text('Cancel',
                style: TextStyle(
                    color: Color(0xFF9CA3AF), fontFamily: 'IBM Plex Sans')),
          ),
          TextButton(
            onPressed: () => Get.back(result: true),
            child: const Text('Delete',
                style: TextStyle(
                    color: Color(0xFFF87171), fontFamily: 'IBM Plex Sans')),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    try {
      await _repo.deleteExperiment(d.id);
      Get.back(); // pop detail page
      // Reload results list
      if (Get.isRegistered<ResultsController>()) {
        Get.find<ResultsController>().loadExperiments();
      }
      Get.snackbar(
        'Deleted',
        'Experiment removed.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('[ExperimentDetail] deleteExperiment ERROR: $e');
      Get.snackbar(
        'Error',
        'Could not delete experiment. Please try again.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void resetLogForm() {
    logMetricValue.value = 5.0;
    logNotes.value = '';
    logObservation.value = '';
  }

  Future<void> submitLog() async {
    if (isSubmittingLog.value) return;

    final d = detail.value;
    if (d == null) return;

    isSubmittingLog.value = true;
    try {
      final newLog = await _repo.logExperiment(
        experimentId: d.id,
        metricValue: logMetricValue.value,
        notes: logNotes.value.trim(),
        dailyObservation: logObservation.value.trim(),
        completed: 'yes',
      );

      // Append the new log and refresh detail in-memory
      final updatedLogs = List<ExperimentLog>.from(d.logs)..add(newLog);

      detail.value = ExperimentDetail(
        id: d.id,
        hypothesis: d.hypothesis,
        action: d.action,
        metric: d.metric,
        durationDays: d.durationDays,
        status: d.status,
        startDate: d.startDate,
        logs: updatedLogs,
        aiAnalysis: d.aiAnalysis,
        createdAt: d.createdAt,
      );

      // Refresh results list and home stats
      if (Get.isRegistered<ResultsController>()) {
        Get.find<ResultsController>().loadExperiments();
      }
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchData();
      }

      Get.back(); // close the bottom sheet
      Get.snackbar(
        '✓ Logged',
        'Your entry for today has been saved.',
        backgroundColor: const Color(0xFF0C1612),
        colorText: const Color(0xFF6EE7B7),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      print('[ExperimentDetail] submitLog ERROR: $e');
      Get.snackbar(
        'Error',
        'Could not save your log. Please try again.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSubmittingLog.value = false;
    }
  }
}
