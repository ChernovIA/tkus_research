from flask import Flask, request, jsonify
from flask_cors import cross_origin
import json

from services.ollamaService import OllamaService
from services.questionMatcherService import QuestionMatcher

app = Flask(__name__)
lc_service = OllamaService()
questionMatcher = QuestionMatcher()


@app.route("/", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def process_request():
    json_obj = json.loads(request.data.decode())

    answer_prompt = questionMatcher.match(json_obj['prompt'])

    if answer_prompt is not None:
        answer = lc_service.generate(answer_prompt)
        return jsonify(answer)
    else:
        answer = lc_service.generate_random(json_obj['prompt'])
        return jsonify(answer)


if __name__ == "__main__":
    app.run(port=4443, host='0.0.0.0')
