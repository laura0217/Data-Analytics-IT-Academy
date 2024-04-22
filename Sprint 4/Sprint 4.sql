
-- *********************
--      SPRINT 4 
-- *********************

------------------------  
--     Nivel 1        --
------------------------

------ Creació base de dades ------

CREATE database new_transactions;

USE new_transactions;

CREATE TABLE companies (
   id VARCHAR(15) NOT NULL,
   company_name VARCHAR(255) DEFAULT NULL,
   phone VARCHAR(15) DEFAULT NULL,
   email VARCHAR(100) DEFAULT NULL,
   country VARCHAR(100) DEFAULT NULL,
   website VARCHAR(100) DEFAULT NULL,
   PRIMARY KEY (id)
 );

  
  CREATE TABLE credit_cards (
  id VARCHAR(15) NOT NULL,
  user_id INT NOT NULL,
  iban VARCHAR(50) DEFAULT NULL,
  pan VARCHAR(20) DEFAULT NULL,
  pin VARCHAR(4) DEFAULT NULL,
  cvv INT DEFAULT NULL,
  track1 VARCHAR(50) DEFAULT NULL,
  track2 VARCHAR(50) DEFAULT NULL,
  expiring_date VARCHAR(10) DEFAULT NULL,
  PRIMARY KEY (id)
) 

 CREATE TABLE products (
   id INT NOT NULL,
   product_name VARCHAR(100) DEFAULT NULL,
  `price` VARCHAR(20) DEFAULT NULL,
  `colour` VARCHAR(7) DEFAULT NULL,
  `weight` FLOAT DEFAULT NULL,
  `warehouse_id` VARCHAR(10) DEFAULT NULL,
   PRIMARY KEY (id)
 );
 
CREATE TABLE users (
  id INT NOT NULL,
  name VARCHAR(100) DEFAULT NULL,
  surname VARCHAR(100) DEFAULT NULL,
  phone VARCHAR(150) DEFAULT NULL,
  email VARCHAR(150) DEFAULT NULL,
  birth_date VARCHAR(100) DEFAULT NULL,
  country VARCHAR(150) DEFAULT NULL,
  city VARCHAR(150) DEFAULT NULL,
  postal_code VARCHAR(100) DEFAULT NULL,
  address VARCHAR(255) DEFAULT NULL,
  PRIMARY KEY (id)
) 

 CREATE TABLE transactions (
  id VARCHAR(255) NOT NULL,
  card_id VARCHAR(15) DEFAULT NULL,
  company_id VARCHAR(15) DEFAULT NULL,
  timestamp TIMESTAMP NULL DEFAULT NULL,
  amount DECIMAL(10,2) DEFAULT NULL,
  declined TINYINT DEFAULT NULL,
  product_ids VARCHAR(100) DEFAULT NULL,
  user_id INT DEFAULT NULL,
  lat FLOAT DEFAULT NULL,
  longitude FLOAT DEFAULT NULL,
  PRIMARY KEY (id),
  KEY idx_company_id (company_id),
  KEY idx_user_id (user_id),
  KEY idx_card_id (card_id),
  CONSTRAINT transaction_ibfk_1 FOREIGN KEY (company_id) REFERENCES companies (id),
  CONSTRAINT transaction_ibfk_2 FOREIGN KEY (card_id) REFERENCES credit_cards (id),
  CONSTRAINT transaction_ibfk_3 FOREIGN KEY (user_id) REFERENCES users (id)
) ;

 
 


------   Fi Creació   -------------

-- Pujar les dades ---

	SHOW VARIABLES LIKE "secure_file_priv";  -- path per deixar els fitxers
	SET GLOBAL LOCAL_INFILE = TRUE;  		-- Canvi seguretat
	 
	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/companies.csv"
	INTO TABLE companies
	FIELDS TERMINATED BY ',';
	IGNORE 1 LINES;
 
	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_cards.csv"
	INTO TABLE credit_cards
	FIELDS TERMINATED BY ','
	IGNORE 1 LINES;
 
	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/products.csv"
	INTO TABLE products
	FIELDS TERMINATED BY ','
	IGNORE 1 LINES;

	
	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_ca.csv"
	INTO TABLE users
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED by '"'
	ESCAPED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;

	
	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_usa.csv"
	INTO TABLE users
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED by '"'
	ESCAPED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;


	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users_uk.csv"
	INTO TABLE users
	FIELDS TERMINATED BY ','
	OPTIONALLY ENCLOSED by '"'
	ESCAPED BY '"'
	LINES TERMINATED BY '\r\n'
	IGNORE 1 LINES;


	LOAD DATA LOCAL INFILE "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/transactions.csv"
	INTO TABLE transactions
	FIELDS TERMINATED BY ';'
	ESCAPED BY '"'
	IGNORE 1 LINES;
 

