<div align="center">
  <a href="README.md">🇬🇧 English Version</a>
</div>

<div align="center">

# 🦅 Falcon: 企业级 Text-to-SQL 评测基准

**面向复杂跨领域分析场景的综合性中文 Text-to-SQL 评测基准**

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](LICENSE)
[![arXiv](https://img.shields.io/badge/arXiv-2510.24762-b31b1b.svg)](https://arxiv.org/abs/2510.24762)

[**简介**](#-简介) | [**数据集结构**](#-数据集结构) | [**快速开始**](#-快速开始) | [**引用**](#-引用)

</div>

---

## 📖 简介

**Falcon** 是一个持续迭代的高质量评测基准，旨在弥合学术界 Text-to-SQL 数据集与真实企业级需求之间的差距。与传统基准不同，Falcon 专注于 **MaxCompute/Hive 方言**，并着重考察模型在生产环境中常见的复杂 SQL 模式及语言歧义处理能力。

### 核心特性
*   **SQL 复杂度高**：重点考察多表关联（占样本总数的 77%）、嵌套 CTE（公用表表达式）、窗口函数、排名以及类型转换等高级特性。
*   **语言挑战性强**：包含中文模糊时间表达、口语化业务术语、省略句以及多意图复合问题。
*   **企业级规模**：Schema 设计包含非规范化（反范式）字段、隐式外键关系以及特定领域的同义词映射。

当前版本基于精选的公开数据集构建，覆盖 **金融、互联网和零售** 三大领域。

---

## 📂 数据集结构

为了支持稳健的评估，Falcon 基准被划分为 **开发集（Development Set）**（包含标准答案）和 **测试集（Test Set）**（盲测）。

### 仓库目录结构

```text
FALCON/
├── dev_data/                   # 开发集
│   ├── dev.json                # 问题、SQL 及其执行结果
│   ├── tables.json             # Schema 定义 (主键/外键/列信息)
│   └── dev_databases/          # 用于执行的 SQLite/CSV 源文件
│
├── test_data/                  # 测试集
│   ├── test.json               # 仅包含问题 (标准答案已隐藏)
│   ├── tables.json             # Schema 定义
│   └── test_databases/         # SQLite/CSV 源文件
│
├── simple_agent/               # [新增] 轻量级评测脚本
│   ├── comparator.py           # SQL 执行结果比对器
│   ├── utils.py                # 从 LLM 响应中提取 SQL 的工具类
│   └── simple_benchmark.py     # 运行 dev/test 评测的主脚本
│
├── submission/                 # [新增] 提交辅助工具与示例
│   ├── example_submission_csv/ # 榜单提交用的 CSV 示例文件
│   ├── example_submission_sql/ # 榜单提交用的 SQL 示例文件
│   └── format_submission.py    # 将 DB-GPT Excel 输出转换为 Zip 的辅助脚本
│
└── README.md
```

### 数据格式详情

#### 1. 开发数据 (`dev_data/dev.json`)
用于 Few-shot Prompting（少样本提示）、微调或调试。包含自然语言问题、标准 SQL（Ground Truth）以及预期的执行结果。

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

#### 2. 测试数据 (`test_data/test.json`)
用于官方榜单评测。仅提供问题和 Schema 引用，不包含 SQL 和答案。

---

## 🚀 快速开始

目前我们提供两种方式在 Falcon 基准上评估您的模型：基于脚本的轻量级方法和基于 DB-GPT 的可视化方法。

### 方法 1: Simple Agent (脚本方式)

`simple_agent` 目录包含了一套轻量级的评估流程。您可以使用 `simple_benchmark.py` 在开发集或测试集上运行评估。

1.  **克隆仓库**
    ```bash
    git clone https://github.com/eosphoros-ai/Falcon.git
    cd Falcon
    ```

2.  **环境配置**
    确保安装了必要的 Python 依赖。
    ```bash
    pip install openai pandas tqdm
    ```

3.  **运行评估**
    
    *   **开发集 (Dev Set)**：在开发集上运行基准测试，并将结果与标准答案进行比对。
        ```bash
        cd simple_agent
        python simple_benchmark.py dev
        ```
    
    *   **测试集 (Test Set)**：在测试集上运行基准测试以生成预测结果。
        ```bash
        cd simple_agent
        python simple_benchmark.py test
        ```
        **提交说明：** 执行完成后，脚本会自动生成 `submission.zip` 文件。为了进行官方榜单提交，必须提供 **Trace Log（追踪日志）**（推荐 `.jsonl` 格式）。请在提交前确保手动将您的 Trace Log 包含在最终的 ZIP 包中。

### 方法 2: DB-GPT (可视化方式)

Falcon 已完全集成到 **DB-GPT** 中，支持通过可视化界面评估 **模型 (Models)** 和 **智能体 (Agents)**。

1.  **配置与执行**
    请参考官方 **[DB-GPT 评测文档](https://www.yuque.com/eosphoros/dbgpt-docs/hpowc4o7134xnixn#H2MYu)** 获取详细步骤，包括：
    *   导入 Falcon 评测数据集。
    *   配置您的模型或智能体。
    *   通过 "Models Evaluation"（模型评测）模块运行评测流水线。

2.  **格式化提交文件**
    DB-GPT 将生成 **Excel (`.xlsx`)** 格式的评测报告。要将结果提交至 Falcon 榜单，您必须使用我们的辅助脚本将该文件转换为所需的 ZIP 格式。

    ```bash
    # 运行格式化脚本
    python submission/format_submission.py --input <path_to_dbgpt_output.xlsx> --output submission.zip
    ```

    > **注意：** 生成的 `submission.zip` 将包含符合榜单格式要求的 `result_sql` 和 `result_csv` 文件夹。

---

## 📤 提交指南

生成 SQL 查询（及执行结果）后，请参考 `submission/` 目录了解格式要求。

*   **示例文件**：查看 `submission/example_submission_csv` 和 `submission/example_submission_sql` 了解预期的文件结构。
*   **详细规则**：请参阅 **[Falcon 提交指南](https://docs.google.com/document/d/16KWw1GjrF6aUwumQxxsi_N3GEB5LPzzzHSqHsBE9TBw/edit?usp=sharing)** 获取详细规则说明。

---

## 📝 引用

如果您在研究或开发中使用了 Falcon，请引用我们的论文：

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

## ⚖️ 许可证

本项目采用 **Apache License, Version 2.0** 许可证。  
查看 [LICENSE](LICENSE) 文件获取完整文本。

---

<div align="center">
  <sub>Maintained by <a href="https://github.com/eosphoros-ai">Eosphoros AI</a></sub>
</div>