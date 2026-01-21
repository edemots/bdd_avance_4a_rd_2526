# Base de Données avancé

## Démarrage

```sh
# Démarrer le serveur PostgreSQL
docker compose up -d

# Se connecter à la BDD en ligne de commande
docker compose exec -it db bash
psql -U postgres
# ou
docker compose exec -it db psql -U postgres
```

```sh
# Seeder la base de données avec le schéma et les données par défaut
\i database/seed.sql
```

## Utilisation

```sh
# Cas d'erreur (oubli du ;)
postgres=# SELECT * FROM ...
postgres-#
```

## Fermeture

```sh
# Quitter psql
\q
```

```sh
# Eteindre le serveur de BDD
docker compose down
```
