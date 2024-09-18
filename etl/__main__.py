import os
import sys
import traceback
from dotenv import load_dotenv
from importlib import import_module
from pypasar.db.utils import postgres

# Load environment variables from the .env file
load_dotenv()


def select_db_dialect(db_dialect):
    db = None
    if db_dialect == "POSTGRES":
        db = postgres.postgres("pypasar/db/sql/postgres")
        print("Selected POSTGRES Dialect")
    else:
        print("Db Dialect must be Postgres")
    return db


def db(option):
    db_dialect = os.getenv("DB_DIALECT")
    db = select_db_dialect(db_dialect)
    if db is not None:
        if option == "create_omop_schema":
            db.create_omop_schema()
        elif option == "drop_omop_schema":
            db.drop_omop_schema()
        else:
            print(
                "Db argument must be either create_omop_schema or drop_omop_schema")


def etl(tables):

    omop_entities_to_ingest = None

    if tables is not None:
        omop_entities_to_ingest = [table.strip()
                                   for table in tables.split(',')]
    else:
        # Ingestion will proceed in the order defined wherein dependencies will be populated first
        omop_entities_to_ingest = [
            'cdm_source',  # Required for OHDSI R Packages like data quality to run
            'concept',
            'location',
            'provider',
            'care_site',
            'person',
            'observation_period',
            'death',
            'visit_occurrence',
            'visit_detail',
            'condition_occurrence',
            'condition_era',
            'drug_exposure',
            'drug_era',
            'procedure_occurrence',
            'device_exposure',
            'measurement',
            'observation',
            'note',
            'specimen',
            'payer_plan_period',
            'cost'
        ]

    print(f"OMOP tables to be executed: {omop_entities_to_ingest}")

    # Start ETL for OMOP Tables
    try:
        for omop_entity in omop_entities_to_ingest:
            print(f"Import {omop_entity}..")
            omop_module = import_module(f'pypasar.omop.{omop_entity}')
            omop_class = getattr(omop_module, omop_entity)()
            print(f"Begin execution for {omop_entity}..")
            omop_class.execute()
            print(f"Completed execution for {omop_entity}..")
            print()
    except Exception as err:
        raise err


# Entrypoint
try:
    entrypoint = sys.argv[1]
    if entrypoint == "db":
        options = None if len(sys.argv) <= 2 else sys.argv[2]
        db(options)
    elif entrypoint == "etl":
        tables = None if len(sys.argv) <= 2 else sys.argv[2]
        etl(tables)
    else:
        print("Entrypoint must be either db or etl")
except Exception as err:
    traceback.print_exc()
