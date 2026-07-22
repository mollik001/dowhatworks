import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import '../../onboarding/widgets/custom_button.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class DigitSpanView extends StatelessWidget {
  const DigitSpanView({super.key});

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
              'Game 1 of 3',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'IBM Plex Sans',
                fontWeight: FontWeight.w400,
                fontSize: 14.sp,
                height: 16.5 / 14,
                letterSpacing: 2.64.sp,
                color: const Color(0xFFFF8A5B),
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'Digit Span',
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
              'Working memory capacity',
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
                  _buildStep('1.', 'A sequence of numbers will flash on screen one by one.'),
                  SizedBox(height: 20.h),
                  _buildStep('2.', 'Key in the exact numbers in the correct order.'),
                  SizedBox(height: 20.h),
                  _buildStep('3.', 'The sequence gets longer as you succeed. Two consecutive failures ends this round.'),
                ],
              ),
            ),
            SizedBox(height: 40.h),
            Center(
              child: GestureDetector(
                onTap: () => Get.to(() => const DigitSpanGameView()),
                child: Container(
                  width: 150.w,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF26B3A),
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
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.play_arrow_outlined,
                        size: 26.w,
                        color: Colors.black,
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

class DigitSpanGameView extends StatefulWidget {
  const DigitSpanGameView({super.key});

  @override
  State<DigitSpanGameView> createState() => _DigitSpanGameViewState();
}

class _DigitSpanGameViewState extends State<DigitSpanGameView> {
  static const int maxAttempts = 2;
  int level = 3;
  int attempt = 1;

  List<String> digits = [];
  int currentDigitIndex = 0;
  bool isShowingDigits = true;
  String userAnswer = '';
  Timer? timer;
  final Random random = Random();

  @override
  void initState() {
    super.initState();
    _startLevel();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startLevel() {
    isShowingDigits = true;
    userAnswer = '';
    currentDigitIndex = 0;
    digits = List.generate(level, (_) => random.nextInt(10).toString());
    setState(() {});
    _showNextDigit();
  }

  void _showNextDigit() {
    if (currentDigitIndex < digits.length) {
      setState(() {});
      timer = Timer(const Duration(milliseconds: 1500), () {
        currentDigitIndex++;
        if (!mounted) return;
        if (currentDigitIndex < digits.length) {
          _showNextDigit();
        } else {
          setState(() {
            isShowingDigits = false;
          });
        }
      });
    }
  }

  void _submitAnswer() {
    final correct = userAnswer == digits.join('');
    if (correct) {
      setState(() {
        level++;
        attempt = 1;
      });
      _startLevel();
    } else {
      setState(() {
        attempt++;
      });
      if (attempt > maxAttempts) {
        Get.offAllNamed(AppRoutes.stroopIntro);
      } else {
        _startLevel();
      }
    }
  }

  void _skipTest() {
    Get.offAllNamed(AppRoutes.stroopIntro);
  }

  @override
  Widget build(BuildContext context) {
    final showingDigit = isShowingDigits && currentDigitIndex < digits.length;

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
                    onTap: _skipTest,
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
              if (showingDigit)
                Center(
                  child: Text(
                    digits[currentDigitIndex],
                    style: TextStyle(
                      fontFamily: 'IBM Plex Sans',
                      fontWeight: FontWeight.w400,
                      fontSize: 60.sp,
                      height: 60 / 60,
                      letterSpacing: 20.4.sp,
                      color: Colors.white,
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    Text(
                      'Ready to answer',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'IBM Plex Sans',
                        fontWeight: FontWeight.w400,
                        fontSize: 12.sp,
                        height: 18 / 12,
                        letterSpacing: 0,
                        color: const Color(0xFFFF8A5B),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      'What sequence did you see?',
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
                    SizedBox(height: 16.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400.w),
                      child: TextField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        style: TextStyle(
                          fontFamily: 'IBM Plex Sans',
                          fontWeight: FontWeight.w700,
                          fontSize: 20.sp,
                          height: 39 / 20,
                          letterSpacing: 0,
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Enter Your DIGITS',
                          hintStyle: TextStyle(
                            fontFamily: 'IBM Plex Sans',
                            fontWeight: FontWeight.w700,
                            fontSize: 20.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                          filled: true,
                          fillColor: const Color(0xFF151214),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: const Color(0xFFF26B3A), width: 1.5.w),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: const Color(0xFFF26B3A), width: 1.5.w),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.r),
                            borderSide: BorderSide(color: const Color(0xFFF26B3A), width: 2.w),
                          ),
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                        onChanged: (v) => setState(() => userAnswer = v),
                      ),
                    ),
                    SizedBox(height: 24.h),
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 400.w),
                      child: CustomButton(
                        text: 'Submit Answer',
                        onPressed: _submitAnswer,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
