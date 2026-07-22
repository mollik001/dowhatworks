import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../onboarding/widgets/custom_button.dart';

class TestCompleteView extends StatelessWidget {
  const TestCompleteView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              SizedBox(height: 60.h),
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        width: 70.w,
                        height: 70.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            center: Alignment.center,
                            radius: 1.2,
                            colors: [
                              const Color(0xFF1B5A42).withValues(alpha: 0.18),
                              const Color(0xFF1B5A42).withValues(alpha: 0.0),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26.r),
                        color: const Color(0xFF122F24),
                        border: Border.all(color: const Color(0xFF1B5A42), width: 1.5.w),
                      ),
                      child: Icon(
                        Icons.check,
                        size: 36.w,
                        color: const Color(0xFF1B5A42),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Baseline complete',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 16.5 / 14,
                  letterSpacing: 2.2.sp,
                  color: const Color(0xFF6EE7B7),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Test completed',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 30.sp,
                  height: 45 / 30,
                  letterSpacing: -0.75.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Your cognitive baseline and belief profile are ready to calibrate Daniel\'s strategy.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 1.0,
                  letterSpacing: 0,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              SizedBox(height: 32.h),
              Row(
                children: [
                  Expanded(
                    child: _buildStatBox(
                      top: 'Memory\ncapacity',
                      middle: '5',
                      bottom: 'digits',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatBox(
                      top: 'Cognitive\ncontrol',
                      middle: '60%',
                      bottom: 'response',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatBox(
                      top: 'Focus\nendurance',
                      middle: '57%',
                      bottom: 'accuracy',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: CustomButton(
                  text: 'Save & Sync Profile',
                  onPressed: () {},
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Discard and retake',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 18 / 14,
                  letterSpacing: 0,
                  color: Colors.white.withValues(alpha: 0.4),
                ),
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatBox({
    required String top,
    required String middle,
    required String bottom,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      padding: EdgeInsets.all(12.w),
      child: Column(
        children: [
          Text(
            top,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 10.sp,
              height: 1.5,
              letterSpacing: 0.9.sp,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            middle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 24.sp,
              height: 32 / 24,
              letterSpacing: 0,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            bottom,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 11.sp,
              height: 1.5,
              letterSpacing: 0,
              color: Colors.white.withValues(alpha: 0.35),
            ),
          ),
        ],
      ),
    );
  }
}
