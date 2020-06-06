
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



-- Dado um nome, retorna o nr de federaçao

--create function PROJETO.GetNrFed(@name varchar(100))
--returns varchar(100)
--as
--begin
--	declare @number int;
--	set @number = (select p.NrFederacao
--	from PROJETO.Pessoa p
--	where p.Nome = @name);
--	return @number;
--end;
--go

--SELECT PROJETO.GetNrFed('Dasi Grummitt');


---- Dado um Treinador, retorna o tipo de Treinador
create function PROJETO.GetTrainerType(@nrFed int)
returns varchar(100)
as
begin
	DECLARE @trainerType varchar(100);
	declare @treinador int;
	declare @is_found varchar(1);
	-- Check Treinador Principal ---
	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao
	from PROJETO.TreinadorPrincipal t
	open cur;
	fetch cur into @treinador;
	WHILE @@FETCH_STATUS = 0
		begin
			if  @nrFed = @treinador
				begin
					set @trainerType = 'Treinador Principal';
					set @is_found = 'T';
				end
			fetch cur into @treinador;
		end;
	close cur;
	deallocate cur;

	-- Check Treinador Adjunto ---
	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao
	from PROJETO.TreinadorAdjunto t
	open cur;
	fetch cur into @treinador;
	WHILE @@FETCH_STATUS = 0
		begin
			if  @nrFed = @treinador
				begin
					set @trainerType = 'Treinador Adjunto';
				end
			fetch cur into @treinador;
		end;
	close cur;
	deallocate cur;

	-- Check Treinador de Guarda redes
	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao
	from PROJETO.TreinadorGuardaRedes t
	open cur;
	fetch cur into @treinador;
	WHILE @@FETCH_STATUS = 0
		begin
			if  @nrFed = @treinador
				begin
					set @trainerType = 'Treinador de Guarda-Redes';
				end
			fetch cur into @treinador;
		end;
	close cur;
	deallocate cur;
	return @trainerType;
end;
go

--SELECT PROJETO.GetTrainerType(502);
--drop function PROJETO.GetTrainerType;


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


-- Dado um treinador, retorna todos os clubes por onde passou

--create procedure PROJETO.ManagerHistory @nrFed int
--as
--	declare @tempTable table (Nome varchar(100),Clube varchar(100), dataSub date);
--	declare @name varchar(100) = (Select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @nrFed);
--	declare @club varchar(100) = (Select t.ClubeTreinado from PROJETO.Treinador t where t.NrFederacao = @nrFed);
--	declare @dataSub date;
--	insert into @tempTable values(@name,@club,@dataSub);
--	declare @entra varchar(100),@sai varchar(100), @clube varchar(100), @data date
--	set @data =  convert (date,@data)
--	DECLARE cur cursor FAST_FORWARD
--	for select s.TreinadorEntra,s.TreinadorSai,s.Clube,s.DataSubstituicao
--	from PROJETO.TreinadorSubstitui s
--	open cur;
--	fetch cur into @entra,@sai,@clube,@data;
--	WHILE @@FETCH_STATUS = 0
--		begin
--			if  @nrFed = @entra
--				begin
--					insert into @tempTable  values(@name, @clube,@data);
--				end
--			else if  @nrFed = @sai
--				begin
--					insert into @tempTable  values(@name, @clube,@data);
--				end
--			fetch cur into @entra,@sai,@clube,@data;
--		end;
--	close cur;
--	deallocate cur;
--	SELECT * from @tempTable
--GO

--drop procedure PROJETO.ManagerHistory;
--exec PROJETO.ManagerHistory @nrFed = 502


-- Retorna a lista dos treinadores, o seu clube e o seu cargo
create procedure PROJETO.GetTreinadores
as
	declare @tableTemp table(Nome varchar(100),Clube varchar(100),Especializacao varchar(100));
	declare @treinador int;

	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao
	from PROJETO.Treinador t
	open cur;
	fetch cur into @treinador;
	WHILE @@FETCH_STATUS = 0
		begin
			declare @name varchar(100),@clube varchar(100),@type varchar(100);

			set @name = (select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @treinador);
			set @clube = (select t.ClubeTreinado from PROJETO.Treinador t join PROJETO.Pessoa p on t.NrFederacao=p.NrFederacao where p.NrFederacao = @treinador);
			set @type = (select PROJETO.GetTrainerType(@treinador))
			INSERT into @tableTemp values(@name,@clube,@type);
			fetch cur into @treinador
		end;
	close cur;
	deallocate cur;
	select * from @tableTemp;


-- Retorna um clube, ao dar o nome ---

create procedure PROJETO.GetClub @name varchar(100)
as
	select c.Nome,c.Vitorias,c.Derrotas,c.Empates,c.Estadio
	from PROJETO.Clube c
	where c.Nome = @name

--drop procedure PROJETO.GetTeam;
--exec PROJETO.GetClub 'Sporting Clube de Fermentelos';
	
--drop procedure PROJETO.GetTreinadores;

--exec PROJETO.GetTreinadores
----exec PROJETO.JogadoresPosicao 'Atacante'
----drop procedure PROJETO.JogadoresPosicao

