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
├── experiment-3/                  # Experiment 3: SQL Views, Updatability & Recursive CTE
│   ├── experiment_3.sql           # Schema alter, Views, Updatability tests, Recursive CTEs
│   └── README.md                  # Theory, Step-by-step walkthrough & comparison table
│
├── experiment-4/                  # Experiment 4: Conceptual ER Diagram (E-Commerce Platform)
│   ├── DBMS_Exp_1_ER_Diagram.pdf  # Attached original lab submission PDF
│   ├── er_diagram.mermaid         # Visual Mermaid ER diagram definition
│   └── README.md                  # Theoretical foundations, entity definitions & diagram
│
├── experiment-5/                  # Experiment 5: Relational Schema & Integrity Constraints
│   ├── DBMS_Exp_2_Relational_Schema.pdf # Attached original lab submission PDF
│   ├── experiment_5.sql           # 18-table DDL, DML sample inserts & constraint tests
│   └── README.md                  # Relational mapping matrix, query scripts & execution outputs
│
└── experiment-6/                  # Experiment 6: Stored Procedures & Triggers with Error Handling
    ├── EXPERIMENT_DBMS_06.pdf     # Attached original lab submission PDF
    ├── experiment_6.sql           # transfer_employee procedure, validation & audit triggers
    └── README.md                  # Comprehensive theory, error handling & execution outputs
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

### [Experiment 4: Conceptual Database Design & ER Diagram for an Indian E-Commerce Platform](./experiment-4/)
- **Attached Lab Submission**: Includes original scanned submission [`DBMS_Exp_1_ER_Diagram.pdf`](./experiment-4/DBMS_Exp_1_ER_Diagram.pdf).
- **Core Entities**: Modeling `Customer`, `Product`, `Order`, `Seller`, `Category`, `Payment`, `Delivery`, `Address`, `Cart`, `Wishlist`, and `Product_Review`.
- **Advanced Modeling Features**:
  - Decomposition of composite attributes (multiline addresses).
  - Identification and handling of multi-valued attributes (multiple phone numbers, product images).
  - Modeling weak entities (`OrderItem`).
  - Specialization of `Product` into subclasses (`Electronics`, `Clothing`, `Books`).
  - Interactive Mermaid ER diagram.

👉 [Explore Experiment 4 Details](./experiment-4/)

---

### [Experiment 5: ER Diagram to Relational Schema and SQL Implementation](./experiment-5/)
- **Attached Lab Submission**: Includes original scanned submission [`DBMS_Exp_2_Relational_Schema.pdf`](./experiment-5/DBMS_Exp_2_Relational_Schema.pdf).
- **Relational Mapping**: Comprehensive mapping table for 18 relational tables, primary keys, and foreign keys.
- **DDL Implementation**: Complete database creation script with referential actions (`ON DELETE CASCADE`, `ON DELETE SET NULL`).
- **DML Implementation**: Realistic sample data insertion representing sellers, customers, hierarchical categories, products, orders, and delivery tracking.
- **Demonstrations & Verifications**:
  - Output 1: `SHOW TABLES;` verifying 18 generated tables.
  - Output 2: Verification of inserted data via `SELECT` queries.
  - Output 3: **Referential Integrity Violation** demonstration (`ERROR 1452 (23000)`).
  - Output 4: **`ON DELETE SET NULL`** demonstration when deleting parent categories.
  - Output 5: **`ON DELETE CASCADE`** demonstration when deleting parent customers.

👉 [Explore Experiment 5 Details](./experiment-5/)

---

### [Experiment 6: Stored Procedures & Triggers with Error Handling and Audit Logging](./experiment-6/)
- **Attached Lab Submission**: Includes original submission [`EXPERIMENT_DBMS_06.pdf`](./experiment-6/EXPERIMENT_DBMS_06.pdf).
- **Stored Procedure with Error Handling**: `transfer_employee(emp_id, new_dept_id)` checking employee and department existence and raising custom exceptions via `SIGNAL SQLSTATE '45000'`.
- **Edge Cases Tested**:
  - Non-existent employee (`Emp_ID = 666` $\to$ `ERROR 1644: Employee does not exist`).
  - Non-existent department (`Dept_ID = 666` $\to$ `ERROR 1644: Department does not exist`).
- **Data Validation Trigger**: `before_employee_salary_update` preventing negative salaries (`NEW.Salary < 0`).
- **Audit Logging Trigger**: `after_employee_salary_update` recording historical salary changes into `Salary_Audit` table (`OLD.Salary <> NEW.Salary`).

👉 [Explore Experiment 6 Details](./experiment-6/)

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

4. **Run Experiment 5 (E-Commerce Platform Relational Schema & Constraints)**:
   ```bash
   mysql -u <username> -p < experiment-5/experiment_5.sql
   ```

5. **Run Experiment 6 (Stored Procedures & Triggers with Error Handling)**:
   ```bash
   mysql -u <username> -p CompanyDB < experiment-6/experiment_6.sql
   ```

---

## 👤 Author
- **Author**: Hardik Maurya
- **Subject**: Database Management Systems (DBMS) Laboratory


