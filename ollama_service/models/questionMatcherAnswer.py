class QuestionMatcherAnswer:
    def __init__(self, id, question, promt, filter, query, context):
        self.id = id
        self.question = question
        self.promt = promt
        self.filter = filter
        self.query = query
        self.context = context