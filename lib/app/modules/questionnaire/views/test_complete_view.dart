import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../data/repositories/auth_repository.dart';
import '../../../data/services/storage_service.dart';
import '../../onboarding/widgets/custom_button.dart';
import '../../../routes/app_routes.dart';

class TestCompleteView extends StatefulWidget {
  const TestCompleteView({super.key});

  @override
  State<TestCompleteView> createState() => _TestCompleteViewState();
}

class _TestCompleteViewState extends State<TestCompleteView> {
  final AuthRepository _authRepository = AuthRepository();
  bool _isSaving = false;

  // Scores received from CPT via Get.arguments
  late final int _capacityScore;
  late final int _controlScore;
  late final int _enduranceScore;
  late final int _attentionScore;

  @override
  void initState() {
    super.initState();
    final args = Get.arguments;

    _capacityScore  = (args is Map && args['capacity_score']  is int) ? args['capacity_score']  as int : 3;
    _controlScore   = (args is Map && args['control_score']   is int) ? args['control_score']   as int : 0;
    _enduranceScore = (args is Map && args['endurance_score'] is int) ? args['endurance_score'] as int : 0;

    // Composite: capacity_percent = min(100, round(capacity_score / 9 * 100))
    // attention_score = round((capacity_percent + control_score + endurance_score) / 3)
    final capacityPercent = ((_capacityScore / 9) * 100).round().clamp(0, 100);
    _attentionScore = ((capacityPercent + _controlScore + _enduranceScore) / 3).round();

    debugPrint('[TestComplete] capacity=$_capacityScore  control=$_controlScore'
        '  endurance=$_enduranceScore  capacity_percent=$capacityPercent'
        '  attention_score=$_attentionScore');
  }

  Future<void> _saveAndSync() async {
    if (_isSaving) return;

    final token = StorageService.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Session Expired',
        'Please sign in again to continue.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      Get.offAllNamed(AppRoutes.authSignin);
      return;
    }

    setState(() => _isSaving = true);

    try {
      final response = await _authRepository.submitAttentionScores(
        attentionScore: _attentionScore,
        capacityScore: _capacityScore,
        controlScore: _controlScore,
        enduranceScore: _enduranceScore,
        accessToken: token,
      );

      debugPrint('[TestComplete] API response: $response');

      await StorageService.setHasCompletedOnboarding(true);
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      debugPrint('[TestComplete] Error: $e');
      setState(() => _isSaving = false);
      Get.snackbar(
        'Sync Failed',
        _friendlyError(e.toString()),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    }
  }

  String _friendlyError(String raw) {
    if (raw.contains('No internet')) return 'No internet connection. Please check your network and try again.';
    if (raw.contains('401') || raw.contains('Unauthorized')) return 'Your session has expired. Please sign in again.';
    if (raw.contains('500') || raw.contains('502') || raw.contains('503')) return 'The server is having trouble. Please try again in a moment.';
    return 'Something went wrong. Please try again.';
  }

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
                      middle: '$_capacityScore',
                      bottom: 'digits',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatBox(
                      top: 'Cognitive\ncontrol',
                      middle: '$_controlScore%',
                      bottom: 'response',
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildStatBox(
                      top: 'Focus\nendurance',
                      middle: '$_enduranceScore%',
                      bottom: 'accuracy',
                    ),
                  ),
                ],
              ),
              SizedBox(height: 32.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 400.w),
                child: CustomButton(
                  text: _isSaving ? 'Saving...' : 'Save & Sync Profile',
                  onPressed: _isSaving ? () {} : _saveAndSync,
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
