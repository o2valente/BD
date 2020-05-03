--CREATE SCHEMA COMPANY_6_2
--GO



--CREATE TABLE COMPANY_6_2.employee (
--	fname			VARCHAR(30)		NOT NULL,
--	minit			CHAR(1),
--	lname			VARCHAR(30)		NOT NULL,
--	ssn				INT				NOT NULL,
--	bdate			DATE,
--	address			VARCHAR(40),
--	sex				CHAR(1)			NOT NULL,
--	salary			MONEY			NOT NULL,
--	super_ssn		INT,
--	dno				TINYINT			NOT NULL,
--	PRIMARY KEY(ssn),
--	FOREIGN KEY(super_ssn) REFERENCES COMPANY_6_2.employee(ssn),
--)


--INSERT INTO COMPANY_6_2.employee VALUES ('Paula','A','Sousa','183623612','2001-08-11','Rua da FRENTE','F',1450.00,NULL,3);
--INSERT INTO COMPANY_6_2.employee VALUES ('Carlos','D','Gomes','21312332','2000-01-01','Rua XPTO','M',1200.00,NULL,1);
--INSERT INTO COMPANY_6_2.employee VALUES ('Juliana','A','Amaral','321233765','1980-08-11','Rua BZZZZ','F',1350.00,NULL,3);
--INSERT INTO COMPANY_6_2.employee VALUES ('Maria','I','Pereira','342343434','2001-05-01','Rua JANOTA','F',1250.00,21312332,2);
--INSERT INTO COMPANY_6_2.employee VALUES ('Joao','G','Costa','41124234','2001-01-01','Rua YGZ','M',1300.00,21312332,2);
--INSERT INTO COMPANY_6_2.employee VALUES ('Ana','L','Silva','12652121','1990-03-03','Rua ZIG ZAG','F',1400.00,21312332,2);


--CREATE TABLE COMPANY_6_2.department(
--	dname			VARCHAR(30)		NOT NULL,
--	dnumber			TINYINT			NOT NULL,
--	mgr_ssn			INT,
--	mgr_start_date	DATE,
--	PRIMARY KEY(dnumber),
--	FOREIGN KEY(mgr_ssn) REFERENCES COMPANY_6_2.employee,
--)

--INSERT INTO COMPANY_6_2.department VALUES ('Investigacao',1,'21312332' ,'2010-08-02');
--INSERT INTO COMPANY_6_2.department VALUES ('Comercial',2,'321233765','2013-05-16');
--INSERT INTO COMPANY_6_2.department VALUES ('Logistica',3,'41124234' ,'2013-05-16');
--INSERT INTO COMPANY_6_2.department VALUES ('Recursos Humanos',4,'12652121','2014-04-02');
--INSERT INTO COMPANY_6_2.department VALUES ('Desporto',5,NULL,NULL);



--ALTER TABLE COMPANY_6_2.employee ADD CONSTRAINT employee_dno FOREIGN KEY(dno) REFERENCES COMPANY_6_2.department(dnumber);

--CREATE TABLE COMPANY_6_2.dependent(
--	essn			INT			NOT NULL,
--	dependent_name	VARCHAR(30)	NOT NULL,
--	sex				CHAR(1)		NOT NULL,
--	bdate			DATE,
--	relationship	VARCHAR(15)	NOT NULL,
--	PRIMARY KEY(essn, dependent_name),
--	FOREIGN KEY(essn) REFERENCES COMPANY_6_2.employee,
--)


--INSERT INTO COMPANY_6_2.dependent VALUES ('21312332' ,'Joana Costa','F','2008-04-01', 'Filho');
--INSERT INTO COMPANY_6_2.dependent VALUES ('21312332' ,'Maria Costa','F','1990-10-05', 'Neto');
--INSERT INTO COMPANY_6_2.dependent VALUES ('21312332' ,'Rui Costa','M','2000-08-04','Neto');
--INSERT INTO COMPANY_6_2.dependent VALUES ('321233765','Filho Lindo','M','2001-02-22','Filho');
--INSERT INTO COMPANY_6_2.dependent VALUES ('342343434','Rosa Lima','F','2006-03-11','Filho');
--INSERT INTO COMPANY_6_2.dependent VALUES ('41124234' ,'Ana Sousa','F','2007-04-13','Neto');
--INSERT INTO COMPANY_6_2.dependent VALUES ('41124234' ,'Gaspar Pinto','M','2006-02-08','Sobrinho');

