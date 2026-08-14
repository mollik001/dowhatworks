import 'package:get/get.dart';
import '../../../core/network/api_client.dart';
import '../../../core/values/constants.dart';
import 'storage_service.dart';

class UserService extends GetxService {
  // Singleton accessor
  static UserService get to => Get.find<UserService>();

  final username     = ''.obs;
  final email        = ''.obs;
  final profilePhoto = Rxn<String>();

  /// Returns the first character of username, uppercased. Falls back to '?'.
  String get initial {
    final u = username.value.trim();
    return u.isNotEmpty ? u[0].toUpperCase() : '?';
  }

  Future<void> fetchProfile() async {
    final token = StorageService.getAccessToken();
    if (token == null || token.isEmpty) return;

    try {
      final response = await ApiClient.get(ApiConstants.profile, token: token);
      print('[UserService] Profile: $response');

      username.value     = response['username'] as String? ?? '';
      email.value        = response['email']    as String? ?? '';
      profilePhoto.value = response['profile_photo'] as String?;
    } catch (e) {
      print('[UserService] Error fetching profile: $e');
    }
  }
}
