USE shop;

/* 1.Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине */

SELECT DISTINCT
	o.user_id,
	u.name
FROM users AS u
JOIN orders AS o
WHERE u.id = o.user_id;

/* 2.Выведите список товаров products и разделов catalogs, который соответствует товару. */

SELECT 
	p.name,
	p.price,
	c.name
FROM products AS p
LEFT JOIN catalogs AS c
WHERE c.id = p.catalog_id;

/* 3.Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
Поля from, to и label содержат английские названия городов, поле name — русское. 
Выведите список рейсов flights с русскими названиями городов. */

SELECT c.name, c1.name
FROM flights f 
JOIN cities c ON c.label = f.`from` 
JOIN cities c1 ON c1.label = f.`to` 
ORDER BY f.id;
	