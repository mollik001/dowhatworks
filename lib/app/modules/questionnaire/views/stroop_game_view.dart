import 'dart:async';
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
  static const int totalTrials = 15;

  static const List<Color> gameColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];
  static const List<String> colorNames = ['RED', 'BLUE', 'GREEN', 'YELLOW'];

  // --- Pre-generated balanced trial list ---
  // Each trial: { wordIndex, inkIndex }
  late final List<Map<String, int>> _trials;

  int _trialIndex = 0;
  bool _answered = false;

  // Scoring
  int _correctCount = 0;
  int _totalCorrectResponseMs = 0;
  DateTime? _trialStartTime;

  // capacity_score passed in from Digit Span
  late final int _capacityScore;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _capacityScore = (args is Map && args['capacity_score'] is int)
        ? args['capacity_score'] as int
        : 3;

    print('[Stroop] Started — received capacity_score=$_capacityScore');
    _trials = _buildBalancedTrials();
    _trialStartTime = DateTime.now();
  }

  /// Build 15 trials: ~7-8 congruent, ~7-8 incongruent, then shuffle.
  List<Map<String, int>> _buildBalancedTrials() {
    final list = <Map<String, int>>[];
    // 8 congruent (word index == ink index)
    for (int i = 0; i < 8; i++) {
      final idx = i % colorNames.length;
      list.add({'word': idx, 'ink': idx});
    }
    // 7 incongruent (word index != ink index)
    for (int i = 0; i < 7; i++) {
      final wordIdx = i % colorNames.length;
      final inkIdx = (wordIdx + 1 + (i ~/ colorNames.length)) % colorNames.length;
      list.add({'word': wordIdx, 'ink': inkIdx});
    }
    list.shuffle();
    return list;
  }

  void _onOptionTapped(int tappedIndex) {
    if (_answered) return; // block multiple taps per trial
    _answered = true;

    final trial = _trials[_trialIndex];
    final correctIndex = trial['ink']!;
    final isCorrect = tappedIndex == correctIndex;

    // Local counters updated before navigating (avoids async state issues)
    final updatedCorrect = _correctCount + (isCorrect ? 1 : 0);
    int updatedResponseMs = _totalCorrectResponseMs;
    if (isCorrect && _trialStartTime != null) {
      updatedResponseMs += DateTime.now().difference(_trialStartTime!).inMilliseconds;
    }

    final nextTrial = _trialIndex + 1;

    if (nextTrial >= totalTrials) {
      // Final trial — compute score from local values
      final controlScore = (updatedCorrect / totalTrials * 100).round();
      final avgResponseMs = updatedCorrect > 0
          ? (updatedResponseMs / updatedCorrect).round()
          : 0;

      debugPrint('[Stroop] correct=$updatedCorrect/15  control_score=$controlScore  avg_response_ms=$avgResponseMs');

      Get.offAllNamed(
        AppRoutes.sustainedResponseIntro,
        arguments: {
          'capacity_score': _capacityScore,
          'control_score': controlScore,
          'stroop_avg_ms': avgResponseMs,
        },
      );
    } else {
      setState(() {
        _correctCount = updatedCorrect;
        _totalCorrectResponseMs = updatedResponseMs;
        _trialIndex = nextTrial;
        _answered = false;
        _trialStartTime = DateTime.now();
      });
    }
  }

  void _skipTest() {
    // Skip with 0 correct for this game but preserve capacity_score
    debugPrint('[Stroop] skipped — control_score=0');
    Get.offAllNamed(
      AppRoutes.sustainedResponseIntro,
      arguments: {
        'capacity_score': _capacityScore,
        'control_score': 0,
        'stroop_avg_ms': 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final trial = _trials[_trialIndex];
    final currentWord = colorNames[trial['word']!];
    final inkColor = gameColors[trial['ink']!];

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
                  'Trial ${_trialIndex + 1} of $totalTrials',
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
