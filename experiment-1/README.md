# Experiment 1: Company Database Creation, Population and Basic SQL Queries

> **DBMS Laboratory**

---

## Aim
To design, create, and populate a relational database schema (`CompanyDB`) containing `Department`, `Employee`, `Project`, and `Employee_Project` tables, and to perform basic SQL queries including filtering, aggregation, grouping, and conditional expressions (`CASE`).

---

## Requirements
- **DBMS**: MySQL Server 8.0 or later
- **Client**: MySQL Command Line Client / MySQL Workbench

---

## Database Contents
- `Department`: Five departments with location details.
- `Employee`: 30 employees across 5 departments with job titles, salaries, and hire dates.
- `Project`: Eight company projects with assigned budgets and managing departments.
- `Employee_Project`: Bridge table capturing many-to-many employee-to-project assignments and hours worked.

---

## Execution Guide

From the repository directory, execute the script with a MySQL account:

```bash
mysql -u <username> -p < experiment_1.sql
```

Enter your password when prompted. The script creates the `CompanyDB` database, builds all four tables, inserts the complete sample records, and executes the 18 example queries.

---

## Summary of Queries
1. High earners query (`Salary > 90000`)
2. Department-specific filtering (`Dept_ID = 1`)
3. Projection of employee names, salaries, and job titles
4. Aggregate functions: `AVG()`, `MAX()`, `MIN()`, `SUM()`, `COUNT()`
5. Group-level aggregations (`GROUP BY`, `HAVING`)
6. Conditional transformations (`CASE` statements for salary categories and department naming)
7. Sorting (`ORDER BY ASC`, `DESC`, multi-column ordering)

---

## Verification
The SQL statements were verified for syntactic correctness and schema integrity. Total salary expenditure across all 30 employees equals `2410000`.
