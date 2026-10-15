# Experiment 2: Advanced SQL Queries and Execution Plans

> **DBMS Laboratory**

---

## Aim
To perform advanced SQL queries on the `Employee`–`Department`–`Project` database using **INNER JOIN**, **LEFT JOIN**, **SELF JOIN**, **multi-table joins**, **correlated subqueries**, **EXISTS**, **simulated INTERSECT** and **EXCEPT** operations, and to compare query execution plans using **`EXPLAIN`**.

---

## Software / Requirements
- **DBMS**: MySQL 8.0 or later / MySQL Workbench
- **Database**: `CompanyDB` (created in Experiment 1)
- **Tables**: `Department`, `Employee`, `Project`, and `Employee_Project`

---

## Theory
- **SQL Joins**: Joins combine rows from two or more tables based on related columns.
  - **INNER JOIN**: Returns only matching rows from both tables based on join condition.
  - **LEFT JOIN**: Preserves all rows from the left table and matches rows from the right table (NULL if no match).
  - **SELF JOIN**: A table is joined with itself using aliases.
  - **Multi-Table Joins**: Joins more than two tables, often using bridge/junction tables for $M:N$ relationships.
- **Subqueries**: Allow one query to use the result of another query.
  - **Correlated Subquery**: Evaluates once per candidate row of the outer query, referencing outer column values.
  - **EXISTS / NOT EXISTS**: Tests whether a subquery returns any rows (evaluates to boolean `TRUE`/`FALSE`).
- **Set Operations Simulation**:
  - **INTERSECT**: Simulated in MySQL using `INNER JOIN` between two subqueries.
  - **EXCEPT / MINUS**: Simulated using `NOT EXISTS` or `LEFT JOIN ... WHERE right.key IS NULL`.
- **EXPLAIN**: Displays the execution plan selected by MySQL query optimizer, revealing access types (`ALL`, `ref`, `eq_ref`), indexes used, rows scanned, and filtering efficiency.

---

## Database Schema

```
+------------------+         +------------------+         +----------------------+         +------------------+
|    Department    |         |     Employee     |         |   Employee_Project   |         |     Project      |
+------------------+         +------------------+         +----------------------+         +------------------+
| Dept_ID (PK)     |<---+    | Emp_ID (PK)      |<---+    | Emp_ID (PK, FK)      |    +--->| Project_ID (PK)  |
| Dept_Name        |    +----| Dept_ID (FK)     |    +----| Project_ID (PK, FK)  |----+    | Project_Name     |
+------------------+         | Emp_Name         |         +----------------------+         +------------------+
                             | Job_Title        |
                             | Salary           |
                             +------------------+
```

---

## Queries & Demonstrations

### 1. INNER JOIN
Display employees along with the departments to which they belong.

```sql
SELECT e.Emp_ID,
       e.Emp_Name,
       e.Job_Title,
       d.Dept_Name
FROM Employee e
INNER JOIN Department d 
ON e.Dept_ID = d.Dept_ID;
```
> **Explanation**: Returns only those employees who have a matching department record.

#### Sample Output:
| Emp_ID | Emp_Name | Job_Title | Dept_Name |
| :--- | :--- | :--- | :--- |
| 101 | Aarav Sharma | AI Engineer | Artificial Intelligence |
| 102 | Priya Verma | ML Engineer | Artificial Intelligence |
| 103 | Rohan Gupta | AI Developer | Artificial Intelligence |
| 104 | Ananya Singh | Research Engineer | Artificial Intelligence |
| 105 | Karan Mehta | ML Engineer | Artificial Intelligence |
| 106 | Neha Kapoor | AI Analyst | Artificial Intelligence |
| 107 | Rahul Kumar | Software Engineer | Software Development |
| 108 | Sneha Patel | Backend Developer | Software Development |
| 109 | Aditya Jain | Frontend Developer | Software Development |
| 110 | Simran Kaur | Full Stack Developer | Software Development |
| 111 | Vivek Mishra | Software Engineer | Software Development |
| 112 | Ishita Rao | QA Engineer | Software Development |
| 113 | Arjun Malhotra | Security Engineer | Cyber Security |
| 114 | Megha Joshi | Cyber Security Analyst | Cyber Security |
| 115 | Yash Thakur | Security Consultant | Cyber Security |
| 116 | Pooja Nair | SOC Analyst | Cyber Security |

---

### 2. LEFT JOIN
Display all departments and their employees, including departments with no matching employee.

