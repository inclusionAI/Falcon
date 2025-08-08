# Falcon - Text2SQL Benchmark

**Falcon** is a continuously-evolving, high-quality benchmark for natural-language-to-SQL (NL2SQL) systems.  
The benchmark is designed to stress-test models under **complex, cross-domain analytical scenarios** with a special focus on:

* SQL-computational difficulties – multi-table joins, nested CTEs, window functions, ranking, type casting, regular-expression filters …  
* Linguistic difficulties – Chinese fuzzy time expressions, colloquial business jargon, ellipsis, multi-intent questions …

The current release is built on public Kaggle datasets covering **Finance, Internet and Retail**.  
Each domain is paired with question sets of **incremental difficulty levels** so that model capability can be measured more finely.

---

## Release Status

| Feature                                                                     | Status            |
|-----------------------------------------------------------------------------|-------------------|
| 500 Chinese questions (various difficulty) derived from Kaggle datasets     | ✅ Released        |
| more questions focusing on fuzzy / vague linguistic expressions               | 🔄 In Preparation |
| more questions collected from real Ant Group production scenarios             | 🔄 In Preparation |

---

## Repository Layout

```
FALCON/
└── data/
    ├── source/                     # raw tables for every dataset_id
    │   └── 1/ , 2/ , 10/ …         # each sub-folder = one dataset
    └── result/                     # benchmark resources & ground-truth
        ├── sql/                    # final executable SQL, one file per question
        │   ├── 1.sql
        │   ├── 2.sql
        │   └── …
        ├── query_answer.jsonl      # canonical answers produced by the SQL
        ├── questions.jsonl         # NL questions + dataset_id mapping
        ├── table_relations.jsonl   # PK / FK graph for every dataset
        └── dataset_source.csv      # provenance / download URL of each dataset
```

### 1. `result/sql/`  – ground-truth SQL

* File name pattern: `question_id.sql`  
* Example files: `1.sql`, `2.sql`, …

### 2. `query_answer.jsonl`  – canonical answers

Each line is a JSON object:

```json
{"question_id": "1", "answer": {"Gender": ["Female", "Male"], "AvgAge": ["27.7333","27.84"]}}
{"question_id": "2", "answer": {"objective": ["Capital Appreciation","Growth","Income"], "GovBondTotal": ["117","15","54"]}}
```

### 3. `questions.jsonl`  – natural-language questions

```json
{"question_id": "1", "question": "What is the average age for each gender, ordered by age?", "dataset_id": "1"}
{"question_id": "2", "question": "What is the total amount of government bonds for each investment objective, ordered by objective name?", "dataset_id": "1"}
```

Fields  
| Field          | Meaning                                |
|----------------|----------------------------------------|
| `question_id`  | unique identifier of the question      |
| `question`     | Chinese NL query (UTF-8 encoded)       |
| `dataset_id`   | which schema / table folder to use     |

### 4. `table_relations.jsonl`  – schema graph

```json
{"dataset_id": "10", "tables": {"indexInfo":  {"pk": ["index"], "fk": {}},
                                "indexData": {"pk": [],       "fk": {"index": "indexInfo.index"}}}}
{"dataset_id": "11", "tables": {"price": {"pk": ["name"], "fk": {}},
                                "sales": {"pk": [],       "fk": {"product_name": "price.name"}}}}
```

One line per `dataset_id`, covering all tables and their PK/FK relationships.

### 5. `dataset_source.csv`  – data provenance

| dataset_id | source URL |
|------------|------------|
| 1 | https://www.kaggle.com/datasets/nitindatta/finance-data?select=Finance_data.csv |
| 2 | https://www.kaggle.com/datasets/krishnaraj30/finance-loan-approval-prediction-data?select=test.csv |

### 6. `data/source/`  – original tables

Each sub-folder is named after a `dataset_id` and contains the raw CSV/Parquet files used to build the benchmark.

---

Key changes compared to the previous structure  
* The old `benchmark_dataset.xlsx` is split into several machine-friendly files (`questions.jsonl`, `query_answer.jsonl`, individual `.sql` files, etc.).  
* All ground-truth SQL moves to `result/sql/`.  
* `table_relations.jsonl` replaces the previous `table_relations.csv`.  
* All benchmark results and metadata now live under `data/result/`.

---

## Contribution Guide

We welcome pull requests for

* New question–SQL pairs
* Additional domains or external datasets
* Bug fixes in existing samples
* Evaluation scripts

Please open an issue first if the change is non-trivial.  
Detailed guidelines will be published in **CONTRIBUTING.md**.

---

## License

The benchmark is released under the **Apache License, Version 2.0** license.

For the full legal text, see <https://www.apache.org/licenses/LICENSE-2.0>.

---

## Acknowledgements

* Kaggle community for publicly available datasets  
* Ant Group engineers for anonymised real-world schemas and question patterns