--CREATE TABLE COMPANY_6_2.dept_locations(
--	dnumber			TINYINT				NOT NULL,
--	dlocation		VARCHAR(40)		NOT NULL,
--	PRIMARY KEY(dnumber, dlocation),
--	FOREIGN KEY(dnumber) REFERENCES COMPANY_6_2.department,
--)


--INSERT INTO COMPANY_6_2.Dept_locations VALUES (2,'Aveiro');
--INSERT INTO COMPANY_6_2.Dept_locations VALUES (3,'Coimbra');



--CREATE TABLE COMPANY_6_2.project(
--	pname			VARCHAR(30)		NOT NULL,
--	pnumber			TINYINT				NOT NULL,
--	plocation		VARCHAR(40)		NOT NULL,
--	dnum			TINYINT				NOT NULL,
--	PRIMARY KEY(pnumber),
--	FOREIGN KEY(dnum) REFERENCES COMPANY_6_2.department,
--)



--INSERT INTO COMPANY_6_2.project VALUES ('Aveiro Digital',1,'Aveiro',3);
--INSERT INTO COMPANY_6_2.project VALUES ('BD Open Day',2,'Espinho',2);
--INSERT INTO COMPANY_6_2.project VALUES ('Dicoogle',3,'Aveiro',3);
--INSERT INTO COMPANY_6_2.project VALUES ('GOPACS',4,'Aveiro',3);



--CREATE TABLE COMPANY_6_2.works_on(
--	essn		INT				NOT NULL,
--	pno			TINYINT			NOT NULL,
--	hours		REAL			NOT NULL,
--	PRIMARY KEY(essn, pno),
--	FOREIGN KEY(essn) REFERENCES COMPANY_6_2.employee,
--	FOREIGN KEY(pno) REFERENCES COMPANY_6_2.project,
--)



--INSERT INTO COMPANY_6_2.works_on VALUES ('183623612',1,20.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('183623612',3,10.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('21312332' ,1,20.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('321233765',1,25.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('342343434',1,20.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('342343434',4,25.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('41124234' ,2,20.0);
--INSERT INTO COMPANY_6_2.works_on VALUES ('41124234' ,3,30.0);



 -- 6.2 c)
--a)
--select ssn, fname, minit, lname, pno
--from (COMPANY_6_2.employee join COMPANY_6_2.works_on on ssn=essn);


---- b)
--select E.fname, E.minit, E.lname
--from (COMPANY_6_2.employee as E join COMPANY_6_2.employee as S on E.super_ssn=S.ssn)
--where S.fname='Carlos' and S.minit='D' and S.lname='Gomes';

---- c)
--select pname, sum(hours) as total_hours
--from (COMPANY_6_2.project join COMPANY_6_2.works_on on pnumber=pno)
--group by pname;

---- d)
--select fname, minit, lname
--from ((COMPANY_6_2.project join COMPANY_6_2.works_on on pnumber=pno and pname='Aveiro Digital') join COMPANY_6_2.employee on ssn=essn)
--where hours>20 and dno=3;

---- e)
--select fname, minit, lname
--from (COMPANY_6_2.employee left outer join COMPANY_6_2.works_on on ssn=essn)
--where pno is null;

---- f)
--select dname, avg(salary) as avg_salary
--from (COMPANY_6_2.department join COMPANY_6_2.employee on dno=dnumber)
--where sex='F'
--group by dname;

---- g)
--select fname, minit, lname
--from (COMPANY_6_2.employee join COMPANY_6_2.dependent on ssn=essn)
--group by fname, minit, lname
--having count(essn)>2;

---- h)
--select fname, minit, lname
--from (COMPANY_6_2.employee join COMPANY_6_2.department on ssn=mgr_ssn) left outer join COMPANY_6_2.dependent on ssn=essn
--where essn is null;
select Prescricao.Paciente.Nome
from Prescricao.Medico join
		(Prescricao.Paciente join Prescricao.Prescricao on Prescricao.Paciente.numUtente = Prescricao.Prescricao.numUtente)
on Prescricao.Medico.numSNS = Prescricao.Prescricao.numMedico
group by Prescricao.Paciente.Nome, Prescricao.Paciente.numUtente
having count(Prescricao.Medico.numSNS) > 1;