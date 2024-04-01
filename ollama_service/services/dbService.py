import pandas as pd

from typing import Any, Sequence

from sqlalchemy import create_engine, text, Row

from pref.envHolder import EnvHolder

envHolder = EnvHolder()


class DBService:
    def __init__(self):
        self.engine = create_engine(
            f"postgresql+psycopg2://{envHolder.postgres_user}:{envHolder.postgres_password}@{envHolder.server_ip}:{envHolder.postgres_port}/{envHolder.postgres_database}")

    def run_query(self, query) -> Sequence[Row[Any]]:
        with self.engine.connect() as conn:
            res = conn.execute(text(query))
            return res.fetchall()

    def run_query_pandas(self, query):
        print("Query = " + query)
        df = pd.read_sql_query(query, self.engine)
        return df
