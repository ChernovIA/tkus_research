from services.dbService import DBService
from models.questionMatcherAnswer import QuestionMatcherAnswer

db_service = DBService()


class QuestionMatcher:
    def __init__(self):
        self.query = '''
            select * from (
	            SELECT *, similarity(m.key_words, '{question}') AS "rank"
	            FROM public.answer_map m
            ) as sel
            where sel.rank > 0.06
            order by sel.rank desc
            limit 1;
        '''

        self.context_query = """
            select * from answer_map m 
            where context_requared and context = '{context}'
        """

        self.context_query_default = """
                    select * from answer_map m 
                    where context_requared
                """

    def match(self, question: str, context: str) -> QuestionMatcherAnswer | None:
        question = question.replace("'", "")

        df = db_service.run_query_pandas(self.query.format(question=question))

        if not df.empty:
            df = self.check_context_question(df, context)

        if not df.empty:
            result = df.iloc[0]

            sql_query_for_filter = str(result['filter'])

            if len(sql_query_for_filter):
                filter_words = db_service.run_query_pandas(sql_query_for_filter)['value'].tolist()
                filtered = [s for s in filter_words if s.lower() in question.lower()]
            else:
                filtered = None

            return QuestionMatcherAnswer(result['id'], question, result['prompt'], filtered, result['query'],
                                         result['context'])
        else:
            return None

    def check_context_question(self, df, context):
        result = df.iloc[0]

        if result['context_requared'] and context is not None:
            return db_service.run_query_pandas(self.context_query.format(context=context))
        elif result['context_requared']:
            return db_service.run_query_pandas(self.context_query_default)
        else:
            return df
