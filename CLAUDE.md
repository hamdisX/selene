# Séléné — CLAUDE.md
> Mémoire technique du projet. Lu par Claude à chaque session.
> Mis à jour après chaque décision validée.

---

## Projet
Application mobile cross-platform de mise en relation sportive locale.
Géolocalisation temps réel, carte interactive, matching sportif.
iOS + Android (Flutter).

**Cahier des charges :** `docs/selene-cdc-v4-final.md` (validé — 6 agents, 4 phases)
**Décisions techniques :** `docs/TECHNICAL_DECISIONS.md` (validé — voir workflow ci-dessous)

---

## Stack technique validée

| Couche | Technologie | Notes |
|--------|-------------|-------|
| Mobile | Flutter (Dart) | iOS + Android |
| Backend | NestJS + Fastify adapter | TypeScript |
| Base de données | PostgreSQL 15 + PostGIS | Une seule DB partagée |
| Cache / Pub-Sub | Redis | Sessions, rate limiting |
| Temps réel | Socket.io (NestJS Gateway) | Chat + carte live |
| Stockage (dev) | MinIO (Docker) | Compatible S3 |
| Stockage (prod) | Cloudflare R2 | 10 GB gratuit |
| Cartes | MapLibre + Mapbox (parallèle) | Free tier Mapbox 50K/mois |
| Routing/Isochrones (dev) | OSRM (Docker) | Gratuit |
| Routing/Isochrones (prod) | Mapbox Isochrone API | Free tier |
| OTP (dev) | Mock logs | Code affiché dans le terminal |
| OTP (prod) | Twilio | ~0.08$/SMS France |
| Push (dev) | Mock logs | — |
| Push (prod) | FCM + APNs | Gratuits |
| Modération (dev) | Mock (accepte tout) | — |
| Modération (prod) | OpenAI Moderation API | — |

## Environnement développeur
- OS : Ubuntu
- Test mobile : iPhone (iOS) + Android
- Containerisation : Docker Compose (backend + DB + Redis + MinIO + OSRM)
- Flutter tourne en dehors de Docker

## Principe architectural central — Pattern Adapter
Obligatoire pour tous les services externes.
Changer de service = modifier 1 variable `.env`. Zéro changement code métier.

```
STORAGE_DRIVER=minio|r2
MAP_DRIVER=maplibre|mapbox
OTP_DRIVER=mock|twilio
PUSH_DRIVER=mock|fcm
MODERATION_DRIVER=mock|openai
ROUTING_DRIVER=osrm|mapbox
```

## Architecture backend
- Un module NestJS par domaine métier
- Modules : auth / users / activities / matching / chat / notifications / geo / moderation / adapters
- Aucun module n'accède aux tables d'un autre module
- Validation stricte via class-validator + DTOs

## Architecture mobile (Flutter)
- Feature-first (un dossier par feature)
- State management : Riverpod
- Appels API : Dio + intercepteurs
- MapService abstrait avec impl MapLibre + Mapbox

## Structure du projet
```
selene/
├── .claude/
│   └── agents/
│       ├── architect-tech-1.md   # Backend / DB / temps réel / géoloc
│       ├── architect-tech-2.md   # Mobile / Maps / frontend / push
│       ├── expert-ux.md          # Parcours utilisateur / UX mobile
│       ├── expert-business.md    # Modèle économique / roadmap
│       ├── expert-security.md    # RGPD / modération / sécurité
│       └── expert-pro.md         # Validation finale globale
├── backend/                      # NestJS + Fastify
├── mobile/                       # Flutter
├── docs/
│   ├── selene-cdc-v4-final.md
│   └── TECHNICAL_DECISIONS.md
├── CLAUDE.md
└── README.md
```

---

## Agents disponibles

Les agents vivent dans `.claude/agents/`. Ils sont invoqués explicitement
par le Main Agent selon le contexte. Chaque agent a une spécialité stricte
et un critère de validation binaire (OK ou DEMANDE_CORRECTIONS).

### architect-tech-1
**Spécialité :** Backend, base de données, temps réel, géolocalisation
**Zone de compétence :**
- Choix backend (NestJS, Fastify, langages)
- PostgreSQL + PostGIS (schéma, requêtes géospatiales, index)
- Redis (stratégie cache, pub/sub, sessions)
- Socket.io (architecture WebSocket, rooms, events)
- Pattern Adapter (implémentation backend)
- Scalabilité infra, Docker Compose, coûts cloud

**Quand l'invoquer :**
- Review de TECHNICAL_DECISIONS.md sections backend
- Création ou modification du schéma de base de données
- Architecture d'un nouveau module NestJS
- Questions de performance ou scalabilité backend

**Condition de validation :** `ARCHITECT_TECH1_OK ✅`

---

### architect-tech-2
**Spécialité :** Mobile, cartes, frontend, push notifications
**Zone de compétence :**
- Flutter (architecture, state management Riverpod, navigation)
- MapLibre et Mapbox (intégration, performance, offline)
- FCM + APNs (configuration, deep links, payload)
- OSRM + Mapbox Isochrone (calcul de zones temps de trajet)
- Pattern Adapter côté mobile (MapService, PushService)
- Performance mobile (battery, cache, offline mode)

**Quand l'invoquer :**
- Review de TECHNICAL_DECISIONS.md sections mobile
- Architecture d'une nouvelle feature Flutter
- Choix de librairie mobile
- Problèmes de performance ou de rendu carte

**Condition de validation :** `ARCHITECT_TECH2_OK ✅`

---

