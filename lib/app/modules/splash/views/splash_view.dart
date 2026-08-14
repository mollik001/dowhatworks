import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dowhatworks/app/data/repositories/auth_repository.dart';
import 'package:dowhatworks/app/data/services/storage_service.dart';
import 'package:dowhatworks/app/data/services/user_service.dart';
import 'package:dowhatworks/app/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final AuthRepository _authRepository = AuthRepository();

  @override
  void initState() {
    super.initState();
    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    final token = StorageService.getAccessToken();

    // No token — go through intro/onboarding flow
    if (token == null || token.isEmpty) {
      print('[Splash] No token — routing to onboarding');
      Get.offAllNamed(AppRoutes.onboarding);
      return;
    }

    // Has token — check onboarding status from API
    try {
      final status = await _authRepository.getOnboardingStatus(accessToken: token);
      print('[Splash] Onboarding status: $status');

      final bool hasCompleted = status['has_completed_onboarding'] == true;
      final bool scoresAreNull = status['attention_score'] == null
          && status['capacity_score'] == null
          && status['control_score'] == null
          && status['endurance_score'] == null;

      if (!hasCompleted) {
        // Hasn't finished the questionnaire yet
        print('[Splash] Onboarding incomplete — routing to questionnaire');
        Get.offAllNamed(AppRoutes.questionnaire);
      } else if (scoresAreNull) {
        // Finished questionnaire but never did the games
        print('[Splash] Scores missing — routing to game (begin test)');
        Get.offAllNamed(AppRoutes.game);
      } else {
        // Fully complete
        print('[Splash] Fully onboarded — routing to home');
        unawaited(UserService.to.fetchProfile());
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (e) {
      // API failed (e.g. no internet) — fall back to locally cached flag
      print('[Splash] API check failed: $e — using local cache');
      final hasCompleted = StorageService.getHasCompletedOnboarding();
      if (hasCompleted) {
        unawaited(UserService.to.fetchProfile());
      }
      Get.offAllNamed(hasCompleted ? AppRoutes.home : AppRoutes.questionnaire);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/splash.png',
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }
}
