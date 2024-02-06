/*
******************** Kaleab Analysis **********************************

Level: From Basic to Advanced

Here I use a database for a Hypothetical Health Record Management System, HRMS

	TABLES : Patient, Doctor, Disease and Diagnosis, Medicine, PharmacyPersonel, Prescription, MedicinePrescribed, ...*/


USE HRMSDB;
GO




--Write SELECT statement to retrive the entire columns of Employee table by explicitly listing each column.
--NOTE (1) List all the columns to be retrived on SELECT statement
--NOTE (2) The name of each column must be separated by comma

SELECT empId, empFName, empLName, SSN, DoB, gender, salary, employedDate, strAddress, apt, city, state, zipCode, phoneNo, email, empType,  department
FROM Employee

--Repeat the previous exercise, but SSN and DoB must be displated as the 1st and 2nd column
--NOTE : The order of columns list determine their display, regardless of the order of defination in source table.

SELECT SSN, DoB, empId, empFName, empLName, gender, salary, employedDate, strAddress, apt, city, state, zipCode, phoneNo, email, empType,  department
FROM Employee


--Write SELECT statement to retrive the entire columns of Employee table using "star" character (*)
--NOTE : This method is frequently used for quick test, refrain using this short cut in production environment


SELECT *
FROM Employee


--Write SELECT statement to retrive empId, empFName, empLName, phoneNo and email columns of Employee table.


SELECT  empId, empFName, empLName, phoneNo, email
FROM Employee


/*
--SELECT statement can be used to perform calculations and manipulation of data
	Operators, 
		'+' : Adding or Concatinate
		'-' : Subtract
		'*' : Multiply
		'/' : Divide
		'%' : Modulo
	The result will appear in a new column, repeated once per row of result set
	Note : Calculated expressions must be Scalar, must return only single value
	Note : Calculated expressions can operate on other colums in the same row
*/

SELECT 5 % 3

--EXAMPLE : 
--Calculate the amount each type of medicine worth in stock

SELECT *, qtyInStock * unitPrice [WORTH]
FROM Medicine

--The unit price of each medicine is increased by 6%. Provide the list of medecine with 
--their respective rise in price.

SELECT *, unitPrice * 0.06 [ RISE IN PRICE]
FROM Medicine

--Calculate and display the old and new prices for each medicine 

SELECT *, unitPrice * 0.06 [ RISE IN PRICE], unitPrice +(unitPrice * 0.06) [ NEW PRICE]
FROM Medicine


--'+' Can be used to as an operator to concatenate (linked together as in a chain) the content of columns
--EXAMPLE : Get Employee Full Name of all employees

SELECT (empFName + ' ' + empLName) [FULL NAME]
FROM Employee

--Write a code to display employee's Full Address, and Phone Number

SELECT (strAddress+ ' '+ apt+ ' '+ city+ ' '+ state+ ' '+ zipCode) [ADDRESS], phoneNo
FROM Employee

--CONCAT Function
--Is string function that joins two or more string values in an end-to-end manner.
--SYNTAX: CONCAT ( string_value1, string_value2, string_value2, ...)
--EXAMPLE : Write a code to display the Full Name of all employees using CONCAT function

SELECT CONCAT(empFName, ' ', empLName) [FULL NAME]
FROM Employee

--Write a code to display employee's Full Address, and Phone Number using CONCAT function


SELECT CONCAT(strAddress, ' ', apt, ' ', city, ' ', state, ', ', zipCode) [ADDRESS], phoneNo
FROM Employee

/*
DISTINCT statement
	SQL query results are not truly relational, are not always unique, and not guranteed order
	Even unique rows in a source table can return duplicate values for some columns
	DISTINCT specifies only unique rows to apper in result set
--
*/



--EXAMPLE :
--Write a code to retrive the year of employement of all employees in Employee table

SELECT YEAR(employedDate)[EMPLOYED YEAR]
FROM Employee

--Notice there are redudant instances on the result set. Execute the following code
--and observer the change of result set


--EXERCISE # 09
--Write a code that retrive the list of dosages from MedicinePrescribed table, use DISTINCT to eliminate duplicates

SELECT DISTINCT dosage
FROM MedicinePrescribed

/*
Column Aliases
	- At data display by SELECT statement, each column is named after it's source.
	- However, if required, columns can be relabeled using aliases
	- This is useful for columns created with expressons
	- Provides custom column headers.

Table Aliases
	- Used in FROM clause to provide convenient way of refering table elsewhere 
	  in the query, enhance readability 

*/



--EXAMPLE : 
--Display all columns of Disease table with full name for each column


--Write the code to display the 10% rise on the price of each Medicine, use appropriate column alias for computed column

SELECT *, (unitPrice * .1) [RISE IN PRICE]
FROM Medicine


--Modify the above code to include the new price column with the name 'New Price'


SELECT *, unitPrice + (unitPrice * .1) [NEW PRICE]
FROM Medicine

--EXAMPLE :
--Using '=' signs to assign alias to columns


--Use '=' to assign alias for the new price of all medecines with price rise by 13%

SELECT *, [NEWPRICE] = unitPrice + (unitPrice * .13) 
FROM Medicine

--EXAMPLE :
--Using built in function on a column in the SELECT list. Note the name of column is used as input for the function


--EXAMPLE : 
--Write a code to display the the first name and last name of all patients. Use table alias to refer the columns
SELECT P.pFName, P.pLName
FROM Patient P


--Assign the appropriate aliases for columns displayed on previous exercise. 
SELECT P.pFName [PATIENT FIRST NAME], P.pLName [PATIENT LAST NAME]
FROM Patient P

/*
Logical Processing Order on Aliases
	- FROM, WHERE, GROUP BY and HAVING clauses process before SELECT 
	- Aliases created in SELECT clauses only visible to ORDER BY clause
	- Expressions aliased in SELECT clause may be repeated elsewere in query
	
	5. SELECT [DISTINCT | ALL] 7.[TOP <value> [PERCENT]] <column list>
	1. FROM
	2. WHERE
	3. GROUP BY
	4. HAVING
	6. ORDER BY
*/


--The following code will run free from error, since alias dicleration done before alias used by ORDER BY clause
SELECT empId AS [Employee ID], empFName AS [First Name], empLName AS [Last Name]
FROM Employee
WHERE empFName LIKE 'R%'


--EXAMPLE
--The following code will err out, since alias decleration done after the execution of WHERE clause
SELECT empId AS [Employee ID], empFName AS [First Name], empLName AS [Last Name]
FROM Employee
WHERE [First Name] LIKE 'R%'



--EXAMPLE : 
--Simple CASE 
/* 
First
	ALTER TABLE Disease
	DROP COLUMN dCategory
*/
SELECT * FROM Disease

SELECT dId, dName,
		CASE dId
			WHEN 1 THEN 'Bacterial infections'
			WHEN 2 THEN 'Blood Diseases'
			WHEN 3 THEN 'Digestive Diseases'
			ELSE 'NO CATEGORY'
		END AS Category
FROM Disease

--EXAMPLE : 
--Searched CASE
SELECT empId, empFName, empLName, (CASE 
                                         WHEN salary <= 35000 then 'LOW SALARY'
								       	WHEN  salary <= 50000 THEN 'MID SALARY'
										 ELSE 'HIGH SALARY'
									END) AS CATEGORY
FROM Employee


--Use simple CASE to list the brand names of medecines available as per Medecine Id
SELECT *
FROM Medicine
SELECT mId, CASE mId
            WHEN '1' THEN 'XALETO'
			WHEN '2' THEN 'APIZA'
			WHEN '3' THEN 'INHIBITOR'
			ELSE 'NO BRAND NAME'
		END AS [BRAND NAME]
