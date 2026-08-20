# Write your MySQL query statement below

WITH daily_counts AS
(
    SELECT
        user_id,
        action_date,
        action,
        COUNT(*) OVER
        (
            PARTITION BY user_id, action_date
        ) AS cnt
    FROM activity
),

valid_days AS
(
    SELECT
        user_id,
        action_date,
        action
    FROM daily_counts
    WHERE cnt = 1
),

streaks AS
(
    SELECT
        user_id,
        action,
        action_date,

        DATE_SUB(
            action_date,
            INTERVAL ROW_NUMBER() OVER
            (
                PARTITION BY user_id, action
                ORDER BY action_date
            ) DAY
        ) AS grp

    FROM valid_days
),

streak_summary AS
(
    SELECT
        user_id,
        action,
        COUNT(*) AS streak_length,
        MIN(action_date) AS start_date,
        MAX(action_date) AS end_date
    FROM streaks
    GROUP BY
        user_id,
        action,
        grp
    HAVING COUNT(*) >= 5
),

ranked_streaks AS
(
    SELECT
        user_id,
        action,
        streak_length,
        start_date,
        end_date,

        ROW_NUMBER() OVER
        (
            PARTITION BY user_id
            ORDER BY streak_length DESC, start_date
        ) AS rn

    FROM streak_summary
)

SELECT
    user_id,
    action,
    streak_length,
    start_date,
    end_date
FROM ranked_streaks
WHERE rn = 1
ORDER BY
    streak_length DESC,
    user_id ASC;