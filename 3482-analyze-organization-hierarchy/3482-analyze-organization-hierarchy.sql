# Write your MySQL query statement below

WITH RECURSIVE hierarchy AS (

    SELECT employee_id, employee_name, manager_id, salary, 1 AS level
    FROM Employees
    WHERE manager_id IS NULL

    UNION ALL

    SELECT e.employee_id, e.employee_name, e.manager_id, e.salary, h.level + 1
    FROM Employees e
    JOIN hierarchy h ON e.manager_id = h.employee_id
),

descendants AS (
    
    SELECT employee_id AS descendant_id, manager_id AS ancestor_id, salary
    FROM Employees
    WHERE manager_id IS NOT NULL

    UNION ALL

    SELECT d.descendant_id, e.manager_id AS ancestor_id, d.salary
    FROM descendants d
    JOIN Employees e ON d.ancestor_id = e.employee_id
    WHERE e.manager_id IS NOT NULL
)

SELECT h.employee_id,
       h.employee_name,
       h.level,
       COALESCE(t.team_size, 0) AS team_size,
       h.salary + COALESCE(t.budget, 0) AS budget
FROM hierarchy h
LEFT JOIN (
    SELECT ancestor_id, COUNT(*) AS team_size, SUM(salary) AS budget
    FROM descendants
    GROUP BY ancestor_id
) t ON h.employee_id = t.ancestor_id
ORDER BY h.level ASC, budget DESC, h.employee_name ASC;