FROM Medicine

--Searched CASE to identify label the price of a medicine cheap, moderate and expensive. Price of cheap ones
--is less than 15 USD, and expensive ones are above 45 USD. Display Medecine Id, Generic Name, the unit price and 
--category of the price.  
SELECT *, CASE
               WHEN (unitPrice <= 15) THEN 'LOW PRICE'
			   WHEN (unitPrice <= 45) THEN 'MODERATE PRICE'
			   ELSE 'HIGH PRICE'
			END AS [CATEGORY OF PRICE]
FROM Medicine

-- Display MRN, Full Name and Gender (as Female and Male) of all Patients -- use case statement for gender
SELECT mrn, CONCAT(pFName, ' ', pLName) FULLNAME, CASE gender
                                                     WHEN 'M' THEN 'MALE'
													 ELSE 'FEMALE'
												END AS GENDER
FROM Patient


--Retrive details of Employees in assending order of their first names

SELECT *
FROM Employee
ORDER BY empFName ASC

-- Also order by last name - and return the names as lastname, firstname
SELECT empLName, empFName
FROM Employee
ORDER BY empLName



--Write a code to retrive details of Patients in assending order of last names 
SELECT *
FROM Patient
ORDER BY pLName

--Write a code to retrive details of Employees in descending order of DoB
--Note : Use column alias on ORDER BY clause
SELECT empId, empFName, empLName, DoB [DATE OF BIRTH]
FROM Employee
ORDER BY [DATE OF BIRTH]


--Display the list of Patients in the order of the year of their treatement. Use their First name to order the ones that came 
--to the hospital on same year. 

-- Return the year, month and day separately
SELECT *, YEAR(registeredDate) registeredYEAR, MONTH(registeredDate) registeredMONTH, DAY(registeredDate)registeredDAY
FROM Patient
ORDER BY registeredYEAR, pFName


--Find below a code to get Employee information (across all columns) - who are contractors,
--Note : P: Principal Associate, A: Associate, C: Contractor, M:Manager
SELECT *
FROM Employee
WHERE empType = 'C'


--Find below a code to get Employee information (across all columns) -  for Contract and Associate
SELECT *
FROM Employee
WHERE empType IN ('C', 'A')


--Find the list of employees with salary above 90,000
SELECT *
FROM Employee
WHERE salary > 90000

--Find the list of employees with salary range betwen 85,000 to 90,000 inclusive
SELECT *
FROM Employee
WHERE salary betwEen 85000 AND 90000


--Find the list of patients that had registration to the hospital in the year 2018
--Use 'BETWEEN' operator
SELECT *
FROM Patient
WHERE registeredDate BETWEEN '01-01-2018' AND '12-31-2018'
-- The above two queries are efficient ones
-- The query below will also return the same result - but considered inefficient (issue related to indexing)


--Get Employees born in the year 1980 (from 1980-01-01 - 1980-12-31)using 'BETWEEN' operator
SELECT *
FROM Employee
WHERE DoB BETWEEN '01-01-1980' AND '12-31-1980'


--Get Employees born in the year 1980 using 'AND' operator
SELECT *
FROM Employee
WHERE DoB >= '01-01-1980' AND DoB <= '12-31-1980'

--We can also use the YEAR() function to do the same for the above exercise - but it is NOT recommended
SELECT *
FROM Employee
WHERE YEAR(DoB) = '1980'


--Write a code that retrives details of Patients that live in Silver Spring.
SELECT *
FROM Patient
WHERE city = 'SILVER SPRING'


--Write a code retrive the information of contractor Employees with salary less than 75000.
SELECT *
FROM Employee
WHERE empType = 'C' AND salary < 75000



--Write a code to retrive list of medicines with price below 30 USD.
SELECT *
FROM Medicine
WHERE unitPrice < 30


--Write a code to retrive patients that live in Miami and Seattle
SELECT *
FROM Patient
WHERE city = 'Miami' OR city = 'Seattle'


--Write a code to display full name for employees
SELECT CONCAT(empFName, ' ', empLName) FULLNAME
FROM Employee


--Get the last four digists of SSN of all Employees together with their id and full name
SELECT empId, CONCAT(empFName, ' ', empLName) FULLNAME, RIGHT(SSN, 4) [SSN LAST FOUR]
FROM Employee

-- Question Write a query to get the Employee with the last four digits of the SSN is '3456'
SELECT empId, CONCAT(empFName, ' ', empLName) FULLNAME, SSN
FROM Employee
WHERE RIGHT(SSN, 4) = '3456'
-- Q2 - Write a query to get the Employee with the last four digits of the SSN is '3456' and with DoB = '1980-09-07'
SELECT empId, CONCAT(empFName, ' ', empLName) FULLNAME, SSN
FROM Employee
WHERE RIGHT(SSN, 4) = '3456' AND  DoB = '1980-09-07'

--Write a code to retrive the full name and area code of their phone number, use Employee table
SELECT CONCAT(empFName, ' ', empLName) [FULL NAME], RIGHT(LEFT(phoneNo, 4), 3)[AREA CODE]
FROM Employee


--Write a code to retrive the full name and area code of their phone number, (without a bracket). use Employee table
SELECT CONCAT(empFName, ' ', empLName) [FULL NAME], RIGHT(LEFT(phoneNo, 4), 3)[AREA CODE]
FROM Employee

--Run the following codes and explain the result with the purpose of CHARINDEX function
SELECT CHARINDEX('O', 'I love SQL')


--Modify the above code, so that the output/result will have appopriate column name
SELECT CHARINDEX('O', 'I love SQL') AS [Index for letter 'O']



--Write a code that return the index for letter 'q' in the sentence 'I love sql'
SELECT CHARINDEX('q', 'I love SQL') [Index for letter 'Q']




--Use the CHARINDEX() function to retrieve the house(building) number of all our employees
SELECT *, LEFT(strAddress,CHARINDEX(' ', strAddress)-1)[BUILDING NO]
FROM Employee




--Run the following code and explain the result with the purpose of LEN function
SELECT LEN('I love SQL')




--Reterive the email's domain name for the entiere employees. 
--NOTE : Use LEN(), CHARINDEX() and RIGHT()
SELECT *, RIGHT(email,(LEN(EMAIL)-CHARINDEX('@', EMAIL)))[EMAIL DOMAIN]
FROM Employee


--Assign a new email address for empId=EMP05 as 'sarah.Kathrin@aol.us'
UPDATE Employee
SET email = 'sarah.Kathrin@aol.us'
WHERE empId = 'EMP05'



--Using wildcards % and _ ('%' means any number of charactes while '_' means single character)
--mostly used in conditions (WHERE clause or HAVING clause)
--Get Employees whose first name begins with the letter 'P'
SELECT *
FROM Employee
WHERE empFName LIKE 'P%'


--Get the list of employees with 2nd letter of their frst name is 'a'
SELECT *
FROM Employee
WHERE empFName LIKE '_A%'


--Get full name of employees with earning more than 75000. (Add salary information to result set)
SELECT CONCAT(empFName, ' ', empLName)[FULL NAME], salary
FROM Employee
WHERE salary > 75000

--Get Employees who have yahoo email account
--NOTE : the code retrives only the list of employee's with email account having 'yahoo.com'
SELECT *, RIGHT(email,(LEN(EMAIL)-CHARINDEX('@', EMAIL)))[EMAIL DOMAIN]
FROM Employee
WHERE email LIKE '%YAHOO.COM' 


