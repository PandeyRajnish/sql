-- DISTINCT - remove duplicates ( Repeated Values )
-- Each Value appears only once

-- Bad habbits with DISTINCT - Don't use DISTINCT unless
-- it's necessary; it can slow down your query

-- if data is unique don't apply


-- Return unique list of all countries

SELECT DISTINCT
	country
FROM customers;
