
-- *********************
--      SPRINT 2 
-- *********************

------------------------  
--     Nivel 1        --
------------------------
-- Ejercici 1 

	SELECT * FROM transaction 
	WHERE company_id IN 
		(SELECT id FROM company c WHERE country= "Germany") 

 
-- Ejercici 2 
	SELECT company_name, vendes FROM (
		SELECT company_name, (SELECT sum(amount) FROM transaction WHERE company_id=c.id) as vendes
		FROM company c
		) t
	WHERE vendes > (SELECT AVG(amount) FROM transaction)


-- Ejercici 3

	SELECT company_id,credit_card_id, timestamp, amount,declined FROM transaction 
	WHERE company_id IN 
		(SELECT id FROM company c WHERE upper(company_name) like 'C%') 


-- Ejercici 4

	SELECT * FROM company 
	WHERE id not IN ( 
		SELECT company_id FROM transaction)



------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 

	SELECT * FROM transaction WHERE company_id IN 
		(SELECT id FROM company WHERE country IN 
			(SELECT country FROM company WHERE company_name='Non Institute')
	)


-- Ejercici 2

	SELECT company_name, vendes FROM (
		SELECT company_name, (SELECT SUM(amount) FROM transaction WHERE company_id=c.id) as vendes
		FROM company c
		) t
	WHERE vendes = (
		SELECT SUM(amount) as ven  
		FROM transaction 
		GROUP BY company_id 
		ORDER BY ven DESC LIMIT 1 
		); 



------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

	SELECT country, SUM(vendes) / SUM(numTrans) as avgVendes FROM (
		SELECT id, country,(
					SELECT SUM(amount) 
					FROM transaction 
					WHERE company_id=c.id
					group by company_id
			) vendes,
			(
					SELECT COUNT(amount) 
					FROM transaction 
					WHERE company_id=c.id
					GROUP BY company_id
			) numTrans
		FROM company c
		) t
	GROUP BY country
	HAVING avgVendes >(SELECT AVG(amount) FROM transaction)	   


-- Ejercici 2

SELECT company_name, if (numTrans>4, "Mes de 4" , "4 o menys") as Trans 
FROM (
	SELECT company_name,
		(SELECT count(id) FROM transaction WHERE company_id=c.id ) numTrans
	FROM company c
)t
