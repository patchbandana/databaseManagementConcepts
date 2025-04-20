-- First, make sure we're using the correct database
USE COMPANY_DB;

-- Query 1: Retrieve the names of all employees in department 5 who work more than 10 hours per week on the ProductX project.
SELECT 'Query 1 Results:' AS '';
SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E, WORKS_ON W, PROJECT P
WHERE E.Ssn = W.Essn
  AND W.Pno = P.Pnumber
  AND P.Pname = 'ProductX'
  AND E.Dno = 5
  AND W.Hours > 10;

-- Query 2: Find the names of all female employees who are directly supervised by 'Franklin Wong'.
SELECT 'Query 2 Results:' AS '';
SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E, EMPLOYEE S
WHERE E.Super_Ssn = S.Ssn
  AND S.Fname = 'Franklin'
  AND S.Lname = 'Wong'
  AND E.Sex = 'F';

-- Query 3: Retrieve the names of all employees whose supervisor's supervisor has '888665555' for Ssn.
SELECT 'Query 3 Results:' AS '';
SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E, EMPLOYEE S1, EMPLOYEE S2
WHERE E.Super_Ssn = S1.Ssn
  AND S1.Super_Ssn = S2.Ssn
  AND S2.Ssn = '888665555';

-- Query 4: Retrieve the names of all employees who do not work on any project.
SELECT 'Query 4 Results:' AS '';
SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E
WHERE E.Ssn NOT IN (SELECT W.Essn FROM WORKS_ON W);

-- Query 5: Create a view for project summary
SELECT 'Query 5 Results:' AS '';
DROP VIEW IF EXISTS PROJECT_SUMMARY;
CREATE VIEW PROJECT_SUMMARY AS
SELECT P.Pname AS Project_Name, 
       D.Dname AS Department_Name,
       COUNT(DISTINCT W.Essn) AS Employee_Count,
       SUM(W.Hours) AS Total_Hours
FROM PROJECT P, DEPARTMENT D, WORKS_ON W
WHERE P.Dnum = D.Dnumber
  AND P.Pnumber = W.Pno
GROUP BY P.Pnumber, P.Pname, D.Dname
HAVING COUNT(DISTINCT W.Essn) > 1;

-- Show the view contents
SELECT * FROM PROJECT_SUMMARY;

-- Bonus Query 1: Retrieve the names of all employees who work on every project.
SELECT 'Bonus Query 1 Results:' AS '';
SELECT E.Fname, E.Minit, E.Lname
FROM EMPLOYEE E
WHERE NOT EXISTS (
    SELECT P.Pnumber
    FROM PROJECT P
    WHERE NOT EXISTS (
        SELECT *
        FROM WORKS_ON W
        WHERE W.Essn = E.Ssn
          AND W.Pno = P.Pnumber
    )
);

-- Bonus Query 2: Find the names and addresses of all employees who work on at least one project 
-- located in Houston but whose department has no location in Houston.
SELECT 'Bonus Query 2 Results:' AS '';
SELECT DISTINCT E.Fname, E.Minit, E.Lname, E.Address
FROM EMPLOYEE E, PROJECT P, WORKS_ON W
WHERE E.Ssn = W.Essn
  AND W.Pno = P.Pnumber
  AND P.Plocation = 'Houston'
  AND E.Dno NOT IN (
      SELECT DL.Dnumber
      FROM DEPT_LOCATIONS DL
      WHERE DL.Dlocation = 'Houston'
  );