### expert-ux
**Spécialité :** Parcours utilisateur, écrans, UX mobile
**Zone de compétence :**
- Fluidité des parcours (invité → inscription → match → chat)
- Ergonomie de la carte interactive et des filtres
- Friction points dans les formulaires et permissions
- Cohérence entre personas et comportements attendus
- Gamification (badges, score, rétention)

**Quand l'invoquer :**
- Design d'un nouveau parcours utilisateur
- Review d'une spec d'écran ou d'un flow
- Ajout d'une feature impactant l'onboarding
- Questions de rétention ou d'engagement

**Condition de validation :** `EXPERT_UX_OK ✅`

---

### expert-business
**Spécialité :** Modèle économique, roadmap, monétisation
**Zone de compétence :**
- Viabilité du modèle freemium
- Projections financières et point mort
- Stratégie d'acquisition et masse critique géographique
- Roadmap MVP → V2 (priorisation, scope)
- Partenariats et publicité locale sportive

**Quand l'invoquer :**
- Révision du modèle économique
- Ajout d'une feature premium
- Décisions de priorisation roadmap
- Stratégie de lancement ou de croissance

**Condition de validation :** `EXPERT_BUSINESS_OK ✅`

---

### expert-security
**Spécialité :** Sécurité, RGPD, modération, anti-fake
**Zone de compétence :**
- Mapping bases légales RGPD + DPIA
- Gestion des secrets et variables d'environnement
- Authentification (JWT, OTP, biométrie)
- Anti-fake (Trust Score, device fingerprinting)
- Modération (signalement, blocage, SLA)
- Protection des mineurs et anti-harcèlement

**Quand l'invoquer :**
- Review de TECHNICAL_DECISIONS.md sections sécurité
- Toute feature touchant à l'auth ou aux données personnelles
- Implémentation d'un nouvel adapter (secrets exposés ?)
- Ajout d'une feature de mise en relation

**Condition de validation :** `EXPERT_SECURITY_OK ✅`

---

### expert-pro
**Spécialité :** Validation finale globale (regard externe indépendant)
**Zone de compétence :**
- Cohérence globale du document soumis
- Faisabilité pour une startup early-stage
- Risques cachés non identifiés par les autres agents
- Qualité niveau dossier incubateur / investisseur

**Quand l'invoquer :**
- Uniquement après tous les OK des agents concernés
- Validation finale d'un document (CDC, TECHNICAL_DECISIONS, spec feature)
- Jamais en première passe — toujours en dernier verrou

**Condition de validation :** `EXPERT_PRO_OK ✅`

---

## Workflows agents

### Workflow A — Validation document technique
*Utilisé pour : TECHNICAL_DECISIONS.md, spec d'architecture, ADR*

```
Soumettre le document à architect-tech-1 + architect-tech-2 + expert-security
  → en parallèle
  → corrections jusqu'aux 3 OK simultanés
  → puis expert-pro pour validation finale
```

Conditions requises :
```
ARCHITECT_TECH1_OK + ARCHITECT_TECH2_OK + EXPERT_SECURITY_OK → expert-pro → EXPERT_PRO_OK
```

---

### Workflow B — Validation cahier des charges / spec produit
*Utilisé pour : CDC, spec feature complète*

```
Phase 1 : architect-tech-1 + architect-tech-2 (parallèle)
  → ARCHITECT_TECH1_OK + ARCHITECT_TECH2_OK
Phase 2 : expert-ux + expert-business + expert-security (parallèle)
  → EXPERT_UX_OK + EXPERT_BUSINESS_OK + EXPERT_SECURITY_OK
Phase 3 : expert-pro
  → EXPERT_PRO_OK
```

---

### Workflow C — Review feature spécifique
*Utilisé pour : une nouvelle feature, un module, un écran*

Invoquer uniquement les agents dont la zone est impactée :
- Feature backend uniquement → architect-tech-1 + expert-security
- Feature mobile uniquement → architect-tech-2 + expert-ux
- Feature avec impact business → + expert-business
- Validation finale → expert-pro si changement structurant

---

## Règles de versioning

Avant chaque modification suite à un feedback agent :
- Sauvegarder la version actuelle dans `docs/`
- Ne jamais écraser une version précédente
- Format : `docs/{nom-fichier}-v{N}-{etape}.md`

Exemple pour TECHNICAL_DECISIONS.md :
```
docs/TECHNICAL_DECISIONS-v1-initial.md
docs/TECHNICAL_DECISIONS-v2-post-architects.md
docs/TECHNICAL_DECISIONS-v3-final.md
```

---

## Règle de rebouclage

Toute correction appliquée → renvoyer aux agents concernés pour recheck.
Ne jamais passer à la phase suivante sans tous les OK simultanés.
Un agent peut signer OK uniquement si toutes ses objections sont fermées.

---

## Historique des validations

| Document | Version finale | Statut |
|----------|---------------|--------|
| Cahier des charges | `docs/selene-cdc-v4-final.md` | ✅ EXPERT_PRO_OK |
| TECHNICAL_DECISIONS.md | `docs/TECHNICAL_DECISIONS-v3-final.md` | ✅ EXPERT_PRO_OK |

---

## Langue
Tout le code, les commentaires et la documentation sont en français.
Les agents communiquent en français.

## Fichiers de référence actifs
- `docs/selene-cdc-v4-final.md` — seul fichier CDC à lire
- `docs/TECHNICAL_DECISIONS.md` — décisions techniques

> Les fichiers v1/v2/v3 sont des archives historiques.
> Ne pas les charger sauf si explicitement demandé