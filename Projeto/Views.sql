-- ID das Equipas de Arbitragem
create view PROJETO.getIDea
as
	select ea.ID from PROJETO.EquipaArbitragem ea;

--SELECT * FROM PROJETO.getIDea;
--drop view PROJETO.getIDea

-- Nome dos Estádios
create view PROJETO.getNomeEstadio
as
	select e.Nome from PROJETO.Estadio e;

--drop view PROJETO.getNomeEstadio;

--Numero das Jornadas
create view PROJETO.getNrJornada
as
	select j.NrJornada from PROJETO.Jornada j;

--drop view PROJETO.getNrJornada

--Nomes de todos os clubes
create view PROJETO.getNomesClube
as
	select C.Nome from PROJETO.Clube C;

--drop view PROJETO.getNomesClube;