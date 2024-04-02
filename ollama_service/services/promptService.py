from decimal import Decimal
from typing import Sequence, Any

from langchain_core.prompts import ChatPromptTemplate

from sqlalchemy import Row

from services.dbService import DBService

db_service = DBService()

SYSTEM_MESSAGE = "Given an input question and SQL response, convert it to a natural language answer. No pre-amble."


def process_q0(result: Sequence[Row[Any]]):
    db_context = f"Average amount is {result[0][0].quantize(Decimal('1.00'))} $"
    return db_context


def process_q1(result: Sequence[Row[Any]]):
    db_context = f"Variance for {result[0][0]} is {result[0][1]}"
    db_context += f"Variance for {result[1][0]} is {result[1][1]}"
    return db_context


def process_q2(result: Sequence[Row[Any]]):
    db_context = "Compare object in query with all other\n"
    for row in result:
        db_context += f"{row[0]} had {row[1]} %\n"
    return db_context


class PromptService:
    def __init__(self):
        self.process_map = {
            0: process_q0,
            1: process_q1,
            2: process_q2,
            3: process_q2,
            4: process_q2
        }

    def obtain_prompt(self, id: int, query: str, query_filter: str | None):
        if query_filter is not None:
            sql_query = query.format(f"'{','.join(query_filter)}'")
        else:
            sql_query = query
        result = db_service.run_query(sql_query)
        db_context = self.process_map[id](result)

        human_qry_template = """
            Input:
            {input}
            
            Context from database:
            """
        messages = [
            ("system", SYSTEM_MESSAGE),
            ("human", human_qry_template + db_context)
        ]
        return ChatPromptTemplate.from_messages(messages)
