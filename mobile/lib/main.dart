import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/router/app_router.dart';

// Variables injectées via --dart-define
const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
const String mapDriver = String.fromEnvironment('MAP_DRIVER', defaultValue: 'maplibre');
// Valeur par défaut : émulateur Android. Pour iOS simulator utiliser localhost:3000.
// Pour appareil physique, passer --dart-define=BACKEND_URL=http://192.168.x.x:3000
const String backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase requis par firebase_messaging (FCM push notifications)
  // firebase_options.dart sera généré par `flutterfire configure` lors du Sprint notifications
  await Firebase.initializeApp();

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
      debugShowCheckedModeBanner: appEnv != 'prod',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2D6A4F)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: router,
    );
  }
}
