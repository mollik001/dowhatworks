class AppConstants {
  static const String appName = 'Do What Works';
  static const String version = '1.0.0';
}

class ApiConstants {
  static const String baseUrl = 'https://api.dowhatworks.ai';

  static const String login = '/api/v1/auth/login/';
  static const String signup = '/api/v1/auth/signup/';
  static const String verifyOtp = '/api/v1/auth/verify-otp/';
  static const String forgotPassword = '/api/v1/auth/forgot-password/';
  static const String resetPassword = '/api/v1/auth/reset-password/';
  static const String onboarding = '/api/v1/auth/onboarding/';
  static const String dailyCheckin = '/api/v1/experiments/daily-checkin/';
  static const String tokenRefresh = '/api/v1/auth/token/refresh/';
  static const String profile = '/api/v1/auth/profile/';
  static const String experiments = '/api/v1/experiments/';
  static const String experimentTemplates = '/api/v1/experiments/templates/';
  static String experimentDetail(int id) => '/api/v1/experiments/$id/';
  static String experimentLogs(int experimentId) =>
      '/api/v1/experiments/$experimentId/logs/';
  static String experimentLog(int experimentId, int logId) =>
      '/api/v1/experiments/$experimentId/logs/$logId/';
  static const String chatSessions = '/api/v1/chat/sessions/';
  static String chatSession(int sessionId) => '/api/v1/chat/sessions/$sessionId/';
  static String chatMessages(int sessionId) => '/api/v1/chat/sessions/$sessionId/messages/';
  static String chatAsk(int sessionId) => '/api/v1/chat/sessions/$sessionId/ask/';
  static const String baselineHistory = '/api/v1/auth/baseline-history/';

  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String onboardingCompletedKey = 'has_completed_onboarding';
  static const String hasSeenOnboardingKey = 'has_seen_onboarding';
}

