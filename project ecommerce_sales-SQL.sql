USE ecommerce_project;

SHOW TABLES;

SELECT * FROM global_ecommerce_sales
LIMIT 10;

DESCRIBE global_ecommerce_sales;

#Total orders#
SELECT COUNT(*) AS total_orders
FROM global_ecommerce_sales;

#Total Sales#
SELECT ROUND(SUM(Total_Amount) ,2)AS total_sales
FROM global_ecommerce_sales; 

#Average Order Value#
SELECT ROUND(AVG(Total_Amount) ,2)AS average_order_value
FROM global_ecommerce_sales;

#Minimum Order Value#
SELECT MIN(Total_Amount) AS minimum_order_value
FROM global_ecommerce_sales;

#Maximum Order Value#
SELECT MAX(Total_Amount) AS maximum_order_value
FROM global_ecommerce_sales;

#Sales by Country#
SELECT Country,SUM(Total_Amount) AS total_sales
FROM global_ecommerce_sales
GROUP BY Country
ORDER BY total_sales DESC;

#Orders by country#
SELECT Country,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY Country
ORDER BY total_orders DESC;

#Average Order Value by Country#
SELECT Country,ROUND(AVG(Total_Amount), 2) AS average_order_value
FROM global_ecommerce_sales
GROUP BY Country
ORDER BY average_order_value DESC;

#Top 5 Countries by Sales#
SELECT Country,ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY Country
ORDER BY  total_sales DESC
LIMIT 5;

#Sales by Category#
SELECT Category,SUM(Total_Amount) AS total_sales
FROM global_ecommerce_sales
GROUP BY Category
ORDER BY total_sales DESC;

#Orders by Category#
SELECT Category,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY Category
ORDER BY total_orders DESC;

#Average Order Value BY Category#
SELECT Category,ROUND(AVG(Total_Amount), 2) AS average_order_value
FROM global_ecommerce_sales
GROUP BY Category
ORDER BY average_order_value DESC;

#Top 3 Categories Sales#
SELECT Category,ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY Category
ORDER BY  total_sales DESC
LIMIT 3;

#First and last Order Date#
SELECT
    MIN(STR_TO_DATE(REPLACE(Order_Date, '-', '/'), '%c/%e/%Y')) AS first_order_date,
    MAX(STR_TO_DATE(REPLACE(Order_Date, '-', '/'), '%c/%e/%Y')) AS last_order_date
FROM global_ecommerce_sales;

#Monthly Sales#
SELECT MONTHNAME(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
        STR_TO_DATE(TRIM(order_date), '%c-%e-%Y'))) AS month,
        ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
		STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')))
ORDER BY MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
        STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')));

#Monthly Orders#
SELECT MONTHNAME(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
        STR_TO_DATE(TRIM(order_date), '%c-%e-%Y'))) AS month,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')))
ORDER BY MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
    STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')));

#Best Sales Month#
SELECT MONTHNAME(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
        STR_TO_DATE(TRIM(order_date), '%c-%e-%Y'))) AS month,
        ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
		STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')))
ORDER BY total_sales DESC
LIMIT 1;

#Categorize Orders#
SELECT Order_id,Total_Amount,
    CASE WHEN Total_Amount >= 3000 THEN 'High Value'
         WHEN Total_Amount >= 1500 THEN 'Medium Value'
        ELSE 'Low Value'
    END AS order_value_category
FROM global_ecommerce_sales;

#Count Order Categories#
SELECT
    CASE WHEN Total_Amount >= 3000 THEN 'High Value'
         WHEN Total_Amount >= 1500 THEN 'Medium Value'
         ELSE 'Low Value'
    END AS order_value_category,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY order_value_category;

#Countries With Sales Above 150,000#
SELECT Country,ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY Country
HAVING SUM(Total_Amount) > 150000
ORDER BY total_sales DESC;

