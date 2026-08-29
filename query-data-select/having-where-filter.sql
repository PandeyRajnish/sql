-- Having - Filters data after aggregation
-- Can be used only with the group

-- Filter your data -1.  Before aggregation Where
-- Flilter you data -2.  After aggregation Having


/* Find the average score for each country
   considering only customers with a score not equal to 0
   and return only those countries with an average score
   greater than 430
*/

SELECT
	country,
	AVG(score) AS avg_score
FROM customers
WHERE score !=0
GROUP BY country
HAVING AVG(score) > 430