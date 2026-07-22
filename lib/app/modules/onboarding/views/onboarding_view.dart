import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/onboarding_controller.dart';
import '../widgets/custom_button.dart';
import '../widgets/page_indicator.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller.pageController,
        onPageChanged: controller.onPageChanged,
        children: [
          _buildOnboardingPage(
            bgImage: 'assets/images/onboarding_1.png',
            buttonText: 'See How It Works',
            showBack: false,
          ),
          _buildOnboardingPage(
            bgImage: 'assets/images/onboarding_2.png',
            buttonText: 'Meet Your Toolkit',
            showBack: true,
          ),
          _buildOnboardingPage(
            bgImage: 'assets/images/onboarding_3.png',
            buttonText: 'One More Thing',
            showBack: true,
          ),
          _buildOnboardingPage(
            bgImage: 'assets/images/onboarding_4.png',
            buttonText: 'Start My Baseline',
            showBack: true,
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTopRow() {
    return Row(
      children: [
        Image.asset(
          'assets/images/mini_logo.png',
          width: 60.w,
          height: 60.w,
        ),
        Expanded(
          child: Transform.translate(
            offset: Offset(0, -1.5.h),
            child: Text(
              'Do What Works',
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
                fontSize: 16.sp,
                height: 22.5 / 16,
                letterSpacing: -0.38,
                color: Colors.white,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        GestureDetector(
          onTap: controller.skip,
          child: Text(
            'Skip',
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w700,
              fontSize: 14.sp,
              height: 19.5 / 14,
              letterSpacing: 0,
              color: const Color(0xFF949596),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOnboardingPage({
    required String bgImage,
    required String buttonText,
    required bool showBack,
    bool isLast = false,
  }) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            bgImage,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: EdgeInsets.fromLTRB(24.w, 40.h, 24.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopRow(),
              SizedBox(height: 16.h),
              Obx(
                () => PageIndicator(
                  currentPage: controller.currentPage.value,
                  totalPages: 4,
                ),
              ),
              const Spacer(),
              CustomButton(
                text: buttonText,
                onPressed: isLast ? controller.skip : controller.nextPage,
              ),
              if (showBack) ...[
                SizedBox(height: 16.h),
                Center(
                  child: GestureDetector(
                    onTap: controller.previousPage,
                    child: Text(
                      'Back',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w700,
                        fontSize: 14.sp,
                        height: 19.5 / 14,
                        letterSpacing: 0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: 70.h),
            ],
          ),
        ),
      ],
    );
  }
}
