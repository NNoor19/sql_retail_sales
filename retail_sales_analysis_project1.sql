SELECT *
FROM retail_sales

----------------------
SELECT count(*)
FROM retail_sales
_______
SELECT *
FROM retail_sales
WHERE
   transactions_id IS NULL
   OR
   sale_date IS NULL
   OR
   sale_time IS NULL
   OR
   customer_id IS NULL
   OR
   gender IS NULL
   OR
   age IS NULL
   OR
   category IS NULL
   OR
   quantiy IS NULL
   OR
   price_per_unit IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL
---------------------------------

DELETE
FROM retail_sales
WHERE
   transactions_id IS NULL
   OR
   sale_date IS NULL
   OR
   sale_time IS NULL
   OR
   customer_id IS NULL
   OR
   gender IS NULL
   OR
   age IS NULL
   OR
   category IS NULL
   OR
   quantiy IS NULL
   OR
   price_per_unit IS NULL
   OR
   cogs IS NULL
   OR
   total_sale IS NULL

--------------------------------------------
---How many customers do we have here?
SELECT count(DISTINCT customer_id)
FROM retail_sales
-------------------------------
---How many categories do we have here?
SELECT count(DISTINCT category)
FROM retail_sales

----Only the categories
SELECT DISTINCT category
FROM retail_sales

-------------QUESTIONS-------------------

-------Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05'

-------Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than and equal to 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE 
category = 'Clothing'
AND
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND
quantiy>=4

------Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) AS Total_Sale, COUNT(*) AS Amount_Sold
FROM retail_sales
GROUP BY 1

-------Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(AVG(age),2) AS Average_Age, category, gender
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY 2, 3

-----Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale>1000

---Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT count(transactions_id) AS total_transactions, gender, category
FROM retail_sales
GROUP BY 2,3
ORDER BY 2

--Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT *
FROM (
SELECT
EXTRACT(YEAR FROM sale_date) AS year,
EXTRACT(MONTH FROM sale_date) AS month,
AVG(total_sale)AS Average_sale,
RANK() OVER (
        PARTITION BY EXTRACT(YEAR FROM sale_date)
        ORDER BY AVG(total_sale) DESC 
		) AS Highest_rank
FROM retail_sales
GROUP BY 1,2
) AS highest_sale
WHERE Highest_rank = 1
--ORDER BY 1,2

--Write a SQL query to find the top 5 customers based on the highest total sales

Select customer_id, sum(total_sale) AS Total_sale
From retail_sales
group by 1
order by 2 desc
limit 5

--Write a SQL query to find the number of unique customers who purchased items from each category.:

Select count(DISTINCT customer_id) AS unique_customers, category
from retail_sales
group by 2

--Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

SELECT 
EXTRACT(Hour FROM sale_time) AS shift,
count(*) AS number_of_orders
from retail_sales
GROUP BY EXTRACT(HOUR FROM sale_time)
Order by 1

WITH hourly_sale
AS
(
Select *, 
CASE
WHEN EXTRACT(Hour FROM sale_time) <12 THEN 'Morning'
WHEN EXTRACT(Hour FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS shift
from retail_sales
)
Select count(*) AS total_orders, shift
From hourly_sale
group by shift