--Get Employees who have yahoo email account
--NOTE : Use RIGHT string function. 
SELECT *, RIGHT(email,(LEN(EMAIL)-CHARINDEX('@', EMAIL)))[EMAIL DOMAIN]
FROM Employee
WHERE RIGHT(email, 9) LIKE 'YAHOO.COM' 


--Get Employees who have yahoo email account
--NOTE : The code must checke only 'yahoo' to retrive the entire employees with yahoo account
SELECT *, RIGHT(email,(LEN(EMAIL)-CHARINDEX('@', EMAIL)))[EMAIL DOMAIN]
FROM Employee
WHERE email LIKE '%YAHOO%' 


--Create a CHECK constraint on email column of Employee table to check if it's a valid email address
--NOTE : Assume a valid email address contains the '@' character
ALTER TABLE employee
ADD 
CONSTRAINT CK_EMAIL_VALIDITY CHECK (EMAIL LIKE '%@%')



--Get total number of Employees
SELECT COUNT(empId) [NO OF EMPLOYEES]
FROM Employee



--Get number of Employees not from Maryland
SELECT COUNT(empId)[NO OF EMPLOYEES OUT OF MARYLAND]
FROM Employee
WHERE [state] <> 'MD'

--OR
SELECT COUNT(empId)[NO OF EMPLOYEES OUT OF MARYLAND]
FROM Employee
WHERE [state] != 'MD'


--Get the number of Principal Employees, with emptype = 'P')
SELECT COUNT(empId)[PRINCIPAL EMPLOYEE]
FROM Employee
WHERE empType = 'P'


--Get the Minimum salary
SELECT MIN(salary)[MINIMUM SALARY]
FROM Employee


--Modify the above code to include the Minimum, Maximum, Average and Sum of the Salaries of all employees
SELECT MIN(salary)[MINIMUM SALARY], MAX(salary)[MAXIMUM SALARY], AVG(salary)[AVERAGE SALARY], SUM(salary)[TOTAL SALARY]
FROM Employee


--Get Average Salary of Female Employees
SELECT AVG(salary)
FROM Employee
WHERE gender = 'F'


--Get Average Salary of Associate Employees (empType = 'A')
SELECT CONVERT(DECIMAL(10,2),AVG(salary)) [AVG SALARY OF ASSOCIATES]
FROM Employee
WHERE empType = 'A'


--Get Average salaries for each type of employees?
SELECT empType, CONVERT(DECIMAL(10,2),AVG(salary))[AVG SALARY]
FROM Employee
GROUP BY empType


--Get Average Salary per gender
SELECT gender, CONVERT(DECIMAL(10,2),AVG(salary))[AVG SALARY]
FROM Employee
GROUP BY gender


--Get Average Salary per sate of residence
SELECT [state], CONVERT(DECIMAL(10,2),AVG(salary))[AVG SALARY]
FROM Employee
GROUP BY [state]


--Get Employees earning less than the average salary of all employees
SELECT empId, empFName
FROM Employee
WHERE salary < (SELECT AVG(salary) FROM Employee)


--Get list of Employees with earning less than the average salary of Associate Employees
--Note : Use a scalar subquery which is self contained to solve the problem
SELECT empId, empFName
FROM Employee
WHERE salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'A')


--Get Principal Employees earning less than the average of Contractors
SELECT empId, empFName
FROM Employee
WHERE empType = 'P' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'C')


--Get Principal Employees earning less than or equal to the average salary of Pricipal Employees
SELECT empId, empFName
FROM Employee
WHERE empType = 'P' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'P')


--Get Contractors earning less than or equal to the average salary of Contractors
SELECT empId, empFName
FROM Employee
WHERE empType = 'C' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'C')



--Get Associate Employees earning less than or equal to the average salary of Associate Employees
SELECT empId, empFName
FROM Employee
WHERE empType = 'A' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'A')



--Get Managers earning less than or equal to the average salary of Managers
SELECT empId, empFName
FROM Employee
WHERE empType = 'M' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'M')



--Get the count of Employees based on the year they were born
SELECT YEAR(DoB) [BIRTH YEAR], COUNT(empId) [NO OF EMPLOYEES]
FROM Employee
GROUP BY YEAR(DoB)

--Get list of patients diagnoized by each doctor
--NOTE : Use multi-valued subquery to get the list of doctors from 'Doctors' table
SELECT docId,MRN,diagDate,diagResult
FROM Diagnosis
ORDER BY 1


--EXERCISE # 67
--Get list of patients diagnoized for each disease type
--NOTE : Use multi-valued subquery to get the list of disease from 'Disease' table
SELECT dId, mrn, diagDate, diagResult
FROM Diagnosis D
WHERE D.dId IN (SELECT DISTINCT dId FROM Disease)
ORDER BY 1


--EXAMPLE :
--Get Employees who are earning less than or equal to the average salary of their gender
--NOTE : Use correlated subquery
SELECT empId, empFName
FROM Employee EM
WHERE EM.salary <= (SELECT AVG(salary) FROM  Employee E WHERE E.gender = EM.gender)


--EXERCISE # 68 
--Retrieve all Employees earning less than or equal to their groups averages
--NOTE : Use correlated subquery, 
SELECT empId, empFName
FROM Employee EM
WHERE EM.salary <= (SELECT AVG(salary) FROM  Employee E WHERE E.empType = EM.empType)

-- Create one table called - Department (depId, depName, depEstablishmentDate)
-- And also allocate our employees to the departments
USE HRMSDB;
GO
CREATE TABLE Department 
(
	depId CHAR(4) PRIMARY KEY NOT NULL, 
	depName VARCHAR(40) NOT NULL, 
	depEstablishmentDate DATE
);
GO 
INSERT INTO Department VALUES	('KB10', 'Finance', '2010-10-10'), ('VL20', 'Marketing', '2010-01-10'), ('HN02', 'Medicine', '2010-01-10'),
								('AK12', 'Information Technology', '2015-01-01')
GO
ALTER TABLE Employee
ADD department CHAR(4) FOREIGN KEY REFERENCES Department(depId)
GO
UPDATE Employee
SET department = 'HN02'
WHERE empId IN ('EMP10','EMP12','EMP04','EMP17','EMP15')

UPDATE Employee
SET department = 'KB10'
WHERE empId IN ('EMP01', 'EMP02', 'EMP03')

UPDATE Employee
SET department = 'VL20'
WHERE empId IN
('EMP05',
'EMP06',
'EMP07',
'EMP08',
'EMP09');
GO
UPDATE Employee
SET department = 'AK12'
WHERE department IS NULL



--Note : The answer for the this exercise will be used as subquery to the next question )
--Get the average salary of all employees
SELECT AVG(salary) AVERAGE
FROM Employee


-- Get the average salary of employees in each department
SELECT department, AVG(salary) AVERAGE
FROM Employee
GROUP BY department


--The following code uses 'EXIST' predicate to display the list of doctors that diagnose a patient
SELECT D.docId, D.empId
FROM Doctor D
WHERE EXISTS (SELECT * FROM Diagnosis DI WHERE D.docId = DI.docId)


--Modify the above code to display list of doctor/s that had never diagnosed a patient
SELECT D.docId, D.empId
FROM Doctor D
WHERE NOT EXISTS (SELECT * FROM Diagnosis DI WHERE D.docId = DI.docId)


--Write a code that display the list of medicines which are not prescribed to patients
SELECT mId, brandName
FROM Medicine M
WHERE NOT EXISTS (SELECT * FROM MedicinePrescribed MP WHERE M.mId = MP.mId )


--Write a code that display the list of medicines which are prescribed to patients
SELECT mId, brandName
FROM Medicine M
WHERE EXISTS (SELECT * FROM MedicinePrescribed MP WHERE M.mId = MP.mId )


