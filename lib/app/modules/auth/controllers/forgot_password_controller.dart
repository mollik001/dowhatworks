import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final emailController = TextEditingController();

  void resetPassword() {
    Get.toNamed(AppRoutes.authOtp, arguments: {'nextRoute': AppRoutes.authResetPassword});
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
