--Guiao 10


--ex a)
GO
CREATE PROC dbo.p_RemoveEmployee (@Ssn INT)
AS
	DELETE dbo.WORKS_ON WHERE Essn = @Ssn
	DELETE dbo.WORKS_ON WHERE Essn = @Ssn
	UPDATE dbo.DEPARTMENT SET Mgr_ssn = null, Mgr_start_date = null WHERE Mgr_ssn = @Ssn
	UPDATE dbo.EMPLOYEE SET Super_ssn = null WHERE Super_ssn = @Ssn
	DELETE dbo.EMPLOYEE WHERE SSN = @Ssn
	DELETE dbo.EMPLOYEE WHERE Ssn = @Ssn
	--Deveremos ter como preocupação, a eliminação do funcionário do departamento, assim como eliminar o seu super_ssn

--ex b)
GO
CREATE PROC dbo.p_RecordSetI(@OldestEmployee INT OUTPUT)
AS
	BEGIN

	SELECT TOP 1 @OldestEmployee = Ssn
	FROM (dbo.DEPARTMENT AS Dep JOIN dbo.EMPLOYEE AS Emp on Dep.Mgr_ssn = Emp.Ssn) 
	ORDER BY Mgr_start_date DESC

	-- Funcionarios gestores de departamentos
	SELECT * FROM (dbo.DEPARTMENT AS Dep JOIN dbo.EMPLOYEE AS Emp on Dep.Mgr_ssn = Emp.Ssn)
	END

--ex c)
GO
CREATE TRIGGER t_addManager ON dbo.DEPARTMENT INSTEAD OF INSERT, UPDATE
AS
BEGIN
	DECLARE @Dname			AS VARCHAR(30);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=inserted.Dname, @Dnumber=inserted.Dnumber, @Mgr_ssn=inserted.Mgr_ssn, @Mgr_start_date=inserted.Mgr_start_date FROM inserted;
	
	IF @Mgr_ssn IN (SELECT Mgr_ssn FROM dbo.DEPARTMENT AS D WHERE D.Mgr_ssn = @Mgr_ssn)  -- Se funcionário já for gestor:
	BEGIN
		PRINT('Already has a department');
	END
	ELSE																				-- Else : 
	BEGIN
		IF EXISTS (SELECT * FROM deleted)												-- Se o funcionário já existir, atualizamos a entrada
		BEGIN
			UPDATE dbo.DEPARTMENT SET Dname=@Dname, Dnumber=@Dnumber, Mgr_ssn=@Mgr_ssn, Mgr_start_date=@Mgr_start_date WHERE Dnumber=@Dnumber
		END
		ELSE																			-- Senão, inserimos uma nova entrada
		BEGIN
			INSERT INTO dbo.DEPARTMENT SELECT * FROM inserted;
		END
	END	
END


-- d) 
GO
CREATE TRIGGER t_salary ON dbo.EMPLOYEE AFTER INSERT, UPDATE
AS 
BEGIN
	DECLARE @Essn				AS INT;
	DECLARE @Esalary			AS INT;
	DECLARE @Dno				AS INT;
	DECLARE @ManagerSalary		AS INT;

	SELECT @Essn=inserted.Ssn, @Esalary=inserted.Salary, @Dno=inserted.Dno FROM inserted;
	SELECT @ManagerSalary=EMPLOYEE.Salary FROM DEPARTMENT
		JOIN EMPLOYEE ON DEPARTMENT.Mgr_ssn=EMPLOYEE.Ssn
		WHERE @Dno=DEPARTMENT.Dnumber;
	

	IF @Esalary>@ManagerSalary 
	BEGIN
		UPDATE EMPLOYEE
		SET EMPLOYEE.Salary=@ManagerSalary
		WHERE EMPLOYEE.Ssn=@Essn;
	END
END
GO

-- e)
GO
CREATE FUNCTION dbo.employeeProjects (@empSSN int) RETURNS @table TABLE ([name] varchar(40), [location] varchar(40))
AS
	BEGIN
		INSERT @table
			SELECT PROJECT.Pname, PROJECT.Plocation
			FROM PROJECT
			JOIN WORKS_ON ON WORKS_ON.Pno=PROJECT.Pnumber
			WHERE WORKS_ON.Essn=@empSSN;
		RETURN; 
	END;


