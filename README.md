# DBMS Practical 1

A SQL practical that creates and populates a small company database, then runs example queries against its departments, employees, and projects.

## Requirements

- MySQL Server and the MySQL command-line client

## Run

From the repository directory, execute the script with a MySQL account that can create databases:

```sh
mysql -u <username> -p < file
```

Enter the account password when prompted. The script creates and selects the `CompanyDB` database, creates the tables, inserts sample records, and runs the queries. It is intended to be run once against a fresh database; running it again will fail because the database and tables already exist.

## Database Contents

- `Department`: five departments
- `Employee`: 30 employees, including job titles, salaries, hire dates, and department assignments
- `Project`: eight projects with budgets and department assignments
- `Employee_Project`: employee project assignments and hours worked

The 18 example queries cover filtering and sorting employees, salary aggregates, department-level counts and averages, and `CASE`-based salary and department categories.

## Verification

The SQL statements were executed successfully in SQLite in an in-memory database. SQLite does not support the MySQL `CREATE DATABASE` and `USE` statements, so they were omitted for this compatibility check:

```sh
sed '/^CREATE DATABASE CompanyDB;$/d; /^USE CompanyDB;$/d' file | sqlite3 -bail :memory:
```

The sample data contains 30 employees, and the total salary query returns `2410000`.
