import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../data/services/user_service.dart';
import '../../../routes/app_routes.dart';

class OtpController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  final isLoading = false.obs;
  final email = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map) {
      final map = Get.arguments as Map;
      email.value = map['email'] ?? '';
    }
  }

  Future<void> verifyOtp() async {
    final otpString = otpControllers.map((c) => c.text).join();
    if (otpString.length != 6) {
      Get.snackbar(
        'Error',
        'Please enter the complete 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      final dynamic otpCode = int.tryParse(otpString) ?? otpString;

      final response = await _authRepository.verifyOtp(
        email: email.value.isNotEmpty ? email.value : '',
        otpCode: otpCode,
      );

      // OTP is only used for signup verification
      final userMap = response['user'] as Map<String, dynamic>? ??
          (response['data'] is Map
              ? (response['data']['user'] as Map<String, dynamic>?)
              : null);

      final bool hasCompletedOnboarding =
          (userMap?['has_completed_onboarding'] == true) ||
              (response['has_completed_onboarding'] == true) ||
              StorageService.getHasCompletedOnboarding();

      if (hasCompletedOnboarding) {
        unawaited(UserService.to.fetchProfile());
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.questionnaire);
      }
    } catch (e) {
      Get.snackbar(
        'Verification Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendEmail() {
    Get.snackbar(
      'Email Sent',
      'Verification code has been resent to your email',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  void onClose() {
    for (final controller in otpControllers) {
      controller.dispose();
    }
    for (final node in otpFocusNodes) {
      node.dispose();
    }
    super.onClose();
  }
}
