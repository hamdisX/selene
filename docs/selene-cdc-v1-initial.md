# SÉLÉNÉ — Cahier des Charges Complet
## Application Mobile de Mise en Relation Sportive Locale

---

| Champ            | Valeur                                      |
|------------------|---------------------------------------------|
| **Produit**      | Séléné                                      |
| **Version**      | 1.0 — Initial                               |
| **Date**         | 29 mai 2026                                 |
| **Statut**       | Draft — Revue Architects                    |
| **Confidentialité** | Confidentiel — Usage interne             |
| **Auteur**       | Équipe Produit Séléné                       |

---

## TABLE DES MATIÈRES

1. [Vision Produit & Proposition de Valeur](#1-vision-produit)
2. [Positionnement & Analyse Concurrentielle](#2-positionnement)
3. [Personas Utilisateurs](#3-personas)
4. [Concept & Logique Métier](#4-concept)
5. [Système d'Inscription en 2 Niveaux](#5-inscription)
6. [Parcours Utilisateurs Détaillés](#6-parcours)
7. [User Stories](#7-user-stories)
8. [Fonctionnalités MVP](#8-mvp)
9. [Fonctionnalités V2](#9-v2)
10. [Architecture Technique](#10-architecture)
11. [Schéma Base de Données](#11-bdd)
12. [APIs & Endpoints](#12-api)
13. [Temps Réel & Chat](#13-temps-reel)
14. [Sécurité & RGPD](#14-securite)
15. [Modération & Anti-Fraude](#15-moderation)
16. [Analytics & Admin Panel](#16-analytics)
17. [Modèle Freemium & Monétisation](#17-monetisation)
18. [Gamification & Rétention](#18-gamification)
19. [Matching Intelligent (IA)](#19-matching)
20. [Diagrammes Fonctionnels](#20-diagrammes)
21. [Structure Écrans & Navigation](#21-ecrans)
22. [UX/UI — Design System 2026](#22-ux)
23. [Roadmap Technique — Sprint par Sprint](#23-roadmap)
24. [Estimation Complexité & Coûts](#24-estimation)
25. [Équipe Nécessaire](#25-equipe)
26. [Stratégie Croissance & Rétention](#26-croissance)

---

## 1. VISION PRODUIT & PROPOSITION DE VALEUR

### 1.1 Vision

> **"Séléné connecte les sportifs locaux en temps réel autour d'une carte vivante de leur ville."**

Séléné est une application mobile qui résout un problème universel et quotidien : trouver des partenaires sportifs disponibles, à proximité, maintenant. Là où les réseaux sociaux génèrent du contenu passif et où les clubs sportifs imposent des engagements longs, Séléné crée des **connexions sportives spontanées et géolocalisées**.

Le cœur du produit n'est pas un système de swipe. C'est une **carte interactive vivante** où chaque point représente une activité sportive réelle, publiée par un humain, dans les minutes ou heures à venir.

### 1.2 Problème Résolu

| Problème utilisateur | Solution Séléné |
|----------------------|-----------------|
| "Je veux jouer au tennis mais n'ai pas de partenaire disponible" | Voir en temps réel qui joue près de soi |
| "Je ne connais pas les gens qui font du sport dans mon quartier" | Découvrir la communauté sportive locale |
| "Les applications sportives sont soit trop engageantes (clubs) soit trop sociales (Instagram)" | Un outil pur, centré sur l'action sportive immédiate |
| "Je suis nouveau en ville et veux rencontrer des sportifs" | Onboarding rapide, connexions immédiates |
| "Je veux organiser une partie mais ne sais pas qui contacter" | Publication d'activité avec gestion de participants |

### 1.3 Proposition de Valeur Unique (UVP)

**Pour les sportifs occasionnels à réguliers :**
> Séléné est la seule application qui transforme votre ville en terrain de jeu partagé, en connectant instantanément les sportifs disponibles autour d'une carte interactive géolocalisée.

**Tagline :** *"Ton sport. Ta ville. Maintenant."*

**Tagline secondaire :** *"La carte vivante des sportifs de ta ville."*

### 1.4 Indicateurs de Succès (KPIs Produit)

| Métrique | Cible MVP (6 mois) | Cible V2 (18 mois) |
|----------|--------------------|--------------------|
| Utilisateurs actifs mensuels (MAU) | 5 000 | 50 000 |
| Activités publiées / jour | 200 | 3 000 |
| Taux de conversion invité → membre | 40 % | 55 % |
| Taux de match accepté / demande | 60 % | 70 % |
| Session moyenne | 8 min | 12 min |
| Rétention J7 | 35 % | 50 % |
| NPS | > 40 | > 60 |

---

## 2. POSITIONNEMENT & ANALYSE CONCURRENTIELLE

### 2.1 Paysage Concurrentiel

| Application | Modèle | Limite vs Séléné |
|-------------|--------|------------------|
| Meetup | Événements communautaires | Pas temps réel, pas sportif-first, interface vieillissante |
| Fitfinder | Matching sportif | Modèle swipe, pas de carte, moins local |
| Decathlon Outdoor | Activités outdoor | Lié à une marque, pas de matching individuel |
| Strava | Tracking performance | Pas de matching, pas d'organisation spontanée |
| Facebook Groups | Groupes locaux | Généraliste, pas de carte, expérience dégradée mobile |
| Just-Play | Squash/padel | Très niche, pas multi-sport, peu de villes |
| Playtomic | Réservation courts | Payant, lié aux installations, pas de matching humain |

### 2.2 Avantages Différenciants Séléné

1. **Carte interactive temps réel** — visualisation immédiate des opportunités sportives
2. **Friction zéro au démarrage** — mode invité sans compte pour découvrir
3. **Recherche par temps de trajet** — pas juste la distance, mais la réalité du déplacement
4. **Inscription progressive** — pas de mur à l'entrée, engagement après valeur perçue
5. **Design 2026** — expérience mobile-native ultra-fluide, pas de webapp déguisée
6. **Matching par habitudes** — recommandations IA basées sur l'historique sportif
7. **Gamification intégrée** — rétention par le jeu, pas par l'obligation

---

## 3. PERSONAS UTILISATEURS

### Persona 1 — Léa, 26 ans, Sportive Occasionnelle

**Profil :** Graphiste freelance, Lyon 3ème. Fait du running 2x/semaine, joue au tennis quand elle trouve quelqu'un.

**Frustrations :**
- Ses amis ne sont jamais disponibles en même temps qu'elle
- Les clubs de tennis imposent des engagements annuels
- Elle ne sait pas qui fait du sport dans son quartier

**Comportement mobile :** Très active sur Instagram, utilise Google Maps quotidiennement, réticente aux apps nécessitant une inscription longue.

**Objectif Séléné :** Trouver un partenaire de tennis disponible samedi matin, à moins de 20 minutes à pied.

**Déclencheur d'adoption :** Découvrir en 30 secondes (mode invité) qu'il y a 3 activités tennis ce weekend à proximité.

---

### Persona 2 — Marc, 34 ans, Sportif Régulier

**Profil :** Développeur, Paris 11ème. Fait du foot 5x5 le jeudi soir, cherche à diversifier ses activités.

**Frustrations :**
- Organiser une partie de foot prend 2h de coordination WhatsApp
- Il aimerait essayer le padel mais ne connaît personne qui joue

**Comportement mobile :** Strava pour tracker, WhatsApp pour coordonner. Cherche l'efficacité.

**Objectif Séléné :** Créer une activité foot, recruter 4 joueurs rapidement, accéder au chat intégré pour coordination.

**Déclencheur d'adoption :** Publier une activité en 60 secondes et recevoir 2 demandes en 10 minutes.

---

### Persona 3 — Sophie, 41 ans, Organisatrice d'Événements Sportifs

**Profil :** Coach sportif indépendant, Bordeaux. Organise des sessions de yoga en plein air et des randonnées de groupe.

**Frustrations :**
- Gérer les inscriptions par email est archaïque
- Elle a besoin de visibilité locale sans budget pub
- Les annulations de dernière minute perturbent ses sessions

**Comportement mobile :** Utilise EventBrite et Facebook Events mais trouve les interfaces lourdes.

**Objectif Séléné :** Publier ses événements sportifs récurrents, gérer les participants, construire une base de fidèles.

**Déclencheur d'adoption :** Voir que son événement yoga apparaît sur la carte de 500 personnes dans son quartier.

---

### Persona 4 — Thomas, 22 ans, Utilisateur Invité / Nouveau en Ville

**Profil :** Étudiant en master, vient d'arriver à Toulouse. Joue au basketball, ne connaît personne.

**Frustrations :**
- Pas de réseau local pour trouver des partenaires sportifs
- Méfiant envers les apps qui demandent trop d'infos dès le départ

**Comportement mobile :** TikTok, Discord, Snapchat. Génération Z, UX instinctive.

**Objectif Séléné :** Explorer les activités basket à Toulouse sans créer de compte, rejoindre une partie.

**Déclencheur d'adoption :** Voir la carte chargée avec des icônes basketball et pouvoir demander à rejoindre en 3 clics.

---

## 4. CONCEPT & LOGIQUE MÉTIER

### 4.1 Le Cœur du Produit : La Carte Vivante

La carte est l'interface principale de Séléné. Elle affiche en temps réel toutes les activités sportives publiées autour de la position de l'utilisateur. Chaque activité est représentée par une icône personnalisée selon le sport (🎾 🚴 🏃 ⚽ 🏀 🎿...).

```
┌─────────────────────────────────────────┐
│  🔍  Recherche          Filtres ⚙️      │
│─────────────────────────────────────────│
│                                         │
│          [CARTE MAPBOX]                 │
│                                         │
│    🎾(2)    🏃(1)                       │
│                  ⚽(3)                  │
│      📍YOU           🚴(1)              │
│                                         │
│         🏀(1)    🎾(1)                  │
│                                         │
│─────────────────────────────────────────│
│  ← 5 activités dans 2km                │
└─────────────────────────────────────────┘
```

### 4.2 Flux Principal — Création et Rejoindre une Activité

```
CRÉATEUR                              PARTICIPANT
    │                                      │
    ▼                                      │
[Publier activité]                         │
    │ sport, lieu, date, heure,            │
    │ niveau, nb places, visibilité        │
    ▼                                      │
[Activité visible sur carte] ─────────────►│
                                           │
                              [Voit icône sur carte]
                                           │
                              [Consulte détails limités]
                              (sport, distance, heure,
                               nb places, niveau requis)
                                           │
                              [Demande à rejoindre]
    │                                      │
    ◄──────── [Notification push] ─────────┘
    │
    ▼
[Consulte profil demandeur]
(invité : pseudo, âge, genre, niveau)
(membre : profil complet)
    │
  ┌─┴──────────────────┐
  ▼                    ▼
[ACCEPTE]          [REFUSE]
  │                    │
  ▼                    ▼
[Chat ouvert]    [Notification refus]
[Détails complets]
[Match sportif créé]
```

### 4.3 Types d'Activités

| Type | Description | Exemple |
|------|-------------|---------|
| **Activité spontanée** | Aujourd'hui ou demain, 1-2 joueurs manquants | "Tennis ce soir 19h, cherche partenaire" |
| **Événement récurrent** | Session hebdomadaire, groupe fixe | "Yoga dimanche matin, 8 places" |
| **Événement ponctuel** | Événement daté, nombreux participants | "Tournoi basket 3x3, samedi 14h" |
| **Recherche de partenaire** | Sans date fixe, disponibilité ouverte | "Cherche partenaire running régulier" |

### 4.4 Sports Supportés (MVP)

Football, Tennis, Running, Cycling, Basketball, Volleyball, Badminton, Padel, Natation, Randonnée, Yoga, Fitness, Boxe, Escalade, Squash.

Extension V2 : sports de neige, sports nautiques, arts martiaux, e-sport local.

### 4.5 Système de Filtres

| Filtre | Options | Notes |
|--------|---------|-------|
| **Sport** | Liste complète + "Tous" | Multi-sélection |
| **Distance** | 1km / 2km / 5km / 10km / 20km | Rayon géographique |
| **Temps de trajet** | 10 min / 20 min / 30 min | Basé sur mode transport |
| **Mode transport** | Marche / Vélo / Voiture / Transport public | Utilise API routage |
| **Genre** | Mixte / Hommes / Femmes / Non-binaire | Respect du choix créateur |
| **Niveau** | Débutant / Intermédiaire / Confirmé / Expert | Auto-déclaré |
| **Date** | Aujourd'hui / Cette semaine / Ce weekend / Calendrier | |
| **Places disponibles** | Au moins 1 / 2+ / 5+ | |
| **Visibilité** | Public / Semi-privé (invité link) | |

---

## 5. SYSTÈME D'INSCRIPTION EN 2 NIVEAUX

### 5.1 Niveau 1 — Mode Invité

**Déclencheur :** Premier lancement de l'application.

**Données collectées :**
- Âge (curseur, pas de date de naissance exacte) — requis pour filtres et sécurité mineurs
- Genre (Homme / Femme / Non-binaire / Préfère ne pas dire)
- Pseudo (5-20 caractères, unicité vérifiée)
- Autorisation géolocalisation (indispensable au produit)

**Ce que l'invité peut faire :**
- Voir la carte et toutes les activités publiques
- Appliquer des filtres
- Consulter les détails limités d'une activité
- Envoyer une demande pour rejoindre une activité
- Recevoir notifications push (si autorisées)

**Ce que l'invité ne peut PAS faire :**
- Publier une activité
- Accéder au chat
- Voir les profils complets
- Créer un groupe
- Accéder à l'historique

**Persistance :** Le profil invité est stocké localement (UUID device) + minimal serveur pour les demandes.

### 5.2 Niveau 2 — Inscription Complète (déclenchée après 1er match accepté)

**Déclencheur :** Première demande acceptée par un créateur.

**Message affiché :**
> "🎉 Ta demande a été acceptée ! Pour accéder au chat et aux détails de l'activité, complète ton profil en 2 minutes."

**Données collectées (étapes progressives) :**
1. Email → vérification par lien
2. Numéro de téléphone → OTP SMS (Twilio)
3. Photo de profil (obligatoire, modérée par IA)
4. Prénom (affiché publiquement)
5. Sports pratiqués + niveaux associés
6. Biographie courte (optionnelle)

**Avantages immédiats de l'inscription complète :**
- Accès chat
- Publication d'activités
- Historique des matchs
- Score et badges
- Notifications personnalisées

### 5.3 Justification UX de l'Inscription Progressive

Cette approche réduit le **taux d'abandon à l'onboarding** (problème n°1 des apps sociales sportives). L'utilisateur voit la valeur (la carte vivante, les activités) AVANT d'être bloqué par un formulaire. Le déclencheur naturel (match accepté = preuve de valeur) rend l'inscription désirable, pas obligatoire.

---

## 6. PARCOURS UTILISATEURS DÉTAILLÉS

### 6.1 Parcours Invité — Découverte & Premier Match

```
[Télécharge l'app]
        │
        ▼
[Splash screen Séléné]
        │
        ▼
[Onboarding 3 slides] ← swipeable, skippable
"Trouve des sportifs près de toi"
"Rejoins une partie en 3 clics"
"Publie ton activité, recrute ton équipe"
        │
        ▼
[Profil invité] ← 30 secondes
Âge | Genre | Pseudo
        │
        ▼
[Demande géolocalisation] ← avec explication claire
        │
   ┌────┴────────┐
   ▼             ▼
[Acceptée]   [Refusée]
   │             │
   ▼             ▼
[CARTE]    [Liste activités
           mode manuel]
   │
   ▼
[Explore la carte]
Zoom / Pan / Tap sur icônes
        │
        ▼
[Tap activité] → [Bottom sheet]
Sport | Distance | Heure | Niveau | Places
        │
        ▼
[Bouton "Demander à rejoindre"]
        │
        ▼
[Confirmation demande envoyée]
[Notification push activée ?]
        │
        ▼
[En attente acceptation]
        │
   ┌────┴──────┐
   ▼           ▼
[Accepté]   [Refusé]
   │           │
   ▼           ▼
[Modale inscription] [Notification refus]
"Complète ton profil"    │
   │             [Retour carte]
   ▼
[INSCRIPTION COMPLÈTE]
→ voir 6.2
```

### 6.2 Parcours Inscription Complète

```
[Modale inscription déclenchée]
        │
        ▼
[Étape 1/4 — Email]
email@domaine.com → [Envoyer lien vérif]
        │
        ▼
[Vérification email] ← lien magic link
        │
        ▼
[Étape 2/4 — Téléphone]
+33 6 XX XX XX XX → [Envoyer OTP]
[Saisie code 6 chiffres] ← 60s timeout
        │
        ▼
[Étape 3/4 — Photo]
[Accès galerie / Caméra]
Photo recadrée automatiquement
Modération IA : détection visage obligatoire
        │
        ▼
[Étape 4/4 — Sports & Niveaux]
[Multi-select sports]
[Slider niveau par sport]
        │
        ▼
[Bienvenue !]
[Accès chat avec nouveau match]
[Retour carte avec statut membre]
```

### 6.3 Parcours Créateur d'Activité

```
[Bouton + (FAB) sur carte]
        │
        ▼
[Sélection sport] ← icônes visuelles
        │
        ▼
[Lieu de l'activité]
- Ma position actuelle
- Choisir sur carte
- Saisir adresse
        │
        ▼
[Détails activité]
Date | Heure | Durée estimée
Nombre de places (1-50)
Niveau requis
Description (optionnel)
        │
        ▼
[Visibilité]
○ Public (visible sur carte)
○ Privé (lien d'invitation uniquement)
○ Semi-privé (visible amis/groupes)
        │
        ▼
[Récurrence] (optionnel)
Une fois / Hebdomadaire / Personnalisé
        │
        ▼
[Aperçu] ← voir rendu sur carte
        │
        ▼
[Publier] → Activité live sur carte
[Notification aux utilisateurs filtrés à proximité]
```

### 6.4 Parcours Gestion Demandes (Créateur)

```
[Notification push] ← "Théo demande à rejoindre ton tennis"
        │
        ▼
[Ouvre notif → Tab Activités]
[Liste demandes pour cette activité]
        │
        ▼
[Profil du demandeur]
Photo | Pseudo | Niveau | Badges | Score | Avis
        │
   ┌────┴──────────────┐
   ▼                   ▼
[ACCEPTER]          [REFUSER]
   │                   │
   ▼                   ▼
[Chat ouvert]    [Notif envoyée]
[Match créé]     [Raison optionnelle]
[Décompte places MAJ]
   │
   ▼
[Activité "Complète" si 0 places restantes]
[ou reste visible si places dispo]
```

---

## 7. USER STORIES

### Epic 1 — Découverte (Invité)

| ID | Story | Priorité |
|----|-------|----------|
| US-001 | En tant qu'invité, je veux créer un profil minimal (âge, genre, pseudo) en moins de 30 secondes afin de commencer à explorer sans friction | P0 |
| US-002 | En tant qu'invité, je veux voir une carte géolocalisée avec les activités sportives proches afin de comprendre immédiatement la valeur de l'app | P0 |
| US-003 | En tant qu'invité, je veux filtrer les activités par sport et distance afin de ne voir que ce qui m'intéresse | P0 |
| US-004 | En tant qu'invité, je veux voir les détails d'une activité (sport, heure, lieu, niveau, places) afin de décider si elle me convient | P0 |
| US-005 | En tant qu'invité, je veux filtrer par temps de trajet (10/20/30 min) et mode de transport afin de trouver des activités réellement accessibles | P1 |

### Epic 2 — Participation

| ID | Story | Priorité |
|----|-------|----------|
| US-010 | En tant qu'invité, je veux envoyer une demande pour rejoindre une activité en 2 clics afin de manifester mon intérêt rapidement | P0 |
| US-011 | En tant qu'utilisateur, je veux être notifié quand ma demande est acceptée ou refusée afin de planifier ma journée | P0 |
| US-012 | En tant qu'utilisateur accepté, je veux accéder à un chat privé avec le créateur afin de coordonner les détails | P0 |
| US-013 | En tant qu'utilisateur, je veux voir l'historique de mes matchs sportifs afin de suivre mon activité | P1 |
| US-014 | En tant qu'utilisateur, je veux annuler ma participation jusqu'à 2h avant l'activité afin de gérer les imprévus | P1 |

### Epic 3 — Création & Organisation

| ID | Story | Priorité |
|----|-------|----------|
| US-020 | En tant que membre, je veux publier une activité sportive en moins de 60 secondes afin d'attirer des participants rapidement | P0 |
| US-021 | En tant que créateur, je veux recevoir une notification push dès qu'un utilisateur demande à rejoindre afin de répondre rapidement | P0 |
| US-022 | En tant que créateur, je veux accepter ou refuser chaque demande en consultant le profil du demandeur afin de contrôler la composition du groupe | P0 |
| US-023 | En tant que créateur, je veux définir un nombre maximum de participants afin d'éviter la suroccupation | P1 |
| US-024 | En tant que créateur, je veux créer des activités récurrentes (ex: foot chaque jeudi) afin de ne pas republier manuellement | P1 |
| US-025 | En tant que créateur, je veux rendre une activité privée (accessible par lien uniquement) afin d'organiser des événements fermés | P2 |

### Epic 4 — Profil & Réputation

| ID | Story | Priorité |
|----|-------|----------|
| US-030 | En tant que membre, je veux créer un profil complet avec photo, sports et niveaux afin d'être reconnu par la communauté | P0 |
| US-031 | En tant qu'utilisateur, je veux laisser un avis après un match afin de contribuer au score de réputation de mes partenaires | P1 |
| US-032 | En tant qu'utilisateur, je veux voir le score de réputation d'un autre utilisateur afin d'évaluer sa fiabilité | P1 |
| US-033 | En tant qu'utilisateur, je veux débloquer des badges selon mon activité afin de valoriser mon engagement | P2 |

### Epic 5 — Groupes & Communauté

| ID | Story | Priorité |
|----|-------|----------|
| US-040 | En tant que membre, je veux créer un groupe sportif (ex: "Les coureurs du 11ème") afin de fédérer une communauté locale | P2 |
| US-041 | En tant que membre, je veux rejoindre des groupes sportifs locaux afin de recevoir leurs activités en priorité | P2 |
| US-042 | En tant qu'organisateur, je veux publier des événements liés à un groupe afin de notifier automatiquement les membres | P2 |

### Epic 6 — Sécurité & Confort

| ID | Story | Priorité |
|----|-------|----------|
| US-050 | En tant qu'utilisateur, je veux signaler un comportement inapproprié afin de maintenir la qualité de la communauté | P0 |
| US-051 | En tant qu'utilisateur, je veux bloquer un autre utilisateur afin de ne plus voir ses activités ni recevoir ses demandes | P0 |
| US-052 | En tant qu'utilisateur féminin, je veux filtrer les activités pour ne voir que les activités mixtes ou féminines afin de me sentir en sécurité | P1 |
| US-053 | En tant que mineur, je veux que l'app détecte mon âge et limite mes interactions aux activités adaptées afin d'être protégé | P0 |

### Epic 7 — Premium & Monétisation

| ID | Story | Priorité |
|----|-------|----------|
| US-060 | En tant que membre premium, je veux voir qui a consulté mon activité afin d'adapter ma communication | P3 |
| US-061 | En tant que membre premium, je veux apparaître en tête de liste pour les activités correspondant à mon profil afin d'augmenter mes chances | P3 |
| US-062 | En tant que coach/organisateur pro, je veux accéder à des outils de gestion avancés (récurrence, stats, export) afin de professionnaliser mes sessions | P3 |

---

## 8. FONCTIONNALITÉS MVP

### 8.1 Carte & Géolocalisation

- [x] Carte Mapbox interactive (pan, zoom, clustering)
- [x] Géolocalisation de l'utilisateur en temps réel
- [x] Affichage des activités avec icônes sport
- [x] Clustering intelligent (>5 activités = badge numérique)
- [x] Recherche par rayon (1, 2, 5, 10, 20 km)
- [x] Recherche par temps de trajet (10/20/30 min) — 4 modes
- [x] Filtres : sport, distance, temps de trajet, niveau, genre, date
- [x] Actualisation automatique (WebSocket + pull-to-refresh)

### 8.2 Activités

- [x] Création d'activité (sport, lieu, date, heure, niveau, places)
- [x] Activités publiques / privées (lien d'invitation)
- [x] Gestion des demandes (accepter / refuser)
- [x] Gestion des participants
- [x] Annulation d'activité (avec notification participants)
- [x] Décompte automatique des places disponibles
- [x] Détails activité (bottom sheet sur carte)

### 8.3 Système de Match

- [x] Demande de participation (invité et membre)
- [x] Notification push au créateur
- [x] Acceptation / refus avec consultation profil
- [x] Déclencheur inscription complète (après 1er match accepté)
- [x] Création du "match sportif" enregistré

### 8.4 Chat

- [x] Chat temps réel (WebSocket) — débloqué après match accepté
- [x] Messages texte
- [x] Indicateurs de lecture (✓✓)
- [x] Historique des conversations
- [x] Notifications push pour nouveaux messages
- [x] Chat de groupe (si activité multi-participants)

### 8.5 Profil & Inscription

- [x] Mode invité (âge, genre, pseudo)
- [x] Inscription complète (email, tel, OTP, photo, sports)
- [x] Profil public (photo, pseudo, sports, niveau, score)
- [x] Modification du profil
- [x] Historique des matchs

### 8.6 Notifications Push

- [x] Demande pour rejoindre une activité
- [x] Acceptation / refus d'une demande
- [x] Nouveau message chat
- [x] Activité annulée
- [x] Rappel 1h avant activité
- [x] Nouvelles activités dans ma zone (opt-in)

### 8.7 Sécurité Minimale

- [x] Système de signalement (report)
- [x] Blocage utilisateur
- [x] Limitation des interactions mineurs (<18)
- [x] Modération photo de profil (IA)

---

## 9. FONCTIONNALITÉS V2

### 9.1 Groupes Sportifs

- [ ] Création et gestion de groupes
- [ ] Invitation et modération membres
- [ ] Activités liées aux groupes
- [ ] Feed du groupe
- [ ] Chat de groupe permanent

### 9.2 Événements Avancés

- [ ] Activités récurrentes (hebdomadaire, mensuel)
- [ ] Tournois et compétitions locales
- [ ] Événements multi-équipes
- [ ] Liste d'attente automatique
- [ ] Système de co-organisateurs

### 9.3 Recommandations IA

- [ ] Suggestions d'activités basées sur l'historique
- [ ] Matching intelligent : partenaires selon habitudes
- [ ] Prédiction de disponibilité
- [ ] Recommandation de lieux selon sport + météo
- [ ] "Pour toi" — section personnalisée

### 9.4 Gamification Avancée

- [ ] Badges et récompenses (voir section 18)
- [ ] Score activité global
- [ ] Classements locaux par sport
- [ ] Défis hebdomadaires ("10 km cette semaine")
- [ ] Niveau utilisateur (Rookie → Legend)

### 9.5 Intégrations Tierces

- [ ] Strava (import activités, sync)
- [ ] Apple Health / Google Fit
- [ ] Calendrier (Apple Calendar, Google Calendar)
- [ ] Partage social (Instagram Stories, WhatsApp)
- [ ] Météo intégrée sur les activités outdoor

### 9.6 Premium & Pro

- [ ] Abonnement premium mensuel/annuel
- [ ] Outils pro pour coachs et organisateurs
- [ ] Analytics pour organisateurs
- [ ] Mise en avant des activités (boost)
- [ ] Publicité locale contextuelle

### 9.7 Admin & Modération Avancée

- [ ] Panel admin complet
- [ ] Modération automatique (NLP pour le chat)
- [ ] Shadow ban
- [ ] Alertes automatiques comportements suspects
- [ ] Rapports de sécurité hebdomadaires

---

## 10. ARCHITECTURE TECHNIQUE

### 10.1 Vue d'ensemble

```
┌─────────────────────────────────────────────────────────┐
│                    CLIENTS MOBILES                      │
│              iOS (Flutter)  |  Android (Flutter)        │
└──────────────────┬──────────────────────┬───────────────┘
                   │ HTTPS / WSS          │
┌──────────────────▼──────────────────────▼───────────────┐
│                    API GATEWAY                          │
│            (Nginx / AWS API Gateway)                    │
│         Rate limiting | Auth | Load balancing           │
└──────────────────┬──────────────────────────────────────┘
                   │
     ┌─────────────┼─────────────────┐
     ▼             ▼                 ▼
┌─────────┐  ┌──────────┐   ┌──────────────┐
│REST API │  │WebSocket │   │ Push Service │
│NestJS   │  │Server    │   │ FCM / APNs   │
│Node.js  │  │Socket.io │   │              │
└────┬────┘  └────┬─────┘   └──────────────┘
     │             │
     ▼             ▼
┌─────────────────────────────────────────┐
│              COUCHE DONNÉES             │
│  PostgreSQL+PostGIS | Redis | S3/R2     │
└─────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────┐
│           SERVICES EXTERNES             │
│  Mapbox | Twilio | Cloudflare | OpenAI  │
└─────────────────────────────────────────┘
```

### 10.2 Stack Frontend (Mobile)

**Choix recommandé : Flutter**

| Critère | Flutter | React Native |
|---------|---------|--------------|
| Performance | Excellent (moteur Skia/Impeller) | Bon (bridge JS amélioré) |
| Carte Maps | `flutter_map` + Mapbox | react-native-mapbox-gl |
| Animations | Excellent | Bon avec Reanimated 3 |
| Communauté 2026 | En forte croissance | Mature et stable |
| Hot reload | Excellent | Excellent |
| DartPad/Tests | Bon | Bon |
| **Verdict** | **Recommandé** | Alternative valide |

**Packages Flutter clés :**
```yaml
dependencies:
  flutter_map: ^6.0.0          # Carte Mapbox/OSM
  mapbox_maps_flutter: ^2.0.0  # SDK Mapbox officiel
  socket_io_client: ^2.0.3     # WebSocket
  firebase_messaging: ^14.0.0  # Push notifications
  geolocator: ^10.0.0          # Géolocalisation
  flutter_secure_storage: ^9.0.0 # Stockage sécurisé tokens
  dio: ^5.3.0                  # HTTP client
  riverpod: ^2.4.0             # State management
  go_router: ^12.0.0           # Navigation
  cached_network_image: ^3.3.0 # Images avec cache
  image_picker: ^1.0.7         # Photo profil
  intl: ^0.18.0                # Internationalisation
```

### 10.3 Stack Backend

**Framework :** NestJS (Node.js / TypeScript)

**Justification NestJS :**
- Architecture modulaire adaptée à la croissance
- Support natif WebSocket (Socket.io gateway)
- Intégration TypeORM / Prisma
- Swagger auto-généré
- Guards et Interceptors pour auth et logs
- Scalable horizontalement

**Structure NestJS :**
```
src/
├── modules/
│   ├── auth/           # JWT, OTP, magic link
│   ├── users/          # Profils, préférences
│   ├── activities/     # CRUD activités
│   ├── matches/        # Logique matching
│   ├── chat/           # WebSocket chat
│   ├── notifications/  # Push FCM/APNs
│   ├── geo/            # PostGIS queries
│   ├── reports/        # Signalements
│   ├── groups/         # V2
│   └── admin/          # Panel admin
├── common/
│   ├── guards/         # AuthGuard, RolesGuard
│   ├── interceptors/   # Logging, transform
│   ├── filters/        # Exception filters
│   └── pipes/          # Validation
└── config/             # Env, database, cache
```

### 10.4 Base de Données

**PostgreSQL 15+ avec extension PostGIS**

PostGIS est indispensable pour :
- `ST_DWithin` — activités dans un rayon
- `ST_Distance` — distance entre deux points GPS
- `ST_GeomFromText` — stockage coordonnées
- Index GIST sur colonnes géographiques (performances)

**Redis 7+**
- Sessions WebSocket
- Cache des activités chaudes (TTL 5 min)
- Rate limiting
- Files d'attente (Bull) pour notifications async
- Pub/Sub pour diffusion temps réel

### 10.5 Services Tiers

| Service | Usage | Alternative |
|---------|-------|-------------|
| **Mapbox** | Carte interactive, routage, isochrones | Google Maps |
| **Twilio** | OTP SMS, vérification téléphone | Firebase Phone Auth |
| **Firebase Cloud Messaging** | Push notifications Android | — |
| **APNs** | Push notifications iOS | — |
| **Cloudflare R2** | Stockage photos profil | AWS S3 |
| **Cloudflare CDN** | Cache statiques, DDoS | AWS CloudFront |
| **OpenAI API** | Modération contenu, recommandations | Modèle local |
| **Sentry** | Monitoring erreurs | Datadog |
| **PostHog** | Analytics produit | Mixpanel, Amplitude |
| **Resend** | Emails transactionnels | SendGrid, Mailgun |

### 10.6 Infrastructure Cloud (AWS recommandé)

```
Production :
├── ECS Fargate (API + WebSocket — auto-scaling)
├── RDS Aurora PostgreSQL (Multi-AZ)
├── ElastiCache Redis (Cluster mode)
├── Application Load Balancer
├── CloudFront CDN
├── S3 / Cloudflare R2
├── Route 53 DNS
└── WAF + Shield (DDoS)

CI/CD :
├── GitHub Actions
├── ECR (images Docker)
├── Terraform (IaC)
└── GitHub Environments (dev/staging/prod)
```

---

## 11. SCHÉMA BASE DE DONNÉES

### 11.1 Tables Principales

```sql
-- UTILISATEURS
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pseudo VARCHAR(20) UNIQUE NOT NULL,
    age_range VARCHAR(10),                    -- '18-25', '26-35', etc.
    gender VARCHAR(20),
    -- Données inscription complète (nullable tant qu'invité)
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    phone_verified BOOLEAN DEFAULT FALSE,
    email_verified BOOLEAN DEFAULT FALSE,
    first_name VARCHAR(50),
    avatar_url TEXT,
    bio TEXT,
    -- Statut
    is_guest BOOLEAN DEFAULT TRUE,
    is_active BOOLEAN DEFAULT TRUE,
    is_banned BOOLEAN DEFAULT FALSE,
    trust_score INTEGER DEFAULT 50,           -- 0-100
    -- Géo dernière position (opt-in)
    last_location GEOGRAPHY(POINT, 4326),
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- SPORTS
CREATE TABLE sport_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    icon_url TEXT,
    emoji CHAR(10),
    category VARCHAR(30)                      -- 'collectif', 'individuel', 'raquette', etc.
);

-- SPORTS UTILISATEUR
CREATE TABLE user_sports (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    sport_id INTEGER REFERENCES sport_types(id),
    level VARCHAR(20) NOT NULL,               -- 'beginner', 'intermediate', 'advanced', 'expert'
    PRIMARY KEY (user_id, sport_id)
);

-- ACTIVITÉS
CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    sport_id INTEGER REFERENCES sport_types(id),
    title VARCHAR(100),
    description TEXT,
    -- Géolocalisation
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    address TEXT NOT NULL,
    location_name VARCHAR(100),               -- "Parc de la Tête d'Or, court 3"
    -- Timing
    scheduled_at TIMESTAMPTZ NOT NULL,
    duration_minutes INTEGER,
    -- Participants
    max_participants INTEGER NOT NULL DEFAULT 2,
    current_participants INTEGER DEFAULT 1,   -- créateur inclus
    -- Attributs
    required_level VARCHAR(20),
    gender_filter VARCHAR(20) DEFAULT 'all',  -- 'all', 'male', 'female', 'mixed'
    -- Visibilité
    visibility VARCHAR(20) DEFAULT 'public',  -- 'public', 'private', 'link'
    invite_token UUID DEFAULT gen_random_uuid(),
    -- Récurrence (V2)
    is_recurring BOOLEAN DEFAULT FALSE,
    recurrence_rule TEXT,                     -- RRULE format
    -- Statut
    status VARCHAR(20) DEFAULT 'active',      -- 'active', 'full', 'cancelled', 'completed'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Index géographique
CREATE INDEX idx_activities_location ON activities USING GIST(location);
CREATE INDEX idx_activities_scheduled ON activities(scheduled_at);
CREATE INDEX idx_activities_status ON activities(status);

-- DEMANDES DE PARTICIPATION
CREATE TABLE activity_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES activities(id) ON DELETE CASCADE,
    requester_id UUID REFERENCES users(id) ON DELETE CASCADE,
    message TEXT,                             -- message optionnel à la demande
    status VARCHAR(20) DEFAULT 'pending',     -- 'pending', 'accepted', 'rejected', 'cancelled'
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(activity_id, requester_id)
);

-- MATCHS SPORTIFS (activité + participants validés)
CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES activities(id),
    chat_room_id UUID REFERENCES chat_rooms(id),
    status VARCHAR(20) DEFAULT 'upcoming',    -- 'upcoming', 'ongoing', 'completed', 'cancelled'
    occurred_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE match_participants (
    match_id UUID REFERENCES matches(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'participant',   -- 'organizer', 'participant'
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (match_id, user_id)
);

-- CHAT
CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) DEFAULT 'match',         -- 'match', 'group', 'direct'
    name VARCHAR(100),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID REFERENCES chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL,
    content_type VARCHAR(20) DEFAULT 'text',  -- 'text', 'image', 'system'
    is_moderated BOOLEAN DEFAULT FALSE,
    moderation_reason TEXT,
    read_by UUID[] DEFAULT '{}',
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- AVIS & RÉPUTATION
CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reviewer_id UUID REFERENCES users(id),
    reviewed_id UUID REFERENCES users(id),
    match_id UUID REFERENCES matches(id),
    rating INTEGER CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(reviewer_id, match_id)
);

-- SIGNALEMENTS
CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID REFERENCES users(id),
    reported_user_id UUID REFERENCES users(id),
    reported_activity_id UUID REFERENCES activities(id),
    reported_message_id UUID REFERENCES messages(id),
    category VARCHAR(50) NOT NULL,            -- 'fake', 'harassment', 'spam', 'inappropriate'
    description TEXT,
    status VARCHAR(20) DEFAULT 'pending',     -- 'pending', 'reviewed', 'resolved', 'dismissed'
    admin_note TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- BLOCAGES
CREATE TABLE blocks (
    blocker_id UUID REFERENCES users(id) ON DELETE CASCADE,
    blocked_id UUID REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (blocker_id, blocked_id)
);

-- BADGES
CREATE TABLE badges (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    icon_url TEXT,
    condition_type VARCHAR(50),               -- 'matches_count', 'sports_variety', etc.
    condition_value INTEGER
);

CREATE TABLE user_badges (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER REFERENCES badges(id),
    earned_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (user_id, badge_id)
);

-- GROUPES (V2)
CREATE TABLE groups (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    sport_id INTEGER REFERENCES sport_types(id),
    avatar_url TEXT,
    location GEOGRAPHY(POINT, 4326),
    city VARCHAR(100),
    is_public BOOLEAN DEFAULT TRUE,
    max_members INTEGER,
    creator_id UUID REFERENCES users(id),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE group_members (
    group_id UUID REFERENCES groups(id) ON DELETE CASCADE,
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) DEFAULT 'member',        -- 'admin', 'moderator', 'member'
    joined_at TIMESTAMPTZ DEFAULT NOW(),
    PRIMARY KEY (group_id, user_id)
);

-- NOTIFICATIONS
CREATE TABLE push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform VARCHAR(10) NOT NULL,            -- 'ios', 'android'
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id, token)
);
```

---

## 12. APIs & ENDPOINTS

### 12.1 REST API

**Base URL :** `https://api.selene.app/v1`

**Auth :** Bearer JWT (header `Authorization: Bearer <token>`)

#### Authentification

```
POST /auth/guest              → Créer profil invité
POST /auth/email/request      → Demander magic link email
POST /auth/email/verify       → Vérifier token email
POST /auth/phone/request      → Envoyer OTP SMS
POST /auth/phone/verify       → Vérifier OTP
POST /auth/refresh            → Rafraîchir token JWT
POST /auth/logout             → Invalider token
```

#### Utilisateurs

```
GET    /users/me              → Mon profil
PUT    /users/me              → Modifier mon profil
DELETE /users/me              → Supprimer compte (RGPD)
GET    /users/:id             → Profil public d'un utilisateur
POST   /users/me/avatar       → Upload photo profil
GET    /users/me/matches      → Historique matchs
GET    /users/me/badges       → Mes badges
```

#### Activités

```
GET    /activities                        → Liste avec filtres géo
GET    /activities/:id                    → Détail activité
POST   /activities                        → Créer activité (membre only)
PUT    /activities/:id                    → Modifier activité (créateur)
DELETE /activities/:id                    → Supprimer activité
GET    /activities/nearby                 → Activités proches (lat, lng, radius)
GET    /activities/isochrone              → Activités par temps de trajet
POST   /activities/:id/requests           → Demander à rejoindre
GET    /activities/:id/requests           → Voir demandes (créateur)
PUT    /activities/:id/requests/:reqId    → Accepter/refuser
DELETE /activities/:id/requests/:reqId    → Annuler demande
```

#### Chat

```
GET  /chat/rooms              → Mes conversations
GET  /chat/rooms/:id          → Détail room
GET  /chat/rooms/:id/messages → Historique messages (pagination)
```

#### Signalements & Sécurité

```
POST /reports                 → Signaler utilisateur/activité/message
POST /blocks                  → Bloquer utilisateur
DELETE /blocks/:userId        → Débloquer
GET  /blocks                  → Liste utilisateurs bloqués
```

#### Push Tokens

```
POST   /push/tokens           → Enregistrer token push
DELETE /push/tokens/:id       → Désinscrire
```

#### Admin (scope restreint)

```
GET    /admin/users           → Liste utilisateurs
PUT    /admin/users/:id/ban   → Bannir utilisateur
GET    /admin/reports         → Liste signalements
PUT    /admin/reports/:id     → Traiter signalement
GET    /admin/stats           → Statistiques dashboard
```

### 12.2 WebSocket Events (Socket.io)

**Namespace :** `/chat` et `/live`

```javascript
// Connexion
socket.emit('join_room', { roomId: 'uuid' })
socket.emit('leave_room', { roomId: 'uuid' })

// Chat
socket.emit('send_message', { roomId, content, contentType })
socket.on('new_message', { id, senderId, content, createdAt })
socket.on('message_read', { messageId, readBy })

// Activités live
socket.emit('subscribe_area', { lat, lng, radius })
socket.on('activity_created', { activity })
socket.on('activity_updated', { activityId, changes })
socket.on('activity_deleted', { activityId })
socket.on('activity_full', { activityId })

// Notifications
socket.on('request_received', { requestId, activityId, requester })
socket.on('request_accepted', { requestId, matchId, chatRoomId })
socket.on('request_rejected', { requestId, reason })
```

### 12.3 API Mapbox utilisées

| API | Usage |
|-----|-------|
| Maps GL | Rendu carte interactif |
| Geocoding | Recherche adresse → coordonnées |
| Directions | Calcul itinéraire + durée trajet |
| Isochrone | Zone accessible en X minutes |
| Static Images | Miniatures carte pour notifications |

---

## 13. TEMPS RÉEL & CHAT

### 13.1 Architecture WebSocket

```
Client Flutter                       Serveur NestJS
     │                                    │
     │──── WS Handshake (JWT) ───────────►│
     │◄─── Connected ────────────────────│
     │                                    │
     │──── subscribe_area({lat,lng,r}) ──►│
     │                         │         │
     │                    PostGIS query  │
     │                    Redis subscribe │
     │                                    │
     │◄─── activity_created({...}) ──────│
     │    (autre user publie une activité)│
     │                                    │
     │──── join_room({roomId}) ──────────►│
     │                                    │
     │──── send_message({...}) ──────────►│
     │                    Sauvegarde BDD  │
     │                    Redis pub →     │
     │◄─── new_message({...}) ───────────│ ← Tous les membres du room
```

### 13.2 Chat — Fonctionnalités Techniques

**Persistance :** Tous les messages en PostgreSQL, chargement paginé (cursor-based).

**Délivrance garantie :**
- Message status : `sending` → `sent` → `delivered` → `read`
- Retry automatique si connexion perdue (3 tentatives)
- Queue Redis pour messages offline (FCM push si user déconnecté)

**Modération en temps réel :**
- Analyse contenu (OpenAI Moderation API ou Perspective API)
- Score toxicité → modération automatique si score > 0.85
- Flag pour review manuelle si score 0.60-0.85

### 13.3 Notifications Push — Architecture

```
Event (demande, message, etc.)
        │
        ▼
[NestJS Event Emitter]
        │
        ▼
[Bull Queue — notifications]
        │
   ┌────┴──────────────┐
   ▼                   ▼
[FCM — Android]    [APNs — iOS]
        │
        ▼
[Appareil utilisateur]
```

**Types de notifications :**

| Événement | Titre | Corps |
|-----------|-------|-------|
| Demande reçue | "Nouvelle demande ! 🎾" | "{pseudo} veut rejoindre ton activité" |
| Demande acceptée | "C'est parti ! ✅" | "{pseudo} a accepté ta demande" |
| Demande refusée | "Pas de chance 😔" | "{pseudo} n'a pas de place disponible" |
| Nouveau message | "{pseudo}" | "{aperçu message}" |
| Rappel activité | "Dans 1h — {sport} 🏃" | "Prépare-toi pour ton activité !" |
| Activité annulée | "Activité annulée ❌" | "{sport} de {pseudo} est annulé" |

---

## 14. SÉCURITÉ & RGPD

### 14.1 Sécurité Applicative

**Authentification :**
- JWT access token (15 min expiry) + refresh token (30 jours)
- Refresh token rotation (invalidation à chaque renouvellement)
- Stockage tokens : Flutter Secure Storage (Keychain iOS / Keystore Android)
- OTP SMS via Twilio : code 6 chiffres, TTL 120 secondes, max 3 tentatives
- Rate limiting : 5 tentatives OTP/email / 15 min / IP

**Transport :**
- HTTPS/TLS 1.3 obligatoire
- Certificate pinning sur mobile (production)
- HSTS header

**API :**
- Rate limiting global : 1000 req/min/IP
- Rate limiting par endpoint sensible : 10 req/min
- Input validation (class-validator NestJS)
- SQL injection : ORM TypeORM (requêtes préparées)
- XSS : sanitisation contenu text
- CORS configuré domaines autorisés

**Stockage données sensibles :**
- Mots de passe : bcrypt (cost 12) — pas de mot de passe classique, auth passwordless
- Numéros de téléphone : chiffrés en base (AES-256)
- Positions GPS : stockées localement, envoyées uniquement pour les requêtes
- Logs : anonymisés, TTL 90 jours

### 14.2 RGPD (Règlement Général sur la Protection des Données)

**Base légale :** Consentement explicite + Intérêt légitime

**Données collectées et finalités :**

| Donnée | Finalité | Durée conservation |
|--------|----------|--------------------|
| Email | Authentification, communication | Durée compte + 1 an |
| Téléphone | Vérification, sécurité | Durée compte + 1 an |
| Photo profil | Identification | Durée compte + 30 jours |
| Position GPS | Fonctionnement service (carte) | Session uniquement |
| Historique matchs | Fonctionnalités, réputation | Durée compte + 2 ans |
| Messages chat | Fonctionnement service | 1 an |
| Logs navigation | Analytics, sécurité | 90 jours |

**Droits utilisateurs (implémentés dans l'app) :**
- **Droit d'accès** : Export de toutes ses données (format JSON) — délai 72h
- **Droit de rectification** : Modification profil en temps réel
- **Droit à l'effacement** : Suppression compte + données (sauf légal) — délai 30 jours
- **Droit à la portabilité** : Export structuré
- **Droit d'opposition** : Opt-out analytics, opt-out notifications marketing
- **Droit de retrait consentement** : Géolocalisation désactivable sans perte totale de service

**DPO et registre de traitements :** Nommer un DPO (ou prestataire externe) avant lancement.

**Sous-traitants :** Mapbox, Twilio, AWS, Firebase — tous avec DPA (Data Processing Agreement).

**Mineurs :**
- < 13 ans : interdiction absolue d'utilisation
- 13-17 ans : mode restreint (pas de profil public complet, interactions limitées)
- Détection par âge déclaré à l'onboarding

### 14.3 Sécurité Infrastructure

- Secrets gérés via AWS Secrets Manager / HashiCorp Vault
- VPC privé pour bases de données (jamais exposées directement)
- Firewall WAF (règles OWASP Core Rule Set)
- Backup quotidien PostgreSQL (point-in-time recovery 35 jours)
- Monitoring intrusion : AWS GuardDuty / CloudTrail
- Pentest annuel obligatoire avant chaque release majeure

---

## 15. MODÉRATION & ANTI-FRAUDE

### 15.1 Système de Signalement

**Types de signalements :**
- `fake_account` — compte faux / usurpation d'identité
- `harassment` — harcèlement, messages inappropriés
- `spam` — publicité, contenu commercial non sollicité
- `inappropriate_content` — photo / contenu offensant
- `dangerous_activity` — activité potentiellement dangereuse
- `other` — autre (champ texte libre)

**Flux de traitement :**
```
[Signalement soumis]
        │
        ▼
[Analyse automatique IA]
        │
   ┌────┴──────────────────┐
   ▼                       ▼
[Score élevé]         [Score faible]
[Action auto]         [Queue modérateur]
   │                       │
   ▼                       ▼
[Shadow ban temp]    [Review manuelle 48h]
[Notification user]  [Action selon jugement]
```

**Score de confiance (trust_score) :**
- Starts at 50/100 for all users
- +5 : avis positif reçu
- +10 : email vérifié
- +15 : téléphone vérifié
- +20 : photo modérée acceptée
- -10 : signalement fondé
- -30 : avertissement admin
- 0-20 : suspension automatique + review
- < 0 : ban permanent

### 15.2 Anti-Fake Accounts

**Mécanismes :**
1. **OTP téléphone obligatoire** pour publier une activité (1 compte / numéro)
2. **Photo de profil obligatoire** avec détection de vrai visage (AWS Rekognition / Face.io)
3. **Détection comportement bot** : trop de demandes rapides, pattern suspect
4. **Vérification email** : domaine jetable bloqué (liste à jour)
5. **Device fingerprinting** : limite les créations de comptes par device
6. **Score trust minimal** pour certaines actions (publier activité : trust ≥ 40)

### 15.3 Anti-Harcèlement

**Prévention :**
- Chat uniquement entre matchs acceptés (pas de messagerie froide)
- Blocage facile (1 tap depuis profil ou message)
- Après 3 blocages mutuels → alerte admin
- Filtre genre sur les activités (femmes peuvent filtrer "femmes uniquement")

**Détection automatique :**
- Modération NLP sur messages (Perspective API Google)
- Mots clés interdits (liste évolutive)
- Pattern détection : messages répétitifs, envoi masse

**Réponse :**
- Warning visible à l'auteur
- Masquage message (shadow mod)
- Suspension 24h → 7j → permanent
- Possibilité appel via formulaire

### 15.4 Système de Blocage

```
[User A bloque User B]
        │
        ▼
- User B disparaît de la carte de A
- User A disparaît de la carte de B
- Toute demande de l'un vers l'autre : silencieusement ignorée
- Messages non délivrés
- Blocage silencieux (B ne sait pas qu'il est bloqué)
```

### 15.5 Système de Réputation

**Composantes du score (0-100) :**

| Composante | Poids | Description |
|------------|-------|-------------|
| Fiabilité présence | 30 % | Se présente aux activités acceptées |
| Avis reçus | 30 % | Moyenne des notes post-match |
| Ancienneté | 15 % | Durée de présence active |
| Vérifications | 15 % | Email, téléphone, photo |
| Signalements | -10 % | Pénalité par signalement fondé |

**Niveaux de réputation :**
- ⭐⭐⭐⭐⭐ Excellent (85-100) : badge "Partenaire de confiance"
- ⭐⭐⭐⭐ Bon (65-84)
- ⭐⭐⭐ Moyen (45-64)
- ⭐⭐ Faible (25-44) : avertissement visible
- ⭐ Très faible (<25) : restrictions fonctionnelles

---

## 16. ANALYTICS & ADMIN PANEL

### 16.1 Métriques Produit (PostHog)

**Acquisition :**
- Nouveaux utilisateurs / jour / semaine
- Source d'acquisition (organique, référral, paid)
- Taux d'installation → onboarding

**Engagement :**
- DAU / MAU (ratio cible : 30 %+)
- Sessions par utilisateur / jour
- Durée moyenne de session
- Activités créées / demandes envoyées / matchs réalisés
- Carte vue : sports les plus consultés, zones géographiques actives

**Rétention :**
- Courbes de rétention J1, J7, J30
- Taux de conversion invité → membre
- Taux d'abandon à chaque étape onboarding
- Retention par cohorte

**Revenue (V2) :**
- MRR / ARR
- LTV par utilisateur premium
- Taux de conversion free → premium

### 16.2 Admin Panel (Interface Web)

**Technologie :** React + Vite + Tailwind CSS (interface web admin distincte de l'app mobile)

**Modules :**

| Module | Fonctionnalités |
|--------|----------------|
| **Dashboard** | KPIs temps réel, carte de chaleur activités, alertes sécurité |
| **Utilisateurs** | Recherche, consultation profil, historique, ban/suspend, trust score |
| **Activités** | Liste, modération, suppression, stats par sport/zone |
| **Signalements** | Queue de modération, workflow accept/dismiss, notes admin |
| **Chat** | Accès logs (scope restreint, procédure légale), signalements messages |
| **Analytics** | Tableaux de bord PostHog/Grafana intégrés |
| **Configurations** | Liste noire mots, zones géographiques, features flags |
| **Notifications** | Envoi notifications broadcast, ciblées |

**Accès :** Authentification séparée (SSO interne), rôles (Super Admin, Modérateur, Lecteur).

---

## 17. MODÈLE FREEMIUM & MONÉTISATION

### 17.1 Version Gratuite (Free)

**Toujours gratuit :**
- Carte et exploration des activités
- 3 demandes de participation / jour
- 1 activité publiée en simultané
- Chat avec matchs actifs
- Profil de base
- Historique 30 jours

### 17.2 Séléné Premium

**Prix :** 4,99 €/mois ou 39,99 €/an (33 % de réduction)

**Fonctionnalités :**
- Demandes illimitées
- Jusqu'à 5 activités simultanées
- Voir qui a consulté mon activité
- Boost de visibilité (priorité dans les résultats filtrés)
- Filtres avancés (disponibilité calendrier, style de jeu)
- Statistiques personnelles avancées
- Badge "Premium" visible sur profil
- Historique illimité
- Accès anticipé nouvelles fonctionnalités

### 17.3 Séléné Pro (Pour Coachs & Organisateurs)

**Prix :** 14,99 €/mois ou 119,99 €/an

**Fonctionnalités :**
- Tout Premium inclus
- Activités récurrentes illimitées
- Jusqu'à 50 participants par activité
- Page profil pro (lien site, bio longue)
- Outils gestion participants (présence, liste attente)
- Export données (CSV)
- Analytics de ses événements
- Support prioritaire

### 17.4 Publicité Locale Contextuelle

**Format :** Bannières discrètes dans la liste d'activités (non intrusif, pas sur la carte)

**Ciblage :**
- Sport pratiqué (salle de tennis → publicité raquette/balle)
- Géolocalisation (salle de sport à 500m)
- Niveau sportif

**Acteurs cibles :**
- Salles de sport locales
- Clubs sportifs
- Marques équipement (Decathlon, Nike, Adidas)
- Applications bien-être (nutrition, récupération)

**Revenus estimés :** CPM 8-15 €, CPC 0.30-1.50 €

### 17.5 Partenariats B2B

- **Salles de sport :** Page officielle sur Séléné, promotion activités membres, booking intégré (V2)
- **Clubs sportifs :** Visibilité événements, recrutement membres
- **Mairies / collectivités :** Promotion équipements sportifs publics
- **API B2B :** Accès données anonymisées locales (flux sportif par quartier) pour urbanistes, marques
- **White label :** Version branded pour fédérations sportives

### 17.6 Projections Financières (12 mois post-lancement)

| Source | Scénario conservateur | Scénario optimiste |
|--------|-----------------------|--------------------|
| Premium (5% MAU × 4.99€) | 1 250 €/mois | 7 500 €/mois |
| Pro (0.5% MAU × 14.99€) | 375 €/mois | 1 500 €/mois |
| Publicité | 500 €/mois | 3 000 €/mois |
| **TOTAL** | **~2 125 €/mois** | **~12 000 €/mois** |

*(Base MAU : 5 000 utilisateurs à 12 mois)*

---

## 18. GAMIFICATION & RÉTENTION

### 18.1 Système de Badges

| Badge | Condition | Rareté |
|-------|-----------|--------|
| 🏃 Première foulée | 1er match complété | Commun |
| 🎾 Multi-sport | 3 sports différents | Commun |
| 🌟 5 étoiles | Score réputation ≥ 90 | Rare |
| 🔥 En feu | 5 matchs en 1 semaine | Peu commun |
| 🗺️ Explorateur | Activités dans 3 villes différentes | Peu commun |
| 👥 Organisateur | 10 activités créées | Peu commun |
| 🏆 Champion local | Top 10 sport dans sa ville | Rare |
| 💎 Vétéran | 100 matchs complétés | Épique |
| 🤝 Ambassadeur | 5 amis parrainés | Rare |
| ⭐ Séléné Star | Élu meilleur partenaire du mois | Légendaire |

### 18.2 Score Activité (Activity Score)

Calculé en continu pour chaque utilisateur, visible sur le profil.

**Formule :**
```
Score = (Matchs × 10) + (Diversité sports × 15) + (Avis positifs × 8) 
      + (Activités créées × 12) + (Présences confirmées × 5)
      - (No-shows × -20) - (Signalements fondés × -50)
```

**Niveaux :**
- 🥉 Rookie (0-100)
- 🥈 Challenger (101-300)
- 🥇 Warrior (301-700)
- 💎 Elite (701-1500)
- 👑 Legend (1500+)

### 18.3 Défis Hebdomadaires

Chaque lundi, 3 défis générés automatiquement selon le profil :
- "Fais 3 matchs cette semaine" → +50 points
- "Essaie un nouveau sport" → Badge + 80 points
- "Crée 2 activités et recrute des joueurs" → +60 points

### 18.4 Classements Locaux

- Top 10 sportifs de la semaine (par ville, par sport)
- Visible publiquement, opt-out disponible
- Récompenses symboliques (badge "Top de la semaine")

### 18.5 Streak System

- Streak hebdomadaire : participer à au moins 1 activité / semaine
- Streak brisée → notification de "relance"
- Streak 4 semaines → badge + boost de profil temporaire

---

## 19. MATCHING INTELLIGENT (IA)

### 19.1 Algorithme de Recommandation MVP

**Filtrage collaboratif simplifié** basé sur :
1. Sports pratiqués en commun
2. Niveaux sportifs compatibles (±1 niveau)
3. Historique géographique (zones habituelles)
4. Horaires habituels (analyse des matchs passés)
5. Score de compatibilité (avis post-match)

**Résultat :** Section "Activités recommandées pour toi" (top 5) en bas de la carte.

### 19.2 Algorithme Avancé (V2)

**Modèle de recommandation :**
```
Input features :
- Vector sports/niveaux utilisateur
- Vector historique temporel (horaires habituels)
- Vector géographique (clusters de lieux fréquentés)
- Score de compatibilité avec d'autres users (post-match ratings)
- Météo prévue (pour sports outdoor)

Output :
- Score de pertinence pour chaque activité visible
- Ranking personnalisé des activités sur la carte
- Suggestions de nouveaux sports à essayer
```

**Stack IA V2 :** Python (FastAPI micro-service) + scikit-learn / LightGBM + feature store Redis.

### 19.3 Matching de Partenaires

En V2, possibilité de créer un profil de recherche de partenaire régulier :
- "Cherche partenaire tennis 1x/semaine, niveau intermédiaire, Lyon 3ème"
- L'algorithme notifie quand un profil compatible rejoint la zone
- Pas de swipe — une liste ordonnée par compatibilité, consultable une fois/jour

---

## 20. DIAGRAMMES FONCTIONNELS

### 20.1 Flux Complet Publication → Match

```
┌─────────────────────────────────────────────────────────────┐
│                     FLUX PRINCIPAL SÉLÉNÉ                   │
└─────────────────────────────────────────────────────────────┘

UTILISATEUR A (CRÉATEUR)          UTILISATEUR B (PARTICIPANT)
         │                                    │
         │ 1. Ouvre l'app                     │ 1. Ouvre l'app
         │ 2. Crée activité                   │ 2. Voit carte
         │    → Sport: Tennis                  │ 3. Voit icône 🎾
         │    → Lieu: Parc Tête d'Or           │ 4. Tap sur icône
         │    → Date: Aujourd'hui 18h          │ 5. Bottom sheet :
         │    → Niveau: Intermédiaire          │    "Tennis - 2km"
         │    → Places: 1                      │    "Aujourd'hui 18h"
         │                                    │    "Intermédiaire"
         │ 3. Publie → Activité live           │    "1 place disponible"
         │            sur carte                │
         │                                    │ 6. "Demander à rejoindre"
         │                                    │    → Confirmation
         │                                    │
         │ 4. 🔔 Notification push             │ 7. En attente...
         │    "Karim demande à               │
         │     rejoindre ton tennis"          │
         │                                    │
         │ 5. Consulte profil Karim           │
         │    Photo | Niveau | Score          │
         │                                    │
         │ 6. ACCEPTE ─────────────────────► 8. 🔔 "Accepté !"
         │                                    │    "Complète ton profil"
         │                                    │    (si invité)
         │                                    │
         │ 7. Chat ouvert ◄──────────────────► Chat ouvert
         │                                    │
         │         "Allô ! On joue court 3 ?" │
         │                    "Parfait, j'arrive !" │
         │                                    │
         │ 8. MATCH CRÉÉ                      │ Match confirmé
         │    → Rappel 1h avant               │ → Rappel 1h avant
         │                                    │
         │ 9. POST-MATCH                      │
         │    Avis laissés mutuellement       │
         │    Badges débloqués                │
         │    Score mis à jour                │
```

### 20.2 Diagramme Filtres Temps de Trajet

```
POSITION UTILISATEUR (Paris 11ème)
              │
              ▼
         [Isochrone API Mapbox]
              │
    ┌─────────┼──────────┐
    ▼         ▼          ▼
  10 min    20 min    30 min
  ~1 km     ~3 km     ~5 km
(marche)  (vélo)   (transport)
    │         │          │
    └─────────┼──────────┘
              │
         [Zone colorée sur carte]
         [Activités dans la zone]
         [Activités hors zone : grisées]
```

### 20.3 Architecture Temps Réel

```
CLIENT A publie activité
        │
        ▼
   [API REST POST /activities]
        │
        ▼
   [PostgreSQL INSERT]
        │
        ▼
   [Redis PUBLISH channel:"activities:city:lyon"]
        │
        ▼
[WebSocket Gateway NestJS]
        │
   ┌────┼────┬────┐
   ▼    ▼    ▼    ▼
 CLI-B CLI-C CLI-D CLI-E   ← Tous abonnés à zone Lyon
        │
[activity_created event envoyé]
        │
[Carte mise à jour en temps réel]
```

---

## 21. STRUCTURE ÉCRANS & NAVIGATION

### 21.1 Navigation Principale (Bottom Tab Bar)

```
┌─────────────────────────────────────────┐
│          [CONTENU DE L'ÉCRAN]           │
│                                         │
│                                         │
│                                         │
├─────────────────────────────────────────┤
│  🗺️ Carte │ 🔔 Activités │  +  │ 💬 Chat │ 👤 Profil │
└─────────────────────────────────────────┘
```

| Tab | Icône | Fonction |
|-----|-------|----------|
| **Carte** | 🗺️ | Vue principale carte + filtres |
| **Activités** | 🔔 | Mes demandes / mes activités créées / notifications |
| **+** (FAB) | ➕ | Publier une nouvelle activité |
| **Chat** | 💬 | Conversations actives (badge compteur) |
| **Profil** | 👤 | Mon profil, paramètres, historique |

### 21.2 Arborescence Complète

```
APP SÉLÉNÉ
├── ONBOARDING (1ère visite)
│   ├── Splash / Logo
│   ├── Slide 1 — Concept
│   ├── Slide 2 — Carte live
│   ├── Slide 3 — CTA
│   └── Création profil invité
│       ├── Âge
│       ├── Genre
│       └── Pseudo
│
├── TAB CARTE
│   ├── Carte principale (Mapbox)
│   │   ├── Barre de recherche (top)
│   │   ├── Bouton filtres
│   │   ├── Markers activités
│   │   │   └── Tap → Bottom Sheet Activité
│   │   │       ├── Info résumée (sport, dist, heure)
│   │   │       ├── Bouton "Voir détails"
│   │   │       └── Bouton "Demander à rejoindre"
│   │   └── Bouton "Ma position"
│   ├── Détail Activité (plein écran)
│   │   ├── Photo lieu (si disponible)
│   │   ├── Sport + Niveau + Places
│   │   ├── Date + Heure + Durée
│   │   ├── Carte mini (localisation précise)
│   │   ├── Profil créateur (limité)
│   │   ├── Participants (photos)
│   │   └── Bouton demande / statut
│   ├── Panel Filtres (bottom sheet)
│   │   ├── Sport (chips multi-select)
│   │   ├── Distance (slider)
│   │   ├── Temps de trajet (radio + transport)
│   │   ├── Niveau (checkboxes)
│   │   ├── Genre
│   │   └── Date
│   └── Liste alternatives (si géoloc refusée)
│
├── TAB ACTIVITÉS
│   ├── Mes demandes envoyées
│   │   ├── En attente
│   │   ├── Acceptées
│   │   └── Refusées
│   ├── Mes activités créées
│   │   ├── En cours
│   │   ├── Passées
│   │   └── Annulées
│   └── Notifications push history
│
├── TAB + (CRÉER ACTIVITÉ)
│   ├── Sélection sport
│   ├── Lieu (map picker / adresse / ma position)
│   ├── Date + Heure
│   ├── Détails (places, niveau, description)
│   ├── Visibilité
│   ├── Récurrence (V2)
│   └── Aperçu + Publier
│
├── TAB CHAT
│   ├── Liste conversations
│   │   ├── Par match (titre = sport + date)
│   │   └── Badges non-lus
│   └── Conversation
│       ├── Messages
│       ├── Input texte
│       └── Infos activité (header cliquable)
│
├── TAB PROFIL
│   ├── Mon profil (vue publique)
│   │   ├── Photo + Pseudo + Score
│   │   ├── Sports + Niveaux
│   │   ├── Badges
│   │   └── Stats (matchs, avis)
│   ├── Modifier profil
│   ├── Historique matchs
│   ├── Mes badges
│   ├── Paramètres
│   │   ├── Notifications
│   │   ├── Confidentialité (géoloc, profil)
│   │   ├── Compte (email, tel, mot de passe)
│   │   ├── Abonnement Premium
│   │   └── RGPD (export, suppression)
│   └── Déconnexion
│
├── PROFIL AUTRE UTILISATEUR
│   ├── Photo + Pseudo + Score
│   ├── Sports pratiqués
│   ├── Badges
│   ├── Avis reçus
│   ├── Activités publiques récentes
│   ├── Bouton Signaler
│   └── Bouton Bloquer
│
└── INSCRIPTION COMPLÈTE (modale)
    ├── Étape 1/4 — Email
    ├── Étape 2/4 — Téléphone + OTP
    ├── Étape 3/4 — Photo
    └── Étape 4/4 — Sports + Niveaux
```

---

## 22. UX/UI — DESIGN SYSTEM 2026

### 22.1 Principes de Design

1. **Mobile-first natif** — pas de compromis web, chaque interaction pensée pour le doigt
2. **Glassomorphisme contextuel** — UI légère sur fond de carte, transparences intelligentes
3. **Micro-animations** — feedback immédiat sur chaque action (haptics iOS/Android)
4. **Dark mode natif** — switchable selon préférence système
5. **Accessibilité AA** — contraste, taille typographique, support VoiceOver/TalkBack

### 22.2 Palette de Couleurs

```
Primaire     : #4F46E5  (Indigo vibrant — action, CTAs)
Secondaire   : #10B981  (Vert émeraude — succès, validation)
Accent       : #F59E0B  (Ambre — badges, highlights)
Danger       : #EF4444  (Rouge — erreurs, annulations)
Neutre dark  : #111827  (Fond dark mode)
Neutre light : #F9FAFB  (Fond light mode)
Carte        : Mapbox Style Custom (dark pour la nuit)
```

### 22.3 Typographie

```
Display  : Satoshi Bold — titres, scores
Heading  : Satoshi Medium — sous-titres, labels
Body     : Inter Regular — corps de texte
Caption  : Inter Light — métadonnées, dates
Mono     : JetBrains Mono — codes OTP
```

### 22.4 Composants Clés

**Activity Card (Bottom Sheet)**
```
┌──────────────────────────────┐
│ ⚽  Football                 │
│     Parc des Sports  •  1.2km│
│     Aujourd'hui  18:00 - 20h │
│                              │
│  👤👤👤  3/5 places           │
│  🟡 Intermédiaire            │
│                              │
│  [Demander à rejoindre  →]   │
└──────────────────────────────┘
```

**Profile Card**
```
┌──────────────────────────────┐
│  [📷]  Karim T.              │
│  ⭐ 4.8  •  47 matchs        │
│                              │
│  ⚽ Intermédiaire  🎾 Débutant│
│                              │
│  🏆 Champion local  🔥 En feu│
└──────────────────────────────┘
```

### 22.5 Carte Interactive — UX Détails

- **Zoom** : 12 (ville) → 17 (rue) — zoom auto sur position utilisateur au lancement
- **Clustering** : < 3 activités = icônes séparées, ≥ 3 = cluster numéroté
- **Couleur markers** : par sport (palette sport unique)
- **Animation** : pulse sur nouveaux markers (3 secondes)
- **Long press** : afficher adresse + distance
- **Night mode** : style carte sombre automatique après 20h

---

## 23. ROADMAP TECHNIQUE — SPRINT PAR SPRINT

### MVP — 4 mois (Sprints 1 à 8 × 2 semaines)

**Sprint 1 (S1-S2) — Fondations**
- [ ] Setup projet Flutter (architecture Riverpod + go_router)
- [ ] Setup NestJS backend (modules auth, users)
- [ ] Base de données PostgreSQL + PostGIS + schéma initial
- [ ] Authentification : JWT, mode invité
- [ ] Géolocalisation basique (permission + récupération position)

**Sprint 2 (S3-S4) — Carte & Activités**
- [ ] Intégration Mapbox (carte, markers, clustering)
- [ ] CRUD activités (création, liste, détail)
- [ ] Requêtes géographiques PostGIS (ST_DWithin)
- [ ] Filtres basiques (sport, distance)
- [ ] Bottom sheet activité

**Sprint 3 (S5-S6) — Matching & Notifications**
- [ ] Système demandes de participation
- [ ] Notifications push (FCM + APNs)
- [ ] Acceptation / refus par créateur
- [ ] Déclencheur inscription complète
- [ ] OTP Twilio

**Sprint 4 (S7-S8) — Chat & Profil**
- [ ] WebSocket (Socket.io) — chat temps réel
- [ ] Historique messages (PostgreSQL)
- [ ] Profil complet (photo upload, sports, niveaux)
- [ ] Inscription complète multi-étapes
- [ ] Système de blocage/signalement basique

**Sprint 5 (S9-S10) — Filtres Avancés & Polish**
- [ ] Filtres temps de trajet (Mapbox Isochrone API)
- [ ] Filtres genre, niveau, date
- [ ] Temps réel carte (WebSocket subscribe_area)
- [ ] Animations et micro-interactions
- [ ] Dark mode

**Sprint 6 (S11-S12) — Sécurité & RGPD**
- [ ] Rate limiting API
- [ ] Modération photo (Rekognition)
- [ ] Panel admin basique
- [ ] Export données RGPD
- [ ] Suppression compte

**Sprint 7 (S13-S14) — Beta Privée**
- [ ] Tests E2E (Flutter integration tests)
- [ ] Performance et optimisation requêtes
- [ ] Bug fixing beta testeurs (50 users)
- [ ] Analytics PostHog
- [ ] App Store / Play Store prép

**Sprint 8 (S15-S16) — MVP Launch**
- [ ] Tests de charge (k6)
- [ ] Documentation API (Swagger)
- [ ] Monitoring (Sentry, Grafana)
- [ ] Lancement App Store + Google Play
- [ ] Landing page marketing

---

### V2 — 4 mois supplémentaires (Sprints 9-16)

**Sprints 9-10 — Groupes Sportifs**
- Création, gestion, membres
- Feed groupe, chat permanent

**Sprints 11-12 — Gamification Complète**
- Badges, scores, classements
- Défis hebdomadaires
- Notifications gamification

**Sprints 13-14 — IA & Recommandations**
- Algorithme de recommandation
- "Pour toi" personnalisé
- Matching partenaire régulier

**Sprints 15-16 — Premium & Monétisation**
- Abonnement in-app (Apple IAP, Google Billing)
- Fonctionnalités premium
- Panel analytics organisateurs

---

## 24. ESTIMATION COMPLEXITÉ & COÛTS

### 24.1 Complexité par Feature (T-Shirt)

| Feature | Complexité | Estimation dev |
|---------|-----------|----------------|
| Carte Mapbox + géoloc | M | 3 jours |
| Filtres géographiques (PostGIS) | L | 4 jours |
| Filtres isochrones (temps trajet) | XL | 5 jours |
| CRUD Activités | M | 3 jours |
| Système demandes / acceptation | M | 3 jours |
| Notifications push | L | 4 jours |
| Chat WebSocket | XL | 6 jours |
| Profil 2 niveaux + OTP | L | 5 jours |
| Inscription complète multi-étapes | M | 3 jours |
| Temps réel carte (WebSocket) | XL | 5 jours |
| Système réputation + avis | M | 3 jours |
| Modération + signalements | L | 4 jours |
| Admin panel web | XL | 8 jours |
| RGPD / export données | M | 3 jours |
| Analytics PostHog | S | 2 jours |
| CI/CD + Infrastructure | L | 5 jours |
| **TOTAL MVP** | | **~67 jours** |

### 24.2 Estimation Coûts Cloud (AWS, mensuels)

**Environnement Développement/Staging :**

| Service | Config | Coût/mois |
|---------|--------|-----------|
| ECS Fargate (API) | 0.5 vCPU, 1GB × 2 tasks | ~30 € |
| RDS PostgreSQL | db.t3.small, 20GB | ~25 € |
| ElastiCache Redis | cache.t3.micro | ~15 € |
| CloudFront | 50GB transfer | ~5 € |
| S3 / R2 | 10GB | ~3 € |
| **TOTAL DEV** | | **~80 €/mois** |

**Production (5 000 MAU) :**

| Service | Config | Coût/mois |
|---------|--------|-----------|
| ECS Fargate (API) | 1 vCPU, 2GB × 3 tasks | ~120 € |
| ECS Fargate (WebSocket) | 0.5 vCPU, 1GB × 2 tasks | ~40 € |
| RDS Aurora PostgreSQL | db.r6g.large, Multi-AZ | ~200 € |
| ElastiCache Redis | cache.r6g.large | ~80 € |
| CloudFront | 500GB transfer | ~45 € |
| S3 / Cloudflare R2 | 50GB | ~5 € |
| FCM/APNs | Gratuit | ~0 € |
| Twilio OTP | ~1000 SMS/mois | ~50 € |
| Mapbox | 50K map loads | ~50 € |
| Sentry | Team plan | ~25 € |
| **TOTAL PROD** | | **~615 €/mois** |

**Production Scale (50 000 MAU) :**
- ~3 500 €/mois (estimation avec auto-scaling)

### 24.3 Services Tiers — Coûts Clés

| Service | Gratuit | Payant |
|---------|---------|--------|
| Mapbox | 50K map loads/mois | ~0.004€/load ensuite |
| Twilio SMS | 0 | ~0.05€/SMS |
| Firebase FCM | ∞ (gratuit) | — |
| OpenAI Moderation | Faible coût | ~0.002$/1K tokens |
| PostHog | 1M events/mois | ~450$/mois ensuite |

---

## 25. ÉQUIPE NÉCESSAIRE

### 25.1 Équipe MVP (4 mois)

| Rôle | ETP | Profil |
|------|-----|--------|
| **Lead Developer Full-Stack** | 1.0 | NestJS + PostgreSQL + DevOps |
| **Mobile Developer Flutter** | 1.0 | Flutter, Mapbox, animations |
| **Product Manager / Designer** | 0.5 | Figma, specs, tests utilisateurs |
| **DevOps / Cloud** | 0.3 | AWS, Terraform, CI/CD |
| **QA / Testeur** | 0.3 | Tests manuels + automatisés |

**Coût estimé (Paris, tarifs marché 2026) :**
- Lead Full-Stack : ~600€/j → 4 mois × 22j × 0.7 ≈ **37 000 €**
- Mobile Flutter : ~550€/j → 4 mois × 22j × 1.0 ≈ **48 400 €**
- PM/Designer : ~450€/j → 4 mois × 22j × 0.5 ≈ **19 800 €**
- DevOps : ~600€/j → 4 mois × 22j × 0.3 ≈ **15 840 €**
- QA : ~400€/j → 4 mois × 22j × 0.3 ≈ **10 560 €**
- **TOTAL DEV MVP : ~131 600 €**

### 25.2 Équipe V2 & Croissance

Ajouts recommandés après lancement :
- **Data Engineer / ML Engineer** (recommandations IA) : 0.5 ETP
- **Community Manager / Modérateur** : 0.5 ETP
- **Growth Marketer** : 0.5 ETP
- **Customer Success** : 0.3 ETP

### 25.3 Stack Organisationnelle

| Outil | Usage |
|-------|-------|
| **Linear** | Gestion tickets, sprints |
| **Figma** | Design, prototypes |
| **GitHub** | Code, PR reviews |
| **Notion** | Documentation, specs |
| **Slack** | Communication équipe |
| **Loom** | Démos asynchrones |
| **Vercel** | Preview deployments admin |

---

## 26. STRATÉGIE CROISSANCE & RÉTENTION

### 26.1 Stratégie d'Acquisition

**Phase 1 — Lancement local (Mois 1-3)**
- Lancement dans 2-3 villes pilotes (Lyon, Bordeaux, Toulouse)
- Activation communautés sportives locales (clubs, associations)
- Partenariats salles de sport (Séléné visible dans les salles)
- Contenu TikTok / Instagram Reels (démo live de la carte)
- Programme ambassadeurs : coachs et organisateurs locaux

**Phase 2 — Expansion (Mois 4-9)**
- Croissance organique (referral intégré : "Invite un ami, +50 points")
- SEO local (pages "Sport à Lyon", "Trouver partenaire tennis Paris")
- Publicité Meta Ads ciblée (sportifs 18-40 ans, intérêts fitness)
- Relations presse sport et tech

**Phase 3 — Scale national (Mois 10-18)**
- Déploiement 10+ grandes villes françaises
- Partenariats marques sport (Decathlon, Nike France)
- Événements IRL (tournois Séléné, session discovery)

### 26.2 Rétention

**Leviers de rétention :**
1. **Notifications intelligentes** — rappels activités, nouvelles activités dans sa zone, défis
2. **Gamification** — streaks, badges, classements hebdomadaires
3. **Réseau social léger** — voir l'activité de ses "partenaires réguliers"
4. **Personnalisation** — recommandations IA qui s'améliorent avec l'usage
5. **Événements récurrents** — ancrage hebdomadaire avec les groupes

**Courbe de rétention cible :**
- J1 : 65 % (onboarding réussi → valeur immédiate)
- J7 : 40 % (1er match réalisé = hook)
- J30 : 25 % (habitude installée)
- J90 : 15 % (utilisateur actif long terme)

### 26.3 Funnel de Conversion

```
Téléchargement app
        │  (80 %)
        ▼
Complétion onboarding invité
        │  (60 %)
        ▼
Carte vue + activité consultée
        │  (40 %)
        ▼
Demande envoyée
        │  (60 %)
        ▼
Match accepté
        │  (80 %)
        ▼
Inscription complète
        │  (50 %)
        ▼
2ème match (rétention validée)
```

### 26.4 Métriques d'Activation (North Star)

**North Star Metric : Nombre de matchs sportifs complétés par semaine**

> Un match complété = un créateur + un participant se sont rencontrés physiquement pour une activité sportive via Séléné. C'est la preuve ultime de la valeur créée.

**Métriques secondaires :**
- Activités publiées / jour
- Taux de demande → match (cible : 60 %)
- Messages chat / match (cible : 10+ messages)
- Avis laissés / match (cible : 70 %)

---

## ANNEXE A — GLOSSAIRE

| Terme | Définition |
|-------|-----------|
| **Activité** | Session sportive publiée sur la carte par un créateur |
| **Match** | Activité avec au moins un participant accepté |
| **Invité** | Utilisateur avec profil minimal (pseudo, âge, genre) |
| **Membre** | Utilisateur avec profil complet vérifié |
| **Créateur** | Utilisateur ayant publié une activité |
| **Participant** | Utilisateur ayant rejoint une activité |
| **Trust Score** | Score de confiance calculé sur les comportements |
| **Activity Score** | Score de gamification reflétant l'engagement sportif |
| **Isochrone** | Zone géographique accessible en un temps donné selon un mode de transport |
| **Match complété** | Match pour lequel les deux parties se sont présentées |
| **No-show** | Participant ou créateur ne s'étant pas présenté |

---

## ANNEXE B — CONTRAINTES TECHNIQUES IDENTIFIÉES

1. **Scalabilité WebSocket** : Au-delà de 10K connexions simultanées, passer à une architecture Pub/Sub distribuée (Redis Cluster + Sticky Sessions via ALB).

2. **PostGIS Performance** : Index GIST obligatoires sur toutes les colonnes géographiques. Pour des requêtes < 50ms avec 100K+ activités, considérer le partitioning par ville.

3. **Mapbox Coût** : À 500K users/mois, Mapbox peut devenir coûteux. Alternative : migration vers MapLibre + tuiles hébergées (100 % contrôle coût).

4. **iOS Push Notifications** : APNs nécessite un compte Apple Developer (99$/an) et une configuration de certificats.

5. **RGPD Droit à l'Oubli** : La suppression des messages chat doit être irréversible, mais les chats de groupe créent un problème : les messages des autres utilisateurs doivent rester. Solution : anonymisation du sender_id (remplacer par "Utilisateur supprimé").

---

*Document version 1.0 — Initial Draft — 29 mai 2026*
*Prochaine étape : Revue par Architect-Tech-1 et Architect-Tech-2*
