# Experiment 3: SQL Views, View Updatability and Recursive CTE

> **DBMS Laboratory**

---

## Aim
To create SQL views for department salary summary and employee hierarchy, test the updatability of views, and implement a recursive Common Table Expression (CTE) to display employee reporting chains.

---

## Software / Requirements
- **DBMS**: MySQL 8.0 or later
- **Interface**: MySQL Workbench / MySQL CLI
- **Database**: `CompanyDB` (created in Experiments 1 and 2)

---

## Theory
- **SQL View**: A view is a virtual table based on the result-set of an SQL statement. Views simplify complex queries, encapsulate business logic, and provide role-based security access without storing duplicate data.
- **View Updatability**:
  - A view is **updatable** if the DBMS can unambiguously trace an UPDATE, INSERT, or DELETE back to corresponding rows in a single base table.
  - Views that include aggregate functions (`SUM`, `AVG`, `COUNT`, `MIN`, `MAX`), `GROUP BY`, `DISTINCT`, `HAVING`, or `UNION` are **non-updatable** because their rows represent aggregated summaries rather than distinct rows of a base table.
  - Views spanning multiple joined tables have strict updatability limits and generally cannot update joined/derived columns simultaneously.
- **Recursive Common Table Expression (CTE)**:
  - Formulated using `WITH RECURSIVE`.
  - Consists of two parts connected by `UNION ALL`:
    1. **Anchor Member**: The base query executed once to produce the initial result set (e.g., top-level managers with `Manager_ID IS NULL`).
    2. **Recursive Member**: References the CTE name itself to iteratively join subsequent hierarchy levels until no new rows are produced.

---

## Step-by-Step Implementation

### 1. Extend the Employee Schema for Reporting Hierarchy
Add a `Manager_ID` self-referencing foreign key column in `Employee`:

```sql
USE CompanyDB;

ALTER TABLE Employee
ADD COLUMN Manager_ID INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID);
```

Assign sample reporting relationships:

```sql
-- Artificial Intelligence
UPDATE Employee SET Manager_ID = NULL WHERE Emp_ID = 101; 
UPDATE Employee SET Manager_ID = 101 WHERE Emp_ID IN (102, 103); 
UPDATE Employee SET Manager_ID = 102 WHERE Emp_ID IN (104, 105); 
UPDATE Employee SET Manager_ID = 103 WHERE Emp_ID = 106;

-- Software Development
UPDATE Employee SET Manager_ID = NULL WHERE Emp_ID = 110; 
UPDATE Employee SET Manager_ID = 110 WHERE Emp_ID IN (107, 108); 
UPDATE Employee SET Manager_ID = 107 WHERE Emp_ID IN (109, 111); 
UPDATE Employee SET Manager_ID = 108 WHERE Emp_ID = 112;

-- Cyber Security
UPDATE Employee SET Manager_ID = NULL WHERE Emp_ID = 115; 
UPDATE Employee SET Manager_ID = 115 WHERE Emp_ID IN (113, 114); 
UPDATE Employee SET Manager_ID = 113 WHERE Emp_ID IN (117, 118); 
UPDATE Employee SET Manager_ID = 114 WHERE Emp_ID = 116;

-- Data Science
UPDATE Employee SET Manager_ID = NULL WHERE Emp_ID = 119; 
UPDATE Employee SET Manager_ID = 119 WHERE Emp_ID IN (120, 121);
UPDATE Employee SET Manager_ID = 120 WHERE Emp_ID IN (122, 123); 
UPDATE Employee SET Manager_ID = 121 WHERE Emp_ID = 124;

-- Human Resources
UPDATE Employee SET Manager_ID = NULL WHERE Emp_ID = 125; 
UPDATE Employee SET Manager_ID = 125 WHERE Emp_ID IN (126, 129);
UPDATE Employee SET Manager_ID = 126 WHERE Emp_ID IN (127, 128, 130);
```

---

### 2. Create Department Salary Summary View (Aggregate View)

```sql
CREATE OR REPLACE VIEW Department_Salary_Summary AS 
SELECT d.Dept_ID,
       d.Dept_Name,
       COUNT(e.Emp_ID) AS Employee_Count, 
       SUM(e.Salary) AS Total_Salary, 
       AVG(e.Salary) AS Average_Salary, 
       MIN(e.Salary) AS Minimum_Salary, 
       MAX(e.Salary) AS Maximum_Salary
FROM Department d
LEFT JOIN Employee e ON d.Dept_ID = e.Dept_ID 
GROUP BY d.Dept_ID, d.Dept_Name;

-- Query the view:
SELECT * FROM Department_Salary_Summary;
```

