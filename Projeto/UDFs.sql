--retorna o nome da pessoa
create function PROJETO.nomePessoa(@nr int)
returns varchar(100)
as
begin
	declare @nome varchar(100);
	set @nome = (select p.Nome
	from PROJETO.Pessoa p
	where p.NrFederacao = @nr);
	return @nome;
end;
go

--drop function PROJETO.nomePessoa

--funcao que devolve uma string com nome do estadio e sua capacidade dado um clube
create function PROJETO.getEstadioInfo(@clube varchar(100))
returns varchar(300)
begin
	declare @info varchar(300);
	set @info = 
	concat(
	(select e.Nome from PROJETO.Estadio e, PROJETO.Clube c where c.Nome=@clube and c.Estadio = e.Nome) 
	, ' com capacidade para ' , 
	(select e.Capacidade from PROJETO.Estadio e, PROJETO.Clube c where c.Nome=@clube and c.Estadio=e.Nome)
	, ' espetadores');
	return @info;
end
go

--drop function PROJETO.getEstadioInfo;

-- Dado um ano, retorna o vencedor dessa epoca
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

-- Dado um nome, retorna o nr de federacao
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
					set @trainerType = 'Treinador de GuardaRedes';
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