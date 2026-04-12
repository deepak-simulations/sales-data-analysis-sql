# Total revenue


SELECT SUM(Sales_Amount) AS total_sales
FROM sales_data;


## CATEGORY ANALYSIS

# Highest revenue 

SELECT Product_Category, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY Product_Category
ORDER BY total_sale DESC
LIMIT 1;

#Lowest revenue
SELECT Product_Category, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY Product_Category
ORDER BY total_sale 
LIMIT 1;


## Region Analysis

#Highest revenue
SELECT Region, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY Region
ORDER BY total_sale DESC 
LIMIT 1;

#Lowest revenue
SELECT Region, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY Region
ORDER BY total_sale 
LIMIT 1;

## TIME ANALYSIS 

#Highest revenue
SELECT strftime('%m',Sale_Date) AS month, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY month 
ORDER BY total_sale DESC 
LIMIT 1;

#Lowest revenue
SELECT strftime('%m',Sale_Date) AS month, SUM(Sales_Amount) AS total_sale 
FROM sales_data
GROUP BY month
ORDER BY total_sale 
LIMIT 1;

## PROFIT ANYLYSIS

#Highest profit
SELECT Product_Category, sum((CAST(Unit_Price AS REAL) - CAST(Unit_Cost AS REAL)) * CAST(Quantity_Sold AS REAL )) AS total_profit
FROM sales_data
GROUP BY Product_Category
ORDER BY  total_profit DESC
LIMIT 1;

#Lowest profit 
SELECT Product_Category, sum((CAST(Unit_Price AS REAL) - CAST(Unit_Cost AS REAL)) * CAST(Quantity_Sold AS REAL )) AS total_profit
FROM sales_data
GROUP BY Product_Category
ORDER BY  total_profit 
LIMIT 1;

## Category which has revenue above average.
SELECT Product_Category, sum(CAST(Sales_Amount AS REAL)) AS total_sales
FROM sales_data
GROUP BY Product_Category
HAVING total_sales > (
  SELECT AVG(category_total)
  FROM (
    SELECT SUM(CAST(Sales_Amount AS REAL)) AS category_total
    FROM sales_data
    GROUP BY Product_Category
  )
);


## Category which has revenue below average.
SELECT Product_Category, sum(CAST(Sales_Amount AS REAL)) AS total_sales
FROM sales_data
GROUP BY Product_Category
HAVING total_sales <  (
  SELECT AVG(category_total)
  FROM (
    SELECT SUM(CAST(Sales_Amount AS REAL)) AS category_total
    FROM sales_data
    GROUP BY Product_Category
  )
);

## Avarage revenue of  the categories
SELECT ROUND(AVG(category_total),2)  AS average_category_revenue
FROM  (
      SELECT SUM(CAST(Sales_Amount AS REAL)) AS category_total
      FROM sales_data
      GROUP BY Product_Category
       );
