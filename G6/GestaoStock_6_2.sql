CREATE SCHEMA GestaoStock_6_2;
GO


CREATE TABLE GestaoStock_6_2.tipo_fornecedor(
	codigo			SMALLINT				NOT NULL,
	designacao		VARCHAR(40),
	PRIMARY KEY(codigo),
)

INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (101,'Carnes');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (102,'Laticinios');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (103,'Frutas e Legumes');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (104,'Mercearia');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (105,'Bebidas');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (106,'Peixe');
INSERT INTO GestaoStock_6_2.tipo_fornecedor VALUES (107,'Detergentes');


CREATE TABLE GestaoStock_6_2.fornecedor(
	nif			INT				NOT NULL,
	nome		VARCHAR(30)		NOT NULL,
	fax			INT,
	endereco	VARCHAR(50),
	condpag		TINYINT,
	tipo		SMALLINT		NOT NULL,
	PRIMARY KEY(nif),
	FOREIGN KEY(tipo) REFERENCES GestaoStock_6_2.tipo_fornecedor(codigo),
)


INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509111222','LactoSerrano',234872372,NULL,'60',102);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509121212','FrescoNorte',221234567,'Rua do Complexo Grande - Edf 3','90',102);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509294734','PinkDrinks',2123231732,'Rua Poente 723','30',105);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509827353','LactoSerrano',234872372,NULL,'60',102);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509836433','LeviClean',229343284,'Rua Sol Poente 6243','30',107);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('509987654','MaduTex',234873434,'Estrada da Cincunvalacao 213','30',104);
INSERT INTO GestaoStock_6_2.fornecedor VALUES ('590972623','ConservasMac', 234112233,'Rua da Recta 233','30',104);


CREATE TABLE GestaoStock_6_2.produto(
	codigo			INT			NOT NULL,
	nome			VARCHAR(40)	NOT NULL,
	preco			MONEY,
	iva				TINYINT		NOT NULL,
	unidades		INT	NOT NULL
	PRIMARY KEY(codigo),
)

INSERT INTO GestaoStock_6_2.produto VALUES (10001,'Bife da Pa', 8.75,23,125);
INSERT INTO GestaoStock_6_2.produto VALUES (10002,'Laranja Algarve',1.25,23,1000);
INSERT INTO GestaoStock_6_2.produto VALUES (10003,'Pera Rocha',1.45,23,2000);
INSERT INTO GestaoStock_6_2.produto VALUES (10004,'Secretos de Porco Preto',10.15,23,342);
INSERT INTO GestaoStock_6_2.produto VALUES (10005,'Vinho Rose Plus',2.99,13,5232);
INSERT INTO GestaoStock_6_2.produto VALUES (10006,'Queijo de Cabra da Serra',15.00,23,3243);
INSERT INTO GestaoStock_6_2.produto VALUES (10007,'Queijo Fresco do Dia',0.65,23,452);
INSERT INTO GestaoStock_6_2.produto VALUES (10008,'Cerveja Preta Artesanal',1.65,13,937);
INSERT INTO GestaoStock_6_2.produto VALUES (10009,'Lixivia de Cor', 1.85,23,9382);
INSERT INTO GestaoStock_6_2.produto VALUES (10010,'Amaciador Neutro', 4.05,23,932432);
INSERT INTO GestaoStock_6_2.produto VALUES (10011,'Agua Natural',0.55,6,919323);
INSERT INTO GestaoStock_6_2.produto VALUES (10012,'Pao de Leite',0.15,6,5434);
INSERT INTO GestaoStock_6_2.produto VALUES (10013,'Arroz Agulha',1.00,13,7665);
INSERT INTO GestaoStock_6_2.produto VALUES (10014,'Iogurte Natural',0.40,13,998);



CREATE TABLE GestaoStock_6_2.encomenda(
	numero			SMALLINT		NOT NULL,
	data			DATE,
	fornecedor		INT				NOT NULL,
	PRIMARY KEY(numero),
	FOREIGN KEY(fornecedor) REFERENCES GestaoStock_6_2.fornecedor(nif),
)

