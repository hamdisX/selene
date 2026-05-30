# Séléné — Changelog
> Historique des sessions et features terminées.
> Append-only — ne jamais modifier une entrée existante.
> Chargé via @ dans Claude Code pour contexte inter-sessions.

---

## [2026-05-29] — Fondations du projet

### Documents validés
- CDC complet rédigé et validé via workflow multi-agents (6 agents, 4 phases)
  → `docs/selene-cdc-v4-final.md` — EXPERT_PRO_OK ✅
- Décisions techniques rédigées et validées (4 agents)
  → `docs/TECHNICAL_DECISIONS.md` — EXPERT_PRO_OK ✅

### Agents créés
- 6 agents CDC dans `.claude/agents/cdc/`
  (architect-tech-1, architect-tech-2, expert-ux, expert-business, expert-security, expert-pro)
- 8 agents dev dans `.claude/agents/dev/`
  (review-backend, review-mobile, review-database, review-infra, review-security, review-test, review-api, review-pro)

### Fichiers projet
- `README.md` — documentation publique GitHub
- `CLAUDE.md` — mémoire technique projet
- `CHANGELOG.md` — ce fichier

### Nettoyage
- Archives CDC v1/v2/v3 supprimées — seul `selene-cdc-v4-final.md` conservé

---

## [2026-05-30] — Sprint 0 : Setup environnement de développement

### Ajouté — Backend (NestJS + Fastify)
- `backend/Dockerfile` — multi-stage (base → development / base → build → production), user non-root `nestjs` en production
- `backend/src/main.ts` — bootstrap Fastify, prefix `api/v1`, ValidationPipe, Swagger non-prod, Logger
- `backend/src/app.module.ts` — ConfigModule global, TypeOrmModule async, ThrottlerModule, APP_GUARD ThrottlerGuard
- `backend/src/config/env.validation.ts` — validation Zod au démarrage, guard `OTP_DRIVER=mock` interdit hors development
- `backend/src/config/data-source.ts` — TypeORM CLI data source, synchronize:false, migrationsRun:false
- `backend/src/adapters/adapters.module.ts` — @Global(), 5 factories Pattern Adapter (STORAGE, OTP, PUSH, MODERATION, ISOCHRONE)
- `backend/src/auth/auth.module.ts` — JWT RS256, fs.existsSync avant lecture clés, message d'erreur explicite
- Modules squelettes : AuthModule, UsersModule, ActivitiesModule, MatchingModule, ChatModule, NotificationsModule, GeoModule, ModerationModule, AdaptersModule
- `backend/package.json` — dépendances complètes, Jest config avec moduleNameMapper pour tous les alias
- `backend/test/jest-e2e.json` — configuration e2e Jest

### Ajouté — Base de données
- `backend/database/init/00_init_users.sh` — création rôles selene_migrate + selene_readonly depuis env vars, anti-injection SQL via sed
- `backend/database/init/01_setup.sql` — extensions PostGIS/uuid-ossp/pgcrypto, REVOKE ALL PUBLIC, grants DML/DDL/SELECT par rôle, ALTER DEFAULT PRIVILEGES

### Ajouté — Mobile (Flutter 3.44.0)
- `mobile/pubspec.yaml` — flutter_riverpod, go_router, dio, firebase, maplibre, mapbox, mockito, network_image_mock
- `mobile/lib/main.dart` — Firebase.initializeApp() async, ProviderScope, dart-define BACKEND_URL/APP_ENV/MAP_DRIVER
- `mobile/lib/core/router/app_router.dart` — GoRouter, routes statiques avant dynamiques, redirect avec assert(appEnv == 'dev'), auth guard commenté prêt Sprint Auth
- `mobile/lib/core/providers/auth_state_provider.dart` — stub @riverpod AuthState (build → false), connecter()/deconnecter()
- `mobile/lib/core/adapters/map_service.dart` — abstract MapService + MapLibreMapService + MapboxMapService + factory dart-define

### Ajouté — Infrastructure
- `docker-compose.yml` — 5 services : postgres (postgis/postgis:18-3.6), redis (8.6.3-alpine), minio, minio-init, backend ; ports liés 127.0.0.1 ; healthchecks ; OSRM sous profil `routing`
- `.env.example` — toutes les variables documentées
- `.gitignore` — couverture complète (`.env.*`, clés RSA, dist/, build/)
- `Makefile` — targets : up, down, logs, migrate, setup-osrm, .env auto-création
- `scripts/generate-jwt-keys.sh` — RSA 4096, chmod 600/644
- `scripts/setup-osrm.sh` — téléchargement + preprocessing carte France (osrm/osrm-backend:v5.27.1)

