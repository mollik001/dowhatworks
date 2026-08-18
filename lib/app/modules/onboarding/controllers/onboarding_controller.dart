import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/data/services/storage_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';

class OnboardingController extends GetxController {
  final currentPage = 0.obs;
  final PageController pageController = PageController();

  void onPageChanged(int index) {
    currentPage.value = index;
  }

  void nextPage() {
    if (currentPage.value < 3) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _finishOnboarding();
    }
  }

  void previousPage() {
    if (currentPage.value > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void skip() {
    _finishOnboarding();
  }

  void _finishOnboarding() {
    final isFirstTime = !StorageService.getHasSeenOnboarding();
    StorageService.setHasSeenOnboarding();

    if (isFirstTime) {
      Get.offAllNamed(AppRoutes.authSignup);
    } else {
      Get.offAllNamed(AppRoutes.authSignin);
    }
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }
}
