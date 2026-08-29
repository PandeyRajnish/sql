-- Filters your data based on condition

-- Retrive customers with a score not equal to 0

SELECT *  -- step 3
FROM customers   -- step 1
WHERE score != 0; -- step 2 

-- Retrive the customers from the Germany
SELECT *
FROM customers
WHERE country = 'Germany';

-- Retrieve the customer with name and country from Germany
SELECT 
	first_name,
	country
FROM customers
WHERE country = 'Germany';