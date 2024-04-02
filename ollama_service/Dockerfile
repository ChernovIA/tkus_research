FROM python:3.12
WORKDIR /src

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

ENV SERVER_IP="10.11.15.67"
ENV OLLAMA_PORT="11434"
ENV POSTGRES_PORT="5432"
ENV POSTGRES_USER="postgres"
ENV POSTGRES_PASSWORD="password"
ENV POSTGRES_DATABASE="analytics"

CMD ["python", "app.py"]

EXPOSE 4443
