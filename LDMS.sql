--1) Create the necessary data structures to contain the data specified in the Appendix ensuring that data integrity is enforced

CREATE TABLE Departments
(
    DepartmentId   NUMBER(5)    PRIMARY KEY,
    DepartmentName VARCHAR2(50) NOT NULL,
    Location       VARCHAR2(50) NOT NULL
);				

CREATE TABLE EMPLOYEESFILE
(
    EMPLOYEEID 	    NUMBER (10) PRIMARY KEY,
    EMPLOYEENAME    VARCHAR2(50) NOT NULL,
    JOBTITLE        VARCHAR2(50) NOT NULL,
    MANAGERID	    NUMBER(10),
    DATEHIRED       DATE         NOT NULL,
    SALARY          NUMBER(10)   NOT NULL,
    DEPARTMENTID    NUMBER(5)    NOT NULL,
    CONSTRAINT FK_DEPARTMENT FOREIGN KEY (DEPARTMENTID) REFERENCES DEPARTMENTS(DEPARTMENTID)
);

--2. Populate the Departments and Employees data structures using the data specified in the Appendix

INSERT INTO Departments values(1,'Management','London');
INSERT INTO Departments values(2,'Engineering','Cardiff');
INSERT INTO Departments values(3,'Research & Development','Edinburgh');
INSERT INTO Departments values(4,'Sales','Belfast');
--
INSERT INTO EMPLOYEESFILE values (90001, 'John Smith','CEO','',to_DATE('01/01/95','DD/MM/YYYY'),100000,1); 
INSERT INTO EMPLOYEESFILE values (90002, 'Jimmy Willis','Manager', 90001, to_DATE('23/09/03','DD/MM/YYYY'),52500, 4);
INSERT INTO EMPLOYEESFILE values (90003, 'Roxy Jones','Salesperson', 90002, to_DATE('11/02/17','DD/MM/YYYY'), 35000, 4);
INSERT INTO EMPLOYEESFILE values (90004, 'Selwyn Field','Salesperson', 90003, to_DATE('20/05/15','DD/MM/YYYY'),32000, 4);
INSERT INTO EMPLOYEESFILE values (90005, 'David Hallett','Engineer', 90006, to_DATE('17/04/18','DD/MM/YYYY'),40000, 2);
INSERT INTO EMPLOYEESFILE values (90006, 'Sarah Phelps','Manager', 90001, to_DATE('21/03/15','DD/MM/YYYY'),45000, 2);
INSERT INTO EMPLOYEESFILE values (90007, 'Louise Harper','Engineer', 90006,to_DATE( '01/01/13','DD/MM/YYYY'),47000, 2);
INSERT INTO EMPLOYEESFILE values (90008, 'Tina Hart','Engineer', 90009, to_DATE('28/07/14','DD/MM/YYYY'),45000, 3);
INSERT INTO EMPLOYEESFILE values (90009, 'Gus Jones','Manager', 90001, to_DATE('15/05/18','DD/MM/YYYY'),50000, 3);
INSERT INTO EMPLOYEESFILE values (90010, 'Mildred Hall','Secretary', 90001, to_DATE('12/10/96','DD/MM/YYYY'),35000, 1);

--3. Create an appropriate executable database object to allow an Employee to be created
CREATE OR REPLACE PROCEDURE Employees(
    p_EmployeeId NUMBER,
    p_EmployeeName VARCHAR2,
    p_JobTitle VARCHAR2,
    p_ManagerId NUMBER,
    p_DateHired DATE,
    p_Salary NUMBER,
    p_DepartmentId NUMBER
) AS
BEGIN
    INSERT INTO Employees (EmployeeId, EmployeeName, JobTitle, ManagerId, DateHired, Salary, DepartmentId) VALUES (p_EmployeeId, p_EmployeeName, p_JobTitle, p_ManagerId, p_DateHired, p_Salary, p_DepartmentId);
    COMMIT;
END;
/

--4. Create an appropriate executable database object to allow the Salary for an Employee to be increased or decreased by a percentage

CREATE OR REPLACE PROCEDURE Employees(
    p_EmployeeId NUMBER,
    p_Salary NUMBER    
) AS
BEGIN
	UPDATE EMPLOYEESFILE
	   SET SALARY * p_Salary;
	 WHERE EmployeeId = p_EmployeeId;
    COMMIT;
END;
/

--5. Create an appropriate executable database object to allow the transfer of an Employee to a different Department

CREATE OR REPLACE PROCEDURE Employees(
    p_EmployeeId   NUMBER,
    P_DEPARTMENTID NUMBER    
) AS
BEGIN
	UPDATE EMPLOYEESFILE
	   SET DEPARTMENTID = P_DEPARTMENTID
	 WHERE EmployeeId = p_EmployeeId;
    COMMIT;
END;
/

--6. Create an appropriate executable database object to return the Salary for an Employee.

CREATE OR REPLACE FUNCTION employees_salary(
    p_EmployeeId   NUMBER,
    p_Salary NUMBER    
) AS
L_SALARY NUMBER;
BEGIN
	SELECT EMPLOYEESFILE
	  INTO L_SALARY
	WHERE EmployeeId = P_EmployeeId;	
	RETURN L_SALARY;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('Employee not found');
END;
/

--7. Write a report to show all Employees for a Department.

CREATE OR REPLACE procedure all_employees(
    P_DEPARTMENTID NUMBER    
) AS
l_EMPLOYEEID 	number,
l_EMPLOYEENAME  varchar2,
l_JOBTITLE      varchar2,
l_MANAGERID	    number,
l_DATEHIRED     date,
l_SALARY        number,
l_DEPARTMENTID  number,
BEGIN
	SELECT  EMPLOYEEID,EMPLOYEENAME,JOBTITLE,MANAGERID,DATEHIRED,SALARY,DEPARTMENTID	
	  INTO l_EMPLOYEEID, 
		   l_EMPLOYEENAME,
		   l_JOBTITLE,    
		   l_MANAGERID,	  
		   l_DATEHIRED,  
		   l_SALARY,      
		   l_DEPARTMENTID  
     FROM EMPLOYEESFILE
	WHERE DEPARTMENTID = P_DEPARTMENTID;	

DBMS_OUTPUT.PUT_LINE('emp id     :'||l_EMPLOYEEID);
DBMS_OUTPUT.PUT_LINE('emp name   :'||l_EMPLOYEENAME);
DBMS_OUTPUT.PUT_LINE('job title  :'||l_JOBTITLE);
DBMS_OUTPUT.PUT_LINE('Manager id :'||l_MANAGERID);
DBMS_OUTPUT.PUT_LINE('date hired :'||l_DATEHIRED);
DBMS_OUTPUT.PUT_LINE('salary     :'||l_SALARY);
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('departmentid not found');
END;
/

--8. Write a report to show the total of Employee Salary for a Department

CREATE OR REPLACE procedure TOT_employees_SAL(
    P_DEPARTMENTID NUMBER    
) AS
l_SALARY        number,
l_DEPARTMENTID  number,
BEGIN
	SELECT SUM(SALARY),DEPARTMENTID
	  INTO l_SALARY,      
		   l_DEPARTMENTID  
     FROM EMPLOYEESFILE
	WHERE DEPARTMENTID = P_DEPARTMENTID
	GROUP BY DEPARTMENTID;	
DBMS_OUTPUT.PUT_LINE('Department :'||DEPARTMENTID || 'SALARY' || l_SALARY;
EXCEPTION
WHEN OTHERS THEN
DBMS_OUTPUT.PUT_LINE('departmentid not found');
END;
/