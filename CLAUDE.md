# Séléné — CLAUDE.md
> Mémoire technique du projet. Lu par Claude à chaque session.
> Mis à jour après chaque décision validée.

---

## Projet
Application mobile cross-platform de mise en relation sportive locale.
Géolocalisation temps réel, carte interactive, matching sportif.
iOS + Android (Flutter).

---

## Fichiers de référence actifs
- `docs/selene-cdc-v4-final.md` — cahier des charges validé (seul fichier CDC à lire)
- `docs/TECHNICAL_DECISIONS.md` — décisions techniques validées
- `CHANGELOG.md` — historique des sessions et features (@CHANGELOG.md pour contexte inter-sessions)

> Ne charger aucun autre fichier docs/ sauf si explicitement demandé.

---

## Stack technique validée

| Couche | Technologie | Notes |
|--------|-------------|-------|
| Mobile | Flutter 3.44.0 (Dart) | iOS + Android |
| Backend | NestJS + Fastify adapter | TypeScript |
| Base de données | PostgreSQL 18.4 + 3.6.3 | Une seule DB partagée |
| Cache / Pub-Sub | Redis 8.6.3 | Sessions, rate limiting |
| Temps réel | Socket.io (NestJS Gateway) | Chat + carte live |
| Stockage (dev) | MinIO (Docker) | Compatible S3 |
| Stockage (prod) | Cloudflare R2 | 10 GB gratuit, zone EU |
| Cartes | MapLibre + Mapbox (parallèle) | Free tier Mapbox 50K/mois |
| Routing/Isochrones (dev) | OSRM (Docker) | Gratuit |
| Routing/Isochrones (prod) | Mapbox Isochrone API | Free tier |
| OTP (dev) | Mock logs | mock INTERDIT en staging/prod |
| OTP (prod) | Twilio | ~0.08$/SMS France |
| Push (dev) | Mock logs | — |
| Push (prod) | FCM + APNs | Gratuits |
| Modération (dev) | Mock | — |
| Modération (prod) | OpenAI Moderation API | DPA requis avant prod |

## Environnement développeur
- OS : Ubuntu
- Test mobile : iPhone (iOS) + Android
- Containerisation : Docker Compose (backend + DB + Redis + MinIO + OSRM)
- Flutter tourne en dehors de Docker
- Node.js : 24 LTS
- Flutter : 3.44.0 (Impeller engine, null safety strict)

## Principe architectural central — Pattern Adapter
Changer de service = modifier 1 variable `.env`. Zéro changement code métier.

```
STORAGE_DRIVER=minio|r2
MAP_DRIVER=maplibre|mapbox
OTP_DRIVER=mock|twilio        ← mock INTERDIT en staging/prod
PUSH_DRIVER=mock|fcm
MODERATION_DRIVER=mock|openai
ROUTING_DRIVER=osrm|mapbox
```

## Architecture backend — Modules NestJS

| Module | Responsabilités | Dépend de |
|--------|----------------|-----------|
| `AuthModule` | JWT RS256, OTP, biométrie, refresh tokens | `UsersModule` |
| `UsersModule` | Profils, photos, trust score | — |
| `ActivitiesModule` | CRUD activités, filtres sportifs | `UsersModule`, `GeoModule` |
| `MatchingModule` | Demandes, acceptation, matching | `ActivitiesModule`, `NotificationsModule` |
| `ChatModule` | WebSocket chat, historique messages | `MatchingModule` |
| `NotificationsModule` | Push FCM/APNs, in-app | `UsersModule` |
| `GeoModule` | Géolocalisation, isochrones, cache Redis | — |
| `ModerationModule` | Signalements, blocages, modération IA | `UsersModule` |
| `AdaptersModule` | Pattern Adapter (Storage, Map, OTP...) | — |

**Règle d'isolation :** aucun module n'importe les repositories d'un autre module.

## Architecture mobile — Flutter

- Feature-first (un dossier par feature)
- State management : Riverpod avec code generation (@riverpod)
- Navigation : GoRouter (routing déclaratif, deep links, auth guards)
- Appels API : Dio + intercepteurs (auth token, refresh automatique)
- Flavors : dev / staging / prod
- MapService abstrait → impl MapLibreMapService + MapboxMapService

## Structure du projet

```
selene/
├── .claude/
│   └── agents/
│       ├── cdc/               # Agents review documents produit
│       │   ├── architect-tech-1.md
│       │   ├── architect-tech-2.md
│       │   ├── expert-ux.md
│       │   ├── expert-business.md
│       │   ├── expert-security.md
│       │   └── expert-pro.md
│       └── dev/               # Agents review code
│           ├── review-backend.md
│           ├── review-mobile.md
│           ├── review-database.md
│           ├── review-infra.md
│           ├── review-security.md
│           ├── review-test.md
│           ├── review-api.md
│           └── review-pro.md
├── backend/                   # NestJS + Fastify
├── mobile/                    # Flutter 3.44.0
├── docs/
│   ├── selene-cdc-v4-final.md
│   └── TECHNICAL_DECISIONS.md
├── CHANGELOG.md               # Historique sessions + features
├── CLAUDE.md
└── README.md
```

