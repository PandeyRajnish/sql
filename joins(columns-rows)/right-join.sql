-- RIGHT JOIN - Returns all rows from right and ony matching from left

/* Get all customers along with their orders, including orders without matching 
	customers Using RIGHT JOIN
*/
-- RIGHT JOIN
SELECT * 
FROM customers;

SELECT *
FROM orders;

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
RIGHT JOIN orders AS o
ON c.id = o.customer_id

/* Get all customers along with their orders, including orders without matching 
	customers using LEFT JOIN
*/

-- Alternative left join 
-- Left join is more famous then right join
-- always try to use left join

SELECT 
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM orders AS o
LEFT JOIN customers AS c 
ON c.id = o.customer_id