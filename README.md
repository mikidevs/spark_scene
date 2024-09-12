# spark_scene

[![Package Version](https://img.shields.io/hexpm/v/spark_scene)](https://hex.pm/packages/spark_scene)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/spark_scene/)


## Connect to postgres

```
sudo -u postgres psql -p 5555 -d spark_scene
```

## Run Database Initialiser

```
\i ./scripts/init_db.sql
```

## Generate sql functions

```
gleam run -m squirrel
```

## Run program
```
source .pg_env && gleam run
```