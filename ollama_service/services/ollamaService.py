

from langchain_core.prompts import ChatPromptTemplate
from langchain_community.llms import Ollama

from pref.envHolder import EnvHolder
from services.promptService import PromptService

from models.questionMatherAnswer import QuestionMatherAnswer


envHolder = EnvHolder()
promptService = PromptService()


class OllamaService:
    def __init__(self):
        ollama_base_url = f'http://{envHolder.server_ip}:{envHolder.ollama_port}'
        self.ollama = Ollama(base_url=ollama_base_url, model="llama2:7b-chat-q4_0")

    def generate(self, payload: QuestionMatherAnswer) -> str:
        prompt_template = promptService.obtain_prompt(payload.id, payload.query, payload.filter)

        chain = prompt_template | self.ollama
        result = chain.invoke({"input": payload.question})
        return result

    def generate_random(self, question: str) -> str:
        system_message = "You do not understand question, so say joke about this"
        human_qry_template = """
            Input:
            {input}"""
        messages = [
            ("system", system_message),
            ("human", human_qry_template)
        ]
        prompt_template = ChatPromptTemplate.from_messages(messages)
        chain = prompt_template | self.ollama
        result = chain.invoke({"input": question})
        return result
