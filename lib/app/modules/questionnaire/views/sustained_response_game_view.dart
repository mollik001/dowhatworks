import 'dart:async';
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
  static const int totalTrials = 30;
  // ~22% X = 7 out of 30
  static const int xTrialCount = 7;
  static const int visibleMs = 700;
  static const int blankMs = 300;

  // Scores passed in from Stroop
  late final int _capacityScore;
  late final int _controlScore;
  late final int _stroopAvgMs;

  // Pre-generated trial sequence: true = X (no-go), false = non-X (go)
  late final List<bool> _trialSequence;

  int _trialIndex = 0;
  bool _trialActive = false;    // letter is currently visible
  bool _tappedThisTrial = false; // prevents double-tap
  bool _gameFinished = false;

  // 4 outcome counters
  int _correctHits = 0;        // non-X, tapped
  int _correctRejections = 0;  // X, not tapped
  int _omissionErrors = 0;     // non-X, not tapped
  int _commissionErrors = 0;   // X, tapped

  String _currentLetter = '';
  Timer? _visibleTimer;
  Timer? _blankTimer;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;
    _capacityScore = (args is Map && args['capacity_score'] is int) ? args['capacity_score'] as int : 3;
    _controlScore  = (args is Map && args['control_score']  is int) ? args['control_score']  as int : 0;
    _stroopAvgMs   = (args is Map && args['stroop_avg_ms']  is int) ? args['stroop_avg_ms']  as int : 0;

    print('[CPT] Started — received capacity_score=$_capacityScore  control_score=$_controlScore');
    _trialSequence = _buildTrialSequence();
    _runNextTrial();
  }

  @override
  void dispose() {
    _visibleTimer?.cancel();
    _blankTimer?.cancel();
    super.dispose();
  }

  /// Build exactly 30 trials: 7 X (no-go) + 23 non-X (go), shuffled.
  List<bool> _buildTrialSequence() {
    final list = <bool>[];
    for (int i = 0; i < xTrialCount; i++) list.add(true);          // X trials
    for (int i = 0; i < totalTrials - xTrialCount; i++) list.add(false); // non-X
    list.shuffle();
    return list;
  }

  /// Pick a random non-X letter (A–Z excluding X).
  String _randomNonXLetter() {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWYZ'; // 25 chars, X excluded
    final idx = DateTime.now().microsecondsSinceEpoch % letters.length;
    return letters[idx];
  }

  void _runNextTrial() {
    if (!mounted || _gameFinished) return;
    if (_trialIndex >= totalTrials) {
      _finishGame();
      return;
    }

    final isXTrial = _trialSequence[_trialIndex];
    _currentLetter = isXTrial ? 'X' : _randomNonXLetter();
    _tappedThisTrial = false;
    _trialActive = true;
    setState(() {});

    // After visible window, evaluate if not already tapped
    _visibleTimer = Timer(const Duration(milliseconds: visibleMs), () {
      if (!mounted || _gameFinished) return;
      _evaluateTrialEnd();
    });
  }

  /// Called when the visible window expires (user didn't tap, or we need to close).
  void _evaluateTrialEnd() {
    if (!mounted || _gameFinished) return;
    _trialActive = false;

    if (!_tappedThisTrial) {
      // No tap — score it
      final isX = _trialSequence[_trialIndex];
      if (isX) {
        _correctRejections++; // X, no tap = correct rejection
      } else {
        _omissionErrors++;    // non-X, no tap = omission error
      }
    }

    setState(() {});

    // Blank interval then next trial
    _blankTimer = Timer(const Duration(milliseconds: blankMs), () {
      if (!mounted || _gameFinished) return;
      _trialIndex++;
      _runNextTrial();
    });
  }

  void _onTap() {
    if (!_trialActive || _tappedThisTrial || _gameFinished) return;
    _tappedThisTrial = true;
    _visibleTimer?.cancel(); // stop the auto-evaluate timer

    final isX = _trialSequence[_trialIndex];
    if (isX) {
      _commissionErrors++; // X, tapped = commission error
    } else {
      _correctHits++;      // non-X, tapped = correct hit
    }

    _trialActive = false;
    setState(() {});

    // Blank interval then next trial
    _blankTimer = Timer(const Duration(milliseconds: blankMs), () {
      if (!mounted || _gameFinished) return;
      _trialIndex++;
      _runNextTrial();
    });
  }

  void _finishGame() {
    if (_gameFinished) return;
    _gameFinished = true;

    final successfulTrials = _correctHits + _correctRejections;
    final enduranceScore = (successfulTrials / totalTrials * 100).round();

    debugPrint('[CPT] correct_hits=$_correctHits  correct_rejections=$_correctRejections'
        '  omissions=$_omissionErrors  commissions=$_commissionErrors'
        '  endurance_score=$enduranceScore');

    Get.offAllNamed(
      AppRoutes.testComplete,
      arguments: {
        'capacity_score': _capacityScore,
        'control_score': _controlScore,
        'stroop_avg_ms': _stroopAvgMs,
        'endurance_score': enduranceScore,
        'cpt_correct_hits': _correctHits,
        'cpt_correct_rejections': _correctRejections,
        'cpt_omission_errors': _omissionErrors,
        'cpt_commission_errors': _commissionErrors,
      },
    );
  }

  void _skipTest() {
    _visibleTimer?.cancel();
    _blankTimer?.cancel();
    _gameFinished = true;

    // Score whatever has been evaluated so far
    final successfulTrials = _correctHits + _correctRejections;
    final enduranceScore = _trialIndex > 0
        ? (successfulTrials / totalTrials * 100).round()
        : 0;

    debugPrint('[CPT] skipped at trial $_trialIndex  endurance_score=$enduranceScore');

    Get.offAllNamed(
      AppRoutes.testComplete,
      arguments: {
        'capacity_score': _capacityScore,
        'control_score': _controlScore,
        'stroop_avg_ms': _stroopAvgMs,
        'endurance_score': enduranceScore,
        'cpt_correct_hits': _correctHits,
        'cpt_correct_rejections': _correctRejections,
        'cpt_omission_errors': _omissionErrors,
        'cpt_commission_errors': _commissionErrors,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusText = 'Tap for All Except "X" · ${_trialIndex + 1} / $totalTrials';

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
                _trialActive ? _currentLetter : '',
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
