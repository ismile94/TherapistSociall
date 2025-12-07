import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/foundation.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  // Token keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  /// Save access token
  static Future<void> saveAccessToken(String token) async {
    debugPrint('🔵 [SECURE_STORAGE] Saving access token (length: ${token.length})');
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      debugPrint('🟢 [SECURE_STORAGE] Access token saved successfully');
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error saving access token: $e');
      rethrow;
    }
  }

  /// Get access token
  static Future<String?> getAccessToken() async {
    debugPrint('🔵 [SECURE_STORAGE] Reading access token...');
    try {
      final token = await _storage.read(key: _accessTokenKey);
      debugPrint('🔵 [SECURE_STORAGE] Access token read: ${token != null ? "exists (length: ${token.length})" : "null"}');
      return token;
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error reading access token: $e');
      return null;
    }
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String token) async {
    debugPrint('🔵 [SECURE_STORAGE] Saving refresh token (length: ${token.length})');
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      debugPrint('🟢 [SECURE_STORAGE] Refresh token saved successfully');
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error saving refresh token: $e');
      rethrow;
    }
  }

  /// Get refresh token
  static Future<String?> getRefreshToken() async {
    debugPrint('🔵 [SECURE_STORAGE] Reading refresh token...');
    try {
      final token = await _storage.read(key: _refreshTokenKey);
      debugPrint('🔵 [SECURE_STORAGE] Refresh token read: ${token != null ? "exists (length: ${token.length})" : "null"}');
      return token;
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error reading refresh token: $e');
      return null;
    }
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    debugPrint('🔵 [SECURE_STORAGE] Saving user ID: $userId');
    try {
      await _storage.write(key: _userIdKey, value: userId);
      debugPrint('🟢 [SECURE_STORAGE] User ID saved successfully');
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error saving user ID: $e');
      rethrow;
    }
  }

  /// Get user ID
  static Future<String?> getUserId() async {
    debugPrint('🔵 [SECURE_STORAGE] Reading user ID...');
    try {
      final userId = await _storage.read(key: _userIdKey);
      debugPrint('🔵 [SECURE_STORAGE] User ID read: $userId');
      return userId;
    } catch (e) {
      debugPrint('🔴 [SECURE_STORAGE] Error reading user ID: $e');
      return null;
    }
  }

  /// Clear all stored tokens and user data
  static Future<void> clearAll() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.delete(key: _userIdKey);
  }

  /// Check if user is logged in (has access token)
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
