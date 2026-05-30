# 🌙 Séléné

> Application mobile cross-platform de mise en relation sportive locale.

[![Status](https://img.shields.io/badge/status-in%20development-yellow)](https://github.com)
[![Platform](https://img.shields.io/badge/platform-iOS%20%7C%20Android-blue)](https://github.com)
[![License](https://img.shields.io/badge/license-proprietary-red)](./LICENSE)

---

## Concept

Séléné n'est pas une app de swipe. C'est une **carte interactive géolocalisée** qui connecte les sportifs autour d'eux en temps réel.

Tu vois autour de toi des activités sportives publiées par d'autres utilisateurs — un match de tennis à 500m, un groupe de running dans le parc, un 5-à-side ce soir à 20h. Tu demandes à rejoindre. Le créateur accepte. Le match se fait.

---

## Fonctionnalités clés

- 🗺️ **Carte interactive** — activités sportives géolocalisées autour de soi avec icônes par sport
- 🔍 **Filtres avancés** — sport, distance, temps de trajet, genre, niveau, disponibilité
- 🤝 **Matching sportif** — demande → notification → acceptation → chat → match
- 💬 **Chat temps réel** — ouvert uniquement après validation mutuelle
- 📍 **Recherche par rayon ou temps de trajet** — 10/20/30 min, à pied/vélo/voiture/transport
- 🏟️ **Événements sportifs** — publics ou privés, gestion des participants
- 👥 **Groupes sportifs** — création et gestion de communautés locales
- 🔔 **Notifications push** — temps réel, FCM/APNs
- 🏅 **Gamification** — badges, score d'activité, réputation

---

## Inscription en deux niveaux

| Mode invité | Compte complet |
|-------------|---------------|
| Âge, genre, pseudo | Email + téléphone + OTP |
| Accès lecture carte | Photo + profil complet |
| Demande de rejoindre | Obligatoire après 1er match validé |

---

## Stack technique

| Couche | Technologie | Notes |
|--------|-------------|-------|
| Mobile | Flutter 3.44.0 (Dart) | iOS + Android |
| Backend | NestJS + Fastify adapter | TypeScript, Node.js 24 LTS |
| Base de données | PostgreSQL 18 + PostGIS 3.6 | Géospatial natif |
| Cache & temps réel | Redis 8.6 + Socket.io | Sessions, chat live |
| Cartes | MapLibre + Mapbox (parallèle) | Free tier 50K loads/mois |
| Routing/Isochrones | OSRM (dev) → Mapbox (prod) | Temps de trajet |
| Auth | OTP + JWT RS256 + Biométrie | Flutter Secure Storage |
| Push notifications | FCM + APNs | Gratuits |
| Stockage | MinIO (dev) → Cloudflare R2 (prod) | Zone EU, buckets privés |
| Containerisation | Docker Compose | Dev local |

---

## Structure du projet

```
selene/
├── .claude/
│   └── agents/
│       ├── cdc/                   # Agents review documents produit
│       │   ├── architect-tech-1.md
│       │   ├── architect-tech-2.md
│       │   ├── expert-ux.md
│       │   ├── expert-business.md
│       │   ├── expert-security.md
│       │   └── expert-pro.md
│       └── dev/                   # Agents review code
│           ├── review-backend.md
│           ├── review-mobile.md
│           ├── review-database.md
│           ├── review-infra.md
│           ├── review-security.md
│           ├── review-test.md
│           ├── review-api.md
│           └── review-pro.md
├── backend/                       # NestJS + Fastify
├── mobile/                        # Flutter 3.44.0
├── docs/
│   ├── selene-cdc-v4-final.md     # CDC validé (6 agents)
│   └── TECHNICAL_DECISIONS.md    # Décisions techniques validées (4 agents)
├── CHANGELOG.md                   # Historique sessions + features
├── CLAUDE.md                      # Mémoire technique projet
└── README.md
```

---

## Cahier des charges

Produit via un workflow multi-agents Claude Code (6 agents, 4 phases) :

```
Main Agent → v1
  → architect-tech-1 (backend/infra)   ┐ Phase 1
  → architect-tech-2 (mobile/maps)     ┘ consensus à 3 requis
  → expert-ux (parcours/écrans)        ┐
  → expert-business (modèle éco)       │ Phase 2
  → expert-security (RGPD/modération)  ┘ 3 OK simultanés requis
  → expert-pro (validation finale)       Phase 3
```

Résultat : `docs/selene-cdc-v4-final.md` — EXPERT_PRO_OK ✅

---

## Roadmap

### MVP (Sprint 1–6)
- [ ] Authentification invité + compte complet (OTP + JWT)
- [ ] Carte interactive + publication d'activité (PostGIS + MapLibre/Mapbox)
- [ ] Système de demande / acceptation / refus
- [ ] Chat post-match (Socket.io temps réel)
- [ ] Notifications push (FCM + APNs)
- [ ] Filtres de base (sport, distance, temps de trajet)

### V2
- [ ] Événements sportifs & groupes
- [ ] Recommandations IA (matching par habitudes sportives)
- [ ] Gamification complète (badges, score, leaderboard)
- [ ] Modèle premium + publicité locale sportive
- [ ] Partenariats salles de sport

---

## Modèle économique

- **Freemium** — fonctionnalités de base gratuites
- **Premium** — filtres avancés, visibilité boostée, stats
- **Publicité locale sportive** — ciblée géographiquement
- **Partenariats** — salles de sport, clubs, équipementiers

---

## Sécurité & conformité

- RGPD — consentement explicite, droit à l'oubli, données minimales
- Géolocalisation — foreground only, zone approximative en mode invité
- Anti-fake — vérification OTP, Trust Score, device fingerprinting
- Modération — système de report, blocage, SLA défini
- JWT RS256 — access token 15 min, refresh token 7 jours, blacklist Redis
- Buckets privés — URLs pré-signées, zone EU (Cloudflare R2)

---

## Démarrage sur une nouvelle machine

### Prérequis
- Docker + Docker Compose v2
- Git
- Ubuntu (pour le script de setup mobile)

### 1. Cloner et configurer l'environnement mobile

```bash
git clone <url-du-repo> selene
cd selene

bash scripts/setup-mobile-env.sh   # Flutter 3.44.0 + Android SDK + Chromium
source ~/.bashrc
```

### 2. Configurer les variables d'environnement

```bash
# Docker Compose (credentials, ports)
cp .env.example .env
# Éditer .env : DB_PASSWORD, REDIS_PASSWORD (min 16 car.), MINIO_ACCESS_KEY, MINIO_SECRET_KEY

# NestJS backend (drivers, URLs internes)
cp backend/.env.example backend/.env.local
# Éditer backend/.env.local : mêmes DB_PASSWORD, REDIS_PASSWORD, MINIO_ACCESS_KEY, MINIO_SECRET_KEY
```

### 3. Générer les clés JWT

```bash
bash scripts/generate-jwt-keys.sh
# Crée backend/keys/jwt_private.pem et jwt_public.pem
```

### 4. Démarrer les services

```bash
make up

# Vérification
make ps
curl http://localhost:3000/api/v1/health   # → {"status":"ok"}
```

### 5. Lancer l'app Flutter

```bash
cd mobile

# Émulateur Android
flutter run --flavor dev --dart-define=APP_ENV=dev --dart-define=MAP_DRIVER=maplibre

# iPhone physique (remplacer l'IP par celle de la machine de dev)
flutter run --flavor dev \
  --dart-define=APP_ENV=dev \
  --dart-define=MAP_DRIVER=maplibre \
  --dart-define=BACKEND_URL=http://192.168.x.x:3000
```

> Fichiers non versionnés à créer manuellement : `.env`, `backend/keys/`

---

## Développement avec Claude Code

### Démarrage de session

À chaque nouvelle session ou après `/clear` :

```
@CHANGELOG.md @docs/TECHNICAL_DECISIONS.md

[ta tâche ici]
```

### Agents disponibles

**Agents CDC** (`.claude/agents/cdc/`) — review de documents produit
**Agents Dev** (`.claude/agents/dev/`) — review de code

Voir `CLAUDE.md` pour les workflows complets.

---

## Nom & identité

**Séléné** — déesse grecque de la Lune.
Symbole de présence, de lumière locale, de cycles et de rencontres sportives.
Cohérent avec une app de géolocalisation qui illumine l'activité sportive autour de soi.

---

## Licence

Propriétaire — tous droits réservés.