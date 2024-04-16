
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
	SELECT (
		SELECT company_name FROM company WHERE id=t.company_id) as Company,
		amount
	FROM transaction t
	WHERE amount > (SELECT AVG(amount) 
					FROM transaction)



-- Ejercici 3

	SELECT company_id,credit_card_id, timestamp, amount,declined 
	FROM transaction 
	WHERE company_id IN 
		(SELECT id FROM company c WHERE upper(company_name) like 'C%') 


-- Ejercici 4

	SELECT * 
	FROM company 
	WHERE id NOT IN ( 
		SELECT company_id 
		FROM transaction)



------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 

	SELECT * 
	FROM transaction 
	WHERE company_id IN 
		(SELECT id 
		 FROM company 
		 WHERE country IN 
			(SELECT country 
			 FROM company 
			 WHERE company_name='Non Institute')
	)


-- Ejercici 2

	SELECT company_name, vendes FROM (
		SELECT company_name, (
			SELECT SUM(amount) 
			FROM transaction 
			WHERE company_id=c.id) AS vendes
		FROM company c
		) t
	WHERE vendes = (
		SELECT SUM(amount) AS ven  
		FROM transaction 
		GROUP BY company_id 
		ORDER BY ven DESC LIMIT 1 
		); 



------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

	SELECT country, SUM(vendes) / SUM(numTrans) AS avgVendes 
	FROM (
		SELECT id, country,(
					SELECT SUM(amount) 
					FROM transaction 
					WHERE company_id=c.id
					GROUP BY company_id
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
	HAVING avgVendes > (SELECT AVG(amount) 
						FROM transaction
						)	   


-- Ejercici 2

SELECT company_name, IF (numTrans>4, "Mes de 4" , "4 o menys") AS Trans 
FROM (
	SELECT company_name,
		(SELECT COUNT(id) 
		 FROM transaction 
		 WHERE company_id=c.id ) numTrans
	FROM company c
)t
