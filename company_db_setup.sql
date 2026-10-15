-- =====================================================================
-- CompanyDB Database Schema & Sample Dataset
-- Pre-requisite for DBMS Lab Experiments 2 & 3
-- =====================================================================

CREATE DATABASE IF NOT EXISTS CompanyDB;
USE CompanyDB;

-- Drop tables if they already exist (in reverse FK order)
DROP TABLE IF EXISTS Employee_Project;
DROP TABLE IF EXISTS Project;
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- ---------------------------------------------------------------------
-- 1. Department Table
-- ---------------------------------------------------------------------
CREATE TABLE Department (
    Dept_ID INT PRIMARY KEY,
    Dept_Name VARCHAR(100) NOT NULL
);

INSERT INTO Department (Dept_ID, Dept_Name) VALUES
(1, 'Artificial Intelligence'),
(2, 'Software Development'),
(3, 'Cyber Security'),
(4, 'Data Science'),
(5, 'Human Resources');

-- ---------------------------------------------------------------------
-- 2. Employee Table
-- ---------------------------------------------------------------------
CREATE TABLE Employee (
    Emp_ID INT PRIMARY KEY,
    Emp_Name VARCHAR(100) NOT NULL,
    Job_Title VARCHAR(100) NOT NULL,
    Salary DECIMAL(10, 2) NOT NULL,
    Dept_ID INT,
    CONSTRAINT fk_employee_dept FOREIGN KEY (Dept_ID) REFERENCES Department(Dept_ID)
);

INSERT INTO Employee (Emp_ID, Emp_Name, Job_Title, Salary, Dept_ID) VALUES
-- Dept 1: Artificial Intelligence (Total: 520,000 | Avg: 86,666.67)
(101, 'Aarav Sharma', 'AI Engineer', 85000.00, 1),
(102, 'Priya Verma', 'ML Engineer', 92000.00, 1),
(103, 'Rohan Gupta', 'AI Developer', 78000.00, 1),
(104, 'Ananya Singh', 'Research Engineer', 105000.00, 1),
(105, 'Karan Mehta', 'ML Engineer', 88000.00, 1),
(106, 'Neha Kapoor', 'AI Analyst', 72000.00, 1),

-- Dept 2: Software Development (Total: 465,000 | Avg: 77,500.00)
(107, 'Rahul Kumar', 'Software Engineer', 70000.00, 2),
(108, 'Sneha Patel', 'Backend Developer', 82000.00, 2),
(109, 'Aditya Jain', 'Frontend Developer', 75000.00, 2),
(110, 'Simran Kaur', 'Full Stack Developer', 95000.00, 2),
(111, 'Vivek Mishra', 'Software Engineer', 78000.00, 2),
(112, 'Ishita Rao', 'QA Engineer', 65000.00, 2),

-- Dept 3: Cyber Security (Total: 516,000 | Avg: 86,000.00)
(113, 'Arjun Malhotra', 'Security Engineer', 90000.00, 3),
(114, 'Megha Joshi', 'Cyber Security Analyst', 82000.00, 3),
(115, 'Yash Thakur', 'Security Consultant', 98000.00, 3),
(116, 'Pooja Nair', 'SOC Analyst', 68000.00, 3),
(117, 'Dev Patel', 'Security Specialist', 87000.00, 3),
(118, 'Tanvi Shah', 'Security Architect', 91000.00, 3),

-- Dept 4: Data Science (Total: 506,000 | Avg: 84,333.33)
(119, 'Akash Singh', 'Chief Data Scientist', 100000.00, 4),
(120, 'Kriti Sharma', 'Data Analyst', 76000.00, 4),
(121, 'Mohit Agarwal', 'Data Scientist', 95000.00, 4),
(122, 'Riya Das', 'Data Analyst', 74000.00, 4),
(123, 'Nikhil Bansal', 'ML Data Scientist', 89000.00, 4),
(124, 'Sakshi Roy', 'BI Analyst', 72000.00, 4),

-- Dept 5: Human Resources (Total: 403,000 | Avg: 67,166.67)
(125, 'Manish Verma', 'HR Manager', 85000.00, 5),
(126, 'Divya Mehta', 'HR Executive', 65000.00, 5),
(127, 'Suresh Kumar', 'Recruiter', 60000.00, 5),
(128, 'Ayesha Khan', 'HR Executive', 62000.00, 5),
(129, 'Varun Gupta', 'Training Manager', 73000.00, 5),
(130, 'Nandini Sharma', 'HR Analyst', 58000.00, 5);

-- ---------------------------------------------------------------------
-- 3. Project Table
-- ---------------------------------------------------------------------
CREATE TABLE Project (
    Project_ID INT PRIMARY KEY,
    Project_Name VARCHAR(100) NOT NULL
);

INSERT INTO Project (Project_ID, Project_Name) VALUES
(1, 'AI Recommendation System'),
(2, 'Computer Vision Platform'),
(3, 'E-Commerce Platform'),
(4, 'Mobile Banking Application'),
(5, 'Cyber Threat Detection'),
(6, 'Security Monitoring System');

-- ---------------------------------------------------------------------
-- 4. Employee_Project Bridge Table (Many-to-Many Relationship)
-- ---------------------------------------------------------------------
CREATE TABLE Employee_Project (
    Emp_ID INT,
    Project_ID INT,
    PRIMARY KEY (Emp_ID, Project_ID),
    CONSTRAINT fk_ep_emp FOREIGN KEY (Emp_ID) REFERENCES Employee(Emp_ID),
    CONSTRAINT fk_ep_project FOREIGN KEY (Project_ID) REFERENCES Project(Project_ID)
);

INSERT INTO Employee_Project (Emp_ID, Project_ID) VALUES
(101, 1),
(102, 1),
(104, 1),
(103, 2),
(105, 2),
(106, 2),
(107, 3),
(108, 3),
(110, 3),
(109, 4),
(111, 4),
(112, 4),
(113, 5),
(114, 5),
(117, 5),
(115, 6),
(116, 6);
