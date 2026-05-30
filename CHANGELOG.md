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