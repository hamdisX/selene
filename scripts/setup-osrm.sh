#!/bin/bash
# Télécharge et prépare les données de routage OSRM (une seule fois)
# Usage: bash scripts/setup-osrm.sh [region]
# Exemple: bash scripts/setup-osrm.sh ile-de-france (défaut)

set -e

REGION="${1:-ile-de-france}"
DATA_DIR="./osrm_data"
OSM_FILE="${DATA_DIR}/${REGION}.osm.pbf"
GEOFABRIK_URL="https://download.geofabrik.de/europe/france/${REGION}-latest.osm.pbf"

echo "=== Setup OSRM pour la région : ${REGION} ==="

mkdir -p "${DATA_DIR}"

if [ -f "${OSM_FILE}" ]; then
  echo "Fichier OSM déjà présent : ${OSM_FILE}"
else
  echo "Téléchargement des données OSM depuis Geofabrik..."
  wget -O "${OSM_FILE}" "${GEOFABRIK_URL}"
  echo "Téléchargement terminé."
fi

echo "Extraction OSRM (profil voiture)..."
docker run -t --rm -v "$(pwd)/${DATA_DIR}:/data" \
  osrm/osrm-backend:v5.27.1 osrm-extract -p /opt/car.lua "/data/${REGION}.osm.pbf"

echo "Partitionnement OSRM..."
docker run -t --rm -v "$(pwd)/${DATA_DIR}:/data" \
  osrm/osrm-backend:v5.27.1 osrm-partition "/data/${REGION}.osrm"

echo "Customisation OSRM..."
docker run -t --rm -v "$(pwd)/${DATA_DIR}:/data" \
  osrm/osrm-backend:v5.27.1 osrm-customize "/data/${REGION}.osrm"

echo "Création du lien symbolique map.osrm..."
cd "${DATA_DIR}" && ln -sf "${REGION}.osrm" map.osrm && cd ..

echo ""
echo "=== OSRM prêt ==="
echo "Démarrez le service avec : docker compose --profile routing up osrm"
