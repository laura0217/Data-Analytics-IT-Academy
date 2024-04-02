------------------------  
--     Nivel 1        --
------------------------
-- Ejercici 1 
 --No hay queries, se ejecutan las sql de los ficheros proporcionados --
 
-- Ejercici 2 
SELECT company_name, email, country 
FROM company 
ORDER BY company_name

-- Ejercici 3
SELECT DISTINCT country 
FROM company c INNER JOIN transaction t
ON c.id=t.company_id

-- Ejercici 4
SELECT COUNT(DISTINCT country) AS numPaisos 
FROM company c INNER JOIN transaction t
ON c.id=t.company_id


-- Ejercici 5
SELECT company_name,country 
FROM company
WHERE id='b-2354'

-- Ejercici 6
SELECT company_name, AVG (amount) 
FROM company c INNER JOIN transaction t
ON c.id=t.company_id
GROUP BY company_name
LIMIT 1


------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 
SELECT id, count(id) 
FROM company 
GROUP BY id
HAVING count(id) > 1

-- Ejercici 2
SELECT DATE(timestamp) AS fecha, SUM(amount) AS ventas 
FROM transaction 
GROUP BY fecha
ORDER BY ventas desc
LIMIT 5

-- Ejercici 3
SELECT DATE(timestamp) AS fecha, SUM(amount) AS ventas 
FROM transaction 
GROUP BY fecha
ORDER BY ventas 
LIMIT 5

-- Ejercici 4
SELECT country, AVG(amount) AS ventas 
FROM company c INNER JOIN transaction t
ON c.id=t.company_id
group by country
ORDER BY ventas DESC

------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

SELECT company_name, phone, country, amount 
FROM company c INNER JOIN transaction t
ON c.id=t.company_id
WHERE amount BETWEEN 100 AND 200
ORDER BY amount DESC


-- Ejercici 2
SELECT company_name, DATE(timestamp) AS fecha
FROM company c INNER JOIN transaction t
ON c.id=t.company_id
HAVING fecha IN ('2022-03-16','2022-02-18','2022-02-13')