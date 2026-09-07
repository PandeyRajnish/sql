-- Comparison operators

SELECT *
FROM customers 
WHERE country = 'USA'

SELECT *
FROM customers 
WHERE country != 'USA'

SELECT *
FROM customers 
WHERE score > 600

SELECT *
FROM customers 
WHERE score >= 500

SELECT *
FROM customers 
WHERE score < 800

SELECT *
FROM customers 
WHERE score <= 500


-- Logical Operators 
-- AND -both condition should be true
/* Retrieve all customers who are from USA
or have a score greater than 500. */
SELECT *
FROM customers 
WHERE country = 'USA' AND score > 500

--OR - At least one condition true
/* Retrieve all customers who are either from USA
or have a score greater than 500. */

SELECT *
FROM customers
WHERE country = 'USA' OR score > 500

--NOt
/* Retrieve all customers with a score not less
	than 500 
*/

SELECT * 
FROM customers
WHERE NOT score >= 500

-- Range operatore 
-- BETWEEN
/* Retrieve all customers who whose score falls
	in the range between 100 and 500
*/
-- skip this use AND ( comparison)
SELECT * 
FROM customers
WHERE score BETWEEN 100 AND 500

-- same with and logical operatore
SELECT * 
FROM customers
WHERE score >= 100 AND score <= 500


-- MEmbership Operatore
--IN - value exist in list

/* Retrieve all customers from either Germany or
USA
*/

SELECT *
FROM customers
WHERE country = 'Germany' 
OR country = 'USA'
OR country = 'UK'

-- same using IN always use this 
SELECT * 
FROM customers
WHERE country IN ('Germany', 'USA', 'UK')



-- Search Operator
-- Search for text patter

/* Find all the customers whose first name starts with 
'M' */

SELECT *
FROM customers
WHERE first_name LIKE 'M%'


/* Find all the customers whose first name ends with 
'n' */

SELECT * 
FROM customers
WHERE first_name LIKE '%n'


/* Find all the customers whose first name contains
'r' */

SELECT *
FROM customers
WHERE first_name LIKE '%r%'


/* Find all the customers whose first name has 'r' 
in the 3rd position */

SELECT *
FROM customers
WHERE first_name LIKE '__r%'