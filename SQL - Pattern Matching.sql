-- PATTERN MATCHING

-- How can you select all employees whose names start with the letter 'A'?
SELECT *
FROM Employees
WHERE Name LIKE 'A%';

-- How do you find all products whose names contain the word 'phone' regardless of case?
SELECT *
FROM Products
WHERE LOWER(Name) LIKE '%phone%';

-- How can you retrieve all email addresses from a table that end with '.com'?
SELECT mailid
FROM Contacts
WHERE mailid LIKE '%.com';

-- How do you find all phone numbers that start with the area code '555'?
SELECT numbers
FROM Contacts
WHERE numbers LIKE '555%';

-- How can you select all cities that start with 'New' followed by any characters?
SELECT City
FROM Contacts
WHERE City LIKE 'New%';

-- How do you find all records where the value in the 'description' column contains either 'apple' or 'orange'?
SELECT *
FROM Products
WHERE description LIKE '%apple%' OR description LIKE '%orange%';

-- How can you retrieve all email addresses that follow the pattern of "user@domain.com"?
SELECT mailid
FROM Contacts
WHERE mailid REGEXP "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}$";
                   
-- How do you find all records where the 'product_code' is exactly four characters long and consists of letters and digits?
SELECT *
FROM Orders
WHERE product_code REGEXP '^[A-Za-z0-9]{4}$';

-- How can you retrieve all phone numbers that match the pattern '###-###-####'?
SELECT numbers
FROM Contacts
WHERE numbers REGEXP '^[0-9]{3}-[0-9]{3}-[0-9]{4}$';

-- How do you find all records where the 'text' column contains two consecutive digits?
SELECT *
FROM Contacts
WHERE text_col REGEXP '[0-9]{2}';