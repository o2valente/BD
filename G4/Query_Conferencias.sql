CREATE SCHEMA CONFERENCIAS;
GO

create table CONFERENCIAS.ArtigoCientifico(
	Nr_registo	int				not null	check(Nr_Registo > 0), 
	Titulo		varchar(50)		not null,
	primary key(Nr_registo)
);

create table CONFERENCIAS.Autor(
	Email		varchar(25)		not null,
	Nome		varchar(20)		not null,
	Nr_artigo	int unique		not null	check(Nr_artigo > 0),
	primary key(Email),
	foreign key (Nr_artigo) references CONFERENCIAS.ArtigoCientifico(Nr_registo)
);

create table CONFERENCIAS.Pessoa(
	Email		varchar(25)		not null,
	Nome		varchar(30)		not null,
	Instituicao	varchar(20)		not null,
	primary key(Email)
);

create table CONFERENCIAS.Instituicao(
	Nome		varchar(20)		not null,
	Endereço	varchar(50)		not null,
	primary key(Nome)
);

create table CONFERENCIAS.ParticipanteEstudante(
	Email				varchar(25)		not null,
	Instituicao			varchar(20)		not null,
	Nome				varchar(20)		not null,
	Data_Inscricao		datetime		not null,
	Morada				varchar(50)		not null,			
	Comprovativo		varchar(50)	unique	not null,
	primary key(Email),
	foreign key (Instituicao) references CONFERENCIAS.Instituicao(Nome),
	foreign key (Email)	references CONFERENCIAS.Pessoa(Email)
);

create table CONFERENCIAS.ParticipanteNaoEstudante(
	Email				varchar(25)		not null,
	Instituicao			varchar(20)		not null,
	Nome				varchar(20)		not null,
	Data_Inscricao		datetime		not null,
	Morada				varchar(50)		not null,
	Custo_Inscricao		money			not null	check(Custo_Inscricao > 5),
	primary key (Email),
	foreign key (Instituicao) references CONFERENCIAS.Instituicao(Nome),
	foreign key (Email)	references CONFERENCIAS.Pessoa(Email)
);

ALTER TABLE CONFERENCIAS.Autor
	ADD CONSTRAINT AutPessoaFK FOREIGN KEY (Email) REFERENCES CONFERENCIAS.Pessoa(Email);

ALTER TABLE CONFERENCIAS.Pessoa
	ADD CONSTRAINT PessoaInstFK FOREIGN KEY (Instituicao) REFERENCES CONFERENCIAS.Instituicao(Nome);