-- Ejercici 1 
	SELECT id, name, surname, (
								SELECT COUNT(*) as trans 
								FROM transactions t2 
								WHERE user_id=u.id ) AS numTrans 
	FROM users u 
	HAVING numTrans >30

 
-- Ejercici 2 

	SELECT iban, AVG(amount) AS avgAmount, company_id 
	FROM transactions t 
	INNER JOIN credit_cards cc
	ON t.card_id=cc.id
	WHERE company_id=(SELECT id 
					  FROM companies 
					  WHERE company_name='Donec Ltd' )
	GROUP BY cc.iban, company_id




------------------------  
--     Nivel 2        --
------------------------

	-- Creació de la taula --

	CREATE TABLE `active_cards` (
	   `card_id` VARCHAR(15) NOT NULL,
	   `declined` TINYINT DEFAULT NULL, 
	   PRIMARY KEY (`card_id`),
	   CONSTRAINT `active_cards_ibfk_1` FOREIGN KEY (`card_id`) REFERENCES `credit_cards` (`id`)
	 ) ;


	-- Fi crear taula
	
	---- Function LastDeclined per calcular si les tres ultimes han estat declined
	DELIMITER //

	CREATE FUNCTION LastDeclined (idCard VARCHAR(15) ) 
	RETURNS INT
	READS SQL DATA

	BEGIN

	   DECLARE SumDeclined INT;
	   
		SELECT SUM(declined) INTO SumDeclined FROM (
			SELECT t.card_id,timestamp,declined from transactions  t
			WHERE t.card_id=idCard
			ORDER BY t.card_id,timestamp DESC  
			LIMIT 3) s;

	   RETURN SumDeclined;

	END; //

	DELIMITER ;

	 --- Final funcio --- 

	--- Insertar les dades en la nova taula ---
	INSERT INTO active_cards 
	(
		SELECT card_id, IF (lastDeclined(card_id)=3,0,1) AS declined
		FROM transactions 
	)
	---


-- Ejercici 1 
	SELECT count(card_id) numActive FROM active_cards 
	WHERE active=1

 


------------------------ 
--     Nivel 3        --
------------------------

	-- Creació de la taula --

	CREATE TABLE `product_transac` (
		`id` int NOT NULL AUTO_INCREMENT,
	   `product_id` int NOT NULL,
	   `transaction_id` VARCHAR(255) DEFAULT NULL, 
	   PRIMARY KEY (`id`),
	   CONSTRAINT `product_transac_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`id`),
	   CONSTRAINT `product_transac_ibfk_2` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`)
	 ) ;


	-- Fi crear taula
	
	
	-- PROCEDURE per insertar registres
	DELIMITER //
	CREATE PROCEDURE sp_Insert_In_Product_Trans()
	BEGIN
		DECLARE sId varchar(150);
		DECLARE sProduct_ids varchar(100);
		DECLARE inumComas INT;
		DECLARE i INT;
		DECLARE var_final INT DEFAULT 0;
		DECLARE cur1 CURSOR FOR SELECT id,product_ids, ((LENGTH(product_ids)) - LENGTH((REPLACE(product_ids,",",""))) ) AS numComas 
								FROM transactions 
								WHERE id NOT IN (SELECT transaction_id 
												 FROM product_transac);
		DECLARE CONTINUE HANDLER FOR NOT FOUND SET var_final = 1;
		
		OPEN cur1;
		read_loop: LOOP
		FETCH cur1 INTO sId, sProduct_ids,inumComas;
			IF var_final = 1 THEN
					LEAVE read_loop;
				END IF;
			SET i=0;
			getIdProd: LOOP
				INSERT INTO product_transac (transaction_id,product_id) VALUES (sId, SUBSTRING_INDEX(SUBSTRING_INDEX(sProduct_ids, ',', i+1), ',', -1) ) ;
				SET i = i +1;
				IF i > inumComas THEN
					LEAVE getIdProd;
				END IF;
			END LOOP getIdProd;

		END LOOP read_loop;
		CLOSE cur1;

	END //
		
	DELIMITER ;
		
		
	-- Fi PROCEDURE

-- Ejercici 1 

	SELECT product_name, COUNT(pt.id) AS sold_units 
	FROM product_transac pt 
	INNER JOIN products p ON pt.product_id = p.id
	GROUP BY product_name
	ORDER BY sold_units DESC


