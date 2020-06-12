USE [p2g4]
GO
/****** Object:  UserDefinedFunction [PROJETO].[getEstadioInfo]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [PROJETO].[getEstadioInfo](@clube varchar(100))
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
GO
/****** Object:  UserDefinedFunction [PROJETO].[GetNrFed]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [PROJETO].[GetNrFed](@name varchar(100))
returns int
as
begin
	declare @number int;
	set @number = (select p.NrFederacao
	from PROJETO.Pessoa p
	where p.Nome = @name);
	return @number;
end;
GO
/****** Object:  UserDefinedFunction [PROJETO].[GetNumJornada]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create function [PROJETO].[GetNumJornada](@week tinyint,@year smallint)
returns int
as
begin
	declare @number int;
	set @number = (select j.NrJornada
	from PROJETO.Jornada j
	where j.Semana = @week and j.Ano = @year);
	return @number;
end;
GO
/****** Object:  UserDefinedFunction [PROJETO].[GetTrainerType]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [PROJETO].[GetTrainerType](@nrFed int)
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
GO
/****** Object:  UserDefinedFunction [PROJETO].[GetWinner]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [PROJETO].[GetWinner](@year smallint)
returns varchar(100)
as
begin
	declare @nome varchar(100);
	set @nome = (select v.ClubeVencedor
	from PROJETO.Vence v
	where v.AnoEpoca = @year);
	return @nome;
end;
GO
/****** Object:  UserDefinedFunction [PROJETO].[nomePessoa]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create function [PROJETO].[nomePessoa](@nr int)
returns varchar(100)
as
begin
	declare @nome varchar(100);
	set @nome = (select p.Nome
	from PROJETO.Pessoa p
	where p.NrFederacao = @nr);
	return @nome;
end;
GO