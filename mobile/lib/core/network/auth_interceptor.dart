import 'package:dio/dio.dart';
import 'token_storage.dart';

/// Attache le Bearer token à chaque requête et gère le renouvellement
/// automatique sur 401 (un seul retry, puis déconnexion).
///
/// _refreshDio est une instance sans intercepteur — évite la boucle récursive
/// si le serveur retourne lui-même 401 sur /auth/refresh.
class AuthInterceptor extends Interceptor {
  final TokenStorage _tokenStorage;
  final Dio _dio;
  late final Dio _refreshDio;
  bool _isRefreshing = false;

  AuthInterceptor(this._tokenStorage, this._dio) {
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: _dio.options.baseUrl,
        connectTimeout: _dio.options.connectTimeout,
        receiveTimeout: _dio.options.receiveTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Ne pas attacher le token sur les routes publiques (auth/refresh)
    if (_isPublicRoute(options.path)) {
      handler.next(options);
      return;
    }
    final token = await _tokenStorage.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401 || _isRefreshing) {
      handler.next(err);
      return;
    }

    final refreshToken = await _tokenStorage.getRefreshToken();
    if (refreshToken == null) {
      await _tokenStorage.clearTokens();
      handler.next(err);
      return;
    }

    _isRefreshing = true;
    try {
      final response = await _refreshDio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {'refresh_token': refreshToken},
      );
      final data = response.data!;
      await _tokenStorage.saveTokens(
        access: data['access_token'] as String,
        refresh: data['refresh_token'] as String,
      );
      err.requestOptions.headers['Authorization'] =
          'Bearer ${data['access_token']}';
      final retried = await _dio.fetch<dynamic>(err.requestOptions);
      handler.resolve(retried);
    } on DioException {
      await _tokenStorage.clearTokens();
      handler.next(err);
    } finally {
      _isRefreshing = false;
    }
  }

  bool _isPublicRoute(String path) =>
      path.startsWith('/auth') || path.startsWith('/health');
}
