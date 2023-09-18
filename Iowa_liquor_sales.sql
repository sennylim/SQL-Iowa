-- Total sales by year

SELECT 
	EXTRACT ('YEAR' FROM date) AS years,
	ROUND(SUM(sale_dollars)) AS total_sales

FROM iowa

GROUP BY 
	years
ORDER BY
	years DESC;


-- Which days have the highest sales?

SELECT
	to_char(date, 'Day') AS days,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM iowa

GROUP BY 
	days
ORDER BY
	total_sales DESC;


-- Which months have the highest sales?

SELECT
	to_char(date, 'Month') AS months,
	ROUND(CAST(SUM(sale_dollars) as numeric),2) AS total_sales 

FROM iowa

GROUP BY 
	months
ORDER BY
	total_sales DESC;


-- Sales by Vendor

SELECT
	lower(vendor_name) AS vendor,
	ROUND(CAST(SUM(sale_dollars) AS numeric),0) AS total_sales

FROM iowa

GROUP BY 
	vendor
ORDER BY
	total_sales DESC;


-- How have liquor sales in Iowa changed over the past year? (from '22 to '23)

SELECT
	DATE_TRUNC('MONTH', date) AS months,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM iowa
WHERE date BETWEEN '2022-01-01' AND '2023-08-29'
GROUP BY
	months
ORDER BY
	months, total_sales;

	
-- Which types of liquor have the highest sales revenue?

SELECT
	EXTRACT ('YEAR' FROM date) AS years,
	lower(item_description) AS item,
	lower(category_name) AS category,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM iowa

WHERE date BETWEEN '2022-01-01' AND '2023-08-29'

GROUP BY 
	1, 2, 3

ORDER BY
	5 DESC;

	
-- Which types of liquor have the highest sales volume?

SELECT
	EXTRACT ('YEAR' FROM date) AS years,
	lower(item_description) AS item,
	lower(category_name) AS category,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM iowa

WHERE date BETWEEN '2022-01-01' AND '2023-08-29'

GROUP BY 
	1, 2, 3

ORDER BY
	4 DESC;

	
-- Are there any seasonal trends in liquor sales?

SELECT
	to_char(date, 'Month') AS months,
	lower(category_name) AS category,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales

FROM iowa

WHERE date BETWEEN '2020-01-01' AND '2023-08-29'
GROUP BY 
	1, 2

ORDER BY
	3 DESC;

	
-- Which liquor stores in Iowa have the highest sales?

SELECT
	lower(store_name) AS store,
	lower(county) AS county,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1, 2

ORDER BY
	4 DESC;

	
-- Are there any stores that are underperforming?

SELECT category_name, item_description, pack, state_bottle_cost, state_bottle_retail

FROM iowa

WHERE lower(store_name) = 'kum & go #570 / johnston' 
	OR lower(store_name) = 'raysmarket';

	
-- Is there any geographic patterns in store performance?

SELECT
	lower(store_name) AS store,
	lower(county) AS county,
	lower(category_name) AS category,
	lower(item_description) AS item,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1, 2, 3, 4

ORDER BY
	5 DESC;

	
-- Which liquor brands are the best-sellers? (by bottles)

SELECT
	lower(item_description) AS item,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1

ORDER BY
	2 DESC;


-- Which liquor brands are the best-sellers? (by total sales)
SELECT
	lower(item_description) AS item,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1

ORDER BY
	3 DESC;


-- Which liquor products are the best-sellers? (by bottles)
SELECT
	lower(category_name) AS category,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1

ORDER BY
	2 DESC;


-- Which liquor products are the best-sellers? (by total sales)
SELECT
	lower(category_name) AS category,
	SUM(bottles_sold) AS bottle_sales,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa
WHERE date BETWEEN '2020-01-01' AND '2023-08-29'

GROUP BY
	1

ORDER BY
	3 DESC;


-- Are there any products with declining sales?

WITH monthly_sales AS (
	SELECT
	EXTRACT ('Year' FROM date) AS years,
	to_char (date, 'Month') AS months,
	lower(item_description) AS items,
	ROUND(CAST(SUM(sale_dollars) AS numeric), 0) AS total_sales
	
FROM iowa

GROUP BY
	1, 2, 3
)
SELECT
	years, months, items, total_sales,
	LAG(total_sales) OVER (ORDER BY years, months) AS sales_previous_month,
	total_sales - LAG(total_sales) OVER (ORDER BY years, months) AS month_to_month_difference
FROM
	monthly_sales
GROUP BY
	1, 2, 3, 4
ORDER BY
	1, 2;
