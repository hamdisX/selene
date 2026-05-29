# Séléné — CLAUDE.md

## Projet
Application mobile cross-platform de mise en relation sportive locale.
Géolocalisation, carte interactive, matching sportif.
iOS + Android (React Native ou Flutter — à définir par les Architects).

## Objectif de cette session
Produire un cahier des charges complet niveau dossier incubateur/investisseur.
Rédaction en français. Qualité professionnelle exploitable immédiatement.

## Versioning obligatoire
Avant chaque modification suite à un review d'agent :
- Sauvegarder la version actuelle dans docs/
- Format : docs/selene-cdc-v{N}-{etape}.md
  Exemple :
  docs/selene-cdc-v1-initial.md
  docs/selene-cdc-v2-post-architects.md
  docs/selene-cdc-v3-post-experts.md
  docs/selene-cdc-v4-final.md

## Workflow multi-agents
Phase 1 : Main produit v1 → sauvegarde v1
          → Architect-Tech-1 + Architect-Tech-2 en parallèle
          → débat jusqu'à consensus à 3
          → sauvegarde v2

Phase 2 : → Expert-UX + Expert-Business + Expert-Security en parallèle
          → va-et-vient jusqu'aux 3 OK simultanés
          → sauvegarde v3

Phase 3 : → Expert-Pro validation finale
          → EXPERT_PRO_OK → sauvegarde v4-final
          → REFUSÉ → retour phase concernée

## Règle de rebouclage
Toute correction appliquée suite au feedback d'un agent
→ renvoyer aux agents concernés pour recheck
→ commit uniquement quand tous les OK sont obtenus :
  Phase 1 : ARCHITECT_TECH1_OK + ARCHITECT_TECH2_OK
  Phase 2 : EXPERT_UX_OK + EXPERT_BUSINESS_OK + EXPERT_SECURITY_OK
  Phase 3 : EXPERT_PRO_OK

## Agents actifs
- architect-tech-1  → backend, DB, temps réel, géoloc
- architect-tech-2  → mobile, Maps, push notifs, frontend
- expert-ux         → parcours, écrans, UX mobile
- expert-business   → modèle éco, roadmap, monétisation
- expert-security   → RGPD, modération, anti-fake
- expert-pro        → validation finale globale

## Langue
Tout le cahier des charges est rédigé en français.
Les agents communiquent en français.