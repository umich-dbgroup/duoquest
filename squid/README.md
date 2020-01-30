# SQuID Baseline Comparison

This folder includes information for the simulation study with the SQuID system. Only the development set for Spider is included, please contact the authors of the Spider benchmark directly if you seek access to the test set.

## Running SQuID Comparison

1. Clone the forked version of [SQuID repository](https://github.com/chrisjbaik/squid-public).
2. Compile the SQuID code and point `squid.py` in the parent directory of this repository to the appropriate `CLASSPATH`.
3. Modify hard-coded `SCHEMA_DIR` (to the `/squid/schema` subdirectory of this repository) and `DATA_DIR` (to the `/squid/data` subdirectory of this repository) in `/src/util/DBUtil.java` in SQuID implementation.
4. Run `python squid.py` with the appropriate arguments in the main repository (parent of this folder).

## Adding New Schemas

There is **no need to do this** because it has already done and all relevant information is stored in the `/squid/schema/` folder, but if you ever need to add a new database, these are the steps. Note that some steps may not be needed if the database already exists in PostgreSQL, this is for migration from a SQLite database.

1. Download [pgloader](https://pgloader.readthedocs.io/en/latest/#).
2. Add any schema modifications that need to be executed to the PostgreSQL database after loading it into PostgreSQL, but before dumping the schema into a file named `/squid/schema/preload/<db_name>.sql`.
3. Add all metadata (fact/dimension information) for database into `/squid/schema/meta/<db_name>.json`.
4. Modify `load_spider_dev_postgres` variables as needed.
5. Run `./load_spider_dev_postgres`.
