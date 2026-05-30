import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../config/app_config.dart';
import '../providers/auth_state_provider.dart';
import '../../features/auth/presentation/auth_screen.dart';
import '../../features/map/presentation/map_screen.dart';
import '../../features/activities/presentation/activities_screen.dart';
import '../../features/matching/presentation/matching_screen.dart';
import '../../features/chat/presentation/chat_screen.dart';

part 'app_router.g.dart';

const _routesPubliques = ['/auth', '/splash'];

@Riverpod(keepAlive: true)
GoRouter appRouter(AppRouterRef ref) {
  // Guard actif dès Sprint 0 : authStateProvider retourne false (stub)
  // → toutes les routes protégées redirigent vers /auth jusqu'au Sprint Auth
  final isAuthenticated = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: isDevelopment,
    redirect: (context, state) {
      final versRoutePublique = _routesPubliques.any(
        (r) => state.matchedLocation.startsWith(r),
      );
      if (!isAuthenticated && !versRoutePublique) return '/auth';
      if (isAuthenticated && state.matchedLocation.startsWith('/auth')) {
        return '/map';
      }
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
            builder: (context, state) => const AuthOtpScreen(),
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
          // Routes statiques AVANT les routes dynamiques (règle GoRouter)
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
