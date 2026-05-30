import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/providers/auth_state_provider.dart';
import '../../../core/network/token_storage.dart';

class AuthTokens {
  final String accessToken;
  final String refreshToken;
  final bool isNewUser;

  const AuthTokens({
    required this.accessToken,
    required this.refreshToken,
    required this.isNewUser,
  });

  factory AuthTokens.fromJson(Map<String, dynamic> json) => AuthTokens(
        accessToken: json['access_token'] as String,
        refreshToken: json['refresh_token'] as String,
        isNewUser: json['is_new_user'] as bool? ?? false,
      );
}

class AuthRepository {
  final Dio _dio;
  final TokenStorage _tokenStorage;

  AuthRepository(ApiClient apiClient, this._tokenStorage) : _dio = apiClient.dio;

  Future<void> sendOtp(String phone) async {
    await _dio.post<void>('/auth/phone', data: {'phone': phone});
  }

  Future<AuthCurrentUser> verifyOtp(String phone, String code) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/verify',
      data: {'phone': phone, 'code': code},
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Réponse vide du serveur lors de verifyOtp');
    }
    final tokens = AuthTokens.fromJson(data);
    await _tokenStorage.saveTokens(
      access: tokens.accessToken,
      refresh: tokens.refreshToken,
    );
    return AuthCurrentUser.fromAccessToken(
      tokens.accessToken,
      isProfileComplete: !tokens.isNewUser,
    );
  }

  Future<void> setupGuest({
    required String pseudo,
    required int age,
    required String genre,
  }) async {
    await _dio.post<void>(
      '/auth/guest',
      data: {'pseudo': pseudo, 'age': age, 'genre': genre},
    );
  }

  Future<void> logout(String refreshToken) async {
    await _dio.post<void>(
      '/auth/logout',
      data: {'refresh_token': refreshToken},
    );
  }
}
