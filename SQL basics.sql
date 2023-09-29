-- create new database
CREATE DATABASE practice;

-- use the current database
USE practice;

-- ------------------

/*Create a table named "Students" with the following columns: StudentID (int),
FirstName (varchar), LastName (varchar), and Age (int). */
CREATE TABLE Students (
	StudentID int,
    FirstName varchar(20),
    LastName varchar(20), 
    Age int );

-- insert values into Students table
INSERT INTO Students VALUES
	(1, "John", "Smith", 18),
    (2, "Ravi", "Kumar", 20),
    (3, "Maria", "Anders", 22),
    (4, "Hanna", "Moos", 19),
    (5, "Yang", "Wang", 20)
;

-- retrieve all the values
SELECT * 
FROM Students;

-- Update the age of the student with StudentID 1 to 21
UPDATE Students 
SET Age = 21 
WHERE StudentID = 1;

-- Delete the student with StudentID 3 from the "Students" table
DELETE FROM Students 
WHERE StudentID = 3;

-- Retrieve the first names and ages of all students who are older than 20
SELECT FirstName, Age 
FROM Students
WHERE Age > 20;

-- Delete records where age<18
DELETE FROM Students 
WHERE Age < 18;

-- -------------------------------

/*Create a table named "Customers" with the following columns and constraints: CustomerID (int) as the primary key.
FirstName (varchar) not null. LastName (varchar) not null. Email (varchar) unique. 
Age (int) check constraint to ensure age is greater than 18. */
CREATE TABLE Customers(
	CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Email VARCHAR(20) UNIQUE KEY,
    Age INT CHECK (Age>18)
);

-- Retrieve the names of customers from the "Customers" table who are not from the city 'New York' or 'Los Angeles'
ALTER TABLE Customers
ADD COLUMN City VARCHAR(20);

SELECT FirstName
FROM Customers
WHERE City NOT IN ('New York','Los Angeles');

/* Retrieve the names of customers from the "Customers" table who are not from the
city 'London' and either have a postal code starting with '1' or their country is not 'USA'.*/
ALTER TABLE Customers
ADD COLUMN PostalCode VARCHAR(20);

ALTER TABLE Customers
ADD COLUMN Country VARCHAR(20);

SELECT FirstName
FROM Customers
WHERE City != 'London' AND PostalCode LIKE '1%' OR Country!= 'USA';

-- --------------------

/* You have a table named "Orders" with columns: OrderID (int), CustomerID (int), OrderDate (date), 
and TotalAmount (decimal). Create a foreign key constraint on the "CustomerID" column referencing the "Customers" table */
CREATE TABLE Orders(
	OrderID INT, 
    CustomerID INT,
	OrderDate DATE, 
    TotalAmount DECIMAL
);

ALTER TABLE Orders
ADD CONSTRAINT FK_Customer
FOREIGN KEY(CustomerID) REFERENCES  Customers(CustomerID);

/* retrieve the order IDs and total amounts of orders placed by customer ID 1001 after January 1, 2023, or 
orders with a total amount exceeding $500 */
SELECT OrderID, TotalAmount
FROM Orders 
WHERE CustomerID = 1001 AND OrderDate = "2023-01-01" OR TotalAmount>500;

-- ---------------------

/* Create a table named "Employees" with columns: EmployeeID (int) as the primary key. FirstName (varchar) not null. 
LastName (varchar) not null. Salary (decimal) check constraint to ensure salary is between 20000 and 100000. */
CREATE TABLE Employees(
	EmployeeID INT PRIMARY KEY,
    FirstName VARCHAR(20) NOT NULL,
    LastName VARCHAR(20) NOT NULL,
    Salary DECIMAL CHECK (Salary BETWEEN 20000 AND 100000)
);

-- Consider a table named "Employees" with columns: EmployeeID, FirstName,LastName, and Age. 
ALTER TABLE Employees
ADD COLUMN Age INT;

-- Describe the structure of Employees table
DESC Employees;

-- retrieve the first name and last name of employees who are older than 30
SELECT Firstname, Lastname
FROM Employees
WHERE Age>30;

-- retrieve the first name, last name, and age of employees whose age is between 20 and 30.
SELECT Firstname, Lastname, Age
FROM Employees
WHERE Age BETWEEN 20 AND 30;

/* Retrieve the names of employees from the "Employees" table who are both from the
"Sales" department and have an age greater than 25, or they are from the "Marketing" department */

ALTER TABLE Employees
ADD COLUMN Department VARCHAR(20);

SELECT Firstname
FROM Employees
WHERE (Department="Sales" AND Age>25) OR Department="Marketing";

/* Retrieve the names of employees from the "Employees" table who are either from the "HR" department 
and have an age less than 30, or they are from the "Finance" department and have an age greater than or equal to 35 */
SELECT Firstname
FROM Employees
WHERE (Department="HR" AND Age<30) OR (Department="Finance" AND Age>=35);

-- ---------------

/* Given a table named "Products" with columns: ProductID, ProductName, Price, and
InStock (0- for out of stock, 1- for in stock). */
CREATE TABLE Products(
	ProductID INT PRIMARY KEY,
    ProductName VARCHAR(20), 
    Price DECIMAL,
    Instock BOOL
);

-- retrieve the product names and prices of products that are either priced above $100 or are out of stock
SELECT ProductName, Price 
FROM Products
WHERE Price>100 OR InStock=0;

-- retrieve the product names and prices of products that are in stock and priced between 50 and 150
SELECT ProductName, Price 
FROM Products
WHERE InStock=1 AND Price BETWEEN 50 AND 150;

/* Retrieve the ProductName of products from the "Products" table that have a price
between $50 and $100 */
SELECT ProductName
FROM Products
WHERE Price BETWEEN 50 AND 100;

-- ---------------

/* Create a table named "Books" with columns: BookID (int) as the primary key.
Title (varchar) not null. ISBN (varchar) unique. */
CREATE TABLE Books(
	BookID INT PRIMARY KEY,
    Title VARCHAR(20) NOT NULL,
    ISBN VARCHAR(20) UNIQUE KEY
);










