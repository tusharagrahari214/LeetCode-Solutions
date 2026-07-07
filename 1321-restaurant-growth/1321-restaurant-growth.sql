# Write your MySQL query statement below

WITH sales_by_visited_on AS (
    SELECT visited_on,
           SUM(amount) AS daily_total_amount
    FROM Customer
    GROUP BY visited_on
),

moving_window AS(
    SELECT visited_on,
           SUM(daily_total_amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
           ROUND(AVG(daily_total_amount) OVER(ORDER BY visited_on ROWS BETWEEN 6 PRECEDING AND CURRENT ROW), 2) AS average_amount,
           ROW_NUMBER() OVER(ORDER BY visited_on) AS visit_rank
    FROM sales_by_visited_on
)

SELECT visited_on,
       amount,
       average_amount
FROM moving_window
WHERE visit_rank >= 7
ORDER BY visited_on

