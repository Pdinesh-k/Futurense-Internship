-- Use the Database
USE CompanyDB;

-- Insert into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, BirthDate, HireDate)
VALUES (1, 'John', 'Doe', '1985-01-15', '2010-06-01');

-- Insert into Departments
INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'Human Resources');

-- Insert into Projects
INSERT INTO Projects (ProjectID, ProjectName, StartDate, EndDate)
VALUES (1, 'Project Alpha', '2023-01-01', '2023-12-31');

-- Insert Multiple Rows into Employees
INSERT INTO Employees (EmployeeID, FirstName, LastName, BirthDate, HireDate)
VALUES 
(2, 'Jane', 'Smith', '1990-02-20', '2012-08-15'),
(3, 'Michael', 'Brown', '1980-03-25', '2005-09-01');

-- Update Employee Record
UPDATE Employees
SET LastName = 'Johnson'
WHERE EmployeeID = 1;

-- Delete Employee Record
DELETE FROM Employees
WHERE EmployeeID = 3;

-- Select All Employees
SELECT * FROM Employees;

-- Select Specific Columns
SELECT FirstName, LastName
FROM Employees;

-- Join Employees and Departments
SELECT e.FirstName, e.LastName, d.DepartmentName
FROM Employees e
JOIN Departments d ON e.EmployeeID = d.DepartmentID;

-- Insert into EmployeeProjects
INSERT INTO EmpProjects (EmployeeID, ProjectID, HoursWorked)
VALUES (1, 1, 40);
