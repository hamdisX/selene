# Séléné — Décisions Techniques

> Document de référence des choix technologiques validés.
> Lu par Claude à chaque session via CLAUDE.md.
> Ne pas modifier sans mettre à jour la date et la justification.

**Dernière mise à jour :** 29 mai 2026
**Statut :** v3 — Final — Validé par tous les agents

**Validé par :** Architect-Tech-1 ✅ · Architect-Tech-2 ✅ · Expert-Security ✅ · Expert-Pro ✅

---

## 1. Environnement de développement

| Paramètre | Valeur |
|-----------|--------|
| OS dev | Ubuntu |
| Mobile test | iPhone (iOS) + Android |
| Containerisation | Docker Compose |
| Langue du code | TypeScript (backend) + Dart (mobile) |
| Flutter version | 3.44.0 (Impeller engine, null safety strict) |
| Node.js version | 24 LTS (requis pour NestJS + Fastify adapter) |
| PostgreSQL version | 18.4 + PostGIS 3.6.3 |

---

## 2. Stack complète

### 2.1 Backend

**Choix : NestJS + Fastify adapter (TypeScript)**

```typescript
const app = await NestFactory.create(AppModule, new FastifyAdapter());
```

**Justification :**
- Structure modulaire imposée → anti-spaghetti garanti
- Chaque feature = un module isolé (ajout/suppression sans impact)
- TypeScript natif → typage fort, refactoring sûr
- Guards/Interceptors → auth et validation centralisés
- WebSocket natif (Socket.io)
- Fastify adapter → performances supérieures à Express

**Alternatives rejetées :**
- Fastify seul → pas de structure imposée, risque spaghetti
- Go → performances supérieures mais dev plus lent, écosystème géo moins mature
- Python FastAPI → WebSocket moins performant, GIL limitant pour temps réel

**Modules NestJS :**

| Module | Responsabilités | Dépend de |
|--------|----------------|-----------|
| `AuthModule` | JWT, OTP, biométrie, refresh tokens | `UsersModule` |
| `UsersModule` | Profils, photos, trust score | — |
| `ActivitiesModule` | CRUD activités, filtres sportifs | `UsersModule`, `GeoModule` |
| `MatchingModule` | Demandes, acceptation, matching | `ActivitiesModule`, `NotificationsModule` |
| `ChatModule` | WebSocket chat, historique messages | `MatchingModule` |
| `NotificationsModule` | Push FCM/APNs, in-app | `UsersModule` |
| `GeoModule` | Géolocalisation, isochrones, cache Redis | — |
| `ModerationModule` | Signalements, blocages, modération IA | `UsersModule` |
| `AdaptersModule` | Pattern Adapter (Storage, Map, OTP...) | — |

**Règle d'isolation :** aucun module n'importe les repositories d'un autre module. Les communications inter-modules passent par des services exportés explicitement.

---

### 2.2 Mobile

**Choix : Flutter (Dart)**

**Justification :**
- Cross-platform iOS + Android depuis une seule codebase
- Performances proches du natif (rendu propre, pas de bridge JS)
- Dart typé → cohérence avec TypeScript côté backend
- Excellent support MapLibre + Mapbox

**Configuration :**
- Flutter version : 3.44.0 (Impeller engine activé par défaut)
- iOS → Simulateur Xcode ou iPhone physique
- Android → Émulateur Android Studio ou téléphone physique
- Backend accessible via `http://localhost:3000` (physique iOS) ou `http://10.0.2.2:3000` (émulateur Android)

**Flavors (multi-environnement) :**

| Flavor | `--dart-define` | Backend URL |
|--------|----------------|-------------|
| `dev` | `APP_ENV=dev` | `http://10.0.2.2:3000` |
| `staging` | `APP_ENV=staging` | `https://api-staging.selene.app` |
| `prod` | `APP_ENV=prod` | `https://api.selene.app` |

```bash
# Lancer en dev (émulateur Android)
flutter run --flavor dev --dart-define=APP_ENV=dev --dart-define=MAP_DRIVER=maplibre

# Lancer en staging (Mapbox)
flutter run --flavor staging --dart-define=APP_ENV=staging --dart-define=MAP_DRIVER=mapbox
```

**Navigation :** GoRouter (routing déclaratif, deep links, auth guards)

**State management :** Riverpod avec code generation (`@riverpod` annotation)

> **Note iPhone physique :** en mode dev sur iPhone physique (non simulateur), remplacer `http://10.0.2.2:3000` par l'IP locale de la machine de développement (ex. `http://192.168.1.x:3000`). Configurable via `--dart-define=BACKEND_URL=http://192.168.1.x:3000`.

