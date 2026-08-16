# Write your MySQL query statement below

WITH reactions_count AS (
    SELECT user_id,
           reaction,
           COUNT(reaction) AS reaction_count
    FROM reactions
    GROUP BY user_id, reaction
),

ratio AS (
    SELECT user_id,
           MAX(reaction_count) AS max_count,
           SUM(reaction_count) AS total_count,
           ROUND(MAX(reaction_count) / SUM(reaction_count), 2) AS reaction_ratio
    FROM reactions_count
    GROUP BY user_id
    HAVING total_count >= 5 AND reaction_ratio >= 0.60
)

SELECT rc.user_id,
       rc.reaction AS dominant_reaction,
       r.reaction_ratio
FROM ratio AS r
JOIN reactions_count AS rc
ON r.user_id = rc.user_id AND r.max_count = rc.reaction_count
ORDER BY reaction_ratio DESC, user_id ASC