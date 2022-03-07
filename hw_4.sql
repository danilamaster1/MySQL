USE vk;

/* 1.Заполнить все таблицы БД vk данными. */

INSERT INTO users (firstname, lastname, email, phone)
VALUES
('Dan', 'Howard', 'howard@mail.com', '9421233445'),
('Elizabeth', 'Howard', 'howard_l@mail.com', '9421238954'),
('Vitaliy', 'Petrov', 'petya@mail.com', '9115993354'),
('Evgeniy', 'Andreev', 'andr@mail.com', '9811778485'),
('Olga', 'Sergeeva', 'serega@mail.com', '9428764321'),
('Albert', 'Vasiliev', 'vsya@mail.ru', '9876543211'),
('Zigmynd', 'Freid', 'teoriya@mail.com', '1234568744');

INSERT INTO `profiles` (gender, birthday)
VALUES
('m', '2000-05-10'),
('f', '2002-01-21'),
('m', '1985-11-28'),
('m', '2010-03-11'),
('f', '1999-08-04'),
('m', '1977-06-02'),
('m', '1950-01-01');

INSERT INTO `status` (body)
VALUES
('всем привет!)'),
('в школе'),
('на работе'),
('йоу))'),
('устал('),
('привет)'),
('пишите сюда');

INSERT INTO messages (from_user_id, to_user_id, body)
VALUES
(1, 2, 'Привет, как дела?'),
(2, 1, 'Все хорошо) ты как?'),
(1, 5, 'посмотри мое новое видео!)'),
(5, 1, 'супер!!!'),
(3, 4, 'что сегодня делаешь?'),
(4, 3, 'ничего, прогуляемся?'),
(3, 4, 'давай)');

INSERT INTO friend_requests (initiator_user_id, target_user_id)
VALUES
(1, 2),
(1, 4),
(3, 5),
(1, 3);

INSERT INTO communities (name)
VALUES
('новости про игры'),
('новости спорта'),
('идеи подарков');

INSERT INTO users_communities (user_id, community_id)
VALUES
(1, 1),
(1, 3),
(5, 2),
(2, 3),
(5, 1);

INSERT INTO games (name, difficult)
VALUES
('DOTA 2', 3),
('CS GO', 1),
('Ралли', 1),
('Русская рыбалка', 2),
('Ферма', 1),
('Мой город', 1),
('Драки', 3);

INSERT INTO users_games (user_id, game_id)
VALUES
(1, 1),
(1, 4),
(2, 5),
(4, 3),
(5, 6),
(2, 3),
(3, 4);

INSERT INTO media_types (name)
VALUES
('Videos'),
('Pictures'),
('Music'),
('Text');

INSERT INTO media (user_id, body, filename, media_type_id)
VALUES
(1, 'стрим', 'видео со стрима 2021-12-19', 1),
(2, 'подарки', 'делаем подарки своими руками...', 4),
(4, 'я', 'мое новое фото)', 2),
(3, 'мой новый трек', 'MC - социалка', 3),
(1, 'как-то раз...', 'сочинение', 4),
(1, 'фотки', 'фото1', 2),
(2, 'погода', 'весна1', 2);

INSERT INTO likes (user_id, media_id)
VALUES
(1, 2),
(1, 3),
(2, 1),
(1, 4),
(5, 2),
(4, 1);

INSERT INTO comments (user_id, media_id, body)
VALUES
(1, 2, 'Круто, спасибо!!!'),
(1, 3, 'Красавчик)'),
(2, 1, 'весело было))'),
(1, 4, 'мощный трек!'),
(5, 2, 'полезная заметка!)'),
(4, 1, 'никогда так не ржал');

INSERT INTO photo_albums (name, user_id)
VALUES
('весна!', 2),
('достижения', 1),
('холода', 5),
('праздники', 3),
('веселье', 4);

INSERT INTO photos (album_id, media_id)
VALUES
(1, 7),
(5, 3),
(2, 6);

 

/* 2.Написать скрипт, возвращающий список имен (только firstname) пользователей без повторений в алфавитном порядке. */
SELECT DISTINCT firstname FROM users
ORDER BY firstname;


/* 3.Первые пять пользователей пометить как удаленные. */
UPDATE users 
SET
	is_deleted = 1
LIMIT 5;


/* 4.Написать скрипт, удаляющий сообщения «из будущего» (дата больше сегодняшней). */
UPDATE messages 
SET
	created_at = '2200-01-01'
WHERE from_user_id = 4 AND to_user_id = 3

DELETE FROM messages 
WHERE created_at > NOW(); 


/* 5.Написать название темы курсового проекта. 
 * Магазин музыкальных инструментов */