---

### 2.3 Base de données

**Choix : PostgreSQL 18.4 + PostGIS 3.6.3 + Redis 8.6.3**

**Architecture : Une seule base partagée**

```
selene_db (PostgreSQL + PostGIS)
  → tous les modules partagent la même instance
  → chaque module NestJS n'accède QU'À SES PROPRES tables
```

**Règle stricte :** le module `Activities` ne touche jamais aux tables du module `Chat`. L'isolation est garantie par le code, pas par des bases séparées.

**Migration future :** si passage microservices → chaque module est déjà isolé, la séparation des bases est triviale.

#### PostGIS — géospatial

```sql
-- Type géographique standard (sphérique, en mètres)
ALTER TABLE activities ADD COLUMN location geography(POINT, 4326);

-- Index GIST obligatoire (performance ST_DWithin)
CREATE INDEX idx_activities_location ON activities USING GIST(location);

-- Requête de proximité (rayon 5 km)
SELECT * FROM activities
WHERE ST_DWithin(location, ST_MakePoint(:lng, :lat)::geography, 5000)
  AND status = 'open';
```

**Règle :** toujours utiliser `geography` (sphérique, mètres) plutôt que `geometry` (plan, degrés). L'index GIST est **obligatoire** sur toute colonne géographique interrogée.

#### Redis — namespaces et TTL

| Namespace | Usage | TTL | Politique |
|-----------|-------|-----|----------|
| `cache:geo:*` | Cache requêtes géospatiales | 30 secondes | allkeys-lru |
| `ratelimit:*` | Rate limiting IP + téléphone | 60 secondes | allkeys-lru |
| `socket:*` | Pub/sub Socket.io (rooms, sessions) | Pas de TTL fixe | allkeys-lru |
| `session:blacklist:*` | Refresh token blacklist | 7 jours | allkeys-lru |
| `otp:*` | Codes OTP + compteurs tentatives | 5 minutes | allkeys-lru |

```yaml
# docker-compose.yml — Redis config
redis:
  command: >
    redis-server
    --maxmemory 256mb
    --maxmemory-policy allkeys-lru
    --requirepass ${REDIS_PASSWORD}
    --save ""
```

**Scaling horizontal :** `@socket.io/redis-adapter` pour synchroniser les rooms Socket.io entre plusieurs instances backend.

> **Risque d'éviction mémoire :** la politique `allkeys-lru` permet à Redis d'évincer N'IMPORTE quelle clé sous pression mémoire, y compris `session:blacklist:*` (token révoqué) et `otp:*` (code actif). Si un token blacklisté est évincé, il redevient valide de facto. **Mitigation :** passer à `volatile-lru` (éviction uniquement sur clés avec TTL) + augmenter `maxmemory` à ≥512MB en production. En V1.1, prévoir une instance Redis séparée pour les namespaces de sécurité.

#### Utilisateurs PostgreSQL

| Utilisateur | Permissions | Usage |
|-------------|-------------|-------|
| `selene_app` | SELECT, INSERT, UPDATE, DELETE | Application NestJS (runtime) |
| `selene_migrate` | DDL complet | Migrations uniquement (job séparé) |
| `selene_readonly` | SELECT uniquement | Analytics, monitoring |

**Règle :** l'utilisateur `selene_app` ne peut pas exécuter de DDL (pas de CREATE/DROP/ALTER). Les migrations sont exécutées par un job séparé avec `selene_migrate`.

**Outil de migration :** TypeORM Migrations (décision Sprint 1). Chaque migration inclut `up()` et `down()` (rollback). Procédure rollback staging : `npm run migration:revert` via `selene_migrate`.

---

### 2.4 Temps réel

**Choix : Socket.io (via NestJS Gateway)**

**Namespaces :**

| Namespace | Usage | Auth requise |
|-----------|-------|-------------|
| `/chat` | Messages entre participants d'un match | JWT obligatoire |
| `/geo` | Mises à jour positions + activités carte | JWT obligatoire |
| `/notifications` | Notifications in-app temps réel | JWT obligatoire |

