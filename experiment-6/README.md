# Experiment 6: Stored Procedures & Triggers with Error Handling and Audit Logging

> **DBMS Laboratory**

---

## 📌 Attached Lab Submission
📄 **Original Lab Submission PDF**: [EXPERIMENT_DBMS_06.pdf](./EXPERIMENT_DBMS_06.pdf)

---

## 🎯 Aim
To create a stored procedure `transfer_employee(emp_id, new_dept_id)` with validation and custom error handling using `SIGNAL SQLSTATE '45000'`, and to implement triggers for salary business-rule validation (`BEFORE UPDATE`) and audit logging (`AFTER UPDATE`), including testing edge cases.

---

## 📖 Theoretical Concepts

### 1. Stored Procedures
A stored procedure is a prepared SQL code segment that you can save and reuse. Stored procedures reduce network traffic, provide centralized business logic, and allow programmatic error handling via `SIGNAL SQLSTATE`.

### 2. Custom Error Handling (`SIGNAL SQLSTATE '45000'`)
The `SIGNAL` statement is used in MySQL to raise a custom exception condition. 
- **`SQLSTATE '45000'`** represents a generic user-defined unhandled exception.
- **`MESSAGE_TEXT`** specifies the readable error message returned to the calling client.

### 3. Database Triggers
Triggers are specialized stored programs automatically executed by the MySQL engine in response to specific DML events (`INSERT`, `UPDATE`, `DELETE`) on a particular table:
- **`BEFORE UPDATE` (Data Integrity / Validation Trigger)**: Intercepts the row modification before changes are written to the database disk. If invalid values are found (e.g., negative salary), `SIGNAL` aborts the transaction.
- **`AFTER UPDATE` (Audit Logging Trigger)**: Fires after the row modification succeeds. Uses pseudo-records `OLD.col_name` and `NEW.col_name` to record historical changes in a separate audit table (`Salary_Audit`).

---

## 🛠️ Execution Guide

Execute the complete experiment script using the MySQL client:

```bash
mysql -u <username> -p < experiment-6/experiment_6.sql
```

Enter your MySQL password when prompted.

---

## 📝 SQL Source Code & Breakdown

### 1. Schema Definition & Sample Data

```sql
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

INSERT INTO Department VALUES (1, 'Sales'), (2, 'Engineering');
INSERT INTO Employee VALUES (1, 'Alex', 60000.00, 1);
```

---

### 2. Stored Procedure: `transfer_employee`

Validates that both the employee and target department exist before performing the update. If either does not exist, an exception is thrown:

```sql
DELIMITER $$
CREATE PROCEDURE transfer_employee(
    IN p_emp_id INT,
    IN p_new_dept_id INT
)
BEGIN
    DECLARE emp_count INT DEFAULT 0;
    DECLARE dept_count INT DEFAULT 0;

    -- Validate employee existence
    SELECT COUNT(*) INTO emp_count
    FROM Employee
    WHERE Emp_ID = p_emp_id;

    -- Validate department existence
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
```

---

### 3. Validation Trigger: `before_employee_salary_update`

Ensures that salaries cannot be set to negative values:

```sql
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
```

---

### 4. Audit Logging Trigger: `after_employee_salary_update`

Logs salary adjustments to `Salary_Audit` whenever `OLD.Salary <> NEW.Salary`:

```sql
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
```

---

## 📊 Test Cases & Output Demonstrations

### Test Case 1: Valid Employee Transfer
Transfer employee `1` from Department `1` (Sales) to Department `2` (Engineering):

```sql
CALL transfer_employee(1, 2);
SELECT * FROM Employee WHERE Emp_ID = 1;
```

**Output**:
```text
+--------+----------+----------+---------+
| Emp_ID | Emp_Name | Salary   | Dept_ID |
+--------+----------+----------+---------+
|      1 | Alex     | 60000.00 |       2 |
+--------+----------+----------+---------+
1 row in set
```

---

### Test Case 2: Edge Case – Invalid Employee ID
Attempting to transfer a non-existent employee (`Emp_ID = 666`):

```sql
CALL transfer_employee(666, 2);
```

**Observed Result**:
```text
ERROR 1644 (45000): Employee does not exist
```

---

### Test Case 3: Edge Case – Invalid Department ID
Attempting to transfer employee `1` to non-existent Department `666`:

```sql
CALL transfer_employee(1, 666);
```

**Observed Result**:
```text
ERROR 1644 (45000): Department does not exist
```

---

### Test Case 4: Edge Case – Negative Salary Validation Trigger
Attempting to update employee salary to a negative value (`-5000`):

```sql
UPDATE Employee SET Salary = -5000 WHERE Emp_ID = 1;
```

**Observed Result**:
```text
ERROR 1644 (45000): Salary cannot be negative
```

---

### Test Case 5: Valid Salary Modification & Automatic Audit Logging
Updating employee `1`'s salary to `65000.00`:

```sql
UPDATE Employee SET Salary = 65000 WHERE Emp_ID = 1;
```

Checking `Salary_Audit` table:
```sql
SELECT * FROM Salary_Audit;
```

**Output**:
```text
+----------+--------+------------+------------+---------------------+
| Audit_ID | Emp_ID | Old_Salary | New_Salary | Changed_At          |
+----------+--------+------------+------------+---------------------+
|        1 |      1 |   60000.00 |   65000.00 | 2026-10-14 05:32:46 |
+----------+--------+------------+------------+---------------------+
1 row in set
```

Verifying `Employee` record:
```sql
SELECT Emp_ID, Emp_Name, Salary FROM Employee WHERE Emp_ID = 1;
```

**Output**:
```text
+--------+----------+----------+
| Emp_ID | Emp_Name | Salary   |
+--------+----------+----------+
|      1 | Alex     | 65000.00 |
+--------+----------+----------+
1 row in set
```

---

## 🎯 Summary & Key Takeaways
- **Validation**: Enforcing pre-conditions in stored procedures prevents invalid foreign keys or logic errors.
- **Transactional Safety**: Using `SIGNAL` in `BEFORE` triggers halts modifications and avoids corrupted state.
- **Auditability**: `AFTER` triggers automate non-repudiation audit trails without polluting application code.
