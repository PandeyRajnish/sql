-- INNER JOIN ( can be used for either combined or filter data)

/* Get all customers along with their orders
	but only for customers who have placed an order
*/

-- Not good practice pick few columns as id twice
SELECT *
FROM customers
INNER JOIN orders
ON id = customer_id

-- Still due to long table names we can use Aliases
-- use aliases for best practices
SELECT 
	customers.id,
	customers.first_name,
	orders.order_id,
	orders.sales
FROM customers
INNER JOIN orders
ON customers.id = orders.customer_id

-- best practices with aliases
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
INNER JOIN orders AS o
ON c.id = o.customer_id

-- Order of the table doen't matter
-- inner join order doen't matter
SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
INNER JOIN customers AS c
ON c.id = o.customer_id