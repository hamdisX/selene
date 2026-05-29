# SÉLÉNÉ — Cahier des Charges Complet
## Application Mobile de Mise en Relation Sportive Locale

---

| Champ            | Valeur                                            |
|------------------|---------------------------------------------------|
| **Produit**      | Séléné                                            |
| **Version**      | 1.1 — Post-Review Architects                      |
| **Date**         | 29 mai 2026                                       |
| **Statut**       | Draft corrigé — Resoumission Architects           |
| **Confidentialité** | Confidentiel — Usage interne                   |
| **Auteur**       | Équipe Produit Séléné                             |

---

## TABLE DES MATIÈRES

1. [Vision Produit & Proposition de Valeur](#1)
2. [Positionnement & Analyse Concurrentielle](#2)
3. [Personas Utilisateurs](#3)
4. [Concept & Logique Métier](#4)
5. [Système d'Inscription en 2 Niveaux](#5)
6. [Parcours Utilisateurs Détaillés](#6)
7. [User Stories](#7)
8. [Fonctionnalités MVP](#8)
9. [Fonctionnalités V2](#9)
10. [Architecture Technique](#10)
11. [Schéma Base de Données](#11)
12. [APIs & Endpoints](#12)
13. [Temps Réel & Chat](#13)
14. [Sécurité & RGPD](#14)
15. [Modération & Anti-Fraude](#15)
16. [Analytics & Admin Panel](#16)
17. [Modèle Freemium & Monétisation](#17)
18. [Gamification & Rétention](#18)
19. [Matching Intelligent (IA)](#19)
20. [Diagrammes Fonctionnels](#20)
21. [Structure Écrans & Navigation](#21)
22. [UX/UI — Design System 2026](#22)
23. [Roadmap Technique — Sprint par Sprint](#23)
24. [Estimation Complexité & Coûts](#24)
25. [Équipe Nécessaire](#25)
26. [Stratégie Croissance & Rétention](#26)

---

## 1. VISION PRODUIT & PROPOSITION DE VALEUR

### 1.1 Vision

> **"Séléné connecte les sportifs locaux en temps réel autour d'une carte vivante de leur ville."**

Séléné est une application mobile qui résout un problème universel et quotidien : trouver des partenaires sportifs disponibles, à proximité, maintenant. Le cœur du produit n'est pas un système de swipe. C'est une **carte interactive vivante** où chaque point représente une activité sportive réelle publiée par un humain.

### 1.2 Proposition de Valeur Unique

**Tagline :** *"Ton sport. Ta ville. Maintenant."*

| Problème | Solution Séléné |
|----------|-----------------|
| Pas de partenaire disponible | Carte temps réel des activités proches |
| Inscription longue et décourageante | Mode invité 30 secondes, inscription après valeur |
| Distance en km ne reflète pas la réalité | Filtres par temps de trajet (10/20/30 min, 4 modes) |
| Applications trop engageantes | Outil pur, action sportive immédiate |

### 1.3 KPIs Produit

| Métrique | Cible MVP (6 mois) | Cible V2 (18 mois) |
|----------|--------------------|--------------------|
| MAU | 5 000 | 50 000 |
| Activités publiées / jour | 200 | 3 000 |
| Taux invité → membre | 40 % | 55 % |
| Taux match accepté / demande | 60 % | 70 % |
| Rétention J7 | 35 % | 50 % |
| NPS | > 40 | > 60 |

---

## 2. POSITIONNEMENT & ANALYSE CONCURRENTIELLE

| Application | Modèle | Limite vs Séléné |
|-------------|--------|------------------|
| Meetup | Événements communautaires | Pas temps réel, pas sportif-first |
| Strava | Tracking performance | Pas de matching, pas d'organisation |
| Playtomic | Réservation courts | Lié aux installations, pas de matching humain |
| Facebook Groups | Groupes locaux | Généraliste, pas de carte |
| Just-Play | Squash/padel | Très niche, peu de villes |

**Avantages différenciants Séléné :**
1. Carte interactive temps réel avec isochrones (temps de trajet)
2. Friction zéro (mode invité)
3. Inscription progressive (engagement après valeur)
4. Design mobile-native 2026
5. Matching IA sur habitudes sportives

---

## 3. PERSONAS UTILISATEURS

### Persona 1 — Léa, 26 ans, Sportive Occasionnelle
Graphiste freelance, Lyon 3ème. Running 2x/semaine, cherche partenaire tennis disponible le week-end. Réticente aux inscriptions longues. **Déclencheur :** voit 3 activités tennis samedi matin en 30 secondes (mode invité).

### Persona 2 — Marc, 34 ans, Sportif Régulier
Développeur, Paris 11ème. Organise du foot 5x5, veut recruter rapidement sans WhatsApp. **Déclencheur :** publie une activité en 60s, reçoit 2 demandes en 10 minutes.

### Persona 3 — Sophie, 41 ans, Coach Sportif
Bordeaux. Organise yoga en plein air et randonnées de groupe. Gestion inscriptions archaïque. **Déclencheur :** événement yoga visible sur la carte de 500 personnes dans son quartier.

### Persona 4 — Thomas, 22 ans, Étudiant Nouveau en Ville
Toulouse, cherche partenaires basket. Méfiant envers les apps demandant trop d'infos. **Déclencheur :** voit la carte avec icônes basketball, peut demander à rejoindre en 3 clics sans compte.

---

## 4. CONCEPT & LOGIQUE MÉTIER

### 4.1 La Carte Vivante

La carte est l'interface principale. Elle affiche en temps réel toutes les activités publiées autour de la position de l'utilisateur avec icônes sportives.

```
┌─────────────────────────────────────────┐
│  🔍  Recherche          Filtres ⚙️      │
│─────────────────────────────────────────│
│    🎾(2)    🏃(1)                       │
│                  ⚽(3)                  │
│      📍YOU           🚴(1)              │
│         🏀(1)    🎾(1)                  │
│─────────────────────────────────────────│
│  ← 5 activités dans 2km                │
└─────────────────────────────────────────┘
```

### 4.2 Flux Principal

```
CRÉATEUR → Publie activité → Visible sur carte
PARTICIPANT → Voit icône → Consulte détails → Demande à rejoindre
CRÉATEUR → Reçoit notification → Accepte/Refuse
Si accepté → Chat ouvert + Match sportif créé
```

### 4.3 Types d'Activités

| Type | Description |
|------|-------------|
| Spontanée | Aujourd'hui/demain, 1-2 joueurs manquants |
| Événement récurrent | Session hebdomadaire |
| Événement ponctuel | Tournoi, événement daté |
| Recherche partenaire | Sans date fixe |

### 4.4 Filtres

| Filtre | Options |
|--------|---------|
| Sport | Liste complète + "Tous" (multi-sélection) |
| Distance | 1/2/5/10/20 km |
| Temps de trajet | 10/20/30 min + mode transport |
| Mode transport | Marche / Vélo / Voiture / Transport public |
| Niveau | Débutant / Intermédiaire / Confirmé / Expert |
| Genre | Mixte / Hommes / Femmes |
| Date | Aujourd'hui / Cette semaine / Ce weekend |

---

## 5. SYSTÈME D'INSCRIPTION EN 2 NIVEAUX

### 5.1 Mode Invité (30 secondes)

**Données :** Âge (curseur, pas de date exacte), Genre, Pseudo

**Capacités :** Voir carte, filtrer, consulter activités, envoyer demande, recevoir push

**Restrictions :** Pas de publication, pas de chat, pas d'historique

**Persistance :** UUID device + minimal serveur pour les demandes

### 5.2 Inscription Complète (déclenchée après 1er match accepté)

**Message :** *"🎉 Ta demande a été acceptée ! Complète ton profil en 2 minutes pour accéder au chat."*

**Étapes progressives :**
1. Email → magic link
2. Téléphone → OTP SMS (Twilio, code 6 chiffres, TTL 120s)
3. Photo → modération IA (détection visage obligatoire)
4. Sports pratiqués + niveaux

**Avantages :** Chat, publication d'activités, historique, badges, score

### 5.3 Justification UX

Réduit le taux d'abandon à l'onboarding (problème n°1 des apps sociales). L'utilisateur voit la valeur AVANT d'être bloqué par un formulaire. Le déclencheur naturel (match accepté) rend l'inscription désirable.

---

## 6. PARCOURS UTILISATEURS DÉTAILLÉS

### 6.1 Parcours Invité → Premier Match

```
[Télécharge] → [Onboarding 3 slides] → [Profil invité]
→ [Demande géolocalisation] → [CARTE]
→ [Tap icône] → [Bottom sheet activité]
→ [Demander à rejoindre] → [Notification envoyée]
→ [Attente] → [Accepté] → [Modale inscription complète]
```

### 6.2 Parcours Création d'Activité

```
[Bouton + FAB] → [Sélection sport] → [Lieu]
→ [Date + Heure + Places + Niveau] → [Visibilité]
→ [Aperçu carte] → [Publier]
→ [Activité live + notifications zone]
```

### 6.3 Parcours Gestion Demandes

```
[🔔 "Théo demande à rejoindre"] → [Profil demandeur]
→ [ACCEPTER] → [Chat ouvert + Match créé]
→ [REFUSER] → [Notif envoyée]
```

---

## 7. USER STORIES

### Epic 1 — Découverte

| ID | Story | Priorité |
|----|-------|----------|
| US-001 | En tant qu'invité, je crée un profil minimal en 30s | P0 |
| US-002 | En tant qu'invité, je vois la carte géolocalisée avec activités proches | P0 |
| US-003 | En tant qu'invité, je filtre par sport et distance | P0 |
| US-004 | En tant qu'invité, je consulte les détails limités d'une activité | P0 |
| US-005 | En tant qu'invité, je filtre par temps de trajet et mode transport | P1 |

### Epic 2 — Participation

| ID | Story | Priorité |
|----|-------|----------|
| US-010 | En tant qu'invité, j'envoie une demande en 2 clics | P0 |
| US-011 | En tant qu'utilisateur, je suis notifié acceptation/refus | P0 |
| US-012 | En tant qu'utilisateur accepté, j'accède au chat | P0 |
| US-013 | En tant qu'utilisateur, je vois mon historique matchs | P1 |

### Epic 3 — Création

| ID | Story | Priorité |
|----|-------|----------|
| US-020 | En tant que membre, je publie une activité en 60s | P0 |
| US-021 | En tant que créateur, je reçois push dès qu'une demande arrive | P0 |
| US-022 | En tant que créateur, j'accepte/refuse en consultant le profil | P0 |
| US-023 | En tant que créateur, je fixe le nombre max de participants | P1 |
| US-024 | En tant que créateur, je crée des activités récurrentes | P1 |

### Epic 4 — Profil & Réputation

| ID | Story | Priorité |
|----|-------|----------|
| US-030 | En tant que membre, je crée un profil complet avec photo et sports | P0 |
| US-031 | En tant qu'utilisateur, je laisse un avis post-match | P1 |
| US-032 | En tant qu'utilisateur, je vois le score de réputation d'autrui | P1 |

### Epic 5 — Sécurité

| ID | Story | Priorité |
|----|-------|----------|
| US-050 | En tant qu'utilisateur, je signale un comportement inapproprié | P0 |
| US-051 | En tant qu'utilisateur, je bloque un autre utilisateur | P0 |
| US-052 | En tant qu'utilisatrice, je filtre les activités féminines uniquement | P1 |
| US-053 | En tant que mineur, l'app limite mes interactions | P0 |

---

## 8. FONCTIONNALITÉS MVP

- **Carte :** Mapbox interactive, géoloc, icônes sport, clustering, rayon + isochrone
- **Filtres :** sport, distance, temps de trajet (4 modes), niveau, genre, date
- **Activités :** création, liste, détail, gestion demandes, annulation
- **Matching :** demande participation, notification créateur, acceptation/refus
- **Chat :** WebSocket temps réel, messages texte, lecture confirmée, chat de groupe
- **Profil :** mode invité + inscription complète progressive
- **Push :** demande, acceptation, refus, message, rappel, annulation
- **Sécurité :** signalement, blocage, modération photo, limitation mineurs

---

## 9. FONCTIONNALITÉS V2

- Groupes sportifs (création, membres, feed, chat permanent)
- Activités récurrentes et tournois
- Recommandations IA personnalisées
- Gamification complète (badges, classements, défis)
- Intégrations Strava / Apple Health / Google Fit
- Abonnement premium in-app
- Publicité locale contextuelle
- Admin panel modération avancée (NLP)
- Matching partenaire régulier

---

## 10. ARCHITECTURE TECHNIQUE

### 10.1 Vue d'Ensemble

```
┌──────────────────────────────────────────────┐
│            CLIENTS MOBILES                   │
│         iOS (Flutter) | Android (Flutter)    │
└──────────────┬───────────────────────────────┘
               │ HTTPS/TLS 1.3 + WSS
┌──────────────▼───────────────────────────────┐
│   API GATEWAY (Nginx / AWS ALB)              │
│   Rate limiting | JWT Auth | Load balancing  │
└──────────────┬───────────────────────────────┘
               │
     ┌─────────┼──────────────┐
     ▼         ▼              ▼
┌─────────┐ ┌──────────┐ ┌──────────────┐
│REST API │ │WebSocket │ │Push Service  │
│NestJS   │ │NestJS    │ │FCM / APNs    │
│Node.js  │ │Socket.io │ │              │
└────┬────┘ └────┬─────┘ └──────────────┘
     │            │
     └─────┬──────┘
           ▼
┌────────────────────────────────────────┐
│           COUCHE DONNÉES               │
│  PostgreSQL+PostGIS | Redis | S3/R2    │
│  RDS Proxy (PgBouncer) | Read Replica  │
└────────────────────────────────────────┘
           │
           ▼
┌────────────────────────────────────────┐
│         SERVICES EXTERNES              │
│  Mapbox | Twilio | Cloudflare          │
│  OpenAI | Sentry | PostHog             │
└────────────────────────────────────────┘
```

### 10.2 Choix Frontend Mobile — Flutter vs React Native

**Décision : Flutter**

| Critère | Flutter | React Native (Expo SDK 51+) |
|---------|---------|------------------------------|
| Performance rendu carte | ★★★★★ Moteur Skia/Impeller, 60/120fps natif, overlays sans bridge | ★★★★ New Architecture (JSI/Fabric) réduit l'écart, mais bridge résiduel |
| SDK Mapbox | `mapbox_maps_flutter` v2.x (basé SDK v10+, stable depuis 2023) | `@rnmapbox/maps` v10 (mature, large communauté) — légèrement meilleur écosystème |
| Animations | ★★★★★ Flutter Animations nativement fluides | ★★★★ Reanimated 3 excellent, mais dépendance tierce |
| Recrutement (France) | ★★★ Dart = moins de candidats que TS/JS | ★★★★★ TypeScript = large pool de devs |
| Communauté Maps | ★★★ Croissante mais moins mature côté libs | ★★★★ Écosystème Maps plus établi |
| Hot reload | ★★★★★ | ★★★★★ |
| App size | ~7-10 MB (moteur embarqué) | ~5-8 MB (sans Expo Go) |
| Tests | ★★★★ Flutter Test + Integration Test | ★★★★ Jest + Detox |

**Justification du choix Flutter :**

1. **Cartes haute performance :** Les overlays animés (markers pulsants, clustering dynamique, bottom sheets sur carte) tirent parti du moteur Impeller sans bridge natif. Pour Séléné où la carte est l'interface principale, cette différence de fluidité est perceptible.
2. **Cohérence UI cross-platform :** Séléné cible une UX identique iOS/Android avec contrôle total du rendu. Flutter garantit un pixel-perfect identique, contrairement aux composants natifs React Native.
3. **Riverpod 2.x :** Le state management Flutter est mature pour les streams géographiques temps réel.

**Risque identifié et mitigation :**
- `mapbox_maps_flutter` change d'API fréquemment (version 2.x) → figer la version dans `pubspec.lock`, tester les upgrades en branche dédiée.
- Dart = frein recrutement → mitiger par documentation interne et onboarding structuré.

**Alternative acceptable :** React Native avec Expo SDK 51+ si l'équipe est majoritairement TypeScript.

### 10.3 Stack Backend (NestJS / Node.js)

**Packages clés :**
```typescript
// NestJS core
@nestjs/common, @nestjs/core, @nestjs/platform-express
@nestjs/websockets, @nestjs/platform-socket.io  // WebSocket Gateway
@nestjs/throttler      // Rate limiting
@nestjs/config         // Configuration typée
@nestjs/bull           // Queues async (notifications)

// Base de données
typeorm, pg            // PostgreSQL + TypeORM
@types/geojson         // Types géographiques

// Auth
@nestjs/jwt, passport-jwt
bcrypt                 // Hash (même sans mot de passe classique, pour tokens internes)

// Validation
class-validator, class-transformer

// Cache / Queue
ioredis, bull

// Observabilité
@sentry/node, pino     // Logging structuré
```

**Justification Socket.IO vs WebSocket natif :**

Socket.IO est retenu pour le MVP pour les raisons suivantes :
- **Reconnexion automatique** avec backoff exponentiel (critique pour mobile avec connexions instables)
- **Rooms natives** — gestion de rooms par session et par zone géographique sans implémentation custom
- **Fallback polling** — dégradation gracieuse si WSS bloqué (rare mais important)
- **NestJS Gateway** — intégration first-class avec `@WebSocketGateway`

Coût : ~15 KB de bundle supplémentaire côté client, overhead acceptable. Si l'équipe atteint 100K connexions simultanées, migration vers `ws` natif avec couche Pub/Sub custom — documenter ce seuil dans la roadmap scalabilité.

### 10.4 Géolocalisation Temps Réel — Cycle de Vie

```
MOBILE (Flutter)                   SERVEUR                    REDIS
     │                                │                          │
     │  Foreground : update toutes    │                          │
     │  les 30s si delta > 50m        │                          │
     │──── PATCH /users/me/location ─►│                          │
     │     { lat, lng, accuracy }     │                          │
     │                                │── SET user:loc:{id} ────►│
     │                                │   { lat, lng, ts }       │
     │                                │   TTL: 300s (5 min)      │
     │                                │                          │
     │  Background : STOP (iOS)       │                          │
     │  ou geofencing léger           │                          │
     │                                │                          │
     │  App killed / 5 min inactif    │                          │
     │                                │   TTL expire →           │
     │                                │   User absent de carte   │
```

**Règles :**
- Mise à jour serveur uniquement si delta > 50 mètres (évite les writes inutiles)
- Redis TTL 300 secondes : si pas d'update depuis 5 min → utilisateur retiré de la carte temps réel
- PostgreSQL `last_location` mis à jour uniquement à 1 km de delta (persistance long terme)
- La position n'est **jamais** stockée en historique sans consentement explicite

**Stratégie iOS background location :**
- Mode retenu : **"When In Use"** uniquement (pas de "Always")
- Justification : Séléné n'a pas besoin de tracker l'utilisateur en permanence. Les alertes proactives ("une session démarre près de vous") seront implémentées via push notifications FCM ciblées, pas via background location.
- Avantage : évite le formulaire de revue étendue Apple Store, évite la consommation batterie continue
- Limitation : si l'app est en background, la position n'est plus envoyée. La carte d'autrui ne reflète pas la position exacte. Comportement documenté dans l'UX : "Votre position est mise à jour quand l'app est active."

**Stratégie Android background location :**
- Mode retenu : **géofencing léger** via `Geolocator.getPositionStream` uniquement en foreground
- En background : arrêt du stream, relance au retour en foreground
- `ACCESS_BACKGROUND_LOCATION` non demandée (évite la revue Google Play spéciale)
- Impact batterie estimé : ~3-5% de batterie/heure en utilisation active (mode foreground uniquement)

**Package Flutter :** `geolocator` ^10.0.0 (plus maintenu que `location`, supporte les deux plateformes).

### 10.5 Push Notifications — Architecture Complète

**Infrastructure :**
```
Event NestJS → Bull Queue → Worker → FCM (Android) / APNs (iOS) → Appareil
```

**Gestion des 3 états de notification :**

| État | Comportement | Implémentation Flutter |
|------|-------------|----------------------|
| **Foreground** (app ouverte) | In-app banner custom (UI Flutter) | `FirebaseMessaging.onMessage.listen()` → `flutter_local_notifications` |
| **Background** (app réduite) | Notification système standard | FCM/APNs gère automatiquement |
| **Terminated** (app fermée) | Notification système + cold start | `FirebaseMessaging.getInitialMessage()` au launch |

**Deep Linking depuis notification :**

Chaque notification contient un payload JSON structuré :
```json
{
  "type": "request_accepted",
  "data": {
    "match_id": "uuid",
    "activity_id": "uuid",
    "chat_room_id": "uuid"
  }
}
```

Routing au tap (via `go_router`) :
```dart
// Dans main.dart — gestion cold start
final message = await FirebaseMessaging.instance.getInitialMessage();
if (message != null) _handleNotificationNavigation(message);

// Gestion background tap
FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationNavigation);

void _handleNotificationNavigation(RemoteMessage message) {
  final type = message.data['type'];
  switch (type) {
    case 'request_accepted':
      router.go('/chat/${message.data['chat_room_id']}');
    case 'request_received':
      router.go('/activities/${message.data['activity_id']}/requests');
  }
}
```

Configuration requise :
- iOS : `apple-app-site-association` + entitlement `Associated Domains`
- Android : `intent-filter` avec `android:autoVerify="true"` dans `AndroidManifest.xml`

**Rotation tokens FCM :**
```dart
// Écouter les rotations de token (Firebase renouvelle silencieusement)
FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
  // Mettre à jour le token sur le serveur
  apiService.updatePushToken(newToken);
});
```

Côté serveur : table `push_tokens` avec `(user_id, token)`. Multi-device supporté (un user peut avoir iPhone + iPad). Révocation à la déconnexion : `DELETE FROM push_tokens WHERE user_id = $id AND token = $token`.

**APNs :** deux environnements distincts (sandbox dev / production). Erreur classique évitée : le CDC impose d'utiliser les certificats `.p8` (APNs Auth Key) plutôt que `.p12` (plus de renouvellement annuel).

**Permission iOS — timing :**
Demander la permission push uniquement après la 1ère action significative (après premier match accepté), pas au lancement. Taux d'opt-in cible : 55-65% (vs 43% si demandé au lancement sans contexte).

### 10.6 Mode Offline — Stratégie

**Fonctionnalités disponibles offline :**

| Fonctionnalité | Offline | Comportement |
|----------------|---------|--------------|
| Voir activités déjà chargées | ✅ | Cache Isar, dernière sync |
| Envoyer un message | ✅ (queue) | Message mis en attente, envoyé à la reconnexion |
| Créer une activité | ❌ | Message d'erreur + retry suggéré |
| Voir carte | ✅ partiel | Tuiles Mapbox en cache + markers dernière position |
| Profil utilisateur | ✅ | Cache local |

**Stockage local : Isar Database**

Choix Isar vs alternatives :
| | Isar | Hive | Drift (SQLite) |
|-|------|------|----------------|
| Performance | ★★★★★ | ★★★ | ★★★★ |
| Requêtes complexes | ★★★★ | ★★ | ★★★★★ |
| Setup | ★★★★★ | ★★★★★ | ★★★ |
| FFI overhead | 0 | 0 | Minimal |
| **Verdict** | **Choix MVP** | | Alternative |

**Collections Isar :**
- `CachedActivity` : activités chargées dans le viewport actuel (TTL 10 min)
- `PendingMessage` : messages à envoyer (sync à la reconnexion, max 50)
- `UserProfile` : profil local (sync au login)

**Stratégie de sync :**
- À la reconnexion : flush `PendingMessage` dans l'ordre chronologique
- Conflits : "last write wins" côté serveur (les activités sportives ne se modifient pas concurrentiellement)
- Indicateur UI : bannière "Mode hors ligne" + indicateur de sync en cours

### 10.7 Contraintes App Store & Google Play

**Apple App Store :**
- Délai revue : 1-3 jours (nouvelles apps avec géoloc : potentiellement jusqu'à 14 jours Extended Review)
- Compte Developer : 99 USD/an obligatoire avant soumission
- Privacy Policy : URL accessible depuis le store listing ET depuis l'app (page in-app ou WebView)
- Privacy Nutrition Labels : déclarer toutes les données collectées (position, contacts, identifiants)
- Background location : mode "When In Use" uniquement (voir section 10.4) — évite l'Extended Review
- Photos/caméra : justification obligatoire dans `NSPhotoLibraryUsageDescription` et `NSCameraUsageDescription`

**Google Play :**
- Nouveau compte : revue initiale jusqu'à 2 semaines
- Closed Testing obligatoire : 20 testeurs minimum pendant 14 jours consécutifs avant accès public
- Data Safety section : déclarer précisément les données collectées, partagées, et leur finalité
- `ACCESS_FINE_LOCATION` : permission normale (acceptée)
- `ACCESS_BACKGROUND_LOCATION` : permission spéciale, revue obligatoire — **non utilisée** dans Séléné
- Target API Level : API 34+ (Android 14) obligatoire depuis août 2024

**Planning à prévoir (Sprint 7-8) :**
- Rédiger Privacy Policy (juriste + DPO) : 1 semaine
- Remplir Data Safety (Google) et Privacy Nutrition Labels (Apple) : 2 jours
- Screenshots et assets store (6 écrans iOS + 8 écrans Android) : 2 jours
- Compte développeur + signing keystore Android : 1 jour

### 10.8 Stack Flutter — Packages Complets

```yaml
dependencies:
  # Carte
  mapbox_maps_flutter: ^2.3.0     # SDK Mapbox v10+ (NE PAS utiliser flutter_mapbox_gl, déprécié)
  
  # Géolocalisation
  geolocator: ^10.1.0
  
  # State management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0     # Code generation
  
  # Navigation
  go_router: ^13.0.0
  
  # HTTP
  dio: ^5.4.0
  
  # WebSocket
  socket_io_client: ^2.0.3
  
  # Push notifications
  firebase_messaging: ^14.7.0
  flutter_local_notifications: ^16.0.0
  
  # Stockage local
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  
  # Stockage sécurisé (JWT tokens)
  flutter_secure_storage: ^9.0.0  # Keychain iOS / EncryptedSharedPreferences Android
  
  # Biométrie
  local_auth: ^2.1.8              # Face ID / Touch ID pour actions sensibles
  
  # Upload photo
  image_picker: ^1.0.7
  
  # Internationalisation
  flutter_localizations:
    sdk: flutter
  intl: ^0.18.0
  
  # Images
  cached_network_image: ^3.3.0
  
dev_dependencies:
  riverpod_generator: ^2.3.0
  build_runner: ^2.4.0
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
```

**Sécurité mobile — Stockage des tokens JWT :**
- `flutter_secure_storage` utilise le **Keychain iOS** et **EncryptedSharedPreferences Android**
- Les tokens JWT ne sont JAMAIS stockés dans `SharedPreferences` (non chiffré)
- Rotation des refresh tokens : à chaque renouvellement, l'ancien refresh token est invalidé côté serveur (token family rotation)
- `local_auth` pour Face ID / Touch ID : proposé optionnellement sur les actions sensibles (confirmation de participation à 5+ personnes, suppression de compte)

**Accessibilité et UX technique :**
- `Semantics` widgets sur tous les éléments interactifs (support VoiceOver iOS / TalkBack Android)
- `HapticFeedback.mediumImpact()` sur : match accepté, demande envoyée, message reçu
- `HapticFeedback.lightImpact()` sur : tap marker carte, sélection filtre
- Dark mode géré via `ThemeData` avec `MediaQuery.platformBrightness` (automatique) + toggle manuel
- Taille de texte : respect `textScaleFactor` pour l'accessibilité

### 10.9 Performance Carte — Stratégies Clés

**Clustering Mapbox (natif, sans lib tierce) :**
```dart
// Configuration layer de clustering via MapboxMap
final clusterLayer = CircleLayer(
  id: 'cluster-layer',
  sourceId: 'activities-source',
  filter: ['has', 'point_count'],
  circleColor: '#4F46E5',
  circleRadius: ['step', ['get', 'point_count'], 20, 5, 30, 10, 40],
);
// < 5 activités : markers individuels | ≥ 5 : cercle numéroté
```

**Lazy loading au `onCameraIdle` :**
```dart
mapboxMap.onCameraIdle.listen((_) async {
  final bounds = await mapboxMap.getBounds();
  // Charger uniquement les activités dans le viewport + 20% de buffer
  ref.read(activitiesProvider.notifier).loadForBounds(bounds);
});
```

**`RepaintBoundary` pour overlays :**
```dart
// Envelopper les widgets overlay dans RepaintBoundary
// pour éviter les re-renders à chaque frame de la carte
RepaintBoundary(
  child: ActivityMarkerWidget(activity: activity),
)
```

### 10.10 Infrastructure Cloud (AWS)

```
Production :
├── ECS Fargate (API NestJS — auto-scaling 2-10 tasks)
├── ECS Fargate (WebSocket NestJS — sticky sessions via ALB)
├── RDS Aurora PostgreSQL 15 (Multi-AZ primary + 1 Read Replica géo)
├── RDS Proxy (connection pooling — évite saturation connexions PG)
├── ElastiCache Redis 7 (Cluster mode — Pub/Sub + cache)
├── Application Load Balancer (sticky sessions pour WebSocket)
├── CloudFront CDN
├── S3 / Cloudflare R2 (photos profil)
├── Route 53 DNS
└── WAF + Shield Standard

Pourquoi RDS Proxy :
Avec 10 instances NestJS × 50 connexions = 500 connexions simultanées
PostgreSQL par défaut supporte ~100-200 connexions (db.t3.medium).
RDS Proxy pool les connexions : réduction à ~50 connexions effectives.

Read Replica dédiée requêtes géo :
Les requêtes ST_DWithin représentent ~80% du trafic DB (lectures pures).
La read replica absorbe ces requêtes, libérant le primary pour les écritures.
Routing NestJS : DataSource "read" → replica, DataSource "write" → primary.
```

### 10.11 Services Tiers — Synthèse

| Service | Usage | Alternative gratuite |
|---------|-------|---------------------|
| **Mapbox** | Carte, geocoding, isochrones | MapLibre + PMTiles self-hosted |
| **Twilio** | OTP SMS | Firebase Phone Auth |
| **FCM** | Push Android | — |
| **APNs** | Push iOS | — |
| **Cloudflare R2** | Photos profil | AWS S3 |
| **OpenAI Moderation** | Modération contenu | Perspective API (gratuit) |
| **Sentry** | Monitoring erreurs | — |
| **PostHog** | Analytics produit | Mixpanel |
| **Resend** | Emails transactionnels | Brevo (Sendinblue) |

---

## 11. SCHÉMA BASE DE DONNÉES

### 11.1 Entités et Relations

```
users ──────────────────── user_sports (N-N avec sport_types)
  │                        
  ├── activities (1-N, creator)
  │     ├── activity_requests (1-N)
  │     └── matches (1-1 via activity_id)
  │           ├── match_participants (N-N avec users)
  │           └── chat_rooms (1-1)
  │                 └── messages (1-N)
  │
  ├── reviews (N-N via reviewer_id / reviewed_id)
  ├── reports (1-N, reporter)
  ├── blocks (N-N, blocker/blocked)
  ├── user_badges (N-N avec badges)
  └── push_tokens (1-N)
```

### 11.2 DDL Complet

```sql
-- EXTENSION
CREATE EXTENSION IF NOT EXISTS postgis;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- UTILISATEURS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pseudo VARCHAR(20) UNIQUE NOT NULL,
    age_range VARCHAR(10) CHECK (age_range IN ('13-17','18-25','26-35','36-45','46-60','60+')),
    gender VARCHAR(20) CHECK (gender IN ('male','female','non_binary','prefer_not_say')),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    first_name VARCHAR(50),
    avatar_url TEXT,
    bio TEXT CHECK (char_length(bio) <= 300),
    is_guest BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_banned BOOLEAN NOT NULL DEFAULT FALSE,
    ban_reason TEXT,
    trust_score SMALLINT NOT NULL DEFAULT 50 CHECK (trust_score BETWEEN 0 AND 100),
    activity_score INTEGER NOT NULL DEFAULT 0 CHECK (activity_score >= 0),
    last_location GEOGRAPHY(POINT, 4326),
    last_location_updated_at TIMESTAMPTZ,
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT email_required_if_not_guest CHECK (
        is_guest = TRUE OR email IS NOT NULL
    )
);

CREATE INDEX idx_users_pseudo ON users(pseudo);
CREATE INDEX idx_users_trust_score ON users(trust_score);

-- SPORTS
CREATE TABLE sport_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    emoji CHAR(10),
    category VARCHAR(30) CHECK (category IN ('collectif','individuel','raquette','endurance','combat','eau','hiver','autre'))
);

-- SPORTS UTILISATEUR
CREATE TABLE user_sports (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport_id INTEGER NOT NULL REFERENCES sport_types(id),
    level VARCHAR(20) NOT NULL CHECK (level IN ('beginner','intermediate','advanced','expert')),
    PRIMARY KEY (user_id, sport_id)
);

-- ACTIVITÉS
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    sport_id INTEGER NOT NULL REFERENCES sport_types(id),
    title VARCHAR(100),
    description TEXT CHECK (char_length(description) <= 500),
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    address TEXT NOT NULL,
    location_name VARCHAR(100),
    scheduled_at TIMESTAMPTZ NOT NULL,
    duration_minutes SMALLINT CHECK (duration_minutes BETWEEN 15 AND 480),
    max_participants SMALLINT NOT NULL DEFAULT 2 CHECK (max_participants BETWEEN 1 AND 100),
    current_participants SMALLINT NOT NULL DEFAULT 1 CHECK (current_participants >= 0),
    required_level VARCHAR(20) CHECK (required_level IN ('any','beginner','intermediate','advanced','expert')),
    gender_filter VARCHAR(20) NOT NULL DEFAULT 'all' CHECK (gender_filter IN ('all','male','female','mixed')),
    visibility VARCHAR(20) NOT NULL DEFAULT 'public' CHECK (visibility IN ('public','private','link')),
    invite_token UUID NOT NULL DEFAULT gen_random_uuid(),
    is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
    recurrence_rule TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'active' CHECK (status IN ('active','full','cancelled','completed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT participants_within_max CHECK (current_participants <= max_participants),
    CONSTRAINT scheduled_in_future CHECK (scheduled_at > created_at - INTERVAL '1 hour')
);

CREATE INDEX idx_activities_location ON activities USING GIST(location);
CREATE INDEX idx_activities_scheduled ON activities(scheduled_at) WHERE status = 'active';
CREATE INDEX idx_activities_sport_status ON activities(sport_id, status);
CREATE INDEX idx_activities_creator ON activities(creator_id);

-- DEMANDES DE PARTICIPATION
CREATE TABLE activity_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
    requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT CHECK (char_length(message) <= 200),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','accepted','rejected','cancelled')),
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(activity_id, requester_id)
);

CREATE INDEX idx_requests_activity_status ON activity_requests(activity_id, status);
CREATE INDEX idx_requests_requester ON activity_requests(requester_id);

-- CHAT ROOMS
CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL DEFAULT 'match' CHECK (type IN ('match','group','direct')),
    name VARCHAR(100),
    activity_id UUID REFERENCES activities(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

-- MATCHS
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES activities(id) ON DELETE SET NULL,
    chat_room_id UUID UNIQUE REFERENCES chat_rooms(id),
    status VARCHAR(20) NOT NULL DEFAULT 'upcoming' CHECK (status IN ('upcoming','ongoing','completed','cancelled')),
    occurred_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE match_participants (
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'participant' CHECK (role IN ('organizer','participant')),
    has_attended BOOLEAN,
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (match_id, user_id)
);

-- MESSAGES
CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL CHECK (char_length(content) BETWEEN 1 AND 2000),
    content_type VARCHAR(20) NOT NULL DEFAULT 'text' CHECK (content_type IN ('text','image','system')),
    is_moderated BOOLEAN NOT NULL DEFAULT FALSE,
    moderation_reason TEXT,
    read_by UUID[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_messages_room_created ON messages(room_id, created_at DESC);

-- AVIS
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reviewer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    reviewed_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    match_id UUID NOT NULL REFERENCES matches(id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT CHECK (char_length(comment) <= 300),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(reviewer_id, match_id),
    CHECK (reviewer_id != reviewed_id)
);

-- SIGNALEMENTS
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES users(id),
    reported_user_id UUID REFERENCES users(id),
    reported_activity_id UUID REFERENCES activities(id),
    reported_message_id UUID REFERENCES messages(id),
    category VARCHAR(50) NOT NULL CHECK (category IN ('fake','harassment','spam','inappropriate','dangerous','other')),
    description TEXT CHECK (char_length(description) <= 500),
    status VARCHAR(20) NOT NULL DEFAULT 'pending' CHECK (status IN ('pending','reviewed','resolved','dismissed')),
    admin_note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT at_least_one_target CHECK (
        reported_user_id IS NOT NULL OR
        reported_activity_id IS NOT NULL OR
        reported_message_id IS NOT NULL
    )
);

-- BLOCAGES
CREATE TABLE blocks (
    blocker_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blocked_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (blocker_id, blocked_id),
    CHECK (blocker_id != blocked_id)
);

-- BADGES
CREATE TABLE badges (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    emoji CHAR(10),
    condition_type VARCHAR(50) NOT NULL,
    condition_value INTEGER NOT NULL
);

CREATE TABLE user_badges (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER NOT NULL REFERENCES badges(id),
    earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, badge_id)
);

-- PUSH TOKENS
CREATE TABLE push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform VARCHAR(10) NOT NULL CHECK (platform IN ('ios','android')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(token)
);

CREATE INDEX idx_push_tokens_user ON push_tokens(user_id);

-- GROUPES (V2)
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    sport_id INTEGER REFERENCES sport_types(id),
    avatar_url TEXT,
    city VARCHAR(100),
    location GEOGRAPHY(POINT, 4326),
    is_public BOOLEAN NOT NULL DEFAULT TRUE,
    max_members SMALLINT,
    creator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_groups_location ON groups USING GIST(location);

CREATE TABLE group_members (
    group_id UUID NOT NULL REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'member' CHECK (role IN ('admin','moderator','member')),
    joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);
```

### 11.3 Structure Redis — Clés et TTL

| Clé Redis | Type | TTL | Rôle |
|-----------|------|-----|------|
| `user:loc:{uuid}` | Hash `{lat, lng, ts}` | 300s (5 min) | Position temps réel utilisateur |
| `activity:cache:{uuid}` | String (JSON) | 300s | Cache détail activité |
| `activities:zone:{geohash5}` | Set (UUIDs) | 60s | Index local activités par zone |
| `rate:ip:{ip}:{endpoint}` | Counter | 60s | Rate limiting par IP |
| `rate:user:{uuid}:{action}` | Counter | 60s | Rate limiting par user |
| `otp:{phone}` | String | 120s | Code OTP en attente |
| `otp:attempts:{phone}` | Counter | 900s | Nb tentatives OTP (max 3) |
| `session:ws:{socket_id}` | Hash `{user_id, rooms}` | 0 (persistant jusqu'à déco) | Session WebSocket active |
| `refresh_token:{token_hash}` | String (user_id) | 2592000s (30j) | Refresh token valide |

**Pub/Sub Channels :**
| Channel | Émetteur | Abonnés |
|---------|----------|---------|
| `activities:zone:{geohash5}` | API lors de création | WS Gateway → clients de la zone |
| `activity:{uuid}:updates` | API (demandes, annulations) | WS Gateway → room de l'activité |
| `chat:room:{uuid}` | API lors d'un message | WS Gateway → membres du room |
| `notifications:{user_uuid}` | Services internes | WS Gateway → client |

**Nommage des Rooms WebSocket (Geohash) :**
Les zones géographiques utilisent le geohash de niveau 5 (cellules ~5km × 5km en France) :
- Exemple Paris : `u09tvw`, `u09tvy`, `u09tw5`...
- Un utilisateur à Paris 11ème s'abonne à son geohash + les 8 geohash voisins (9 zones au total)
- Mise à jour de l'abonnement si l'utilisateur se déplace de plus d'une cellule

---

## 12. APIs & ENDPOINTS

### 12.1 Conventions

- **Base URL :** `https://api.selene.app/v1`
- **Auth :** `Authorization: Bearer <access_token>` (JWT, 15 min)
- **Format :** JSON, snake_case
- **Pagination :** cursor-based (pas d'OFFSET)
- **Timestamps :** ISO 8601, UTC
- **Erreurs :** `{ "error": { "code": "RESOURCE_NOT_FOUND", "message": "..." } }`

### 12.2 Endpoints REST

#### Authentification
```
POST /auth/guest                → Créer profil invité
POST /auth/email/request        → Magic link email
POST /auth/email/verify         → Vérifier token email
POST /auth/phone/request        → OTP SMS (rate: 3/15min/phone)
POST /auth/phone/verify         → Vérifier OTP
POST /auth/token/refresh        → Rotation refresh token
POST /auth/logout               → Invalider tokens
```

#### Utilisateurs
```
GET    /users/me                → Mon profil complet
PUT    /users/me                → Modifier profil
DELETE /users/me                → Supprimer compte (RGPD, async)
GET    /users/:id               → Profil public
POST   /users/me/avatar         → Upload photo (multipart, max 5MB)
PUT    /users/me/location       → MAJ position (rate: 1/10s/user)
GET    /users/me/matches        → Historique (cursor pagination)
GET    /users/me/badges         → Mes badges
GET    /users/me/data-export    → Export RGPD (async, email)
```

#### Activités — Pagination Cursor-Based
```
GET /activities/nearby
  Params :
    lat (float, requis)
    lng (float, requis)
    radius_km (float, défaut: 5, max: 50)
    sport_id (int, optionnel)
    level (string, optionnel)
    gender (string, optionnel)
    date_from (ISO8601, défaut: now)
    date_to (ISO8601, optionnel)
    cursor (string, opaque, pour pagination)
    limit (int, défaut: 20, max: 50)

  Réponse :
    {
      "data": [Activity],
      "next_cursor": "eyJkaXN0Ij...",  // null si dernière page
      "total_in_radius": 47
    }

  Requête SQL sous-jacente :
    SELECT *, ST_Distance(location, $ref_point) AS dist
    FROM activities
    WHERE status = 'active'
      AND scheduled_at > NOW()
      AND ST_DWithin(location, $ref_point, $radius_meters)
      AND ($cursor IS NULL OR ST_Distance(location, $ref_point) > $cursor_dist)
      AND (sport_id = $sport_id OR $sport_id IS NULL)
    ORDER BY dist ASC
    LIMIT $limit

GET /activities/isochrone
  Params :
    lat, lng (requis)
    minutes (10 | 20 | 30, requis)
    transport (walking | cycling | driving | transit, requis)
  → Appel Mapbox Isochrone API → filtre activités dans le polygone

GET    /activities/:id
POST   /activities              → Créer (membre uniquement, trust_score >= 40)
PUT    /activities/:id          → Modifier (créateur uniquement)
DELETE /activities/:id          → Supprimer

POST   /activities/:id/requests        → Demander à rejoindre
GET    /activities/:id/requests        → Liste demandes (créateur)
PUT    /activities/:id/requests/:reqId → Accepter/refuser (créateur)
DELETE /activities/:id/requests/:reqId → Annuler demande (requester)
```

#### Chat
```
GET  /chat/rooms              → Mes conversations actives
GET  /chat/rooms/:id/messages → Messages (cursor pagination, 50/page)
     Params: cursor (message_id), direction (before|after)
```

#### Sécurité
```
POST   /reports               → Signaler (rate: 5/hour/user)
POST   /blocks                → Bloquer
DELETE /blocks/:userId        → Débloquer
GET    /blocks                → Liste bloqués
```

#### Admin
```
GET  /admin/dashboard/stats   → KPIs temps réel
GET  /admin/users             → Liste + search (paginated)
PUT  /admin/users/:id/ban     → Bannir avec raison
GET  /admin/reports           → Queue modération
PUT  /admin/reports/:id       → Traiter (resolve/dismiss)
GET  /admin/activities        → Activités modération
```

### 12.3 Contrat WebSocket (Socket.io)

**Connexion :** `wss://api.selene.app/ws?token=<jwt>`
JWT vérifié au handshake via `AuthGuard` NestJS.

**Namespace `/live` — Carte temps réel**

```typescript
// CLIENT → SERVEUR
interface SubscribeZonePayload {
  geohashes: string[]; // 9 geohashes (zone user + voisins)
}

interface UpdateLocationPayload {
  lat: number;
  lng: number;
}

// SERVEUR → CLIENT
interface ActivityCreatedEvent {
  event: 'activity:created';
  data: {
    id: string;
    sport: { id: number; slug: string; emoji: string };
    location: { lat: number; lng: number };
    scheduled_at: string; // ISO8601
    max_participants: number;
    current_participants: number;
    required_level: string;
    gender_filter: string;
  };
}

interface ActivityUpdatedEvent {
  event: 'activity:updated';
  data: {
    id: string;
    changes: Partial<ActivityCreatedEvent['data']>;
  };
}

interface ActivityDeletedEvent {
  event: 'activity:deleted';
  data: { id: string };
}
```

**Namespace `/chat` — Messagerie**

```typescript
// CLIENT → SERVEUR
interface JoinRoomPayload { room_id: string }
interface SendMessagePayload {
  room_id: string;
  content: string;
  content_type: 'text' | 'image';
  client_message_id: string; // UUID généré côté client pour dédup
}
interface MarkReadPayload { room_id: string; up_to_message_id: string }

// SERVEUR → CLIENT
interface NewMessageEvent {
  event: 'chat:message';
  data: {
    id: string;
    room_id: string;
    sender_id: string;
    content: string;
    content_type: string;
    created_at: string;
    client_message_id: string;
  };
}

interface MessageReadEvent {
  event: 'chat:read';
  data: { room_id: string; reader_id: string; up_to_message_id: string };
}

interface RequestReceivedEvent {
  event: 'request:received';
  data: { request_id: string; activity_id: string; requester: PublicUserProfile };
}

interface RequestAcceptedEvent {
  event: 'request:accepted';
  data: { request_id: string; match_id: string; chat_room_id: string };
}
```

**Gestion des états déconnectés :**
- Reconnexion automatique Socket.io : backoff exponentiel (1s → 2s → 4s → max 30s)
- Messages envoyés pendant la déconnexion : mis en queue Isar (offline), flush au reconnect
- Si déconnexion > 5 min : rechargement complet des activités (pas de delta)
- Authentification : si token JWT expiré lors de la reconnexion → refresh automatique via `/auth/token/refresh` avant reconnect WS

### 12.4 Stratégie Retry & Fallback Services Externes

| Service | Retry | Fallback |
|---------|-------|----------|
| Mapbox Isochrone | 3 tentatives, backoff 1s | Rayon circulaire `ST_DWithin` (dégradé) |
| Mapbox Geocoding | 3 tentatives, backoff 1s | Cache Redis du dernier résultat connu |
| Twilio OTP | 2 tentatives, backoff 2s | Message d'erreur utilisateur + retry manuel |
| FCM Push | 3 tentatives (géré par Bull) | Log + next session pull |
| OpenAI Moderation | 2 tentatives, timeout 3s | Allow message + flag pour review manuelle |

Implémentation via Bull Queue avec `attempts: 3` et `backoff: { type: 'exponential', delay: 1000 }`.

---

## 13. TEMPS RÉEL & CHAT

### 13.1 Architecture WebSocket Multi-Instances

```
CLIENT FLUTTER
      │ WSS
      ▼
[ALB Sticky Session] ← sticky par cookie "io" Socket.io
      │
[WS Gateway NestJS Instance 1]
      │         │
      │    [Redis Pub/Sub]
      │         │
[WS Gateway NestJS Instance 2]
      │
CLIENT FLUTTER 2
```

Les rooms Socket.io sont partagées entre instances via Redis adapter (`@socket.io/redis-adapter`).
Un message envoyé par le client A (connecté à l'instance 1) est diffusé au client B (connecté à l'instance 2) via le canal Redis `activities:zone:{geohash5}`.

### 13.2 Chat — Garanties de Délivrance

**Cycle de vie d'un message :**
```
Client envoie → status: 'sending'
Reçu serveur  → status: 'sent' (ACK WebSocket)
Délivré device→ status: 'delivered' (confirmation push ou WS)
Lu par dest.  → status: 'read' (event MarkRead)
```

**Persistance :** PostgreSQL (source de vérité) + cache Redis 1h pour les 50 derniers messages.
**Pagination :** cursor-based sur `(room_id, created_at DESC)` avec index composite.

### 13.3 Push Notifications — Détail

| Événement | Titre | Corps | Action au tap |
|-----------|-------|-------|---------------|
| Demande reçue | "Nouvelle demande 🎾" | "{pseudo} veut rejoindre" | `/activities/:id/requests` |
| Accepté | "C'est parti ✅" | "{pseudo} a accepté" | `/chat/:room_id` |
| Refusé | "Pas de chance 😔" | "{pseudo} n'a pas de place" | `/map` |
| Nouveau message | "{pseudo}" | "{preview}" | `/chat/:room_id` |
| Rappel activité | "Dans 1h — {sport}" | "Prépare-toi !" | `/activities/:id` |
| Annulation | "Annulé ❌" | "{sport} de {pseudo} annulé" | `/map` |

---

## 14. SÉCURITÉ & RGPD

### 14.1 Sécurité Applicative

**Auth :**
- Passwordless : magic link email + OTP SMS uniquement
- JWT access token : 15 min expiry, signé RS256
- Refresh token : 30 jours, rotation à chaque renouvellement (token family), stocké haché (SHA-256) en Redis
- Mobile : tokens dans `flutter_secure_storage` (Keychain iOS / EncryptedSharedPreferences Android)
- Certificate pinning en production (SHA-256 du certificat serveur)

**Transport :**
- HTTPS/TLS 1.3 obligatoire, HSTS 1 an, certificate pinning mobile

**Rate Limiting — Seuils par Endpoint :**

| Endpoint | Limite | Fenêtre | Identification |
|----------|--------|---------|----------------|
| `POST /auth/phone/request` | 3 req | 15 min | par numéro + IP |
| `POST /auth/email/request` | 5 req | 15 min | par email + IP |
| `POST /activities` | 10 req | 1 heure | par user JWT |
| `POST /activities/:id/requests` | 20 req | 1 heure | par user JWT |
| `POST /reports` | 5 req | 1 heure | par user JWT |
| API publique générale | 200 req | 1 min | par IP |
| API authentifiée générale | 600 req | 1 min | par user JWT |
| WebSocket messages | 60 msg | 1 min | par user JWT |

Implémentation : `@nestjs/throttler` + Redis sliding window.

**Validation :**
- Input sanitization : `class-validator` sur tous les DTOs
- Requêtes SQL : ORM TypeORM (prepared statements, jamais de string interpolation)
- Upload photo : validation MIME type côté serveur, scan antivirus (ClamAV ou AWS Macie), resize automatique (Sharp.js)

### 14.2 RGPD

**Base légale :** Consentement explicite (checkbox obligatoire avant inscription)

**Données et durées de conservation :**

| Donnée | Finalité | Conservation |
|--------|----------|-------------|
| Email | Auth, communication | Durée compte + 1 an |
| Téléphone (chiffré AES-256) | Vérification, anti-fake | Durée compte + 1 an |
| Photo profil | Identification | Durée compte + 30 jours |
| Position GPS | Fonctionnement carte | Session uniquement (Redis TTL 5 min) |
| `last_location` PostgreSQL | Matching passif | Compte actif uniquement |
| Historique matchs | Réputation, fonctionnalités | Durée compte + 2 ans |
| Messages chat | Service | 1 an |
| Logs applicatifs | Sécurité, debug | 90 jours |

**Droits utilisateurs :**
- Accès : export JSON (asynchrone, délai 72h, envoyé par email)
- Rectification : modification profil en temps réel
- Effacement : suppression compte + données (délai 30 jours, sauf obligations légales)
- Portabilité : export structuré JSON
- Opposition : opt-out analytics, opt-out notifications marketing

**Mineurs :**
- < 13 ans : accès refusé (détection par âge déclaré à l'onboarding)
- 13-17 ans : mode restreint (profil non public, interactions limitées aux activités jeunesse)

**Suppression des messages (droit à l'oubli) :**
Lorsqu'un compte est supprimé, les messages chat ne sont pas effacés (car ils font partie d'une conversation partagée). En revanche, `sender_id` est remplacé par `NULL` et le nom affiché devient "Utilisateur supprimé". Le contenu des messages est conservé pour les autres participants.

### 14.3 Infrastructure Sécurité

- Secrets : AWS Secrets Manager (rotation automatique)
- VPC : bases de données non exposées publiquement
- WAF : AWS WAF v2 avec OWASP Core Rule Set v4
- Monitoring : AWS GuardDuty + CloudTrail + alertes Sentry

### 14.4 Sauvegarde & Continuité

- **RPO (Recovery Point Objective) cible :** 1 heure
- **RTO (Recovery Time Objective) cible :** 4 heures
- Backup PostgreSQL : automated backups AWS RDS, rétention 35 jours, point-in-time recovery activé
- Redis : snapshot RDB toutes les heures + AOF (Append-Only File) pour les données critiques
- Réplication : RDS Multi-AZ avec failover automatique (~30 secondes)
- Runbook de restauration : documenté dans Notion, testé trimestriellement

---

## 15. MODÉRATION & ANTI-FRAUDE

### 15.1 Signalements

**Types :** `fake` / `harassment` / `spam` / `inappropriate` / `dangerous` / `other`

**Flux automatique :**
```
Signalement → Score IA (OpenAI Moderation / Perspective API)
├── Score > 0.85 → Shadow ban temporaire 24h + queue review
├── Score 0.60-0.85 → Queue review (48h SLA)
└── Score < 0.60 → Archivé
```

### 15.2 Trust Score — Règles Complètes

| Action | Delta |
|--------|-------|
| Création compte | +50 (base) |
| Email vérifié | +10 |
| Téléphone vérifié | +15 |
| Photo modérée | +20 |
| Avis positif reçu (4-5 ⭐) | +5 |
| Match complété (présence) | +3 |
| Signalement fondé | -15 |
| No-show (absent à activité acceptée) | -10 |
| Avertissement admin | -30 |
| Trust < 20 | Suspension + review |
| Trust < 0 | Ban permanent |

### 15.3 Anti-Fake Accounts

1. OTP téléphone (1 compte / numéro)
2. Photo profil avec détection visage réel (AWS Rekognition)
3. Trust score minimum pour publier (≥ 40, obtenu après vérifications)
4. Domaines email jetables bloqués (liste mise à jour)
5. Device fingerprinting (limite créations par device)
6. Détection comportement suspect : >10 demandes en 5 min → CAPTCHA

### 15.4 Anti-Harcèlement

- Chat uniquement entre matchs acceptés (pas de messagerie froide)
- Blocage silencieux (1 tap depuis profil ou message)
- Filtre genre sur les activités (femmes peuvent choisir "femmes uniquement")
- Modération NLP : Perspective API sur chaque message (score > 0.85 → suppression auto)
- 3 blocages reçus mutuels → alerte admin

### 15.5 Réputation

**Score 0-100 :**

| Composante | Poids |
|------------|-------|
| Fiabilité présence | 30 % |
| Moyenne avis reçus | 30 % |
| Ancienneté compte actif | 15 % |
| Vérifications complètes | 15 % |
| Malus signalements fondés | -10 % |

**Niveaux :** Excellent (85-100) / Bon (65-84) / Moyen (45-64) / Faible (25-44 — avertissement visible) / Très faible (<25 — restrictions)

---

## 16. ANALYTICS & ADMIN PANEL

### 16.1 KPIs et SLA de Performance

**KPIs Produit (PostHog) :**
- North Star : matchs sportifs complétés / semaine
- DAU/MAU (cible ratio 30 %+)
- Funnel invité → demande → acceptation → inscription → 2ème match

**SLA Techniques :**

| Endpoint | Latence cible p95 | Disponibilité cible |
|----------|-------------------|---------------------|
| `GET /activities/nearby` | < 200ms | 99.9 % |
| Chat WebSocket (end-to-end) | < 500ms | 99.9 % |
| `POST /activities` | < 300ms | 99.9 % |
| Livraison notification push | < 5s | 99.5 % |
| Disponibilité globale app | — | 99.5 % MVP, 99.9 % post-seed |

**Monitoring :** Sentry (erreurs), Grafana + Prometheus (infra), AWS CloudWatch (logs), PostHog (produit).

### 16.2 Admin Panel

**Stack :** React + Vite + Tailwind CSS (interface web dédiée)

| Module | Fonctionnalités |
|--------|----------------|
| Dashboard | KPIs temps réel, heat map activités, alertes sécurité |
| Utilisateurs | Search, profil, historique, ban/suspend, trust score |
| Activités | Modération, stats sport/zone |
| Signalements | Queue avec SLA 48h, workflow accept/dismiss |
| Configurations | Feature flags, liste noire mots |

---

## 17. MODÈLE FREEMIUM & MONÉTISATION

### 17.1 Version Gratuite (Forever Free)

- 3 demandes de participation / jour
- 1 activité publiée en simultané
- Chat avec matchs actifs
- Historique 30 jours
- Carte complète, tous les filtres

### 17.2 Séléné Premium — 4,99 €/mois ou 39,99 €/an

- Demandes illimitées
- 5 activités simultanées
- Voir qui a consulté mon activité
- Boost de visibilité (priorité résultats filtrés)
- Statistiques avancées
- Badge "Premium" profil
- Historique illimité

### 17.3 Séléné Pro (Coachs/Organisateurs) — 14,99 €/mois

- Tout Premium inclus
- 50 participants max par activité
- Activités récurrentes illimitées
- Page profil pro
- Outils gestion (présence, liste attente, export CSV)
- Analytics événements

### 17.4 Publicité Locale Contextuelle

Format non-intrusif (bannières dans liste activités, jamais sur carte).
Ciblage : sport pratiqué + géolocalisation + niveau. CPM 8-15 €.

### 17.5 Partenariats B2B

- Salles de sport : page officielle + booking intégré (V2)
- Clubs sportifs : visibilité événements, recrutement
- Mairies : promotion équipements sportifs publics
- API B2B : données anonymisées flux sportif local

### 17.6 Projections Financières (12 mois)

| Source | Conservateur | Optimiste |
|--------|-------------|-----------|
| Premium (5% × 5K MAU × 4.99€) | 1 250 €/mois | 7 500 €/mois |
| Pro (0.5% × 5K MAU × 14.99€) | 375 €/mois | 1 500 €/mois |
| Publicité | 500 €/mois | 3 000 €/mois |
| **TOTAL** | **~2 125 €/mois** | **~12 000 €/mois** |

---

## 18. GAMIFICATION & RÉTENTION

### 18.1 Badges

| Badge | Condition | Rareté |
|-------|-----------|--------|
| 🏃 Première foulée | 1er match complété | Commun |
| 🎾 Multi-sport | 3 sports différents | Commun |
| 🔥 En feu | 5 matchs en 1 semaine | Peu commun |
| 🗺️ Explorateur | Activités dans 3 villes | Peu commun |
| 👥 Organisateur | 10 activités créées | Peu commun |
| 🌟 5 étoiles | Réputation ≥ 90 | Rare |
| 🏆 Champion local | Top 10 sport dans sa ville | Rare |
| 💎 Vétéran | 100 matchs complétés | Épique |
| 🤝 Ambassadeur | 5 parrainages | Rare |
| 👑 Séléné Star | Meilleur partenaire du mois | Légendaire |

### 18.2 Activity Score

```
Score = (Matchs × 10) + (Sports variés × 15) + (Avis 4-5★ × 8)
      + (Activités créées × 12) + (Présences × 5)
      - (No-shows × 20) - (Signalements fondés × 50)
```

**Niveaux :** Rookie (0-100) → Challenger (101-300) → Warrior (301-700) → Elite (701-1500) → Legend (1500+)

### 18.3 Autres Mécanismes

- **Défis hebdomadaires :** 3 défis personnalisés chaque lundi (+points, +badges)
- **Streak hebdomadaire :** au moins 1 activité/semaine, brisé = relance push
- **Classements locaux :** top 10 sportifs par ville et par sport, opt-out disponible

---

## 19. MATCHING INTELLIGENT (IA)

### 19.1 MVP — Recommandation Basique

**"Activités pour toi" (top 5) :**
1. Sport pratiqué en commun (poids 40 %)
2. Niveau sportif compatible (±1 niveau) (poids 25 %)
3. Historique géographique (zones habituelles) (poids 20 %)
4. Horaires habituels (analyse matchs passés) (poids 15 %)

Calculé à la demande (pas de batch), résultat mis en cache Redis 10 min.

### 19.2 V2 — Algorithme Avancé

**Stack :** Python micro-service (FastAPI) + LightGBM + feature store Redis

**Features :**
- Vecteur sports/niveaux utilisateur
- Vecteur temporel (créneaux horaires habituels)
- Vecteur géographique (clusters lieux fréquentés via K-means)
- Score compatibilité avec d'autres users (post-match ratings)
- Météo prévue (pour sports outdoor)

**Output :** ranking personnalisé des activités sur la carte

### 19.3 Matching Partenaire Régulier (V2)

Profil de recherche : "Tennis 1x/semaine, niveau intermédiaire, Lyon 3ème"
→ Algorithme notifie à la compatibilité de profil (pas de swipe — liste ordonnée, 1x/jour)

---

## 20. DIAGRAMMES FONCTIONNELS

### 20.1 Flux Complet Publication → Match Post-Avis

```
CRÉATEUR A                              PARTICIPANT B
    │                                       │
    │ 1. Publie activité Tennis             │
    │    → Carte live + notif zone          │
    │                                       │ 2. Voit icône 🎾
    │                                       │ 3. Bottom sheet → détails
    │                                       │ 4. "Demander à rejoindre"
    │                                       │
    │ 5. 🔔 "Karim demande à rejoindre" ◄──│
    │                                       │
    │ 6. Consulte profil Karim             │
    │    → Score, badges, avis             │
    │                                       │
    │ 7. ACCEPTE ─────────────────────────►│ 8. 🔔 "Accepté !"
    │                                       │    → modale inscription si invité
    │                                       │
    │ 9. Chat ouvert ◄───────────────────► 9. Chat ouvert
    │    "Court 3 à 18h ?" ──────────────► "Parfait !"
    │                                       │
    │          [MATCH SPORTIF] ←────────────│
    │                                       │
    │ Après match :                         │
    │    ⭐ Avis mutuels                   │
    │    🏆 Badges débloqués              │
    │    📊 Score mis à jour              │
```

### 20.2 Géolocalisation Temps Réel — Architecture

```
MOBILE FOREGROUND          API GATEWAY         REDIS / WEBSOCKET
       │                        │                     │
       │── PATCH /location ────►│── SET user:loc ────►│ TTL 300s
       │   (si delta > 50m)     │                     │
       │   (max 1/30s)          │── Pub/Sub ──────────►│
       │                        │   activities:zone   │
       │                        │   geohash5          │
       │                        │                     │──► WS clients zone
       │                        │                     │    activity events
```

### 20.3 Filtres Isochrones

```
Position utilisateur (Paris 11ème)
              │
              ▼
    [Mapbox Isochrone API]
    transport=walking, contourMinutes=20
              │
              ▼
    Polygone GeoJSON retourné
              │
              ▼
    [PostGIS ST_Within(activity.location, polygone)]
              │
              ▼
    Activités dans la zone colorée
    Activités hors zone : grisées
```

---

## 21. STRUCTURE ÉCRANS & NAVIGATION

### 21.1 Bottom Tab Bar

```
┌──────────────────────────────────────────────┐
│              [CONTENU ÉCRAN]                 │
│                                              │
├──────────────────────────────────────────────┤
│ 🗺️ Carte │ 🔔 Activités │ ➕ │ 💬 Chat │ 👤 Profil │
└──────────────────────────────────────────────┘
```

### 21.2 Arborescence

```
APP SÉLÉNÉ
├── ONBOARDING
│   ├── Splash + Logo
│   ├── 3 slides (swipeable, skippable)
│   └── Profil invité (âge, genre, pseudo)
│
├── TAB CARTE
│   ├── Carte Mapbox (clustering, markers par sport)
│   │   ├── Barre recherche
│   │   ├── Bouton filtres
│   │   └── Tap marker → Bottom Sheet Activité
│   │       ├── Résumé (sport, dist, heure, places)
│   │       ├── "Voir détails" → Détail plein écran
│   │       └── "Demander à rejoindre"
│   └── Panel Filtres (bottom sheet)
│       ├── Sport (chips multi-select)
│       ├── Distance (slider) ou Temps de trajet (radio)
│       ├── Mode transport (4 options)
│       ├── Niveau + Genre + Date
│
├── TAB ACTIVITÉS
│   ├── Mes demandes (en attente / acceptées / refusées)
│   └── Mes activités créées (actives / passées)
│
├── TAB ➕ (FAB — Créer)
│   ├── Sélection sport
│   ├── Lieu (carte picker / adresse / ma position)
│   ├── Date + Heure + Durée
│   ├── Places + Niveau + Visibilité
│   └── Aperçu carte → Publier
│
├── TAB CHAT
│   ├── Liste conversations (badge non-lus)
│   └── Conversation (messages + infos activité header)
│
├── TAB PROFIL
│   ├── Mon profil public
│   ├── Modifier profil
│   ├── Historique matchs + Badges
│   └── Paramètres
│       ├── Notifications (granulaire par type)
│       ├── Confidentialité (géoloc, visibilité profil)
│       ├── Abonnement Premium
│       └── RGPD (export, suppression)
│
├── PROFIL AUTRE UTILISATEUR
│   ├── Photo + Score + Badges + Avis
│   ├── Activités publiques récentes
│   ├── Bouton Signaler
│   └── Bouton Bloquer
│
└── INSCRIPTION COMPLÈTE (modale contextuelle)
    ├── 1/4 Email → magic link
    ├── 2/4 Téléphone → OTP
    ├── 3/4 Photo
    └── 4/4 Sports + Niveaux
```

---

## 22. UX/UI — DESIGN SYSTEM 2026

### 22.1 Principes

1. **Mobile-first natif** — chaque interaction pensée pour le doigt, pas un port web
2. **Glassomorphisme contextuel** — UI légère sur fond de carte
3. **Micro-animations + haptics** — feedback immédiat, `HapticFeedback.mediumImpact()` sur match accepté et demande envoyée
4. **Dark mode natif** — `ThemeData` avec `MediaQuery.platformBrightness` + toggle manuel
5. **Accessibilité AA** — `Semantics` widgets sur tous les éléments interactifs, VoiceOver/TalkBack
6. **i18n prêt** — `flutter_localizations` + `intl`, tous les strings externalisés dès le MVP

### 22.2 Couleurs

```
Primaire   : #4F46E5  (Indigo — CTAs)
Succès     : #10B981  (Vert — validations)
Accent     : #F59E0B  (Ambre — badges)
Danger     : #EF4444  (Rouge — erreurs)
Fond dark  : #111827
Fond light : #F9FAFB
```

### 22.3 Composants Clés

**Activity Card :**
```
┌──────────────────────────────┐
│ ⚽ Football                  │
│    Parc des Sports  •  1.2km │
│    Aujourd'hui  18:00 - 20h  │
│                              │
│  👤👤👤  3/5 places          │
│  🟡 Intermédiaire            │
│                              │
│  [ Demander à rejoindre  → ] │
└──────────────────────────────┘
```

---

## 23. ROADMAP TECHNIQUE — SPRINT PAR SPRINT

### MVP — 4 mois (Sprints 1-8 × 2 semaines)

**Sprint 1-2 — Fondations**
- Setup Flutter (Riverpod + go_router + Isar)
- NestJS modules auth, users
- PostgreSQL + PostGIS + schéma
- JWT + mode invité + géolocalisation

**Sprint 3-4 — Carte & Activités**
- Mapbox `mapbox_maps_flutter` v2.x
- CRUD activités + PostGIS ST_DWithin
- Clustering Mapbox natif
- Filtres basiques

**Sprint 5-6 — Matching & Notifications**
- Système demandes/acceptation
- Push FCM + APNs (3 états : foreground/background/terminated)
- Deep linking notifications → go_router
- OTP Twilio
- Déclencheur inscription complète

**Sprint 7-8 — Chat & Temps Réel**
- WebSocket Socket.io (namespace /live + /chat)
- Redis Pub/Sub inter-instances
- Chat rooms + messages persistants
- Géoloc temps réel (cycle de vie Redis TTL 300s)

**Sprint 9-10 — Filtres Avancés & Polish**
- Mapbox Isochrone API (fallback ST_DWithin)
- Lazy loading au `onCameraIdle`
- Animations + haptics
- Dark mode + accessibilité Semantics

**Sprint 11-12 — Sécurité & RGPD**
- Rate limiting par endpoint
- Modération photo (Rekognition)
- flutter_secure_storage + rotation refresh tokens
- Export RGPD + suppression compte

**Sprint 13-14 — Beta Privée**
- Tests E2E (Flutter integration tests)
- Tests de charge k6 (SLA: p95 < 200ms)
- PostHog analytics
- Bug fixing beta testeurs (50 users)
- Préparation App Store / Play Store

**Sprint 15-16 — MVP Launch**
- Privacy Policy + Data Safety labels
- Closed Testing Google Play (20 testeurs, 14 jours)
- App Store review submission
- Monitoring Sentry + Grafana
- Landing page marketing

### V2 — Sprints 17-24

- S17-18 : Groupes sportifs
- S19-20 : Gamification complète
- S21-22 : IA recommandation (Python micro-service)
- S23-24 : Premium in-app (Apple IAP, Google Billing)

---

## 24. ESTIMATION COMPLEXITÉ & COÛTS

### 24.1 Complexité MVP

| Feature | Complexité | Jours dev estimés |
|---------|-----------|-------------------|
| Carte Mapbox + clustering | M | 3 |
| PostGIS nearby + cursor pagination | L | 4 |
| Isochrones Mapbox + fallback | XL | 5 |
| CRUD Activités | M | 3 |
| Matching + notifications push | L | 5 |
| Chat WebSocket (3 états + deep link) | XL | 7 |
| Profil 2 niveaux + OTP + photo | L | 5 |
| Géoloc temps réel (Redis TTL) | M | 3 |
| Offline mode (Isar + sync) | L | 4 |
| Réputation + avis | M | 3 |
| Modération + signalements | L | 4 |
| Admin panel web | XL | 8 |
| RGPD + export | M | 3 |
| Rate limiting + sécurité | M | 3 |
| CI/CD + infra AWS + RDS Proxy | L | 5 |
| App Store/Play Store prep | M | 3 |
| **TOTAL** | | **~68 jours** |

### 24.2 Coûts Cloud AWS — 3 Scenarios

**Dev/Staging :**

| Service | Config | €/mois |
|---------|--------|--------|
| ECS Fargate (API) | 0.5 vCPU, 1GB × 2 | ~30 |
| RDS PostgreSQL | db.t3.small | ~25 |
| ElastiCache Redis | cache.t3.micro | ~15 |
| CloudFront + S3/R2 | 50GB | ~8 |
| **TOTAL** | | **~78 €/mois** |

**Production MVP (1K-5K MAU) :**

| Service | Config | €/mois |
|---------|--------|--------|
| ECS Fargate (API + WS) | 1 vCPU, 2GB × 3 | ~150 |
| RDS Aurora PG (Multi-AZ + Replica) | db.r6g.large | ~350 |
| RDS Proxy | Standard | ~40 |
| ElastiCache Redis | cache.r6g.large | ~80 |
| CloudFront + S3/R2 | 500GB | ~50 |
| Twilio OTP | ~1K SMS/mois | ~50 |
| Sentry | Team | ~25 |
| **TOTAL** | | **~745 €/mois** |

**Scale (50K MAU) :**
~3 500-4 500 €/mois (auto-scaling ECS, Aurora scale-out)

### 24.3 Coûts Mapbox — Projections

| MAU | Map loads/mois (3 sessions/jour) | Coût Mapbox |
|-----|----------------------------------|-------------|
| 1 000 | ~90 000 | Gratuit (< 50K) → ~160 USD |
| 10 000 | ~900 000 | ~1 700 USD/mois |
| 50 000 | ~4 500 000 | ~8 200 USD/mois |

**Alternative MapLibre (MVP scale-up) :**
MapLibre GL Flutter (fork open source de Mapbox GL) + tuiles PMTiles hébergées sur Cloudflare R2 :
- Coût tuiles : ~50-200 USD/mois (storage R2 + bandwidth)
- Coût routage/isochrones : OpenRouteService (gratuit jusqu'à 500 req/jour, 40 USD/mois au-delà)
- **Économie potentielle à 10K MAU : ~1 500 USD/mois**

Recommandation : démarrer avec Mapbox (intégration plus rapide, SDK meilleur), migrer vers MapLibre au franchissement du seuil 10K MAU.

### 24.4 Services Tiers — Coûts Opérationnels

| Service | Gratuit | Coût à 5K MAU |
|---------|---------|---------------|
| FCM (push Android) | ∞ | 0 |
| APNs (push iOS) | ∞ (avec compte Apple Dev) | 0 |
| Twilio SMS OTP | 0 | ~50 USD/mois |
| Resend (emails) | 3K/mois | ~20 USD/mois |
| PostHog | 1M events/mois | 0 |
| Sentry | 5K errors/mois | ~25 USD/mois |

---

## 25. ÉQUIPE NÉCESSAIRE

### 25.1 MVP (4 mois)

| Rôle | ETP | Profil | Coût estimé (TJM Paris 2026) |
|------|-----|--------|------------------------------|
| Lead Full-Stack (NestJS + DevOps) | 1.0 | Senior, NestJS + PostgreSQL + AWS | ~48 000 € |
| Mobile Flutter | 1.0 | Senior, Flutter + Mapbox + FCM | ~44 000 € |
| PM / Product Designer | 0.5 | Figma, specs, tests utilisateurs | ~19 800 € |
| QA | 0.3 | Tests manuels + automatisés | ~10 560 € |
| **TOTAL DEV MVP** | | | **~122 000 €** |

### 25.2 V2 & Croissance

- Data/ML Engineer (recommandations IA) : 0.5 ETP
- Community Manager / Modérateur : 0.5 ETP
- Growth Marketer : 0.5 ETP

### 25.3 Outillage Équipe

| Outil | Usage |
|-------|-------|
| Linear | Sprints + tickets |
| Figma | Design + prototypes |
| GitHub | Code + PRs |
| Notion | Documentation |
| Slack | Communication |

---

## 26. STRATÉGIE CROISSANCE & RÉTENTION

### 26.1 Acquisition

**Phase 1 (M1-3) — Lancement local :**
- 2-3 villes pilotes (Lyon, Bordeaux, Toulouse)
- Activation clubs et associations sportives locales
- Ambassadeurs : coachs et organisateurs locaux (compte Pro offert 3 mois)
- Contenu TikTok/Reels : démo live de la carte

**Phase 2 (M4-9) — Expansion :**
- Referral intégré ("Invite un ami → +50 points chacun")
- SEO local ("partenaire tennis Lyon", "activité sport bordeaux")
- Meta Ads ciblé (sportifs 18-40 ans)

**Phase 3 (M10-18) — Scale national :**
- 10+ grandes villes
- Partenariats marques (Decathlon, Nike France)
- Événements IRL (tournois Séléné)

### 26.2 Rétention

1. **Notifications intelligentes** — nouvelles activités zone, rappels, défis
2. **Gamification** — streaks, badges, classements hebdomadaires
3. **Personnalisation IA** — recommandations qui s'améliorent
4. **Réseau social léger** — partenaires récurrents favoris
5. **Événements récurrents** — ancrage hebdomadaire via groupes

**Courbe de rétention cible :**
J1 : 65 % → J7 : 40 % → J30 : 25 % → J90 : 15 %

### 26.3 North Star Metric

**Matchs sportifs complétés par semaine**
= créateur + participant se sont rencontrés physiquement via Séléné.

---

## ANNEXE A — GLOSSAIRE

| Terme | Définition |
|-------|-----------|
| Activité | Session sportive publiée sur la carte |
| Match | Activité avec au moins un participant accepté |
| Invité | Utilisateur profil minimal |
| Membre | Utilisateur profil complet vérifié |
| Trust Score | Score de confiance comportemental |
| Activity Score | Score de gamification |
| Isochrone | Zone accessible en un temps donné selon un mode |
| No-show | Participant ne s'étant pas présenté |
| Geohash | Encodage géographique d'une zone en chaîne de caractères |

## ANNEXE B — CONTRAINTES TECHNIQUES

1. **WebSocket Scale > 10K connexions :** Passer de Redis single-node à Redis Cluster pour le Pub/Sub. Configurer l'ALB avec sticky sessions (`stickiness: lb_cookie`).

2. **PostGIS > 500K activités :** Partitionnement par `scheduled_at` (partition mensuelle). Les requêtes `ST_DWithin` sur une partition récente restent < 50ms.

3. **Mapbox coût > 10K MAU :** Migration vers MapLibre (voir section 24.3).

4. **iOS Push Notifications :** Utiliser certificats `.p8` (APNs Auth Key) plutôt que `.p12` pour éviter le renouvellement annuel.

5. **RGPD messages chat :** À la suppression d'un compte, `sender_id` → NULL, nom affiché → "Utilisateur supprimé". Le contenu est conservé pour les autres participants.

---

*Document version 1.1 — Corrections post-review Architects (Architect-Tech-1 + Architect-Tech-2)*
*Date : 29 mai 2026*
*Prochaine étape : Resoumission aux deux Architects pour validation*
