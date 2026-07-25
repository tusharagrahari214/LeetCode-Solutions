# Write your MySQL query statement below

WITH employee_rank AS (
SELECT e.employee_id,
       e.name,
       p.review_date,
       p.rating,
       ROW_NUMBER() OVER(PARTITION BY e.employee_id ORDER BY p.review_date DESC) AS rn
FROM employees AS e
LEFT JOIN performance_reviews AS p
ON e.employee_id = p.employee_id
),

top_three_review AS(
    SELECT employee_id,
           name,     
           MAX(CASE WHEN rn = 1 THEN rating END) AS latest_rating,
           MAX(CASE WHEN rn = 2 THEN rating END) AS second_latest_rating,
           MAX(CASE WHEN rn = 3 THEN rating END) AS third_latest_rating                 
    FROM employee_rank
    WHERE rn <= 3 
    GROUP BY employee_id, name
)

SELECT employee_id,
       name,
       (latest_rating - third_latest_rating) AS improvement_score
FROM top_three_review
WHERE latest_rating > second_latest_rating AND second_latest_rating > third_latest_rating
ORDER BY improvement_score DESC, name