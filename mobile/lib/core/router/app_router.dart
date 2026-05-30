import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_router.g.dart';

// Routes accessibles sans authentification
const _routesPubliques = ['/auth', '/splash'];

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  // TODO Sprint Auth : écouter authStateProvider pour conditionner le redirect
  // final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: appEnv != 'prod',
    redirect: (context, state) {
      // Garde-fou : ce scaffold sans auth NE DOIT PAS être buildé en staging/prod
      assert(appEnv == 'dev', 'Auth guard doit être activé avant tout build staging ou prod');

      // Guard d'authentification — à activer lors du Sprint Auth
      // final estAuthentifie = authState.isAuthenticated;
      // final versRoutePublique = _routesPubliques.any(
      //   (r) => state.matchedLocation.startsWith(r),
      // );
      // if (!estAuthentifie && !versRoutePublique) return '/auth';
      // if (estAuthentifie && state.matchedLocation.startsWith('/auth')) return '/map';
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const _PlaceholderScreen(label: 'Splash'),
      ),
      GoRoute(
        path: '/auth',
        builder: (context, state) => const _PlaceholderScreen(label: 'Auth'),
        routes: [
          GoRoute(
            path: 'phone',
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Auth — Téléphone'),
          ),
          GoRoute(
            path: 'otp',
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Auth — OTP'),
          ),
        ],
      ),
      GoRoute(
        path: '/map',
        builder: (context, state) => const _PlaceholderScreen(label: 'Carte'),
      ),
      GoRoute(
        path: '/activities',
        builder: (context, state) =>
            const _PlaceholderScreen(label: 'Activités'),
        routes: [
          // Routes statiques AVANT les routes dynamiques (règle GoRouter)
          GoRoute(
            path: 'create',
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Créer activité'),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) =>
                const _PlaceholderScreen(label: 'Détail activité'),
          ),
        ],
      ),
      GoRoute(
        path: '/matching',
        builder: (context, state) =>
            const _PlaceholderScreen(label: 'Matching'),
      ),
      GoRoute(
        path: '/chat/:roomId',
        builder: (context, state) => const _PlaceholderScreen(label: 'Chat'),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const _PlaceholderScreen(label: 'Profil'),
      ),
    ],
  );
}

// ignore: unused_element
const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');

class _PlaceholderScreen extends StatelessWidget {
  final String label;
  const _PlaceholderScreen({required this.label});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(label)),
      body: Center(child: Text(label)),
    );
  }
}
