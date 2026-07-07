# Write your MySQL query statement below

WITH rating_count AS (
        SELECT u.name AS name,
        COUNT(*) AS r_count
        FROM Users AS u
        LEFT JOIN MovieRating AS mr
        ON u.user_id = mr.user_id
        GROUP BY mr.user_id

),

highest_avg_rate AS(
        SELECT m.title AS movie_name,
               AVG(mr.rating) AS avg_rating
        FROM Movies AS m
        LEFT JOIN MovieRating AS mr
        ON m.movie_id = mr.movie_id
        WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
        GROUP BY mr.movie_id


)

(SELECT name AS results
FROM rating_count
ORDER BY r_count DESC, name ASC
LIMIT 1)

UNION ALL

(SELECT movie_name AS results
FROM highest_avg_rate
ORDER BY avg_rating DESC, movie_name ASC 
LIMIT 1)



