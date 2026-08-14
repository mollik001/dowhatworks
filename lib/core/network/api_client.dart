import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../values/constants.dart';

// Import lazily via a function pointer to avoid a circular dependency
// between ApiClient and StorageService.
import '../../app/data/services/storage_service.dart';

class ApiClient {
  static String get baseUrl => ApiConstants.baseUrl;

  static Map<String, String> _headers({String? token}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return headers;
  }

  // ---------------------------------------------------------------------------
  // Token refresh
  // ---------------------------------------------------------------------------

  /// Attempts to refresh the access token using the stored refresh token.
  /// Saves the new access token to storage and returns it.
  /// Throws if the refresh fails (refresh token also expired → must re-login).
  static Future<String> _refreshAccessToken() async {
    final refreshToken = StorageService.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw 'Session expired. Please sign in again.';
    }

    print('[ApiClient] Access token expired — refreshing...');

    final uri = Uri.parse('$baseUrl${ApiConstants.tokenRefresh}');
    final response = await http.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode({'refresh': refreshToken}),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      final body = jsonDecode(response.body) as Map<String, dynamic>;
      final newAccessToken = body['access'] as String?;
      if (newAccessToken == null || newAccessToken.isEmpty) {
        throw 'Session expired. Please sign in again.';
      }
      await StorageService.setAccessToken(newAccessToken);
      print('[ApiClient] Token refreshed successfully.');
      return newAccessToken;
    } else {
      // Refresh token itself is expired — user must log in again
      await StorageService.clearTokens();
      throw 'Session expired. Please sign in again.';
    }
  }

  // ---------------------------------------------------------------------------
  // GET
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> get(
    String endpoint, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(uri, headers: _headers(token: token));

      // 401 → refresh and retry once
      if (response.statusCode == 401 && token != null) {
        final newToken = await _refreshAccessToken();
        final retried = await http.get(uri, headers: _headers(token: newToken));
        return _parseResponse(retried);
      }

      return _parseResponse(response);
    } on SocketException {
      throw 'No internet connection. Please check your network settings.';
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // POST
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        uri,
        headers: _headers(token: token),
        body: jsonEncode(body),
      );

      // 401 → refresh and retry once
      if (response.statusCode == 401 && token != null) {
        final newToken = await _refreshAccessToken();
        final retried = await http.post(
          uri,
          headers: _headers(token: newToken),
          body: jsonEncode(body),
        );
        return _parseResponse(retried);
      }

      return _parseResponse(response);
    } on SocketException {
      throw 'No internet connection. Please check your network settings.';
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  static Future<void> delete(
    String endpoint, {
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response =
          await http.delete(uri, headers: _headers(token: token));

      // 401 → refresh and retry once
      if (response.statusCode == 401 && token != null) {
        final newToken = await _refreshAccessToken();
        final retried =
            await http.delete(uri, headers: _headers(token: newToken));
        if (retried.statusCode >= 200 && retried.statusCode < 300) return;
        _parseResponse(retried); // will throw with error message
        return;
      }

      // 204 No Content = success, nothing to parse
      if (response.statusCode == 204) return;
      if (response.statusCode >= 200 && response.statusCode < 300) return;
      _parseResponse(response); // throws with error body
    } on SocketException {
      throw 'No internet connection. Please check your network settings.';
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // PATCH
  // ---------------------------------------------------------------------------

  static Future<Map<String, dynamic>> patch(
    String endpoint, {
    required Map<String, dynamic> body,
    String? token,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.patch(
        uri,
        headers: _headers(token: token),
        body: jsonEncode(body),
      );

      // 401 → refresh and retry once
      if (response.statusCode == 401 && token != null) {
        final newToken = await _refreshAccessToken();
        final retried = await http.patch(
          uri,
          headers: _headers(token: newToken),
          body: jsonEncode(body),
        );
        return _parseResponse(retried);
      }

      return _parseResponse(response);
    } on SocketException {
      throw 'No internet connection. Please check your network settings.';
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------------------------------------------------------
  // Response parsing
  // ---------------------------------------------------------------------------

  static Map<String, dynamic> _parseResponse(http.Response response) {
    Map<String, dynamic> body = {};
    try {
      if (response.body.isNotEmpty) {
        final parsed = jsonDecode(response.body);
        if (parsed is Map<String, dynamic>) {
          body = parsed;
        } else if (parsed is List) {
          body = {'data': parsed};
        }
      }
    } catch (_) {
      body = {'message': response.body};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    } else {
      final errorMessage = body['detail'] ??
          body['message'] ??
          body['error'] ??
          _extractFirstError(body) ??
          'Request failed with status code ${response.statusCode}';
      throw errorMessage;
    }
  }

  static String? _extractFirstError(Map<String, dynamic> map) {
    for (final entry in map.entries) {
      if (entry.value is List && (entry.value as List).isNotEmpty) {
        return '${entry.key}: ${(entry.value as List).first}';
      } else if (entry.value is String) {
        return '${entry.key}: ${entry.value}';
      }
    }
    return null;
  }
}
