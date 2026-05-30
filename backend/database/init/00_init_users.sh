#!/bin/bash
# Création des rôles PostgreSQL avec mots de passe depuis variables d'environnement
# Exécuté avant 01_setup.sql par PostgreSQL au premier démarrage

set -e

# Valider que les mots de passe requis sont définis
if [ -z "${DB_MIGRATE_PASSWORD}" ]; then
  echo "ERREUR : DB_MIGRATE_PASSWORD non défini" >&2; exit 1
fi
if [ -z "${DB_READONLY_PASSWORD}" ]; then
  echo "ERREUR : DB_READONLY_PASSWORD non défini" >&2; exit 1
fi

# Échapper les apostrophes (SQL injection prevention : ' → '')
MIGRATE_PWD_SAFE=$(printf '%s' "${DB_MIGRATE_PASSWORD}" | sed "s/'/''/g")
READONLY_PWD_SAFE=$(printf '%s' "${DB_READONLY_PASSWORD}" | sed "s/'/''/g")

psql -v ON_ERROR_STOP=1 \
     --username "$POSTGRES_USER" \
     --dbname "$POSTGRES_DB" <<-EOSQL

  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'selene_migrate') THEN
      CREATE ROLE selene_migrate WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT
        PASSWORD '${MIGRATE_PWD_SAFE}';
    ELSE
      ALTER ROLE selene_migrate WITH PASSWORD '${MIGRATE_PWD_SAFE}';
    END IF;
  END
  \$\$;

  DO \$\$
  BEGIN
    IF NOT EXISTS (SELECT FROM pg_catalog.pg_roles WHERE rolname = 'selene_readonly') THEN
      CREATE ROLE selene_readonly WITH LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT
        PASSWORD '${READONLY_PWD_SAFE}';
    ELSE
      ALTER ROLE selene_readonly WITH PASSWORD '${READONLY_PWD_SAFE}';
    END IF;
  END
  \$\$;
EOSQL

echo "Rôles PostgreSQL initialisés."