#### Output:
| Dept_ID | Dept_Name | Employee_Count | Total_Salary | Average_Salary | Minimum_Salary | Maximum_Salary |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 1 | Artificial Intelligence | 6 | 520000.00 | 86666.666667 | 72000.00 | 105000.00 |
| 2 | Software Development | 6 | 465000.00 | 77500.000000 | 65000.00 | 95000.00 |
| 3 | Cyber Security | 6 | 516000.00 | 86000.000000 | 68000.00 | 98000.00 |
| 4 | Data Science | 6 | 506000.00 | 84333.333333 | 72000.00 | 100000.00 |
| 5 | Human Resources | 6 | 403000.00 | 67166.666667 | 58000.00 | 85000.00 |

> **Observation**: This view contains `GROUP BY` and aggregate functions (`SUM`, `AVG`, etc.), hence it is **not directly updatable**.

---

### 3. Create Employee Hierarchy View (Join View)

```sql
CREATE OR REPLACE VIEW Employee_Hierarchy AS 
SELECT e.Emp_ID,
       e.Emp_Name AS Employee_Name, 
       e.Job_Title,
       e.Dept_ID, 
       d.Dept_Name, 
       e.Manager_ID,
       m.Emp_Name AS Manager_Name
FROM Employee e
LEFT JOIN Department d ON e.Dept_ID = d.Dept_ID 
LEFT JOIN Employee m ON e.Manager_ID = m.Emp_ID;

-- Query the hierarchy view:
SELECT *
FROM Employee_Hierarchy
ORDER BY Dept_ID, Manager_ID, Emp_ID;
```

#### Sample Output:
| Emp_ID | Employee_Name | Job_Title | Dept_ID | Dept_Name | Manager_ID | Manager_Name |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | Aarav Sharma | AI Engineer | 1 | Artificial Intelligence | NULL | NULL |
| 102 | Priya Verma | ML Engineer | 1 | Artificial Intelligence | 101 | Aarav Sharma |
| 103 | Rohan Gupta | AI Developer | 1 | Artificial Intelligence | 101 | Aarav Sharma |
| 104 | Ananya Singh | Research Engineer | 1 | Artificial Intelligence | 102 | Priya Verma |
| 105 | Karan Mehta | ML Engineer | 1 | Artificial Intelligence | 102 | Priya Verma |
| 106 | Neha Kapoor | AI Analyst | 1 | Artificial Intelligence | 103 | Rohan Gupta |
| 110 | Simran Kaur | Full Stack Developer | 2 | Software Development | NULL | NULL |
| 109 | Aditya Jain | Frontend Developer | 2 | Software Development | 107 | Rahul Kumar |

---

### 4. Test Updatability of a Simple View

```sql
CREATE OR REPLACE VIEW Employee_Basic AS
SELECT Emp_ID, Emp_Name, Job_Title, Salary, Dept_ID 
FROM Employee;

-- Test UPDATE through view:
UPDATE Employee_Basic 
SET Salary = 86000 
WHERE Emp_ID = 101;

-- Verify change on base table:
SELECT Emp_ID, Emp_Name, Salary 
FROM Employee
WHERE Emp_ID = 101;
```

| Emp_ID | Emp_Name | Salary |
| :--- | :--- | :--- |
| 101 | Aarav Sharma | 86000.00 |

> **Expected Observation**: The update **succeeds** because `Employee_Basic` is a 1-to-1 projection of a single underlying base table with no aggregates or joins.

---

### 5. Test Updatability of the Aggregate View

```sql
UPDATE Department_Salary_Summary 
SET Average_Salary = 90000 
WHERE Dept_ID = 1;
```

> **Expected Result / Error**:
> ```
> ERROR 1288 (HY000): The target table Department_Salary_Summary of the UPDATE is not updatable
> ```
> **Reason**: MySQL rejects the update because the view contains `GROUP BY` and calculated aggregate values that do not correspond to individual stored rows.

---

### 6. Test Updatability of the Employee Hierarchy View

```sql
UPDATE Employee_Hierarchy
SET Manager_Name = 'Priya Verma' 
WHERE Emp_ID = 103;
```

> **Expected Result / Error**:
> MySQL rejects the update because `Manager_Name` is derived from a joined table (`m.Emp_Name`), making modifying joined multi-table columns through the view invalid.

---

### 7. Inspect View Definitions

