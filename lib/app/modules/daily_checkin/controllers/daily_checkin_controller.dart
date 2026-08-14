import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/values/constants.dart';
import '../../../data/services/storage_service.dart';

class DailyCheckinController extends GetxController {
  // Slider values: 1–10 to match API range
  final sleep    = 5.0.obs;
  final exercise = 5.0.obs;
  final focus    = 5.0.obs;
  final energy   = 5.0.obs;
  final mood     = 5.0.obs;
  final stress   = 5.0.obs;
  final social   = 5.0.obs;
  final progress = 5.0.obs;
  final notes    = ''.obs;

  final isLoading = false.obs;

  Future<void> submitCheckIn() async {
    if (isLoading.value) return;

    final token = StorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Session Expired',
        'Please sign in again to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final payload = {
        'sleep':    sleep.value.round(),
        'exercise': exercise.value.round(),
        'focus':    focus.value.round(),
        'energy':   energy.value.round(),
        'mood':     mood.value.round(),
        'stress':   stress.value.round(),
        'social':   social.value.round(),
        'progress': progress.value.round(),
        'notes':    notes.value,
      };

      print('[DailyCheckin] Submitting: $payload');

      final response = await ApiClient.post(
        ApiConstants.dailyCheckin,
        body: payload,
        token: token,
      );

      print('[DailyCheckin] SUCCESS — response: $response');

      Get.back();
    } catch (e) {
      print('[DailyCheckin] ERROR: $e');
      Get.snackbar(
        'Submission Failed',
        _friendlyError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('No internet')) return 'No internet connection. Please check your network and try again.';
    if (raw.contains('401') || raw.contains('Unauthorized')) return 'Your session has expired. Please sign in again.';
    if (raw.contains('500') || raw.contains('502') || raw.contains('503')) return 'The server is having trouble. Please try again in a moment.';
    return 'Something went wrong. Please try again.';
  }
}
