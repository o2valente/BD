create schema PROJETO;
go

create table PROJETO.Clube(
	Nome			varchar(100)	not null,
	Vitorias		tinyint			not null,
	Derrotas		tinyint			not null,
	Empates			tinyint			not null,
	Estadio			varchar(100)	not null,
	primary key (Nome)
);

create table PROJETO.Pessoa(
	NrFederacao		int				not null,
	Nome			varchar(100)	not null,
	primary key	(NrFederacao)
);

create table PROJETO.Estadio(
	Nome			varchar(100)	not null,
	Capacidade		int				not null,
	primary key (Nome)
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
	Vencedor		varchar(100)	not null,
	primary key (Ano),
	foreign key (Vencedor)		references PROJETO.Clube(Nome)
);

create table PROJETO.Jornada(
	NrJornada		tinyint			not null,
	Semana			tinyint			not null,
	Ano				smallint		not null,
	primary key (NrJornada),
	foreign key (Ano)			references PROJETO.Epoca(Ano)
);

create table PROJETO.Jogo(
	NrJogo			tinyint			not null, --tinhamos como pk NrJornada
	NrEspetadores	int				not null,
	Estadio			varchar(100)	not null,
	NrJornada		tinyint			not null,
	Arbitro			int				not null, --why?
	Clube1			varchar(100)	not null,
	Clube2			varchar(100)	not null,
	Resultado1		int				not null,
	Resultado2		int				not null,
	primary key (NrJogo),
	foreign key (Estadio)		references PROJETO.Estadio(Nome),
	foreign key (NrJornada)		references PROJETO.Jornada(NrJornada),
	foreign key (Clube1)		references PROJETO.Clube(Nome),
	foreign key (Clube2)		references PROJETO.Clube(Nome),
	--check(NrEspetadores < PROJETO.Estadio(Capacidade))
);

create table PROJETO.Vence(
	Pontos			tinyint			not null,
	ClubeVencedor	varchar(100)	not null,
	AnoEpoca		smallint		not null,
	primary key (Pontos),
	foreign key (ClubeVencedor) references PROJETO.Clube(Nome),
	foreign key (AnoEpoca)		references PROJETO.Epoca(Ano)
);

create table PROJETO.Arbitro(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Pessoa(NrFederacao)
);

create table PROJETO.Arbitrar(
	Arbitro			int				not null,
	NrJogo			tinyint			not null,
	primary key (Arbitro),
	foreign key (Arbitro)		references PROJETO.Arbitro(NrFederacao),
	foreign key (NrJogo)		references PROJETO.Jogo(NrJogo)
);

create table PROJETO.ArbitroCampo(
	NrFederacao		int				not null,
	primary key (NrFederacao),
	foreign key (NrFederacao)	references PROJETO.Arbitro(NrFederacao)
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

create table PROJETO.Treinador(
	NrFederacao		int				not null,
	Nome			varchar(100)	not null,
	ClubeTreinado	varchar(100)	not null,
	primary key (NrFederacao),
	foreign key (ClubeTreinado)	references PROJETO.Clube(Nome),
	foreign key (NrFederacao)	references PROJETO.Pessoa(NrFederacao)
);

create table PROJETO.TreinadorSubstitui(
	TreinadorEntra	 int	  unique	not null,
	TreinadorSai	 int	  unique	not null,
	Clube			 varchar(100)		not null,
	DataSubstituicao date				not null,
	primary key (TreinadorEntra,TreinadorSai),
	foreign key (TreinadorEntra) references PROJETO.Treinador(NrFederacao),	
	foreign key (TreinadorSai) references PROJETO.Treinador(NrFederacao),	
	foreign key (Clube) references PROJETO.Clube(Nome),	
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

alter table PROJETO.Clube
	add constraint CluEstFK foreign key (Estadio) references PROJETO.Estadio(Nome);