```sql
SELECT d.Dept_ID,
       d.Dept_Name,
       e.Emp_Name
FROM Department d 
LEFT JOIN Employee e
ON d.Dept_ID = e.Dept_ID;
```
> **Explanation**: Preserves every row from `Department` (the left table) even if no employees are assigned.

---

### 3. SELF JOIN
Find pairs of employees who work in the same department.

```sql
SELECT e1.Emp_Name AS Employee_1, 
       e2.Emp_Name AS Employee_2, 
       e1.Dept_ID
FROM Employee e1 
INNER JOIN Employee e2
ON e1.Dept_ID = e2.Dept_ID 
AND e1.Emp_ID < e2.Emp_ID;
```
> **Explanation**: The condition `e1.Emp_ID < e2.Emp_ID` eliminates duplicate mirrored pairs (e.g., A-B vs B-A) and avoids matching an employee with themselves.

#### Sample Output:
| Employee_1 | Employee_2 | Dept_ID |
| :--- | :--- | :--- |
| Aarav Sharma | Priya Verma | 1 |
| Aarav Sharma | Rohan Gupta | 1 |
| Aarav Sharma | Ananya Singh | 1 |
| Aarav Sharma | Karan Mehta | 1 |
| Aarav Sharma | Neha Kapoor | 1 |
| Priya Verma | Rohan Gupta | 1 |
| Priya Verma | Ananya Singh | 1 |
| Priya Verma | Karan Mehta | 1 |
| Priya Verma | Neha Kapoor | 1 |
| Rahul Kumar | Sneha Patel | 2 |

---

### 4. Multi-Table / 3-Way Join
Display employee name, department name, and project name.

```sql
SELECT e.Emp_Name,
       d.Dept_Name, 
       p.Project_Name
FROM Employee e
INNER JOIN Department d 
ON e.Dept_ID = d.Dept_ID
INNER JOIN Employee_Project ep 
ON e.Emp_ID = ep.Emp_ID
INNER JOIN Project p
ON ep.Project_ID = p.Project_ID;
```
> **Explanation**: Joins `Employee`, `Department`, `Employee_Project` (bridge table), and `Project` to resolve the $M:N$ employee-to-project relationship.

#### Sample Output:
| Emp_Name | Dept_Name | Project_Name |
| :--- | :--- | :--- |
| Aarav Sharma | Artificial Intelligence | AI Recommendation System |
| Priya Verma | Artificial Intelligence | AI Recommendation System |
| Ananya Singh | Artificial Intelligence | AI Recommendation System |
| Rohan Gupta | Artificial Intelligence | Computer Vision Platform |
| Karan Mehta | Artificial Intelligence | Computer Vision Platform |
| Neha Kapoor | Artificial Intelligence | Computer Vision Platform |
| Rahul Kumar | Software Development | E-Commerce Platform |
| Sneha Patel | Software Development | E-Commerce Platform |
| Simran Kaur | Software Development | E-Commerce Platform |
| Aditya Jain | Software Development | Mobile Banking Application |
| Vivek Mishra | Software Development | Mobile Banking Application |
| Ishita Rao | Software Development | Mobile Banking Application |
| Arjun Malhotra | Cyber Security | Cyber Threat Detection |
| Megha Joshi | Cyber Security | Cyber Threat Detection |
| Dev Patel | Cyber Security | Cyber Threat Detection |
| Yash Thakur | Cyber Security | Security Monitoring System |
| Pooja Nair | Cyber Security | Security Monitoring System |

---

### 5. Correlated Subquery
Find employees whose salary is greater than the average salary of their own department.

```sql
SELECT e.Emp_ID,
       e.Emp_Name, 
       e.Salary, 
       e.Dept_ID
FROM Employee e 
WHERE e.Salary > (
    SELECT AVG(e2.Salary) 
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
);
```
> **Explanation**: The inner query executes dynamically for each employee row from the outer query, computing the average for that specific employee's department.

