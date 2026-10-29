-- ============================================================================
-- EXPERIMENT 06: Stored Procedures & Triggers with Error Handling & Auditing
-- AIM: To create a stored procedure transfer_employee(emp_id, new_dept_id) with
--      validation and error handling, and to implement triggers for salary
--      validation and audit logging, including testing of edge cases.
-- ============================================================================

-- Use existing database or create sandbox
CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- ----------------------------------------------------------------------------
-- 1. CLEANUP & SCHEMA CREATION
-- ----------------------------------------------------------------------------
DROP TRIGGER IF EXISTS before_employee_salary_update;
DROP TRIGGER IF EXISTS after_employee_salary_update;
DROP PROCEDURE IF EXISTS transfer_employee;
DROP TABLE IF EXISTS Salary_Audit;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);

CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Salary DECIMAL(10,2) NOT NULL,
    Dept_ID INT,
    FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

CREATE TABLE Salary_Audit (
    Audit_ID INT AUTO_INCREMENT PRIMARY KEY,
    Emp_ID INT,
    Old_Salary DECIMAL(10,2),
    New_Salary DECIMAL(10,2),
    Changed_At TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ----------------------------------------------------------------------------
-- 2. SAMPLE DATA INSERTION
-- ----------------------------------------------------------------------------
INSERT INTO Department (Dept_ID, Dept_Name)
VALUES (1, 'Sales'), (2, 'Engineering');

INSERT INTO Employee (Emp_ID, Emp_Name, Salary, Dept_ID)
VALUES (1, 'Alex', 60000.00, 1);

-- ----------------------------------------------------------------------------
-- 3. STORED PROCEDURE: transfer_employee WITH ERROR HANDLING
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    DECLARE dept_count INT DEFAULT 0;

    -- Validate if employee exists
    SELECT COUNT(*) INTO emp_count
    FROM Employee
    WHERE Emp_ID = p_emp_id;

    -- Validate if target department exists
    SELECT COUNT(*) INTO dept_count
    FROM Department
    WHERE Dept_ID = p_new_dept_id;

    IF emp_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Employee does not exist';
    ELSEIF dept_count = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Department does not exist';
    ELSE
        UPDATE Employee
        SET Dept_ID = p_new_dept_id
        WHERE Emp_ID = p_emp_id;
    END IF;
END$$
DELIMITER ;

-- Successful Transfer Execution:
CALL transfer_employee(1, 2);
SELECT * FROM Employee WHERE Emp_ID = 1;

-- Edge Case Validations (Uncomment to test individually):
-- Test Case 1: Non-existent employee (Expected: Error 1644 (45000): Employee does not exist)
-- CALL transfer_employee(666, 2);

-- Test Case 2: Non-existent department (Expected: Error 1644 (45000): Department does not exist)
-- CALL transfer_employee(1, 666);

-- ----------------------------------------------------------------------------
-- 4. VALIDATION TRIGGER: before_employee_salary_update
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER before_employee_salary_update
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF NEW.Salary < 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Salary cannot be negative';
    END IF;
END$$
DELIMITER ;

-- Edge Case Test: Negative salary update (Uncomment to test):
-- Expected: Error 1644 (45000): Salary cannot be negative
-- UPDATE Employee SET Salary = -5000 WHERE Emp_ID = 1;

-- ----------------------------------------------------------------------------
-- 5. AUDIT LOGGING TRIGGER: after_employee_salary_update
-- ----------------------------------------------------------------------------
DELIMITER $$
CREATE TRIGGER after_employee_salary_update
AFTER UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF OLD.Salary <> NEW.Salary THEN
        INSERT INTO Salary_Audit (Emp_ID, Old_Salary, New_Salary)
        VALUES (OLD.Emp_ID, OLD.Salary, NEW.Salary);
    END IF;
END$$
DELIMITER ;

-- Valid Salary Update Execution:
UPDATE Employee SET Salary = 65000 WHERE Emp_ID = 1;

-- ----------------------------------------------------------------------------
-- 6. VERIFICATION OUTPUTS
-- ----------------------------------------------------------------------------
-- Check Audit Table for logged salary modification
SELECT * FROM Salary_Audit;

-- Display updated employee details
SELECT Emp_ID, Emp_Name, Salary, Dept_ID
FROM Employee
WHERE Emp_ID = 1;
