# Write your MySQL query statement below

WITH first_positive AS
(
    SELECT
        patient_id,
        MIN(test_date) AS firstPositive
    FROM covid_tests
    WHERE result = 'Positive'
    GROUP BY patient_id
),

first_negative AS
(
    SELECT
        c.patient_id,
        MIN(c.test_date) AS firstNegative
    FROM covid_tests AS c
    JOIN first_positive AS fp
        ON c.patient_id = fp.patient_id
    WHERE c.result = 'Negative' AND c.test_date > fp.firstPositive
    GROUP BY c.patient_id
)

SELECT
    p.patient_id,
    p.patient_name,
    p.age,
    DATEDIFF(fn.firstNegative, fp.firstPositive) AS recovery_time
FROM patients AS p
JOIN first_positive AS fp
    ON p.patient_id = fp.patient_id
JOIN first_negative AS fn
    ON p.patient_id = fn.patient_id
ORDER BY recovery_time, patient_name

