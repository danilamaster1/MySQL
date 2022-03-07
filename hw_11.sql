USE shop;

/* 1)Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
   catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы,
   идентификатор первичного ключа и содержимое поля name. */

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP(),
	table_name VARCHAR(100),
	str_id BIGINT(100),
	name_val VARCHAR(100)
) ENGINE = ARCHIVE;

-- TRIGGER ON USERS
DROP TRIGGER IF EXISTS watchlog_users;
DELIMITER //
CREATE TRIGGER watchlog_users AFTER INSERT ON users
FOR EACH ROW
BEGIN 
	INSERT INTO logs(created_at, table_name, str_id, name_val) VALUES
	(DEFAULT, 'users', NEW.id, NEW.name);
END //
DELIMITER ;

-- TRIGGER ON CATALOGS
DROP TRIGGER IF EXISTS watchlog_catalogs;
DELIMITER //
CREATE TRIGGER watchlog_catalogs AFTER INSERT ON catalogs
FOR EACH ROW 
BEGIN
	INSERT INTO logs(created_at, table_name, str_id, name_val) VALUES
	(DEFAULT, 'catalogs', NEW.id, NEW.name);	
END//
DELIMITER ;

-- TRIGGER ON PRODUCTS
DROP TRIGGER IF EXISTS watchlog_products;
DELIMITER //
CREATE TRIGGER watchlog_products AFTER INSERT ON products
FOR EACH ROW
BEGIN
	INSERT INTO logs(created_at, table_name, str_id, name_val) VALUES
	(DEFAULT, 'products', NEW.id, NEW.name);
END//
DELIMITER ;

-- ---------------------------------------------------------------------------

-- test for users
SELECT * FROM users;
SELECT * FROM logs;

INSERT INTO users (name, birthday_at) VALUES
('User_1', '2000-01-11'),
('User_2', '1980-12-05');

SELECT * FROM users;
SELECT * FROM logs;

-- test for catalogs
SELECT * FROM catalogs;
SELECT * FROM logs;

INSERT INTO catalogs (name) VALUES 
('Оперативная память'),
('Куллера'),
('Аксессуары');

SELECT * FROM catalogs;
SELECT * FROM logs;
	
-- test for products
SELECT * FROM products;
SELECT * FROM logs;

INSERT INTO products (name, description, price, catalog_id) VALUES 
('PATRIOT PSD34G13332', 'Оперативная память', 3000.00, 1),
('DARK ROCK PRO 4 (BK022)', 'Куллера', 500.00, 2),
('Коврик', 'Коврик для мыши', 150.00, 3);

SELECT * FROM products;
SELECT * FROM logs;

/* 2)Создайте SQL-запрос, который помещает в таблицу users миллион записей */

-- тестовая таблица
DROP TABLE IF EXISTS test_users; 
CREATE TABLE test_users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255),
	birthday_at DATE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP PROCEDURE IF EXISTS insert_into_users;
DELIMITER //
CREATE PROCEDURE insert_into_users ()
BEGIN
	DECLARE i INT DEFAULT 1000000;
	DECLARE j INT DEFAULT 1;
	WHILE i > 0 DO
		INSERT INTO test_users (name, birthday_at) VALUES (CONCAT('user_', j), NOW());
		SET j = j + 1;
		SET i = i - 1;
	END WHILE;	
END //
DELIMITER ;

-- тест
SELECT * FROM test_users;

CALL insert_into_users();

SELECT * FROM test_users;




