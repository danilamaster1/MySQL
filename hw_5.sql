USE shop;
/* 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем. */

UPDATE users
SET 
	create_at = NOW(),
	update_at = NOW()
WHERE create_at IS NULL OR update_at IS NULL;

/* 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
 * и в них долгое время помещались значения в формате 20.10.2017 8:10. 
 * Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения. */

UPDATE users
	SET created_at = STR_TO_DATE(created_at, '%d.%m.%Y %k:%i'),
	updated_at = STR_TO_DATE(updated_at, '%d.%m.%Y %k:%i');

ALTER TABLE users
	MODIFY COLUMN created_at DATETIME,
	MODIFY COLUMN updated_at DATETIME;

/* 3.В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
 * 0, если товар закончился и выше нуля, если на складе имеются запасы. 
 * Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения значения value. 
 * Однако нулевые запасы должны выводиться в конце, после всех записей. */

SELECT id, product_id, value FROM storehouses_products 
ORDER BY 
	CASE 
		WHEN value = 0 THEN 9999999999999
		ELSE value 
END;

/* 4.Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. Месяцы заданы в виде списка английских названий (may, august) */

SELECT name, birthday_at FROM users WHERE MONTHNAME(birthday_at) IN ('may', 'august'); 

/* 5.Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); Отсортируйте записи в порядке, заданном в списке IN. */

SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(id, 5, 1, 2);

-- АГРЕГАЦИЯ ДАННЫХ
/* 1.Подсчитайте средний возраст пользователей в таблице users.*/

SELECT ROUND(AVG(TIMESTAMPDIFF(YEAR, birthday_at, NOW()))) AS age FROM users;

/* 2.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. */

SELECT
	DATE_FORMAT(DATE(CONCAT_WS('-', YEAR(NOW()), MONTH(birthday_at), DAY(birthday_at))), '%W') AS `day`,
	COUNT(*) AS total
FROM
	users
GROUP BY
	`day`
ORDER BY
	total DESC;

/* 3.Подсчитайте произведение чисел в столбце таблицы. */
SELECT round(exp(sum(log(id))), 10) from users;
