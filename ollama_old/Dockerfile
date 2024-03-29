FROM python:3.12
WORKDIR /src

COPY requirements.txt requirements.txt
RUN pip3 install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "service_flask.py"]

EXPOSE 4443
