CREATE SCHEMA COMPANY_DB;

USE COMPANY_DB;

CREATE TABLE EMPLOYEE
(
   Fname       VARCHAR(20) NOT NULL,
   Minit       CHAR(1),
   Lname       VARCHAR(20) NOT NULL,
   Ssn         CHAR(9),
   Bdate       DATE,
   Address     VARCHAR(30),
   Sex         CHAR(1),
   Salary      DECIMAL(8, 2),
   Super_Ssn   CHAR(9),
   Dno         INT,  
   PRIMARY KEY (Ssn)
);

-- use ALTER command to add a foreign key constraint
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYEE_fk1 FOREIGN KEY (Super_ssn)
                                                 REFERENCES EMPLOYEE (Ssn)
						                         ON DELETE CASCADE
                                                 ON UPDATE CASCADE;

INSERT INTO EMPLOYEE (Fname, Minit, Lname, Ssn, Bdate, Address, Sex, Salary, Super_Ssn, Dno) VALUES 
('James', 'E', 'Borg', '888665555', DATE '1937-11-10', '450 Stone, Houston, TX', 'M', 55000, NULL, 1),
('Franklin', 'T', 'Wong', '333445555', DATE '1955-12-08', '638 Voss, Houston, TX', 'M', 40000, '888665555', 5),
('John', 'B', 'Smith', '123456789', DATE '1965-01-09', '731 Fondren, Houston, TX', 'M', 30000, '333445555', 5),
('Jennifer', 'S', 'Wallace', '987654321', DATE '1941-06-20', '291 Berry, Bellaire, Tx', 'F', 37000, '888665555', 4),
('Alicia', 'J', 'Zelaya', '999887777', DATE '1968-01-19', '3321 castle, Spring, TX', 'F', 25000, '987654321', 4),
('Ramesh', 'K', 'Narayan', '666884444', DATE '1962-09-15', '975 Fire Oak, Humble, TX', 'M', 38000, '333445555', 5),
('Joyce', 'A', 'English', '453453453', DATE '1972-07-31', '5631 Rice, Houston, TX', 'F', 25000, '333445555', 5),
('Ahmad', 'V', 'Jabbar', '987987987', DATE '1969-03-29', '980 Dallas, Houston, TX', 'M', 22000, '987654321', 4);


CREATE TABLE DEPARTMENT
(
   Dname            VARCHAR(20) NOT NULL UNIQUE,
   Dnumber          INT,
   Mgr_ssn          CHAR(9),
   Mgr_start_date   DATE,  
   PRIMARY KEY (Dnumber),
   CONSTRAINT DEPARTMENT_fk FOREIGN KEY (Mgr_ssn)
                            REFERENCES EMPLOYEE (Ssn)
                            ON DELETE CASCADE
                            ON UPDATE CASCADE
);

INSERT INTO DEPARTMENT (Dname, Dnumber, Mgr_ssn, Mgr_start_date) VALUES 
('Research', 5, '333445555', DATE '1988-05-22'),
('Administration', 4, '987654321', DATE '1995-01-01'),
('Headquarters', 1, '888665555', DATE '1981-06-19');

-- this alter is here because Employee table was created first
ALTER TABLE EMPLOYEE ADD CONSTRAINT EMPLOYEE_fk2 FOREIGN KEY (Dno) 
                                                 REFERENCES DEPARTMENT (Dnumber)
                                                 ON DELETE CASCADE
                                                 ON UPDATE CASCADE;

CREATE TABLE PROJECT
(
   Pname         VARCHAR(20) NOT NULL UNIQUE,
   Pnumber       INT,
   Plocation     VARCHAR(20),
   Dnum          INT,
   PRIMARY KEY (Pnumber)
);

INSERT INTO PROJECT (Pname, Pnumber, Plocation, Dnum) VALUES 
('ProductX', 1, 'Bellaire', 5),
('ProductY', 2, 'Sugarland', 5),
('ProductZ', 3, 'Houston', 5),
('Computerization', 10, 'Stafford', 4),
('Reorganization', 20, 'Houston', 1),
('Newbenefits', 30, 'Stafford', 4);

CREATE TABLE WORKS_ON
(
   Essn        CHAR(9),
   Pno         INT,
   Hours       DECIMAL(3,1) DEFAULT 0,  
   PRIMARY KEY (Essn, Pno),
   CONSTRAINT WORKS_ON_fk1 FOREIGN KEY (Essn)
                           REFERENCES EMPLOYEE (Ssn)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE,
   CONSTRAINT WORKS_ON_fk2 FOREIGN KEY (Pno)
                           REFERENCES PROJECT(Pnumber)
                           ON DELETE CASCADE
                           ON UPDATE CASCADE
);

INSERT INTO WORKS_ON (Essn, Pno, Hours) VALUES 
('123456789', 1, 32.5),
('123456789', 2, 7.5),
('666884444', 3, 40.0),
('453453453', 1, 20.0),
('453453453', 2, 20.0),
('333445555', 1, 10.0),
('333445555', 2, 10.0),
('333445555', 3, 10.0),
('333445555', 10, 10.0),
('333445555', 20, 10.0),
('999887777', 30, 30.0),
('999887777', 10, 10.0),
('987987987', 10, 35.0),
('987987987', 30, 5.0),
('987654321', 30, 20.0),
('987654321', 20, 15.0),
('888665555', 20, NULL);

CREATE TABLE DEPT_LOCATIONS (
Dnumber    INT,
Dlocation  VARCHAR(20),
PRIMARY KEY (Dnumber, Dlocation),
CONSTRAINT DEPT_LOCATIONS_fk FOREIGN KEY (Dnumber) 
                             REFERENCES DEPARTMENT(Dnumber)
                             ON DELETE CASCADE
                             ON UPDATE CASCADE
);

INSERT INTO DEPT_LOCATIONS (Dnumber, Dlocation) VALUES 
(1, 'Houston'),
(4, 'Stafford'),
(5, 'Bellaire'),
(5, 'Sugarland'),
(5, 'Houston');

CREATE TABLE DEPENDENT (
Essn            CHAR(9),
Dependent_name  VARCHAR(20) NOT NULL,
Sex             CHAR(1),
Bdate           DATE,
Relationship    VARCHAR(20),
PRIMARY KEY (Essn, Dependent_name),
CONSTRAINT DEPENDENT_fk FOREIGN KEY (Essn) 
						REFERENCES EMPLOYEE (Ssn)
                        ON DELETE CASCADE
                        ON UPDATE CASCADE
);

INSERT INTO DEPENDENT (Essn, Dependent_name, Sex, Bdate, Relationship) VALUES
('333445555', 'Alice', 'F', '1986-04-04', 'Daughter'),
('333445555', 'Theodore', 'M', '1983-10-25', 'Son'),
('333445555', 'Joy', 'F', '1958-05-03', 'Spouse'),
('987654321', 'Abner', 'M', '1942-02-28', 'Spouse'),
('123456789', 'Michael', 'M', '1988-01-04', 'Son'),
('123456789', 'Alice', 'F', '1988-12-30', 'Daughter'),
('123456789', 'Elizabeth', 'F', '1967-05-05', 'Spouse');

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