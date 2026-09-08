-- LEFT ANTI JOIN - return rows from left that has NO MATCH in Right
-- Look up (FIlter)
-- Not for data just a Filter

/* Get all customers who haven't place any order */

SELECT *
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id
