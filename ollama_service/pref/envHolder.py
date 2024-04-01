import os


class EnvHolder:
    def __init__(self):
        self.server_ip = os.getenv("SERVER_IP")
        self.ollama_port = os.getenv("OLLAMA_PORT")
        self.postgres_port = os.getenv("POSTGRES_PORT")
        self.postgres_user = os.getenv("POSTGRES_USER")
        self.postgres_password = os.getenv("POSTGRES_PASSWORD")
        self.postgres_database = os.getenv("POSTGRES_DATABASE")
