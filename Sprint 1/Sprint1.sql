------------------------  
--     Nivel 1        --
------------------------
-- Ejercici 1 
 --No hay queries, se ejecutan las sql de los ficheros proporcionados --
 
-- Ejercici 2 
select company_name, email, country from company order by company_name

-- Ejercici 3
select distinct (country) from company c inner join transaction t
on c.id=t.company_id

-- Ejercici 4
select count(distinct (country)) as numPaisos from company c inner join transaction t
on c.id=t.company_id


-- Ejercici 5
select company_name,country from company
where id='b-2354'

-- Ejercici 6
select  company_name ,avg (amount) from company c inner join transaction t
on c.id=t.company_id
group by company_name
limit 1


------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 
select  id, count(id) from company 
group by id
having count(id) >1

-- Ejercici 2
select date(timestamp) as fecha, sum(amount)as ventas from transaction 
group by fecha
order by ventas desc
limit 5

-- Ejercici 3
select date(timestamp) as fecha, sum(amount)as ventas from transaction 
group by fecha
order by ventas 
limit 5

-- Ejercici 4
select country, avg(amount)as ventas 
from company c inner join transaction t
on c.id=t.company_id
group by country
order by ventas desc

------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

select company_name, phone, country, sum(amount)as vendes 
from company c inner join transaction t
on c.id=t.company_id
group by company_name, phone, country
having sum(amount) between 100 and 200
order by vendes desc


-- Ejercici 2
select company_name, date(timestamp) as fecha
from company c inner join transaction t
on c.id=t.company_id
having fecha in ('2022-03-16','2022-02-18','2022-02-13')