--Get the CROSS JOIN of Patient and Diagnosis tables
SELECT *
FROM Patient CROSS JOIN Diagnosis


--Get the information of a patient along with its diagnosis. 
--NOTE : First CROSS JOIN Patient and Diagnosis tables, and retrive only the ones that share the same 'mrn on both tables
SELECT *
FROM Patient P CROSS JOIN Diagnosis D
WHERE P.mrn = D.mrn

-- Retrive MRN, Full Name, Diagnosed Date, Disease Id, Result and Doctor Id for Patient, MRN = 'PA002'
SELECT P.mrn, CONCAT(P.pFName, ' ', P.pLName)[FULL NAME], D.diagDate, D.dId, D.diagResult, D.docId
FROM Patient P CROSS JOIN Diagnosis D
WHERE P.mrn = D.mrn


--List employees that are not doctors by profession
--NOTE : Use LEFT OUTER JOIN as required
SELECT E.empId, D.empId, E.empFName, E.empLName
FROM Employee E LEFT JOIN Doctor D ON E.empId = D.empId
WHERE D.empId IS NULL
ORDER BY 2 DESC


--RIGHT OUTER JOIN : Returns all rows form the second table, only matches from first table. 
--It assignes 'NULL' on FIRST table that has no matching with second table
--The following query displays the list of doctors that are not employees to the hospital
SELECT *
FROM Employee E RIGHT JOIN Doctor D ON E.empId = D.empId
WHERE E.empId IS NULL

--The following query displays the list of doctors that had never diagnosed 
--a parient
SELECT D.*
FROM Doctor D LEFT JOIN Diagnosis DS ON D.docId = DS.docId
WHERE DS.docId IS NULL



--Display the list of medicines that are prescribed by any of the doctor. (Use RIGHT OUTER JOIN)
SELECT DISTINCT  M.*
FROM MedicinePrescribed MP RIGHT JOIN Medicine M ON M.mId = MP.mId
WHERE MP.mId IS NOT NULL


--Display the list of medicines that which not prescribed by any of the doctors. (Use RIGHT OUTER JOIN)
SELECT DISTINCT  M.*
FROM MedicinePrescribed MP RIGHT JOIN Medicine M ON M.mId = MP.mId
WHERE MP.mId IS NULL


--Get Patients with their diagnosis information: MRN, Full Name, Insurance Id, Diagnosed Date, Disease Id and Doctor Id
--You can get this information from Patient and Diagnosis tables
SELECT P.mrn, CONCAT(P.pFName, ' ', P.pLName)[FULL NAME], P.insuranceId, D.diagDate, D.dId, D.docId
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn


--Get Doctors who have ever diagonosed a patient(s) with the diagnosis date, mrn 
--and Disease Id and result of the patient who is diagnosed
--The result should include Doctor Id, Specialization, Diagnosis Date, mrn of 
--the patient, Disease Id, Result
SELECT DO.docId, DO.specialization, D.diagDate, D.mrn, D.dId, D.diagResult
FROM Diagnosis D JOIN Doctor DO ON D.docId = DO.docId


--Add the Full Name of the Doctors to the above query.
--HINT : Join Employee table with the existing table formed by joining Doctor & Diagnosis tables on previous exercise
SELECT DO.docId, CONCAT(E.empFName, ' ', empLName)[FULL NAME], DO.specialization, D.diagDate, D.mrn, D.dId, D.diagResult
FROM Diagnosis D JOIN Doctor DO ON D.docId = DO.docId JOIN Employee E ON DO.empId = E.empId


--Add the Full Name of the Patients to the above query.
SELECT DO.docId, CONCAT(E.empFName, ' ', empLName)[FULL NAME], DO.specialization, D.diagDate, P.mrn,CONCAT(P.pFName, ' ', P.pLName)[PATIENT FULL NAME], D.dId, D.diagResult
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn JOIN Doctor DO ON D.docId = DO.docId JOIN Employee E ON DO.empId = E.empId



--Add the Disease Name to the above query
SELECT DO.docId, CONCAT(E.empFName, ' ', empLName)[FULL NAME], DO.specialization, D.diagDate, P.mrn,CONCAT(P.pFName, ' ', P.pLName)[PATIENT FULL NAME], D.dId, DI.dName, D.diagResult
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn JOIN Doctor DO ON D.docId = DO.docId JOIN Employee E ON DO.empId = E.empId JOIN Disease DI ON D.dId = DI.dId


--Join tables as required and retrive PresciptionId, DiagnosisId, PrescriptionDate, MedicineId and Dosage
SELECT P.prescriptionId, P.diagnosisNo, P.prescriptionDate, MP.mId, MP.dosage
FROM Prescription P JOIN MedicinePrescribed MP ON P.prescriptionId = MP.prescriptionId


--Retrive PresciptionId, DiagnosisId, PrescriptionDate, MedicineId, Dosage and Medicine Name
SELECT P.prescriptionId, P.diagnosisNo, P.prescriptionDate, MP.mId, MP.dosage, M.mId
FROM Prescription P JOIN MedicinePrescribed MP ON P.prescriptionId = MP.prescriptionId JOIN Medicine M ON MP.mId = M.mId



-- Get the MRN, Full Name and Number of times each Patient is Diagnosed
SELECT P.mrn, CONCAT(P.pFName, ' ', P.pLName) [FULL NAME], COUNT(D.diagnosisNo)[NO TIMES PATIENT DIAGNOSED]
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn
GROUP BY P.mrn, CONCAT(P.pFName, ' ', P.pLName)


--Get Full Name and number of times every Doctor Diagnosed Patients
SELECT CONCAT(E.empFName, ' ', E.empLName)[FULL NAME], COUNT(DI.diagnosisNo)[NO OF DIAGNOSIS DONE BY EACH DOCTOR]
FROM Employee E JOIN Doctor D ON E.empId = D.empId JOIN Diagnosis DI ON D.docId = DI.docId
GROUP BY CONCAT(E.empFName, ' ', E.empLName)


--Patient diagnosis and prescribed Medicine Information 
--MRN, Patient Full Name, Medicine Name, Prescibed Date and Doctor's Full Name
SELECT D.mrn, CONCAT(P.pFName, ' ', P.pLName)[PATIENT FULL NAME], M.brandName, PR.prescriptionDate, CONCAT(E.empFName, ' ', empLName)[DOCTOR NAME]
FROM Diagnosis D JOIN Doctor DO ON D.docId = DO.docId JOIN Employee E ON DO.empId = E.empId JOIN Patient P ON P.mrn = D.mrn JOIN Prescription PR ON D.diagnosisNo = PR.diagnosisNo JOIN MedicinePrescribed MP ON MP.prescriptionId = PR.prescriptionId JOIN Medicine M ON M.mId = MP.mId


/*
	1- Get Patients' information: MRN, Patient Full Name, and Diagnosed Date of those diagnosed for disease with dId = 3
		(Use filter in Where clause in addition to Joining tables Patient and Diagnosis) */

		SELECT P.mrn, CONCAT(P.pFName, ' ',P.pLName) [PATIENT FULL NAME], D.diagDate
		FROM Diagnosis D JOIN Patient P ON D.mrn = P.mrn
		WHERE D.dId = 3


  /*
	2- Get the Employee Id, Full Name and Specializations for All Doctors  */
		
			SELECT CONCAT(E.empFName,' ',E.empLName) AS [EMPLOYEE NAME], E.empId, D.Specialization
			FROM Employee AS E JOIN Doctor AS D on e.empId=D.empId
  /*
	3- Get Disease Ids (dId) and the number of times Patients are diagnosed for those diseases
	   (Use only Diagnosis table for this)
			- Can you put in the order of (highest to lowest) based on the number of times people diagnosed for the disease?
			- Can you get the top most prevalent disease? */

