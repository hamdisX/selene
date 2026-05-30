import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/config/app_config.dart';
import 'core/router/app_router.dart';

// Firebase.initializeApp() sera ajouté lors du Sprint Notifications
// après `flutterfire configure` (génère firebase_options.dart)

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Guard sécurité : backendUrl doit être HTTPS en staging/prod
  if (!isDevelopment && !backendUrl.startsWith('https://')) {
    throw StateError(
      'SÉCURITÉ : BACKEND_URL doit commencer par https:// en $appEnv. '
      'Passer --dart-define=BACKEND_URL=https://... au build.',
    );
  }

  runApp(
    const ProviderScope(
      child: SeleneApp(),
    ),
  );
}

class SeleneApp extends ConsumerWidget {
  const SeleneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Séléné',
      debugShowCheckedModeBanner: !isProduction,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: router,
    );
  }
}
