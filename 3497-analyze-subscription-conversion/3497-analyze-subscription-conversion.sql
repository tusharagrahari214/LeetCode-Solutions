# Write your MySQL query statement below
WITH T AS
(
    SELECT
        user_id,
        activity_type,
        ROUND(AVG(activity_duration), 2) AS duration
    FROM UserActivity
    WHERE activity_type != 'cancelled'
    GROUP BY
        user_id,
        activity_type
),

F AS
(
    SELECT
        user_id,
        duration AS trial_avg_duration
    FROM T
    WHERE activity_type='free_trial'
),

P AS
(
    SELECT
        user_id,
        duration AS paid_avg_duration
    FROM T
    WHERE activity_type='paid'
)

SELECT
    F.user_id,
    trial_avg_duration,
    paid_avg_duration
FROM F
JOIN P
ON F.user_id=P.user_id
ORDER BY user_id;