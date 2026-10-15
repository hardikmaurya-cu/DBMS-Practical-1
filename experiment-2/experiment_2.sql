-- =====================================================================
-- DBMS Lab – Experiment 2
-- Topic: Advanced SQL Queries and Execution Plans
-- Database: CompanyDB
-- =====================================================================

USE CompanyDB;

-- ---------------------------------------------------------------------
-- 1. INNER JOIN
-- Display employees along with the departments to which they belong.
-- INNER JOIN returns only those employees for whom a matching department exists.
-- ---------------------------------------------------------------------
SELECT e.Emp_ID,
       e.Emp_Name,
       e.Job_Title,
       d.Dept_Name
FROM Employee e
INNER JOIN Department d 
ON e.Dept_ID = d.Dept_ID;

-- ---------------------------------------------------------------------
-- 2. LEFT JOIN
-- Display all departments and their employees, including departments with no matching employee.
-- LEFT JOIN preserves every row from the left table, Department, even when no matching employee exists.
-- ---------------------------------------------------------------------
SELECT d.Dept_ID,
       d.Dept_Name,
       e.Emp_Name
FROM Department d 
LEFT JOIN Employee e
ON d.Dept_ID = e.Dept_ID;

-- ---------------------------------------------------------------------
-- 3. SELF JOIN
-- Find pairs of employees who work in the same department.
-- The condition e1.Emp_ID < e2.Emp_ID prevents duplicate pairs and prevents an employee from being paired with themself.
-- ---------------------------------------------------------------------
SELECT e1.Emp_Name AS Employee_1, 
       e2.Emp_Name AS Employee_2, 
       e1.Dept_ID
FROM Employee e1 
INNER JOIN Employee e2
ON e1.Dept_ID = e2.Dept_ID 
AND e1.Emp_ID < e2.Emp_ID;

-- ---------------------------------------------------------------------
-- 4. Multi-Table / 3-Way Join
-- Display employee name, department name, and project name.
-- Because Employee and Project have a many-to-many relationship, the Employee_Project bridge table is required.
-- Therefore, the physical query joins four tables.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 5. Correlated Subquery
-- Find employees whose salary is greater than the average salary of their own department.
-- The inner query is correlated because it refers to e.Dept_ID from the outer Employee query.
-- The department average is evaluated in relation to the current employee's department.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 6. EXISTS
-- Find departments that have at least one employee earning more than ₹100,000.
-- EXISTS evaluates to TRUE when the subquery returns at least one matching row.
-- ---------------------------------------------------------------------
SELECT d.Dept_ID,
       d.Dept_Name
FROM Department d 
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.Dept_ID = d.Dept_ID 
    AND e.Salary > 100000
);

-- ---------------------------------------------------------------------
-- 7. Simulated INTERSECT
-- Find employees who earn more than ₹80,000 and belong to either the AI or Data Science department.
-- The query demonstrates the intersection of two result sets using INNER JOIN.
-- The INNER JOIN keeps only employee IDs appearing in both result sets, thereby simulating INTERSECT.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 8. Simulated EXCEPT
-- Find employees who earn more than ₹80,000 but are not in the Cyber Security department.
-- NOT EXISTS removes rows for which a matching Cyber Security employee record is found, thereby simulating an EXCEPT operation.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 9. EXPLAIN — Execution Plan
-- EXPLAIN displays how MySQL plans to execute a SELECT statement.
-- Important columns include type, possible_keys, key, rows, and Extra.
-- ---------------------------------------------------------------------

-- Query 1: EXPLAIN for a simple selection
EXPLAIN 
SELECT *
FROM Employee
WHERE Salary > 90000;

-- Query 2: EXPLAIN for INNER JOIN
EXPLAIN
SELECT e.Emp_Name,
       d.Dept_Name 
FROM Employee e
INNER JOIN Department d 
ON e.Dept_ID = d.Dept_ID;

-- Query 3: EXPLAIN for correlated subquery
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

-- Query 4: EXPLAIN for EXISTS
EXPLAIN
SELECT d.Dept_Name 
FROM Department d 
WHERE EXISTS (
    SELECT 1
    FROM Employee e
    WHERE e.Dept_ID = d.Dept_ID 
    AND e.Salary > 100000
);
