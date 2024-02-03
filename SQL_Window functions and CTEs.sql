-- Window functions and CTEs

/* Given a table named sales with columns order_date, region, and revenue.
write a query to calculate the total revenue for each region,
ordering the results by region and order date. */
SELECT region,
	order_date,
	SUM(revenue) OVER (PARTITION BY region ORDER BY order_date) AS total_revenue
FROM sales
ORDER BY region, 
	order_date;


/* Using the same sales table, write a query to find the top 3 highest revenue days
for each region. */
WITH RankedSales AS (
	SELECT region,
		order_date,
		revenue,
		ROW_NUMBER() OVER (PARTITION BY region ORDER BY revenue DESC) AS row_num
	FROM sales
)
SELECT region, 
	order_date, 
    revenue
FROM RankedSales
WHERE row_num <= 3
ORDER BY region, 
	row_num;


/* Suppose you have a table sales with columns sale_date, product_id, and revenue. 
Write a query to calculate the moving average revenue for each product over a 7-day window. */
SELECT sale_date,
	product_id,
	revenue,
	AVG(revenue) OVER (PARTITION BY product_id ORDER BY
		sale_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS moving_avg_revenue
FROM sales;


/* You are given a table sales with columns order_date, region, and revenue. 
Write a CTE query to find the total revenue for each region and
display regions with total revenue greater than $1,000,000.*/
WITH RegionTotalRevenue AS (
	SELECT region, 
		SUM(revenue) AS total_revenue
	FROM sales
	GROUP BY region
)
SELECT region, 
	total_revenue
FROM RegionTotalRevenue
WHERE total_revenue > 1000000;


/* Suppose you have an employee_salaries table with columns employee_id, salary, and department_id. 
Write a query to calculate the average salary for each department, including the department's
highest-paid employee's salary.*/
SELECT department_id,
	AVG(salary) AS avg_salary,
	MAX(salary) OVER (PARTITION BY department_id) AS max_salary
FROM employee_salaries
GROUP BY department_id;


/* In a table employee_salaries with columns employee_id, salary, and department_id.
find the difference between each employee's salary and the average salary in their department.*/
SELECT employee_id,
	salary,
	department_id,
	salary - AVG(salary) OVER (PARTITION BY department_id) AS salary_difference
FROM employee_salaries;


/*In a table employee_salaries with columns employee_id, salary, and department_id.
write a CTE query to find the highest salary in each department.*/
WITH MaxSalaries AS (
	SELECT department_id, 
		MAX(salary) AS max_salary
	FROM employee_salaries
	GROUP BY department_id
)
SELECT department_id, 
	max_salary
FROM MaxSalaries;


/*In a table employee_salaries with columns employee_id, salary, and department_id
write a CTE query to find the employees who have the same salary as their department's average salary.*/
WITH EmployeeSameSalaryAsAvg AS (
	SELECT E.employee_id, 
		E.salary, 
        E.department_id, 
        AVG(S.salary) AS avg_salary
	FROM employee_salaries E JOIN employee_salaries S ON E.department_id = S.department_id
	GROUP BY E.employee_id, E.salary, E.department_id
	HAVING E.salary = AVG(S.salary)
)
SELECT employee_id, 
	salary, 
	department_id
FROM EmployeeSameSalaryAsAvg;

/* In a table named student_scores with columns student_id, subject, and score.
Find the student with the highest score in each subject.*/
WITH RankedScores AS (
	SELECT student_id,
		subject,
		score,
		RANK() OVER (PARTITION BY subject ORDER BY score DESC) AS ranks
	FROM student_scores
)
SELECT student_id, 
	subject, 
    score
FROM RankedScores
WHERE ranks = 1;


/* In a table student_scores with columns student_id, subject, and score.
find the average score for each subject, and also include the student 
who scored the highest in each subject. */
WITH RankedScores AS (
	SELECT student_id,
		subject,
		score,
		RANK() OVER (PARTITION BY subject ORDER BY score DESC) AS ranks
	FROM student_scores
)
SELECT subject,
	AVG(score) AS avg_score,
	student_id AS highest_scorer
FROM RankedScores
WHERE ranks = 1
GROUP BY subject;


/*Given a table student_scores with columns student_id, subject, and score.
write a CTE query to find the average score for each subject
and display subjects with an average score greater than 80.*/
WITH SubjectAverages AS (
	SELECT subject, 
		AVG(score) AS avg_score
	FROM student_scores
	GROUP BY subject
)
SELECT subject, 
	avg_score
FROM SubjectAverages
WHERE avg_score > 80;


/* In a table order_details with columns order_id, product_id, and quantity. 
find the product that contributed the most to each order in terms of quantity. */
WITH RankedProducts AS (
	SELECT order_id,
		product_id,
		quantity,
		ROW_NUMBER() OVER (PARTITION BY order_id ORDER BY quantity DESC) AS row_num
	FROM order_details
)
SELECT order_id, 
	product_id, 
	quantity
FROM RankedProducts
WHERE row_num = 1;


/* Suppose you have a table order_details with columns order_id, product_id, and unit_price. 
Write a query to calculate the total revenue for each order and 
include the order with the highest revenue in each result row.*/
WITH MaxRevenueOrders AS (
	SELECT order_id,
		product_id,
		SUM(unit_price) OVER (PARTITION BY order_id) AS total_revenue
	FROM order_details
)
SELECT order_id,
	product_id,
	total_revenue,
	FIRST_VALUE(order_id) OVER (PARTITION BY order_id ORDER BY total_revenue DESC) 
		AS highest_revenue_order
FROM MaxRevenueOrders;


/* You have a table order_details with columns order_id, product_id, and quantity. 
Write a CTE query to find the total quantity ordered for each product and 
rank the products by total quantity.*/
WITH ProductTotalQuantity AS (
	SELECT product_id, 
		SUM(quantity) AS total_quantity
	FROM order_details
	GROUP BY product_id
)
SELECT product_id, 
	total_quantity,
	RANK() OVER (ORDER BY total_quantity DESC) AS product_rank
FROM ProductTotalQuantity;


/* Given a table employee_performance with columns employee_id, quarter, and performance_score.
calculate the average performance score for each employee over the last two quarters.*/
SELECT employee_id,
	quarter,
	performance_score,
	AVG(performance_score) OVER (PARTITION BY employee_id 
    ORDER BY quarter ROWS BETWEEN 1 PRECEDING AND CURRENT ROW) AS avg_score_last_two_quarters
FROM employee_performance
ORDER BY employee_id, 
	quarter;


/*In a table employee_performance with columns employee_id, quarter, and performance_score
find the employees whose performance score has improved for three consecutive quarters.*/
WITH ImprovedPerformance AS (
	SELECT employee_id,
		quarter,
		performance_score,
		LAG(performance_score, 1) OVER (PARTITION BY employee_id
			ORDER BY quarter) AS prev_quarter_score,
		LAG(performance_score, 2) OVER (PARTITION BY employee_id
			ORDER BY quarter) AS prev_two_quarters_score
	FROM employee_performance
)
SELECT DISTINCT employee_id
FROM ImprovedPerformance
WHERE performance_score > prev_quarter_score
AND prev_quarter_score > prev_two_quarters_score;


/*Suppose you have a table employee_performance with columns
employee_id, quarter, and performance_score. 
Write a CTE query to find the employees who have shown consistent improvement in their
performance score over the last four quarters.*/
WITH ImprovedPerformance AS (
	SELECT employee_id, 
		quarter, 
        performance_score,
		LAG(performance_score, 1) OVER (PARTITION BY employee_id
			ORDER BY quarter) AS prev_quarter_score,
		LAG(performance_score, 2) OVER (PARTITION BY employee_id
			ORDER BY quarter) AS prev_two_quarters_score,
		LAG(performance_score, 3) OVER (PARTITION BY employee_id
			ORDER BY quarter) AS prev_three_quarters_score
	FROM employee_performance
)
SELECT DISTINCT employee_id
FROM ImprovedPerformance
WHERE performance_score > prev_quarter_score
	AND prev_quarter_score > prev_two_quarters_score
	AND prev_two_quarters_score > prev_three_quarters_score;


/* Suppose you have a table exam_scores with columns student_id, subject, score, and exam_date. 
Write a query to find the student who achieved the highest score in each subject 
within the last month.*/
WITH RankedScores AS (
	SELECT student_id,
		subject,
		score,
		exam_date,
		ROW_NUMBER() OVER (PARTITION BY subject ORDER BY score DESC) AS ranks
	FROM exam_scores
	WHERE exam_date >= DATEADD(MONTH, -1, GETDATE())
)
SELECT student_id, 
	subject, 
    score, 
    exam_date
FROM RankedScores
WHERE ranks = 1;


/*Given a table customer_orders with columns customer_id, order_date, and order_total.
write a CTE query to calculate the total order value for each customer and 
list customers with total order values exceeding $10,000.*/
WITH CustomerOrderTotals AS (
	SELECT customer_id, 
		SUM(order_total) AS total_order_value
	FROM customer_orders
	GROUP BY customer_id
)
SELECT customer_id, 
	total_order_value
FROM CustomerOrderTotals
WHERE total_order_value > 10000;


/*Given a table customer_orders with columns customer_id, order_date, and order_total.
write a CTE query to find the customers who
placed orders on the same date as the highest total daily order value.*/
WITH DailyMaxOrderTotal AS (
	SELECT order_date, 
		SUM(order_total) AS total_order_value
	FROM customer_orders
	GROUP BY order_date
	ORDER BY total_order_value DESC
	LIMIT 1
)
SELECT customer_id, 
	order_date, 
    order_total
FROM customer_orders
WHERE order_date = (SELECT order_date FROM DailyMaxOrderTotal);


/* Given a table web_traffic with columns page_id, visit_date, and page_views.
find the pages that received the highest number of page views for each month. */
WITH RankedPages AS (
	SELECT page_id,
		visit_date,
		page_views,
		RANK() OVER (PARTITION BY DATEPART(YEAR, visit_date),
			DATEPART(MONTH, visit_date) ORDER BY page_views DESC) AS ranks
	FROM web_traffic
)
SELECT page_id, 
	visit_date, 
    page_views
FROM RankedPages
WHERE ranks = 1;


/* Given a table web_logs with columns log_date, user_id, and page_views.
calculate the 7-day rolling average page views for each user.*/
SELECT log_date,
	user_id,
	page_views,
	AVG(page_views) OVER (PARTITION BY user_id ORDER BY
		log_date ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS rolling_avg_page_views
FROM web_logs;


/* Given a table web_logs with columns log_date, user_id, and page_views.
write a CTE query to find the users who had the highest daily page views.*/
WITH DailyMaxPageViews AS (
	SELECT log_date, 
		MAX(page_views) AS max_page_views
	FROM web_logs
	GROUP BY log_date
)
SELECT W.log_date, 
	W.user_id
FROM web_logs W
JOIN DailyMaxPageViews D ON W.log_date = D.log_date AND W.page_views = D.max_page_views;


/*Given a table web_logs with columns log_date, user_id, and page_views.
write a CTE query to find the date with the highest total page
views and the user who had the highest page views on that date.*/
WITH DailyMaxPageViews AS (
	SELECT log_date, 
		SUM(page_views) AS total_page_views
	FROM web_logs
	GROUP BY log_date
	ORDER BY total_page_views DESC
	LIMIT 1
)
SELECT W.log_date, 
	W.user_id
FROM web_logs W JOIN DailyMaxPageViews D ON W.log_date = D.log_date;


/* Given a table product_sales with columns product_id, sale_date, and revenue. 
find the products that have had the highest daily revenue at least once.*/
WITH RankedProducts AS (
	SELECT product_id,
		sale_date,
		revenue,
		RANK() OVER (PARTITION BY product_id, sale_date ORDER BY revenue DESC) AS ranks
	FROM product_sales
)
SELECT DISTINCT product_id
FROM RankedProducts
WHERE ranks = 1;


/* You have a table product_sales with columns product_id, sale_date, and revenue. 
Write a CTE query to calculate the cumulative revenue for each product ordered by sale date.*/
WITH CumulativeRevenue AS (
	SELECT product_id, 
		sale_date, 
		revenue,
		SUM(revenue) OVER (PARTITION BY product_id ORDER BY sale_date) AS cumulative_revenue
	FROM product_sales
)
SELECT product_id, 
	sale_date, 
	revenue, 
	cumulative_revenue
FROM CumulativeRevenue;


/*Given a table product_sales with columns product_id, sale_date, and revenue 
write a CTE query to calculate the average revenue for each product for the last 3 months.*/
WITH Last3MonthsAverage AS (
	SELECT product_id, 
		AVG(revenue) AS avg_revenue
	FROM product_sales
	WHERE sale_date >= DATEADD(MONTH, -3, GETDATE())
	GROUP BY product_id
)
SELECT product_id, 
	avg_revenue
FROM Last3MonthsAverage;


/* Given a table product_sales with columns product_id, sale_date, and revenue. 
calculate the running total revenue for each product, ordered by sale date. */
SELECT product_id,
	sale_date,
	revenue,
	SUM(revenue) OVER (PARTITION BY product_id ORDER BY sale_date) AS running_total
FROM product_sales
ORDER BY product_id, 
	sale_date;


/*Question: Given a table product_inventory with columns product_id, transaction_date, and quantity.
calculate the sum of quantities sold for each product over a rolling 30-day period.*/
SELECT product_id,
	transaction_date,
	quantity,
	SUM(quantity) OVER (PARTITION BY product_id ORDER BY
		transaction_date ROWS BETWEEN 29 PRECEDING AND CURRENT ROW) AS rolling_sum_quantity
FROM product_inventory;


/* In a table product_inventory with columns product_id, transaction_date, and quantity.
write a CTE query to find the products that have never had a negative quantity in stock.*/
WITH PositiveStockProducts AS (
	SELECT DISTINCT product_id
	FROM product_inventory
	WHERE product_id NOT IN (
		SELECT product_id
		FROM product_inventory
		WHERE quantity < 0
	)
)
SELECT product_id
FROM PositiveStockProducts;


/*In a table product_inventory with columns product_id, transaction_date, and quantity.
write a CTE query to find the products that have the highest cumulative quantity purchased 
in the last 90 days. */
WITH CumulativeQuantityLast90Days AS (
	SELECT product_id, 
		SUM(quantity) AS total_quantity
	FROM product_inventory
	WHERE transaction_date >= DATEADD(DAY, -90, GETDATE())
	GROUP BY product_id
)
SELECT product_id, 
	total_quantity
FROM CumulativeQuantityLast90Days
WHERE total_quantity = (SELECT MAX(total_quantity) 
	FROM CumulativeQuantityLast90Days);


/*Given a table employees with columns employee_id, employee_name, and manager_id.
write a SQL query to list all employees and their immediate managers using a CTE.*/
WITH EmployeeHierarchy AS (
	SELECT employee_id, 
		employee_name, 
        manager_id
	FROM employees
)
SELECT E.employee_name, 
	M.employee_name AS manager_name
FROM EmployeeHierarchy E
	LEFT JOIN EmployeeHierarchy M ON E.manager_id = M.employee_id;


/*In a table orders with columns order_id, customer_id, and order_date.
write a CTE query to find the number of orders placed by each customer in the year 2022.*/
WITH CustomerOrderCounts AS (
	SELECT customer_id, 
		COUNT(order_id) AS order_count
	FROM orders
	WHERE YEAR(order_date) = 2022
	GROUP BY customer_id
)
SELECT C.customer_id, 
	C.order_count
FROM CustomerOrderCounts C;


/* Suppose you have a table orders with columns order_id,ncustomer_id, and order_date. 
Write a CTE query to find the first and last order dates for each customer.*/
WITH FirstLastOrderDates AS (
	SELECT customer_id, 
		MIN(order_date) AS first_order_date,
		MAX(order_date) AS last_order_date
	FROM orders
	GROUP BY customer_id
)
SELECT customer_id, 
	first_order_date, 
	last_order_date
FROM FirstLastOrderDates;


/*Suppose you have a table expenses with columns expense_id, category, and amount. 
Write a CTE query to find the top 5 expense categories with the highest total amount.*/
WITH CategoryTotalExpenses AS (
	SELECT category, 
		SUM(amount) AS total_amount
	FROM expenses
	GROUP BY category
)
SELECT category, 
	total_amount
FROM CategoryTotalExpenses
ORDER BY total_amount DESC
LIMIT 5;


/*Suppose you have a table expenses with columns expense_id, category, and amount. 
Write a CTE query to find the category with the 
highest total amount spent and list expenses within that category.*/
WITH CategoryTotalAmount AS (
	SELECT category, 
		SUM(amount) AS total_amount
	FROM expenses
	GROUP BY category
	ORDER BY total_amount DESC
	LIMIT 1
)
SELECT E.expense_id, 
	E.category, 
    E.amount
FROM expenses E JOIN CategoryTotalAmount C ON E.category = C.category;


/* In a table employee_hierarchy with columns employee_id, employee_name, and manager_id
write a CTE query to find all employees and their immediate managers' names */
WITH EmployeeManagers AS (
	SELECT E.employee_id, 
		E.employee_name, 
        M.employee_name AS manager_name
	FROM employee_hierarchy E
		LEFT JOIN employee_hierarchy M ON E.manager_id = M.employee_id
)
SELECT employee_id, 
	employee_name, 
    manager_name
FROM EmployeeManagers;


/*You are designing a database for a library. 
Create a view that lists all books available for checkout along with their authors' names.
Explain the benefits of using this view.*/
CREATE VIEW available_books AS
	SELECT b.book_id, 
		b.title, 
        a.author_name
	FROM books b JOIN authors a ON b.author_id = a.author_id
	WHERE b.is_available = 1;


/* You have a table sales_data with columns order_date, region, salesperson_id, and revenue. 
Write an SQL query to find the top-performing salesperson in each region based on the highest total
revenue. Use a combination of CTEs and window functions.*/
WITH SalesRegionTotal AS (
	SELECT region, 
		salesperson_id, 
        SUM(revenue) AS total_revenue
	FROM sales_data
	GROUP BY region, salesperson_id
),
RankedSalespeople AS (
	SELECT region, 
		salesperson_id, 
        total_revenue,
		ROW_NUMBER() OVER (PARTITION BY region ORDER BY total_revenue DESC) AS ranks
	FROM SalesRegionTotal
)
SELECT region, 
	salesperson_id, 
    total_revenue
FROM RankedSalespeople
WHERE ranks = 1;
