<div align="center">
  <a href="README_zh.md">🇨🇳 中文版</a>
</div>

<div align="center">

# 🦅 Falcon: Enterprise-Grade Text-to-SQL Benchmark

**A Comprehensive Chinese Text-to-SQL Benchmark for Complex, Cross-Domain Analytical Scenarios**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![arXiv](https://img.shields.io/badge/arXiv-2510.24762-b31b1b.svg)](https://arxiv.org/abs/2510.24762)

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
├── dev_data/                   # Development Set
│   ├── dev.json                # Questions, SQL, and Execution Results
│   ├── tables.json             # Schema definitions (PK/FK/Columns)
│   └── dev_databases/          # SQLite/CSV source files for execution
│
├── test_data/                  # Test Set
│   ├── test.json               # Questions ONLY (Ground truth hidden)
│   ├── tables.json             # Schema definitions
│   └── test_databases/         # SQLite/CSV source files
│
├── simple_agent/               # [NEW] Lightweight Evaluation Scripts
│   ├── comparator.py           # SQL execution result comparator
│   ├── utils.py                # Utilities for SQL extraction from LLM response
│   └── simple_benchmark.py     # Main script to run dev/test evaluation
│
├── submission/                 # [NEW] Submission Helpers & Examples
│   ├── example_submission_csv/ # Example CSV files for leaderboard submission
│   ├── example_submission_sql/ # Example SQL files for leaderboard submission
│   └── format_submission.py    # Helper to convert DB-GPT Excel output to Zip
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
    "question": "每个性别的平均年龄是多少，按年龄排序？",
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

---

## 🚀 Getting Started

We currently provide two methods for evaluating your models on the Falcon benchmark: a lightweight script-based approach and a GUI-based approach via DB-GPT.

### Method 1: Simple Agent (Script-based)

The `simple_agent` directory contains a lightweight evaluation pipeline. You can use `simple_benchmark.py` to run evaluations on either the development or test sets.

1.  **Clone the Repository**
    ```bash
    git clone https://github.com/eosphoros-ai/Falcon.git
    cd Falcon
    ```

2.  **Setup Environment**
    Ensure you have the necessary Python dependencies installed.
    ```bash
    pip install openai pandas tqdm
    ```

3.  **Run Evaluation**
    
    *   **Development Set**: Run the benchmark on the dev set to check performance against ground truth.
        ```bash
        cd simple_agent
        python simple_benchmark.py dev
        ```
    
    *   **Test Set**: Run the benchmark on the test set to generate predictions.
        ```bash
        cd simple_agent
        python simple_benchmark.py test
        ```
        **Note on Submission:** After execution, a `submission.zip` will be automatically generated. For official leaderboard submission, a **trace log** (we recommend `.jsonl` format) is required. Please ensure you manually include your trace log in the final ZIP before submitting.

### Method 2: DB-GPT (GUI-based)

Falcon is fully integrated into **DB-GPT**, allowing you to evaluate both **Models** (LLMs) and **Agents** through a visual interface.

1.  **Configuration & Execution**
    Please refer to the official **[DB-GPT Evaluation Documentation](https://www.yuque.com/eosphoros/dbgpt-docs/hpowc4o7134xnixn#H2MYu)** for detailed steps on how to:
    *   Import the Falcon benchmark dataset.
    *   Configure your Model or Agent.
    *   Run the evaluation pipeline via the "Models Evaluation" module.

2.  **Format Submission**
    DB-GPT will generate an evaluation report in **Excel (`.xlsx`)** format. To submit your results to the Falcon leaderboard, you must convert this file into the required ZIP format using our helper script.

    ```bash
    # Run the formatting script
    python submission/format_submission.py --input <path_to_dbgpt_output.xlsx> --output submission.zip
    ```

    > **Note:** The generated `submission.zip` will contain the required `result_sql` and `result_csv` folders formatted correctly for the leaderboard.

---

## 📤 Submission

Once you have generated your SQL queries (and execution results), please refer to the `submission/` directory for format requirements.

*   **Examples**: Check `submission/example_submission_csv` and `submission/example_submission_sql` for the expected file structure.
*   **Guidelines**: Please refer to the **[Falcon Submission Guidelines](https://docs.google.com/document/d/16KWw1GjrF6aUwumQxxsi_N3GEB5LPzzzHSqHsBE9TBw/edit?usp=sharing)** for detailed rules.

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

---

<div align="center">
  <sub>Maintained by <a href="https://github.com/eosphoros-ai">Eosphoros AI</a></sub>
</div>
