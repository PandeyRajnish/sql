-- Combines rows with a same value
-- Aggregates a column By another Column 
-- Find Total score by country

-- Find the total score for each country

SELECT
	country, -- category
	SUM(score) -- Aggregation
FROM customers
GROUP BY country

SELECT 
	country,
	first_name, 
	SUM(score)
FROM customers
GROUP BY country, first_name;

SELECT *
FROM customers;

/* Find the total score and the total number of
customers for each country
*/

SELECT 
	country,
	SUM(score) AS total_score,
	COUNT(id) AS total_customers
FROM customers
GROUP BY country