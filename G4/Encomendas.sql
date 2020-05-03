CREATE SCHEMA ENCOMENDAS

GO

CREATE TABLE ENCOMENDAS.IVA
(
		taxa			TINYINT			NOT NULL
		PRIMARY KEY(taxa)
);

CREATE TABLE ENCOMENDAS.PRODUTO
(
		codigo			VARCHAR(30)		NOT NULL,
		preco			MONEY			NOT NULL,
		nome			VARCHAR(20)		NOT NULL,
		iva				TINYINT			NOT NULL
		PRIMARY KEY(codigo)
		FOREIGN KEY(iva)			REFERENCES ENCOMENDAS.IVA(taxa)
);

CREATE TABLE ENCOMENDAS.TIPO
(
		codigo			VARCHAR(30)		NOT NULL,
		quantidade		SMALLINT		NOT NULL,
		PRIMARY KEY(codigo)
);

CREATE TABLE ENCOMENDAS.FORNECEDOR
(
		nif				INT				NOT NULL,
		nome			VARCHAR(20)		NOT NULL,
		endereco		VARCHAR(30)		NOT NULL,
		num_fax			INT,
		cond_pagamento	VARCHAR(20)		NOT NULL,
		tipo			VARCHAR(30)		NOT NULL,
		PRIMARY KEY(nif),
		FOREIGN KEY(tipo)			REFERENCES ENCOMENDAS.TIPO(codigo)
);

CREATE TABLE ENCOMENDAS.ENCOMENDA
(
		numero			INT				NOT NULL,
		data			DATE			NOT NULL,
		fornecedor		INT				NOT NULL,
		PRIMARY KEY(numero),
		FOREIGN KEY(fornecedor)		REFERENCES ENCOMENDAS.FORNECEDOR(nif)
);
CREATE TABLE ENCOMENDAS.CONTEM
(
		codigo_produto	VARCHAR(30)		NOT NULL,
		num_encomenda	INT				NOT NULL,
		designacao		VARCHAR(20)		NOT NULL,
		PRIMARY KEY(codigo_produto),
		FOREIGN KEY(codigo_produto)	REFERENCES ENCOMENDAS.PRODUTO(codigo),
		FOREIGN KEY(num_encomenda)	REFERENCES ENCOMENDAS.ENCOMENDA(numero)
);