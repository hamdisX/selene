import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/network_providers.dart';
import '../../features/auth/providers/auth_provider.dart';

part 'auth_state_provider.g.dart';

class AuthCurrentUser {
  final String userId;
  final String phone;
  final bool isProfileComplete;

  const AuthCurrentUser({
    required this.userId,
    required this.phone,
    required this.isProfileComplete,
  });

  AuthCurrentUser copyWith({bool? isProfileComplete}) => AuthCurrentUser(
        userId: userId,
        phone: phone,
        isProfileComplete: isProfileComplete ?? this.isProfileComplete,
      );

  static AuthCurrentUser fromAccessToken(
    String token, {
    required bool isProfileComplete,
  }) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw const FormatException('Token JWT malformé : nombre de segments incorrect');
    }
    try {
      final normalized = base64Url.normalize(parts[1]);
      final payload = utf8.decode(base64Url.decode(normalized));
      final json = jsonDecode(payload) as Map<String, dynamic>;
      final sub = json['sub'];
      final phone = json['phone'];
      if (sub is! String || phone is! String) {
        throw const FormatException('Claims JWT manquants : sub ou phone absent');
      }
      return AuthCurrentUser(
        userId: sub,
        phone: phone,
        isProfileComplete: isProfileComplete,
      );
    } on FormatException {
      rethrow;
    } catch (e) {
      throw FormatException('Erreur décodage JWT : $e');
    }
  }
}

@Riverpod(keepAlive: true)
class AuthState extends _$AuthState {
  @override
  AuthCurrentUser? build() => null;

  void setUser(AuthCurrentUser user) => state = user;

  void markProfileComplete() {
    final current = state;
    if (current != null) state = current.copyWith(isProfileComplete: true);
  }

  // Révoque le refresh token côté serveur, puis efface les tokens locaux.
  Future<void> logout() async {
    final storage = ref.read(tokenStorageProvider);
    final refreshToken = await storage.getRefreshToken();
    try {
      if (refreshToken != null) {
        await ref.read(authRepositoryProvider).logout(refreshToken);
      }
    } catch (_) {
      // Déconnexion locale garantie même si la révocation serveur échoue
    } finally {
      await storage.clearTokens();
      state = null;
    }
  }
}
