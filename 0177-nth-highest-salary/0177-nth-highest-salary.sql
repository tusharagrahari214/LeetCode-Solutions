CREATE FUNCTION getNthHighestSalary(N INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
        WITH salary_rank AS(
            SELECT  salary,
                   DENSE_RANK() OVER(ORDER BY salary DESC) AS sal_rank
            FROM Employee
        )
        SELECT MAX(salary)
        FROM salary_rank
        WHERE sal_rank = N
  );
END