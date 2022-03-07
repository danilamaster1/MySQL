USE vk;

/* 1.Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с выбранным пользователем */

SELECT 
	m.from_user_id,
	COUNT(*) AS cnt
FROM messages m
JOIN friend_requests fr ON (m.from_user_id = fr.target_user_id AND fr.initiator_user_id = 1) OR (m.from_user_id = fr.initiator_user_id AND fr.target_user_id = 1)
WHERE `status` = 'approved'
GROUP BY m.from_user_id
ORDER BY cnt DESC
LIMIT 1;

/* 2.Подсчитать общее количество лайков, которые получили пользователи младше 11 лет. */

SELECT 
	COUNT(*)
FROM likes l
JOIN media m ON m.id = l.media_id 
JOIN profiles p ON p.user_id = m.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, NOW()) <= 11;

/* 3.Определить кто больше поставил лайков (всего): мужчины или женщины. */

SELECT
	p.gender,
	COUNT(*) AS cnt
FROM likes l 
JOIN profiles p ON l.user_id = p.user_id 
GROUP BY p.gender
ORDER BY cnt DESC
LIMIT 1;
