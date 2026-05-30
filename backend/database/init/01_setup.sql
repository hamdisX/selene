-- Initialisation de la base Séléné — extensions et droits
-- Les rôles avec mots de passe sont créés par 00_init_users.sh (avant ce fichier)
--
-- Rôles :
--   selene_app     = POSTGRES_USER (créé par Docker) — DML uniquement, JAMAIS DDL
--   selene_migrate = migrations TypeORM (DDL complet) — job séparé uniquement
--   selene_readonly = analytics / monitoring — SELECT uniquement

-- ─── Extensions ───────────────────────────────────────────────────────────
CREATE EXTENSION IF NOT EXISTS postgis;      -- Géospatial principal (ST_DWithin, GIST)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";  -- Génération UUID côté DB
CREATE EXTENSION IF NOT EXISTS pgcrypto;     -- Hachage (emails, téléphones pour index)
-- postgis_topology retirée : inutile pour points GPS + ST_DWithin (usage Séléné)

-- ─── Révoquer les droits PUBLIC par défaut (moindre privilège) ────────────
REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON DATABASE selene_db FROM PUBLIC;

-- ─── selene_app — DML uniquement (SELECT/INSERT/UPDATE/DELETE) ─────────────
GRANT CONNECT ON DATABASE selene_db TO selene_app;
GRANT USAGE ON SCHEMA public TO selene_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO selene_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO selene_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO selene_app;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO selene_app;

-- ─── selene_migrate — DDL complet (migrations TypeORM uniquement) ──────────
GRANT CONNECT ON DATABASE selene_db TO selene_migrate;
GRANT ALL ON SCHEMA public TO selene_migrate;
ALTER SCHEMA public OWNER TO selene_migrate;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON TABLES TO selene_migrate;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT ALL ON SEQUENCES TO selene_migrate;

-- ─── selene_readonly — SELECT uniquement (analytics, monitoring) ──────────
GRANT CONNECT ON DATABASE selene_db TO selene_readonly;
GRANT USAGE ON SCHEMA public TO selene_readonly;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO selene_readonly;
ALTER DEFAULT PRIVILEGES IN SCHEMA public
  GRANT SELECT ON TABLES TO selene_readonly;
