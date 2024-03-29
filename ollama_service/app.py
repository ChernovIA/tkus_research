import requests
from flask import Flask, request, jsonify
from flask_cors import cross_origin
import json


from service.langChainService import LangChainService

app = Flask(__name__)
lc_service = LangChainService()


@app.route("/", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def process_request():
    headers = {'Content-type': 'application/json; charset=UTF-8'}
    # ollama_req = requests.post("http://10.11.15.67:11434/api/generate", headers=headers, data=request.data)
    # return jsonify(ollama_req.json()['response'])
    json_obj = json.loads(request.data.decode())

    answer = lc_service.generate(json_obj['prompt'])

    return jsonify(answer)


if __name__ == "__main__":
    # app.run(port=4443, host='0.0.0.0', ssl_context=('cert.pem', 'key.pem'))
    app.run(port=4443)
