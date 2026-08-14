import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/experiment_models.dart';
import '../../../data/repositories/experiment_repository.dart';
import '../../results/controllers/results_controller.dart';
import '../../../routes/app_routes.dart';

class LabController extends GetxController {
  final _repo = ExperimentRepository();

  final templates = <ExperimentTemplate>[].obs;
  final isLoadingTemplates = false.obs;

  // Tracks which template id is currently being launched
  final launchingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadTemplates();
  }

  Future<void> loadTemplates() async {
    isLoadingTemplates.value = true;
    try {
      final result = await _repo.getTemplates();
      templates.value = result;
      print('[Lab] Loaded ${result.length} templates');
    } catch (e) {
      print('[Lab] loadTemplates ERROR: $e');
    } finally {
      isLoadingTemplates.value = false;
    }
  }

  Future<void> launchTemplate(ExperimentTemplate template) async {
    if (launchingId.value.isNotEmpty) return;

    launchingId.value = template.id;
    try {
      // Derive metric label: first metric label, or template title as fallback
      final metric = template.metrics.isNotEmpty
          ? template.metrics.first.label
          : template.title;

      final experiment = await _repo.createExperiment(
        hypothesis: template.hypothesis,
        action: template.action,
        metric: metric,
        durationDays: template.durationDays,
      );

      print('[Lab] Launched experiment id=${experiment.id}');

      // Refresh results list if controller is already in memory
      if (Get.isRegistered<ResultsController>()) {
        Get.find<ResultsController>().loadExperiments();
      }

      Get.snackbar(
        '✓ Launched',
        'Experiment started! Track it in Results.',
        backgroundColor: const Color(0xFF0C1612),
        colorText: const Color(0xFF6EE7B7),
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );

      Get.offNamed(AppRoutes.results);
    } catch (e) {
      print('[Lab] launchTemplate ERROR: $e');
      Get.snackbar(
        'Error',
        'Could not launch experiment. Please try again.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      launchingId.value = '';
    }
  }
}
