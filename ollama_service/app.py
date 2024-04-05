import os
import uuid

from flask import Flask, request, jsonify, session, abort
from flask_cors import cross_origin
import json

from services.history_service import HistoryService
from services.ollamaService import OllamaService
from services.questionMatcherService import QuestionMatcher

app = Flask(__name__)
app.secret_key = os.urandom(24)
lc_service = OllamaService()
questionMatcher = QuestionMatcher()
historyService = HistoryService()

CONTEXT = 'context'


@app.route("/", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def process_request():
    if CONTEXT not in session:
        session[CONTEXT] = None

    json_obj = json.loads(request.data.decode())

    answer_prompt = questionMatcher.match(json_obj['prompt'], session[CONTEXT])

    if answer_prompt is not None:
        session[CONTEXT] = answer_prompt.context
        answer = lc_service.generate(answer_prompt)
        return jsonify(answer)
    else:
        session[CONTEXT] = None
        answer = lc_service.generate_random(json_obj['prompt'])
        return jsonify(answer)


@app.route("/history", methods=['GET', 'OPTIONS'])
@cross_origin(origins='*')
def get_history():
    res = historyService.get_history()

    if res is not None:
        return res
    else:
        abort(404)


@app.route("/history", methods=['POST', 'OPTIONS'])
@cross_origin(origins='*')
def save_history():
    json_obj = json.loads(request.data.decode())
    historyService.update_history(json_obj['history'])
    return jsonify(status=200)


@app.route("/history", methods=['DELETE', 'OPTIONS'])
@cross_origin(origins='*')
def delete_history():
    historyService.delete_history()
    return jsonify(status=200)


if __name__ == "__main__":
    app.run(port=4443, host='0.0.0.0')
