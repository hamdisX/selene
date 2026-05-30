# ─── Séléné — Commandes de développement ─────────────────────────────────
# Usage : make <cible>

.PHONY: help up down logs ps build clean setup-osrm migrate

help: ## Affiche cette aide
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ─── Docker ───────────────────────────────────────────────────────────────

up: .env ## Démarre tous les services (sans OSRM)
	docker compose up -d

up-routing: .env setup-osrm ## Démarre tous les services avec OSRM
	docker compose --profile routing up -d

down: ## Arrête tous les services
	docker compose down

logs: ## Affiche les logs du backend
	docker compose logs -f backend

ps: ## Affiche l'état des services
	docker compose ps

build: ## Rebuild l'image backend
	docker compose build backend

clean: ## Supprime les containers, volumes et images du projet
	docker compose down -v --rmi local

# ─── OSRM ─────────────────────────────────────────────────────────────────

setup-osrm: ## Télécharge et prépare les données OSRM (région par défaut : ile-de-france)
	@mkdir -p osrm_data
	@bash scripts/setup-osrm.sh $(REGION)

# ─── Base de données ──────────────────────────────────────────────────────

migrate: ## Exécute les migrations TypeORM dans le container backend
	docker compose exec backend npm run migration:run

migrate-revert: ## Annule la dernière migration TypeORM
	docker compose exec backend npm run migration:revert

# ─── Initialisation ───────────────────────────────────────────────────────

.env: .env.example ## Crée .env depuis .env.example si absent
	@echo "Fichier .env absent — copie depuis .env.example"
	@cp .env.example .env
	@echo "IMPORTANT : éditez .env et remplacez les valeurs CHANGE_ME avant de continuer."
	@exit 1
