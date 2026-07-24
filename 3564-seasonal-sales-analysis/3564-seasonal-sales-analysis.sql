# Write your MySQL query statement below

WITH seasonSales AS(
    SELECT (CASE
               WHEN MONTH(s.sale_date) IN (12,1,2) THEN 'Winter'
               WHEN MONTH(s.sale_date) IN (3,4,5) THEN 'Spring'
               WHEN MONTH(s.sale_date) IN (6,7,8) THEN 'Summer'
               ELSE 'Fall'
            END
           ) AS season,
           p.category AS category,
           SUM(s.quantity) AS total_quantity,
           SUM(s.quantity * s.price) AS total_revenue
    FROM sales AS s
    LEFT JOIN products AS p
    ON s.product_id = p.product_id
    GROUP BY season, p.category
),

categoryRank AS (
    SELECT *, 
           ROW_NUMBER() OVER(PARTITION BY season ORDER BY total_quantity DESC, total_revenue DESC, category ASC) AS catRank
    FROM seasonSales
)


SELECT season,
       category,
       total_quantity,
       total_revenue
FROM categoryRank
WHERE catRank = 1
ORDER BY season