#Categories With More Than 145 Orders#
SELECT Category,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY Category
HAVING COUNT(*) > 145
ORDER BY total_orders DESC;

#Orders Above Average#
SELECT Order_id,Country,Category,Total_Amount
FROM global_ecommerce_sales
WHERE Total_Amount >
(
    SELECT AVG(Total_Amount)
    FROM global_ecommerce_sales
)
ORDER BY Total_Amount DESC;

#Highest Value Order#
SELECT *
FROM global_ecommerce_sales
WHERE Total_Amount =
(
    SELECT MAX(Total_Amount)
    FROM global_ecommerce_sales
);

#Rank Orders By Sales#
SELECT Order_id,Country,Category,Total_Amount,
    RANK() OVER (
    ORDER BY Total_Amount DESC
    ) AS sales_rank
FROM global_ecommerce_sales;

#Rank Countries by Sales#
SELECT Country,ROUND(SUM(Total_Amount), 2) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(Total_Amount) DESC
    ) AS country_rank
FROM global_ecommerce_sales
GROUP BY Country;

#Rank Categories by Sales#
SELECT Category,ROUND(SUM(Total_Amount), 2) AS total_sales,
    RANK() OVER (
        ORDER BY SUM(Total_Amount) DESC
    ) AS category_rank
FROM global_ecommerce_sales
GROUP BY Category;

#Top 5 Orders#
SELECT Order_id,Country,Category,Total_Amount
FROM global_ecommerce_sales
ORDER BY Total_Amount DESC
LIMIT 5;

#Country+Category Sales#
SELECT Country,Category,ROUND(SUM(Total_Amount), 2) AS total_sales
FROM global_ecommerce_sales
GROUP BY Country, Category
ORDER BY total_sales DESC;

#Country+Category Orders#
SELECT Country,Category,COUNT(*) AS total_orders
FROM global_ecommerce_sales
GROUP BY Country, Category
ORDER BY total_orders DESC;

#check invalid dates#
SELECT
    COUNT(*) AS total_records,
    SUM(CASE WHEN order_date LIKE '%/%'AND STR_TO_DATE(order_date, '%c/%e/%Y') IS NULL THEN 1
            WHEN order_date LIKE '%-%'AND STR_TO_DATE(order_date, '%m-%d-%Y') IS NULL THEN 1
            WHEN order_date NOT LIKE '%/%'AND order_date NOT LIKE '%-%'THEN 1 ELSE 0 END) 
            AS invalid_dates
FROM global_ecommerce_sales;
-- Result: 0 invalid dates 

#Export Cleaned E-Commerce Data for Power BI#
SELECT Order_ID,Country,Category,Unit_Price,Quantity,Total_Amount,
    COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),STR_TO_DATE(TRIM(order_date), '%c-%e-%Y')) 
       AS order_date_clean
FROM global_ecommerce_sales;

-- Monthly Sales Using CTE
WITH MonthlySales AS (
    SELECT MONTHNAME(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
    STR_TO_DATE(TRIM(order_date), '%c-%e-%Y'))) AS month,
        MONTH(COALESCE(STR_TO_DATE(TRIM(order_date), '%c/%e/%Y'),
            STR_TO_DATE(TRIM(order_date), '%c-%e-%Y'))) AS month_number,ROUND(SUM(Total_Amount), 2) 
            AS total_sales
    FROM global_ecommerce_sales
    GROUP BY month, month_number
)
SELECT month,total_sales,RANK() OVER (ORDER BY total_sales DESC) AS sales_rank
FROM MonthlySales
ORDER BY sales_rank;

-- JOIN: Orders with Country-wise Sales
SELECT o.Order_ID,o.Country,o.Total_Amount,c.country_total_sales
FROM global_ecommerce_sales AS o
INNER JOIN (SELECT Country,ROUND(SUM(Total_Amount), 2) AS country_total_sales
    FROM global_ecommerce_sales
    GROUP BY Country
) AS c
ON o.Country = c.Country;


