from services.dbService import DBService
from models.questionMatherAnswer import QuestionMatherAnswer

db_service = DBService()


class QuestionMatcher:
    def __init__(self):
        self.query = '''
            SELECT *, similarity(m.key_words, '{question}') AS rank
            FROM public.answer_map m
            WHERE m.key_words %% '{question}'
            ORDER BY rank DESC limit 1;
        '''
        # additional % for working in pandas

    def match(self, question: str) -> QuestionMatherAnswer | None:
        df = db_service.run_query_pandas(self.query.format(question=question))

        if not df.empty:
            return QuestionMatherAnswer(question, df['prompt'][0], df['filter'][0], df['query'][0])
        else:
            return None
