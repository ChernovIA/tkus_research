import os

from langchain_core.prompt_values import PromptValue
from langchain_experimental.sql import SQLDatabaseChain
from langchain_community.agent_toolkits.sql.base import create_sql_agent
from langchain_community.llms import Ollama
from langchain_community.utilities import SQLDatabase
from langchain.prompts.chat import HumanMessagePromptTemplate
from langchain.schema import HumanMessage, SystemMessage
from langchain_core.prompts import ChatPromptTemplate


SERVER_IP = os.getenv("SERVER_IP")
OLLAMA_PORT = os.getenv("OLLAMA_PORT")
POSTGRES_PORT = os.getenv("POSTGRES_PORT")
POSTGRES_USER = os.getenv("POSTGRES_USER")
POSTGRES_PASSWORD = os.getenv("POSTGRES_PASSWORD")
POSTGRES_DATABASE = os.getenv("POSTGRES_DATABASE")


class LangChainService:
    def __init__(self):
        ollama_base_url = f'http://{SERVER_IP}:{OLLAMA_PORT}'

        self.ollama = Ollama(base_url=ollama_base_url, model="llama2:7b-chat-q4_0")
        self.db = SQLDatabase.from_uri(
            f"postgresql+psycopg2://{POSTGRES_USER}:{POSTGRES_PASSWORD}@{SERVER_IP}:{POSTGRES_PORT}/{POSTGRES_DATABASE}",
            include_tables=['commercial_payment'], sample_rows_in_table_info=0, max_string_length=10000)
        self.db_chain = SQLDatabaseChain.from_llm(self.ollama, self.db, verbose=True, return_direct=True)

    def retrieve_from_db(self, query: str) -> str:
        db_context = self.db_chain(query)
        db_context = db_context['result'].strip()
        return db_context

    def generate(self, query: str) -> PromptValue:
        db_context = self.retrieve_from_db(query)
        system_message = """Given an input question and SQL response, convert it to a natural language answer. No pre-amble.
        """
        human_qry_template = """
            Input:
            {input}
            
            Context from database:
            {db_context}
            """
        messages = [
            ("system", system_message),
            ("human", human_qry_template),
        ]
        prompt_template = ChatPromptTemplate.from_messages(messages)

        chain = prompt_template | self.ollama
        result = chain.invoke({"input": query, "db_context": db_context})
        return result
