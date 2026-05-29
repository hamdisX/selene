# Séléné — Changelog
> Historique des sessions et features terminées.
> Append-only — ne jamais modifier une entrée existante.
> Chargé via @ dans Claude Code pour contexte inter-sessions.

---

## [2026-05-29] — Fondations du projet

### Documents validés
- CDC complet rédigé et validé via workflow multi-agents (6 agents, 4 phases)
  → `docs/selene-cdc-v4-final.md` — EXPERT_PRO_OK ✅
- Décisions techniques rédigées et validées (4 agents)
  → `docs/TECHNICAL_DECISIONS.md` — EXPERT_PRO_OK ✅

### Agents créés
- 6 agents CDC dans `.claude/agents/cdc/`
  (architect-tech-1, architect-tech-2, expert-ux, expert-business, expert-security, expert-pro)
- 8 agents dev dans `.claude/agents/dev/`
  (review-backend, review-mobile, review-database, review-infra, review-security, review-test, review-api, review-pro)

### Fichiers projet
- `README.md` — documentation publique GitHub
- `CLAUDE.md` — mémoire technique projet
- `CHANGELOG.md` — ce fichier

### Nettoyage
- Archives CDC v1/v2/v3 supprimées — seul `selene-cdc-v4-final.md` conservé

---

<!-- TEMPLATE pour les prochaines entrées

## [YYYY-MM-DD] — Sprint N / Feature X

### Ajouté
- Description de ce qui a été créé

### Modifié
- Description de ce qui a été changé

### Validé
- NOM_AGENT_OK ✅ sur fichier/module concerné

### Fichiers impactés
- `chemin/fichier.ts`

-->