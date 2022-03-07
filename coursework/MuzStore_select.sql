USE muzstore;

/* 6)скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы) */

-- подсчитать общую сумму конкретного заказа
SELECT 
	op.order_id,
	SUM(p.price) AS final_price
FROM orders_products op 
JOIN products p ON op.product_id = p.id
WHERE op.order_id = 9
GROUP BY op.order_id;

-- все товары с ценой ниже среднего с catalog_id = 2
SELECT 
	id, name, price
FROM
	products p 
WHERE 
	catalog_id = 2 AND price < (SELECT AVG(price) FROM products);

-- вывести фамилии пользователей, их отзывы и названия товаров
SELECT 
	u.lastname,
	r.body AS `text`,
	p.name
FROM reviews r 
JOIN users u ON r.user_id = u.id 
JOIN products p ON r.product_id = p.id;

-- вывести товар с наибольшим кол-вом отзывов
SELECT 
	p.name,
	COUNT(r.user_id) as cnt
FROM reviews r 
JOIN products p ON p.id = r.product_id 
GROUP BY p.name
ORDER BY cnt DESC
LIMIT 1;


-- вывести количество товаров в каждом каталоге
SELECT 
	c.name,
	COUNT(*) AS cnt
FROM products p 
LEFT JOIN catalogs c ON p.catalog_id = c.id
GROUP BY c.name
ORDER BY cnt DESC;
	

/* 7)представления */

-- какое кол-во заказов каким способом было оплачено
CREATE OR REPLACE VIEW v_total_payment AS
SELECT 
	pt.name,
	COUNT(*) AS cnt
FROM payment_type pt
JOIN orders o ON o.payment_type_id = pt.id
GROUP BY pt.name;

SELECT * FROM v_total_payment;

-- общее кол-во товаров на каждом складе
CREATE OR REPLACE VIEW v_total_value AS
SELECT 
	s.name,
	SUM(sp.value)
FROM storehouses s 
JOIN storehouses_products sp ON s.id = sp.storehouse_id 
GROUP BY s.name;

SELECT * FROM v_total_value;

/* 8)хранимые процедуры/триггеры */

-- процедура транзакции по добавлению users и 100 бонусов для новых пользователей
DROP PROCEDURE IF EXISTS sp_user_add;
DELIMITER //
CREATE PROCEDURE sp_user_add (
	firstname VARCHAR(150),
	lastname VARCHAR(150),
	email VARCHAR(150),
	phone BIGINT,
	birthday_at DATE,
	hometown VARCHAR(150),
	total BIGINT,
	OUT tran_result VARCHAR(100)
)
BEGIN
	DECLARE `_rollback` BIT DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET `_rollback` = 1;
		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		SET tran_result = CONCAT('Ошибка: ', code, error_string);
	END;
	
	START TRANSACTION;
	INSERT INTO users (firstname, lastname, email, phone, birthday_at, hometown) VALUES
	(firstname, lastname, email, phone, birthday_at, hometown);

	INSERT INTO bonuses (user_id, total) VALUES 
	(last_insert_id(), total);

	if `_rollback` THEN
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;
END//
DELIMITER ;

CALL sp_user_add('NEW', 'User', 'new@mail.ru', 898171742313, '2000-05-11', 'Moscow', 100, @tran_result);

SELECT @tran_result;

SELECT * FROM users u
LEFT JOIN bonuses b ON u.id = b.user_id
ORDER BY u.id DESC;


-- процедура транзакции по добавлению в products товарной позиции и места на складе
DROP PROCEDURE IF EXISTS sp_product_add;
DELIMITER //
CREATE PROCEDURE sp_product_add (
	name VARCHAR(150),
	description TEXT,
	price DECIMAL(11,2),
	catalog_id BIGINT,
	storehouse_id BIGINT,
    value INT,
	OUT tran_result VARCHAR(100)
)
BEGIN
	DECLARE `_rollback` BIT DEFAULT 0;
	DECLARE code VARCHAR(100);
	DECLARE error_string VARCHAR(100);
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		SET `_rollback` = 1;
		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
		SET tran_result = CONCAT('Ошибка: ', code, error_string);
	END;
	
	START TRANSACTION;
	INSERT INTO products (name, description, price, catalog_id) VALUES
	(name, description, price, catalog_id);
	
	INSERT INTO storehouses_products (storehouse_id, product_id, value) VALUES
	(storehouse_id, last_insert_id(), value);

	if `_rollback` THEN
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;
END//
DELIMITER ;

CALL sp_product_add('BEHRINGER C-8', 'Микрофон', 8000, 4, 1, 100, @tran_result);

SELECT @tran_result;

SELECT * FROM products p 
LEFT JOIN storehouses_products sp ON p.id = sp.product_id 
ORDER BY p.id DESC;

-- триггер проверяющий валидность даты рождения
DROP TRIGGER IF EXISTS check_user_birthday;
DELIMITER //
CREATE TRIGGER check_user_birthday
BEFORE INSERT ON users
FOR EACH ROW 
BEGIN 
	IF NEW.birthday_at > CURRENT_DATE() THEN 
		SET NEW.birthday_at = CURRENT_DATE();
	END IF;
END//
DELIMITER ;

INSERT INTO users(firstname, lastname, email, phone, birthday_at) VALUES
('Новый', 'Пользователь', 'new@mail.com', 891824915, '2202-01-01');

SELECT * FROM users u
ORDER BY u.id DESC 
LIMIT 1;

-- триггер, который при вставке товара в products будет следить за catalog_id, если он не заполнен внесет наименьший
DROP TRIGGER IF EXISTS check_catalog_id;
DELIMITER //
CREATE TRIGGER check_catalog_id
BEFORE INSERT ON products
FOR EACH ROW 
BEGIN 
	DECLARE catalog_id INT;
	SELECT id INTO catalog_id FROM catalogs 
	ORDER BY id
	LIMIT 1;
	SET NEW.catalog_id = COALESCE(NEW.catalog_id, catalog_id);
END //
DELIMITER ;

INSERT INTO products (name, description, price) VALUES
('Новый', 'Товар', 16000);

SELECT * FROM products p 
JOIN catalogs c ON c.id = p.catalog_id
ORDER BY p.name DESC
LIMIT 1;