### Validé (Workflow C + Workflow E)
- REVIEW_INFRA_OK ✅ — docker-compose.yml, Dockerfile, scripts
- REVIEW_SECURITY_OK ✅ — JWT RS256, secrets, validation inputs, rôles DB
- REVIEW_BACKEND_OK ✅ — modules NestJS, guards, Pattern Adapter
- REVIEW_MOBILE_OK ✅ — Flutter, Riverpod, GoRouter, MapService
- REVIEW_DATABASE_OK ✅ — PostgreSQL 18.4 + PostGIS 3.6.3, rôles, extensions
- REVIEW_API_OK ✅ — Swagger, ValidationPipe, prefix api/v1
- REVIEW_TEST_OK ✅ — Jest config, moduleNameMapper, pubspec dev_deps
- **REVIEW_PRO_OK ✅** — Verdict APPROUVÉ (recheck après corrections)

### Points de vigilance documentés (risques acceptés Sprint 0)
- `sed "s/'/''/g"` dans 00_init_users.sh : anti-injection basique, suffisant en Docker dev, à remplacer avant staging
- `assert(appEnv == 'dev')` dans app_router.dart : éliminé en mode release Flutter — comportement attendu et documenté
- `network_image_mock: ^2.1.1` : à surveiller lors des upgrades Flutter 3.x

---

## [2026-05-30] — Sprint 0 : Tests de validation environnement

### Résultats des tests

| Service | Image | Status | Healthcheck |
|---------|-------|--------|-------------|
| PostgreSQL + PostGIS | postgis/postgis:18-3.6 | ✅ Up | ✅ healthy |
| Redis | redis:8.6.3-alpine | ✅ Up | ✅ healthy |
| MinIO | minio/minio:latest | ✅ Up | ✅ healthy |
| Backend NestJS | selene-backend | ✅ Up | ✅ démarré |

#### Connexions validées
- PostgreSQL 18.4 + PostGIS 3.6 : `SELECT version()` → OK ✅
- PostgreSQL rôles init : `selene_app`, `selene_migrate`, `selene_readonly` créés ✅
- Redis : `PING` → `PONG` ✅
- TypeORM → PostgreSQL : `TypeOrmCoreModule dependencies initialized` ✅
- MinIO bucket `selene-dev` : healthcheck live → 200 ✅

#### Endpoints NestJS validés
- `GET /api/v1/health` → 200 `{"status":"ok","timestamp":"..."}` ✅
- `GET /api/docs` (Swagger UI) → 200 ✅

### Corrections appliquées lors de la validation

1. **`docker-compose.yml`** — volume PostgreSQL 18 : mount corrigé `/var/lib/postgresql/data` → `/var/lib/postgresql` (format PostgreSQL 18+)
2. **`backend/Dockerfile`** — ajout `ENV npm_config_nodedir=/usr/local` pour éviter le téléchargement des headers Node par bcrypt/node-gyp
3. **`backend/package.json`** — 3 corrections de versions :
   - `@nestjs/swagger`: `^8.0.0` → `^11.0.0` (NestJS 11 incompatible avec swagger 8)
   - `@typescript-eslint/eslint-plugin`: `^7.0.0` → `^8.0.0` (ESLint 9 requiert typescript-eslint 8)
   - `@typescript-eslint/parser`: `^7.0.0` → `^8.0.0` (même raison)
   - Ajout de `@fastify/static: "^8.0.0"` (requis par Fastify + Swagger pour servir les assets UI)
4. **`backend/package-lock.json`** — généré (absent du repo initial)
5. **`backend/src/adapters/`** — 10 fichiers d'adapters créés (squelettes Sprint 0) :
   - `storage/minio.adapter.ts` — MinIOAdapter (implémentation complète dev)
   - `storage/r2.adapter.ts` — CloudflareR2Adapter (implémentation complète prod)
   - `otp/mock.adapter.ts` — MockOtpAdapter ✅
   - `otp/twilio.adapter.ts` — TwilioOtpAdapter (prod)
   - `push/mock.adapter.ts` — MockPushAdapter ✅
   - `push/fcm-apns.adapter.ts` — FcmApnsAdapter (stub prod)
   - `moderation/mock.adapter.ts` — MockModerationAdapter ✅
   - `moderation/openai.adapter.ts` — OpenAIModerationAdapter (stub prod)
   - `isochrone/osrm.adapter.ts` — OsrmIsochroneAdapter ✅
   - `isochrone/mapbox.adapter.ts` — MapboxIsochroneAdapter (stub prod)
6. **`backend/src/health.controller.ts`** — créé (GET /api/v1/health)
7. **`backend/src/app.module.ts`** — ajout HealthController
8. **`.env`** + **`backend/.env.local`** — créés (générés automatiquement, non commités)
9. **`backend/keys/`** — clés JWT RSA 4096 générées via `scripts/generate-jwt-keys.sh`

### Points de vigilance documentés