```typescript
@WebSocketGateway({ namespace: '/chat' })
export class ChatGateway implements OnGatewayConnection {
  // Auth JWT au handshake — connexion refusée si token invalide
  async handleConnection(client: Socket) {
    const token = client.handshake.auth.token;
    const payload = await this.jwtService.verifyAsync(token).catch(() => null);
    if (!payload) return client.disconnect();
    client.data.userId = payload.sub;
  }

  @SubscribeMessage('message')
  async handleMessage(client: Socket, payload: MessageDto) {
    // Pattern write-then-emit : persister AVANT d'émettre
    const saved = await this.messagesService.save(payload);
    this.server.to(payload.roomId).emit('message', saved);
    return { ack: saved.id };
  }
}
```

**Pattern write-then-emit :** toujours persister en base avant d'émettre l'événement Socket.io. Jamais émettre sans confirmation de persistance.

**Utilisé pour :**
- Chat entre participants après match validé
- Mise à jour en temps réel des activités sur la carte
- Notifications in-app instantanées

---

### 2.5 Stockage fichiers

**Pattern Adapter — deux implémentations actives en parallèle**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev local | MinIO (Docker) | `STORAGE_DRIVER=minio` |
| Production | Cloudflare R2 | `STORAGE_DRIVER=r2` |

**Pourquoi les deux en parallèle :** tester R2 dès le dev évite les surprises en prod (latence, limites, format des URLs).

**Free tier R2 :** 10 GB gratuit permanent — suffisant jusqu'à ~300K photos de profil.

