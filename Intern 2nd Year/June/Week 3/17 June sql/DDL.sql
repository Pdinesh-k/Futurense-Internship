-- Create Database
CREATE DATABASE CompanyDB;

-- Use the Database
USE CompanyDB;

-- Create Table Employees
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    BirthDate DATE,
    HireDate DATE
);

-- Create Table Departments
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

-- Create Table Projects
CREATE TABLE Projects (
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    StartDate DATE,
    EndDate DATE
);

-- Create Table EmployeeProjects
CREATE TABLE EmployeeProjects (
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ProjectID) REFERENCES Projects(ProjectID)
);

-- Add Column to Employees
ALTER TABLE Employees
ADD Email VARCHAR(100);

-- Modify Column in Employees
ALTER TABLE Employees
MODIFY Email VARCHAR(150);

-- Drop Column from Employees
ALTER TABLE Employees
DROP COLUMN Email;

-- Rename Table
ALTER TABLE EmployeeProjects
RENAME TO EmpProjects;

-- Create Index
CREATE INDEX idx_lastname
ON Employees (LastName);

-- Drop Index
DROP INDEX idx_lastname
ON Employees;