---

## Agents disponibles

### Agents CDC — `.claude/agents/cdc/`
Utilisés pour reviewer des **documents produit**.

| Agent | Spécialité | Condition |
|-------|-----------|-----------|
| `architect-tech-1` | Backend, DB, temps réel, géoloc | `ARCHITECT_TECH1_OK ✅` |
| `architect-tech-2` | Mobile, Maps, frontend, push | `ARCHITECT_TECH2_OK ✅` |
| `expert-ux` | Parcours utilisateur, écrans, UX | `EXPERT_UX_OK ✅` |
| `expert-business` | Modèle éco, roadmap, monétisation | `EXPERT_BUSINESS_OK ✅` |
| `expert-security` | RGPD, modération, anti-fake | `EXPERT_SECURITY_OK ✅` |
| `expert-pro` | Validation finale globale document | `EXPERT_PRO_OK ✅` |

### Agents Dev — `.claude/agents/dev/`
Utilisés pour reviewer du **code**.

| Agent | Spécialité | Condition |
|-------|-----------|-----------|
| `review-backend` | NestJS, DTOs, guards, logique métier | `REVIEW_BACKEND_OK ✅` |
| `review-mobile` | Flutter, Riverpod, GoRouter, cartes | `REVIEW_MOBILE_OK ✅` |
| `review-database` | PostgreSQL, PostGIS, migrations TypeORM | `REVIEW_DATABASE_OK ✅` |
| `review-infra` | Docker Compose, CI/CD, variables d'env | `REVIEW_INFRA_OK ✅` |
| `review-security` | JWT, secrets, validation inputs, RGPD | `REVIEW_SECURITY_OK ✅` |
| `review-test` | Tests unitaires, e2e, couverture | `REVIEW_TEST_OK ✅` |
| `review-api` | Contrat REST, OpenAPI, DTOs | `REVIEW_API_OK ✅` |
| `review-pro` | Validation finale globale code | `REVIEW_PRO_OK ✅` |

**Règles d'ordre :**
- `review-security` → toujours après les autres agents dev
- `review-pro` → toujours en dernier, après tous les OK

---

## Workflows agents

### Workflow A — Validation document technique
*TECHNICAL_DECISIONS, spec architecture, ADR*

```
architect-tech-1 + architect-tech-2 + expert-security (parallèle)
  → 3 OK simultanés
  → expert-pro
  → EXPERT_PRO_OK ✅
```

### Workflow B — Validation CDC / spec produit complète

```
Phase 1 : architect-tech-1 + architect-tech-2 (parallèle)
  → ARCHITECT_TECH1_OK + ARCHITECT_TECH2_OK
Phase 2 : expert-ux + expert-business + expert-security (parallèle)
  → EXPERT_UX_OK + EXPERT_BUSINESS_OK + EXPERT_SECURITY_OK
Phase 3 : expert-pro → EXPERT_PRO_OK ✅
```

### Workflow C — Review feature complète (backend + mobile + DB)
*Sprint complet : module NestJS + feature Flutter + schéma*

```
review-backend + review-mobile + review-database + review-api (parallèle)
  → 4 OK simultanés
  → review-infra (si docker/CI modifié)
  → review-security
  → review-test
  → review-pro → REVIEW_PRO_OK ✅
```

### Workflow D — Review backend seul

```
review-backend + review-api (parallèle)
  → review-security → review-test → review-pro → REVIEW_PRO_OK ✅
```

### Workflow E — Review infra seul

```
review-infra → review-security → review-pro → REVIEW_PRO_OK ✅
```

### Workflow F — Review feature spécifique
Invoquer uniquement les agents dont la zone est impactée.
Toujours terminer par review-security → review-pro si changement structurant.

---

## Règles de versioning

- Sauvegarder avant toute modification suite à un feedback agent
- Ne jamais écraser une version précédente
- Format : `docs/{nom-fichier}-v{N}-{etape}.md`
- Après chaque feature terminée → mettre à jour `CHANGELOG.md`

---

## Règle de rebouclage

Toute correction appliquée → renvoyer aux agents concernés pour recheck.
Ne jamais passer à la phase suivante sans tous les OK simultanés.

---

## Historique des validations

| Document | Version | Statut |
|----------|---------|--------|
| Cahier des charges | `docs/selene-cdc-v4-final.md` | ✅ EXPERT_PRO_OK |
| Décisions techniques | `docs/TECHNICAL_DECISIONS.md` | ✅ EXPERT_PRO_OK |

---

## Règle de fin de workflow

Une fois tous les OK obtenus (REVIEW_PRO_OK ou EXPERT_PRO_OK) :

1. Mettre à jour CHANGELOG.md avec :
   - La date du jour
   - Le nom du sprint / feature
   - Les fichiers créés ou modifiés
   - Les agents qui ont validé + leur OK
   - Les points de vigilance documentés

2. Commit git avec message conventionnel :
   - `feat:` nouvelle feature
   - `docs:` documentation
   - `chore:` setup, config
   - `fix:` correction

---

## Langue
Tout le code, les commentaires et la documentation sont en français.
Les agents communiquent en français.