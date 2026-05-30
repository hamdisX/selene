import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_state_provider.g.dart';

/// État d'authentification de l'utilisateur.
/// Stub Sprint 0 — remplacé lors du Sprint Auth par la logique JWT réelle.
@riverpod
class AuthState extends _$AuthState {
  @override
  bool build() => false;

  void connecter() => state = true;
  void deconnecter() => state = false;
}
