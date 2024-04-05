from decimal import Decimal
from typing import Sequence, Any

from langchain_core.prompts import ChatPromptTemplate

from sqlalchemy import Row

from services.dbService import DBService

db_service = DBService()

SYSTEM_MESSAGE = ("""Given an input question and SQL response, convert it to a natural language answer. No pre-amble.
Do not use smiles. Do not use emoji.Do not use special characters.
Do not say 'here is a natural language answer\n""")


def process_q0(result: Sequence[Row[Any]]):
    db_context = f"Average amount is ${round(result[0][0]):_}"
    return db_context, SYSTEM_MESSAGE


def process_q1(result: Sequence[Row[Any]]):
    db_context = f"Variance for {result[0][0]} is {round(result[0][1],1)}%"
    db_context += f"Variance for {result[1][0]} is {round(result[1][1],1)}%"
    return db_context, SYSTEM_MESSAGE


def process_q2(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += f"{row[0]} had {round(row[1],1)}%\n"
    return db_context, SYSTEM_MESSAGE + "Compare object in query with all other"


def process_q5(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += f"Prior day deposits in {row[0]} are {round(row[1],1)}% which has a value ${round(row[2],2):_} \n"
    return db_context, SYSTEM_MESSAGE + ("Compare object in query with all other. Highlight the highest values and the "
                                         "lower values")


def process_q6(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += (f"Total deposits collected would be ${round(row[0],2)} which is {round(row[1], 1)}% of the goal "
                       f"achieved.\n")
    return db_context, SYSTEM_MESSAGE


def process_q7(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += f"${round(row[1],2)}"
    return db_context, SYSTEM_MESSAGE + ("Example: Two amounts were higher than average amount of deposits in Lockbox 3"
                                         " $33,056 and $63,056")


def process_q8(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += f"${round(row[0],0)}%"
    return db_context, SYSTEM_MESSAGE


def process_q9(result: Sequence[Row[Any]]):
    db_context = ""
    for row in result:
        db_context += f"${row[0]} its goal by {round(row[2],1)}%"
    return db_context, SYSTEM_MESSAGE + """ Example: BCBS is significantly below its goal by 38.4%.
                                                    UnitedHealth has exceeded its goal by 24.8%.
                                                    Aetna is slightly below its goal by 1.8%.
                                                    Cigna is below its goal by 7.8%.
                                                    Humana has slightly exceeded its goal by 0.7%.
                                                    Other payers have exceeded their goal by 6.2%."""


class PromptService:
    def __init__(self):
        self.process_map = {
            0: process_q0,
            1: process_q1,
            2: process_q2,
            3: process_q2,
            4: process_q2,
            5: process_q5,
            6: process_q6,
            7: process_q7,
            8: process_q8,
            9: process_q9
        }

    def obtain_prompt(self, row_id: int, query: str, query_filter: str | None):
        if query_filter is not None:
            if len(query_filter):
                sql_query = query.format(f"'{','.join(query_filter)}'")
            else:
                return self.obtain_default_prompt()
        else:
            sql_query = query
        result = db_service.run_query(sql_query)
        db_context, system_message = self.process_map[row_id](result)

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

    @staticmethod
    def obtain_default_prompt():
        system_message = """No matte what user ask you say that you do not understand question, " Use formal english. 
        Do not use smiles. Do not use emoji. Do not use special characters. Answer shortly. Example: I'm sorry, 
        I'm not sure I understand your question. Could you please provide more context or rephrase it in a different 
        way?"""
        human_qry_template = """
            Input:
            {input}"""
        messages = [
            ("system", system_message),
            ("human", human_qry_template)
        ]
        return ChatPromptTemplate.from_messages(messages)
