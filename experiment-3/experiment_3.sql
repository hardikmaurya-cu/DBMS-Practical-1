-- =====================================================================
-- DBMS Lab – Experiment 3
-- Topic: SQL Views, View Updatability and Recursive CTE
-- Database: CompanyDB
-- =====================================================================

USE CompanyDB;

-- ---------------------------------------------------------------------
-- 1. Extend the Employee Schema for Reporting Hierarchy
-- Add a Manager_ID column that references Emp_ID in the same Employee table.
-- ---------------------------------------------------------------------
ALTER TABLE Employee
ADD COLUMN Manager_ID INT NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_employee_manager
FOREIGN KEY (Manager_ID) REFERENCES Employee(Emp_ID);

-- Assign sample reporting relationships:

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

-- ---------------------------------------------------------------------
-- 2. Create Department Salary Summary View
-- Observation: Contains GROUP BY and aggregate functions; not directly updatable.
-- ---------------------------------------------------------------------
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

-- Display the view:
SELECT * FROM Department_Salary_Summary;

-- ---------------------------------------------------------------------
-- 3. Create Employee Hierarchy View
-- ---------------------------------------------------------------------
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

-- Display the hierarchy view:
SELECT *
FROM Employee_Hierarchy
ORDER BY Dept_ID, Manager_ID, Emp_ID;

-- ---------------------------------------------------------------------
-- 4. Test Updatability of a Simple View
-- ---------------------------------------------------------------------
CREATE OR REPLACE VIEW Employee_Basic AS
SELECT Emp_ID, Emp_Name, Job_Title, Salary, Dept_ID 
FROM Employee;

-- Test an update through the simple view:
UPDATE Employee_Basic 
SET Salary = 86000 
WHERE Emp_ID = 101;

-- Verify the base table:
-- Expected observation: the update succeeds because Employee_Basic is a simple projection of one base table.
SELECT Emp_ID, Emp_Name, Salary 
FROM Employee
WHERE Emp_ID = 101;

-- ---------------------------------------------------------------------
-- 5. Test Updatability of the Aggregate View
-- Expected observation: MySQL rejects the update because the view contains GROUP BY and aggregate functions.
-- Error: ERROR 1288 (HY000): The target table Department_Salary_Summary of the UPDATE is not updatable
-- ---------------------------------------------------------------------
-- UPDATE Department_Salary_Summary 
-- SET Average_Salary = 90000 
-- WHERE Dept_ID = 1;

-- ---------------------------------------------------------------------
-- 6. Test Updatability of the Employee Hierarchy View
-- Expected observation: The update is rejected because Manager_Name is derived from a joined table and the view is not directly updatable as a whole.
-- ---------------------------------------------------------------------
-- UPDATE Employee_Hierarchy
-- SET Manager_Name = 'Priya Verma' 
-- WHERE Emp_ID = 103;

-- ---------------------------------------------------------------------
-- 7. Inspect View Definitions
-- ---------------------------------------------------------------------
SHOW CREATE VIEW Department_Salary_Summary; 
SHOW CREATE VIEW Employee_Hierarchy;
SHOW CREATE VIEW Employee_Basic;

-- ---------------------------------------------------------------------
-- 8. Recursive CTE to Display Reporting Chains
-- The anchor member selects top-level employees with no manager.
-- The recursive member repeatedly finds employees whose Manager_ID matches an employee already found.
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 9. Recursive CTE for One Reporting Tree (Rooted at Emp_ID = 101)
-- ---------------------------------------------------------------------
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

-- ---------------------------------------------------------------------
-- 10. Recursive CTE with Hierarchy Indentation
-- ---------------------------------------------------------------------
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
       CONCAT(REPEAT(' ', Level), Emp_Name) AS Employee_Hierarchy, 
       Level
FROM EmployeeTree
ORDER BY Level, Emp_ID;

-- ---------------------------------------------------------------------
-- 11. Verify Reporting Relationships
-- ---------------------------------------------------------------------
SELECT e.Emp_Name AS Employee, 
       m.Emp_Name AS Manager
FROM Employee e
LEFT JOIN Employee m ON e.Manager_ID = m.Emp_ID 
ORDER BY e.Emp_ID;
