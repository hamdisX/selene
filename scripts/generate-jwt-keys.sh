#!/bin/bash
# Génère la paire de clés RSA pour JWT RS256 (à exécuter une seule fois par environnement)

set -e

KEYS_DIR="./backend/keys"
mkdir -p "${KEYS_DIR}"

echo "Génération de la paire de clés RSA 4096 bits..."
openssl genrsa -out "${KEYS_DIR}/jwt_private.pem" 4096
openssl rsa -in "${KEYS_DIR}/jwt_private.pem" -pubout -out "${KEYS_DIR}/jwt_public.pem"

chmod 600 "${KEYS_DIR}/jwt_private.pem"
chmod 644 "${KEYS_DIR}/jwt_public.pem"

echo "Clés générées dans ${KEYS_DIR}/"
echo "  - jwt_private.pem (NE PAS commiter — déjà dans .gitignore)"
echo "  - jwt_public.pem  (NE PAS commiter — déjà dans .gitignore)"
