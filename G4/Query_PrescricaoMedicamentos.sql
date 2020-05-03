CREATE SCHEMA MEDICAMENTOS;
GO

CREATE TABLE MEDICAMENTOS.Medico(
	Nr_SNS			INT				NOT NULL	check(Nr_SNS > 0),
	Nome			VARCHAR(20)		NOT NULL,	
	Especialidade	VARCHAR(20)		NOT NULL,
	PRIMARY KEY (Nr_SNS)
);

CREATE TABLE MEDICAMENTOS.Prescricao(
	Numero		INT			NOT NULL	check(Numero > 0),
	Pdata		Date,
	ID_Medico	INT			NOT NULL	check(ID_Medico > 0),
	ID_Paciente	INT			NOT NULL	check(ID_Paciente > 0),
	ID_Farmacia	INT			NOT NULL	check(ID_Farmacia > 0),
	PRIMARY KEY (Numero),
	FOREIGN KEY (ID_Medico) REFERENCES MEDICAMENTOS.Medico(Nr_SNS)
);

CREATE TABLE MEDICAMENTOS.Paciente(
	Nr_Utente		INT				NOT NULL	check(Nr_Utente > 0),
	Nome			VARCHAR(20)		NOT NULL,
	Endereço		VARCHAR(20)		NOT NULL,
	Data_Nascimento	Date,
	PRIMARY KEY (Nr_Utente)
);

CREATE TABLE MEDICAMENTOS.Farmacia(
	NIF			INT				NOT NULL	check(NIF > 0),
	Nome		VARCHAR(20)		NOT NULL,
	Endereço	VARCHAR(20)		NOT NULL,
	Telefone	INT	UNIQUE		NOT NULL	check(Telefone > 0),
	PRIMARY KEY (NIF),
);

CREATE TABLE MEDICAMENTOS.Farmaco(
	Formula				VARCHAR(10)			NOT NULL,
	Nr_Comercial		INT		UNIQUE		NOT NULL	check(Nr_Comercial > 0),
	Nr_Farmaceutica		INT					NOT NULL	check(Nr_Farmaceutica > 0)
	PRIMARY KEY (Formula),
	
);

CREATE TABLE MEDICAMENTOS.CompanhiaFarmaceutica(
	NRN_Farmaceutica	INT				NOT NULL	check(NRN_Farmaceutica > 0),
	Nome				VARCHAR(20)		NOT NULL,
	Telefone			INT		UNIQUE	NOT NULL	check(Telefone > 0),
	Endereço			VARCHAR(20)		NOT NULL,
	PRIMARY KEY (NRN_Farmaceutica)
);

CREATE TABLE MEDICAMENTOS.FarmacoVendidoFarmacia(
	ID_Farmacia			INT				NOT NULL	check(ID_Farmacia > 0),
	Formula_Farmaco		VARCHAR(10)		NOT NULL,
	Nr_Farmaceutica		INT				NOT NULL	check(Nr_Farmaceutica > 0)
	PRIMARY KEY (ID_Farmacia,Formula_Farmaco, Nr_Farmaceutica),
	FOREIGN KEY (ID_Farmacia) REFERENCES MEDICAMENTOS.Farmacia(NIF),
	FOREIGN KEY (Formula_Farmaco) REFERENCES MEDICAMENTOS.Farmaco(Formula),
	FOREIGN KEY (Nr_Farmaceutica) REFERENCES MEDICAMENTOS.CompanhiaFarmaceutica(NRN_Farmaceutica),
);

CREATE TABLE MEDICAMENTOS.PrecricaoContemFarmaco(
	Nr_Prescricao		INT				NOT NULL	check(Nr_Prescricao > 0),
	Formula_Farmaco		VARCHAR(10)		NOT NULL,
	Nr_Farmaceutica		INT				NOT NULL	check(Nr_Farmaceutica > 0),
	PRIMARY KEY (Nr_Prescricao,Formula_Farmaco,Nr_Farmaceutica),
	FOREIGN KEY (Nr_Prescricao) REFERENCES MEDICAMENTOS.Prescricao(Numero),
	FOREIGN KEY (Formula_Farmaco) REFERENCES MEDICAMENTOS.Farmaco(Formula),
	FOREIGN KEY (Nr_Farmaceutica) REFERENCES MEDICAMENTOS.Companhiafarmaceutica(NRN_Farmaceutica),
);

ALTER TABLE MEDICAMENTOS.Prescricao
	ADD CONSTRAINT PrescPacFK FOREIGN KEY (ID_Paciente) REFERENCES MEDICAMENTOS.Paciente(Nr_Utente);

ALTER TABLE MEDICAMENTOS.Prescricao
	ADD CONSTRAINT PrescPacFK1 FOREIGN KEY (ID_Farmacia) REFERENCES MEDICAMENTOS.Farmacia(NIF);

ALTER TABLE MEDICAMENTOS.Farmaco
	ADD CONSTRAINT FarmCompFK FOREIGN KEY (Nr_Farmaceutica) REFERENCES MEDICAMENTOS.CompanhiaFarmaceutica(NRN_Farmaceutica);