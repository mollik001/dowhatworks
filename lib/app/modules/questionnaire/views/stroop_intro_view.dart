import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class StroopIntroView extends StatelessWidget {
  const StroopIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            SizedBox(height: 100.h),
            Text(
              'Game 2 of 3',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 16.5 / 14,
                letterSpacing: 2.64.sp,
                color: const Color(0xFFC4B5FD),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Stroop color',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 29.sp,
                height: 1.0,
                letterSpacing: -0.73.sp,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'Cognitive control',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 1.0,
                letterSpacing: 0,
                color: Colors.white.withValues(alpha: 0.45),
              ),
            ),
            SizedBox(height: 36.h),
            Container(
              constraints: BoxConstraints(maxWidth: 400.w),
              decoration: BoxDecoration(
                color: const Color(0xFF101010),
                border: Border.all(color: const Color(0xFF232323)),
                borderRadius: BorderRadius.circular(22.r),
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildStep('1.', 'A color word will flash on screen (for example, "RED").'),
                  SizedBox(height: 20.h),
                  _buildStep('2.', 'Tap the button corresponding to the font ink color, not the text itself.'),
                  SizedBox(height: 20.h),
                  _buildStep('3.', 'Speed and accuracy both factor into your final score.'),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.stroopGame),
                child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Start game',
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w600,
                          fontSize: 16.sp,
                          height: 20.63 / 16,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.play_arrow_outlined,
                        size: 26.w,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          number,
          style: TextStyle(
            fontFamily: 'IBM Plex Sans',
            fontWeight: FontWeight.w400,
            fontSize: 14.sp,
            height: 1.0,
            letterSpacing: 0,
            color: Colors.white,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'IBM Plex Sans',
              fontWeight: FontWeight.w400,
              fontSize: 14.sp,
              height: 1.0,
              letterSpacing: 0,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ),
      ],
    );
  }
}
