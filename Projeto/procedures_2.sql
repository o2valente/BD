
-- Dado um ano, retorna o vencedor dessa época

create function PROJETO.GetWinner(@year smallint)
returns varchar(100)
as
begin
	declare @nome varchar(100);
	set @nome = (select v.ClubeVencedor
	from PROJETO.Vence v
	where v.AnoEpoca = @year);
	return @nome;
end;
go

--SELECT PROJETO.GetWinner(1999);

--Dada uma equipa, retorna os campeonatos vencidos por essa equipa

create procedure PROJETO.TeamTitles @equipa varchar (100)
as
	select e.Ano from
	PROJETO.Epoca e , PROJETO.Vence v 
	where v.ClubeVencedor = @equipa and v.AnoEpoca = e.Ano
	order by e.Ano;
GO

--drop procedure PROJETO.TeamTitles;

--exec PROJETO.TeamTitles 'Sporting Clube de Fermentelos';

--create procedure PROJETO.ManagerHistory @nrFed int
--as
--	select c.Nome from
--	PROJETO.Clube c, PROJETO.Treinador t, PROJETO.TreinadorSubstitui s
--	where t.ClubeTreinado = c.Nome INTERSECT t.NrFederacao = @nrFed UNION s.TreinadorEntra = @nrFed INTERSECT s.Clube = c.Nome UNION s.TreinadorSai = @nrFed UNION s.Clube = c.Nome
--	order by c.Nome
--GO
--drop procedure PROJETO.ManagerHistory;
--exec PROJETO.ManagerHistory @nrFed = 502

