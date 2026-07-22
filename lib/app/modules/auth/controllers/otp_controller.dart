import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';

class OtpController extends GetxController {
  final otpControllers = List.generate(6, (_) => TextEditingController());
  final otpFocusNodes = List.generate(6, (_) => FocusNode());

  void verifyOtp() {
    final otp = otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      Get.defaultDialog(
        title: '',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60.sp),
            SizedBox(height: 16.h),
            Text(
              'Verification Successful',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                fontSize: 18.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your account has been verified',
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
            Get.offAllNamed(AppRoutes.questionnaire);
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
    } else {
      Get.snackbar(
        'Error',
        'Please enter the complete 6-digit code',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
