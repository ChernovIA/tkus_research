import requests
from flask import Flask, request, jsonify
from flask_cors import cross_origin
import json


from service.ollamaService import OllamaService

app = Flask(__name__)
lc_service = OllamaService()


@app.route("/", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def process_request():
    json_obj = json.loads(request.data.decode())

    answer = lc_service.generate(json_obj['prompt'])

    return jsonify(answer)


if __name__ == "__main__":
    # app.run(port=4443, host='0.0.0.0', ssl_context=('cert.pem', 'key.pem'))
    app.run(port=4443)
