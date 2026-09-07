-- LEFT JOIN - ( all rows from left and only matching from right

-- The order is important in LEFT JOIN

/* Get all customers along with their orders,
	including those withoud orders
*/

SELECT
	c.id,
	c.first_name,
	o.order_id,
	o.sales
FROM customers AS c
LEFT JOIN orders AS o
ON c.id = o.customer_id