#### Sample Output:
| Emp_ID | Emp_Name | Salary | Dept_ID |
| :--- | :--- | :--- | :--- |
| 102 | Priya Verma | 92000.00 | 1 |
| 104 | Ananya Singh | 105000.00 | 1 |
| 105 | Karan Mehta | 88000.00 | 1 |
| 108 | Sneha Patel | 82000.00 | 2 |
| 110 | Simran Kaur | 95000.00 | 2 |
| 111 | Vivek Mishra | 78000.00 | 2 |
| 113 | Arjun Malhotra | 90000.00 | 3 |
| 115 | Yash Thakur | 98000.00 | 3 |
| 117 | Dev Patel | 87000.00 | 3 |
| 118 | Tanvi Shah | 91000.00 | 3 |
| 119 | Akash Singh | 100000.00 | 4 |
| 121 | Mohit Agarwal | 95000.00 | 4 |
| 123 | Nikhil Bansal | 89000.00 | 4 |
| 125 | Manish Verma | 85000.00 | 5 |
| 129 | Varun Gupta | 73000.00 | 5 |

---

### 6. EXISTS
Find departments that have at least one employee earning more than ₹100,000.

```sql
SELECT d.Dept_ID,
       d.Dept_Name
FROM Department d 
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.Dept_ID = d.Dept_ID 
    AND e.Salary > 100000
);
```
> **Explanation**: Returns the department if at least one matching employee row exists with `Salary > 100000`.

#### Sample Output:
| Dept_ID | Dept_Name |
| :--- | :--- |
| 1 | Artificial Intelligence |

---

### 7. Simulated INTERSECT
Find employees who earn more than ₹80,000 and belong to either the AI or Data Science department.

```sql
SELECT a.Emp_ID,
       a.Emp_Name
FROM 
(
    SELECT Emp_ID, Emp_Name 
    FROM Employee
    WHERE Salary > 80000
) a
INNER JOIN 
(
    SELECT Emp_ID, Emp_Name 
    FROM Employee
    WHERE Dept_ID IN (1, 4)
) b
ON a.Emp_ID = b.Emp_ID;
```
> **Explanation**: Simulates set intersection ($A \cap B$) by performing an `INNER JOIN` between two independent result subsets on `Emp_ID`.

#### Sample Output:
| Emp_ID | Emp_Name |
| :--- | :--- |
| 101 | Aarav Sharma |
| 102 | Priya Verma |
| 104 | Ananya Singh |
| 105 | Karan Mehta |
| 119 | Akash Singh |
| 121 | Mohit Agarwal |
| 123 | Nikhil Bansal |

---

### 8. Simulated EXCEPT
Find employees who earn more than ₹80,000 but are not in the Cyber Security department.

```sql
SELECT e.Emp_ID,
       e.Emp_Name 
FROM Employee e
WHERE e.Salary > 80000 
AND NOT EXISTS (
    SELECT 1
    FROM Employee e2
    WHERE e2.Emp_ID = e.Emp_ID 
    AND e2.Dept_ID = 3
);
```
> **Explanation**: Simulates set difference ($A \setminus B$) using `NOT EXISTS` to exclude rows belonging to Department 3.

#### Sample Output:
| Emp_ID | Emp_Name |
| :--- | :--- |
| 101 | Aarav Sharma |
| 102 | Priya Verma |
| 104 | Ananya Singh |
| 105 | Karan Mehta |
| 108 | Sneha Patel |
| 110 | Simran Kaur |
| 119 | Akash Singh |
| 121 | Mohit Agarwal |
| 123 | Nikhil Bansal |
| 125 | Manish Verma |

---

### 9. EXPLAIN — Execution Plan Analysis

#### Query 1: Simple Selection
```sql
EXPLAIN 
SELECT *
FROM Employee
WHERE Salary > 90000;
```

#### Query 2: INNER JOIN
```sql
EXPLAIN
SELECT e.Emp_Name,
       d.Dept_Name 
FROM Employee e
INNER JOIN Department d 
ON e.Dept_ID = d.Dept_ID;
```

#### Query 3: Correlated Subquery
```sql
EXPLAIN
SELECT e.Emp_ID,
       e.Emp_Name, 
       e.Salary
FROM Employee e 
WHERE e.Salary > (
    SELECT AVG(e2.Salary) 
    FROM Employee e2
    WHERE e2.Dept_ID = e.Dept_ID
);
```

#### Query 4: EXISTS
```sql
EXPLAIN
SELECT d.Dept_Name 
FROM Department d 
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.Dept_ID = d.Dept_ID 
    AND e.Salary > 100000
);
```

---

## Result
The `Employee`–`Department`–`Project` database was successfully queried using `INNER JOIN`, `LEFT JOIN`, `SELF JOIN`, multi-table joins, correlated subqueries, `EXISTS`, and simulated `INTERSECT` and `EXCEPT` operations. Execution plans for selected queries were examined using `EXPLAIN` and their plan characteristics were recorded for comparison.
