import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/experiment_models.dart';
import '../../../data/repositories/experiment_repository.dart';

class ResultsController extends GetxController {
  final _repo = ExperimentRepository();

  final experiments = <Experiment>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadExperiments();
  }

  Future<void> loadExperiments() async {
    isLoading.value = true;
    try {
      final result = await _repo.getExperiments();
      // Active first, then queued, then others
      result.sort((a, b) {
        if (a.isActive && !b.isActive) return -1;
        if (!a.isActive && b.isActive) return 1;
        return 0;
      });
      experiments.value = result;
      print('[Results] Loaded ${result.length} experiments');
    } catch (e) {
      print('[Results] loadExperiments ERROR: $e');
      Get.snackbar(
        'Error',
        'Could not load experiments.',
        backgroundColor: const Color(0xFF1A1A1A),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