INSERT INTO GestaoStock_6_2.encomenda VALUES (1,'2015-03-03','509111222');
INSERT INTO GestaoStock_6_2.encomenda VALUES (2,'2015-03-04','509121212');
INSERT INTO GestaoStock_6_2.encomenda VALUES (3,'2015-03-05','509987654');
INSERT INTO GestaoStock_6_2.encomenda VALUES (4,'2015-03-06','509827353');
INSERT INTO GestaoStock_6_2.encomenda VALUES (5,'2015-03-07','509294734');
INSERT INTO GestaoStock_6_2.encomenda VALUES (6,'2015-03-08','509836433');
INSERT INTO GestaoStock_6_2.encomenda VALUES (7,'2015-03-09','509121212');
INSERT INTO GestaoStock_6_2.encomenda VALUES (8,'2015-03-10','509987654');
INSERT INTO GestaoStock_6_2.encomenda VALUES (9,'2015-03-11','509836433');
INSERT INTO GestaoStock_6_2.encomenda VALUES (10,'2015-03-12','509987654');


CREATE TABLE GestaoStock_6_2.item(
	numenc		SMALLINT		NOT NULL,
	codprod		INT		NOT NULL,
	unidades	INT		NOT NULL,
	PRIMARY KEY(numenc, codprod),
	FOREIGN KEY(numenc) REFERENCES GestaoStock_6_2.encomenda(numero),
	FOREIGN KEY(codprod) REFERENCES GestaoStock_6_2.produto(codigo),
)

INSERT INTO GestaoStock_6_2.item VALUES (1,10001,200);
INSERT INTO GestaoStock_6_2.item VALUES (1,10004,300);
INSERT INTO GestaoStock_6_2.item VALUES (2,10002,1200);
INSERT INTO GestaoStock_6_2.item VALUES (2,10003,3200);
INSERT INTO GestaoStock_6_2.item VALUES (3,10013,900);
INSERT INTO GestaoStock_6_2.item VALUES (4,10006,50);
INSERT INTO GestaoStock_6_2.item VALUES (4,10007,40);
INSERT INTO GestaoStock_6_2.item VALUES (4,10014,200);
INSERT INTO GestaoStock_6_2.item VALUES (5,10005,500);
INSERT INTO GestaoStock_6_2.item VALUES (5,10008,10);
INSERT INTO GestaoStock_6_2.item VALUES (5,10011,1000);
INSERT INTO GestaoStock_6_2.item VALUES (6,10009,200);
INSERT INTO GestaoStock_6_2.item VALUES (6,10010,200);
INSERT INTO GestaoStock_6_2.item VALUES (7,10003,1200);
INSERT INTO GestaoStock_6_2.item VALUES (8,10013,350);
INSERT INTO GestaoStock_6_2.item VALUES (9,10009,100);
INSERT INTO GestaoStock_6_2.item VALUES (9,10010,300);
INSERT INTO GestaoStock_6_2.item VALUES (10,10012,200);


-- 6.2 c)

-- a)
select nif, nome, fax, endereco, condpag, tipo
from (GestaoStock_6_2.fornecedor left outer join GestaoStock_6_2.encomenda on nif=fornecedor)
where numero is null

-- b)
select codprod, avg(unidades) as avgunidades
from GestaoStock_6_2.item
group by codprod

-- c)
select avg(Cast(aveg.num as float)) as numMedioEncomenda
from (select count(item.codprod) as num
	from GestaoStock_6_2.item as item
	group by item.numenc
) as aveg

-- d)
select GestaoStock_6_2.produto.nome, GestaoStock_6_2.fornecedor.nome, sum(GestaoStock_6_2.item.unidades) as Unidades
from (GestaoStock_6_2.produto join (GestaoStock_6_2.item join (GestaoStock_6_2.fornecedor join GestaoStock_6_2.encomenda on nif=fornecedor) on numenc=numero) on codigo=codprod)
group by GestaoStock_6_2.fornecedor.nome, GestaoStock_6_2.produto.nome