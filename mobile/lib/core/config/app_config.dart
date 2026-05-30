/// Constantes injectées via --dart-define au build.
/// Source unique de vérité — ne pas dupliquer dans d'autres fichiers.

const String appEnv = String.fromEnvironment('APP_ENV', defaultValue: 'dev');
const String mapDriver = String.fromEnvironment('MAP_DRIVER', defaultValue: 'maplibre');
const String backendUrl = String.fromEnvironment(
  'BACKEND_URL',
  defaultValue: 'http://10.0.2.2:3000',
);

bool get isProduction => appEnv == 'prod';
bool get isDevelopment => appEnv == 'dev';
