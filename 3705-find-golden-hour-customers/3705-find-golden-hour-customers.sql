# Write your MySQL query statement below

SELECT
    customer_id,
    COUNT(*) AS total_orders,

    ROUND(
        SUM(
            TIME(order_timestamp) BETWEEN '11:00:00' AND '14:00:00'
            OR
            TIME(order_timestamp) BETWEEN '18:00:00' AND '21:00:00'
        ) * 100 / COUNT(*)
    ) AS peak_hour_percentage,

    ROUND(AVG(order_rating),2) AS average_rating

FROM restaurant_orders

GROUP BY customer_id

HAVING
    COUNT(*) >= 3

    AND

    ROUND(
        SUM(
            TIME(order_timestamp) BETWEEN '11:00:00' AND '14:00:00'
            OR
            TIME(order_timestamp) BETWEEN '18:00:00' AND '21:00:00'
        ) * 100 / COUNT(*)
    ) >= 60

    AND

    ROUND(AVG(order_rating),2) >= 4.00

    AND

    SUM(order_rating IS NOT NULL) / COUNT(*) >= 0.5

ORDER BY
    average_rating DESC,
    customer_id DESC;