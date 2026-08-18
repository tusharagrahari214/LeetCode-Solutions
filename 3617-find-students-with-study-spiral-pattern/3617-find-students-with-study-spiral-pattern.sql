# Write your MySQL query statement below

WITH ordered AS (
    SELECT
        student_id,
        subject,
        session_date,
        hours_studied,
        ROW_NUMBER() OVER (PARTITION BY student_id ORDER BY session_date) AS rn,
        DATEDIFF(
            session_date,
            LAG(session_date) OVER (PARTITION BY student_id ORDER BY session_date)
        ) AS gap_days
    FROM study_sessions
),

student_stats AS (
    SELECT
        student_id,
        COUNT(*) AS total_sessions,
        COUNT(DISTINCT subject) AS cycle_length,
        SUM(hours_studied) AS total_study_hours,
        MAX(gap_days) AS max_gap
    FROM ordered
    GROUP BY student_id
),

pattern_check AS (
    SELECT
        o.student_id,
        MIN(CASE WHEN o.subject = prev_cycle.subject THEN 1 ELSE 0 END) AS pattern_matches
    FROM ordered o
    JOIN student_stats s ON o.student_id = s.student_id
    JOIN ordered prev_cycle
        ON prev_cycle.student_id = o.student_id
       AND prev_cycle.rn = o.rn - s.cycle_length
    WHERE o.rn > s.cycle_length
    GROUP BY o.student_id
)

SELECT
    st.student_id,
    st.student_name,
    st.major,
    s.cycle_length,
    s.total_study_hours
FROM student_stats s
JOIN students st ON st.student_id = s.student_id
JOIN pattern_check pc ON pc.student_id = s.student_id
WHERE s.cycle_length >= 3
  AND s.total_sessions >= 6
  AND s.total_sessions >= 2 * s.cycle_length
  AND s.total_sessions % s.cycle_length = 0
  AND (s.max_gap IS NULL OR s.max_gap <= 2)
  AND pc.pattern_matches = 1
ORDER BY s.cycle_length DESC, s.total_study_hours DESC;