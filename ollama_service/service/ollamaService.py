

from langchain_core.prompt_values import PromptValue
from langchain_community.llms import Ollama


from ollama_service.pref.envHolder import EnvHolder
from promptService import PromptService

envHolder = EnvHolder()
promptService = PromptService()


class OllamaService:
    def __init__(self):
        ollama_base_url = f'http://{envHolder.server_ip}:{envHolder.ollama_port}'
        self.ollama = Ollama(base_url=ollama_base_url, model="llama2:7b-chat-q4_0")

    def generate(self, human_query: str, id: int, query: str, query_filter: str, prompt: str) -> PromptValue:
        prompt_template = promptService.obtain_prompt(id, query, query_filter, prompt)

        chain = prompt_template | self.ollama
        result = chain.invoke({"input": human_query})
        return result
