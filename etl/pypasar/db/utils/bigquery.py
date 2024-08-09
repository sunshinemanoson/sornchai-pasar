from sqlalchemy import *
from sqlalchemy.engine import create_engine
from sqlalchemy.schema import *


class bigquery:
    def __init__(self) -> None:
        pass
        # provide credentials as a Python dictionary
        # credentials_info = {
        #     "type": "service_account",
        #     "project_id": "your-service-account-project-id"
        # },
        # engine = create_engine('bigquery://', credentials_info=credentials_info)
        # self.engine = create_engine('bigquery://pasaromop2024')
        # self.table = Table('data_example_ohdsi.pre_op__char',
        #             MetaData(bind=engine), autoload=True)
        # print(select([func.count('*')], from_obj=table().scalar()))

    def create_omop_schema(self) -> None:
        pass

    def populate_omop_tables(self) -> None:
        pass

    def drop_omop_schema(self) -> None:
        pass