```sql
SHOW CREATE VIEW Department_Salary_Summary; 
SHOW CREATE VIEW Employee_Hierarchy;
SHOW CREATE VIEW Employee_Basic;
```

---

### 8. Recursive CTE to Display Reporting Chains

Traverses the reporting chain starting from root managers down through all levels:

```sql
WITH RECURSIVE EmployeeChain AS ( 
    SELECT
        e.Emp_ID, 
        e.Emp_Name, 
        e.Manager_ID,
        0 AS Level,
        CAST(e.Emp_Name AS CHAR(1000)) AS Reporting_Chain 
    FROM Employee e
    WHERE e.Manager_ID IS NULL

    UNION ALL

    SELECT
        e.Emp_ID, 
        e.Emp_Name, 
        e.Manager_ID, 
        ec.Level + 1,
        CONCAT(ec.Reporting_Chain, ' -> ', e.Emp_Name) 
    FROM Employee e
    INNER JOIN EmployeeChain ec
    ON e.Manager_ID = ec.Emp_ID
)
SELECT Emp_ID, Emp_Name, Manager_ID, Level, Reporting_Chain 
FROM EmployeeChain
ORDER BY Reporting_Chain;
```

---

### 9. Recursive CTE for One Specific Reporting Tree (Root: 101)

Traverses only the reporting tree beginning at Employee 101:

```sql
WITH RECURSIVE ReportingTree AS (
    SELECT Emp_ID, Emp_Name, Manager_ID, 0 AS Level 
    FROM Employee
    WHERE Emp_ID = 101 

    UNION ALL

    SELECT e.Emp_ID, e.Emp_Name, e.Manager_ID, rt.Level + 1 
    FROM Employee e
    INNER JOIN ReportingTree rt
    ON e.Manager_ID = rt.Emp_ID
)
SELECT Emp_ID, Emp_Name, Manager_ID, Level 
FROM ReportingTree
ORDER BY Level, Emp_ID;
```

---

### 10. Recursive CTE with Hierarchy Indentation

Displays the reporting structure with visual spaces indented according to hierarchy level:

```sql
WITH RECURSIVE EmployeeTree AS (
    SELECT Emp_ID, Emp_Name, Manager_ID, 0 AS Level 
    FROM Employee
    WHERE Manager_ID IS NULL 

    UNION ALL

    SELECT e.Emp_ID, e.Emp_Name, e.Manager_ID, et.Level + 1 
    FROM Employee e
    INNER JOIN EmployeeTree et
    ON e.Manager_ID = et.Emp_ID
)
SELECT Emp_ID,
       CONCAT(REPEAT('    ', Level), Emp_Name) AS Employee_Hierarchy, 
       Level
FROM EmployeeTree
ORDER BY Level, Emp_ID;
```

---

### 11. Verify Reporting Relationships

```sql
SELECT e.Emp_Name AS Employee, 
       m.Emp_Name AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.Manager_ID = m.Emp_ID 
ORDER BY e.Emp_ID;
```

---

## View Updatability Comparison Table

| View Name | Main Feature | Directly Updatable? | Reason |
| :--- | :--- | :---: | :--- |
| **`Employee_Basic`** | Single base table | **Yes\*** | Simple projection of `Employee` columns without transformations. |
| **`Department_Salary_Summary`** | `GROUP BY` + aggregates | **No** | Rows represent grouped/aggregated calculations, not single physical rows. |
| **`Employee_Hierarchy`** | Multiple-table `JOIN`s | **No** | Contains derived columns from joined tables that cannot be unambiguously updated. |

*\* Note: Subject to DBMS constraints such as NOT NULL columns without default values.*

---

## Important Observations
1. **Virtual Nature**: A view stores only query definitions, not physical duplicates of base data.
2. **Aggregates & Grouping**: Views with `GROUP BY` or aggregate functions are non-updatable.
3. **Single-Table Projection**: A simple 1-to-1 table projection without transformations can be directly updated.
4. **Recursive CTE Structure**: Composed of an anchor query and a recursive member combined with `UNION ALL`.
5. **Self-Referencing Foreign Key**: `Manager_ID` establishes a hierarchy inside the same table (`Employee`).
6. **Termination Condition**: The recursive CTE continues iteration until no further matching child records are found.

---

## Result
SQL views for department salary summary and employee hierarchy were successfully created. View updatability was tested using a simple view and non-updatable aggregate/join views. A recursive CTE was implemented to traverse employee-manager relationships and display reporting chains with hierarchy levels.
