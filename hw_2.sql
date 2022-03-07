/* 2) Создайте базу данных example, разместите в ней таблицу users,
состоящую из двух столбцов, числового id и строкового name. */
CREATE DATABASE IF NOT EXISTS example;
USE example;

DROP TABLE IF EXISTS users;
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) DEFAULT 'anonymous' COMMENT 'Имя пользователя'
);


/* 3) Создайте дамп базы данных example из предыдущего задания, 
разверните содержимое дампа в новую базу данных sample. */
CREATE DATABASE IF NOT EXISTS sample;
mysqldump example > example.sql
mysql sample < example.sql

/* 4) Создайте дамп единственной таблицы help_keyword базы данных mysql. 
Причем добейтесь того, чтобы дамп содержал только первые 100 строк таблицы. */

mysqldump mysql help_keyword --WHERE='TRUE LIMIT 100' > help_keyword_report.sql













