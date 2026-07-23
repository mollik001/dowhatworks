import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class StroopGameView extends StatefulWidget {
  const StroopGameView({super.key});

  @override
  State<StroopGameView> createState() => _StroopGameViewState();
}

class _StroopGameViewState extends State<StroopGameView> {
  static const int maxAttempts = 2;
  int level = 1;
  int attempt = 1;

  static const List<Color> gameColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  static const List<String> colorNames = ['RED', 'BLUE', 'GREEN', 'YELLOW'];

  late String currentWord;
  late Color inkColor;
  late int correctIndex;
  Timer? timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _nextRound() {
    final wordIndex = random.nextInt(colorNames.length);
    final inkIndex = random.nextInt(gameColors.length);
    currentWord = colorNames[wordIndex];
    inkColor = gameColors[inkIndex];
    correctIndex = inkIndex;
    setState(() {});
  }

  void _onOptionTapped(int index) {
    if (index == correctIndex) {
      setState(() {
        level++;
        attempt = 1;
      });
      _nextRound();
    } else {
      setState(() {
        attempt++;
      });
      if (attempt > maxAttempts) {
        Get.offAllNamed(AppRoutes.sustainedResponseIntro);
      } else {
        _nextRound();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/icons/brain.png',
                    width: 32.w,
                    height: 32.h,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      'Cognitive baseline test',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 1.25,
                        letterSpacing: 0,
                        color: const Color(0xFFFF8A5B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAllNamed(AppRoutes.sustainedResponseIntro),
                    child: Row(
                      children: [
                        Text(
                          'Skip Test',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.sp,
                            height: 1.0,
                            letterSpacing: 0,
                            color: Colors.white.withValues(alpha: 0.45),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Icon(
                          Icons.close,
                          size: 20.w,
                          color: Colors.white.withValues(alpha: 0.45),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Center(
                child: Text(
                  'Level $level · Attempt $attempt of $maxAttempts',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'IBM Plex Sans',
                    fontWeight: FontWeight.w400,
                    fontSize: 11.sp,
                    height: 16.5 / 11,
                    letterSpacing: 2.2.sp,
                    color: const Color(0xFFFF8A5B),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              Text(
                currentWord,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 48.sp,
                  height: 72 / 48,
                  letterSpacing: -1.2.sp,
                  color: inkColor,
                ),
              ),
              SizedBox(height: 40.h),
              Column(
                children: List.generate(2, (row) {
                  return Row(
                    children: List.generate(2, (col) {
                      final index = row * 2 + col;
                      final color = gameColors[index];
                      final name = colorNames[index];
                      return Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 6.h),
                          child: GestureDetector(
                            onTap: () => _onOptionTapped(index),
                            child: Container(
                              height: 70.h,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.03),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.09),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    width: 14.w,
                                    height: 14.h,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: 'IBM Plex Sans',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 16.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
