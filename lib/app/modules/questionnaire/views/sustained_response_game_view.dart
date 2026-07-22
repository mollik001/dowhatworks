import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SustainedResponseGameView extends StatefulWidget {
  const SustainedResponseGameView({super.key});

  @override
  State<SustainedResponseGameView> createState() => _SustainedResponseGameViewState();
}

class _SustainedResponseGameViewState extends State<SustainedResponseGameView> {
  static const int totalRounds = 7;
  static const int maxAttempts = 2;
  int level = 1;
  int attempt = 1;
  int currentRound = 1;

  String currentLetter = '';
  bool waitingForTap = false;
  bool roundActive = false;
  Timer? roundTimer;

  final Random random = Random();
  final List<String> alphabet = List.generate(26, (i) => String.fromCharCode(65 + i));

  @override
  void initState() {
    super.initState();
    _nextRound();
  }

  @override
  void dispose() {
    roundTimer?.cancel();
    super.dispose();
  }

  void _nextRound() {
    if (currentRound > totalRounds) {
      Get.offAllNamed(AppRoutes.testComplete);
      return;
    }

    waitingForTap = false;
    roundActive = true;
    currentLetter = alphabet[random.nextInt(26)];

    setState(() {});

    Future.delayed(const Duration(milliseconds: 1200), () {
      if (!mounted || !roundActive) return;
      waitingForTap = true;
      setState(() {});

      Future.delayed(const Duration(milliseconds: 1500), () {
        if (!mounted || !roundActive) return;
        if (waitingForTap) {
          roundActive = false;
          waitingForTap = false;
          setState(() {});

          Future.delayed(const Duration(milliseconds: 600), () {
            if (!mounted) return;
            if (currentLetter == 'X') {
              setState(() {
                currentRound++;
              });
              _nextRound();
            } else {
              setState(() {
                attempt++;
              });
              if (attempt > maxAttempts) {
                Get.offAllNamed(AppRoutes.testComplete);
              } else {
                Future.delayed(const Duration(milliseconds: 600), () {
                  if (mounted && roundActive == false) {
                    _nextRound();
                  }
                });
              }
            }
          });
        }
      });
    });
  }

  void _onTap() {
    if (!roundActive || !waitingForTap) return;

    final wasX = currentLetter == 'X';
    roundActive = false;
    waitingForTap = false;
    setState(() {});

    if (wasX) {
      setState(() {
        attempt++;
      });
      if (attempt > maxAttempts) {
        Get.offAllNamed(AppRoutes.testComplete);
      } else {
        Future.delayed(const Duration(milliseconds: 600), () {
          if (mounted) _nextRound();
        });
      }
    } else {
      setState(() {
        currentRound++;
      });
      _nextRound();
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusText = 'Tap for All Except "X" · $currentRound / $totalRounds';

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
                      'Cognitive baseline test...',
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 16.sp,
                        height: 16.5 / 16,
                        letterSpacing: 0,
                        color: const Color(0xFFFF8A5B),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.offAllNamed(AppRoutes.testComplete),
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
              SizedBox(height: 24.h),
              Text(
                statusText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 14.sp,
                  height: 16.5 / 14,
                  letterSpacing: 0,
                  color: const Color(0xFFFCD34D),
                ),
              ),
              SizedBox(height: 32.h),
              Text(
                currentLetter,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 94.sp,
                  height: 141 / 94,
                  letterSpacing: 0,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Tap the button when a letter appears.',
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
              SizedBox(height: 32.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: GestureDetector(
                  onTap: _onTap,
                  child: Container(
                    width: double.infinity,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF26B3A),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Tap Screens',
                          style: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w600,
                            fontSize: 16.sp,
                            height: 20.63 / 16,
                            letterSpacing: 0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Tapping anywhere inside this card works.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'IBM Plex Sans',
                  fontWeight: FontWeight.w400,
                  fontSize: 11.sp,
                  height: 16.5 / 11,
                  letterSpacing: 0,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
