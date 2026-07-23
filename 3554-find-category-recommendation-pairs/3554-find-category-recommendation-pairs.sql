# Write your MySQL query statement below

WITH user_categorization AS (
    SELECT DISTINCT
           pp.user_id AS user_id,
           pi.category AS category
    FROM ProductPurchases AS pp
    JOIN ProductInfo AS pi
    ON pp.product_id = pi.product_id
), 

pairing_per_user AS(
    SELECT 
           p1.user_id AS user_id,
           p1.category AS category1,
           p2.category AS category2
    FROM user_categorization AS p1
    JOIN user_categorization AS p2
    ON p1.user_id = p2.user_id AND p1.category < p2.category
)

SELECT category1, 
       category2,
       COUNT(DISTINCT user_id) AS customer_count
FROM pairing_per_user
GROUP BY category1, category2
HAVING COUNT(DISTINCT user_id) >= 3
ORDER BY customer_count DESC, category1, category2