# Write your MySQL query statement below

SELECT e.employee_id,
       e.name,
       COUNT(e.employee_id) reports_count,
       ROUND(AVG(m.age), 0) AS average_age
FROM Employees AS e
LEFT JOIN Employees AS m
ON e.employee_id = m.reports_to
WHERE e.employee_id = m.reports_to
GROUP BY e.employee_id
ORDER BY e.employee_id