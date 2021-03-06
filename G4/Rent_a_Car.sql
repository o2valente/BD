--CREATE SCHEMA EX4_1;

/*CREATE TABLE EX4_1.CLIENTE 
(
	nome			VARCHAR(20)		NOT NULL,
	endereco		VARCHAR(35)		NOT NULL,
	num_carta		INT				NOT NULL,
	NIF				INT				NOT NULL,
	PRIMARY KEY	(NIF)
);*/

/*CREATE TABLE EX4_1.TIPO_VEICULO
(
	designacao		VARCHAR(20)		NOT NULL,
	codigo			INT				NOT NULL,
	arcondicionado	VARCHAR(20)		NOT NULL,
	PRIMARY KEY (codigo)
);

CREATE TABLE EX4_1.BALCAO
(
	nome			VARCHAR(20)		NOT NULL,
	numero			INT				NOT NULL,
	endereco		VARCHAR(35)		NOT NULL,
	PRIMARY KEY (numero)
);

CREATE TABLE EX4_1.VEICULO
(
	marca			VARCHAR(20)		NOT NULL,
	matricula		VARCHAR(8)		NOT NULL,
	ano				SMALLINT		NOT NULL,
	tipo			INT				NOT NULL,
	PRIMARY KEY (matricula),
	FOREIGN KEY (tipo)		REFERENCES EX4_1.TIPO_VEICULO (codigo)
);
*/

/*CREATE TABLE EX4_1.ALUGUER
(
	numero			INT				NOT NULL,
	duracao			SMALLINT		NOT NULL,
	data			DATE			NOT NULL,
	titular			INT				NOT NULL,
	local			INT				NOT NULL,
	objeto			VARCHAR(8)		NOT NULL,
	PRIMARY KEY	(numero),	
	FOREIGN KEY (titular)	REFERENCES EX4_1.CLIENTE (NIF),
	FOREIGN KEY (local)		REFERENCES EX4_1.BALCAO (numero),
	FOREIGN KEY (objeto)	REFERENCES EX4_1.VEICULO (matricula)	
);


CREATE TABLE EX4_1.PESADO
(
	peso			INT				NOT NULL,
	codigo			INT				NOT NULL,
	passageiros		SMALLINT		NOT NULL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(codigo)		REFERENCES EX4_1.TIPO_VEICULO (codigo)
);

CREATE TABLE EX4_1.LIGEIRO
(
	portas			TINYINT			NOT NULL,
	codigo			INT				NOT NULL,
	numlugares		SMALLINT		NOT NULL,
	combustivel		INT				NOT NULL,
	PRIMARY KEY(codigo),
	FOREIGN KEY(codigo)		REFERENCES EX4_1.TIPO_VEICULO (codigo)
);

CREATE TABLE EX4_1.SIMILARIDADE
(
	codigo_1		INT				NOT NULL,
	codigo_2		INT				NOT NULL,
	PRIMARY KEY(codigo_1,codigo_2)
);
*/
ALTER TABLE EX4_1.SIMILARIDADE ADD FOREIGN KEY(codigo_1)	REFERENCES EX4_1.TIPO_VEICULO (codigo);
ALTER TABLE EX4_1.SIMILARIDADE ADD FOREIGN KEY(codigo_2)	REFERENCES EX4_1.TIPO_VEICULO (codigo);