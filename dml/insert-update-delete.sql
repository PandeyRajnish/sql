-- DML

--INSERT
INSERT INTO customers(id, first_name, country, score)
VALUES(11, 'Raj', 'INDIA',500),
      (12, 'SAM', 'USA', NULL),
	  (13, 'USA', 'Max', NULL)

INSERT INTO customers (id, first_name)
VALUES (14, 'Manish')

-- Insert table from source table to target table
-- Copy data from customers table into persons
INSERT INTO persons (id, person_name, birth_date, email)
SELECT 
	id,
	first_name,
	NULL,
	'UNKNOWN'
FROM customers

--Update - change already existing rows
-- Change the score of customer 6 to 0

-- Without where it is very risky update all coluns data
UPDATE customers 
SET score = 0
WHERE id = 6

-- Change the score of customer 10 to 0 and update 
-- the country to UK
UPDATE customers
SET score = 0,
	country = 'UK'
WHERE id = 10

-- Update all customers with a Null score
-- by setting their score to 0

UPDATE customers
SET score = 0
WHERE score IS NULL


-- Remove (DELETE) rows from the table
-- DELETE all the customers with an ID greater than 5.
DELETE FROM customers 
WHERE id > 5 -- always use where

TRUNCATE TABLE persons


SELECT * FROM customers; 
SELECT * FROM persons;

SELECT * 
FROM customers 
WHERE id = 6