-- Database: sql_project_p1
--CREATING TABLE
CREATE TABLE RETAIL_SALES (
	TRANSACTIONS_ID INT PRIMARY KEY,
	SALE_DATE DATE,
	SALE_TIME TIME,
	CUSTOMER_ID INT,
	GENDER VARCHAR(6),
	AGE INT,
	CATEGORY VARCHAR(11),
	QUANTIY INT,
	PRICE_PER_UNIT FLOAT,
	COGS FLOAT,
	TOTAL_SALE FLOAT
);

SELECT
	COUNT(*) AS TOTAL_NO_OF_ROWS
FROM
	RETAIL_SALES;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID = NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_TIME = NULL;

SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

--DELETE NULL VALUES
--DATA CLEANING
DELETE FROM RETAIL_SALES
WHERE
	TRANSACTIONS_ID IS NULL
	OR SALE_DATE IS NULL
	OR SALE_TIME IS NULL
	OR GENDER IS NULL
	OR CATEGORY IS NULL
	OR QUANTIY IS NULL
	OR COGS IS NULL
	OR TOTAL_SALE IS NULL;

SELECT
	COUNT(*) AS TOTAL_NO_OF_ROWS
FROM
	RETAIL_SALES;

--DATA EXPLORATION
--How many sales we have
SELECT
	COUNT(*) AS TOTAL_NO_OF_SALES
FROM
	RETAIL_SALES;

--how many unique customers we have
SELECT
	COUNT(DISTINCT CUSTOMER_ID)
FROM
	RETAIL_SALES;

--Data Analysis & Business Key Problems & Answers
--Q1: Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	SALE_DATE = '2022-11-05';

--Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Clothing'
	AND TO_CHAR(SALE_DATE, 'YYYY-MM') = '2022-11'
	AND QUANTIY >= 4;

--Q3: Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT
	CATEGORY,
	SUM(TOTAL_SALE) AS NET_SALES,
	COUNT(*) AS TOTAL_ORDERS
FROM
	RETAIL_SALES
GROUP BY
	CATEGORY;

--Q4: Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT
	CATEGORY,
	ROUND(AVG(AGE), 2) AS AVERAGE_AGE
FROM
	RETAIL_SALES
WHERE
	CATEGORY = 'Beauty'
GROUP BY
	1;

--Q5: Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT
	*
FROM
	RETAIL_SALES
WHERE
	TOTAL_SALE > 1000;

--Q6: Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT
	CATEGORY,
	GENDER,
	COUNT(*) AS TOTAL_TRANSACTIONS
FROM
	RETAIL_SALES
GROUP BY
	1,
	2
ORDER BY
	1,
	2;

--Q7: Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT
	YEAR,
	MONTH,
	AVG_SALES
FROM
	(
		SELECT
			EXTRACT(
				YEAR
				FROM
					SALE_DATE
			) AS YEAR,
			EXTRACT(
				MONTH
				FROM
					SALE_DATE
			) AS MONTH,
			AVG(TOTAL_SALE) AS AVG_SALES,
			RANK() OVER (
				PARTITION BY
					EXTRACT(
						YEAR
						FROM
							SALE_DATE
					)
				ORDER BY
					AVG(TOTAL_SALE) DESC
			) AS RANK
		FROM
			RETAIL_SALES
		GROUP BY
			1,
			2
	) AS T1
WHERE
	RANK = 1;

--Q8: **Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT
	CUSTOMER_ID,
	SUM(TOTAL_SALE) AS TOTAL_SALES
FROM
	RETAIL_SALES
GROUP BY
	1
ORDER BY
	2 DESC
LIMIT
	5;

--Q9: Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT
	CATEGORY,
	COUNT(DISTINCT CUSTOMER_ID) AS CUSTOMERS
FROM
	RETAIL_SALES
GROUP BY
	1;

--Q10: Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH
	HOURLY_SALES AS (
		SELECT
			*,
			CASE
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) < 12 THEN 'Morning'
				WHEN EXTRACT(
					HOUR
					FROM
						SALE_TIME
				) BETWEEN 12 AND 17  THEN 'Afternoon'
				ELSE 'Evening'
			END AS SHIFT
		FROM
			RETAIL_SALES
	)
SELECT
	SHIFT,
	COUNT(TRANSACTIONS_ID) AS TOTAL_ORDERS
FROM
	HOURLY_SALES
GROUP BY
	1;