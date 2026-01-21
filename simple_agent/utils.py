import re


def extract_sql_from_response(response_text: str) -> str:
    """
    从模型返回的文本中提取 SQL 语句。
    支持 Markdown 代码块、特定关键字前缀等多种格式。
    """
    if not response_text:
        return ""

    text = response_text.strip()

    # 策略 1: 匹配 Markdown ```sql ... ``` 代码块 (最优先)
    # re.DOTALL 让 . 匹配换行符
    pattern_sql_block = re.compile(r"```sql\s*(.*?)```", re.IGNORECASE | re.DOTALL)
    match = pattern_sql_block.search(text)
    if match:
        return clean_sql(match.group(1))

    # 策略 2: 匹配通用的 Markdown ``` ... ``` 代码块
    pattern_generic_block = re.compile(r"```\s*(.*?)```", re.DOTALL)
    match = pattern_generic_block.search(text)
    if match:
        return clean_sql(match.group(1))

    # 策略 3: 如果没有代码块，尝试直接寻找 SELECT 开头的内容
    # 假设 SQL 是从 SELECT 开始直到结尾或分号
    pattern_select = re.compile(r"(SELECT\s.*)", re.IGNORECASE | re.DOTALL)
    match = pattern_select.search(text)
    if match:
        # 截取到第一个分号，或者到字符串结束
        sql_part = match.group(1)
        if ";" in sql_part:
            sql_part = sql_part.split(";")[0]
        return clean_sql(sql_part)

    # 策略 4: 兜底，假设整个文本就是 SQL (经过清洗)
    return clean_sql(text)


def clean_sql(sql: str) -> str:
    """
    清洗 SQL：去除多余空白、分号、不可见字符
    """
    if not sql:
        return ""

    # 去除首尾空白
    sql = sql.strip()

    # 去除末尾的分号
    if sql.endswith(";"):
        sql = sql[:-1]

    # 将连续的空白字符替换为单个空格 (可选，视情况而定，这里保留换行可能更易读，但为了执行安全通常压缩)
    # sql = re.sub(r'\s+', ' ', sql)

    return sql.strip()