import os
import json
import sqlite3
import re
import sys
import time
import zipfile
from concurrent.futures import ThreadPoolExecutor, as_completed
from typing import List, Dict, Tuple, Optional

# 引入 SQL 提取工具
try:
    from utils import extract_sql_from_response
except ImportError:
    print("Error: 'utils.py' not found. Please save the provided utils code as utils.py.")
    sys.exit(1)

# 引入 OpenAI
try:
    from openai import OpenAI
except ImportError:
    print("Error: 'openai' library not found. Please install it via 'pip install openai'.")
    sys.exit(1)

# 引入比对器
try:
    from comparator import Evaluator
except ImportError:
    print("Error: 'comparator.py' not found. Please ensure it exists in the same directory.")
    sys.exit(1)

# 引入 Pandas (用于生成提交格式的 CSV)
try:
    import pandas as pd
except ImportError:
    print("Warning: 'pandas' not found. Submission packaging might fail or require installation.")
    pd = None

# 引入 tqdm 进度条
try:
    from tqdm import tqdm
except ImportError:
    print("Warning: 'tqdm' not found. Progress bar will be disabled.")


    def tqdm(iterable, total=None, desc=""):
        return iterable

# ==========================================
#               配置与自定义区域
# ==========================================

BASE_DIR = ".."

API_KEY = "sk-xxx"
BASE_URL = "https://api.openai.com/v1"
MODEL_NAME = "gpt-3.5-turbo"
MAX_WORKERS = 5  # 并发线程数

# 系统提示词 (System Message)
SYSTEM_PROMPT = "You are a SQL expert. Given a question and database schema, write a valid SQLite SQL query. Do not explain, just provide the SQL."


def generate_sql_prompt(question: str, schema_text: str, db_id: str) -> str:
    """
    【用户自定义 Prompt 函数】
    在这里修改 Prompt 的拼接逻辑。

    参数:
    - question: 用户的问题
    - schema_text: 已经格式化好的 Schema 文本 (包含表名、列名、类型、采样值)
    - db_id: 数据库 ID
    """

    # --- 开始构建 Prompt ---
    prompt = f"### Database Schema ({db_id})\n"

    if schema_text:
        prompt += schema_text + "\n\n"
    else:
        prompt += "(Schema not found)\n\n"

    prompt += f"### Question\n{question}\n"

    prompt += "\n### Answer\nPlease write the SQL query:"
    # --- 构建结束 ---

    return prompt


# ==========================================
#               核心逻辑区域
# ==========================================

client = OpenAI(api_key=API_KEY, base_url=BASE_URL)