**Sécurité et conformité :**
- Buckets **privés** — aucun accès public direct
- URLs signées (pre-signed) avec expiration : 15 min (lecture photos profil) à 1h (uploads)
- Zone R2 : **EU (Europe)** — conformité RGPD lieu de stockage
- Clés IAM scopées par environnement (dev/staging/prod) avec permissions minimales
- Suppression en cascade : à la suppression du compte utilisateur, toutes les photos associées sont supprimées (droit à l'effacement RGPD)

```typescript
// Pre-signed URL — expire dans 15 minutes par défaut
getPresignedUrl(key: string, expiresIn = 900): Promise<string>
```

---

### 2.6 Cartes et géolocalisation

**Pattern Adapter — deux implémentations actives en parallèle**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev + prod (gratuit) | MapLibre + OpenStreetMap | `MAP_DRIVER=maplibre` |
| Dev + prod (free tier) | Mapbox | `MAP_DRIVER=mapbox` |

**Pourquoi les deux :** Mapbox offre 50K loads/mois gratuits. On teste les deux simultanément pour comparer rendu, performances et coût avant de choisir en production.

**Isochrones (zones accessibles en X minutes) :**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev local | OSRM (Docker) | `ROUTING_DRIVER=osrm` |
| Production | Mapbox Isochrone API | `ROUTING_DRIVER=mapbox` |

**Interface MapService Flutter (abstraite) :**

```dart
abstract class MapService {
  Future<void> initialize();
  Future<List<Activity>> fetchActivitiesInBounds(LatLngBounds bounds);
  Future<GeoJSON> getIsochrone(LatLng origin, int minutes, TransportMode mode);
  void updateUserPosition(LatLng position);
  void dispose();
}

class MapLibreMapService implements MapService { ... }
class MapboxMapService implements MapService { ... }
```

**Stratégie géolocalisation mobile :**

| Plateforme | Permission | Stratégie |
|-----------|-----------|----------|
| iOS | `When In Use` uniquement | Position mise à jour quand app au premier plan |
| Android | Foreground only (pas `ACCESS_BACKGROUND_LOCATION`) | ForegroundService si suivi actif |
| Les deux | Arrêt automatique | Mises à jour stoppées quand app en arrière-plan |

**Raison :** `ACCESS_BACKGROUND_LOCATION` déclenche une review Google Play obligatoire + popup iOS intrusive. Séléné ne requiert pas de géoloc background — les activités sont planifiées, pas temps-réel continu.

---

### 2.7 OTP (vérification téléphone)

**Pattern Adapter — deux implémentations actives en parallèle**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev local | Mock (affiche le code dans les logs) | `OTP_DRIVER=mock` |
| Production | Twilio | `OTP_DRIVER=twilio` |

**Mock dev :**
```
[OTP SERVICE] Code pour +33612345678 : 847291
```

**Free tier Twilio :** ~15$ de crédit trial (numéros vérifiés uniquement). À passer en payant dès la beta publique (~0.08$/SMS France).

**Contraintes de sécurité OTP :**

| Paramètre | Valeur | Raison |
|-----------|--------|--------|
| Validité du code | 5 minutes | Réduit la fenêtre d'attaque |
| Tentatives max | 3 par code | Anti-brute-force |
| Lockout après échec | 15 minutes | Ralentissement attaquant |
| Rate limiting | 3 SMS/IP/heure + 1 SMS/téléphone/10 min | Anti-spam |
| Longueur code | 6 chiffres | Standard, non devinable |
| Stockage | Hash bcrypt en Redis (namespace `otp:*`) | Jamais en clair |

**Règle absolue :** `OTP_DRIVER=mock` est **interdit** en staging et production. Validation au démarrage de l'application via le schéma Zod (voir section 4).

---

### 2.8 Push notifications

| Service | Environnement | Coût |
|---------|--------------|------|
| Mock logs | Dev | Gratuit |
| FCM (Firebase Cloud Messaging) | Android prod | Gratuit forever |
| APNs (Apple Push Notification) | iOS prod | Gratuit (nécessite compte dev Apple 99$/an) |

**Android — Notification Channels :**

| Channel ID | Importance | Usage |
|-----------|-----------|-------|
| `matches` | HIGH | Nouveau match, demande acceptée |
| `chat` | DEFAULT | Nouveau message |
| `system` | LOW | Mises à jour système |

**FCM — gestion des 3 états :**

| État app | Comportement FCM | Action requise côté Flutter |
|----------|-----------------|---------------------------|
| Foreground | `FirebaseMessaging.onMessage` Stream | Afficher in-app notification |
| Background | Notification système auto | Badge + navigation au tap |
| Killed | Notification système auto | Relancer app + navigation |

**iOS — timing de la permission :**
- Demander la permission push **après** le 1er match validé, pas au lancement
- Message contextuel : "Soyez notifié quand votre partenaire sportif répond"

**Interface PushService (Pattern Adapter) :**

```typescript
interface PushService {
  sendToUser(userId: string, payload: PushPayload): Promise<void>;
  sendToTopic(topic: string, payload: PushPayload): Promise<void>;
  registerToken(userId: string, token: string, platform: 'ios' | 'android'): Promise<void>;
}

class MockPushAdapter implements PushService { /* logs uniquement */ }
class FcmApnsPushAdapter implements PushService { /* FCM + APNs */ }
```

---

### 2.9 Modération contenu

**Pattern Adapter**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev local | Mock (accepte tout) | `MODERATION_DRIVER=mock` |
| Production | OpenAI Moderation API | `MODERATION_DRIVER=openai` |

**Coût production :** ~0.002$/1000 tokens — négligeable en phase de lancement.

**Conformité RGPD — OpenAI comme sous-traitant :**
- **DPA (Data Processing Agreement)** signé avec OpenAI **obligatoire avant mise en production**
- Contenu envoyé à OpenAI : **anonymisé** (noms propres, téléphones, emails supprimés avant envoi)
- Option "do not train" activée via paramètre API — les données ne sont pas utilisées pour l'entraînement des modèles
- OpenAI déclaré comme **sous-traitant** dans le registre de traitements RGPD de Séléné

---

## 3. Pattern Adapter — principe central

Toute la stack repose sur ce pattern. Le code métier ne sait jamais quel service sous-jacent est utilisé.

> Ce principe est appliqué dans les sections 2.5 à 2.9 pour chaque service externe (stockage, cartes, OTP, push, modération). Les interfaces ci-dessous sont les contrats abstraits que le code métier utilise.

**Interfaces TypeScript complètes :**

```typescript
// Storage
interface StorageService {
  upload(file: Buffer, key: string, contentType: string): Promise<string>;
  delete(key: string): Promise<void>;
  getPresignedUrl(key: string, expiresIn?: number): Promise<string>;
}

// Isochrones (backend)
interface IsochroneService {
  getIsochrone(
    lat: number, lng: number,
    minutes: number,
    mode: 'walk' | 'bike' | 'car'
  ): Promise<GeoJSON.Feature>;
}

// OTP
interface OtpService {
  sendCode(phoneNumber: string): Promise<void>;
  verifyCode(phoneNumber: string, code: string): Promise<boolean>;
}

// Push notifications
interface PushService {
  sendToUser(userId: string, payload: PushPayload): Promise<void>;
  sendToTopic(topic: string, payload: PushPayload): Promise<void>;
  registerToken(userId: string, token: string, platform: 'ios' | 'android'): Promise<void>;
}

// Modération
interface ModerationService {
  moderateText(content: string): Promise<ModerationResult>;
  moderateImage(imageUrl: string): Promise<ModerationResult>;
}

// Implémentations (exemple Storage)
class MinIOAdapter implements StorageService { ... }
class CloudflareR2Adapter implements StorageService { ... }

// Injection selon l'env
const driver = process.env.STORAGE_DRIVER === 'r2'
  ? new CloudflareR2Adapter()
  : new MinIOAdapter();
```

**Changer de service = modifier 1 variable dans `.env`. Zéro changement dans le code métier.**

---

## 4. Gestion des environnements

### Variables d'environnement complètes

```bash
# ─── Application ───────────────────────────────────────
NODE_ENV=development          # development | staging | production
PORT=3000

# ─── Base de données (PostgreSQL) ──────────────────────
DATABASE_URL=postgresql://selene_app:${DB_PASSWORD}@localhost:5432/selene_db
DB_PASSWORD=                  # min 16 caractères, généré aléatoirement

# ─── Base de données (Redis) ───────────────────────────
REDIS_URL=redis://:${REDIS_PASSWORD}@localhost:6379
REDIS_PASSWORD=               # min 16 caractères, généré aléatoirement

# ─── JWT (RS256) ───────────────────────────────────────
JWT_PRIVATE_KEY_PATH=./keys/jwt_private.pem
JWT_PUBLIC_KEY_PATH=./keys/jwt_public.pem
JWT_ACCESS_EXPIRES_IN=900     # 15 minutes (secondes)
JWT_REFRESH_EXPIRES_IN=604800 # 7 jours (secondes)

# ─── Drivers (Pattern Adapter) ─────────────────────────
STORAGE_DRIVER=minio          # minio | r2
MAP_DRIVER=maplibre           # maplibre | mapbox
OTP_DRIVER=mock               # mock | twilio  (mock INTERDIT en staging/prod)
PUSH_DRIVER=mock              # mock | fcm
MODERATION_DRIVER=mock        # mock | openai
ROUTING_DRIVER=osrm           # osrm | mapbox

# ─── Stockage (MinIO — dev) ────────────────────────────
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=
MINIO_SECRET_KEY=
MINIO_BUCKET=selene-dev

# ─── Stockage (Cloudflare R2 — prod) ───────────────────
R2_ACCOUNT_ID=
R2_ACCESS_KEY_ID=
R2_SECRET_ACCESS_KEY=
R2_BUCKET=selene-prod
R2_PUBLIC_DOMAIN=

# ─── Cartes (Mapbox) ───────────────────────────────────
MAPBOX_TOKEN=                 # requis si MAP_DRIVER=mapbox ou ROUTING_DRIVER=mapbox

# ─── Cartes (OSRM — dev) ───────────────────────────────
OSRM_URL=http://localhost:5000

# ─── OTP (Twilio — staging/prod) ───────────────────────
TWILIO_ACCOUNT_SID=
TWILIO_AUTH_TOKEN=
TWILIO_PHONE_NUMBER=

# ─── Push notifications (FCM — Android) ────────────────
FCM_PROJECT_ID=
FCM_PRIVATE_KEY=
FCM_CLIENT_EMAIL=

# ─── Push notifications (APNs — iOS) ───────────────────
APNS_KEY_ID=
APNS_TEAM_ID=
APNS_PRIVATE_KEY_PATH=

# ─── Modération (OpenAI — prod) ────────────────────────
OPENAI_API_KEY=
OPENAI_ORG_ID=
```

### Règles `.env`

```gitignore
# .gitignore — OBLIGATOIRE
.env
.env.local
.env.staging
.env.production
*.pem
*.key
keys/
```

**Fichier `.env.example` obligatoire** dans le repo avec toutes les clés, valeurs vides. Permet à un nouveau développeur de savoir exactement quelles variables configurer.

**Validation au démarrage :** toutes les variables requises sont validées via Zod avant démarrage. L'application refuse de démarrer si une variable critique est manquante ou invalide.

```typescript
const envSchema = z.object({
  // Application
  NODE_ENV: z.enum(['development', 'staging', 'production']),
  PORT: z.coerce.number().default(3000),

  // Base de données
  DATABASE_URL: z.string().url(),
  DB_PASSWORD: z.string().min(16),
  REDIS_URL: z.string().url(),
  REDIS_PASSWORD: z.string().min(16),

  // JWT
  JWT_PRIVATE_KEY_PATH: z.string().min(1),
  JWT_PUBLIC_KEY_PATH: z.string().min(1),
  JWT_ACCESS_EXPIRES_IN: z.coerce.number().positive(),
  JWT_REFRESH_EXPIRES_IN: z.coerce.number().positive(),

  // Drivers
  STORAGE_DRIVER: z.enum(['minio', 'r2']),
  MAP_DRIVER: z.enum(['maplibre', 'mapbox']),
  OTP_DRIVER: z.enum(['mock', 'twilio']),
  PUSH_DRIVER: z.enum(['mock', 'fcm']),
  MODERATION_DRIVER: z.enum(['mock', 'openai']),
  ROUTING_DRIVER: z.enum(['osrm', 'mapbox']),

  // Services optionnels selon driver
  MAPBOX_TOKEN: z.string().optional(),
  TWILIO_ACCOUNT_SID: z.string().optional(),
  TWILIO_AUTH_TOKEN: z.string().optional(),
  TWILIO_PHONE_NUMBER: z.string().optional(),
  FCM_PROJECT_ID: z.string().optional(),
  OPENAI_API_KEY: z.string().optional(),
})
// Règles conditionnelles par driver
.refine(
  (env) => !(env.OTP_DRIVER === 'mock' && env.NODE_ENV !== 'development'),
  { message: 'OTP_DRIVER=mock interdit en staging et production' }
)
.refine(
  (env) => !(env.OTP_DRIVER === 'twilio' && (!env.TWILIO_ACCOUNT_SID || !env.TWILIO_AUTH_TOKEN)),
  { message: 'TWILIO_ACCOUNT_SID et TWILIO_AUTH_TOKEN requis si OTP_DRIVER=twilio' }
)
.refine(
  (env) => !((env.MAP_DRIVER === 'mapbox' || env.ROUTING_DRIVER === 'mapbox') && !env.MAPBOX_TOKEN),
  { message: 'MAPBOX_TOKEN requis si MAP_DRIVER=mapbox ou ROUTING_DRIVER=mapbox' }
)
.refine(
  (env) => !(env.PUSH_DRIVER === 'fcm' && !env.FCM_PROJECT_ID),
  { message: 'FCM_PROJECT_ID requis si PUSH_DRIVER=fcm' }
)
.refine(
  (env) => !(env.MODERATION_DRIVER === 'openai' && !env.OPENAI_API_KEY),
  { message: 'OPENAI_API_KEY requis si MODERATION_DRIVER=openai' }
);
```

### Fichiers `.env` par environnement

```bash
# .env.local — développement
STORAGE_DRIVER=minio
MAP_DRIVER=maplibre
OTP_DRIVER=mock
PUSH_DRIVER=mock
MODERATION_DRIVER=mock
ROUTING_DRIVER=osrm

# .env.staging — test avec services réels
STORAGE_DRIVER=r2
MAP_DRIVER=mapbox
OTP_DRIVER=twilio
PUSH_DRIVER=fcm
MODERATION_DRIVER=openai
ROUTING_DRIVER=mapbox

# .env.production — production
STORAGE_DRIVER=r2
MAP_DRIVER=mapbox
OTP_DRIVER=twilio
PUSH_DRIVER=fcm
MODERATION_DRIVER=openai
ROUTING_DRIVER=mapbox
```

### Stratégie parallèle (dev)

En développement, on peut tester les deux adapters simultanément :

```bash
# Tester Mapbox en dev
flutter run --flavor dev --dart-define=APP_ENV=dev --dart-define=MAP_DRIVER=mapbox

# Tester MapLibre en dev
flutter run --flavor dev --dart-define=APP_ENV=dev --dart-define=MAP_DRIVER=maplibre
```

---

## 5. Structure du projet

```
selene/
├── .claude/
│   └── agents/                    # Agents Claude Code
│       ├── architect-tech-1.md
│       ├── architect-tech-2.md
│       ├── expert-ux.md
│       ├── expert-business.md
│       ├── expert-security.md
│       └── expert-pro.md
├── backend/                       # NestJS + Fastify
│   ├── src/
│   │   ├── auth/                  # Module auth (JWT, OTP, biométrie)
│   │   ├── users/                 # Module utilisateurs + profils
│   │   ├── activities/            # Module activités sportives
│   │   ├── matching/              # Module demandes + acceptation
│   │   ├── chat/                  # Module chat temps réel (WebSocket)
│   │   ├── notifications/         # Module push notifications
│   │   ├── geo/                   # Module géolocalisation + isochrones
│   │   ├── moderation/            # Module modération + signalement
│   │   └── adapters/              # Pattern Adapter (storage, maps, otp...)
│   ├── keys/                      # Clés JWT RS256 (gitignored)
│   ├── .env.local
│   ├── .env.staging
│   ├── .env.example               # Variables requises (valeurs vides)
│   └── docker-compose.yml
├── mobile/                        # Flutter 3.44.0
│   ├── lib/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── map/
│   │   │   ├── activities/
│   │   │   ├── matching/
│   │   │   └── chat/
│   │   ├── core/
│   │   │   ├── adapters/          # MapLibre/Mapbox adapter Flutter
│   │   │   ├── router/            # GoRouter — routing déclaratif
│   │   │   └── services/
│   │   └── main.dart
│   ├── flavors/                   # Configuration dev/staging/prod
│   └── pubspec.yaml
├── docs/                          # CDC et documentation
│   ├── selene-cdc-v4-final.md
│   ├── TECHNICAL_DECISIONS.md
│   └── TECHNICAL_DECISIONS-v1-initial.md
├── CLAUDE.md
└── README.md
```

---

## 6. Architecture base de données (aperçu)

```sql
-- Module Auth
users                  (id, pseudo, age, genre, email, phone, photo_url, trust_score)
push_tokens            (id, user_id, token, platform)

-- Module Activities
activities             (id, creator_id, sport, location geography(POINT,4326), address, datetime, level, genre_filter, max_participants, status)
activity_requests      (id, activity_id, requester_id, status, created_at)

-- Index géospatial obligatoire
CREATE INDEX idx_activities_location ON activities USING GIST(location);

-- Module Chat
chat_rooms             (id, activity_id, created_at)
chat_participants      (room_id, user_id)
messages               (id, room_id, sender_id, content, created_at)

-- Module Geo
-- PostGIS : ST_DWithin (rayon), ST_Distance (distance), ST_MakePoint (construction)
-- Toujours utiliser geography (sphérique, mètres) plutôt que geometry (plan, degrés)
```

---

## 7. Conventions de code

### Backend (NestJS)
- Un module par domaine métier
- Aucun module n'importe les repositories d'un autre module
- Toutes les entrées validées via `class-validator` + DTOs
- Adapters injectés via le module DI de NestJS
- Tests unitaires sur les services, tests e2e sur les controllers

### Mobile (Flutter)
- Architecture : Feature-first (un dossier par feature)
- Version Flutter : 3.44.0 avec null safety strict
- State management : Riverpod avec code generation (`@riverpod` annotation)
- Navigation : GoRouter (routing déclaratif, deep links, auth redirects)
- Appels API : Dio + intercepteurs (auth token, refresh automatique, erreurs)
- Multi-env : flavors `dev/staging/prod` + `--dart-define` pour les clés d'API
- Adapters cartes : abstraction `MapService` avec impl `MapLibreMapService` et `MapboxMapService`

---

## 8. Free tiers — récapitulatif

| Service | Free tier | Seuil de dépassement |
|---------|-----------|---------------------|
| Mapbox | 50K map loads/mois | ~1 500 MAU |
| Cloudflare R2 | 10 GB stockage permanent | ~300K photos |
| FCM | Illimité | Jamais |
| APNs | Illimité | Jamais (99$/an compte dev) |
| Twilio | ~15$ crédit trial | Dès beta publique |
| OpenAI Moderation | Quota limité | Très bas coût en prod |
| MinIO | Gratuit (self-hosted) | — |
| OSRM | Gratuit (self-hosted) | — |
| MapLibre + OSM | Gratuit forever | — |

---

## 9. Décisions en suspens

| Décision | Options | Deadline |
|----------|---------|----------|
| Auth social login | Google + Apple Sign-In — DPA Google Sign-In + DPA Apple Sign-In requis avant activation en prod | Sprint 1 |
| Flutter flavors config | FlutterFire + Fastlane vs manuel | Sprint 1 |
| Outil migration DB | TypeORM Migrations (recommandé) vs Prisma Migrate | Sprint 1 |
| Monitoring prod | Sentry (DPA EU requis) vs Datadog | Avant beta |
| CI/CD | GitHub Actions vs GitLab CI | Sprint 2 |
| Monitoring DPA | Contrat Sentry EU + politique scrubbing PII | Avant beta |
| @nestjs/swagger | ^11.0.0 — incompatible avec NestJS 11 si version antérieure | Résolu Sprint 0 |
| @typescript-eslint | ^8.0.0 — ESLint 9 requiert typescript-eslint v8+ | Résolu Sprint 0 |
| Flutter — connexion backend dev | IP locale machine requise sur iPhone physiqu(`BACKEND_URL=http://192.168.1.x:3000`) | À configurer Sprint 1 |


> **Décisions déjà tranchées** (retirées de cette liste) : GoRouter (acté sections 2.2 et 7), stratégie background location (actée section 2.6).

---

## 10. Sécurité & Conformité RGPD

### 10.1 Authentification JWT

| Paramètre | Valeur | Raison |
|-----------|--------|--------|
| Algorithme | RS256 (asymétrique) | Clé publique distribuable sans risque |
| Access token | 15 minutes | Exposition minimale si interception |
| Refresh token | 7 jours | Rotation à chaque renouvellement |
| Blacklist refresh | Redis (`session:blacklist:{jti}`, TTL 7j) | Invalidation immédiate à la déconnexion |
| Transport | HTTPS uniquement | Jamais en HTTP clair |
| Stockage mobile | Flutter Secure Storage (Keychain iOS / Keystore Android) | Pas dans SharedPreferences |

```typescript
@Injectable()
export class JwtAuthGuard extends AuthGuard('jwt') {
  async canActivate(context: ExecutionContext): Promise<boolean> {
    const valid = await super.canActivate(context);
    if (!valid) return false;
    const jti = this.extractJti(context);
    const blacklisted = await this.redis.get(`session:blacklist:${jti}`);
    return !blacklisted;
  }
}
```

### 10.2 Gestion des secrets

**Règles absolues :**
1. Aucun secret dans le code source ou le dépôt Git (`.env*` dans `.gitignore`)
2. `.env.example` avec valeurs vides — seul fichier `.env*` commité
3. Rotation des secrets : à chaque départ d'un membre + tous les 90 jours en prod
4. Clés API scopées : chaque service reçoit les permissions minimales nécessaires
5. **Pre-commit hook** : `gitleaks` pour détecter les secrets accidentels avant commit

```bash
# Installation gitleaks (pre-commit hook)
# .pre-commit-config.yaml
repos:
  - repo: https://github.com/gitleaks/gitleaks
    rev: v8.18.0
    hooks:
      - id: gitleaks
```

### 10.3 Sécurité PostgreSQL

| Règle | Valeur |
|-------|--------|
| Port | 5432 en réseau interne uniquement (non exposé publiquement) |
| SSL/TLS | Obligatoire en staging et production (`sslmode=require`) |
| Utilisateur app | `selene_app` — SELECT/INSERT/UPDATE/DELETE uniquement |
| Utilisateur migration | `selene_migrate` — DDL complet, job séparé uniquement |
| Mots de passe | Générés aléatoirement, stockés en vault/secrets manager |
| Données sensibles | Téléphones et emails hachés pour les index |

### 10.4 Sécurité Redis

| Règle | Valeur |
|-------|--------|
| Port | 6379 en réseau interne uniquement |
| Auth | `requirepass` avec mot de passe fort (voir section 2.3) |
| PII | Jamais de données personnelles identifiables en clair dans Redis |
| TLS | Activé en staging et production |
| Persistence | Désactivée (`--save ""`) — Redis est un cache, pas une source de vérité |

### 10.5 RGPD — Sous-traitants

| Sous-traitant | Service | Exigences légales | Statut |
|--------------|---------|-------------------|--------|
| Twilio | OTP SMS | DPA + SCC (Standard Contractual Clauses) UE signés | Requis avant beta |
| OpenAI | Modération contenu | DPA signé + option "do not train" activée | Requis avant prod |
| Cloudflare (R2) | Stockage fichiers | Zone EU sélectionnée + DPA Cloudflare | Zone EU à configurer |
| Firebase (FCM) | Push notifications | DPA Google Firebase | Standard Google |
| Sentry (monitoring) | Logs d'erreurs | DPA + scrubbing PII dans les logs | Self-hosted EU ou DPA |

**Registre de traitements RGPD :** chaque sous-traitant doit être listé avec sa finalité, sa base légale, et son DPA dans le registre interne de Séléné.

### 10.6 Règles de sécurité critiques — résumé

```
INTERDIT en staging/prod :
  ✗ OTP_DRIVER=mock
  ✗ HTTP sans TLS
  ✗ Secrets en clair dans le code ou variables d'environnement non chiffrées
  ✗ Utilisateur PostgreSQL avec droits DDL pour l'application runtime
  ✗ Redis exposé publiquement sans authentification

OBLIGATOIRE avant mise en production :
  ✓ DPA Twilio + SCC signés
  ✓ DPA OpenAI signé + "do not train" activé
  ✓ R2 bucket zone EU configuré
  ✓ Gitleaks dans le pipeline CI
  ✓ Rotation des secrets documentée
  ✓ JWT blacklist Redis opérationnelle
  ✓ .env.example à jour avec toutes les variables
```