- `selene_app` = rôle PostgreSQL SUPERUSER en dev (POSTGRES_USER Docker) — en prod, créer un rôle dédié avec permissions limitées uniquement
- `osrm` non démarré (profil `routing`, données carte non préparées) — prévu Sprint 1 ou démarrer avec `make up-routing` après `make setup-osrm`
- `@fastify/static` : dépendance obligatoire pour Swagger + Fastify, absente du `package.json` initial

---

## [2026-05-30] — Sprint 0 : Initialisation mobile Flutter

### Ajouté — Mobile (Flutter 3.44.0)

#### Configuration centrale
- `mobile/lib/core/config/app_config.dart` — constantes dart-define (APP_ENV, MAP_DRIVER, BACKEND_URL), getters `isProduction` / `isDevelopment`
- `mobile/lib/main.dart` — guard HTTPS au démarrage (StateError si !isDevelopment && !backendUrl.startsWith('https://'))

#### Réseau
- `mobile/lib/core/network/token_storage.dart` — JWT storage sécurisé (EncryptedSharedPreferences Android, KeychainAccessibility.first_unlock iOS)
- `mobile/lib/core/network/auth_interceptor.dart` — injection Bearer, refresh automatique JWT avec `_refreshDio` séparé (évite boucle 401 récursive)
- `mobile/lib/core/network/api_client.dart` — Dio, LogInterceptor sans tokens (requestHeader/Body:false), base URL `$backendUrl/api/v1`
- `mobile/lib/core/network/network_providers.dart` — providers Riverpod `tokenStorageProvider` + `apiClientProvider`
- `mobile/lib/core/network/network_providers.g.dart` — code généré

#### Navigation
- `mobile/lib/core/router/app_router.dart` — GoRouter, guard auth activé (`ref.watch(authStateProvider)`), routes statiques avant dynamiques, `@Riverpod(keepAlive: true)`
- `mobile/lib/core/router/app_router.g.dart` — `Provider<GoRouter>.internal` (keepAlive, non AutoDispose)

#### Auth state
- `mobile/lib/core/providers/auth_state_provider.dart` — stub `@riverpod bool authState(...)` → false (actif Sprint Auth)
- `mobile/lib/core/providers/auth_state_provider.g.dart` — code généré

#### Écrans feature (stubs prêts Sprint 1+)
- `mobile/lib/features/auth/presentation/auth_screen.dart` — AuthScreen, AuthPhoneScreen, AuthOtpScreen
- `mobile/lib/features/map/presentation/map_screen.dart` — MapScreen avec MapService adapter
- `mobile/lib/features/activities/presentation/activities_screen.dart` — ActivitiesScreen, CreateActivityScreen, ActivityDetailScreen
- `mobile/lib/features/matching/presentation/matching_screen.dart` — MatchingScreen
- `mobile/lib/features/chat/presentation/chat_screen.dart` — ChatScreen(roomId)

#### Android
- `mobile/android/app/build.gradle` — flavors (dev/staging/prod), signing via `key.properties` (build échoue intentionnellement sans keystore), minify + shrink release, ProGuard
- `mobile/android/app/proguard-rules.pro` — règles Flutter, flutter_secure_storage, OkHttp/Kotlin coroutines

#### Qualité
- `mobile/analysis_options.yaml` — `flutter_lints`, règles cancel_subscriptions, close_sinks, unawaited_futures

### Validé (Workflow F)
- REVIEW_MOBILE_OK ✅ — Flutter, Riverpod, GoRouter, adapters carte
- REVIEW_SECURITY_OK ✅ — JWT storage, LogInterceptor, guard HTTPS, signing APK, auth guard
- **REVIEW_PRO_OK ✅** — Verdict : APPROUVÉ AVEC RÉSERVES MINEURES

### Points de vigilance documentés (backlog Sprint 1+)
- `/splash` et `/auth` pointent tous deux vers `AuthScreen` — créer un `SplashScreen` distinct avant Sprint Auth
- Contrat `/auth/refresh` à documenter (snake_case `refresh_token`) dans TECHNICAL_DECISIONS.md avant Sprint Auth
- `_isRefreshing bool` insuffisant pour requêtes 401 concurrentes — implémenter une queue au Sprint Auth
- `createMapService()` à migrer en Riverpod Provider au Sprint Maps
- Injection du keystore en CI/CD à documenter au Sprint CI/CD
- Package `maplibre_gl` : à surveiller (maintenance communautaire) — fallback `flutter_map` documenté en option

---

<!-- TEMPLATE pour les prochaines entrées

## [YYYY-MM-DD] — Sprint N / Feature X

### Ajouté
- Description de ce qui a été créé

### Modifié
- Description de ce qui a été changé

### Validé
- NOM_AGENT_OK ✅ sur fichier/module concerné

### Fichiers impactés
- `chemin/fichier.ts`

-->