

from langchain_core.prompt_values import PromptValue
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

    def generate(self, payload: QuestionMatherAnswer) -> PromptValue:
        prompt_template = promptService.obtain_prompt(payload.id, payload.query, payload.filter)

        chain = prompt_template | self.ollama
        result = chain.invoke({"input": payload.question})
        return result
