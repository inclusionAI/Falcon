import pandas as pd
import json
import zipfile
import re
import io
import os


def clean_sql_content(sql_text):
    """
    清洗SQL内容，移除Markdown代码块标记和首尾空白
    """
    if not isinstance(sql_text, str):
        return ""

    # 移除 ```sql 和 ``` 标记
    pattern = r"```sql\s*(.*?)\s*```"
    match = re.search(pattern, sql_text, re.DOTALL | re.IGNORECASE)
    if match:
        return match.group(1).strip()

    # 如果没有 sql 标记，尝试移除普通的 ```
    pattern_generic = r"```\s*(.*?)\s*```"
    match_generic = re.search(pattern_generic, sql_text, re.DOTALL)
    if match_generic:
        return match_generic.group(1).strip()

    return sql_text.strip()


def process_excel_to_zip(input_file, output_zip):
    print(f"正在读取文件: {input_file} ...")

    try:
        # 读取Excel文件
        df = pd.read_excel(input_file)
    except Exception as e:
        print(f"读取Excel失败: {e}")
        return

    # 创建 ZIP 文件
    with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zf:
        print(f"正在处理 {len(df)} 条数据...")

        for index, row in df.iterrows():
            # 获取编号 (假设编号列名为 '编号')
            item_id = str(row.get('编号', index))

            # --- 处理 SQL ---
            raw_sql = row.get('LLM输出结果', '')
            clean_sql = clean_sql_content(raw_sql)

            # 将 SQL 写入 ZIP 中的 result_sql 文件夹
            sql_filename = f"result_sql/{item_id}.sql"
            zf.writestr(sql_filename, clean_sql)

            # --- 处理 CSV 结果 ---
            raw_result = row.get('结果执行', '')
            csv_content = ""

            try:
                # 尝试解析 JSON 结果
                # 格式示例: {"Dept": ["32"], "total_sales": ["5248.96"]}
                if isinstance(raw_result, str) and raw_result.strip():
                    # 替换单引号为双引号（以防万一是非标准JSON）
                    # 注意：如果内容本身包含单引号，这行可能需要更复杂的处理，
                    # 但针对标准JSON dumps出来的结果，直接loads即可。
                    data = json.loads(raw_result)

                    if isinstance(data, dict):
                        # 将字典转换为 DataFrame (列式数据 -> 表格数据)
                        result_df = pd.DataFrame(data)
                        # 转换为 CSV 字符串，不包含索引
                        csv_content = result_df.to_csv(index=False)
                    elif isinstance(data, list):
                        # 如果是列表形式 [{"col": val}, ...]
                        result_df = pd.DataFrame(data)
                        csv_content = result_df.to_csv(index=False)

            except json.JSONDecodeError:
                print(f"警告: ID {item_id} 的执行结果不是有效的 JSON，已生成空 CSV。")
            except Exception as e:
                print(f"警告: 处理 ID {item_id} 的 CSV 时出错: {e}")

            # 将 CSV 写入 ZIP 中的 result_csv 文件夹
            csv_filename = f"result_csv/{item_id}.csv"
            zf.writestr(csv_filename, csv_content)

    print(f"处理完成！文件已保存为: {output_zip}")


if __name__ == "__main__":
    # 输入文件名 (Input file name - excel)
    INPUT_FILE = "execute.xlsx"
    # 输出压缩包名 (Output file name - zip)
    OUTPUT_ZIP = "submission.zip"

    if os.path.exists(INPUT_FILE):
        process_excel_to_zip(INPUT_FILE, OUTPUT_ZIP)
    else:
        print(f"错误: 找不到文件 {INPUT_FILE}，请确保文件在当前目录下。")