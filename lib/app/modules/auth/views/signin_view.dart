import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';
import '../controllers/signup_controller.dart';
import '../widgets/custom_text_field.dart';
import '../../onboarding/widgets/custom_button.dart';

class SigninView extends GetView<SignupController> {
  const SigninView({super.key});

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
              'Login to Account',
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
              'Please enter your email and password to continue',
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
            CustomTextField(
              hintText: 'Enter Email Address',
              iconPath: 'assets/icons/mini_mail.png',
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16.h),
            CustomTextField(
              hintText: 'Enter Password',
              iconPath: 'assets/icons/mini_lock.png',
              controller: controller.passwordController,
              isPassword: true,
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () => Get.toNamed(AppRoutes.authForgotPassword),
                        child: Text(
                  'Forget Password?',
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    height: 1.0,
                    letterSpacing: 0,
                    color: const Color(0xFFD1D1D1),
                  ),
                  textAlign: TextAlign.right,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Sign In',
              onPressed: () {},
            ),
            SizedBox(height: 16.h),
            CustomButton(
              text: 'Sign Up',
              onPressed: () => Get.toNamed(AppRoutes.authSignup),
            ),
            SizedBox(height: 70.h),
          ],
        ),
      ),
    );
  }
}
