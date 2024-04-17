
-- *********************
--      SPRINT 3 
-- *********************

------------------------  
--     Nivel 1        --
------------------------

-- Ejercici 1 

	USE transactions;
	CREATE TABLE IF NOT EXISTS credit_card(
	id VARCHAR(15) NOT NULL PRIMARY KEY,
	iban VARCHAR (35),
	pan VARCHAR (25),
	pin VARCHAR(5) ,
	cvv VARCHAR (5),
	expiring_date VARCHAR(8)
	);

	ALTER TABLE transaction
	ADD FOREIGN KEY (credit_card_id)
	REFERENCES credit_card(id);


 
-- Ejercici 2 

	SELECT id,IBAN 
	FROM credit_card 
	WHERE id='CcU-2938';  -- Comprovar el valor del camp IBAN

	UPDATE credit_card 
	SET IBAN='R323456312213576817699999' 
	WHERE id='CcU-2938';  -- Modificar el valor del camp IBAN


-- Ejercici 3

	INSERT INTO transaction (id,credit_card_id,company_id,user_id,lat,longitude,amount,declined) 
	VALUES ('108B1D1D-5B23-A76C-55EF-C568E49A99DD','CcU-9999','b-9999','9999','829.999','-117.999','111.11','0');
	
	INSERT INTO credit_card (id) VALUES ('CcU-9999');
	INSERT INTO company (id) VALUES ('b-9999');
	INSERT INTO user (id) VALUES ('9999');


-- Ejercici 4
	
	SHOW columns FROM credit_card;         -- Comprovar si existeix la columna
	ALTER TABLE credit_card DROP column pan;     -- Eliminar la columna




------------------------  
--     Nivel 2        --
------------------------

-- Ejercici 1 

	SELECT * 
	FROM transaction 
	WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02' 	-- Comprovar si existeix el registre
	
	DELETE FROM transaction WHERE id='02C6201E-D90A-1859-B4EE-88D2986D3B02'	-- Eliminar el registre
	
	ALTER TABLE user DROP FOREIGN KEY user_ibfk_1;								-- Eliminar FOREIGN KEY
	
	ALTER TABLE transaction 													-- Añadir FOREIGN KEY
	ADD FOREIGN KEY (user_id)
	REFERENCES user(id);
	

-- Ejercici 2

	CREATE VIEW VistaMarketing AS														-- Creació de la vista
		SELECT company_name,phone,country,avgVen FROM company c,
		(SELECT company_id,AVG(amount) as avgVen FROM transaction t GROUP BY company_id) b 
		WHERE b.company_id=c.id
		
		
	SELECT * from VistaMarketing														-- Presentació de les dades
	ORDER BY avgVen DESC


-- Ejercici 3
	SELECT * from VistaMarketing														-- Mostrar dades vista
	WHERE country='Germany'



------------------------ 
--     Nivel 3        --
------------------------

-- Ejercici 1 

	ALTER TABLE company DROP column website;	-- Eliminar camp website de la taula company
	
	ALTER TABLE credit_card MODIFY COLUMN ID VARCHAR(20);     			-- modificar tipus id de varchar(15) a varchar(20) en la taula credit_card
	ALTER TABLE credit_card MODIFY COLUMN IBAN VARCHAR(50);     		-- modificar tipus iban de varchar(35) a varchar(50) en la taula credit_card
	ALTER TABLE credit_card MODIFY COLUMN pin VARCHAR(4);  				-- modificar tipus pin de varchar(5) a varchar(4) en la taula credit_card
	ALTER TABLE credit_card MODIFY COLUMN cvv INTEGER; 					-- modificar tipus cvv de varchar(5) a int en la taula credit_card
	ALTER TABLE credit_card MODIFY COLUMN expiring_date VARCHAR(10); 	-- modificar tipus expiring_date de varchar(5) a varchar(10) en la taula credit_card
	ALTER TABLE credit_card ADD COLUMN fecha_actual DATE;  				-- afegir camp fecha_actual de tipus date en la taula credit_card
	
	ALTER TABLE user RENAME COLUMN email TO personal_email				-- Renombrar el camp ‘email’  a ‘personal email’ de la taula user
																		




-- Ejercici 2
																			-- Crear vista
	CREATE VIEW InformeTecnico AS																			
		SELECT t.id as idTransac, name as user_name, surname as user_surname, IBAN, co.company_name as company, timestamp as date, amount  
		FROM transaction t 
		INNER JOIN user u ON user_id= u.id
		INNER JOIN credit_card c ON t.credit_card_id = c.id
		INNER JOIN company co ON t.company_id = co.id
		
		
	SELECT * 
	FROM InformeTecnico 
	ORDER BY idTransac DESC					-- Mostrar dades vista	
	