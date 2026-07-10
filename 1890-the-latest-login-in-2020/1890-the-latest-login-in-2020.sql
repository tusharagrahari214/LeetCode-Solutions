# Write your MySQL query statement below

WITH latest_login AS (
SELECT user_id,
       time_stamp,
       DENSE_RANK() OVER(PARTITION BY user_id ORDER BY time_stamp DESC) AS login_rank
FROM Logins
WHERE YEAR(time_stamp) = '2020'
)

SELECT user_id,
       time_stamp AS last_stamp
FROM latest_login
WHERE login_rank = 1
