# Write your MySQL query statement below
SELECT person_name
FROM(
SELECT turn, 
       person_name, 
       SUM(weight) OVER(ORDER BY turn) AS cumulative_weight  
FROM Queue
) AS t
WHERE cumulative_weight <= 1000
ORDER BY turn DESC
LIMIT 1
 