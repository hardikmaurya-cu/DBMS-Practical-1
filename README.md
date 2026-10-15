# DBMS Laboratory Practical Repository

A comprehensive collection of SQL practical scripts, execution plans, views, view updatability tests, and recursive Common Table Expressions (CTEs) for Database Management Systems (DBMS) Laboratory.

---

## 📁 Repository Structure

```tree
DBMS-Practical-1/
├── README.md                      # Main repository index and execution guide
├── company_db_setup.sql           # Schema setup script with 30 employees & 5 departments
├── file                           # Practical 1 original standalone script
│
├── experiment-1/                  # Experiment 1: Schema Setup & Basic Queries
│   ├── experiment_1.sql           # Database creation, inserts & 18 queries
│   └── README.md                  # Experiment 1 documentation
│
├── experiment-2/                  # Experiment 2: Advanced SQL Queries & Execution Plans
│   ├── experiment_2.sql           # Joins, Correlated Subqueries, EXISTS, INTERSECT, EXCEPT, EXPLAIN
│   └── README.md                  # Comprehensive theory, query analysis & output tables
│
└── experiment-3/                  # Experiment 3: SQL Views, Updatability & Recursive CTE
    ├── experiment_3.sql           # Schema alter, Views, Updatability tests, Recursive CTEs
    └── README.md                  # Theory, Step-by-step walkthrough & comparison table
```

---

## 🧪 Experiments Summary

### [Experiment 1: Database Creation, Population and Basic SQL Queries](./experiment-1/)
- Creation of `CompanyDB` schema (`Department`, `Employee`, `Project`, `Employee_Project`).
- Insertion of 30 employee records, 5 departments, 8 projects, and $M:N$ employee-project assignments.
- 18 foundational SQL queries covering selections, aggregations (`AVG`, `SUM`, `MIN`, `MAX`, `COUNT`), grouping (`GROUP BY`, `HAVING`), conditional classification (`CASE`), and sorting (`ORDER BY`).

👉 [Explore Experiment 1 Details](./experiment-1/)

---

### [Experiment 2: Advanced SQL Queries and Execution Plans](./experiment-2/)
- **Joins**: `INNER JOIN`, `LEFT JOIN`, `SELF JOIN` (preventing redundant pairs with `Emp_ID < Emp_ID`), and 4-table multi-table joins.
- **Correlated Subqueries**: Department-level salary comparison evaluated dynamically for each candidate row.
- **EXISTS Clause**: Testing department-level salary conditions.
- **Set Operations Simulation**:
  - `INTERSECT` simulated via `INNER JOIN` between subqueries.
  - `EXCEPT` simulated via `NOT EXISTS`.
- **Query Optimizer Inspection**: `EXPLAIN` execution plans comparing scan types, indexes, and row estimates.

👉 [Explore Experiment 2 Details](./experiment-2/)

---

### [Experiment 3: SQL Views, View Updatability and Recursive CTE](./experiment-3/)
- **Schema Extension**: Adding self-referencing foreign key (`Manager_ID`) for organizational hierarchy.
- **Views**:
  - Aggregate Summary View: `Department_Salary_Summary` (`GROUP BY`, `SUM`, `AVG`, `MIN`, `MAX`).
  - Hierarchy Join View: `Employee_Hierarchy` (`LEFT JOIN` on `Department` and self-join on `Employee`).
- **View Updatability Testing**:
  - Successful update through simple 1-to-1 projection view (`Employee_Basic`).
  - Proving MySQL rejects updates to aggregate views (`ERROR 1288`) and joined multi-table views.
- **Recursive Common Table Expressions (CTEs)**:
  - Traversing complete company reporting chains (`EmployeeChain`).
  - Extracting sub-trees rooted at a specific manager (`ReportingTree`).
  - Rendering formatted visual hierarchy with indentation by level (`EmployeeTree`).

👉 [Explore Experiment 3 Details](./experiment-3/)

---

## 🚀 Execution Guide

### Prerequisites
- MySQL Server 8.0 or later
- MySQL Command Line Client or MySQL Workbench

### Step-by-Step Running:

1. **Run Experiment 1 (Setup and Basic Queries)**:
   ```bash
   mysql -u <username> -p < experiment-1/experiment_1.sql
   ```
   *(Or run `mysql -u <username> -p < file`)*

2. **Run Experiment 2 (Advanced Queries and EXPLAIN)**:
   ```bash
   mysql -u <username> -p CompanyDB < experiment-2/experiment_2.sql
   ```

3. **Run Experiment 3 (Views, Updatability & Recursive CTEs)**:
   ```bash
   mysql -u <username> -p CompanyDB < experiment-3/experiment_3.sql
   ```

---

## 👤 Author
- **Author**: Hardik Maurya
- **Subject**: Database Management Systems (DBMS) Laboratory
