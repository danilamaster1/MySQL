USE shop;

-- Транзакции, переменные, представления

/* 1.В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
 * Скопируйте запись id = 1 из таблицы shop.users в таблицу sample.users.
 * Используйте транзакции. */

START TRANSACTION;
SELECT id, name, birthday_at FROM shop.users WHERE id = 1;
INSERT INTO sample.users (id, name) SELECT id, name FROM shop.users WHERE id = 1;
COMMIT;


/* 2.Создайте представление, которое выводит название name товарной позиции из таблицы products
 * и соответствующее название каталога name из таблицы catalogs. */

CREATE VIEW test3 AS 
SELECT p.name, c.name AS `catalog` FROM products p
LEFT JOIN catalogs c ON p.catalog_id = c.id;

SELECT * FROM test3;

-- Хранимые процедуры и функции, триггеры

/* 1.Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 * С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
 * с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи". */

DELIMITER //
DROP FUNCTION IF EXISTS hello//
CREATE FUNCTION hello ()
RETURNS TINYTEXT DETERMINISTIC
BEGIN
	DECLARE time_now INT;
	SET time_now = HOUR(NOW());
	CASE 
		WHEN time_now BETWEEN 6 AND 11 THEN 
			RETURN 'Доброе утро';
		WHEN time_now BETWEEN 12 AND 17 THEN 
			RETURN 'Добрый день';
		WHEN time_now BETWEEN 18 AND 23 THEN 
			RETURN 'Добрый вечер';
		ELSE 
			RETURN 'Доброй ночи';
	END CASE;
END//

SELECT hello();







