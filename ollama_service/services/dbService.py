import pandas as pd

from typing import Any, Sequence

from sqlalchemy import create_engine, text, Row

from pref.envHolder import EnvHolder

envHolder = EnvHolder()


def logs(func):
    def wrapper(*args, **kwargs):
        print(f"LOG: calling {func.__name__}() from {args[0]}")
        print(f"QUERY: {args[1]}")

        result = func(*args, **kwargs)
        print(f"LOG: {func.__name__}()  RETURNED -> ")
        print(f"{result}")
        return result

    return wrapper


class DBService:
    def __init__(self):
        self.engine = create_engine(
            f"postgresql+psycopg2://{envHolder.postgres_user}:{envHolder.postgres_password}@{envHolder.server_ip}:{envHolder.postgres_port}/{envHolder.postgres_database}")

    @logs
    def run_query(self, query) -> Sequence[Row[Any]]:
        with self.engine.connect() as conn:
            res = conn.execute(text(query))
            return res.fetchall()

    @logs
    def run_query_pandas(self, query):  # additional % for working in pandas
        query = query.replace("%", "%%")

        df = pd.read_sql_query(query, self.engine)
        return df
