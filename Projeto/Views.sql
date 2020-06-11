create view PROJETO.getIDea
as
	select ea.ID from PROJETO.EquipaArbitragem ea;

--SELECT * FROM PROJETO.getIDea;
--drop view PROJETO.getIDea

create view PROJETO.getNomeEstadio
as
	select e.Nome from PROJETO.Estadio e;

--drop view PROJETO.getNomeEstadio;

create view PROJETO.getNrJornada
as
	select j.NrJornada from PROJETO.Jornada j;

--drop view PROJETO.getNrJornada

create view PROJETO.getNomesClube
as
	select C.Nome from PROJETO.Clube C;

--drop view PROJETO.getNomesClube;