SELECT dId, COUNT(mrn)[number of times Patients are diagnosed OF those diseases]
FROM Diagnosis
GROUP BY dId
ORDER BY 2 DESC

SELECT TOP 1 WITH TIES dId, COUNT(mrn)[number of times Patients are diagnosed OF those diseases]
FROM Diagnosis
GROUP BY dId
ORDER BY 2 DESC

/*
	4- Get Medicines (mId) and the number of times they are prescribed. 
		(Use only the MedicinePrescribed table)
		- Also get the mId of medicine that is Prescribed the most  */
		SELECT mId, COUNT(prescriptionId)[number of times they are prescribed]
		FROM MedicinePrescribed
		GROUP BY mId
		ORDER BY 2 DESC

		SELECT TOP 1 WITH TIES mId, COUNT(prescriptionId)[number of times they are prescribed]
		FROM MedicinePrescribed
		GROUP BY mId
		ORDER BY 2 DESC


/*
	5- Can you add the name of the medicines the above query (question 4)? 
		(Join MedicinePrescribed and Medicine tables for this)   */
		SELECT MP.mId, M.brandName, COUNT(MP.prescriptionId)[number of times they are prescribed]
		FROM MedicinePrescribed MP JOIN Medicine M ON MP.mId = M.mId
		GROUP BY MP.mId, M.brandName
		ORDER BY 3 DESC

		SELECT TOP 1 WITH TIES MP.mId, M.brandName, COUNT(MP.prescriptionId)[number of times they are prescribed]
		FROM MedicinePrescribed MP JOIN Medicine M ON MP.mId = M.mId
		GROUP BY MP.mId, M.brandName
		ORDER BY 3 DESC

/*
	6- Alter the table PharmacyPersonel and Add a column ppId - which is a primary key. You may use INT as a data type   */
	
			ALTER TABLE PharmacyPersonel ADD ppId INT NOT NULL PRIMARY KEY (ppId)
	SELECT * FROM PharmacyPersonel
	
	/*
	7- Create one table called MedicineDispense with the following properties
		MedicineDispense(
							dispenseNo - pk, 
							presciptionId and mId - together fk
							dispensedDate - defaults to today
							ppId - foreign key referencing the ppId of PharmacyPersonnel table
						)  */


			CREATE TABLE MedicineDispense
			(
			 dispenseNo INT NOT NULL,
			 prescriptionId INT NOT NULL,
			 mId SMALLINT NOT NULL,
			 dispensedDate DATE DEFAULT GETDATE(),
			 ppId INT NOT NULL,
			 CONSTRAINT PK_MedicineDispense_dispenseNo PRIMARY KEY (dispenseNo),
			 CONSTRAINT FK_MedicineDispense_presciptionId_mId FOREIGN KEY ([prescriptionId],mId) REFERENCES MedicinePrescribed([prescriptionId],mId),
--			 CONSTRAINT DEF_MedicineDispense_dispensedDate DEFAULT GETDATE() for dispensedDate,
			 CONSTRAINT FK_MedicineDispense_ppId FOREIGN KEY (ppId) REFERENCES PharmacyPersonel(ppId)		
			)


/*
	8- Add four Pharmacy Personnels (add four rows of data to the PharmacyPersonnel table) - Remember PharmacyPersonnel are Employees
		and every row you insert into the PharmacyPersonnel table should each reference one Employee from Employee table  */

		   INSERT INTO PharmacyPersonel (empId, pharmacistLisenceNo,licenceDate, PCATTestResult, level, ppId)
				VALUES ('EMP02','GP-003','2012-02-06', 86, 'Out Patient', 1),
					   ('EMP06','HP-012','2015-11-12',  72, 'In Patient',2),
					   ('EMP08','CP-073','2014-04-13',  93, 'Store Manager',3),
					   ('EMP10','GP-082', '2017-06-19', 67, 'Duty Manager',4)

/*
	9- Add six MedicineDispense data  */

		 INSERT INTO MedicineDispense (dispenseNo, prescriptionId, mId, dispensedDate, ppId)
				VALUES (1,10,3,'2018-03-11',4),
					   (2,11,1,'2017-09-21',3),
					   (3,12,5,'2016-08-26',2),
					   (4,13,4,'2015-04-04',1),
					   (5,17,3,'2014-03-23',2),
					   (6,18,4,'2017-09-28',4)

*/




/*
	SET OPERATIONS :
		-UNION
		-UNION ALL
		-INTERSECT
		-EXCEPT
*/


CREATE TABLE HotelCust
(
	fName VARCHAR(20),
	lName VARCHAR(20),
	SSN CHAR(11),
	DoB DATE
);
GO

CREATE TABLE RentalCust
(
	firstName VARCHAR(20),
	lastName VARCHAR(20),
	social CHAR(11),
	DoB DATE,
	phoneNo CHAR(12)
);
GO


INSERT INTO HotelCust 
	VALUES	('Dennis', 'Gogo', '123-45-6789', '2000-01-01'), 
	        ('Belew', 'Haile', '210-45-6789', '1980-09-10'),
			('Nathan', 'Kasu', '302-45-6700', '1989-02-01'), 
			('Kumar', 'Sachet', '318-45-3489', '1987-09-20'),
			('Mahder', 'Nega', '123-02-0089', '2002-01-05'), 
			('Fiker', 'Johnson', '255-22-6033', '1978-05-10'),
			('Alemu', 'Tesema', '240-29-6035', '1982-05-16')


INSERT INTO RentalCust 
	VALUES	('Ujulu', 'Obang', '000-48-6789', '2001-01-01','908-234-0987'), 
			('Belew', 'Haile', '210-45-6789', '1980-09-10', '571-098-2312'),
			('Janet', 'Caleb', '903-00-4700', '1977-02-01', '204-123-0987'), 
			('Kumar', 'Sachet', '318-45-3489', '1987-09-20', '555-666-7788'),
			('Mahder', 'Nega', '123-02-0089', '2002-01-05', '301-678-9087'),
			('John', 'Miller', '792-02-0789', '2005-10-25', '436-678-4567')




--EXERCISE # 85 
--Correct the above code and use 'UNION' operator to get the list of all customers in HotelCustomrs and RentalCustomer 



--EXERCISE # 86 
--Use UNION ALL operator instead of UNION and explain the differece on the result/output



--EXERCISE # 87 
--Get list of customers in both Hotel and Rental Customers ( INTERSECT )

--EXERCISE # 88 
--Get list of customers who are Hotel Customers but not Rental ( EXCEPT )


--EXERCISE # 89
--Get list of customers who are Rental Customers but not Hotel  (EXCEPT )




/*********************   STORED PROCEDURES  **************************************/
	

--Write a code that displays the list of patients and the dates they were diagnosed
SELECT mrn, diagDate
FROM Diagnosis


--Customize the above code to creates a stored proc to gets the same result
CREATE PROC usp_PDD
AS
SELECT mrn, diagDate
FROM Diagnosis
GO


--Execute the newly created stored procedure, using EXEC
EXEC usp_PDD


--Modify the above procedure disply patients that was diagnosed in the year 2018
ALTER PROC usp_PDD
AS
SELECT mrn, diagDate
FROM Diagnosis
WHERE YEAR(diagDate) = 2018
GO

EXEC usp_PDD

--Drop the procedure created in the above example
DROP  PROC usp_PDD


