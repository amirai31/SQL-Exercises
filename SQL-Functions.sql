-- FUNCTIONS:

/* Consider a table named Sales with the following columns:
SaleID (integer): The unique identifier for each sale. Product (string): The name of the product sold.
Quantity (integer): The quantity of the product sold. Price (decimal): The price per unit of the product. */

CREATE TABLE Sales(
	SaleID INT PRIMARY KEY,
    Product VARCHAR(20),
    Quantity INT,
    Price DECIMAL
);

-- Calculate the total quantity sold across all products
SELECT SUM(Quantity) AS Total_Quantity
FROM Sales;

-- Find the total quantity sold for each product.
SELECT Product, 
	SUM(Quantity) AS Total_Quantity
FROM Sales
GROUP BY Product;

-- Calculate the total revenue generated from each product (Total Revenue = Quantity * Price).
SELECT Product, 
	SUM(Quantity * Price) AS Total_Revenue
FROM Sales
GROUP BY Product;

-- Determine the average price of all products.
SELECT AVG(Price) AS Avg_Price
FROM Sales;

-- Determine the average price of each product
SELECT Product, 
	AVG(Price) AS Avg_Price
FROM Sales
GROUP BY Product;

-- Find the product with the highest total revenue (Quantity * Price)
SELECT Product
FROM Sales
GROUP BY Product
ORDER BY SUM(Quantity * Price) DESC
LIMIT 1;

/* Consider a table named Products with the following columns: ProductID (integer): The unique identifier for each product.
ProductName (string): The name of the product. Price (decimal): The price of the product. */

CREATE TABLE Products(
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(20),
    Price DECIMAL
);

-- Determine the square root of the price for each product.
SELECT ProductName, 
	Price, 
	SQRT(Price)
FROM Products;

-- Find the ceiling (smallest integer greater than or equal to) of the prices
SELECT ProductName, 
	Price, 
    CEIL(Price)
FROM Products;

-- Calculate the floor (largest integer less than or equal to) of the prices
SELECT ProductName, 
	Price, 
    FLOOR(Price)
FROM Products;

/* Consider a table named Orders with the following columns:
OrderID (integer): The unique identifier for each order.
OrderDate (datetime): The date and time when the order was placed.
DeliveryDate (datetime): The date and time when the order was delivered. */

CREATE TABLE Orders(
	OrderID INT,
    OrderDate DATETIME,
    DeliveryDate DATETIME
);

-- Find the difference in days between the order date and delivery date for each order
SELECT OrderID, 
	DATEDIFF(DeliveryDate, OrderDate) AS Difference
FROM Orders;

-- Calculate the total delivery time in hours for all orders
SELECT SUM(DATEDIFF(DeliveryDate, OrderDate) * 24) AS DeliveryTime
FROM Orders;

SELECT SUM(TIMESTAMPDIFF(HOUR, OrderDate, DeliveryDate)) AS TotalDeliveryHours
FROM Orders;

-- Determine the day of the week when each order was placed
SELECT OrderID, 
	DATE(OrderDate) AS Date, 
    DAYOFWEEK(OrderDate) AS DayOfWeek
FROM Orders;

-- Find the orders that were placed on a Saturday (DayOfWeek = 7)
SELECT OrderID, 
	DATE(OrderDate) AS Date, 
    DAYOFWEEK(OrderDate) AS DayOfWeek
FROM Orders
WHERE DAYOFWEEK(OrderDate) = 7;

-- Calculate the average delivery time in days for all orders
SELECT AVG(DATEDIFF(DeliveryDate, OrderDate)) AS AvgDeliveryTime
FROM Orders;

-- Find the orders that were delivered on the same day they were placed
SELECT OrderID, 
	OrderDate, 
    DeliveryDate 
FROM Orders
WHERE OrderDate = DeliveryDate; 