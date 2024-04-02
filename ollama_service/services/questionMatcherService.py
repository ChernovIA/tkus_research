from services.dbService import DBService
from models.questionMatherAnswer import QuestionMatherAnswer

db_service = DBService()


class QuestionMatcher:
    def __init__(self):
        self.query = '''
            SELECT *, similarity(m.key_words, '{question}') AS rank
            FROM public.answer_map m
            WHERE m.key_words % '{question}'
            ORDER BY rank DESC limit 1;
        '''


    def match(self, question: str) -> QuestionMatherAnswer | None:
        df = db_service.run_query_pandas(self.query.format(question=question))

        if not df.empty:
            result = df.iloc[0]
            sql_query_for_filter = result['filter']
            filter_words = db_service.run_query_pandas(sql_query_for_filter)['value'].tolist()

            filtered = [s for s in filter_words if s in question]

            return QuestionMatherAnswer(result['id'], question, result['prompt'], [filtered, filter_words], result['query'])
        else:
            return None
