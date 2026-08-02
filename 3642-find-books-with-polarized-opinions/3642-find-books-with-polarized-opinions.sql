# Write your MySQL query statement below

WITH polarization AS(
    SELECT book_id,
           session_rating,
           ROW_NUMBER() OVER(PARTITION BY book_id ORDER BY session_rating DESC) max_rnk,
           ROW_NUMBER() OVER(PARTITION BY book_id ORDER BY session_rating ASC) min_rnk,
           COUNT(*) OVER(PARTITION BY book_id) AS total_session
    FROM reading_sessions
),

max_rate AS (
    SELECT book_id,
           session_rating AS max_rating,
           total_session
    FROM polarization
    WHERE max_rnk = 1 AND total_session >= 5
),

min_rate AS (
    SELECT book_id,
           session_rating AS min_rating
    FROM polarization
    WHERE min_rnk = 1
),

extreme_rating AS (
    SELECT book_id,
           COUNT(*) AS total_extreme
    FROM polarization
    WHERE session_rating <= 2 OR session_rating >= 4
    GROUP BY book_id
),

combo AS(
    SELECT mx.book_id,
           mx.max_rating,
           mn.min_rating,
           mx.total_session,
           ex.total_extreme
    FROM max_rate mx
    JOIN min_rate mn
    ON mx.book_id = mn.book_id
    JOIN extreme_rating ex
    ON mx.book_id = ex.book_id
)

SELECT b.book_id,
       b.title,
       b.author,
       b.genre,
       b.pages,
       (c.max_rating - c.min_rating) AS rating_spread,
       ROUND(c.total_extreme / c.total_session,2) AS polarization_score
FROM combo c
JOIN books AS b
ON c.book_id = b.book_id
WHERE c.max_rating >= 4 AND c.min_rating <= 2 AND ROUND(c.total_extreme / c.total_session,2) >= 0.60
ORDER BY
    polarization_score DESC,
    b.title DESC;




-- SELECT
--     b.book_id,
--     b.title,
--     b.author,
--     b.genre,
--     b.pages,
--     MAX(r.session_rating)-MIN(r.session_rating) AS rating_spread,
--     ROUND(
--         SUM(
--             CASE
--                 WHEN r.session_rating<=2
--                   OR r.session_rating>=4
--                 THEN 1
--                 ELSE 0
--             END
--         )/COUNT(*),
--         2
--     ) AS polarization_score
-- FROM books b
-- JOIN reading_sessions r
-- ON b.book_id=r.book_id
-- GROUP BY
--     b.book_id,
--     b.title,
--     b.author,
--     b.genre,
--     b.pages
-- HAVING
--     COUNT(*)>=5
--     AND MAX(r.session_rating)>=4
--     AND MIN(r.session_rating)<=2
--     AND
--     SUM(
--         CASE
--             WHEN r.session_rating<=2
--               OR r.session_rating>=4
--             THEN 1
--             ELSE 0
--         END
--     )/COUNT(*)>=0.6
-- ORDER BY
--     polarization_score DESC,
--     b.title DESC;