--[ Procedure with parameter/s ]
--Create a proc that returns Doctors who diagnosed Patients in a given year
CREATE PROC usp_DOC_DIAG_PAT_IN_GIVEN_YEAR(@YR INT)
AS
SELECT docId
FROM Diagnosis
WHERE @YR = YEAR(diagDate)

EXEC usp_DOC_DIAG_PAT_IN_GIVEN_YEAR 2023

DROP PROC usp_DOC_DIAG_PAT_IN_GIVEN_YEAR
--[ Procedure with DEFAULT values for parameter/s]
--Create a proc that returns Doctors who diagnosed Patients in a given year. The same procedure 
--will display a message 'Diagnosis Year Missing' if the year is not given as an input. 
--NOTE : If no specific year is entered, NULL is a default value for the parameter
CREATE PROC usp_DOCTOR_DIAG_PAT_IN_GIVEN_YEAR(@YR INT = NULL)
AS
BEGIN
  IF @YR IS NULL 
     BEGIN 
		  PRINT 'Diagnosis Year Missing'
	 END
  ELSE
     BEGIN
	      SELECT DISTINCT DI.docId, CONCAT(E.empFName, ' ', E.empLName) FULLNAME, D.specialization, DI.diagDate
          FROM Diagnosis DI JOIN Doctor D ON DI.docId = D.docId JOIN Employee E ON E.empId = D.empId
          WHERE @YR = YEAR(diagDate)
	 END
END
GO

EXEC usp_DOCTOR_DIAG_PAT_IN_GIVEN_YEAR 2023

DROP PROC usp_DOCTOR_DIAG_PAT_IN_GIVEN_YEAR


--Create a stored procedure that returns the average salaries for each type of employees.
--NOTE : use 'usp' as prefix for new procedures, to mean ' user created stored procedure'
CREATE PROC usp_AVG_SPET
AS
SELECT empType, AVG(salary) [AVG SALARY]
FROM Employee
GROUP BY empType
GO

--It is also possible to use 'EXEC' instead of 'EXECUTE', 

EXECUTE usp_AVG_SPET

EXEC usp_AVG_SPET

DROP PROC usp_AVG_SPET


--Create a stored procedure to get list of employees earning less than the average salary of 
--all employees
--NOTE : use 'usp' as prefix for new procedures, to mean ' user created stored procedure'
CREATE PROC usp_EMP_EARNING_LAVGSAL
AS 
SELECT empId, empFName, salary
FROM Employee
WHERE salary < (SELECT AVG(salary) FROM Employee)
GO

EXEC usp_EMP_EARNING_LAVGSAL

DROP PROC usp_EMP_EARNING_LAVGSAL


