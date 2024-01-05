-- SQL nested queries

/* Create tables
Employees:
Columns: EMPLOYEE_ID, FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER, HIRE_DATE, JOB_ID, SALARY, 
COMMISSION_PCT, MANAGER_ID, DEPARTMENT_ID
Departments:
Columns: DEPARTMENT_ID, DEPARTMENT_NAME, MANAGER_ID, LOCATION_ID*/

CREATE TABLE Employees(
	Employee_ID INT PRIMARY KEY, 
    First_Name VARCHAR(10), 
    Last_Name VARCHAR(20), 
    EMAIL VARCHAR(10), 
    PHONE_NUMBER CHAR(10), 
    Hire_Date DATE, 
    Job_ID INT, 
    Salary DECIMAL, 
    COMMISSION_PCT DECIMAL, 
    Manager_ID INT, 
    Department_ID INT
);

CREATE TABLE Departments(
	Department_ID INT PRIMARY KEY,
    DEPARTMENT_NAME VARCHAR(10),
    Manager_ID INT, 
    Location_ID INT
);

-- find those employees who receive a higher salary than the employee with ID 163. 
-- Return first name, last name
SELECT First_Name,
	Last_Name
FROM Employees
WHERE Salary > (
	SELECT Salary
    FROM Employees
    WHERE Employee_ID = 163
);

-- find out which employees have the same designation as the employee whose ID is 162. 
-- Return first name, last name, department ID and job ID
SELECT First_Name,
	Last_Name, 
    Department_ID,
    Job_ID
FROM Employees
WHERE Job_ID = (
	SELECT Job_ID
    FROM Employees
    WHERE Employee_ID = 162
);

-- find those employees whose salary matches the lowest salary of any of the departments. 
-- Return first name, last name and department ID.
SELECT First_Name,
	Last_Name,
    Department_ID
FROM Employees
WHERE salary IN (
	SELECT MIN(salary)
    FROM Employees
    GROUP BY Department_ID
);    

-- 	find those employees who report to that manager whose first name is ‘Payam’. 
-- Return first name, last name, employee ID and salary.	
SELECT First_Name,
	Last_Name,
    Employee_ID,
    salary
FROM Employees 
WHERE MANAGER_ID = (
	SELECT Employee_ID
    FROM Employees 
    WHERE First_Name = "Payam"
);
	
-- find those employees whose salary falls within the range of the smallest salary and 2500. 
-- Return all the fields.
SELECT * 
FROM Employees
WHERE salary BETWEEN (
	SELECT MIN(salary)
    FROM Employees)
    AND 2500;

-- find those employees who do not work in the departments where managers’ IDs are between 100 and 200 
-- (Begin and end values are included.). Return all the fields of the employees.
SELECT *
FROM Employees
WHERE Department_ID NOT IN(
	SELECT Department_ID
    FROM Departments
    WHERE Manager_ID BETWEEN 100 AND 200);

-- find those employees who work in the same department as ‘Clara’. 
-- Exclude all those records where the first name is ‘Clara’. 
-- Return first name, last name and hire date.
SELECT First_Name,
	Last_Name,
    Hire_Date
FROM Employees
WHERE Department_ID = (
	SELECT Department_ID
    FROM Employees
    WHERE First_Name = "Clara")
    AND First_Name <> "Clara";

-- find those employees who work in a department where the employee’s first name contains the letter 'T'. 
-- Return employee ID, first name and last name.
SELECT Employee_ID, 
	First_Name,
	Last_Name
FROM Employees
WHERE Department_ID IN (
	SELECT Department_ID
    FROM Employees
    WHERE First_Name LIKE '%T%');

-- find those employees who earn more than the average salary
-- and work in the same department as an employee whose first name contains the letter 'J'. 
-- Return employee ID, first name and salary.
SELECT Employee_ID, 
	First_Name,
	salary
FROM Employees
WHERE salary > (
		SELECT AVG(salary)
		FROM Employees
		)
    AND Department_ID IN (
		SELECT Department_ID
        FROM Employees
        WHERE First_Name LIKE '%J%'
		);

-- find those employees whose salaries are higher than the average for all departments. 
-- Return employee ID, first name, last name, job ID.
SELECT Employee_ID, 
	First_Name,
	Last_Name,
	Job_ID
FROM Employees
WHERE salary > ALL(
	SELECT AVG(salary)
    FROM Employees
    GROUP BY Department_ID);

-- display the employee id, name, salary and the SalaryStatus column with a title HIGH and LOW respectively 
-- for those employees whose salary is more than and less than the average salary of all employees.
SELECT Employee_ID, 
	First_Name,
	Last_Name,
    salary,
	CASE 
		WHEN salary >= (
			SELECT AVG(salary) 
            FROM Employees) THEN 'HIGH'
        ELSE 'LOW'
	END AS SalaryStatus
FROM Employees;

-- find those employees whose salaries exceed 50% of their department's total salary bill. 
-- Return first name, last name.
SELECT First_Name,
	Last_Name
FROM Employees E1
WHERE salary > (
	SELECT (SUM(salary)) * 0.5
    FROM Employees E2
    WHERE E1.Department_ID = E2.Department_ID
    );

-- find those employees who are managers. Return all the fields of the employees table.
SELECT *
FROM Employees 
WHERE Employee_ID IN (
	SELECT DISTINCT Manager_ID
    FROM Employees);
    