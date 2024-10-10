create database project;
use project;
CREATE TABLE retail_sales
            (
                transaction_id INT  PRIMARY KEY ,	
                sale_date DATE ,	 
                sale_time TIME ,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );
       
-- Data Exploration & Cleaning

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
	age IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;

DELETE FROM retail_sales    
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
	age IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    price_per_unit IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
 -- Determine the total number of records in the dataset.           
SELECT COUNT(*) as total_sale FROM retail_sales;

-- Find out how many unique customers are in the dataset.
SELECT COUNT(DISTINCT customer_id) as distinct_customers FROM retail_sales;

-- Identify all unique product categories in the dataset.
SELECT DISTINCT category FROM retail_sales;


-- Q1 Write a SQL query to retrieve all columns for sales made on '2022-11-05.
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022.
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 4
  AND MONTH(sale_date) = 11
  AND YEAR(sale_date) = 2022;
  
  -- Q3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category,
    SUM(total_sale) as net_sale, count(*) as total_orders
    FROM retail_sales
GROUP BY category;


-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category,
    gender,
    COUNT(*) as total_transaction
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY category;

-- Q7 Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5


-- Q8 Write a SQL query to calculate the average sale for each month, Find out best selling month in each year.
SELECT years, months, best_sale
FROM
(SELECT
        EXTRACT(YEAR FROM sale_date) AS years,
        EXTRACT(MONTH FROM sale_date) AS months,
        AVG(total_sale) AS best_sale,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS sale_rank
    FROM retail_sales
    GROUP BY years, months
) AS monthly_sales
WHERE sale_rank = 1;

-- Q9 Write a SQL query to create each shift and number of orders.
WITH hourly_sale
AS
(SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift

-- Q10 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category, COUNT(DISTINCT customer_id) as unique_customer FROM retail_sales GROUP BY category;