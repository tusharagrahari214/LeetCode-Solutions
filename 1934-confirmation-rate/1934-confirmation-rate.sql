# Write your MySQL query statement below


SELECT s.user_id,
       ROUND(
            IFNULL(
                    AVG(
                        CASE 
                            WHEN c.action = 'timeout' THEN 0 
                            WHEN c.action IS NULL THEN 0
                            ELSE 1 
                        END
                    ),
                    0
                ),
                2) AS confirmation_rate
       
FROM Signups AS s
LEFT JOIN Confirmations AS c
ON s.user_id = c.user_id
GROUP BY s.user_id

