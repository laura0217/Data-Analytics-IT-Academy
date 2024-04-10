
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
	SELECT company_name, SUM(amount) 
	FROM company inner join transaction 
	ON company.id=transaction.company_id
	GROUP BY company_name 
	HAVING SUM(amount)> (
	SELECT AVG(amount) FROM transaction)


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

	SELECT company_id,company_name, amount 
	FROM company, transaction 
	WHERE company.id=transaction.company_id
	AND amount =(SELECT max(amount) FROM transaction)



------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

	SELECT AVG (amount) as avgAmount, country  
	FROM company, transaction 
	WHERE company.id=transaction.company_id
	GROUP BY country
	HAVING AVG(amount) > (SELECT AVG(amount) FROM transaction)


-- Ejercici 2

SELECT company_name, if (numTrans>4, "Más de 4" , "Menos") as Trans, numTrans FROM (
	SELECT  company_name, count(t.id) as numTrans
	FROM company c inner join transaction t
	ON c.id=company_id
	GROUP BY company_name
) as t1