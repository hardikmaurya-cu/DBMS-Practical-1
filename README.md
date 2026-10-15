# DBMS Laboratory Experiments

A structured repository containing SQL queries, execution plans, views, view updatability tests, and recursive Common Table Expressions (CTEs) for Database Management Systems (DBMS) Laboratory practicals.

---

## 📁 Repository Structure

```tree
dbms-experiments/
├── README.md                      # Root documentation and execution guide
├── company_db_setup.sql           # Schema creation & initial dataset for CompanyDB
├── experiment-2/
│   ├── experiment_2.sql           # Advanced SQL queries & execution plans
│   └── README.md                  # Detailed documentation, query theory & outputs
└── experiment-3/
    ├── experiment_3.sql           # SQL Views, Updatability tests & Recursive CTEs
    └── README.md                  # Comprehensive theory, CTE breakdown & comparison table
```

---

## 🧪 Experiments Overview

### [Experiment 2: Advanced SQL Queries and Execution Plans](./experiment-2/)
Focuses on advanced querying techniques and execution plan inspection:
- **Joins**: `INNER JOIN`, `LEFT JOIN`, `SELF JOIN`, and 4-table multi-table joins.
- **Subqueries**: Correlated subqueries and `EXISTS` conditions.
- **Set Operations**: Simulated `INTERSECT` (via `INNER JOIN`) and simulated `EXCEPT` (via `NOT EXISTS`).
- **Optimizer Analysis**: `EXPLAIN` execution plans for joins, selections, subqueries, and `EXISTS`.

👉 [View Experiment 2 Code & Notes](./experiment-2/)

---

### [Experiment 3: SQL Views, View Updatability and Recursive CTE](./experiment-3/)
Focuses on virtual views, update restrictions, and recursive hierarchical processing:
- **Schema Extension**: Adding self-referencing foreign key (`Manager_ID`) for organizational hierarchy.
- **Views**: Creating aggregate summary view (`Department_Salary_Summary`) and join view (`Employee_Hierarchy`).
- **View Updatability Tests**: Demonstrating successful update on simple 1-to-1 view (`Employee_Basic`) vs rejected updates on aggregate and joined views (Error 1288).
- **Recursive CTEs**:
  - Full company reporting chains (`EmployeeChain`)
  - Sub-tree hierarchy for a specific manager (`ReportingTree`)
  - Visual tree indentation by level (`EmployeeTree`)

👉 [View Experiment 3 Code & Notes](./experiment-3/)

---

## 🚀 Getting Started & Execution Guide

### Prerequisites
- **MySQL Server** 8.0 or newer
- **MySQL Workbench** or MySQL Command Line Client (`mysql`)

### Execution Order

1. **Step 1: Initialize Database & Data**
   Execute `company_db_setup.sql` to create `CompanyDB` and insert all departments, employees, and projects:
   ```bash
   mysql -u root -p < company_db_setup.sql
   ```

2. **Step 2: Run Experiment 2**
   Execute the queries for joins, subqueries, and `EXPLAIN` plans:
   ```bash
   mysql -u root -p CompanyDB < experiment-2/experiment_2.sql
   ```

3. **Step 3: Run Experiment 3**
   Execute schema extension, views, and recursive CTEs:
   ```bash
   mysql -u root -p CompanyDB < experiment-3/experiment_3.sql
   ```

---

## 👤 Author
- **Student**: Hardik Maurya
- **Subject**: Database Management Systems (DBMS) Lab