--Create a procedure that returns list of Contractors that earn less than average salary of Principals
ALTER  PROC usp_CELASP
AS 
SELECT empId, empFName, empLName, salary, empType
FROM Employee
WHERE empType = 'C' AND salary < (SELECT AVG(salary) FROM Employee WHERE empType = 'P'
GO


--Create a proc that returns Doctors who diagnosed Patients in a year 2017
--NOTE : (1) The result must include DocId, Full Name, Specialization, Email Address and DiagnosisDate
CREATE PROC usp_DDPY2017 
AS
SELECT DI.docId, CONCAT(E.empFName, ' ', E.empLName) FULLNAME, D.specialization, E.email, DI.diagDate
FROM Diagnosis DI JOIN Doctor D ON DI.docId = D.docId JOIN Employee E ON E.empId = D.empId
WHERE YEAR(DI.diagDate) = 2017
GO

EXEC usp_DDPY2017

DROP PROC usp_DDPY2017


--Create a stored proc that returns list of patients diagnosed by a given doctor. 
CREATE PROC usp_PDGD (@DN CHAR(4))
AS
SELECT DI.mrn, CONCAT(P.pFName, ' ', P.pLName) FULLNAME, DI.docId
FROM Diagnosis DI JOIN Patient P ON DI.mrn = P.mrn
WHERE @DN = DI.docId
GO

EXEC usp_PDGD MD02

DROP PROC usp_PDGD

--Create a stored procedure that returns the average salary of Employees with a given empType
CREATE PROC usp_AVGSPET (@ET VARCHAR(20))
AS
SELECT empType, CONVERT(DECIMAL(10,2), AVG(salary)) [AVG SALARY]
FROM Employee
WHERE @ET = empType
GROUP BY empType
GO

EXEC usp_AVGSPET P

DROP PROC usp_AVGSPET


--Create a stored Proc that returns the number of diagnosis each doctor made in a 
--given month of the year -> pass both month and year as integer values
CREATE PROC NDPD (@DY INT, @DM INT)
AS
SELECT YEAR(diagDate)[YEAR], MONTH(diagDate)[MONTH],docId, COUNT(diagnosisNo) [NO OF DIAG]
FROM Diagnosis
WHERE @DY = YEAR(diagDate) AND @DM = MONTH(diagDate)
GROUP BY YEAR(diagDate), MONTH(diagDate), docId
GO

EXEC NDPD 2023, 09

DROP PROC NDPD



--USING STORED PROCEDURES FOR DML

--Create a proc that is used to insert data into the Disease table
CREATE PROC USP_IDDT @DID INT, @DNAME VARCHAR (100), @DCATEGORY VARCHAR(50), @DTYPE VARCHAR(40)
AS
INSERT INTO Disease VALUES (@DID, @DNAME, @DCATEGORY, @DTYPE)
GO


--to insert new record
EXECUTE USP_IDDT 100, 'Nasal Congestion', 'Infectious', 'Contageous'

--to remove newly inserted record
DELETE FROM Disease WHERE dId = 100

--to delete the procedure
DROP PROC USP_IDDT


--Create a procedure to insert data into Doctors table,
CREATE PROC USP_IDDOCT @EMPID CHAR(5), @DOCID CHAR(4), @LICENSENO CHAR(11), @LICENCEDATE DATE, @RANK VARCHAR(25), @SPECIALIZATION VARCHAR(50)
AS
INSERT INTO Doctor VALUES (@EMPID, @DOCID, @LICENSENO, @LICENCEDATE, @RANK, @SPECIALIZATION)
GO

EXEC USP_IDDOCT 'EMP48', 'MD45', 'JFF-87-6455', '2017-09-10', 'SENIOR', 'Family medicine'

--Confirm for the insertion of new record using SELECT statement



--Create a stored Proc to deletes a record from RentalCust table with a given SSN 
CREATE PROC DRRCT @SSN CHAR(11)
AS
DELETE FROM RentalCust
WHERE @SSN = social
GO

EXECUTE DRRCT '903-00-4700'

SELECT * FROM RentalCust


--Create the stored procedure that delete a record of a customer in HotelCust table for a given SSN
--The procedure must display 'invalid SSN' if the given ssn is not found in the table
CREATE PROC USP_DRHCT @SSN CHAR(11)
AS
BEGIN 
    IF @SSN IN (SELECT SSN FROM HotelCust)
	   BEGIN 
	      DELETE FROM HotelCust WHERE @SSN = SSN
	   END
    ELSE
	   BEGIN
	     PRINT 'INVALID SSN'
	   END
END
GO

EXEC USP_DRHCT '000-48-6780'

--Write a stored procedure to delete a record from RentalCust for a given SSN. If the SSN is not found
--the procedure deletes the entire rows in the table.
--NOTE : First take backup for Employee table before performing this task. 
CREATE PROC USP_DRRCUST @SSN CHAR(11)
AS
BEGIN 
    IF @SSN IN (SELECT social FROM RentalCust)
	   BEGIN 
	      DELETE FROM RentalCust WHERE @SSN = social
	   END
    ELSE
	   BEGIN
	     DELETE FROM RentalCust
	   END
END
GO




--Write a code that displays the list of customers with the middle two numbers of their SS is 45
SELECT *
FROM RentalCust
WHERE social LIKE '___-45-____'


--Create a Proc that Deletes record/s from RentalCustomer table, by accepting ssn as a parameter. 
--The deletion can only happen if the middle two numbers of SSN is 45
CREATE PROC USP_DRRCTBL @SSN CHAR(11)
AS
BEGIN
   IF @SSN LIKE '___-45-____'
       BEGIN 
	      DELETE FROM RentalCust
		  WHERE @SSN = social
	   END
	ELSE
	   BEGIN 
	     PRINT 'INVALID SOCIAL'
	   END
END


-- Now test the sp
EXEC USP_DRRCTBL '000-48-6789'

DROP PROC USP_DRRCTBL

SELECT * FROM RentalCust

--Create a procedure that takes two numeric characters, and delete row/s from RentalCust table 
--if the middle two characters of the customer/s socal# are same as the passed characters 
CREATE PROC USP_DRRCTBL @2NC CHAR(2)
AS
DELETE FROM RentalCust
WHERE SUBSTRING(social,5,2) =  @2NC
GO


--STORED PROCEDURES to update a table
--Create an stored procedure that updates the phone Number of a rental customer, for a given customer
--Note : The procesure must take two parameters social and new phone number
CREATE PROC USP_UPRC @SSN CHAR(11), @PN CHAR(12)
AS
UPDATE RentalCust
SET phoneNo =@PN
WHERE social = @SSN
GO

EXEC USP_UPRC '001-48-6789', '111-111-1111'


/*
--************************************  VIEWS  *****************************************************/



--Write a code that displays patient's MRN, Full Name, Address, Disease Id and Disease Name
SELECT DI.mrn, CONCAT(P.pFName, ' ', P.pLName) [FULL NAME], CONCAT(P.stAddress, ' ', P.city, ' ', P.[state]) [ADDRESS], DI.dId, D.dName
FROM Diagnosis DI JOIN Disease D ON DI.dId = D.dId JOIN Patient P ON DI.mrn = P.mrn



--Create simple view named vw_PatientDiagnosed using the above code.  
CREATE VIEW vw_PatientDiagnosed
AS
SELECT DI.mrn, CONCAT(P.pFName, ' ', P.pLName) [FULL NAME], P.stAddress, P.city, P.[state], DI.dId, D.dName
FROM Diagnosis DI JOIN Disease D ON DI.dId = D.dId JOIN Patient P ON DI.mrn = P.mrn
GO


--Check the result of vw_PatientDiagnosed by SELECT statement
SELECT *
FROM vw_PatientDiagnosed


--Use vw_PatientDiagnosed and retrieve only the patients that came from MD
--Note : It is possible to filter Views based on a criteria, similar with tables
SELECT *
FROM vw_PatientDiagnosed
WHERE [state] = 'MD'



--Modify vw_PatientDiagnosed so that it returns the patients diagnosed in year 2017 
ALTER VIEW vw_PatientDiagnosed
AS
SELECT DI.mrn, CONCAT(P.pFName, ' ', P.pLName) [FULL NAME], P.stAddress, P.city, P.[state], DI.dId, D.dName
FROM Diagnosis DI JOIN Disease D ON DI.dId = D.dId JOIN Patient P ON DI.mrn = P.mrn
WHERE YEAR(DI.diagDate) = 2017
GO



--Check the result of modified vw_PatientDiagnosed by SELECT statement
SELECT *
FROM vw_PatientDiagnosed



--Use sp_helptext to view the code for vw_PatientDiagnosed
--sp_helptext vw_PatientDiagnosed

sp_helptext vw_PatientDiagnosed


--Drop vw_PatientDiagnosed

Drop VIEW vw_PatientDiagnosed


--Create a view that returns Employees that live in state of Maryland, (Employee empId, FullName, DOB)
CREATE VIEW VW_ELMS
AS
SELECT empId, CONCAT(empFName, ' ', empLName)FULLNAME, DoB
FROM Employee

SELECT * 
FROM VW_ELMS


--Create view that displays mId, Medicine ID and the number of times each medicine was 
--prescribed.
CREATE VIEW VW_NO_OF_MED_PERISC
AS
SELECT M.mId, COUNT(MP.prescriptionId) [TIMES PRESCRIBED]
FROM Medicine M JOIN MedicinePrescribed MP ON M.mId = MP.mId
GROUP BY M.mId
GO

SELECT *
FROM VW_NO_OF_MED_PERISC


--Join vw_MedicinePrescribed with Medicine table and get mId, brandName, genericName and 
--number of times each medicine was prescribed  
CREATE VIEW VW_NO_OF_MED_PRESCRIBED
AS
SELECT M.mId, M.brandName, M.genericName, COUNT(MP.prescriptionId) [TIMES PRESCRIBED]
FROM Medicine M JOIN MedicinePrescribed MP ON M.mId = MP.mId
GROUP BY M.mId, M.brandName, M.genericName
GO

SELECT * 
FROM VW_NO_OF_MED_PRESCRIBED



--Create a view that displays all details of a patient along with his/her diagnosis details
CREATE VIEW VW_PAT_DIAG_DETAIL
AS 
SELECT P.*, DI.diagnosisNo, DI.docId, DI.dId, DI.diagDate, DI.diagResult
FROM Patient P JOIN Diagnosis DI ON P.mrn = DI.mrn
GO

SELECT *
FROM VW_PAT_DIAG_DETAIL



--Use the view created for 'EXERCISE - View # 04' to get the full detail of the doctors
SELECT VW.*, D.empId, D.licenseNo, D.licenseDate, D.[rank], D.specialization
FROM VW_PAT_DIAG_DETAIL VW JOIN Doctor D ON VW.docId = D.docId


--Create the view that returns Contract employees only, empType='C'
CREATE VIEW VW_C_EMP
AS
SELECT * 
FROM Employee
WHERE empType ='C'
GO




--Create the view that returns list of female employees that earn more 
--than the average salary of male employees
CREATE VIEW VW_F_EMP_EARN_MTM
AS
SELECT *
FROM Employee
WHERE gender = 'F' AND salary > (SELECT AVG(salary) FROM Employee WHERE gender = 'M')
GO

SELECT * FROM VW_F_EMP_EARN_MTM



--Create the view that returns list of employees that are not doctors
CREATE VIEW VW_EMP_NOT_D
AS
SELECT E.*
FROM Employee E LEFT JOIN Doctor D ON E.empId = D.empId
WHERE D.empId IS NULL
GO



--Create the view that returns list of employees that are not pharmacy personel
CREATE VIEW VW_EMP_NOT_PP
AS
SELECT E.*
FROM Employee E LEFT JOIN PharmacyPersonel PP ON E.empId = PP.empId
WHERE PP.empId IS NULL
GO



--Create the view that returns empid, full name, dob and ssn of doctors and pharmacy personels
CREATE VIEW VW_D_AND_PP
AS
SELECT E.empId, CONCAT(E.empFName, ' ',E.empLName) FULLNAME, E.DoB, E.SSN 
FROM Employee E JOIN Doctor D ON E.empId = D.empId
UNION SELECT E.empId, CONCAT(E.empFName, ' ',E.empLName) FULLNAME, E.DoB, E.SSN 
FROM Employee E JOIN PharmacyPersonel PP ON E.empId = PP.empId

GO


--Create the view that returns list of medicines that are not never prescribed. 
CREATE VIEW VW_MED_NOT_PRES
AS
SELECT M.*
FROM Medicine M LEFT JOIN MedicinePrescribed MP ON M.mId = MP.mId
WHERE MP.mId IS NULL
GO



--Create the view that returns list of patients that are not diagnosed for a disease 'Cholera'
CREATE VIEW VW_PNDWC
AS
SELECT p.mrn, p.pFName, p.pLName
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn
WHERE D.dId != 4
GO


--Create the view that returns list of employees that earn less than employees averge salary
CREATE VIEW VW_EELAS
AS
SELECT *
FROM Employee 
WHERE salary < (SELECT AVG(salary) FROM Employee)
GO



--Create simple view on Disease table vw_Disease that dispaly entire data
CREATE VIEW VW_DISEASE
AS
SELECT * 
FROM Disease
GO

DROP VIEW VW_DISEASE


--Create view that returns list of doctors that had never done any diagnossis. 
CREATE VIEW VW_DWOD
AS
SELECT D.*
FROM Doctor D LEFT JOIN Diagnosis DI ON D.docId = DI.docId
WHERE DI.docId IS NULL
GO


--Use view, vw_Disease, to insert one instance/record in Disease table
SELECT * FROM VW_DISEASE 
INSERT INTO VW_Disease VALUES (44, 'scam', 'lie', 'agonized')
GO



--Use view, vw_Disease, to delete a record inserted on previous exercise.
DELETE FROM VW_DISEASE WHERE VW_DISEASE.DID = 44



--Create simple view on Medicine table vw_Medicine that dispaly entire data
CREATE VIEW VW_MEDICINE
AS
SELECT *
FROM Medicine
GO



--Insert data into the Medicine table using vw_Medicine
INSERT INTO VW_MEDICINE VALUES (15, 'Asprine', 'No name', 2000, 'Pain killer','2024-02-09', 0.35)



--Create a view, vw_PatientAndDiagnosis, by joining patient and diagnosis tables and 
--try to insert data into vw_PatientDiagnosis view and explain your observation
CREATE VIEW VW_PatientAndDiagnosis
AS 
SELECT P.mrn, P.pFName, D.diagnosisNo
FROM Patient P JOIN Diagnosis D ON P.mrn = D.mrn


INSERT INTO VW_PatientAndDiagnosis VALUES ('PA112', 'HAJI', '39')



/*******************    COMMON TABLE EXPRESSIONS (CTEs)        ***************************************/


--Create a CTE that returns medicines and number of times they are prescribed (mId, NumberOfPrescriptions)
--Then join the created CTE with Medicine table to get the name and number of prescription of the medecines
WITH CTE_MPT AS
(
SELECT mId, COUNT(mId)[NO OF PRESCRIPTION]
FROM MedicinePrescribed
GROUP BY mId)
SELECT M.brandName, CTE_MPT.[NO OF PRESCRIPTION]
FROM CTE_MPT JOIN Medicine M ON CTE_MPT.mId = M.mId



--Create CTE that returns the average salaries of each type of employees
WITH CTE_ASPET AS
(
SELECT empType, AVG(salary) AVGSALARY
FROM Employee
GROUP BY empType
)
SELECT *
FROM CTE_ASPET


--Modify the above code to sort the output by empType in descending order. 
WITH CTE_ASPET AS
(
SELECT empType, AVG(salary) AVGSALARY
FROM Employee
GROUP BY empType
)
SELECT *
FROM CTE_ASPET
ORDER BY 1 DESC


--Create CTE to display PrescriptionId, DiagnossisNo, Prescription Date for each patient. Then use  
--the created CTE to retrive the dossage and number of allowed refills. 
WITH CTE_NT AS
(
SELECT D.mrn, D.diagnosisNo, P.prescriptionId, P.prescriptionDate
FROM Diagnosis D JOIN Prescription P ON D.diagnosisNo = P.diagnosisNo
)
SELECT CTE_NT.*, MP.dosage, MP.numberOfAllowedRefills
FROM CTE_NT JOIN MedicinePrescribed MP ON CTE_NT.prescriptionId = MP.prescriptionId


--Create CTE to display the list of patients. The result must include mrn, full name, gender, dob and ssn.
WITH CTE_PD AS
(
SELECT mrn, CONCAT(pFName, ' ', pLName) FULLNAME, gender, PDoB, SSN
FROM Patient
)
SELECT * 
FROM CTE_PD


--Modify the above script to make use of the CTE to display the name of a disease
--each patient is diagnosed 
WITH CTE_PD AS
(
SELECT mrn, CONCAT(pFName, ' ', pLName) FULLNAME, gender, PDoB, SSN
FROM Patient
)
SELECT CTE_PD.*, DI.dName [DIAGNOSED WITH]
FROM CTE_PD JOIN Diagnosis D ON D.mrn = CTE_PD.mrn join Disease DI ON D.dId = DI.dId



--Create CTE to display DiagnossisNo, DiagnossisDate and Disease Type of all Diagnossis made. Later use the CTE 
--to include the rank of the specialization and rank of the doctor. 
WITH CTE_DDH AS
(
SELECT D.diagnosisNo, D.diagDate, DI.dType, D.docId
FROM Diagnosis D JOIN Disease DI ON D.dId = DI.dId
)
SELECT CTE_DDH.*, D.specialization, D.[rank]
FROM CTE_DDH JOIN Doctor D ON CTE_DDH.docId = D.docId



--Modify the above code, to include doctor's full name and dob. 
WITH CTE_DDH AS
(
SELECT D.diagnosisNo, D.diagDate, DI.dType, D.docId
FROM Diagnosis D JOIN Disease DI ON D.dId = DI.dId
)
SELECT CTE_DDH.*, D.specialization, D.[rank], CONCAT(E.empFName, ' ', empLName)FULLNAME, E.DoB
FROM CTE_DDH JOIN Doctor D ON CTE_DDH.docId = D.docId JOIN Employee E ON D.empId = E.empId



--Create CTE that returns the average salaries of each type of employees. Then use the same CTE
--to display the list of employees that earn less than their respective employee type average salaries
WITH CTE_ASPET AS
(
SELECT empType, AVG(salary) AVGSALARY
FROM Employee
GROUP BY empType
)
SELECT CTE_ASPET.*, E.empId, E.empFName
FROM CTE_ASPET JOIN Employee E ON CTE_ASPET.empType = E.empType
WHERE E.salary < CTE_ASPET.AVGSALARY


--Create CTE that calculates the average salaries for each gender of employees
WITH CTE_AVGET AS
(
SELECT gender, AVG(salary) AVGSALARY
FROM Employee
GROUP BY gender
)
SELECT * 
FROM CTE_AVGET



--Use the CTE created for 'EXERCISE - CTE # 09' and provide the list of employees that earn less more than
--the average salary of their own gender.
WITH CTE_AVGET AS
(
SELECT gender, AVG(salary) AVGSALARY
FROM Employee
GROUP BY gender
)
SELECT E.empId, E.empFName, E.gender
FROM CTE_AVGET join Employee E ON CTE_AVGET.gender = E.gender
WHERE E.salary < CTE_AVGET.AVGSALARY



--Create CTE that calculates the average salaries for female employees. Use the created CTE to display
--list of male employees that earn less than the average salary of female employees.
WITH CTE_AVGET AS
(
SELECT gender, AVG(salary) AVGSALARY
FROM Employee
GROUP BY gender
)
SELECT E.empId, E.empFName, E.gender, E.salary
FROM CTE_AVGET join Employee E ON CTE_AVGET.gender = E.gender
WHERE E.gender = 'M' AND E.salary < (SELECT AVGSALARY FROM CTE_AVGET WHERE gender = 'F')







