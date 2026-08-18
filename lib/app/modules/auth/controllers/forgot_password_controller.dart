import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final isLoading = false.obs;

  Future<void> submitForgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      await _authRepository.forgotPassword(email: email);
      _showEmailSentDialog(email);
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showEmailSentDialog(String email) {
    Get.dialog(
      Dialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
          side: const BorderSide(color: Color(0xFF3A3A3A)),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Mail icon
              Container(
                width: 56.w,
                height: 56.w,
                decoration: BoxDecoration(
                  color: const Color(0xFF0A0A0A),
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF3A3A3A)),
                ),
                child: Center(
                  child: Image.asset(
                    'assets/icons/mini_mail.png',
                    width: 24.w,
                    height: 24.w,
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Check your email',
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                  fontSize: 18.sp,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 13.sp,
                    height: 1.5,
                    color: const Color(0xFFD1D1D1),
                  ),
                  children: [
                    const TextSpan(
                      text: 'If an account exists for ',
                    ),
                    TextSpan(
                      text: email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ', you will receive a password reset link shortly.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              SizedBox(
                width: double.infinity,
                height: 44.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back(); // close dialog
                    Get.offNamed(AppRoutes.authSignin);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'Back to Sign In',
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w900,
                      fontSize: 14.sp,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
