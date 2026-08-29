-- TOP (Limit) - Restrict the number of rows returned

-- Retrieve only three customers

SELECT  TOP 3 *
FROM customers

-- Retrive the Top 3 customers with highest scores

SELECT TOP 3 * 
FROM customers
ORDER BY score DESC

-- Retrive the lowest 2 customers based on the score

SELECT TOP 2 *
FROM customers
ORDER BY score ASC;

-- Get the two most recent orders

SELECT TOP 2 *
FROM orders
ORDER BY order_date DESC