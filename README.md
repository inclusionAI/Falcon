# FalCon - Text2SQL Benchmark

**FalCon** is a continuously-evolving, high-quality benchmark for natural-language-to-SQL (NL2SQL) systems.  
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
text2sqlbench/
├── data/
│   ├── dataset.xlsx          # (core) questions + golden SQL + answers + metadata
│   ├── table_relations.csv   # explicit relationships between tables
│   └── dataset_source.csv    # provenance of every table (Kaggle link etc.)
├── examples/                 # sample loading / evaluation scripts (coming soon)
└── README.md                 # this file
```

### 1. `dataset.xlsx`  (benchmark itself)


### 1. `dataset.xlsx`  (the benchmark itself)

The file now uses **five mandatory columns**; any additional empty columns are ignored.

| Column Name        | Description                                                                               |
|--------------------|-------------------------------------------------------------------------------------------|
| `id`               | Question id (float in the original design, e.g. `1.00`)                                   |
| `dataset_id`       | Identifier that maps to a specific schema / domain (same id appears in `table_relations.csv` and `dataset_source.csv`) |
| `quesetion`        | Chinese natural-language question (note the deliberate typo that matches the file)        |
| `sql_answer`       | Ground-truth executable SQL (MaxCompute syntax)                                           |
| `query_answer`     | Canonical answer returned by the SQL, stored as a JSON string                             |


### 2. `table_relations.csv`  (schema graph)

Example:

| dataset_id                              | relationships                                  |
|--------------------------------------|------------------------------------------------|
| `D2025041800161503000024863833`      | `indexData` **many-to-one** `indexInfo`        |

Each row describes **one pairwise relationship**.  
The file helps NL2SQL parsers avoid guessing FK/PK constraints.

### 3. `dataset_source.csv`  (data provenance)

Example:

| dataset_id                              | source (Kaggle URL or internal location) |
|--------------------------------------|-------------------------------------------|
| `D2025050900161503000025249569`      | https://www.kaggle.com/xxx/finance-data  |


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

The benchmark is released under the **Creative Commons Attribution 4.0 International (CC BY 4.0)** license.

For the full legal text, see <https://creativecommons.org/licenses/by/4.0/>.

---

## Acknowledgements

* Kaggle community for publicly available datasets  
* Ant Group engineers for anonymised real-world schemas and question patterns