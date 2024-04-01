from typing import Sequence, Any

from langchain_core.prompts import ChatPromptTemplate

from dbService import DBService
from sqlalchemy import Row

db_service = DBService()


def process_q1(prompt: str, result: Sequence[Row[Any]]):
    system_message = """Given an input question and SQL response, convert it to a natural language answer. No pre-amble.
    """

    # TODO for each question, get the answer from the database and parse it
    db_context = result
    human_qry_template = """
        Input:
        {input}
        
        Context from database:
        """
    messages = [
        ("system", system_message),
        ("human", human_qry_template + db_context)
    ]
    return ChatPromptTemplate.from_messages(messages)


def process_q2(prompt: str, result: Sequence[Row[Any]]):
    system_message = """Given an input question and SQL response, convert it to a natural language answer. No pre-amble.
    """

    # TODO for each question, get the answer from the database and parse it
    db_context = result
    human_qry_template = """
        Input:
        {input}
        
        Context from database:
        """
    messages = [
        ("system", system_message),
        ("human", human_qry_template + db_context)
    ]
    return ChatPromptTemplate.from_messages(messages)


class PromptService:
    def __init__(self):
        self.process_map = {
            1: process_q1,
            2: process_q2
        }

    def obtain_prompt(self, id: int, query: str, query_filter: str, prompt: str):
        sql_query = query.format("filter", query_filter)
        result = db_service.run_query(sql_query)
        return self.process_map[id](result, prompt)
