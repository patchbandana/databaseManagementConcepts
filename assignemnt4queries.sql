SELECT 
    E.Fname, E.Minit, E.Lname
FROM
    EMPLOYEE E,
    WORKS_ON W,
    PROJECT P
WHERE
    E.Ssn = W.Essn AND W.Pno = P.Pnumber
        AND P.Pname = 'ProductX'
        AND E.Dno = 5
        AND W.Hours > 10;
        
SELECT 
    E.Fname, E.Minit, E.Lname
FROM
    EMPLOYEE E,
    EMPLOYEE S
WHERE
    E.Super_Ssn = S.Ssn
        AND S.Fname = 'Franklin'
        AND S.Lname = 'Wong'
        AND E.Sex = 'F';
  
SELECT 
    E.Fname, E.Minit, E.Lname
FROM
    EMPLOYEE E,
    EMPLOYEE S1,
    EMPLOYEE S2
WHERE
    E.Super_Ssn = S1.Ssn
        AND S1.Super_Ssn = S2.Ssn
        AND S2.Ssn = '888665555';
        
SELECT 
    E.Fname, E.Minit, E.Lname
FROM
    EMPLOYEE E
WHERE
    E.Ssn NOT IN (SELECT 
            W.Essn
        FROM
            WORKS_ON W);
            
CREATE VIEW PROJECT_SUMMARY AS
    SELECT 
        P.Pname AS Project_Name,
        D.Dname AS Department_Name,
        COUNT(DISTINCT W.Essn) AS Employee_Count,
        SUM(W.Hours) AS Total_Hours
    FROM
        PROJECT P,
        DEPARTMENT D,
        WORKS_ON W
    WHERE
        P.Dnum = D.Dnumber AND P.Pnumber = W.Pno
    GROUP BY P.Pnumber , P.Pname , D.Dname
    HAVING COUNT(DISTINCT W.Essn) > 1;
    
SELECT 
    E.Fname, E.Minit, E.Lname
FROM
    EMPLOYEE E
WHERE
    NOT EXISTS( SELECT 
            P.Pnumber
        FROM
            PROJECT P
        WHERE
            NOT EXISTS( SELECT 
                    *
                FROM
                    WORKS_ON W
                WHERE
                    W.Essn = E.Ssn AND W.Pno = P.Pnumber));