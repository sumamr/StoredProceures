select * from Employees;

select * from Employees order by salary desc
OFFSET 2 ROWS  Fetch next  1 rows only;

INSERT INTO Testing (Name)
VALUES ('A'), ('B'), ('B'), ('C'), ('C'), ('D'), ('E');
SELECT * FROM Testing; 
select * from Students;
select Name , RANK() over (Order by Name) as Rank_no from Testing;
select Name, DENSE_RANK() over (Order by Name) as DeseRank from Testing;
select Name , ROW_NUMBER() over (Order by Name) as RowNumber from Testing;

--Indexes
Create table EmployeeManager(
EmployeeID int,
FirstName nvarchar(50),
LastName nvarchar(50),
Department nvarchar(50),
Salary int,
ManagerID int
);
select * from EmployeeManager;
--to display the name of the manager
select *, e.FirstName as Manager_Name from EmployeeManager e join EmployeeManager m on e.EmployeeID = m.EmployeeID;
-- Insert 100,000 rows for demo (use a loop or script in real testing)
INSERT INTO EmployeeManager (EmployeeID, FirstName, LastName, Department, Salary, ManagerID)
VALUES --(1, 'Ilakkiya', 'R', 'IT', 50000, 2);
       --(2, 'Jane', 'Smith', 'HR', 60000, 3);
       (3, 'Alice', 'Brown', 'Finance', 55000, 1);
select * from Employees;
sp_rename 'Employee','Employees';
sp_rename 'Employees.Department', 'Departments','COLUMN';
SELECT * FROM Employees WHERE LastName = 'Smith';
select * from Designation;
--Group by and having
select Departments, COUNT(EmployeeID) as Total_Employees from Employees Group by Departments;

SELECT Departments, MAX(Salary) AS MaxSalary
FROM Employees
GROUP BY Departments
HAVING MAX(Salary) > 5000;

--Index
CREATE Index idx_lastName ON Employees(LastName);
CREATE NONCLUSTERED INDEX IX_Salary_GT_50000 
ON Employees(Salary)
WHERE Salary > 50000;
CREATE NONCLUSTERED INDEX IX_Dept_Salary ON Employees(Departments, Salary);

--To know how many index are there for my table 'Employees'
EXEC sys.sp_helpindex @objname = N'Employees';

SET STATISTICS IO ON;

--Cursors
Declare @EmployeeID int, @FirstName VARCHAR(50), @LastName VARCHAR(50), @Departments VARCHAR(50), @Salary int;
Declare Testing CURSOR FOR
Select EmployeeID, FirstName, LastName, Departments, Salary from Employees;

Open Testing

FETCH NEXT FROM Testing INTO @EmployeeID, @FirstName, @LastName, @Departments, @Salary

While @@FETCH_STATUS = 0
BEGIN
  Update Employees set Salary = Salary * 1.05 where EmployeeID = @EmployeeID;
  Print 'Salary updated Successfully' +CAST(@EmployeeID as varchar);	

FETCH NEXT FROM Testing INTO @EmployeeID, @FirstName, @LastName,@Departments, @Salary;
END

CLOSE Testing
DEALLOCATE Testing;

--Query to change the data type of column salary
ALTER table Employees Alter Column Salary float;


--Designation
Create table Designation(
DesignationID int Primary Key,
Designation nvarchar(50)
);
Insert into Designation values(1,'IT');
Insert into Designation values(2,'Software');
Insert into Designation values(3,'Corporate');

Alter table Employees Add  Designation int; 
sp_rename 'Employees.Designation', 'DesignationID', 'COLUMN';
Alter table Employees Add Constraint FK_Employees_DesignationID
Foreign Key(DesignationID) References Designation(DesignationID);
select * from Employees e outer join select * from Designation d on e.DesignationID = d.DesignationID;

--July 30
select * from Employees;
With HighestSalary as(
select Salary, ROW_NUMBER() OVER (Order by Salary desc) as RANK
from (select Distinct Salary from Employees) as DistinctSalary)
Select Salary from HighestSalary where RANK = 2;

SELECT TOP 1 Salary
FROM (
    SELECT DISTINCT TOP 5 Salary
    FROM Employees
    ORDER BY Salary DESC
) AS TopSalaries
ORDER BY Salary ASC;

--try
with CTE AS(select*, ROW_NUMBER() (over partition by salary Order by EmployeeID) as rn from employees
--try
--LIMIT will not work in sql server
SELECT * FROM Employees;
SELECT * 
FROM Employees
ORDER BY Salary DESC
OFFSET 5 ROWS fetch Next 1 rows only; 
--quey to remove duplicate salary of the employee
WITH CTE AS (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY Salary ORDER BY EmployeeID) AS rn
    FROM Employees
)
DELETE FROM CTE WHERE rn > 1;


