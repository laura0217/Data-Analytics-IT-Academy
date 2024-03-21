
-- *********************
--      SPRINT 4 
-- *********************

------------------------  
--     Nivel 1        --
------------------------

-- Ejercici 1 
	SELECT id, name, surname, (SELECT COUNT(*) as trans FROM transactions t2 WHERE user_id=u.id ) numTrans 
	FROM users u 
	HAVING numTrans >30

 
-- Ejercici 2 

	SELECT iban,AVG(amount) as avgAmount,company_id FROM transactions t INNER JOIN credit_cards cc
	ON t.card_id=cc.id
	WHERE company_id=(SELECT id FROM companies WHERE company_name='Donec Ltd' )
	GROUP BY cc.iban,company_id




------------------------  
--     Nivel 2        --
------------------------

	-- Creació de la taula --

	CREATE TABLE `active_cards` (
	   `card_id` varchar(15) NOT NULL,
	   `declined` tinyint DEFAULT NULL, 
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
	   
		SELECT sum(declined) INTO SumDeclined FROM  (
			select t.card_id,timestamp,declined from transactions  t
			where t.card_id=idCard
			order by t.card_id,timestamp desc  
			limit 3) s;

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
		DECLARE cur1 CURSOR FOR SELECT id,product_ids, ((LENGTH(product_ids)) - length((REPLACE(product_ids,",",""))) ) as numComas 
								FROM transactions WHERE id not in (select transaction_id from product_transac);
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

	SELECT product_name, count(pt.id) as sold_units FROM product_transac pt 
	INNER JOIN products p ON pt.product_id=p.id
	GROUP BY product_name
	ORDER BY sold_units desc


