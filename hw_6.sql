USE vk;

/* 1.Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем. */

SELECT
	from_user_id, 
	COUNT(*) AS cnt 
FROM messages 
GROUP BY from_user_id 
HAVING from_user_id IN (SELECT target_user_id FROM friend_requests WHERE initiator_user_id = 1 AND `status` = 'approved' 
UNION 
SELECT initiator_user_id FROM friend_requests WHERE target_user_id = 1 AND `status` = 'approved')
ORDER BY cnt DESC 
LIMIT 1;

/* 2.Подсчитать общее количество лайков, которые получили пользователи младше 11 лет. */

SELECT 
	COUNT(*)
FROM likes
WHERE media_id IN 
(SELECT id FROM media WHERE user_id IN 
(SELECT user_id FROM profiles WHERE TIMESTAMPDIFF(YEAR, birthday, NOW()) <= 11));

/* 3.Определить кто больше поставил лайков (всего): мужчины или женщины. */

SELECT
    COUNT(profiles.gender) AS cnt,
    profiles.gender
FROM profiles,
    likes
    WHERE likes.user_id = profiles.user_id
GROUP BY profiles.gender
ORDER BY cnt DESC
LIMIT 1;









