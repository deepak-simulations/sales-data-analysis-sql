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

