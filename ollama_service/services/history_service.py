import json

from flask import jsonify

from services.dbService import DBService

db_service = DBService()


class HistoryService:

    def __init__(self):
        self.get_history_sql = """
            select * from (
	            select ch.id as id, ch.history as history, ch.created_at as created_at,
	            trunc((EXTRACT(EPOCH FROM (now() - ch.created_at ))/60)) AS diff_minutes
	            from public.chat_history ch
	            order by ch.created_at desc
            ) as res 
            where res.diff_minutes < 30
            order by res.created_at desc
            limit 1
        """

        self.insert_history_sql = """
            insert into public.chat_history  (history)
            values ('{json}')
        """

        self.update_history_sql = """
            update public.chat_history
            set history = '{json}', created_at = now()
            where id = {id}
        """

        self.delete_history_sql = """
            delete from public.chat_history
        """

    def get_history(self) -> str | None:
        df = db_service.run_query_pandas(self.get_history_sql)

        if not df.empty:
            row = df.iloc[0]

            return row.to_json()
        else:
            return None

    def update_history(self, json_data):
        current_history = self.get_history()

        js = str(json_data).replace("'", '"')
        if current_history is not None:
            current_history = json.loads(current_history)
            db_service.run_query_without_result(self.update_history_sql.format(json=js, id=current_history['id']))
        else:
            db_service.run_query_without_result(self.insert_history_sql.format(json=js))

    def delete_history(self):
        db_service.run_query_without_result(self.delete_history_sql)
