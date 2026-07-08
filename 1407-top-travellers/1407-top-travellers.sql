# Write your MySQL query statement below
WITH total_dist AS (
SELECT id,
       user_id,
       SUM(`distance`) AS dist
FROM Rides
GROUP BY user_id
)

SELECT u.name AS name,
       COALESCE(t.dist, 0) AS travelled_distance
FROM Users AS u
LEFT JOIN total_dist AS t
ON u.id = t.user_id
GROUP BY u.id
ORDER BY t.dist DESC, u.name ASC