-- f)
GO
CREATE FUNCTION dbo.AboveAverageSalary (@dno int) RETURNS @table TABLE (Ssn int)
AS
	BEGIN
		INSERT @table
			SELECT EMPLOYEE.Ssn
			FROM EMPLOYEE
			JOIN (SELECT Dno, AVG(Salary) 'AverageSalary'
				FROM EMPLOYEE
				GROUP BY Dno) AS AVGSALARY
				ON AVGSALARY.Dno=EMPLOYEE.Dno
			WHERE EMPLOYEE.Salary > AVGSALARY.AverageSalary
		RETURN;
	END;

-- g)
GO
CREATE FUNCTION dbo.DepartmentProjects (@dno int) RETURNS @table TABLE (PName varchar(30), Budget int, TotalBudget int)
AS
	BEGIN
		INSERT @table
			SELECT PROJECT.Pname,SUM(EMPLOYEE.Salary) 'Budget',SUM(EMPLOYEE.Salary*WORKS_ON.[Hours]/160) 'TotalBudget'
			FROM DEPARTMENT
				JOIN PROJECT ON DEPARTMENT.Dnumber=PROJECT.Dnum
				JOIN WORKS_ON ON PROJECT.Pnumber=WORKS_ON.Pno
				JOIN EMPLOYEE ON WORKS_ON.Essn=EMPLOYEE.Ssn
			GROUP BY PROJECT.Pname
		RETURN;
	END;
GO
-- h)

--------------------------------------------- Instead of ------------------------------
GO
CREATE TRIGGER t_RemoveDepartment_InsteadOf ON dbo.DEPARTMENT INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Dname			AS VARCHAR(30);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=deleted.Dname, @Dnumber=deleted.Dnumber, @Mgr_ssn=deleted.Mgr_ssn, @Mgr_start_date=deleted.Mgr_start_date FROM deleted;
	-- If the table does not exist, then create
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DEPARTMENT_DELETED'))
		CREATE TABLE DEPARTMENT_DELETED (
		Dname				varchar(30) NOT NULL,
		Dnumber				int,
		Mgr_ssn				int,
		Mgr_start_date		date,
		CONSTRAINT DEPARTMENT_DELETED_PK PRIMARY KEY (Dnumber)
	);
	INSERT INTO dbo.DEPARTMENT_DELETED SELECT * FROM deleted;
	DELETE FROM dbo.DEPARTMENT WHERE Dnumber=@Dnumber;
END

----------------------------------------------After --------------------------------------------------
GO
CREATE TRIGGER t_RemoveDepartment_After ON dbo.DEPARTMENT AFTER DELETE
AS
BEGIN
	DECLARE @Dname			AS VARCHAR(30);
	DECLARE @Dnumber		AS INT;
	DECLARE @Mgr_ssn		AS INT;
	DECLARE @Mgr_start_date AS DATE;

	SELECT @Dname=deleted.Dname, @Dnumber=deleted.Dnumber, @Mgr_ssn=deleted.Mgr_ssn, @Mgr_start_date=deleted.Mgr_start_date FROM deleted;
	-- If the table does not exist, then create
	IF NOT (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = 'DEPARTMENT_DELETED'))
		CREATE TABLE DEPARTMENT_DELETED (
		Dname				varchar(30) NOT NULL,
		Dnumber				int,
		Mgr_ssn				int,
		Mgr_start_date		date,
		CONSTRAINT DEPARTMENT_DELETED_PK PRIMARY KEY (Dnumber)
	);
	INSERT INTO dbo.DEPARTMENT_DELETED SELECT * FROM deleted;
END
-- A diferença entra as duas implementações, verifica-se na medida em que o trigger "Instead of" necessita de um Query de DELETE enquanto o 
-- After já não necessita de tal Query.



-- i)
-- Uma UDF tem os mesmos benificios dos Stored Procedures
-- No entanto, um procedure pode retornar 0 ou n valores, enquanto uma UDF tem de retornar 1 valor
-- Os procedures podem receber parametros de entrada e saida, enquanto uma função só pode receber de entrada
-- As funções podem ser chamadas dentro de um Procedure, mas o contrário já não é verdade.
-- Exceções podem ser manipuladas num Procedure, mas não numa UDF
-- As UDF podem ser utilizadas em SELECT/WHERE/HAVING, enquanto os Procedures não.