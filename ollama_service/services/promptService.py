from decimal import Decimal
from typing import Sequence, Any

from langchain_core.prompts import ChatPromptTemplate

from sqlalchemy import Row

from services.dbService import DBService

db_service = DBService()

SYSTEM_MESSAGE = "Given an input question and SQL response, convert it to a natural language answer. No pre-amble."


def process_q1(result: Sequence[Row[Any]]):
    db_context = f"Average amount is {result[0][0].quantize(Decimal('1.00'))}"
    return db_context


def process_q2(result: Sequence[Row[Any]]):
    db_context = result
    return db_context


class PromptService:
    def __init__(self):
        self.process_map = {
            0: process_q1,
            1: process_q2
        }

    def obtain_prompt(self, id: int, query: str, query_filter: str):
        sql_query = query.format(f"'{','.join(query_filter)}'")
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