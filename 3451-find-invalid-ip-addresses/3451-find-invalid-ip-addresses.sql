# Write your MySQL query statement below


WITH octets AS (
    SELECT log_id,
           ip,
           LENGTH(ip) - LENGTH(REPLACE(ip, '.', '')) AS dot_count,
           SUBSTRING_INDEX(ip, '.', 1) AS octet1,
           SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 2), '.', -1) AS octet2,
           SUBSTRING_INDEX(SUBSTRING_INDEX(ip, '.', 3), '.', -1) AS octet3,
           SUBSTRING_INDEX(ip, '.', -1) AS octet4
    FROM logs
),

flagged AS (
    SELECT ip,
           CASE
               WHEN dot_count != 3 THEN 1

               WHEN CAST(octet1 AS UNSIGNED) > 255 OR CAST(octet2 AS UNSIGNED) > 255
                 OR CAST(octet3 AS UNSIGNED) > 255 OR CAST(octet4 AS UNSIGNED) > 255 THEN 1

               WHEN (LENGTH(octet1) > 1 AND LEFT(octet1, 1) = '0')
                 OR (LENGTH(octet2) > 1 AND LEFT(octet2, 1) = '0')
                 OR (LENGTH(octet3) > 1 AND LEFT(octet3, 1) = '0')
                 OR (LENGTH(octet4) > 1 AND LEFT(octet4, 1) = '0') THEN 1

               ELSE 0
           END AS is_invalid
    FROM octets
)

SELECT ip, COUNT(*) AS invalid_count
FROM flagged
WHERE is_invalid = 1
GROUP BY ip
ORDER BY invalid_count DESC, ip DESC;