class FalconEvaluator:
    def __init__(self, base_dir: str = BASE_DIR):
        self.base_dir = base_dir
        self.dev_dir = os.path.join(base_dir, "falcon_dev")
        self.test_dir = os.path.join(base_dir, "falcon_test")
        self.evaluator = Evaluator()

        # 缓存 tables.json 的数据: {db_id: db_info_dict}
        self.schema_cache = {}

    def _regexp(self, expr, item):
        """SQLite 正则支持"""
        if item is None:
            return False
        try:
            reg = re.compile(expr)
            return reg.search(str(item)) is not None
        except Exception:
            return False

    def _load_tables_json(self, mode: str):
        """加载 tables.json 并建立索引"""
        target_dir = self.dev_dir if mode == "dev" else self.test_dir
        tables_path = os.path.join(target_dir, "tables.json")

        if not os.path.exists(tables_path):
            print(f"Warning: {tables_path} not found. Schema info will be missing.")
            return

        print(f"Loading schema from {tables_path}...")
        try:
            with open(tables_path, 'r', encoding='utf-8') as f:
                data = json.load(f)

            self.schema_cache = {item['db_id']: item for item in data}
            print(f"Loaded schema for {len(self.schema_cache)} databases.")
        except Exception as e:
            print(f"Error loading tables.json: {e}")

    def _format_schema_text(self, db_id: str) -> str:
        """
        [保留的核心功能]
        根据 db_id 从缓存中获取 Schema 信息，并格式化为标准文本。
        """
        if db_id not in self.schema_cache:
            return ""

        db_info = self.schema_cache[db_id]
        schema_text_parts = []

        for table in db_info.get('tables', []):
            table_name = table.get('table_name')
            columns = table.get('columns', [])

            schema_text_parts.append(f"Table: {table_name}")
            schema_text_parts.append("Columns:")

            for col in columns:
                c_name = col.get('column_name')
                c_type = col.get('column_type')
                samples = col.get('sample_values', [])

                sample_str = ""
                if samples:
                    valid_samples = [str(s) for s in samples if s is not None][:3]
                    if valid_samples:
                        sample_str = f", sample values: [{', '.join(valid_samples)}]"

                schema_text_parts.append(f"  - {c_name} ({c_type}){sample_str}")

            schema_text_parts.append("")

        return "\n".join(schema_text_parts).strip()

    def _get_db_path(self, dataset: str, db_id: str) -> str:
        """获取 SQLite 数据库路径"""
        if dataset == "dev":
            base = self.dev_dir
            db_folder = "dev_databases"
        else:
            base = self.test_dir
            db_folder = "test_databases"

        path1 = os.path.join(base, db_folder, db_id, f"{db_id}.sqlite")
        if os.path.exists(path1): return path1
        path2 = os.path.join(base, db_folder, db_id, f"{db_id}.db")
        if os.path.exists(path2): return path2
        return path1

    def _execute_sql(self, db_path: str, sql: str) -> Tuple[Optional[Dict[str, List[str]]], Optional[str]]:
        """执行 SQL (线程安全)"""
        if not os.path.exists(db_path):
            return None, f"Database file not found: {db_path}"

        try:
            conn = sqlite3.connect(db_path)
            conn.create_function("rlike", 2, self._regexp)
            conn.create_function("regexp", 2, self._regexp)
            cursor = conn.cursor()

            cursor.execute(sql)
            rows = cursor.fetchall()

            if cursor.description:
                col_names = [desc[0] for desc in cursor.description]
            else:
                col_names = []

            result_dict = {}
            for col in col_names:
                result_dict[col] = []

            for row in rows:
                for idx, col in enumerate(col_names):
                    val = row[idx]
                    val_str = str(val) if val is not None else "NULL"
                    result_dict[col].append(val_str)

            conn.close()
            return result_dict, None

        except Exception as e:
            return None, str(e)

    def generate_sql_from_model(self, prompt: str) -> str:
        """调用大模型生成 SQL"""
        try:
            response = client.chat.completions.create(
                model=MODEL_NAME,
                messages=[
                    {"role": "system", "content": SYSTEM_PROMPT},
                    {"role": "user", "content": prompt}
                ],
                temperature=0,
                max_tokens=1024
            )
            return response.choices[0].message.content
        except Exception as e:
            return f"Error: {str(e)}"

    def _process_single_case(self, case: Dict, mode: str) -> Dict:
        """处理单个 Case 的逻辑"""
        q_id = case.get('question_id')
        db_id = case.get('db_id')

        # 1. 获取 Schema (内部逻辑)
        schema_text = self._format_schema_text(db_id)

        # 2. 构造 Prompt (调用外部自定义函数)
        prompt = generate_sql_prompt(
            question=case.get('question', ''),
            schema_text=schema_text,
            db_id=db_id
        )

        # 3. 模型生成
        raw_response = self.generate_sql_from_model(prompt)

        # 4. 提取 SQL
        generated_sql = extract_sql_from_response(raw_response)

        # 5. 执行 SQL
        db_path = self._get_db_path(mode, db_id)
        exec_result, exec_error = self._execute_sql(db_path, generated_sql)

        # 6. 评测 (仅 dev 模式)
        is_correct = False
        compare_msg = "N/A"

        if mode == "dev":
            standard_answer = case.get('answer')
            is_order = str(case.get('is_order', '0')) == '1'

            if exec_error:
                compare_msg = "Execution Error"
            else:
                try:
                    is_correct = self.evaluator.compare(standard_answer, exec_result, is_order)
                    compare_msg = "Match" if is_correct else "Mismatch"
                except Exception as e:
                    compare_msg = f"Compare Exception: {e}"

        # 7. 构造结果记录
        record = {
            "question_id": q_id,
            "db_id": db_id,
            "question": case.get('question'),
            "prompt": prompt,
            "model_response_raw": raw_response,
            "generated_sql": generated_sql,
            "execution_result": exec_result,
            "execution_error": exec_error,
            "dataset": mode
        }

        if mode == "dev":
            record["is_correct"] = is_correct
            record["compare_status"] = compare_msg

        return record

    def _generate_submission_zip(self, jsonl_file: str, output_zip: str = "submission.zip"):
        """
        [Test 模式专用] 将运行结果打包成提交格式的 ZIP 文件
        结构:
          - result_sql/{id}.sql
          - result_csv/{id}.csv
        """
        if pd is None:
            print("Error: 'pandas' is not installed. Cannot generate submission CSVs.")
            return

        print(f"\nPackaging results into {output_zip} ...")

        try:
            with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zf:
                # 读取 JSONL 结果文件
                with open(jsonl_file, 'r', encoding='utf-8') as f:
                    lines = f.readlines()

                print(f"Processing {len(lines)} records for submission...")

                for line in tqdm(lines, desc="Zipping"):
                    if not line.strip():
                        continue

                    record = json.loads(line)
                    q_id = str(record.get('question_id'))

                    # 1. 处理 SQL 文件
                    # 使用已经提取好的 generated_sql
                    sql_content = record.get('generated_sql', '')
                    if not sql_content:
                        sql_content = ""  # 确保不为 None

                    sql_filename = f"result_sql/{q_id}.sql"
                    zf.writestr(sql_filename, sql_content)

                    # 2. 处理 CSV 文件
                    exec_result = record.get('execution_result')
                    csv_content = ""

                    try:
                        if exec_result and isinstance(exec_result, dict):
                            # 将字典结果转换为 DataFrame
                            df = pd.DataFrame(exec_result)
                            # 转换为 CSV 字符串，不包含索引
                            csv_content = df.to_csv(index=False)
                        elif exec_result and isinstance(exec_result, list):
                            # 兼容列表格式 [{"col": val}, ...]
                            df = pd.DataFrame(exec_result)
                            csv_content = df.to_csv(index=False)
                    except Exception as e:
                        print(f"Warning: Failed to convert result to CSV for ID {q_id}: {e}")

                    csv_filename = f"result_csv/{q_id}.csv"
                    zf.writestr(csv_filename, csv_content)

            print(f"Submission file created successfully: {os.path.abspath(output_zip)}")

        except Exception as e:
            print(f"Error creating submission zip: {e}")

    def evaluate(self, mode: str):
        """主评测逻辑：多线程 + 实时写入"""
        self._load_tables_json(mode)

        dataset_name = mode
        input_file = os.path.join(self.dev_dir if mode == "dev" else self.test_dir, f"{dataset_name}.json")
        output_file = f"eval_result_{mode}_{int(time.time())}.jsonl"

        if not os.path.exists(input_file):
            print(f"Dataset file not found: {input_file}")
            return

        print(f"Loading dataset from {input_file}...")
        with open(input_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        total = len(data)
        print(f"Start evaluating {total} cases in [{mode}] mode with {MAX_WORKERS} workers...")
        print(f"Results will be streamed to: {output_file}")

        correct_count = 0
        execution_error_count = 0
        processed_count = 0

        # 清空文件
        with open(output_file, 'w', encoding='utf-8') as f:
            pass

        with open(output_file, 'a', encoding='utf-8') as f_out:
            with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
                future_to_case = {executor.submit(self._process_single_case, case, mode): case for case in data}

                pbar = tqdm(as_completed(future_to_case), total=total, desc="Evaluating")

                for future in pbar:
                    try:
                        record = future.result()
                        processed_count += 1

                        if record.get('execution_error'):
                            execution_error_count += 1

                        if mode == "dev" and record.get('is_correct'):
                            correct_count += 1

                        if mode == "dev":
                            acc = correct_count / processed_count if processed_count > 0 else 0
                            pbar.set_postfix({"Acc": f"{acc:.2%}", "Err": execution_error_count})
                        else:
                            pbar.set_postfix({"Err": execution_error_count})

                        f_out.write(json.dumps(record, ensure_ascii=False) + "\n")
                        f_out.flush()

                    except Exception as e:
                        print(f"\nCritical Error: {e}")
                        f_out.write(json.dumps({"error": str(e), "status": "critical_fail"}, ensure_ascii=False) + "\n")
                        f_out.flush()

        print("\n" + "=" * 40)
        print(f"Evaluation Finished: {mode}")
        if mode == "dev":
            accuracy = correct_count / total if total > 0 else 0
            print(f"Total: {total}")
            print(f"Correct: {correct_count}")
            print(f"Exec Errors: {execution_error_count}")
            print(f"Accuracy: {accuracy:.2%}")
        else:
            print(f"Total Processed: {total}")
            print(f"Exec Errors: {execution_error_count}")
        print(f"Detailed logs saved to: {output_file}")

        # === 新增：Test 模式下自动打包 ===
        if mode == "test":
            self._generate_submission_zip(jsonl_file=output_file, output_zip="submission.zip")

        print("=" * 40)


def main():
    if len(sys.argv) < 2:
        print("Usage: python simple_benchmark.py [dev|test]")
        sys.exit(1)

    mode = sys.argv[1].lower()
    if mode not in ['dev', 'test']:
        print("Invalid mode. Use 'dev' or 'test'.")
        sys.exit(1)

    evaluator = FalconEvaluator()
    evaluator.evaluate(mode)


if __name__ == "__main__":
    main()