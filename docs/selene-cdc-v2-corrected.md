# SÉLÉNÉ — Cahier des Charges Complet
## Application Mobile de Mise en Relation Sportive Locale

---

| Champ            | Valeur                                                  |
|------------------|---------------------------------------------------------|
| **Produit**      | Séléné                                                  |
| **Version**      | 2.1 — Post-Review Experts (UX + Business + Security)   |
| **Date**         | 29 mai 2026                                             |
| **Statut**       | Draft corrigé — Resoumission Experts                    |
| **Confidentialité** | Confidentiel — Usage interne                         |
| **Auteur**       | Équipe Produit Séléné                                   |

---

## TABLE DES MATIÈRES

1. [Vision Produit & Proposition de Valeur](#1)
2. [Positionnement & Analyse Concurrentielle](#2)
3. [Personas Utilisateurs](#3)
4. [Concept & Logique Métier](#4)
5. [Système d'Inscription en 2 Niveaux](#5)
6. [Parcours Utilisateurs Détaillés & UX Spécifications](#6)
7. [User Stories](#7)
8. [Fonctionnalités MVP](#8)
9. [Fonctionnalités V2](#9)
10. [Architecture Technique](#10)
11. [Schéma Base de Données](#11)
12. [APIs & Endpoints](#12)
13. [Temps Réel & Chat](#13)
14. [Sécurité, RGPD & Conformité](#14)
15. [Modération & Anti-Fraude](#15)
16. [Analytics & Admin Panel](#16)
17. [Modèle Freemium, Monétisation & Business Model](#17)
18. [Gamification & Rétention](#18)
19. [Matching Intelligent (IA)](#19)
20. [Diagrammes Fonctionnels](#20)
21. [Structure Écrans & Navigation](#21)
22. [UX/UI — Design System 2026](#22)
23. [Roadmap Technique — Sprint par Sprint](#23)
24. [Estimation Complexité & Coûts Cloud](#24)
25. [Équipe Nécessaire](#25)
26. [Stratégie Croissance, Acquisition & Rétention](#26)
27. [Modèle Financier & Projections 24 mois](#27)
28. [Financement, Runway & Utilisation des Fonds](#28)

---

## 1. VISION PRODUIT & PROPOSITION DE VALEUR

### 1.1 Vision

> **"Séléné connecte les sportifs locaux en temps réel autour d'une carte vivante de leur ville."**

Séléné résout un problème universel et quotidien : trouver des partenaires sportifs disponibles, à proximité, maintenant. Le cœur du produit n'est pas un système de swipe. C'est une **carte interactive vivante** où chaque point représente une activité sportive réelle.

**Tagline :** *"Ton sport. Ta ville. Maintenant."*

### 1.2 Problème & Solution

| Problème | Solution Séléné |
|----------|-----------------|
| Pas de partenaire disponible | Carte temps réel des activités proches |
| Inscription longue décourageante | Mode invité 30s, inscription après valeur démontrée |
| Distance km ≠ réalité du déplacement | Filtres par temps de trajet (10/20/30 min, 4 modes) |
| Apps trop sociales ou trop engageantes | Outil pur, action sportive immédiate, pas de profil esthétique |
| Masse critique difficile à atteindre | Lancement concentré ville par ville |

### 1.3 KPIs Produit

| Métrique | Cible M6 (Lyon pilote) | Cible M18 (3 villes) |
|----------|------------------------|----------------------|
| MAU | 5 000 | 30 000 |
| Activités publiées / jour | 200 | 1 500 |
| Taux invité → membre | 40 % | 55 % |
| Taux match accepté / demande | 60 % | 70 % |
| Rétention J7 | 35 % | 50 % |
| Rétention J30 | 20 % | 35 % |
| NPS | > 40 | > 60 |
| **North Star : matchs complétés/semaine** | 500 | 5 000 |

**North Star Metric :** Matchs sportifs complétés (créateur + participant présents physiquement) = preuve ultime de valeur créée.

**Arbre de métriques :**
```
Matchs complétés / semaine (North Star)
├── Activités publiées / jour (leading)
│   ├── Taux créateur actif / MAU
│   └── Durée moyenne de l'activité en ligne
├── Taux demande → acceptation (leading)
│   ├── Qualité profil créateur (trust score)
│   └── Délai de réponse créateur
├── Taux présence confirmée (leading)
│   └── Taux no-show (lagging — cible < 15 %)
└── Taux rétention J7 (lagging)
    ├── Onboarding complétion
    └── Premier match dans les 72h
```

---

## 2. POSITIONNEMENT & ANALYSE CONCURRENTIELLE

### 2.1 Matrice Positionnement

```
                    SOCIAL / COMMUNAUTAIRE
                              ▲
                    Meetup •  |  • Facebook Sports
                              |
INDIVIDUEL ◄──────────────────┼──────────────────► COLLECTIF
(tracking,perf)    Strava •   |        • Séléné ★
                   Garmin •   |  JoinMyGame •
                              |    Heja •
                              ▼
                    PONCTUEL / SPONTANÉ
```

**Séléné se positionne :** communautaire local + spontané + multi-sport.

### 2.2 Analyse Concurrentielle Complète

| Concurrent | Forces | Faiblesses vs Séléné | Risque d'imitation |
|------------|--------|-----------------------|--------------------|
| **Strava** | 100M+ users, tracking avancé | Pas de matching, pas d'organisation spontanée | Élevé — mais nécessiterait pivot produit fort |
| **Meetup** | Marque connue, événements | Pas temps réel, UX vieillissante, frais organisateur | Faible — modèle business trop différent |
| **JoinMyGame** | Multi-sport, matching | Interface web, peu de mobile-first, peu de villes FR | Moyen — cible similaire |
| **Heja** | Gestion équipes amateurs | B2B orienté clubs, pas B2C individuel | Faible — segment distinct |
| **Playtomic** | Padel/tennis, réservation | Lié aux courts/installations, payant, pas de matching humain | Faible — modèle très différent |
| **Decathlon Outdoor** | Distribution massive | Lié à une marque, pas de matching, peu de social | Moyen — Decathlon pourrait développer |
| **Facebook Groups** | Groupes locaux existants | Généraliste, expérience mobile dégradée, pas de carte | Faible — hors stratégie Meta actuelle |

**Barrières à l'entrée de Séléné :**
1. **Effet réseau local** : densité d'activités dans une ville = avantage cumulatif pour l'entrant
2. **Données d'habitudes sportives** : historique des matchs → matching IA de plus en plus précis
3. **Trust Score réseau** : réputation construite au fil du temps, non transférable
4. **Marque communautaire** : sentiment d'appartenance à la communauté sportive locale

**Question investisseur "Pourquoi pas Strava ?" :** Strava est un outil de tracking individuel. Ajouter une feature de matching dégraderait son positionnement "performance". Séléné attaque le marché du "je veux trouver quelqu'un pour faire du sport maintenant", pas "je veux tracker ma performance". Les deux apps sont complémentaires, pas concurrentes directes.

---

## 3. PERSONAS UTILISATEURS

### Persona 1 — Léa, 26 ans, Sportive Occasionnelle
Graphiste freelance, Lyon 3ème. Running 2x/semaine, cherche partenaire tennis. **Déclencheur :** voit 3 activités tennis samedi matin en 30s sans créer de compte.

### Persona 2 — Marc, 34 ans, Sportif Régulier
Développeur, Paris 11ème. Organise foot 5x5, veut recruter sans WhatsApp interminable. **Déclencheur :** publie activité en 60s, reçoit 2 demandes en 10 min.

### Persona 3 — Sophie, 41 ans, Coach Sportif
Bordeaux. Yoga en plein air. **Déclencheur :** événement visible sur la carte de 500 personnes dans son quartier.

### Persona 4 — Thomas, 22 ans, Étudiant Nouveau en Ville
Toulouse, cherche partenaires basket. Méfiant envers les inscriptions longues. **Déclencheur :** voit la carte avec icônes basketball, peut demander à rejoindre en 3 clics.

---

## 4. CONCEPT & LOGIQUE MÉTIER

### 4.1 La Carte Vivante

Interface principale : carte Mapbox avec activités sportives géolocalisées, icônes par sport, clustering automatique.

### 4.2 Flux Principal

```
CRÉATEUR → Publie activité → Visible sur carte
PARTICIPANT (invité) → Voit icône → Détails limités → Demande à rejoindre
CRÉATEUR → Notification push → Accepte/Refuse → Chat ouvert + Match créé
```

### 4.3 Types d'Activités

| Type | Description |
|------|-------------|
| Spontanée | Aujourd'hui/demain, 1-2 joueurs |
| Événement récurrent | Session hebdomadaire |
| Événement ponctuel | Tournoi, événement daté |
| Recherche partenaire | Sans date fixe |

### 4.4 Filtres

| Filtre | Options |
|--------|---------|
| Sport | Liste complète + "Tous" |
| Distance | 1/2/5/10/20 km |
| Temps de trajet | 10/20/30 min + mode transport |
| Niveau | Débutant / Intermédiaire / Confirmé / Expert |
| Genre | Mixte / Hommes / Femmes |
| Date | Aujourd'hui / Cette semaine / Ce weekend |

---

## 5. SYSTÈME D'INSCRIPTION EN 2 NIVEAUX

### 5.1 Mode Invité (30 secondes)

**Données :** Âge (curseur, valeurs groupées), Genre, Pseudo

**Ce que peut faire l'invité :** voir carte, filtrer, consulter détails limités d'activités, envoyer une demande, recevoir notifications push

**Ce que ne peut PAS faire l'invité :** publier, accéder au chat, voir profils complets, voir la liste des participants

### 5.2 Tunnel Conversion Invité → Membre (UX Spécification Détaillée)

**Déclencheur :** tap sur le bouton "Rejoindre" d'une activité par un invité.

**Visuel du bouton pour un invité :**
- Bouton "Rejoindre" actif (pas grisé) avec icône 🔓 discrète
- Pas de cadenas bloquant — l'invité peut taper dessus, ce qui déclenche la bottom sheet

**Séquence après tap :**
```
[Tap "Rejoindre"]
        │
        ▼
[Bottom sheet inscription — mi-écran]
"Pour rejoindre cette activité,
 complète ton profil en 2 min"

[Se connecter avec Google]   ← social login prioritaire
[Se connecter avec Apple]
─────────────────────────
[Continuer avec email →]

[Plus tard] ← ferme sans perdre l'activité
        │
        ▼
[Après inscription réussie]
→ Retour AUTOMATIQUE sur la fiche activité avec statut "Demande en attente"
→ Pas de retour à l'accueil — continuité du parcours garantie
```

**Gestion de l'activité pendant l'inscription :**
- L'activité cible est mémorisée en local (Isar) pendant le processus d'inscription
- Si l'inscription est abandonnée, l'activité reste accessible depuis la carte
- Si l'activité se remplit pendant l'inscription : message "Cette activité est complète" avec suggestion d'activités similaires

### 5.3 Inscription Complète (post-1er match accepté ou volontaire)

**Déclencheur :** match accepté (message push) ou CTA "Compléter mon profil" dans les paramètres

**Étapes progressives :**
1. Email → magic link (délai max 2 min, lien valide 30 min, renvoi possible)
2. Téléphone → OTP SMS Twilio (6 chiffres, TTL 120s, max 3 tentatives)
3. Photo → modération IA obligatoire (détection visage réel)
4. Sports pratiqués + niveaux → chips multi-select + sliders

**Vérification d'âge renforcée (voir section 14.6)**

---

## 6. PARCOURS UTILISATEURS DÉTAILLÉS & UX SPÉCIFICATIONS

### 6.1 Onboarding & Gestion des Permissions

**Écran de pré-permission géolocalisation (avant dialog système) :**
```
┌─────────────────────────────────────────┐
│                                         │
│        🗺️                               │
│                                         │
│   "Pour voir les activités              │
│    sportives autour de toi,             │
│    Séléné a besoin de ta position."     │
│                                         │
│   🔒 Ta position n'est jamais           │
│      partagée sans ton accord.          │
│                                         │
│   [Autoriser la localisation]           │
│   [Utiliser une ville manuellement]     │
└─────────────────────────────────────────┘
```

**Si refus géolocalisation :**
- Champ de saisie "Ville ou code postal" pour utilisation dégradée
- Carte centrée sur la ville saisie, rayon par défaut 5 km
- Bandeau rappel discret : "Active la géoloc pour une expérience optimale"

**Permission push notifications :**
- Demandée uniquement après le 1er match accepté ("Tu as un match ! Active les notifications pour ne jamais rater la réponse d'un créateur")
- Taux d'opt-in cible : 60%+ (contexte pertinent vs 43% au lancement)

### 6.2 États Intermédiaires du Flux de Participation

**État "Demande envoyée — En attente" :**
```
Bouton activité → transformé en "Demande envoyée ⏳"
                  + option "Annuler ma demande" (texte petit, secondaire)
```

**Ce que voit l'utilisateur dans l'onglet Activités :**
```
MES DEMANDES
────────────────────────────────
⏳ Tennis — Parc Tête d'Or
   Demande envoyée il y a 2h
   [Annuler]
────────────────────────────────
✅ Football — Stade Gerland
   Confirmé pour samedi 18h
   [Ouvrir le chat]
────────────────────────────────
❌ Badminton — Salle Confluence
   Non retenu
   [Voir d'autres badminton]
```

**Expiration automatique des demandes :**
- Demande expire 2h avant le début de l'activité si pas de réponse
- Notification push au créateur : "Tu as des demandes en attente pour ton activité de cet après-midi"
- Notification à l'utilisateur à expiration : "Ta demande a expiré. L'activité commence bientôt — cherches-en une autre ?"

### 6.3 Bottom Sheet Activité — 2 États

**État Preview (tap sur marker carte) — Half sheet :**
```
┌─────────────────────────────────────────┐
│ ▬▬▬▬▬  (handle)                         │
│                                         │
│ ⚽  Football         1.2 km  •  ~15 min  │
│ Parc des Sports, Lyon 6ème              │
│                                         │
│ Aujourd'hui 18:00   🕐 2h               │
│ 🟡 Intermédiaire  •  3/5 places         │
│                                         │
│  [Voir les détails]  [Rejoindre →]      │
└─────────────────────────────────────────┘
```
- La carte reste visible et interactive derrière (pattern split view)
- La sheet occupe 45% de l'écran
- Swipe up → État détaillé

**État Détaillé (swipe up ou "Voir les détails") — Full sheet :**
```
┌─────────────────────────────────────────┐
│ ▬▬▬▬▬  ← Fermer                         │
│                                         │
│ ⚽  Football 5v5                         │
│ Parc des Sports — Court 2               │
│                                         │
│ 📍 1.2 km (15 min à pied)               │
│ 📅 Aujourd'hui, 18:00 → 20:00           │
│ 🎯 Niveau intermédiaire                 │
│ 👥 3 places restantes (5 max)           │
│                                         │
│ [Photo créateur] Marc T.  ⭐ 4.7        │
│ "Recherche 3 joueurs pour 5v5           │
│  amical. Niveau intermédiaire SVP"      │
│                                         │
│ Participants confirmés :                │
│ 👤👤 + 1 inconnu                        │
│                                         │
│       [   Rejoindre cette activité   ]  │
│                                         │
│ [Partager]  [Signaler]                  │
└─────────────────────────────────────────┘
```
- La carte est masquée en full sheet
- Scroll interne si contenu dépasse l'écran

### 6.4 Parcours Créateur — Étapes Numérotées

```
[Tab + (FAB)]
        │
        ▼
ÉTAPE 1/5 — Sport
[Grille d'icônes sports] ← tap pour sélectionner
        │
        ▼
ÉTAPE 2/5 — Lieu
3 options :
 ○ Ma position actuelle [📍 utiliser]
 ○ Sélectionner sur la carte [carte miniature interactive]
 ○ Saisir une adresse [champ avec autocomplétion]
        │
        ▼
ÉTAPE 3/5 — Date & Heure
[DatePicker natif iOS/Android]
Durée estimée : [30min] [1h] [2h] [Autre]
        │
        ▼
ÉTAPE 4/5 — Participants & Niveau
Nombre de places : [slider 1-20]
Niveau requis : [chips Débutant / Intermédiaire / Confirmé / Expert]
Genre : [Mixte] [Femmes] [Hommes]
        │
        ▼
ÉTAPE 5/5 — Description & Visibilité
Description : [textarea 200 chars, optionnel]
Visibilité : [● Public] [○ Lien privé]
Récurrence : [● Une fois] [○ Chaque semaine]
        │
        ▼
[APERÇU — Voir le rendu sur la carte]
        │
        ▼
[PUBLIER]
        │
        ▼
[Confirmation]
"🎉 Ton activité est en ligne !"
"Tu recevras une notification dès qu'un sportif demande à rejoindre."
[Voir sur la carte]  [Partager le lien]
```

**Édition post-publication :** bouton "Modifier" sur la fiche activité (créateur uniquement). Modifications notifiées aux participants déjà confirmés.

**Annulation :** bouton "Annuler l'activité" avec confirmation obligatoire ("es-tu sûr ?") + notification push automatique à tous les participants acceptés.

### 6.5 Chat Post-Match — Spécifications Complètes

**Fonctionnalités chat :**
- Messages texte (max 500 caractères)
- **Partage de position "Je suis là" 📍** — bouton dédié dans la barre d'envoi
  - Envoie une carte miniature avec position approximative (arrondie à 100m)
  - Durée de validité : 30 minutes
  - Libellé : "Marc est à ~200m du lieu de rendez-vous"
- Indicateurs de lecture (✓ envoyé, ✓✓ lu)
- Mentions @pseudo dans les groupes

**Gestion du départ d'un participant :**
- Si un participant quitte l'activité → notification au créateur + message système dans le chat : "[Prénom] a annulé sa participation"
- Le participant quittant sort du chat + la place se libère sur la fiche activité

**Cycle de vie du chat :**
- Actif jusqu'à 24h après la fin de l'activité
- Archivage automatique après 24h (consultation lecture seule depuis l'historique)
- Suppression complète après 90 jours (RGPD)

**État vide du chat (avant que quelqu'un n'écrive) :**
```
💬 Chat ouvert !
Tu as rejoint l'activité de Marc.
Présente-toi et coordonne les derniers détails.
[Partager ma position 📍]
```

### 6.6 États Vides — Spécification Complète

**Carte — Aucune activité dans la zone :**
```
┌─────────────────────────────────────────┐
│              🌙 (illustration carte)     │
│                                         │
│   "Pas encore d'activités ici"          │
│   Sois le premier à proposer !          │
│                                         │
│  [Élargir le rayon à 10 km]             │
│  [Créer une activité +]                 │
└─────────────────────────────────────────┘
```

**Liste activités filtrées — Résultat vide :**
- Suggestion automatique : "Essaie avec le niveau 'Tous niveaux' ou élargis le rayon"
- Affiche les activités du sport sélectionné dans les 7 prochains jours

**Onglet Chat — Aucune conversation :**
```
💬 Tes conversations sportives ici
Rejoins une activité pour discuter
avec ton futur partenaire sportif.
[Découvrir les activités →]
```

### 6.7 Filtres — Comportement Détaillé

**Hiérarchie des filtres :** Sport (primaire) → Distance/Temps de trajet → Niveau → Genre → Date

**Comportement :**
- Filtres appliqués en temps réel (les markers disparaissent au fur et à mesure)
- Badge compteur sur le bouton "Filtres" indiquant le nombre de filtres actifs
- Bandeau sous la barre de recherche listant les filtres actifs avec option "×" pour chacun
- Persistance : les filtres sont conservés pendant la session, remis à zéro à la fermeture de l'app (configurable dans les paramètres)
- Rayon de distance : liste de valeurs prédéfinies (500m / 1km / 2km / 5km / 10km / 20km) — pas de slider (moins précis sur mobile)

### 6.8 Signalement & Blocage — UX Complète

**Points d'entrée signalement :**
- Menu 3-points "⋮" sur un message dans le chat → "Signaler ce message"
- Bouton sur la fiche profil d'un utilisateur → "Signaler"
- Bouton sur la fiche activité → "Signaler cette activité"

**Flux de signalement :**
```
[Tap "Signaler"]
        │
        ▼
[Sélection catégorie]
○ Comportement inapproprié
○ Fausse identité / Compte fake
○ Contenu offensant
○ Harcèlement ou intimidation
○ Autre

[Optionnel : message court — 200 chars]
        │
        ▼
[Confirmation]
"Merci pour ton signalement.
 Notre équipe le traitera sous 24h.
 Tu peux également bloquer cet utilisateur."
[Bloquer aussi] [Fermer]
```

**Distinction signalement vs blocage :**
- **Signaler** = alerte l'équipe de modération (l'utilisateur continue à apparaître)
- **Bloquer** = effet immédiat et silencieux (sans signalement)
- Les deux actions sont clairement séparées visuellement

**Effets complets du blocage :**
- L'utilisateur bloqué disparaît de la carte et des listes
- Les activités du bloqué ne sont plus visibles
- Toute demande de l'un vers l'autre est silencieusement ignorée
- Messages non délivrés (sans notification d'erreur)
- Le bloqué ne sait pas qu'il est bloqué
- **Contournement par nouveau compte :** si même numéro de téléphone ou même device fingerprint détecté → flag automatique pour review manuelle

### 6.9 Gamification — Ancrage UX

**Badges dans le profil :**
- Section "Mes Badges" dans l'onglet Profil, sous les stats
- Grille 3 colonnes : badges obtenus en couleur, badges verrouillés en grisé
- Tap sur badge grisé → description de la condition d'obtention

**Notification d'obtention de badge :**
- In-app : full-screen célébration animée (confettis + son) pour les badges rares et épiques
- In-app toast pour les badges courants
- Badge visible sur le profil public (parmi les 3 premiers mis en avant)

**Score activité :**
- Visible sur la fiche profil publique (affiché sous forme de niveau : "Challenger", "Warrior", etc.)
- Chiffre exact visible seulement sur son propre profil
- Pas de leaderboard public par défaut en MVP (V2)

### 6.10 Micro-Interactions & Haptics

| Action | Haptic | Animation |
|--------|--------|-----------|
| Match accepté | `HapticFeedback.mediumImpact()` | Toast vert animé + flash écran |
| Demande envoyée | `HapticFeedback.lightImpact()` | Bouton → animation "check" |
| Tap marker carte | `HapticFeedback.selectionClick()` | Bottom sheet monte avec spring |
| Badge obtenu | `HapticFeedback.heavyImpact()` | Full-screen confettis |
| Nouveau message | `HapticFeedback.lightImpact()` | Badge tab bar bounce |
| Signalement confirmé | `HapticFeedback.lightImpact()` | Icône → checkmark |

---

## 7. USER STORIES

### Epic 1 — Découverte

| ID | Story | Priorité |
|----|-------|----------|
| US-001 | En tant qu'invité, je crée un profil minimal en 30s | P0 |
| US-002 | En tant qu'invité, je vois la carte géolocalisée avec activités | P0 |
| US-003 | En tant qu'invité, je filtre par sport en temps réel | P0 |
| US-004 | En tant qu'invité, je consulte la bottom sheet activité en 2 états | P0 |
| US-005 | En tant qu'invité, si je refuse la géoloc, je peux saisir une ville | P1 |

### Epic 2 — Participation

| ID | Story | Priorité |
|----|-------|----------|
| US-010 | En tant qu'invité, je tape "Rejoindre" et vois la bottom sheet inscription | P0 |
| US-011 | Après inscription, je suis redirigé automatiquement vers l'activité cible | P0 |
| US-012 | En tant que membre, je vois le statut "En attente" de ma demande | P0 |
| US-013 | En tant que membre, j'annule ma demande en attente | P1 |
| US-014 | En tant qu'utilisateur accepté, j'accède au chat avec partage de position | P0 |

### Epic 3 — Création

| ID | Story | Priorité |
|----|-------|----------|
| US-020 | En tant que membre, je publie en 5 étapes en 60s | P0 |
| US-021 | En tant que créateur, je reçois push dès qu'une demande arrive | P0 |
| US-022 | En tant que créateur, j'accepte/refuse en voyant le profil complet | P0 |
| US-023 | En tant que créateur, je modifie ou annule mon activité | P1 |
| US-024 | En tant que créateur, les participants sont notifiés en cas d'annulation | P0 |

### Epic 4 — Sécurité

| ID | Story | Priorité |
|----|-------|----------|
| US-050 | En tant qu'utilisateur, je signale en 3 étapes depuis profil ou message | P0 |
| US-051 | En tant qu'utilisateur, je bloque avec effet immédiat sur carte et listes | P0 |
| US-052 | En tant qu'utilisatrice, je filtre les activités "femmes uniquement" | P1 |
| US-053 | En tant que mineur, l'app détecte mon âge et restreint mes interactions | P0 |

---

## 8. FONCTIONNALITÉS MVP

- **Carte :** Mapbox, géoloc, icônes sport, clustering natif, 2 états bottom sheet
- **Filtres :** sport (temps réel), distance/isochrone, niveau, genre, date
- **Activités :** création 5 étapes, liste, détail, gestion demandes, édition, annulation
- **Matching :** demande, statut "en attente", notification créateur, acceptation/refus
- **Chat :** WebSocket, texte, partage position, lecture, archivage 24h
- **Profil :** mode invité + inscription complète avec vérification âge renforcée
- **Push :** demande, acceptation, refus, message, rappel, expiration, annulation
- **Sécurité :** signalement multi-entrées, blocage complet, modération photo, restrictions mineurs
- **États vides :** tous spécifiés avec CTA contextuels

---

## 9. FONCTIONNALITÉS V2

- Groupes sportifs (création, membres, feed, chat permanent)
- Activités récurrentes et tournois
- Recommandations IA personnalisées
- Gamification complète (leaderboards, défis, classements)
- Intégrations Strava / Apple Health / Google Fit
- Abonnement premium in-app (Apple IAP, Google Billing)
- Publicité locale contextuelle (après 50K MAU)
- Admin panel modération avancée (NLP)
- Matching partenaire régulier
- Bouton SOS / Signalement d'urgence (conformité DSA)

---

## 10. ARCHITECTURE TECHNIQUE

### 10.1 Vue d'Ensemble

```
┌──────────────────────────────────────────┐
│          CLIENTS MOBILES                 │
│       iOS (Flutter) | Android (Flutter)  │
└─────────────┬────────────────────────────┘
              │ HTTPS/TLS 1.3 + WSS
┌─────────────▼────────────────────────────┐
│  API GATEWAY (AWS ALB + WAF)             │
│  Rate limiting | JWT Auth | DDoS protect │
└──────────────┬───────────────────────────┘
               │
     ┌─────────┼──────────────┐
     ▼         ▼              ▼
┌─────────┐ ┌──────────┐ ┌──────────────┐
│REST API │ │WebSocket │ │Push Service  │
│NestJS   │ │NestJS    │ │FCM / APNs    │
└────┬────┘ └────┬─────┘ └──────────────┘
     └─────┬─────┘
           ▼
┌────────────────────────────────────────┐
│          COUCHE DONNÉES                │
│  PostgreSQL+PostGIS | Redis            │
│  RDS Proxy | Read Replica géo          │
└────────────────────────────────────────┘
```

### 10.2 Choix Flutter

Flutter retenu pour : performances Impeller (60/120fps natifs), overlays carte sans bridge, cohérence UI iOS/Android. Risk : recrutement Dart → mitiger par documentation. Alternative viable : React Native + Expo SDK 51+.

### 10.3 Stack Backend

NestJS + TypeScript + TypeORM + PostgreSQL PostGIS + Redis + Socket.io

### 10.4 Géolocalisation Temps Réel

- Foreground : update toutes les 30s si delta > 50m
- Redis TTL 300s : absent si pas d'update depuis 5 min
- PostgreSQL `last_location` : update si delta > 1km
- iOS : "When In Use" (pas de "Always" — évite Extended Review)
- Android : foreground uniquement (pas de `ACCESS_BACKGROUND_LOCATION`)

### 10.5 Push Notifications — 3 États

| État | Comportement | Implémentation |
|------|-------------|----------------|
| Foreground | In-app banner custom | `onMessage.listen()` |
| Background | Système standard | FCM/APNs automatique |
| Terminated | Cold start | `getInitialMessage()` |

Deep linking depuis notification → go_router avec payload JSON.

### 10.6 Mode Offline

Isar Database — fonctionnalités offline : voir activités en cache (TTL 10 min), envoyer message (queue), voir profil. Sync à la reconnexion : flush messages dans l'ordre chronologique.

### 10.7 Contraintes Stores

- **Apple :** délai revue 1-14 jours, Privacy Nutrition Labels, justification permissions
- **Google Play :** Closed Testing 20 testeurs × 14 jours, Data Safety Section
- **iOS :** pas de `ACCESS_ALWAYS_LOCATION`, permission push après contexte
- **Android :** pas de `ACCESS_BACKGROUND_LOCATION`

### 10.8 Infrastructure AWS

ECS Fargate + RDS Aurora Multi-AZ + RDS Proxy + ElastiCache Redis + CloudFront + WAF + ALB sticky sessions

### 10.9 Services Tiers

Mapbox (cartes + isochrones), Twilio (OTP), FCM/APNs (push), Cloudflare R2 (photos), OpenAI Moderation, Sentry, PostHog

---

## 11. SCHÉMA BASE DE DONNÉES

### 11.1 Tables Principales (DDL Simplifié)

```sql
CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pseudo VARCHAR(20) UNIQUE NOT NULL,
    age_range VARCHAR(10) CHECK (age_range IN ('13-17','18-25','26-35','36-45','46-60','60+')),
    gender VARCHAR(20),
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    phone_verified BOOLEAN NOT NULL DEFAULT FALSE,
    email_verified BOOLEAN NOT NULL DEFAULT FALSE,
    age_verification_level VARCHAR(20) DEFAULT 'declarative'
        CHECK (age_verification_level IN ('declarative','phone_verified','enhanced')),
    first_name VARCHAR(50),
    avatar_url TEXT,
    bio TEXT,
    is_guest BOOLEAN NOT NULL DEFAULT TRUE,
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    is_banned BOOLEAN NOT NULL DEFAULT FALSE,
    ban_reason TEXT,
    trust_score SMALLINT NOT NULL DEFAULT 50 CHECK (trust_score BETWEEN 0 AND 100),
    activity_score INTEGER NOT NULL DEFAULT 0,
    last_location GEOGRAPHY(POINT, 4326),
    last_location_updated_at TIMESTAMPTZ,
    last_seen_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE sport_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
    slug VARCHAR(50) UNIQUE NOT NULL,
    emoji CHAR(10),
    category VARCHAR(30)
);

CREATE TABLE user_sports (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    sport_id INTEGER NOT NULL REFERENCES sport_types(id),
    level VARCHAR(20) NOT NULL CHECK (level IN ('beginner','intermediate','advanced','expert')),
    PRIMARY KEY (user_id, sport_id)
);

CREATE TABLE activities (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    creator_id UUID REFERENCES users(id) ON DELETE SET NULL,
    sport_id INTEGER NOT NULL REFERENCES sport_types(id),
    title VARCHAR(100),
    description TEXT,
    location GEOGRAPHY(POINT, 4326) NOT NULL,
    address TEXT NOT NULL,
    location_name VARCHAR(100),
    scheduled_at TIMESTAMPTZ NOT NULL,
    duration_minutes SMALLINT,
    max_participants SMALLINT NOT NULL DEFAULT 2 CHECK (max_participants BETWEEN 1 AND 100),
    current_participants SMALLINT NOT NULL DEFAULT 1,
    required_level VARCHAR(20) DEFAULT 'any',
    gender_filter VARCHAR(20) NOT NULL DEFAULT 'all',
    visibility VARCHAR(20) NOT NULL DEFAULT 'public',
    invite_token UUID NOT NULL DEFAULT gen_random_uuid(),
    is_recurring BOOLEAN NOT NULL DEFAULT FALSE,
    status VARCHAR(20) NOT NULL DEFAULT 'active'
        CHECK (status IN ('active','full','cancelled','completed')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    CONSTRAINT participants_within_max CHECK (current_participants <= max_participants)
);
CREATE INDEX idx_activities_location ON activities USING GIST(location);
CREATE INDEX idx_activities_scheduled ON activities(scheduled_at) WHERE status = 'active';

CREATE TABLE activity_requests (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID NOT NULL REFERENCES activities(id) ON DELETE CASCADE,
    requester_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT,
    status VARCHAR(20) NOT NULL DEFAULT 'pending'
        CHECK (status IN ('pending','accepted','rejected','cancelled','expired')),
    expires_at TIMESTAMPTZ,  -- 2h avant scheduled_at
    responded_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(activity_id, requester_id)
);

CREATE TABLE chat_rooms (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    type VARCHAR(20) NOT NULL DEFAULT 'match',
    activity_id UUID REFERENCES activities(id) ON DELETE SET NULL,
    archived_at TIMESTAMPTZ,  -- 24h après fin de l'activité
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE matches (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    activity_id UUID REFERENCES activities(id),
    chat_room_id UUID UNIQUE REFERENCES chat_rooms(id),
    status VARCHAR(20) NOT NULL DEFAULT 'upcoming',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE match_participants (
    match_id UUID NOT NULL REFERENCES matches(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    role VARCHAR(20) NOT NULL DEFAULT 'participant',
    has_attended BOOLEAN,
    PRIMARY KEY (match_id, user_id)
);

CREATE TABLE messages (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    room_id UUID NOT NULL REFERENCES chat_rooms(id) ON DELETE CASCADE,
    sender_id UUID REFERENCES users(id) ON DELETE SET NULL,
    content TEXT NOT NULL CHECK (char_length(content) BETWEEN 1 AND 500),
    content_type VARCHAR(20) NOT NULL DEFAULT 'text'
        CHECK (content_type IN ('text','location','system')),
    is_moderated BOOLEAN NOT NULL DEFAULT FALSE,
    read_by UUID[] NOT NULL DEFAULT '{}',
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
CREATE INDEX idx_messages_room_created ON messages(room_id, created_at DESC);

CREATE TABLE reviews (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reviewer_id UUID NOT NULL REFERENCES users(id),
    reviewed_id UUID NOT NULL REFERENCES users(id),
    match_id UUID NOT NULL REFERENCES matches(id),
    rating SMALLINT NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(reviewer_id, match_id),
    CHECK (reviewer_id != reviewed_id)
);

CREATE TABLE reports (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    reporter_id UUID NOT NULL REFERENCES users(id),
    reported_user_id UUID REFERENCES users(id),
    reported_activity_id UUID REFERENCES activities(id),
    reported_message_id UUID REFERENCES messages(id),
    category VARCHAR(50) NOT NULL,
    description TEXT,
    severity VARCHAR(20) DEFAULT 'standard'
        CHECK (severity IN ('critical','urgent','standard')),
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    screenshot_path TEXT,   -- chemin S3 chiffré, accès modérateurs uniquement
    screenshot_expires_at TIMESTAMPTZ,  -- 1 an pour reports, 90j pour non-critiques
    admin_note TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE blocks (
    blocker_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    blocked_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (blocker_id, blocked_id),
    CHECK (blocker_id != blocked_id)
);

CREATE TABLE badges (
    id SERIAL PRIMARY KEY,
    slug VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    emoji CHAR(10),
    condition_type VARCHAR(50) NOT NULL,
    condition_value INTEGER NOT NULL,
    rarity VARCHAR(20) DEFAULT 'common'
        CHECK (rarity IN ('common','uncommon','rare','epic','legendary'))
);

CREATE TABLE user_badges (
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    badge_id INTEGER NOT NULL REFERENCES badges(id),
    earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    PRIMARY KEY (user_id, badge_id)
);

CREATE TABLE push_tokens (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    token TEXT NOT NULL,
    platform VARCHAR(10) NOT NULL CHECK (platform IN ('ios','android')),
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    UNIQUE(token)
);

-- Anti-gaming Trust Score
CREATE TABLE trust_score_events (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id),
    event_type VARCHAR(50) NOT NULL,
    delta SMALLINT NOT NULL,
    reference_id UUID,  -- match_id, report_id, etc.
    created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);
```

### 11.2 Structure Redis

| Clé | Type | TTL | Rôle |
|-----|------|-----|------|
| `user:loc:{uuid}` | Hash | 300s | Position temps réel |
| `activity:cache:{uuid}` | String JSON | 300s | Cache activité |
| `activities:zone:{geohash5}` | Set | 60s | Index zone |
| `rate:ip:{ip}:{endpoint}` | Counter | 60s | Rate limiting IP |
| `rate:user:{uuid}:{action}` | Counter | 60s | Rate limiting user |
| `otp:{phone}` | String | 120s | Code OTP |
| `otp:attempts:{phone}` | Counter | 900s | Tentatives OTP |
| `refresh_token:{hash}` | String | 2592000s | Refresh token |
| `block:pairs:{uuid}:{uuid}` | Flag | 0 | Paires bloquées (cache) |

---

## 12. APIs & ENDPOINTS

### 12.1 Conventions

- Base URL : `https://api.selene.app/v1`
- Auth : `Authorization: Bearer <jwt>` (RS256, 15 min)
- Format : JSON, UTC, snake_case
- Pagination : cursor-based
- Erreurs : `{ "error": { "code": "...", "message": "..." } }`

### 12.2 Endpoints Principaux

```
AUTH :
POST /auth/guest              → Créer invité
POST /auth/email/request      → Magic link
POST /auth/phone/request      → OTP (rate: 3/15min/phone)
POST /auth/phone/verify       → Vérifier OTP
POST /auth/token/refresh      → Rotation refresh token
POST /auth/logout             → Invalider

USERS :
GET    /users/me              → Mon profil
PUT    /users/me              → Modifier
DELETE /users/me              → Supprimer (async RGPD)
PUT    /users/me/location     → Position (rate: 1/10s)
GET    /users/me/data-export  → Export RGPD (async, email)

ACTIVITIES :
GET    /activities/nearby     → Cursor pagination géo (ST_DWithin)
GET    /activities/isochrone  → Filtrer par temps de trajet
POST   /activities            → Créer (trust_score >= 40)
PUT    /activities/:id        → Modifier (créateur)
DELETE /activities/:id        → Annuler
POST   /activities/:id/requests         → Demander (invité ou membre)
PUT    /activities/:id/requests/:reqId  → Accepter/refuser
DELETE /activities/:id/requests/:reqId  → Annuler demande

CHAT :
GET  /chat/rooms                    → Mes conversations
GET  /chat/rooms/:id/messages       → Historique (cursor)

SÉCURITÉ :
POST   /reports               → Signaler
POST   /blocks                → Bloquer
DELETE /blocks/:userId        → Débloquer

ADMIN (scope restreint, MFA obligatoire) :
GET  /admin/dashboard
GET  /admin/reports           → Queue modération
PUT  /admin/reports/:id       → Traiter
PUT  /admin/users/:id/ban     → Bannir
```

### 12.3 Contrat WebSocket

**Namespace /live :**
- Client → `subscribe_zone({ geohashes: string[] })`
- Server → `activity:created`, `activity:updated`, `activity:deleted`

**Namespace /chat :**
- Client → `send_message`, `mark_read`, `share_location`
- Server → `chat:message`, `chat:read`, `request:received`, `request:accepted`

### 12.4 Retry & Fallback

| Service | Retry | Fallback |
|---------|-------|----------|
| Mapbox Isochrone | 3x backoff 1s | `ST_DWithin` rayon fixe |
| Twilio OTP | 2x backoff 2s | AWS SNS SMS |
| FCM Push | 3x (Bull) | Log + pull session |
| OpenAI Moderation | 2x timeout 3s | Allow + flag review |

---

## 13. TEMPS RÉEL & CHAT

### 13.1 Architecture Multi-Instances

WebSocket NestJS + Redis Pub/Sub + `@socket.io/redis-adapter` + ALB sticky sessions

### 13.2 Notifications Push — Formulations

| Événement | Titre | Corps | Deep link |
|-----------|-------|-------|-----------|
| Demande reçue | "Nouvelle demande 🎾" | "{pseudo} veut rejoindre" | `/activities/:id/requests` |
| Accepté | "C'est parti ✅" | "{pseudo} a accepté" | `/chat/:room_id` |
| Refusé | "Pas de chance 😔" | "{pseudo} n'a pas de place" | `/map` |
| Nouveau message | "{pseudo}" | "{preview 50 chars}" | `/chat/:room_id` |
| Rappel activité | "Dans 1h — {sport}" | "Prépare-toi !" | `/activities/:id` |
| Annulation | "Annulé ❌" | "{sport} de {pseudo} annulé" | `/map` |
| Demande expirée | "Demande expirée" | "L'activité commence bientôt" | `/map` |

**Granularité des préférences push (onglet Paramètres) :**
- Nouvelles demandes (ON par défaut)
- Réponses à mes demandes (ON par défaut)
- Nouveaux messages (ON par défaut)
- Rappels d'activités (ON par défaut)
- Nouvelles activités dans ma zone (OFF par défaut)

---

## 14. SÉCURITÉ, RGPD & CONFORMITÉ

### 14.1 Sécurité Applicative

- JWT RS256, access 15 min, refresh 30 jours rotation
- Mobile : `flutter_secure_storage` (Keychain / EncryptedSharedPreferences)
- Certificate pinning en production
- Rate limiting par endpoint (voir tableau section 14.2)
- HTTPS/TLS 1.3, HSTS 1 an

### 14.2 Rate Limiting — Seuils Complets

| Endpoint | Limite | Fenêtre | Identification |
|----------|--------|---------|----------------|
| `POST /auth/phone/request` | 3 req | 15 min | numéro + IP |
| `POST /auth/email/request` | 5 req | 15 min | email + IP |
| `POST /activities` | 10 req | 1 heure | user JWT |
| `POST /activities/:id/requests` | 20 req | 1 heure | user JWT |
| `POST /reports` | 5 req | 1 heure | user JWT |
| API publique | 200 req | 1 min | IP |
| API authentifiée | 600 req | 1 min | user JWT |
| WebSocket messages | 60 msg | 1 min | user JWT |

### 14.3 RGPD — Mapping Complet des Bases Légales

| Traitement | Base légale (Art. RGPD) | Durée conservation |
|------------|-------------------------|-------------------|
| Géolocalisation carte (Redis) | Intérêt légitime + Consentement explicite | TTL 300s (session uniquement) |
| Position PostgreSQL `last_location` | Exécution du contrat | Compte actif uniquement |
| Email + téléphone | Exécution du contrat + Sécurité | Compte + 1 an |
| Photo profil | Exécution du contrat | Compte + 30 jours |
| Messages chat | Exécution du contrat | 1 an (90 jours si inactif) |
| Historique matchs | Exécution du contrat + Intérêt légitime | Compte + 2 ans |
| Logs applicatifs | Intérêt légitime (sécurité) | 90 jours |
| Screenshots signalement (critiques) | Intérêt légitime (modération + judiciaire) | 3 ans (critiques), 1 an (standard) |
| Trust Score events | Exécution du contrat | Durée compte |
| Device fingerprinting | Intérêt légitime (sécurité, anti-fraude) — test d'équilibre : intérêt à prévenir la fraude > impact sur l'utilisateur car données pseudo-anonymes, non partagées, TTL court | 30 jours glissants |
| Données de paiement (Stripe) | Obligation légale (conservation comptable Art. L123-22 C.com.) + Exécution du contrat | 10 ans (obligations comptables), données carte : non stockées (Stripe tokenisation) |

**Consentement :** obtenu via checkbox obligatoire au premier lancement ("J'accepte la Politique de confidentialité et les CGU"). Consentement granulaire pour : géolocalisation, notifications push, analytics.

### 14.4 Droits Utilisateurs

| Droit | Implémentation | Délai |
|-------|---------------|-------|
| Accès (Art. 15) | Export JSON depuis Paramètres → envoyé par email | 72h |
| Rectification (Art. 16) | Modification profil en temps réel | Immédiat |
| Effacement (Art. 17) | "Supprimer mon compte" → purge async | 30 jours |
| Portabilité (Art. 20) | Export JSON : profil, sports, matchs, avis reçus, historique | 72h |
| Opposition (Art. 21) | Opt-out analytics, opt-out notifications marketing | Immédiat |

**Processus interne pour demandes RGPD :**
- SLA de réponse : 1 mois réglementaire
- Référent RGPD désigné (voir 14.7)
- Workflow documenté dans Notion (ticket → vérification identité → traitement → confirmation)

### 14.5 Transferts Données Hors UE

| Sous-traitant | Pays | Mécanisme de transfert |
|---------------|------|----------------------|
| AWS (ECS, RDS, S3) | USA | SCC + AWS DPA, région eu-west-3 (Paris) |
| Firebase/FCM | USA | SCC + Google DPA |
| Twilio | USA | SCC + Twilio DPA |
| Cloudflare R2 | USA | SCC + Cloudflare DPA |
| Sentry | USA | SCC + Sentry DPA |
| PostHog | EU (option cloud EU) | Données stockées en UE |
| Resend | USA | SCC |

### 14.6 Protection des Mineurs — Vérification d'Âge Renforcée

**Niveau 1 — Déclaratif (mode invité) :**
- Curseur d'âge par tranche
- Si tranche "13-17" → accès mode restreint mineur automatique

**Niveau 2 — Phone-verified (membres) :**
- OTP SMS obligatoire pour compléter l'inscription
- Un numéro de téléphone = un compte (limite les faux âges)

**Niveau 3 — Enhanced (optionnel, badges Pro) :**
- Vérification par recoupement carte bancaire (indicateur probabiliste d'âge >18)
- Ou service tiers CNIL-compatible (Veriff, Yoti) avec badge "Identité vérifiée"

**Restrictions mode mineur (13-17 ans) :**
- Profil non visible publiquement (prénom masqué, avatar caché)
- Accès uniquement aux activités marquées "Tous âges" ou "Jeunesse"
- Chat uniquement avec adultes ayant obtenu badge "Identité vérifiée"
- Pas de création d'activité en solo (doit inviter un adulte de confiance)

**Signaux de détection d'un profil potentiellement mineur (même si déclarant 18+) :**
- Compte créé sans vérification bancaire ni identité
- Comportement inhabituellement actif aux heures scolaires
- Signalements d'autres utilisateurs → flag pour review manuelle

**< 13 ans :** accès refusé. Si détecté, suppression du compte.

### 14.7 DPO & Registre des Traitements

**Référent RGPD :** Désigner un DPO externe (prestataire juridique spécialisé) avant le lancement public. Budget estimé : 2 000-4 000 €/an.

**Obligation DPO :** évaluer à l'approche de 100 000 utilisateurs actifs. Si atteint, désignation obligatoire (Art. 37 RGPD pour traitements à grande échelle de données sensibles).

**Registre des Traitements (Art. 30) :** Document vivant tenu à jour par le référent RGPD, listant chaque traitement, sa finalité, sa base légale, ses destinataires et ses durées de conservation.

**DPIA (Art. 35) :** Obligatoire pour la géolocalisation temps réel à grande échelle. À commander auprès d'un juriste RGPD avant le lancement (délai 4-6 semaines, budget 3 000-6 000 €). Mesures de mitigation à documenter.

### 14.8 Screenshots de Signalement — Encadrement

**Déclenchement :** capture automatique du contexte (chat/profil) au moment d'un signalement pour faciliter la modération.

**Accès :** modérateurs uniquement (rôle `moderator` ou `admin` avec log d'audit obligatoire)

**Chiffrement :** chemin S3 avec SSE-KMS, accessible uniquement via API admin authentifiée

**Durées :** 3 ans pour signalements catégorisés `critical` (agression, contenu illicite), 1 an pour `urgent`, 90 jours pour `standard`

**Base légale :** Intérêt légitime à la modération et à la coopération judiciaire, documenté dans le DPIA

**Droit à l'effacement :** si un signalement est classé `dismissed` (non fondé), le screenshot est supprimé dans les 30 jours

### 14.9 Device Fingerprinting — Encadrement

**Finalité :** anti-fraude, détection de comptes multiples, détection de contournement après bannissement

**Base légale :** Intérêt légitime (Art. 6.1.f RGPD) — sécurité de la plateforme et protection des utilisateurs contre la fraude

**Test d'équilibre (Art. 6.1.f) :**
- *Intérêt légitime poursuivi* : prévenir la création de comptes frauduleux et le contournement de bannissements, protéger l'ensemble des utilisateurs
- *Nécessité du traitement* : aucune alternative moins intrusive n'offre le même niveau de protection contre les comptes multiples
- *Balance des intérêts* : les données collectées sont pseudo-anonymes (hash, non réversible), non partagées avec des tiers, TTL 30 jours. L'impact sur les droits des utilisateurs est limité et proportionné à l'objectif de sécurité
- *Documenté dans la DPIA et le Registre des Traitements*

**Données collectées :** hash du device (combinaison OS version + résolution + timezone + language) — jamais de données d'identification directe

**Conservation :** 30 jours glissants (suppression automatique)

**Information utilisateur :** mentionné explicitement dans la Politique de Confidentialité, section "Sécurité et prévention de la fraude"

### 14.10 Sécurité Infrastructure

- Secrets : AWS Secrets Manager (rotation automatique)
- VPC privé pour bases de données
- WAF : AWS WAF v2 + OWASP Core Rule Set v4
- RDS : backups quotidiens, rétention 35 jours, point-in-time recovery
- **RPO cible : 1 heure** / **RTO cible : 4 heures**
- Redis : RDB snapshot /heure + AOF
- RDS Multi-AZ avec failover automatique (~30s)

### 14.11 Plan de Réponse aux Incidents

**Classification :**

| Niveau | Description | Exemple | Action |
|--------|-------------|---------|--------|
| P0 — Critique | Violation de données personnelles | Fuite BDD | Notification CNIL 72h + utilisateurs à risque |
| P1 — Urgent | Incident sécurité actif | Compromission API | Escalade CTO + mitigation < 2h |
| P2 — High | Dégradation service | API > 500ms p95 | Alerte on-call < 30 min |
| P3 — Standard | Bug mineur | Erreur UI | Ticket backlog |

**Notification CNIL (Art. 33 RGPD) :** notification dans les 72h en cas de violation affectant des données personnelles. Template de notification préparé à l'avance. Contact CNIL designé.

**Runbook documenté :** dans Notion, testé trimestriellement.

### 14.12 Conformité App Store & Play Store

**Apple App Store :**
- Privacy Nutrition Labels : déclarer géolocalisation précise, données de contact (email, téléphone), historique utilisation
- `NSLocationWhenInUseUsageDescription` : "Séléné utilise votre position pour afficher les activités sportives proches"
- `NSCameraUsageDescription` : "Pour ajouter votre photo de profil"
- Délai revue : prévoir 7-14 jours (app avec géoloc + contenu communautaire)

**Google Play :**
- Data Safety Section : déclarer géoloc précise (collectée, partagée), numéro de téléphone, email, photos
- Closed Testing : 20 testeurs × 14 jours consécutifs avant publication
- `ACCESS_FINE_LOCATION` : déclaré dans Data Safety comme "collecté, non partagé avec tiers"
- `ACCESS_BACKGROUND_LOCATION` : **non utilisée** (mention explicite dans Data Safety)

---

## 15. MODÉRATION & ANTI-FRAUDE

### 15.1 SLA de Modération — Multi-Niveaux

| Niveau | Description | Exemples | SLA premier triage | Action |
|--------|-------------|----------|-------------------|--------|
| **Critique** | Contenu illicite, agression signalée | Menace physique, contenu pédopornographique | **< 2 heures** (humain) | Suspension immédiate + signalement autorités |
| **Urgent** | Harcèlement actif | Messages répétitifs menaçants | **< 8 heures** (humain) | Suspension préventive + investigation |
| **Standard** | Comportement inapproprié, spam | Faux compte, publicité | **< 24 heures** (IA + humain) | Avertissement ou ban selon antécédents |
| **Informatif** | Contenu limite | Texte agressif sans menace | **< 48 heures** (IA) | Review + feedback à l'auteur |

**Chaine d'escalade :**
- Modérateur → Superviseur de modération → CTO/CEO (P0)
- Disponibilité on-call weekends et nuits pour les niveaux Critique et Urgent

### 15.2 Processus Post-Incident Physique

**Définition :** tout signalement indiquant qu'une rencontre sportive organisée via Séléné a abouti à une agression physique, un harcèlement physique, ou tout incident grave.

**Procédure interne détaillée :**

| Étape | Action | Responsable | Délai |
|-------|--------|-------------|-------|
| 1 | Réception du signalement "Incident grave" via formulaire dédié (accessible depuis le profil) | Modérateur on-call | Immédiat |
| 2 | Escalade au responsable modération + CEO + DPO | Modérateur on-call | < 30 min |
| 3 | Conservation immédiate des données (messages, activité, profils, logs de session) — flag `legal_hold = true` | Équipe technique | < 1 heure |
| 4 | Suspension préventive du compte signalé | Modérateur senior | < 1 heure |
| 5 | Contact direct avec la personne signalante (email empathique + numéros d'urgence si besoin) | CEO ou responsable modération | < 4 heures |
| 6 | Décision sur coopération judiciaire proactive (selon gravité) | CEO + référent juridique | < 24 heures |
| 7 | Mise à disposition des données sur réquisition judiciaire (processus documenté, délai légal respecté) | DPO + référent juridique | Selon réquisition |
| 8 | Post-incident : revue interne, mise à jour des procédures si nécessaire | CEO + CTO | < 7 jours |

**Communication de crise :** en cas d'incident médiatisé, désigner un porte-parole unique (CEO). Pas de communication publique avant avis juridique. Template de communiqué préparé à l'avance.

**Conservation des données :** 5 ans minimum pour les incidents graves (Art. 17.3.e RGPD — conservation à des fins de défense en justice).

**CGU :** clause spécifique sur la coopération avec les autorités en cas d'incident grave.

### 15.3 Anti-Fake Accounts

1. OTP téléphone obligatoire pour publier (1 compte / numéro)
2. Photo profil avec détection visage réel (AWS Rekognition)
3. Trust score minimum 40 pour publier
4. Domaines email jetables bloqués (liste mise à jour)
5. Device fingerprinting (limite créations par device)
6. > 10 demandes en 5 min → CAPTCHA

### 15.4 Trust Score — Anti-Gaming

**Mécanismes de détection :**
- Sessions validées entre comptes créés le même jour → flag automatique
- Comptes sur le même sous-réseau IP → investigation
- Même device (fingerprint) → alerte
- Avis échangés entre comptes sans historique commun → annulation des avis suspects
- Délai minimum entre création du compte et obtention du 1er badge : 7 jours
- Badges "Fiable" et "Champion" : validation manuelle par un modérateur pour les 3 premiers de chaque ville

**Algorithme trust score :**

| Action | Delta |
|--------|-------|
| Base création compte | +50 |
| Email vérifié | +10 |
| Téléphone vérifié | +15 |
| Photo modérée | +20 |
| Avis positif reçu (4-5★) | +5 |
| Match complété avec présence | +3 |
| Signalement fondé | -15 |
| No-show | -10 |
| Avertissement admin | -30 |
| Trust < 20 | Suspension auto + review |
| Trust < 0 | Ban permanent |

### 15.5 Back-Office de Modération — Sécurité

- MFA obligatoire pour tous les accès au back-office
- Accès uniquement depuis IP de l'entreprise (VPN obligatoire)
- Rôles granulaires : `moderator` (lecture + actions courantes), `supervisor` (accès complet + bans), `admin` (configuration)
- Log de chaque action de modération avec : identifiant du modérateur, timestamp, action, utilisateur cible, raison
- Accès aux messages privés uniquement dans le contexte d'un signalement actif (pas de browsing libre)
- Revue trimestrielle des accès (principe du moindre privilège)

### 15.6 Système de Blocage — Effets Complets

**Effets immédiats :**
- Utilisateur bloqué disparaît de la carte
- Activités du bloqué invisibles
- Demandes silencieusement ignorées
- Messages non délivrés (sans notification d'erreur)
- Blocage silencieux (bloqué ne sait pas)

**Effets secondaires :**
- Contournement : si même téléphone ou device → flag
- 3 utilisateurs différents bloquent le même profil → alerte modération
- Blocage non réciproque (A bloque B ≠ B bloque A)

### 15.7 Abus du Système de Signalement

- Limitation : 5 signalements / heure / utilisateur
- Détection : même utilisateur signale 5+ profils en 1 jour → flag pour review
- Signalement `dismissed` → pénalité légère sur le trust score du signalant si pattern répété
- Les signalements dismississés répétés → avertissement puis restriction du droit de signaler

---

## 16. ANALYTICS & ADMIN PANEL

### 16.1 SLA Techniques

| Endpoint | p95 cible | Disponibilité |
|----------|-----------|---------------|
| `GET /activities/nearby` | < 200ms | 99.9 % |
| Chat WebSocket (end-to-end) | < 500ms | 99.9 % |
| `POST /activities` | < 300ms | 99.9 % |
| Livraison push | < 5s | 99.5 % |
| Disponibilité globale | — | 99.5 % MVP |

### 16.2 Admin Panel

React + Vite + Tailwind, accès VPN + MFA

| Module | Fonctionnalités |
|--------|----------------|
| Dashboard | KPIs temps réel, heat map, alertes P0/P1 |
| Utilisateurs | Search, profil, trust score, ban, historique |
| Activités | Modération, stats, suppression |
| Signalements | Queue multi-niveaux, SLA countdown, workflow |
| Audit logs | Toutes les actions de modération |
| Configuration | Feature flags, liste noire mots, zones |

---

## 17. MODÈLE FREEMIUM, MONÉTISATION & BUSINESS MODEL

### 17.1 Version Gratuite

- 3 demandes / jour, 1 activité simultanée, carte complète, chat matchs actifs, historique 30 jours

### 17.2 Séléné Premium — 4,99 €/mois ou 39,99 €/an

- Demandes illimitées, 5 activités simultanées, voir consultants de mon activité, boost visibilité, stats avancées, badge Premium, historique illimité

### 17.3 Séléné Pro (Coachs/Clubs) — 39 €/mois ou 299 €/an

**Pricing justifié :** clubs amateurs sportifs en France : budget mensuel outil numérique 20-80€. Valeur perçue : remplace Eventbrite (9,99% commission) + WhatsApp + formulaire Google.

**Features exclusives Pro :**
1. 50 participants max par activité
2. Activités récurrentes illimitées
3. Page profil pro (site web, description longue, logo)
4. Gestion présence (pointage digital)
5. Liste d'attente automatique
6. Analytics événements (vues, conversions, rétention)
7. Export CSV participants
8. Support prioritaire 24h

**Processus de vente :**
- Self-service via l'app (IAP)
- Partenariat avec 1-2 fédérations sportives régionales (premier canal B2B) : remise 20% sur abonnement annuel en échange de visibilité
- Budget vente B2B : 0€ en MVP (100% self-service)

### 17.4 Publicité Locale — Repositionné en Phase 3

**Raison :** l'inventaire publicitaire d'une app < 50K MAU génère < 500€/mois. Les annonceurs locaux n'ont pas les outils pour acheter en programmatique. Ce canal ne devient rentable qu'après 100K-200K MAU.

**Timeline :** Phase 3 = V3 (M24+), uniquement après atteinte 50K MAU.

**Approche alternative avant :** placements sponsorisés négociés manuellement avec 2-3 marques sportives régionales (Decathlon local, salles de sport partenaires). Revenus estimés : 500-2000€/mois à partir de M9.

### 17.5 Partenariats B2B

- Salles de sport : page officielle Séléné + intégration booking (V2)
- Clubs sportifs : visibilité événements, recrutement
- Mairies : promotion équipements sportifs publics
- Déclenché après 5K MAU dans une ville

### 17.6 Stratégie Masse Critique Géographique

**Problème :** une app de mise en relation locale nécessite un seuil minimal d'utilisateurs par ville pour être utile. En dessous de ~500 MAU dans une ville, la carte est trop vide.

**Solution : lancement concentré ville par ville**

```
M0-M6   : Lyon pilote UNIQUEMENT
          Objectif : 5 000 MAU, 200 activités/semaine
          Budget marketing : 80% des dépenses marketing sur Lyon
          
M7-M12  : Bordeaux (M7) + Toulouse (M10)
          Condition d'ouverture : 5 000 MAU à Lyon + J30 > 30%
          
M13-M18 : Paris, Marseille, Nantes
          Condition : 3 000+ MAU dans chaque ville ouverte précédemment
          
M19-M24 : Lille, Strasbourg, Montpellier, Nice
```

**Stratégie d'activation locale (par ville) :**
1. Partenariat avec 3-5 clubs sportifs locaux (comptes Pro offerts 3 mois)
2. Événements IRL de lancement ("Tournoi Séléné")
3. 10-15 ambassadeurs locaux (coachs + organisateurs)
4. Contenu géolocalisé TikTok/Instagram pour chaque ville

---

## 18. GAMIFICATION & RÉTENTION

### 18.1 Badges

| Badge | Condition | Rareté |
|-------|-----------|--------|
| 🏃 Première foulée | 1er match complété | Commun |
| 🎾 Multi-sport | 3 sports différents | Commun |
| 🔥 En feu | 5 matchs en 1 semaine | Peu commun |
| 👥 Organisateur | 10 activités créées | Peu commun |
| 🌟 5 étoiles | Réputation ≥ 90 | Rare |
| 🏆 Champion local | Top 10 sport dans sa ville | Rare |
| 💎 Vétéran | 100 matchs complétés | Épique |
| 👑 Séléné Star | Meilleur partenaire du mois | Légendaire |

### 18.2 Activity Score & Rétention

- **Streak hebdomadaire** : au moins 1 activité/semaine → notification de relance si streak en danger
- **Défis hebdomadaires** : 3 défis personnalisés chaque lundi
- **North Star métriques rétention** : J7 cible 35%, J30 cible 20%, J90 cible 15%

### 18.3 Onboarding des 72 Premières Heures (Critical Retention Window)

```
H0   : Téléchargement → Carte + activités proches en 30s (valeur immédiate)
H1   : Push "Bienvenue ! 3 activités tennis près de toi ce weekend"
H24  : Push "Nouveau : 5 activités dans ton quartier aujourd'hui"
H48  : Si pas de demande envoyée → Push "Prêt à rejoindre une partie ?"
H72  : Si demande envoyée sans match → Push "Essaie d'autres activités"
      Si 1er match confirmé → Push opt-in notifications + inscription complète
```

---

## 19. MATCHING INTELLIGENT (IA)

### 19.1 MVP — Recommandation Basique

Top 5 activités "Pour toi" basées sur : sport (40%), niveau (25%), zone habituelles (20%), horaires (15%). Calculé à la demande, cache Redis 10 min.

### 19.2 V2 — Algorithme Avancé

FastAPI Python micro-service + LightGBM + features : vecteur sports/niveaux, temporel, géographique, compatibilité post-match.

---

## 20. DIAGRAMMES FONCTIONNELS

### 20.1 Flux Complet

```
CRÉATEUR A                               PARTICIPANT B
    │ Publie activité Tennis              │
    │ → Live sur carte                    │
    │                                     │ Voit 🎾 sur carte
    │                                     │ Bottom sheet preview
    │                                     │ [Rejoindre] → inscription si invité
    │                                     │ → Retour auto sur activité
    │ 🔔 "Karim demande" ◄────────────────│ Statut : "En attente ⏳"
    │                                     │
    │ Consulte profil                     │
    │ ACCEPTE ───────────────────────────►│ 🔔 "C'est parti !"
    │                                     │
    │ Chat ouvert ◄──────────────────────►│ Chat ouvert
    │ [Partage position 📍] ◄────────────►│ [Partage position 📍]
    │                                     │
    │ MATCH COMPLÉTÉ → Avis mutuels      │
```

### 20.2 Filtres Isochrones

```
Position utilisateur → [Mapbox Isochrone API] → Polygone GeoJSON
→ [PostGIS ST_Within] → Activités dans la zone
→ Fallback si Mapbox indispo : [ST_DWithin rayon fixe]
```

---

## 21. STRUCTURE ÉCRANS & NAVIGATION

### 21.1 Bottom Tab Bar

```
🗺️ Carte | 🔔 Activités | ➕ | 💬 Chat | 👤 Profil
```

### 21.2 Arborescence Complète

```
APP SÉLÉNÉ
├── ONBOARDING
│   ├── Splash + Logo
│   ├── 3 slides (skippable)
│   ├── Pré-permission géoloc (écran explicatif)
│   └── Profil invité (âge, genre, pseudo)
│
├── TAB CARTE
│   ├── Carte Mapbox (clustering, markers)
│   │   └── Tap → Bottom Sheet PREVIEW (45% écran, carte visible)
│   │         └── Swipe up → Bottom Sheet DÉTAILLÉ (full screen)
│   │               └── [Rejoindre] → tunnel inscription si invité
│   └── Panel Filtres (bottom sheet)
│       (sport, distance/trajet, mode, niveau, genre, date)
│
├── TAB ACTIVITÉS
│   ├── Mes demandes (En attente / Confirmé / Refusé / Expiré)
│   └── Mes activités créées (Actives / Passées)
│
├── TAB ➕ (5 étapes)
│   1. Sport → 2. Lieu → 3. Date/Heure → 4. Participants → 5. Description
│   └── Aperçu + Publier → Confirmation
│
├── TAB CHAT
│   ├── Liste conversations (badge non-lus)
│   └── Conversation
│       ├── Messages texte
│       ├── [Partager ma position 📍]
│       └── Infos activité (header cliquable)
│
├── TAB PROFIL
│   ├── Mon profil (photo, score, sports, badges)
│   ├── Badges (grille couleur + grisé)
│   ├── Historique matchs
│   └── Paramètres
│       ├── Notifications (granulaire)
│       ├── Géolocalisation (on/off + info)
│       ├── Confidentialité
│       ├── Premium / Pro
│       └── RGPD (export, suppression)
│
├── PROFIL AUTRE UTILISATEUR
│   ├── Photo + Pseudo + Score + Badges
│   ├── Activités récentes
│   ├── Avis reçus
│   ├── [Signaler ⋮] [Bloquer]
│
└── INSCRIPTION COMPLÈTE (modale)
    ├── 1/4 Email (magic link)
    ├── 2/4 Téléphone (OTP)
    ├── 3/4 Photo (modération IA)
    └── 4/4 Sports + Niveaux
```

---

## 22. UX/UI — DESIGN SYSTEM 2026

### 22.1 Principes

1. Mobile-first natif — chaque interaction pensée pour le doigt
2. Glassomorphisme contextuel — UI légère sur fond de carte
3. Micro-animations + haptics — `HapticFeedback` sur toutes les actions clés
4. Dark mode natif — `ThemeData.platformBrightness` + toggle manuel
5. **Accessibilité AA obligatoire**
6. i18n prêt — `flutter_localizations` + `intl` dès le MVP

### 22.2 Accessibilité

- `Semantics` widgets sur **tous** les éléments interactifs (markers carte inclus)
- Labels accessibilité markers : "Activité tennis, 1.2km, 3 places, aujourd'hui 18h"
- Dynamic Type iOS / Accessibility Android : taille texte adaptable
- Contrastes : WCAG 2.1 AA minimum (ratio 4.5:1 pour texte standard)
- Navigation switch control / clavier : supportée pour les actions principales

### 22.3 Couleurs

```
Primaire   : #4F46E5  (Indigo — CTAs)
Succès     : #10B981  (Vert — validations)
Accent     : #F59E0B  (Ambre — badges, highlights)
Danger     : #EF4444  (Rouge — erreurs, annulations)
Fond dark  : #111827
Fond light : #F9FAFB
```

---

## 23. ROADMAP TECHNIQUE — SPRINT PAR SPRINT

**MVP — 4 mois (Sprints 1-16 × 1 semaine)**

| Sprints | Focus |
|---------|-------|
| 1-2 | Setup Flutter + NestJS + PostgreSQL + PostGIS + auth invité |
| 3-4 | Carte Mapbox v2.x + clustering + filtres + ST_DWithin |
| 5-6 | Isochrones Mapbox + fallback + bottom sheet 2 états |
| 7-8 | Matching (demande/acceptation) + états intermédiaires + push 3 états |
| 9-10 | Chat WebSocket + partage position + deep linking notifications |
| 11-12 | Profil 2 niveaux + OTP + vérification âge renforcée + Isar offline |
| 13-14 | Sécurité (rate limiting, blocage complet, modération photo, DPIA prep) |
| 15 | Admin panel + SLA modération multi-niveaux + analytics |
| 16 | App Store prep (Privacy Labels, Closed Testing) + launch Lyon |

**V2 — Sprints 17-32**
- S17-20 : Groupes sportifs
- S21-24 : Gamification complète + leaderboards
- S25-28 : IA recommandation
- S29-32 : Premium in-app + Bouton SOS

---

## 24. ESTIMATION COMPLEXITÉ & COÛTS CLOUD

### 24.1 Complexité MVP

| Feature | Complexité | Jours |
|---------|-----------|-------|
| Carte + clustering + 2 états bottom sheet | M | 4 |
| PostGIS + cursor pagination + isochrones | XL | 6 |
| Matching + états intermédiaires | L | 5 |
| Push notifications 3 états + deep linking | XL | 6 |
| Chat + partage position + archivage | XL | 7 |
| Profil 2 niveaux + OTP + vérif âge | L | 5 |
| Géoloc temps réel + cycle de vie Redis | M | 3 |
| Blocage complet + signalement multi-entrées | L | 4 |
| SLA modération + back-office sécurisé | XL | 8 |
| RGPD + export + suppression + DPIA | M | 4 |
| CI/CD + infra AWS + RDS Proxy | L | 5 |
| App Store/Play Store prep + Privacy | M | 3 |
| **TOTAL** | | **~70 jours** |

### 24.2 Coûts Cloud AWS

**Production MVP (1K-5K MAU) :** ~750 €/mois

**Scale (50K MAU) :** ~3 500-4 500 €/mois

### 24.3 Mapbox Budget

| MAU | Map loads/mois | Coût Mapbox | Alternative MapLibre |
|-----|----------------|-------------|---------------------|
| 5 000 | ~450 000 | ~800 USD | ~100 USD |
| 10 000 | ~900 000 | ~1 700 USD | ~150 USD |
| 50 000 | ~4 500 000 | ~8 200 USD | ~400 USD |

Migrer vers MapLibre au franchissement de 10K MAU (économie ~1 500 USD/mois).

---

## 25. ÉQUIPE NÉCESSAIRE

### 25.1 MVP (4 mois)

| Rôle | ETP | Coût estimé |
|------|-----|-------------|
| Lead Full-Stack (NestJS + AWS + DevOps) | 1.0 | ~48 000 € |
| Mobile Flutter Senior | 1.0 | ~44 000 € |
| PM / Product Designer | 0.5 | ~19 800 € |
| QA | 0.3 | ~10 560 € |
| Référent RGPD externe | Forfait | ~3 000 € |
| **TOTAL DEV MVP** | | **~125 000 €** |

---

## 26. STRATÉGIE CROISSANCE, ACQUISITION & RÉTENTION

### 26.1 Acquisition — Quantifiée

**CAC cible par canal :**

| Canal | CAC cible | Volume cible M1-M6 |
|-------|-----------|-------------------|
| Ambassadeurs locaux (clubs) | < 2 € | 1 500 users |
| Contenu organique (TikTok/Reels) | 0 € | 1 500 users |
| Meta Ads (retargeting) | < 5 € | 1 000 users |
| Événement IRL lancement | < 3 € | 500 users |
| Bouche-à-oreille / referral | 0 € | 500 users |
| **TOTAL M0-M6** | **~2.80 € CAC moyen** | **5 000 users** |

**Budget marketing M0-M6 :** 14 000 € (concentré sur Lyon)

**Critères d'ouverture ville suivante :**
- Ville précédente : 5 000 MAU + rétention J30 > 25% + 3 ambassadeurs Pro actifs
- Décision par le CEO, validée en board mensuel

### 26.2 Rétention

1. **Push notifications intelligentes** — nouvelles activités zone, rappels, défis
2. **Gamification** — streaks, badges, défis hebdomadaires
3. **Onboarding 72h critique** (voir section 18.3)
4. **Personnalisation IA** — recommandations qui s'améliorent
5. **Réseau partenaires récurrents** — "retrouve tes partenaires habituels"

**Courbe de rétention cible :**
J1 : 65% → J7 : 35% → J30 : 20% → J90 : 12%

---

## 27. MODÈLE FINANCIER & PROJECTIONS 24 MOIS

### 27.1 Hypothèses de Conversion

**Benchmarks marché sports apps :**
- Strava : ~12% conversion sur base mature (15 ans d'existence)
- Apps sociales sportives early-stage : 2-4% dans les 18 premiers mois
- Notre hypothèse conservatrice : 3% M6, 5% M12, 7% M18, 10% M24

**Hypothèses Premium :**
- ARPU Premium : 4,00 €/mois net (4,99 brut moins Apple/Google 30%)
- Taux conversion Free → Premium : 3% (M6), 5% (M12), 7% (M24)

**Hypothèses Pro :**
- ARPU Pro : 31 €/mois net (39 brut moins 20% IAP)
- Taux conversion Free → Pro : 0.3% (M6), 0.6% (M12), 1% (M24)

### 27.2 Projections MAU par Phase

| Mois | Villes | MAU | Activités/j |
|------|--------|-----|-------------|
| M3 | Lyon (pilote) | 1 500 | 60 |
| M6 | Lyon | 5 000 | 200 |
| M9 | Lyon + Bordeaux | 10 000 | 400 |
| M12 | 3 villes | 18 000 | 700 |
| M18 | 5 villes | 35 000 | 1 400 |
| M24 | 8 villes | 65 000 | 2 600 |

### 27.3 Projections Revenus — 3 Scénarios

**Scénario Pessimiste (conversion × 0.6)**

| Mois | Premium | Pro | Pub/Partenariats | Total MRR |
|------|---------|-----|-----------------|-----------|
| M6 | 360 € | 47 € | 0 € | **407 €** |
| M12 | 1 440 € | 340 € | 500 € | **2 280 €** |
| M18 | 2 940 € | 1 000 € | 1 500 € | **5 440 €** |
| M24 | 5 460 € | 2 015 € | 2 500 € | **9 975 €** |

**Scénario Base**

| Mois | Premium | Pro | Pub/Partenariats | Total MRR |
|------|---------|-----|-----------------|-----------|
| M6 | 600 € | 78 € | 0 € | **678 €** |
| M12 | 2 400 € | 567 € | 800 € | **3 767 €** |
| M18 | 4 900 € | 1 666 € | 2 000 € | **8 566 €** |
| M24 | 9 100 € | 3 348 € | 4 000 € | **16 448 €** |

**Scénario Optimiste (conversion × 1.5)**

| Mois | Premium | Pro | Pub/Partenariats | Total MRR |
|------|---------|-----|-----------------|-----------|
| M6 | 900 € | 117 € | 0 € | **1 017 €** |
| M12 | 3 600 € | 851 € | 1 500 € | **5 951 €** |
| M18 | 7 350 € | 2 500 € | 4 000 € | **13 850 €** |
| M24 | 13 650 € | 5 022 € | 8 000 € | **26 672 €** |

### 27.4 Coûts Opérationnels

| Poste | M6 | M12 | M18 | M24 |
|-------|-----|-----|-----|-----|
| Équipe (salaires) | 18 000 € | 22 000 € | 28 000 € | 35 000 € |
| Infrastructure AWS | 750 € | 1 200 € | 2 000 € | 3 500 € |
| Services tiers (Mapbox, Twilio…) | 300 € | 600 € | 1 200 € | 2 000 € |
| Marketing | 2 500 € | 3 000 € | 4 000 € | 5 000 € |
| Modération | 1 500 € | 2 000 € | 3 000 € | 4 000 € |
| Juridique/RGPD | 500 € | 500 € | 500 € | 500 € |
| **TOTAL BURN RATE** | **~23 550 €** | **~29 300 €** | **~38 700 €** | **~50 000 €** |

### 27.5 Point Mort (Break-Even)

**Calcul au scénario base :**
- Burn rate M24 : 50 000 €/mois
- ARPU blended (mix free/premium/pro) : 0.25 € par MAU
- MAU nécessaire pour break-even : **200 000 MAU** (estimation M30-M36)

**Calcul point mort abonnements seuls :**
- Coûts fixes équipe + infra : ~40 000 €/mois (M24)
- Avec 5% Premium (4€ ARPU) + 0.6% Pro (31€ ARPU) :
  - 100 000 MAU → 5 000 Premium (20 000 €) + 600 Pro (18 600 €) = 38 600 €/mois → quasi break-even abonnements
  - **Point mort abonnements : ~100 000 MAU**

---

## 28. FINANCEMENT, RUNWAY & UTILISATION DES FONDS

### 28.1 Besoins de Financement

**Phase 1 — MVP & Lancement Lyon (M0-M6)**

| Poste | Montant |
|-------|---------|
| Développement MVP (dev + PM + QA) | 125 000 € |
| Infrastructure cloud (6 mois) | 5 000 € |
| Marketing lancement Lyon | 14 000 € |
| Légal (RGPD, CGU, DPIA, DPO) | 10 000 € |
| Buffer opérationnel (20%) | 30 000 € |
| **TOTAL PHASE 1** | **~184 000 €** |

**Phase 2 — Scale & V2 (M7-M18)**

| Poste | Montant |
|-------|---------|
| Équipe élargie (M7-M18) | 250 000 € |
| Infrastructure scale | 25 000 € |
| Marketing (3 nouvelles villes) | 50 000 € |
| Développement V2 | 80 000 € |
| **TOTAL PHASE 2** | **~405 000 € supplémentaires** |

### 28.2 Stratégie de Financement

**Amorçage (pre-seed) : 200 000-300 000 €**
- Sources : love money, BPIfrance (French Tech Seed), incubateurs (Station F, Wilco, etc.)
- Runway cible : 9-12 mois (jusqu'au lancement + premières données de rétention)
- Milestones requis pour seed : 5 000 MAU Lyon + rétention J30 > 20% + 1ère ville ouverte

**Seed : 600 000-1 000 000 €**
- Déclencheur : preuves d'engagement (North Star > 2 000 matchs/semaine)
- Utilisation : scale 5 villes + V2 + équipe (hiring CTO si fondateur non-technique)

### 28.3 Utilisation des Fonds (Pre-seed 250K€)

| Catégorie | % | Montant |
|-----------|---|---------|
| Développement produit | 65 % | 162 500 € |
| Marketing & acquisition | 15 % | 37 500 € |
| Légal & conformité | 8 % | 20 000 € |
| Infrastructure | 5 % | 12 500 € |
| Divers & buffer | 7 % | 17 500 € |

### 28.4 Runway

Avec 250 000 € et un burn rate de 23 550 €/mois (M6) :
- **Runway : ~10 mois** (jusqu'à M10)
- Objectif levée seed avant M8 (selon traction de Lyon)
- Seuil d'alerte : si < 3 mois de runway sans engagement investisseur → pivot vers revenue-first (accélérer Pro B2B)

---

## ANNEXE A — GLOSSAIRE

| Terme | Définition |
|-------|-----------|
| Activité | Session sportive publiée sur la carte |
| Match | Activité avec au moins un participant accepté |
| Invité | Utilisateur profil minimal |
| Membre | Utilisateur profil complet vérifié |
| Trust Score | Score de confiance comportemental |
| North Star | Matchs sportifs complétés / semaine |
| Isochrone | Zone accessible en un temps selon un mode de transport |
| MAU | Monthly Active Users |
| ARPU | Average Revenue Per User |
| CAC | Customer Acquisition Cost |
| MRR | Monthly Recurring Revenue |
| DPIA | Data Protection Impact Assessment (Art. 35 RGPD) |
| DPO | Data Protection Officer |

## ANNEXE B — CONTRAINTES TECHNIQUES

1. WebSocket > 10K connexions → Redis Cluster
2. PostGIS > 500K activités → partitionnement par date
3. Mapbox > 10K MAU → migration MapLibre (économie ~1 500 USD/mois)
4. RGPD suppression : `sender_id` → NULL, nom → "Utilisateur supprimé"
5. APNs : certificats `.p8` (pas `.p12`)

---

*Document version 2.1 — Corrections post-review Expert-UX + Expert-Business + Expert-Security*
*Date : 29 mai 2026*
*Prochaine étape : Resoumission simultanée aux 3 experts pour validation*
