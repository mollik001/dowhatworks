import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/experiment_models.dart';
import '../../../data/repositories/experiment_repository.dart';
import '../../../routes/app_routes.dart';

class CustomProtocolController extends GetxController {
  final _repo = ExperimentRepository();

  final selectedStep = 0.obs;
  final hypothesisController = TextEditingController();
  final selectedMetric = ''.obs;
  final actionController = TextEditingController();
  final duration = '7 days'.obs;

  final isLaunching = false.obs;

  final hypothesisError = ''.obs;
  final actionError = ''.obs;
  final metricError = ''.obs;

  void selectMetric(String metric) {
    selectedMetric.value = metric;
    metricError.value = '';
  }

  void setDuration(String value) {
    duration.value = value;
  }

  /// Validates the current step field and navigates if valid.
  bool validateAndNext({required String field, required String route}) {
    if (field == 'hypothesis') {
      if (hypothesisController.text.trim().isEmpty) {
        hypothesisError.value = 'Please enter your hypothesis.';
        return false;
      }
      hypothesisError.value = '';
    } else if (field == 'action') {
      if (actionController.text.trim().isEmpty) {
        actionError.value = 'Please describe the action.';
        return false;
      }
      actionError.value = '';
    } else if (field == 'metric') {
      if (selectedMetric.value.trim().isEmpty) {
        metricError.value = 'Please select or enter a metric.';
        return false;
      }
      metricError.value = '';
    }
    Get.toNamed(route);
    return true;
  }

  @override
  void onInit() {
    super.onInit();
    _prefillFromArguments();
  }

  /// Pre-fills fields from Get.arguments.
  /// Accepts either an ExperimentTemplate (from Lab) or a Map<String,dynamic>
  /// (from Daniel's proposal_data).
  void _prefillFromArguments() {
    final args = Get.arguments;
    if (args == null) return;

    if (args is ExperimentTemplate) {
      hypothesisController.text = args.hypothesis;
      actionController.text = args.action;
      duration.value = '${args.durationDays} days';
      if (args.metrics.isNotEmpty) {
        selectedMetric.value = args.metrics.first.label;
      }
    } else if (args is Map<String, dynamic>) {
      // Daniel proposal_data keys: hypothesis, action, metric, duration
      if ((args['hypothesis'] as String?)?.isNotEmpty == true) {
        hypothesisController.text = args['hypothesis'] as String;
      }
      if ((args['action'] as String?)?.isNotEmpty == true) {
        actionController.text = args['action'] as String;
      }
      if ((args['metric'] as String?)?.isNotEmpty == true) {
        selectedMetric.value = args['metric'] as String;
      }
      if ((args['duration'] as String?)?.isNotEmpty == true) {
        final raw = args['duration'] as String;
        // Normalise "7" → "7 days"
        duration.value = raw.contains('day') ? raw : '$raw days';
      }
    }
  }

  void reset() {
    selectedStep.value = 0;
    hypothesisController.text = '';
    selectedMetric.value = '';
    actionController.text = '';
    duration.value = '7 days';
    hypothesisError.value = '';
    actionError.value = '';
    metricError.value = '';
  }

  /// Parses "7 days" → 7, "14 days" → 14, etc.
  int get _durationDays {
    final raw = duration.value.trim();
    final match = RegExp(r'(\d+)').firstMatch(raw);
    return match != null ? int.parse(match.group(1)!) : 7;
  }

  /// Returns selected metric, fallback to 'Sleep quality'.
  String get _metricString =>
      selectedMetric.value.isNotEmpty ? selectedMetric.value : 'Sleep quality';

  Future<void> launchExperiment() async {
    final hypothesis = hypothesisController.text.trim();
    final action = actionController.text.trim();

    if (hypothesis.isEmpty || action.isEmpty) {
      Get.snackbar(
        'Missing fields',
        'Please fill in hypothesis and action before launching.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLaunching.value = true;
    try {
      final experiment = await _repo.createExperiment(
        hypothesis: hypothesis,
        action: action,
        metric: _metricString,
        durationDays: _durationDays,
      );
      print('[CustomProtocol] Experiment created: id=${experiment.id}');

      Get.offAllNamed(AppRoutes.lab);
      reset();

      Get.snackbar(
        'Experiment launched! 🚀',
        'Your experiment has been created successfully.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print('[CustomProtocol] launchExperiment ERROR: $e');
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLaunching.value = false;
    }
  }
}
