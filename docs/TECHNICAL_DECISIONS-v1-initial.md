# Séléné — Décisions Techniques

> Document de référence des choix technologiques validés.
> Lu par Claude à chaque session via CLAUDE.md.
> Ne pas modifier sans mettre à jour la date et la justification.

**Dernière mise à jour :** 29 mai 2026
**Statut :** Validé

---

## 1. Environnement de développement

| Paramètre | Valeur |
|-----------|--------|
| OS dev | Ubuntu |
| Mobile test | iPhone (iOS) + Android |
| Containerisation | Docker Compose |
| Langue du code | TypeScript (backend) + Dart (mobile) |

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

---

### 2.2 Mobile

**Choix : Flutter (Dart)**

**Justification :**
- Cross-platform iOS + Android depuis une seule codebase
- Performances proches du natif (rendu propre, pas de bridge JS)
- Dart typé → cohérence avec TypeScript côté backend
- Excellent support MapLibre + Mapbox

**Configuration :**
- iOS → Simulateur Xcode ou iPhone physique
- Android → Émulateur Android Studio ou téléphone physique
- Backend accessible via `http://localhost:3000` (physique) ou `http://10.0.2.2:3000` (émulateur Android)

---

### 2.3 Base de données

**Choix : PostgreSQL 15 + PostGIS + Redis**

**Architecture : Une seule base partagée**

```
selene_db (PostgreSQL + PostGIS)
  → tous les modules partagent la même instance
  → chaque module NestJS n'accède QU'À SES PROPRES tables
```

**Règle stricte :** le module `Activities` ne touche jamais aux tables du module `Chat`. L'isolation est garantie par le code, pas par des bases séparées.

**Migration future :** si passage microservices → chaque module est déjà isolé, la séparation des bases est triviale.

**PostGIS** → requêtes géospatiales (rayon, proximité, isochrones)
**Redis** → sessions, cache, pub/sub WebSocket, rate limiting

---

### 2.4 Temps réel

**Choix : Socket.io (via NestJS Gateway)**

```typescript
@WebSocketGateway()
export class ChatGateway implements OnGatewayConnection {
  @SubscribeMessage('message')
  handleMessage(client: Socket, payload: MessageDto) { ... }
}
```

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

---

### 2.8 Push notifications

| Service | Environnement | Coût |
|---------|--------------|------|
| Mock logs | Dev | Gratuit |
| FCM (Firebase Cloud Messaging) | Android prod | Gratuit forever |
| APNs (Apple Push Notification) | iOS prod | Gratuit (nécessite compte dev Apple 99$/an) |

FCM et APNs sont gratuits — on les intègre directement dès le dev mobile, pas besoin d'adapter complexe.

---

### 2.9 Modération contenu

**Pattern Adapter**

| Environnement | Service | Config |
|--------------|---------|--------|
| Dev local | Mock (accepte tout) | `MODERATION_DRIVER=mock` |
| Production | OpenAI Moderation API | `MODERATION_DRIVER=openai` |

**Coût production :** ~0.002$/1000 tokens — négligeable en phase de lancement.

---

## 3. Pattern Adapter — principe central

Toute la stack repose sur ce pattern. Le code métier ne sait jamais quel service sous-jacent est utilisé.

```typescript
// Interface abstraite
interface StorageService {
  upload(file: Buffer, path: string): Promise<string>;
  delete(path: string): Promise<void>;
  getUrl(path: string): string;
}

// Implémentations
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

### Fichiers `.env`

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
MAP_DRIVER=mapbox MAPBOX_TOKEN=pk.xxx flutter run

# Tester MapLibre en dev
MAP_DRIVER=maplibre flutter run
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
│   ├── .env.local
│   ├── .env.staging
│   └── docker-compose.yml
├── mobile/                        # Flutter
│   ├── lib/
│   │   ├── features/
│   │   │   ├── auth/
│   │   │   ├── map/
│   │   │   ├── activities/
│   │   │   ├── matching/
│   │   │   └── chat/
│   │   ├── core/
│   │   │   ├── adapters/          # MapLibre/Mapbox adapter Flutter
│   │   │   └── services/
│   │   └── main.dart
│   └── pubspec.yaml
├── docs/                          # CDC et documentation
│   ├── selene-cdc-v4-final.md
│   └── TECHNICAL_DECISIONS.md
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
activities             (id, creator_id, sport, location GEOGRAPHY, address, datetime, level, genre_filter, max_participants, status)
activity_requests      (id, activity_id, requester_id, status, created_at)

-- Module Chat
chat_rooms             (id, activity_id, created_at)
chat_participants      (room_id, user_id)
messages               (id, room_id, sender_id, content, created_at)

-- Module Geo
-- PostGIS activé sur la colonne location → requêtes ST_DWithin, ST_Distance
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
- State management : Riverpod
- Appels API : Dio + intercepteurs (auth token, erreurs)
- Adapters cartes : abstraction `MapService` avec impl MapLibre et Mapbox

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
| State management Flutter | Riverpod vs Bloc | Sprint 1 |
| Auth social login | Google + Apple Sign-In | Sprint 1 |
| Monitoring prod | Sentry vs Datadog | Avant beta |
| CI/CD | GitHub Actions vs GitLab CI | Sprint 2 |