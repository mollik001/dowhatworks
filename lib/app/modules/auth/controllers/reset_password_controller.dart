import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void updatePassword() {
    if (newPasswordController.text.isEmpty || confirmPasswordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    Get.defaultDialog(
      title: '',
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
          SizedBox(height: 16.h),
          Text(
            'Password Updated',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w700,
              fontSize: 18.sp,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your password has been reset successfully',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              color: const Color(0xFFD1D1D1),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      confirm: TextButton(
        onPressed: () {
          Get.back();
          Get.offAllNamed(AppRoutes.authSignin);
        },
        child: Text(
          'Continue',
          style: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xFF1A1A1A),
      radius: 16.r,
    );
  }

  @override
  void onClose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
