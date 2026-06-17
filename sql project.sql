select * FROM  sales_pipeline;

SELECT month(engage_date), count(*)
FROM sales_pipeline
GROUP BY MONTH ( engage_date)
ORDER BY count(*) DESC
