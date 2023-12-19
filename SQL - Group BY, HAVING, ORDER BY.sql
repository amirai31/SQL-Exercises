-- GROUP BY, HAVING, ORDER BY

/* Consider a table named Sales with the following columns:
ProductID (integer): The unique identifier for each product.
SaleDate (date): The date of the sale.
QuantitySold (integer): The quantity of the product sold on that date.*/

CREATE TABLE Sales(
	ProductID INT,
    SalesDate DATE,
    QuantitySold INT
);

/*Find the product IDs of products that have been sold in quantities
greater than 100 on at least three different sale dates.*/
SELECT ProductID 
FROM Sales
WHERE QuantitySold > 100
GROUP BY ProductID
HAVING COUNT(DISTINCT SalesDate) >= 3;

SELECT ProductID
FROM (
    SELECT ProductID, COUNT(DISTINCT SalesDate) AS NumSaleDates
    FROM Sales
    WHERE QuantitySold > 100
    GROUP BY ProductID
) AS ProductSaleCounts
WHERE NumSaleDates >= 3;

-- find the product with the highest total quantity sold
SELECT ProductID, 
	SUM(QuantitySold) AS Total
FROM Sales
GROUP BY ProductID
ORDER BY Total DESC
LIMIT 1;

SELECT * FROM Sales;
/*
Consider a table named Employees with the following columns:
EmployeeID (integer): The unique identifier for each employee.
Department (string): The department in which the employee works.
Salary (decimal): The salary of the employee
*/

CREATE TABLE Employees(
	EmployeeID INT,
    Department VARCHAR(20),
    Salary DECIMAL
);

-- find the average salary of employees in each department, but
-- only for departments where the average salary is greater than $60,000
SELECT Department, 
	AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department
HAVING AVG(Salary) > 60000;

-- find the department with the highest average salary
SELECT Department, 
	AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department 
ORDER BY AvgSalary DESC
LIMIT 1;

-- find the department(s) with the lowest average salary
SELECT Department, 
	AVG(Salary) AS AvgSalary
FROM Employees
GROUP BY Department 
ORDER BY AvgSalary
LIMIT 1;

-- find the departments where the highest salary is greater than
-- $80,000 and the total number of employees in that department is at least 5
SELECT Department 
FROM Employees
GROUP BY Department 
HAVING MAX(Salary) > 80000 AND 
	COUNT(EmployeeID) >= 5;

/*
Consider a table named Students with the following columns:
StudentID (integer): The unique identifier for each student.
Course (string): The course name.
Score (integer): The score obtained by the student in the course */
CREATE TABLE Students(
	StudentID INT,
    Course VARCHAR(10),
    Score INT
);

-- find the course names in which the average score of all students is greater than or equal to 80
SELECT Course
FROM Students
GROUP BY Course
HAVING AVG(Score) >= 80;

SELECT AVG(Score)
FROM Students;

-- find the top three students with the highest average score across all courses
SELECT StudentID, 
	AVG(Score) AS Avg_Score
FROM Students
GROUP BY StudentID
ORDER BY Avg_Score DESC
LIMIT 3;

-- find the course names in which the highest score achieved by
-- any student is greater than or equal to 90, ordered by course name in ascending order
SELECT Course, 
	MAX(Score) AS High_Score
FROM Students
GROUP BY Course
HAVING High_Score >= 90
ORDER BY Course;

-- find the course names where the average score of students who
-- scored less than 70 in at least one course is greater than or equal to 80
SELECT Course, 
	AVG(Score) AS Avg_Score
FROM Students
GROUP BY Course
HAVING Avg_Score >= 80 AND 
	COUNT(CASE WHEN Score < 70 THEN 1 ELSE NULL END) > 0;

/*Consider a table named Orders with the following columns:
OrderID (integer): The unique identifier for each order.
CustomerID (integer): The unique identifier for each customer.
OrderDate (date): The date of the order.
TotalAmount (decimal): The total amount of the order */
CREATE TABLE Orders(
	OrderID INT,
    CustomerID INT,
    OrderDate DATE,
    TotalAmount DECIMAL
);

-- find the total amount of orders placed by each customer, ordered in descending order of total amount
SELECT CustomerID, 
	SUM(TotalAmount) AS Total_Orders_Amount
FROM Orders
GROUP BY CustomerID
ORDER BY Total_Orders_Amount DESC;

-- find the customer IDs of customers who have placed orders with
-- a total amount greater than $1,000 and have placed at least two orders
SELECT CustomerID
FROM Orders
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 1000 AND 
	COUNT(OrderID) >= 2;

-- find the customer IDs of customers who have placed orders with a total amount
-- greater than $500 in the year 2023, ordered by customer ID in ascending order
SELECT CustomerID
FROM Orders
WHERE EXTRACT(YEAR FROM OrderDate) = 2023
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 500
ORDER BY CustomerID DESC;

-- find the customer IDs of customers who have placed orders with a total amount
-- greater than $500 in the year 2023 and have placed at least two orders in that year
SELECT CustomerID
FROM Orders
WHERE EXTRACT(YEAR FROM OrderDate) = 2023
GROUP BY CustomerID
HAVING SUM(TotalAmount) > 500 AND 
	COUNT(OrderID) >= 2;

-- find the customer IDs of customers who have placed orders with a total amount
-- greater than $1,000 in any single order and have placed orders on at least three different dates
SELECT CustomerID
FROM Orders
GROUP BY CustomerID
HAVING MAX(TotalAmount) > 1000 AND 
	COUNT(DISTINCT OrderDate) >= 3;

/*Consider a table named Books with the following columns:
BookID (integer): The unique identifier for each book.
Author (string): The author of the book.
PublicationYear (integer): The year the book was published.*/
CREATE TABLE Books(
	BookID INT,
    Author VARCHAR(10),
    PublicationYear INT
);

-- find the number of books published by each author in descending order of the count
SELECT Author, 
	COUNT(BookID) AS Total_Books
FROM Books
GROUP BY Author
ORDER BY Total_Books DESC;

/*Consider a table named Products with the following columns:
ProductID (integer): The unique identifier for each product.
Category (string): The category of the product.
Price (decimal): The price of the product.*/
CREATE TABLE Products(
	ProductID INT,
    Category VARCHAR(10),
    Price DECIMAL
);

-- find the average price of products in each category, ordered by category name in ascending order
SELECT Category, 
	AVG(Price) AS Avg_Price
FROM Products
GROUP BY Category
ORDER BY Category;

-- find the categories where the average price of products is greater than or equal to $50,
-- and the maximum price within that category is greater than $100.
SELECT Category, 
	AVG(Price) AS Avg_Price, 
	MAX(Price) AS Max_Price
FROM Products
GROUP BY Category
HAVING Avg_Price >= 50 AND 
	Max_Price > 100;