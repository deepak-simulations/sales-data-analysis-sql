WITH base AS (
     SELECT Product_Category,
            Region,
            SUM(Sales_Amount) AS total_sales

     FROM sales_data
     GROUP BY Product_Category,Region)
,region_performance AS (
    SELECT Product_Category,
           Region,
           total_sales,
           AVG(total_sales) OVER(PARTITION BY Region) AS region_avg
    FROM   base
    ORDER BY Region, total_sales DESC
),
final AS(
  SELECT * , 
       ROUND(((total_sales - region_avg)/region_avg)*100,2) as performance_gap_percent 
  FROM region_performance
)

SELECT *,
      CASE
        WHEN performance_gap_percent > 10 THEN 'High'
        WHEN performance_gap_percent  >=-10 THEN 'Moderate'
        ELSE 'LOW'
      END AS performance_lable,

      ROW_NUMBER() OVER(
        PARTITION BY Region
        ORDER BY total_sales DESC
        )AS rank
FROM final;

