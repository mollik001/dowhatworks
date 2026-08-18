import 'package:dowhatworks/app/modules/auth/bindings/forgot_password_binding.dart';
import 'package:dowhatworks/app/modules/custom_protocol/bindings/custom_protocol_binding.dart';
import 'package:dowhatworks/app/modules/custom_protocol/views/custom_protocol_view.dart';
import 'package:dowhatworks/app/modules/custom_protocol/views/custom_protocol_action_view.dart';
import 'package:dowhatworks/app/modules/custom_protocol/views/custom_protocol_metric_view.dart';
import 'package:dowhatworks/app/modules/custom_protocol/views/custom_protocol_launch_view.dart';
import 'package:dowhatworks/app/modules/experiment_detail/bindings/experiment_detail_binding.dart';
import 'package:dowhatworks/app/modules/experiment_detail/views/experiment_detail_view.dart';
import 'package:dowhatworks/app/modules/profile/bindings/profile_binding.dart';
import 'package:dowhatworks/app/modules/profile/views/profile_view.dart';
import 'package:get/get.dart';
import '../modules/daily_checkin/bindings/daily_checkin_binding.dart';
import '../modules/daily_checkin/views/daily_checkin_view.dart';
import '../modules/auth/bindings/otp_binding.dart';
import '../modules/auth/bindings/reset_password_binding.dart';
import '../modules/auth/bindings/signup_binding.dart';
import '../modules/auth/bindings/signin_binding.dart';
import '../modules/auth/views/forgot_password_view.dart';
import '../modules/auth/views/otp_view.dart';
import '../modules/auth/views/reset_password_view.dart';
import '../modules/auth/views/signin_view.dart';
import '../modules/auth/views/signup_view.dart';
import '../modules/home/widgets/main_screen.dart';
import '../modules/home/controllers/home_controller.dart';
import '../modules/daniel/controllers/daniel_controller.dart';
import '../modules/lab/controllers/lab_controller.dart';
import '../modules/results/controllers/results_controller.dart';
import '../modules/onboarding/bindings/onboarding_binding.dart';
import '../modules/onboarding/views/onboarding_view.dart';
import '../modules/questionnaire/bindings/questionnaire_binding.dart';
import '../modules/questionnaire/views/questionnaire_view.dart';
import '../modules/questionnaire/views/game_view.dart';
import '../modules/questionnaire/views/digit_span_view.dart';
import '../modules/questionnaire/views/stroop_intro_view.dart';
import '../modules/questionnaire/views/stroop_game_view.dart';
import '../modules/questionnaire/views/sustained_response_intro_view.dart';
import '../modules/questionnaire/views/sustained_response_game_view.dart';
import '../modules/questionnaire/views/test_complete_view.dart';
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
      binding: SigninBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const MainScreen(initialIndex: 0),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) Get.lazyPut(() => HomeController());
        if (!Get.isRegistered<DanielController>()) Get.lazyPut(() => DanielController());
        if (!Get.isRegistered<LabController>()) Get.lazyPut(() => LabController());
        if (!Get.isRegistered<ResultsController>()) Get.lazyPut(() => ResultsController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.daniel,
      page: () => const MainScreen(initialIndex: 1),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) Get.lazyPut(() => HomeController());
        if (!Get.isRegistered<DanielController>()) Get.lazyPut(() => DanielController());
        if (!Get.isRegistered<LabController>()) Get.lazyPut(() => LabController());
        if (!Get.isRegistered<ResultsController>()) Get.lazyPut(() => ResultsController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.lab,
      page: () => const MainScreen(initialIndex: 2),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) Get.lazyPut(() => HomeController());
        if (!Get.isRegistered<DanielController>()) Get.lazyPut(() => DanielController());
        if (!Get.isRegistered<LabController>()) Get.lazyPut(() => LabController());
        if (!Get.isRegistered<ResultsController>()) Get.lazyPut(() => ResultsController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.results,
      page: () => const MainScreen(initialIndex: 3),
      binding: BindingsBuilder(() {
        if (!Get.isRegistered<HomeController>()) Get.lazyPut(() => HomeController());
        if (!Get.isRegistered<DanielController>()) Get.lazyPut(() => DanielController());
        if (!Get.isRegistered<LabController>()) Get.lazyPut(() => LabController());
        if (!Get.isRegistered<ResultsController>()) Get.lazyPut(() => ResultsController());
      }),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 250),
    ),
    GetPage(
      name: AppRoutes.questionnaire,
      page: () => const QuestionnaireView(),
      binding: QuestionnaireBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.game,
      page: () => const GameView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.digitSpan,
      page: () => const DigitSpanView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.stroopIntro,
      page: () => const StroopIntroView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.stroopGame,
      page: () => const StroopGameView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.sustainedResponseIntro,
      page: () => const SustainedResponseIntroView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.sustainedResponseGame,
      page: () => const SustainedResponseGameView(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.testComplete,
      page: () => const TestCompleteView(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.dailyCheckin,
      page: () => const DailyCheckinView(),
      binding: DailyCheckinBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.customProtocol,
      page: () => const CustomProtocolView(),
      binding: CustomProtocolBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.customProtocolAction,
      page: () => const CustomProtocolActionView(),
      binding: CustomProtocolBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.customProtocolMetric,
      page: () => const CustomProtocolMetricView(),
      binding: CustomProtocolBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.customProtocolLaunch,
      page: () => const CustomProtocolLaunchView(),
      binding: CustomProtocolBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.experimentDetail,
      page: () => const ExperimentDetailView(),
      binding: ExperimentDetailBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
      transition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
