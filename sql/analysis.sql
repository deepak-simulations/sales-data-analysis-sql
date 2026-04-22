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



## Label categories ( High/Medium/Low)
SELECT
Product_Category,
total_sale,

CASE
  WHEN total_sale > (
     SELECT AVG(category_total)
     FROM (
       SELECT SUM(Sales_Amount) AS category_total 
       FROM sales_data
       GROUP BY Product_Category
          )
    ) THEN 'HIGH'
   ELSE 'LOW'
  END

FROM(
  SELECT
    Product_Category,
    SUM(Sales_Amount) AS total_sale
  FROM sales_data
  GROUP BY Product_Category
);


#top performance region wiese

SELECT
t.Product_Category,
t.Region,
t.total_sales

FROM(
   SELECT Product_Category,Region,SUM(CAST(Sales_Amount AS REAL)) AS total_sales
   FROM  sales_data
   GROUP BY Product_Category,Region
    ) As t
WHERE t.total_sales = (
   SELECT MAX(total_sales)
   FROM (
        SELECT Region,Product_Category,SUM(CAST(Sales_Amount AS REAL)) AS total_sales
        FROM sales_data
        GROUP BY Region,Product_Category)t2
        WHERE t2.Region = t.Region
);


# use of window functions 

SELECT
  Region,
  Product_Category,
  total_sales

FROM (
  SELECT 
    Region,
    Product_Category,
    SUM(Sales_Amount) AS total_sales,
   

   ROW_NUMBER() OVER(
     PARTITION BY Region
     ORDER BY SUM(Sales_Amount) DESC
   ) AS rank 
   FROM sales_data
   GROUP BY Region,Product_Category
)t
Where rank= 1;



# top 2 categories performance wise

SELECT
  Region,
  Product_Category,
  total_sales

FROM (
  SELECT 
    Region,
    Product_Category,
    SUM(Sales_Amount) AS total_sales,
   

   ROW_NUMBER() OVER(
     PARTITION BY Region
     ORDER BY SUM(Sales_Amount) DESC
   ) AS rank 
   FROM sales_data
   GROUP BY Region,Product_Category
)t
Where rank <= 2;


# regions wehre the top category contributes more than 50% of total region sales 


SElECT 
Product_Category,
Region,
total_sales,
region_total,
ROUND((total_sales/region_total)*100,2) AS contribution

FROM(
SELECT
   Product_Category,
   Region,
   total_sales,
   SUM(total_sales) OVER(PARTITION BY Region) AS region_total,


    ROW_NUMBER() OVER(
        PARTITION BY Region
        ORDER BY total_sales DESC
       ) AS rank


FROM(
   SELECT
      SUM(Sales_Amount) AS total_sales,
      Product_Category,
      Region


   FROM sales_data
   GROUP BY Product_Category, Region
 ));


#Find top two category per region




SELECT
    Product_Category,
    Region,
    total_sales,
    total_region,
    ROUND((total_sales/total_region)*100,2) AS contribution
FROM(
SELECT*
FROM(
SELECT
    Product_Category,
    Region,
    total_sales,
    SUM(totaL_sales) OVER(PARTITION BY Region) AS total_region,

    ROW_NUMBER() OVER(
          PARTITION BY Region
           ORDER BY total_sales DESC
          ) AS rank
     
FROM(
SElECT 
Product_Category,
Region,
SUM(Sales_Amount) AS total_sales

FROM sales_data
GROUP BY Product_Category,Region
)t
)final
WHERE rank <= 2
);
