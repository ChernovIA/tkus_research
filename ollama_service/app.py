import os

from flask import Flask, request, jsonify, session
from flask_cors import cross_origin
import json

from services.ollamaService import OllamaService
from services.questionMatcherService import QuestionMatcher

app = Flask(__name__)
app.secret_key = os.urandom(24)
lc_service = OllamaService()
questionMatcher = QuestionMatcher()


@app.route("/", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def process_request():
    if 'context' not in session:
        session['context'] = None

    json_obj = json.loads(request.data.decode())

    answer_prompt = questionMatcher.match(json_obj['prompt'], session['context'])

    if answer_prompt is not None:
        session['context'] = answer_prompt.context
        answer = lc_service.generate(answer_prompt)
        return jsonify(answer)
    else:
        session['context'] = None
        answer = lc_service.generate_random(json_obj['prompt'])
        return jsonify(answer)


if __name__ == "__main__":
    app.run(port=4443, host='0.0.0.0')
