import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../../routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final token = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments is Map && Get.arguments.containsKey('token')) {
      token.value = Get.arguments['token'] ?? '';
    }
  }

  Future<void> updatePassword() async {
    final password = newPasswordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar(
        'Validation Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final tokenToUse = token.value.isNotEmpty
        ? token.value
        : (StorageService.getAccessToken() ?? '');

    try {
      isLoading.value = true;
      await _authRepository.resetPassword(
        token: tokenToUse,
        password: password,
        confirmPassword: confirmPassword,
      );

      Get.offAllNamed(AppRoutes.authSignin);
    } catch (e) {
      Get.snackbar(
        'Password Reset Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
