import 'package:get/get.dart';
import '../modules/auth/bindings/forgot_password_binding.dart';
import '../modules/auth/bindings/otp_binding.dart';
import '../modules/auth/bindings/reset_password_binding.dart';
import '../modules/auth/bindings/signup_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/otp_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/auth/views/signin_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/questionnaire/bindings/questionnaire_binding.dart';
import '../modules/questionnaire/views/questionnaire_view.dart';
import '../modules/splash/views/splash_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.authSignup,
      page: () => const SignupView(),
      binding: SignupBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.authOtp,
      page: () => const OtpView(),
      binding: OtpBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.authForgotPassword,
      page: () => const ForgotPasswordView(),
      binding: ForgotPasswordBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.authResetPassword,
      page: () => const ResetPasswordView(),
      binding: ResetPasswordBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.authSignin,
      page: () => const SigninView(),
      binding: SignupBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.questionnaire,
      page: () => const QuestionnaireView(),
      binding: QuestionnaireBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
