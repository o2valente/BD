
-- Dado um ano, retorna o vencedor dessa época

--create function PROJETO.GetWinner(@year smallint)
--returns varchar(100)
--as
--begin
--	declare @nome varchar(100);
--	set @nome = (select v.ClubeVencedor
--	from PROJETO.Vence v
--	where v.AnoEpoca = @year);
--	return @nome;
--end;
--go

--SELECT PROJETO.GetWinner(1999);



-- Dado um nome, retorna o nr de federaçao

create function PROJETO.GetNrFed(@name varchar(100))
returns varchar(100)
as
begin
	declare @number int;
	set @number = (select p.NrFederacao
	from PROJETO.Pessoa p
	where p.Nome = @name);
	return @number;
end;
go

--SELECT PROJETO.GetNrFed('Dasi Grummitt');





--Dada uma equipa, retorna os campeonatos vencidos por essa equipa

--create procedure PROJETO.TeamTitles @equipa varchar (100)
--as
--	select e.Ano from
--	PROJETO.Epoca e , PROJETO.Vence v 
--	where v.ClubeVencedor = @equipa and v.AnoEpoca = e.Ano
--	order by e.Ano;
--GO

--drop procedure PROJETO.TeamTitles;

--exec PROJETO.TeamTitles 'Sporting Clube de Fermentelos';


-- Dado um treinador, retorna todos os clubes por onde passou

create procedure PROJETO.ManagerHistory @nrFed int
as
	declare @tempTable table (Nome varchar(100),Clube varchar(100));
	declare @name varchar(100) = (Select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @nrFed);
	declare @club varchar(100) = (Select t.ClubeTreinado from PROJETO.Treinador t where t.NrFederacao = @nrFed);
	insert into @tempTable values(@name,@club);
	declare @entra varchar(100),@sai varchar(100), @clube varchar(100), @data date
	DECLARE cur cursor FAST_FORWARD
	for select s.TreinadorEntra,s.TreinadorSai,s.Clube
	from PROJETO.TreinadorSubstitui s
	open cur;
	fetch cur into @entra,@sai,@clube;
	WHILE @@FETCH_STATUS = 0
		begin
			if  @nrFed = @entra
				begin
					insert into @tempTable  values(@name, @clube);
				end
			else if  @nrFed = @sai
				begin
					insert into @tempTable  values(@name, @clube);
				end
			fetch cur into @entra,@sai,@clube;
		end;
	close cur;
	deallocate cur;
	SELECT * from @tempTable
GO

--drop procedure PROJETO.ManagerHistory;
--exec PROJETO.ManagerHistory @nrFed = 502


--create procedure PROJETO.GetTreinadores
--as
--	select p.Nome,t.ClubeTreinado from
--	PROJETO.Treinador t join PROJETO.Pessoa p on t.NrFederacao=p.NrFederacao
--	order by p.Nome;


--exec PROJETO.GetTreinadores
----exec PROJETO.JogadoresPosicao 'Atacante'
----drop procedure PROJETO.JogadoresPosicao

