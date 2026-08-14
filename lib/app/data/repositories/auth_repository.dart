import '../services/storage_service.dart';
import '../../../core/network/api_client.dart';
import '../../../core/values/constants.dart';

class AuthRepository {
  /// POST {{base_url}}/api/v1/auth/login/
  /// Payload: { "email": "...", "password": "..." }
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.login,
      body: {
        'email': email.trim(),
        'password': password,
      },
    );

    await _extractAndSaveTokens(response);
    return response;
  }

  /// POST {{base_url}}/api/v1/auth/signup/
  /// Payload: { "email": "...", "username": "...", "password": "...", "confirm_password": "..." }
  Future<Map<String, dynamic>> signup({
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.signup,
      body: {
        'email': email.trim(),
        'username': username.trim(),
        'password': password,
        'confirm_password': confirmPassword,
      },
    );

    return response;
  }

  /// POST {{base_url}}/api/v1/auth/verify-otp/
  /// Payload: { "email": "...", "otp_code": 519747 }
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required dynamic otpCode,
  }) async {
    final dynamic formattedOtp = (otpCode is int)
        ? otpCode
        : (int.tryParse(otpCode.toString()) ?? otpCode);

    final response = await ApiClient.post(
      ApiConstants.verifyOtp,
      body: {
        'email': email.trim(),
        'otp_code': formattedOtp,
      },
    );

    await _extractAndSaveTokens(response);
    return response;
  }

  /// GET {{base_url}}/api/v1/auth/onboarding/
  /// Returns has_completed_onboarding, answers, and score fields (may be null).
  Future<Map<String, dynamic>> getOnboardingStatus({
    required String accessToken,
  }) async {
    final response = await ApiClient.get(
      ApiConstants.onboarding,
      token: accessToken,
    );
    return response;
  }

  /// POST {{base_url}}/api/v1/auth/onboarding/
  /// Payload: { "attention_score": 78, "capacity_score": 6, "control_score": 92, "endurance_score": 85 }
  Future<Map<String, dynamic>> submitAttentionScores({
    required int attentionScore,
    required int capacityScore,
    required int controlScore,
    required int enduranceScore,
    required String accessToken,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.onboarding,
      body: {
        'attention_score': attentionScore,
        'capacity_score': capacityScore,
        'control_score': controlScore,
        'endurance_score': enduranceScore,
      },
      token: accessToken,
    );
    return response;
  }

  /// POST {{base_url}}/api/v1/auth/onboarding/
  /// Payload: { "answers": { "question_id": index, ... } }
  Future<Map<String, dynamic>> submitOnboarding({
    required Map<String, int> answers,
    required String accessToken,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.onboarding,
      body: {'answers': answers},
      token: accessToken,
    );
    return response;
  }

  /// POST {{base_url}}/api/v1/auth/forgot-password/
  /// Payload: { "email": "..." }
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.forgotPassword,
      body: {
        'email': email.trim(),
      },
    );
    return response;
  }

  /// POST {{base_url}}/api/v1/auth/reset-password/
  /// Payload: { "token": "...", "password": "...", "confirm_password": "..." }
  Future<Map<String, dynamic>> resetPassword({
    required String token,
    required String password,
    required String confirmPassword,
  }) async {
    final response = await ApiClient.post(
      ApiConstants.resetPassword,
      body: {
        'token': token,
        'password': password,
        'confirm_password': confirmPassword,
      },
    );
    return response;
  }

  Future<void> _extractAndSaveTokens(Map<String, dynamic> response) async {
    final String? accessToken = _findToken(response, ['access_token', 'access', 'token']);
    final String? refreshToken = _findToken(response, ['refresh_token', 'refresh']);

    if (accessToken != null && accessToken.isNotEmpty) {
      await StorageService.setAccessToken(accessToken);
    }
    if (refreshToken != null && refreshToken.isNotEmpty) {
      await StorageService.setRefreshToken(refreshToken);
    }

    final bool? onboardingStatus = _findOnboardingStatus(response);
    if (onboardingStatus != null) {
      await StorageService.setHasCompletedOnboarding(onboardingStatus);
    }
  }

  bool? _findOnboardingStatus(Map<String, dynamic> response) {
    if (response['user'] is Map) {
      final user = response['user'] as Map;
      if (user.containsKey('has_completed_onboarding')) {
        return user['has_completed_onboarding'] == true;
      }
    }
    if (response['data'] is Map) {
      final data = response['data'] as Map;
      if (data['user'] is Map && (data['user'] as Map).containsKey('has_completed_onboarding')) {
        return (data['user'] as Map)['has_completed_onboarding'] == true;
      }
      if (data.containsKey('has_completed_onboarding')) {
        return data['has_completed_onboarding'] == true;
      }
    }
    if (response.containsKey('has_completed_onboarding')) {
      return response['has_completed_onboarding'] == true;
    }
    return null;
  }

  String? _findToken(Map<String, dynamic> response, List<String> keys) {
    for (final key in keys) {
      if (response.containsKey(key) && response[key] is String) {
        return response[key] as String;
      }
    }
    if (response['data'] is Map<String, dynamic>) {
      final dataMap = response['data'] as Map<String, dynamic>;
      for (final key in keys) {
        if (dataMap.containsKey(key) && dataMap[key] is String) {
          return dataMap[key] as String;
        }
      }
    }
    return null;
  }
}
