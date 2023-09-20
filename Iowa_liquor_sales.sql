-- CODES FOR BIGQUERY


-- Total sales by year

SELECT
  DISTINCT(FORMAT_DATE('%Y', date)) AS years,
  ROUND(SUM(sale_dollars),2) AS total_sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY
  years
ORDER BY
  years DESC;


-- Seasonal patterns

SELECT
	DISTINCT (FORMAT_DATE('%B', date)) AS months,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

GROUP BY 
	months
ORDER BY
	total_sales DESC;


-- Sales trends '18 - '22

WITH sales AS (
	SELECT
	FORMAT_DATE('%Y', date) AS year,
	ROUND(CAST(SUM(sale_dollars) AS numeric)) AS total_sales
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
WHERE date BETWEEN '2017-01-01' AND '2022-12-31'
GROUP BY year
ORDER BY 2 DESC
)

SELECT
	year, total_sales,
	ROUND(((total_sales/LAG(total_sales) OVER (ORDER BY year)) - 1)*100,1) AS change
FROM
	sales
ORDER BY
	1 DESC;


-- Consumption trend '18 - '22

WITH liters AS (
	SELECT
	FORMAT_DATE('%Y', date) AS year,
	ROUND(SUM(volume_sold_liters)) AS total_liters
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
WHERE date BETWEEN '2017-01-01' AND '2022-12-31'
GROUP BY year
ORDER BY 2 DESC
)

SELECT
	year, total_liters,
	ROUND(((total_liters/LAG(total_liters) OVER (ORDER BY year)) - 1)*100,1) AS change
FROM
	liters
ORDER BY
	1 DESC;


-- Which days have the highest sales?

SELECT
	DISTINCT(FORMAT_DATE('%A', date)) AS days,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

GROUP BY 
	days
ORDER BY
	total_sales DESC;


-- Sales by Month '21 to '22

SELECT
	DISTINCT(FORMAT_DATE('%b %Y', date)) AS month_year,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE date BETWEEN '2022-01-01' AND '2023-08-29'
GROUP BY
	month_year
ORDER BY
	month_year, total_sales; 


-- Highest sales/volume revenue (2022)

SELECT
	FORMAT_DATE('%Y', date) AS year, 
  item_description AS item,
  category_name AS category,
  SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE 
  FORMAT_DATE('%Y', date) LIKE ('%2022%')

GROUP BY 
	1, 2, 3

ORDER BY
	5 DESC;


-- Store with the highest sales

SELECT
	store_name AS store,
	county AS county,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE FORMAT_DATE('%Y', date) LIKE ('%2022')

GROUP BY
	1, 2

ORDER BY
	4 DESC;


-- Geographical patterns

SELECT
	store_name AS store,
	county AS county,
	category_name AS category,
	item_description AS item,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE FORMAT_DATE('%Y', date) LIKE ('%2022') AND county is not null

GROUP BY
	1, 2, 3, 4

ORDER BY
	2,5 DESC;

	

	
