from langchain_core.pydantic_v1 import BaseModel, Field


class SqlAnswer(BaseModel):
    question: str = Field(description="Question here")
    sql_to_run: str = Field(description="SQL Query to run")
    sql_result: str = Field(description="Result of the SQLQuery")
    answer: str = Field(description="Final answer here")
