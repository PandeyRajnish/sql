-- ORDER BY: sort the result (runs LAST)
-- ASC  = lowest → highest  (default — still write it)
-- DESC = highest → lowest

/* Highest score first */
SELECT *                -- 2  pick columns
FROM customers          -- 1  load table
ORDER BY score DESC;    -- 3  sort last

/* Lowest score first */
SELECT *
FROM customers
ORDER BY score ASC;

-- Nested: first key, then tie-breaker
-- country A→Z, then highest score inside each country
SELECT *                        -- 2  pick columns
FROM customers                  -- 1  load table
ORDER BY                        -- 3  sort last
    country ASC,
    score DESC;