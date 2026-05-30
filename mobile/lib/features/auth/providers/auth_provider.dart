import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/network/network_providers.dart';
import '../data/auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(apiClientProvider),
    ref.watch(tokenStorageProvider),
  );
}
