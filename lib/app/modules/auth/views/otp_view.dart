import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/otp_controller.dart';
import '../widgets/otp_input.dart';
import '../../onboarding/widgets/custom_button.dart';

class OtpView extends GetView<OtpController> {
  const OtpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40.h),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () => Get.back(),
                child: Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                    size: 20.w,
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
            Image.asset(
              'assets/images/logo.png',
              width: 157.w,
              height: 119.h,
            ),
            SizedBox(height: 20.h),
            Text(
              'Check your email',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                fontSize: 20.sp,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              'We sent a code to contact@dscode...com. Enter 6 digit code that mentioned in the email',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.0,
                letterSpacing: 0,
                color: const Color(0xFFD1D1D1),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
              OtpInput(
                controllers: controller.otpControllers,
                focusNodes: controller.otpFocusNodes,
              ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Verify Code',
              onPressed: controller.verifyOtp,
            ),
            SizedBox(height: 16.h),
            GestureDetector(
              onTap: controller.resendEmail,
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFD1D1D1),
                  ),
                  children: [
                    const TextSpan(text: "Haven't got the email yet? "),
                    TextSpan(
                      text: 'Resend email',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.sp,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
