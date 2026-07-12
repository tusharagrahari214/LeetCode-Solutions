# Write your MySQL query statement below

WITH ranked_scores AS (
    SELECT
        student_id,
        subject,
        score,

        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date
        ) AS first_rank,

        ROW_NUMBER() OVER (
            PARTITION BY student_id, subject
            ORDER BY exam_date DESC
        ) AS latest_rank

    FROM Scores
),

student_scores AS (
    SELECT
        student_id,
        subject,
        MAX(CASE
                WHEN first_rank = 1 THEN score
            END) AS first_score,

        MAX(CASE
                WHEN latest_rank = 1 THEN score
            END) AS latest_score

    FROM ranked_scores
    GROUP BY student_id, subject
)

SELECT
    student_id,
    subject,
    first_score,
    latest_score
FROM student_scores
WHERE latest_score > first_score
ORDER BY student_id, subject;