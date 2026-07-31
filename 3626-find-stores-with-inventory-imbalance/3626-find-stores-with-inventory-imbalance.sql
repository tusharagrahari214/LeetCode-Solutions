# Write your MySQL query statement below

WITH inventory_record AS (
    SELECT store_id,
           product_name,
           quantity,
           price,
           ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY price DESC) AS max_rnk,
           ROW_NUMBER() OVER(PARTITION BY store_id ORDER BY price ASC) AS min_rnk,
           COUNT(*) OVER(PARTITION BY store_id) AS product_count
    FROM inventory

),


max_price AS (
    SELECT store_id,
           product_name,
           quantity,
           price
    FROM inventory_record
    WHERE max_rnk = 1 AND product_count >= 3
),


min_price AS (
    SELECT store_id,
           product_name,
           quantity,
           price
    FROM inventory_record
    WHERE min_rnk = 1 AND product_count >= 3
)


SELECT s.store_id store_id,
        s.store_name,
        s.location,
        mx.product_name AS most_exp_product,
        mn.product_name AS cheapest_product,
        ROUND((mn.quantity / mx.quantity), 2) AS imbalance_ratio
FROM max_price AS mx
LEFT JOIN min_price AS mn
ON mx.store_id = mn.store_id
JOIN stores s
ON s.store_id = mx.store_id
WHERE mn.quantity > mx.quantity
ORDER BY
    imbalance_ratio DESC,
    store_name






-- SELECT
--     s.store_id,
--     s.store_name,
--     s.location,
--     e.product_name AS most_exp_product,
--     c.product_name AS cheapest_product,
--     ROUND(c.quantity / e.quantity,2) AS imbalance_ratio
-- FROM inventory_record e
-- JOIN inventory_record c
-- ON e.store_id=c.store_id
-- JOIN stores s
-- ON s.store_id=e.store_id
-- WHERE
--     e.max_rnk=1
-- AND c.min_rnk=1
-- AND e.quantity<c.quantity
-- AND e.product_count>=3
-- ORDER BY
--     imbalance_ratio DESC,
--     store_name
