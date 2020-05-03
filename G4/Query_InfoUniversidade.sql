create schema UNIVERSIDADE;
GO

create table UNIVERSIDADE.Professor(
	Nmec						int				not null check(nmec > 0),
	Nome						varchar(30)		not null,
	Data_Nascimento				date,
	Categoria_Profissional		varchar(20)		not null,
	Area_Cientifica				varchar(20)		not null,
	Nome_Frequenta				varchar(30)		not null,
	primary key(Nmec),
);

create table UNIVERSIDADE.ProjetoInvestigacao(
	ID							int				not null check(ID > 0),
	Nome						varchar(30)		not null,
	Entidade_Financeira			varchar(30)		not null,
	Data_Inicio					date			not null,
	Data_Termino				date			not null,
	Orçamento					money			not null,
	Nmec_gere					int				not null,
	check(Data_Inicio < Data_Termino),
	primary key (ID),
	foreign key (Nmec_gere) references UNIVERSIDADE.Professor(Nmec)
);

create table UNIVERSIDADE.EstudanteGraduado(
	Nmec						int				not null check(Nmec > 0),
	Nome						varchar(30)		not null,
	Data_Nascimento				date,
	Grau_Formação				varchar(25)		not null,
	Aconselha_Nmec				int				not null check(Aconselha_Nmec > 0),
	Frequenta_Departamento		varchar(30)		not null,
	primary key (Nmec),
	foreign key (Aconselha_Nmec) references UNIVERSIDADE.EstudanteGraduado(Nmec)
);

create table UNIVERSIDADE.Departamento(
	Nome						varchar(30)		not null,
	Localizacao					varchar(35)		not null,
	Nmec_dirige					int				not null check(Nmec_dirige > 0),
	primary key(Nome),
	foreign key (Nmec_dirige) references UNIVERSIDADE.Professor(Nmec)
);

create table UNIVERSIDADE.LocalizacaoDepartamento(
	Dep_Nome					varchar(30)		not null,
	Dep_Localizacao				varchar(35)		not null,
	primary key(Dep_Nome, Dep_Localizacao),
	foreign key(Dep_Nome) references UNIVERSIDADE.Departamento(Nome)
);

create table UNIVERSIDADE.Supervisiona(
	Nmec_Professor				int				not null check(Nmec_Professor > 0),
	Nmec_Estudante				int				not null check(Nmec_Estudante > 0),
	primary key (Nmec_Professor, Nmec_Estudante),
	foreign key (Nmec_Professor) references UNIVERSIDADE.Professor(Nmec),
	foreign key (Nmec_Estudante) references UNIVERSIDADE.EstudanteGraduado(Nmec)
);

create table UNIVERSIDADE.Participacao(
	Nmec						int				not null check(Nmec > 0),
	ID_ProjetoInvestigacao		int				not null check(ID_ProjetoInvestigacao > 0),
	primary key (Nmec, ID_ProjetoInvestigacao),
	foreign key (Nmec) references UNIVERSIDADE.EstudanteGraduado(Nmec),
	foreign key (ID_ProjetoInvestigacao) references UNIVERSIDADE.ProjetoInvestigacao(ID)
);

ALTER TABLE UNIVERSIDADE.Professor
	ADD CONSTRAINT ProfDepFK FOREIGN KEY (Nome_Frequenta) REFERENCES UNIVERSIDADE.Departamento(Nome);

ALTER TABLE UNIVERSIDADE.EstudanteGraduado
	ADD CONSTRAINT EstGradDepFK FOREIGN KEY (Frequenta_Departamento) REFERENCES UNIVERSIDADE.Departamento(Nome);