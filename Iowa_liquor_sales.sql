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


-- Which days have the highest sales?

SELECT
	DISTINCT(FORMAT_DATE('%A', date)) AS days,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

GROUP BY 
	days
ORDER BY
	total_sales DESC;


-- Which months have the highest sales?

SELECT
	DISTINCT (FORMAT_DATE('%B', date)) AS months,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

GROUP BY 
	months
ORDER BY
	total_sales DESC;


-- Sales by Vendor

SELECT
	vendor_name AS vendor,
	ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

GROUP BY 
	vendor
ORDER BY
	total_sales DESC;


-- Sales by Month '22 to '23

SELECT
	DISTINCT(FORMAT_DATE('%b %Y', date)) AS month_year,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE date BETWEEN '2022-01-01' AND '2023-08-29'
GROUP BY
	month_year
ORDER BY
	month_year, total_sales; 


-- Highest sales revenue (2022)

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


-- Highest sales revenue (2023)

SELECT
	FORMAT_DATE('%Y', date) AS year, 
  item_description AS item,
  category_name AS category,
  SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE 
  FORMAT_DATE('%Y', date) LIKE ('%2023%')

GROUP BY 
	1, 2, 3

ORDER BY
	5 DESC;


-- Highest sales volume (2022)

SELECT
	FORMAT_DATE('%Y', date) AS year,
  item_description AS item,
  category_name AS category,
  SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE FORMAT_DATE('%Y', date) LIKE ('%2022%')

GROUP BY 
	1, 2, 3

ORDER BY
	4 DESC;


-- Highest sales volume (2023)
SELECT
	FORMAT_DATE('%Y', date) AS year,
  item_description AS item,
  category_name AS category,
  SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE FORMAT_DATE('%Y', date) LIKE ('%2023%')

GROUP BY 
	1, 2, 3

ORDER BY
	4 DESC;


-- Seasonal patterns

SELECT
	DISTINCT(FORMAT_DATE('%m - %Y', date)) AS month_year,
  category_name AS category,
	MAX(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE FORMAT_DATE('%Y', date) LIKE ('%2022')

GROUP BY 
	1, 2

ORDER BY
	1, 3 DESC;


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


-- Underperforming stores

SELECT 
  date,
	address,
	city,
  item_description AS item,
  category_name AS category,
  SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM `bigquery-public-data.iowa_liquor_sales.sales` 

WHERE store_name = 'HY-VEE WINE AND SPIRITS / WATERLOO!'

GROUP BY 1, 2, 3, 4, 5;


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
	
