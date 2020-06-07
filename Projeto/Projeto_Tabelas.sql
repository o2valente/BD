create schema PROJETO;
go


create table PROJETO.Estadio(
	Nome			varchar(100)	not null,
	Capacidade		int				not null,
	primary key (Nome)
);

create table PROJETO.Clube(
	Nome			varchar(100)	not null,
	Vitorias		tinyint			not null,
	Derrotas		tinyint			not null,
	Empates			tinyint			not null,
	Estadio			varchar(100)	not null,
	primary key (Nome),
	foreign key (Estadio)	references PROJETO.Estadio(Nome)
);

create table PROJETO.Pessoa(
	NrFederacao		int				not null,
	Nome			varchar(100)	not null,
	primary key	(NrFederacao)
);



create table PROJETO.Direcao(
	Presidente		int				not null,
	PresAssGeral	int				not null,
	Administrador	int			    not null,
	nome_clube		varchar(100)	not null,
	primary key (Presidente),
	foreign key (nome_clube)	references PROJETO.Clube(Nome),
	foreign key (Presidente)	references PROJETO.Pessoa(NrFederacao),
	foreign key (PresAssGeral)	references PROJETO.Pessoa(NrFederacao),
	foreign key (Administrador)	references PROJETO.Pessoa(NrFederacao)
);

create table PROJETO.GrupoAdeptos(
	Nome			varchar(100)	not null,
	DataFundacao	date			not null,
	clube_apoia		varchar(100)	not null,
	primary key (Nome),
	foreign key (clube_apoia)	references PROJETO.Clube(Nome)
);

create table PROJETO.Jogador(
	NrFederacao		int				not null,
	NrCamisola		tinyint			not null,
	Posicao			varchar(50)		not null,
	clube			varchar(100)	not null,
	primary key (NrFederacao),
	foreign key (nrFederacao)	references PROJETO.Pessoa(NrFederacao),
	foreign key (clube)			references PROJETO.Clube(Nome)
);

create table PROJETO.Epoca(
	Ano				smallint		not null,
	primary key (Ano),
);

create table PROJETO.Jornada(
	NrJornada		tinyint			not null,
	Semana			tinyint			not null,
	Ano				smallint		not null,
	primary key (NrJornada),
	foreign key (Ano)			references PROJETO.Epoca(Ano)
);

create table PROJETO.Jogo(
	NrJogo			int				not null, --tinhamos como pk NrJornada
	NrEspetadores	int				,
	Estadio			varchar(100)	not null,
	NrJornada		tinyint			not null,
	EquipaArbitragem tinyint 		,
	Clube1			varchar(100)	not null,
	Clube2			varchar(100)	not null,
	Resultado1		int				,
	Resultado2		int				,
	primary key (NrJogo),
	foreign key (Estadio)		references PROJETO.Estadio(Nome),
	foreign key (NrJornada)		references PROJETO.Jornada(NrJornada),
	foreign key (Clube1)		references PROJETO.Clube(Nome),
	foreign key (Clube2)		references PROJETO.Clube(Nome),
	--check(NrEspetadores < PROJETO.Estadio(Capacidade))
);

create table PROJETO.Vence(
	Pontos			tinyint,
	ClubeVencedor	varchar(100),
	AnoEpoca		smallint,
	primary key (AnoEpoca),
	foreign key (ClubeVencedor) references PROJETO.Clube(Nome),
	foreign key (AnoEpoca)		references PROJETO.Epoca(Ano)
);


create table PROJETO.Arbitro(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Pessoa(NrFederacao),
);



create table PROJETO.ArbitroCampo(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Arbitro(NrFederacao),
	
);

create table PROJETO.ArbitroLinha(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Arbitro(NrFederacao)
);

create table PROJETO.QuartoArbitro(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Arbitro(NrFederacao)
);

create table PROJETO.EquipaArbitragem(
	ID				tinyint			not null,
	ArbitroCampo	int				not null,
	ArbitroLinha1	int				not null,
	ArbitroLinha2	int				not null,
	QuartoArbitro	int				not null,
	primary key (ID),
	foreign key (ArbitroCampo)	references PROJETO.ArbitroCampo(NrFederacao),
	foreign key (ArbitroLinha1)	references PROJETO.ArbitroLinha(NrFederacao),
	foreign key (ArbitroLinha2)	references PROJETO.ArbitroLinha(NrFederacao),
	foreign key (QuartoArbitro)	references PROJETO.QuartoArbitro(NrFederacao)
);

create table PROJETO.Treinador(
	NrFederacao		int				not null,
	ClubeTreinado	varchar(100),
	primary key (NrFederacao),
	foreign key (ClubeTreinado)	references PROJETO.Clube(Nome),
	foreign key (NrFederacao)	references PROJETO.Pessoa(NrFederacao)
);

create table PROJETO.TreinadorPrincipal(
	NrFederacao		int					not null,
	TaticaPreferida varchar(100)		not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Treinador(NrFederacao)
);

create table PROJETO.TreinadorAdjunto(
	NrFederacao		int					not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Treinador(NrFederacao)
);

create table PROJETO.TreinadorGuardaRedes(
	NrFederacao		int					not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Treinador(NrFederacao)
);

create table PROJETO.TreinadorSubstitui(
	id				 int				not null,
	TreinadorEntra	 int				not null,
	TreinadorSai	 int				not null,
	Clube			 varchar(100)		not null,
	DataSubstituicao date				not null,
	primary key (id),
	foreign key (TreinadorEntra) references PROJETO.TreinadorPrincipal(NrFederacao),	
	foreign key (TreinadorSai) references PROJETO.TreinadorPrincipal(NrFederacao),	
	foreign key (Clube) references PROJETO.Clube(Nome),	
);

ALTER TABLE PROJETO.Jogo ADD FOREIGN KEY(EquipaArbitragem) REFERENCES PROJETO.EquipaArbitragem (ID);

drop table PROJETO.TreinadorSubstitui

drop table PROJETO.Jogo