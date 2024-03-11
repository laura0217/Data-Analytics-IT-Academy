
-- *********************
--      SPRINT 2 
-- *********************

------------------------  
--     Nivel 1        --
------------------------
-- Ejercici 1 

	Select * from transaction 
	where company_id in 
	(select id from company c where country= "Germany") 

 
-- Ejercici 2 
	select company_name, sum(amount) 
	from company inner join transaction 
	on company.id=transaction.company_id
	group by company_name 
	having sum(amount)> (
	Select avg(amount) from transaction)


-- Ejercici 3

	Select company_id,credit_card_id, timestamp, amount,declined from transaction 
	where company_id in 
	(select id from company c where upper(company_name) like 'C%') 


-- Ejercici 4

	Select * from company 
	where id not in ( select company_id from transaction)



------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 

	select * from transaction where company_id in 
	(select id from company where country in 
	   (Select country from company where company_name='Non Institute')
	)


-- Ejercici 2

	select company_id,company_name, amount 
	from company inner join transaction 
	on company.id=transaction.company_id
	and amount =(select max(amount) from transaction) 



------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

	select avg (amount), country  
	from company inner join transaction 
	on company.id=transaction.company_id
	group by country
	having avg(amount) > (select avg(amount) from transaction)


-- Ejercici 2

select company_name, if (numTrans>4, "Más de 4" , "Menos") as Trans, numTrans from (
	select  company_name, count(t.id) as numTrans
	from company c inner join transaction t
	on c.id=company_id
	group by company_name
) as t1