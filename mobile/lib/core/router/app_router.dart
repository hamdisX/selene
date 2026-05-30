import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/app_config.dart';
import '../providers/auth_state_provider.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/auth/presentation/otp_screen.dart';
import '../../features/auth/presentation/guest_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/activities/presentation/activities_screen.dart';
import '../../features/matching/presentation/matching_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';

part 'app_router.g.dart';

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  // ValueNotifier<void> déclenche le refresh du GoRouter quand authState change.
  // ref.listen rebranché à chaque rebuild du provider (keepAlive = pas de rebuild).
  final routerListenable = ValueNotifier<void>(null);
  ref.onDispose(routerListenable.dispose);
  ref.listen<AuthCurrentUser?>(authStateProvider, (_, __) {
    routerListenable.notifyListeners();
  });

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: isDevelopment,
    refreshListenable: routerListenable,
    redirect: (context, state) {
      // ref.read (pas ref.watch) dans redirect — GoRouter n'est pas un widget
      final authUser = ref.read(authStateProvider);
      final loc = state.matchedLocation;
      final isGuestRoute = loc == '/auth/guest';
      final isAuthRoute = loc.startsWith('/auth') || loc == '/splash';

      // Non authentifié
      if (authUser == null) {
        if (isGuestRoute) return '/auth';
        if (!isAuthRoute) return '/auth';
        return null;
      }

      // Authentifié mais profil incomplet → forcer la configuration invité
      if (!authUser.isProfileComplete) {
        if (!isGuestRoute) return '/auth/guest';
        return null;
      }

      // Authentifié et complet → interdire toutes les routes auth
      if (isAuthRoute) return '/map';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const AuthScreen(),
        routes: [
          GoRoute(
            path: 'phone',
            builder: (context, state) => const AuthPhoneScreen(),
          ),
          GoRoute(
            path: 'otp',
            builder: (context, state) => AuthOtpScreen(
              phone: state.extra as String? ?? '',
            ),
          ),
          GoRoute(
            path: 'guest',
            builder: (context, state) => const GuestScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const MapScreen(),
      ),
      GoRoute(
        path: '/activities',
        builder: (context, state) => const ActivitiesScreen(),
        routes: [
          GoRoute(
            path: 'create',
            builder: (context, state) => const CreateActivityScreen(),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) => ActivityDetailScreen(
              activityId: state.pathParameters['id']!,
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/matching',
        builder: (context, state) => const MatchingScreen(),
      ),
      GoRoute(
        path: '/chat/:roomId',
        builder: (context, state) => ChatScreen(
          roomId: state.pathParameters['roomId']!,
        ),
      ),
    ],
  );
}
