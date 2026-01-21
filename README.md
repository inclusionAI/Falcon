<div align="center">

# 🦅 Falcon: Enterprise-Grade Text-to-SQL Benchmark

**A Comprehensive Chinese Text-to-SQL Benchmark for Complex, Cross-Domain Analytical Scenarios**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![arXiv](https://img.shields.io/badge/arXiv-2510.24762-b31b1b.svg)](https://arxiv.org/abs/2510.24762)
[![Data](https://img.shields.io/badge/Data-Kaggle-20beff.svg)](https://www.kaggle.com/)

[**Introduction**](#-introduction) | [**Dataset Structure**](#-dataset-structure) | [**Getting Started**](#-getting-started) | [**Citation**](#-citation)

</div>

---

## 📖 Introduction

**Falcon** is a continuously evolving, high-quality benchmark designed to bridge the gap between academic Text-to-SQL datasets and real-world enterprise requirements. Unlike traditional benchmarks, Falcon focuses on **MaxCompute/Hive dialects** and stresses models with complex SQL patterns and linguistic ambiguities common in production environments.

### Key Features
*   **SQL Complexity**: Heavy focus on multi-table joins (77% of samples), nested CTEs, window functions, ranking, and type casting.
*   **Linguistic Challenges**: Includes Chinese fuzzy time expressions, colloquial business jargon, ellipsis, and multi-intent questions.
*   **Enterprise Scale**: Schemas involve denormalized fields, implicit foreign keys, and domain-specific synonyms.

The current release is built on curated public datasets covering **Finance, Internet, and Retail** domains.

---

## 📂 Dataset Structure

To facilitate robust evaluation, the Falcon benchmark is split into a **Development Set** (with ground truth) and a **Test Set** (blind).

### Repository Layout

```text
FALCON/
├── dev_data/                   # Development Set (300 Samples)
│   ├── dev.json                # Questions, SQL, and Execution Results
│   ├── tables.json             # Schema definitions (PK/FK/Columns)
│   └── db/                     # SQLite/CSV source files for execution
│
├── test_data/                  # Test Set (200 Samples)
│   ├── test.json               # Questions ONLY (Ground truth hidden)
│   ├── tables.json             # Schema definitions
│   └── db/                     # SQLite/CSV source files
│
└── README.md
```

### Data Format Details

#### 1. Development Data (`dev_data/dev.json`)
Used for few-shot prompting, fine-tuning, or debugging. Contains the natural language question, the ground truth SQL, and the expected execution result.

```json
[
  {
    "question_id": "1",
    "dataset_id": "finance_01",
    "question": "What is the average age for each gender, ordered by age?",
    "sql": "SELECT Gender, AVG(Age) FROM customers GROUP BY Gender ORDER BY AVG(Age)",
    "answer": {
      "Gender": ["Female", "Male"],
      "AvgAge": [27.73, 27.84]
    },
    "is_order": "0"
  }
]
```

#### 2. Test Data (`test_data/test.json`)
Used for the official leaderboard. Only the question and schema reference are provided.

```json
[
  {
    "question_id": "201",
    "dataset_id": "loan_approval_db",
    "question": "Show the total amount of government bonds for each investment objective.",
    "is_order": "0"
  }
]
```

#### 3. Schema Definition (`tables.json`)
Defines the structure of the database, including table names, table ddl, column descriptions and sample values.

```json
[
  {
    "db_id": "20",
    "tables": [
      {
        "table_id": 0,
        "table_name": "city_ride_drivers_data",
        "columns": [
          {
            "column_id": 0,
            "column_name": "Driver_ID",
            "column_type": "integer",
            "sample_values": [
              199,
              129,
              170
            ]
          }
        ],
        "ddl": "CREATE TABLE \"city_ride_drivers_data\" (\n\"Driver_ID\" INTEGER,\n  \"Name\" TEXT,\n  \"Age\" INTEGER,\n  \"City\" TEXT,\n  \"Experience_Years\" INTEGER,\n  \"Average_Rating\" REAL,\n  \"Active_Status\" TEXT\n)"
      }
    ]
  }
]
```

---


## 🚀 Getting Started

1.  **Clone the Repository**
    ```bash
    git clone -b yifan_1216 https://github.com/eosphoros-ai/Falcon.git
    cd Falcon
    ```

2.  **Load the Development Set**
    Use the `dev_data` to evaluate your model's baseline performance.
    ```python
    import json
    with open('dev_data/dev.json', 'r') as f:
        data = json.load(f)
    # Iterate through questions and generate SQL
    ```

3.  **Submit Results**
    Generate SQL queries for the `test_data/test.json` file and submit your predictions to the leaderboard.
    [Falcon Submission Guidelines](https://docs.google.com/document/d/16KWw1GjrF6aUwumQxxsi_N3GEB5LPzzzHSqHsBE9TBw/edit?usp=sharing)

4.  **Submission Helper Script**
    For users using DB-GPT for testset execution, we provide a helper script `submission/submission_format.py`. This script converts your execution result Excel file into the required `submission.zip` format containing `result_sql` and `result_csv` folders.

    ```python
    if __name__ == "__main__":
    # Input file name - excel
    INPUT_FILE = "execute.xlsx" # REPLACE WITH ACTUAL EXECEL FILE NAME
    # Output file name - zip
    OUTPUT_ZIP = "submission.zip"
    ```
    
    > **Note:** This script handles SQL and Result packaging. You must provide the execution trace separately if required.

---

## 📝 Citation

If you use Falcon in your research or development, please cite our paper:

```bibtex
@article{falcon2025,
  title={Falcon: A Comprehensive Chinese Text-to-SQL Benchmark for Enterprise-Grade Evaluation},
  author={Luo, Wenzhen and Guan, Wei and Yao, Yifan and Pan, Yimin and Wang, Feng and Yu, Zhipeng and Wen, Zhe and Chen, Liang and Zhuang, Yihong},
  journal={arXiv preprint arXiv:2510.24762},
  year={2025},
  url={https://arxiv.org/abs/2510.24762}
}
```

---

## ⚖️ License

This project is licensed under the **Apache License, Version 2.0**.  
See the [LICENSE](LICENSE) file for the full text.

> "License" shall mean the terms and conditions for use, reproduction, and distribution as defined by Sections 1 through 9 of this document.

---

<div align="center">
  <sub>Maintained by <a href="https://github.com/eosphoros-ai">Eosphoros AI</a></sub>
</div>
