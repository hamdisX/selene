import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import '../config/app_config.dart';
import 'auth_interceptor.dart';
import 'token_storage.dart';

/// Client HTTP Dio unique pour l'application.
/// Injecté via Riverpod — ne pas instancier directement.
class ApiClient {
  late final Dio dio;

  ApiClient(TokenStorage tokenStorage) {
    dio = Dio(
      BaseOptions(
        baseUrl: '$backendUrl/api/v1',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 30),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    dio.interceptors.addAll([
      AuthInterceptor(tokenStorage, dio),
      // En dev : loguer les requêtes sans exposer les tokens ni les bodies sensibles.
      // requestHeader: false → évite de logger Authorization: Bearer <token>
      // requestBody/responseBody: false → évite de logger tokens JWT en clair dans adb logcat
      if (isDevelopment)
        LogInterceptor(
          requestHeader: false,
          requestBody: false,
          responseBody: false,
          responseHeader: false,
          logPrint: (obj) => debugPrint('[HTTP] $obj'),
        ),
    ]);
  }
}
