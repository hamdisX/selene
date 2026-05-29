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

| Couche | Technologie |
|--------|-------------|
| Mobile | React Native (Expo) |
| Backend | Node.js / NestJS |
| Base de données | PostgreSQL + PostGIS |
| Cache & temps réel | Redis + WebSocket |
| Maps | Mapbox |
| Auth | OTP + JWT + Biométrie |
| Push notifications | FCM + APNs |
| Storage | AWS S3 |
| Infra | AWS (ECS / RDS / ElastiCache) |

---

## Structure du projet

```
selene/
├── .claude/
│   └── agents/
│       ├── architect-tech-1.md    # Backend / DB / temps réel / géoloc
│       ├── architect-tech-2.md    # Mobile / Maps / frontend / push
│       ├── expert-ux.md           # Parcours utilisateur / UX mobile
│       ├── expert-business.md     # Modèle économique / roadmap
│       ├── expert-security.md     # RGPD / modération / anti-fake
│       └── expert-pro.md          # Validation finale globale
├── docs/
│   ├── selene-cdc-v1-initial.md
│   ├── selene-cdc-v2-post-architects.md
│   ├── selene-cdc-v3-post-experts.md
│   └── selene-cdc-v4-final.md
├── CLAUDE.md
└── README.md
```

---

## Cahier des charges

Le CDC complet est produit via un workflow multi-agents Claude Code :

```
Main Agent → v1
  → Architect-Tech-1 (backend/infra)   ┐ Phase 1
  → Architect-Tech-2 (mobile/maps)     ┘ consensus à 3 requis
  → Expert-UX (parcours/écrans)        ┐
  → Expert-Business (modèle éco)       │ Phase 2
  → Expert-Security (RGPD/modération)  ┘ 3 OK simultanés requis
  → Expert-Pro (validation finale)       Phase 3
```

Versioning automatique à chaque phase — voir `docs/`.

---

## Roadmap

### MVP (Sprint 1–6)
- [ ] Authentification invité + compte complet
- [ ] Carte interactive + publication d'activité
- [ ] Système de demande / acceptation / refus
- [ ] Chat post-match
- [ ] Notifications push
- [ ] Filtres de base

### V2
- [ ] Événements sportifs & groupes
- [ ] Recommandations IA (matching par habitudes)
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
- Géolocalisation — zone approximative uniquement en mode invité
- Anti-fake — vérification OTP, détection comportements suspects
- Modération — système de report, blocage, équipe dédiée
- Chiffrement — bout en bout sur le chat, HTTPS partout

---

## Nom & identité

**Séléné** — déesse grecque de la Lune.  
Symbole de présence, de lumière locale, de cycles et de rencontres nocturnes comme diurnes. Cohérent avec une app de géolocalisation qui illumine l'activité sportive autour de soi.

---

## Licence

Propriétaire — tous droits réservés.