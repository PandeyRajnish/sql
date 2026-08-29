-- Retrieve All Customer Data

USE MyDatabase;

SELECT *
FROM customers; 


-- Retrieve all order data

SELECT *
FROM orders;

-- Retrieve each customer's name, country, and score
SELECT 
	first_name,
	country,
	score
FROM customers;