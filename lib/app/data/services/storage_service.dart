import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/values/constants.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static Future<bool> setAccessToken(String token) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.setString(ApiConstants.accessTokenKey, token);
  }

  static String? getAccessToken() {
    return _prefs?.getString(ApiConstants.accessTokenKey);
  }

  static Future<bool> setRefreshToken(String token) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.setString(ApiConstants.refreshTokenKey, token);
  }

  static String? getRefreshToken() {
    return _prefs?.getString(ApiConstants.refreshTokenKey);
  }

  static Future<bool> setHasCompletedOnboarding(bool completed) async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.setBool(ApiConstants.onboardingCompletedKey, completed);
  }

  static bool getHasCompletedOnboarding() {
    return _prefs?.getBool(ApiConstants.onboardingCompletedKey) ?? false;
  }

  static Future<bool> setHasSeenOnboarding() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    return await prefs.setBool(ApiConstants.hasSeenOnboardingKey, true);
  }

  static bool getHasSeenOnboarding() {
    return _prefs?.getBool(ApiConstants.hasSeenOnboardingKey) ?? false;
  }

  static Future<bool> clearTokens() async {
    final prefs = _prefs ?? await SharedPreferences.getInstance();
    await prefs.remove(ApiConstants.accessTokenKey);
    await prefs.remove(ApiConstants.refreshTokenKey);
    await prefs.remove(ApiConstants.onboardingCompletedKey);
    return true;
  }
}
