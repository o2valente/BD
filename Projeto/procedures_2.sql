
-- Dado um ano, retorna o vencedor dessa �poca

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



-- Dado um nome, retorna o nr de federa�ao

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

create procedure PROJETO.ManagerHistory @nrFed int
as
	declare @tempTable table (Nome varchar(100),Clube varchar(100), dataSub date);
	declare @name varchar(100) = (Select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @nrFed);
	declare @club varchar(100) = (Select t.ClubeTreinado from PROJETO.Treinador t where t.NrFederacao = @nrFed);
	declare @dataSub date;
	insert into @tempTable values(@name,@club,@dataSub);
	declare @entra varchar(100),@sai varchar(100), @clube varchar(100), @data date
	set @data =  convert (date,@data)
	DECLARE cur cursor FAST_FORWARD
	for select s.TreinadorEntra,s.TreinadorSai,s.Clube,s.DataSubstituicao
	from PROJETO.TreinadorSubstitui s
	open cur;
	fetch cur into @entra,@sai,@clube,@data;
	begin try 
	begin transaction
	WHILE @@FETCH_STATUS = 0
		begin
			if  @nrFed = @entra
				begin
					insert into @tempTable  values(@name, @clube,@data);
				end
			else if  @nrFed = @sai
				begin
					insert into @tempTable  values(@name, @clube,@data);
				end
			fetch cur into @entra,@sai,@clube,@data;
		end;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close cur;
	deallocate cur;
	SELECT * from @tempTable
GO

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
	begin try
	begin transaction
	WHILE @@FETCH_STATUS = 0
		begin
			declare @name varchar(100),@clube varchar(100),@type varchar(100);

			set @name = (select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @treinador);
			set @clube = (select t.ClubeTreinado from PROJETO.Treinador t join PROJETO.Pessoa p on t.NrFederacao=p.NrFederacao where p.NrFederacao = @treinador);
			set @type = (select PROJETO.GetTrainerType(@treinador))
			INSERT into @tableTemp values(@name,@clube,@type);
			fetch cur into @treinador
		end;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close cur;
	deallocate cur;
	select * from @tableTemp;

	--drop procedure PROJETO.GetTreinadores



-- Retorna um clube, ao dar o nome ---

create procedure PROJETO.GetClub @name varchar(100)
as
	select c.Nome,c.Vitorias,c.Derrotas,c.Empates,c.Estadio
	from PROJETO.Clube c
	where c.Nome = @name

create procedure PROJETO.GetTeamTrainer @equipa varchar(100)
as
	declare @tableTemp table(Nome varchar(100), Especializacao varchar(100));
	declare @treinador int,@clubeT varchar(100);

	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao,t.ClubeTreinado
	from PROJETO.Treinador t
	open cur;
	fetch cur into @treinador,@clubeT;
	begin try
	begin transaction
	WHILE @@FETCH_STATUS = 0
		begin
			if @clubeT = @equipa
				begin
					declare @name varchar(100),@type varchar(100);
					set @name = (select p.Nome from PROJETO.Pessoa p where p.NrFederacao = @treinador);
					set @type = (select PROJETO.GetTrainerType(@treinador))
					INSERT into @tableTemp values(@name,@type);
				end
			fetch cur into @treinador,@clubeT
		end;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close cur;
	deallocate cur;
	select * from @tableTemp;

	--drop procedure PROJETO.GetTeamTrainer

---- Troca 1 treinador de uma equipa, por outro treinador
create procedure PROJETO.Change_Trainer @equipa varchar (100),@new_trainer varchar(100), @old_trainer varchar(100)
as
	declare @newT int,@oldT int,@sub_id int;
	set @newT = PROJETO.GetNrFed(@new_trainer);
	set @oldT = PROJETO.GetNrFed(@old_trainer);
	set @sub_id = (SELECT TOP 1 s.id FROM PROJETO.TreinadorSubstitui s ORDER BY s.id DESC) + 1;

	begin try
	begin transaction
		INSERT INTO PROJETO.TreinadorSubstitui
		VALUES(@sub_id,@newT,@oldT,@equipa,GETDATE())

		UPDATE PROJETO.Treinador
		SET ClubeTreinado = NULL
		WHERE NrFederacao = @oldT

		UPDATE PROJETO.Treinador
		SET ClubeTreinado = @equipa
		WHERE NrFederacao = @newT

		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
GO

--drop procedure PROJETO.Change_Trainer

-- Adiciona um jogador a uma equipa
create procedure PROJETO.AddPlayer @nome varchar (100),@camisola tinyint, @posicao varchar(50),@equipa varchar(100)
as
	declare @nr_fed int;
	begin try
	begin transaction
		set @nr_fed = (SELECT TOP 1 s.NrFederacao FROM PROJETO.Pessoa s ORDER BY s.NrFederacao DESC) + 1
		INSERT INTO PROJETO.Pessoa
		VALUES (@nr_fed,@nome)

		INSERT INTO PROJETO.Jogador
		VALUES (@nr_fed,@camisola,@posicao,@equipa)

		commit transaction
	end try
	begin catch
		rollback transaction
	end catch	
GO

create procedure PROJETO.AddGame @espetadores int, @estadio varchar(100),@jornada tinyint,@arbitragem tinyint,@clube1 varchar(100),@clube2 varchar(100),@res1 int,@res2 int
as
	declare @new_nr int;
	begin try
	begin transaction
		set @new_nr = (SELECT TOP 1 j.NrJogo from PROJETO.Jogo j ORDER BY j.NrJogo DESC) + 1
		INSERT INTO PROJETO.Jogo
		VALUES (@new_nr,@espetadores,@estadio,@jornada,@arbitragem,@clube1,@clube2,@res1,@res2)

		commit transaction
	end try
	begin catch
		rollback transaction
	end catch	
GO

create procedure PROJETO.FillGame @nr int,@espetadores int,@arbitragem tinyint,@res1 int,@res2 int
as
	declare @new_nr int;
	begin try
	begin transaction

		UPDATE PROJETO.Jogo
		SET NrEspetadores = @espetadores, EquipaArbitragem = @arbitragem, Resultado1 = @res1, Resultado2 = @res2
		WHERE NrJogo = @nr

		commit transaction
	end try
	begin catch
		rollback transaction
	end catch	
GO

create procedure PROJETO.GetTrainerName @equipa varchar(100)
as
	declare @tableTemp table(Nome varchar(100), Especializacao varchar(100));
	declare @treinador int,@clubeT varchar(100);
	set @tableTemp = (select * from PROJETO.GetTreinadores);


-------------------------- Adicionar um treinador à BD ------------------------
create procedure PROJETO.AddTrainer @equipa varchar (100),@nome varchar(100),@especializacao varchar(100),@tatica_pref varchar(100)
as
	declare @new_nr int
	set @new_nr = (SELECT TOP 1 p.NrFederacao FROM PROJETO.Pessoa p ORDER BY p.NrFederacao DESC) + 1;

	begin try
	begin transaction
		INSERT INTO PROJETO.Pessoa
		VALUES(@new_nr,@nome)

		INSERT INTO PROJETO.Treinador
		VALUES(@new_nr,@equipa)

		if @especializacao = 'Principal'
			begin
				INSERT INTO PROJETO.TreinadorPrincipal
				VALUES(@new_nr,@tatica_pref)
			end
		else if @especializacao = 'Adjunto'
			begin
				INSERT INTO PROJETO.TreinadorAdjunto
				VALUES(@new_nr)
			end
		else
			begin
				INSERT INTO PROJETO.TreinadorGuardaRedes
				VALUES(@new_nr)
			end
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
GO

----------- Updates Victories, Draws and Losses based on games ------------------------
create procedure PROJETO.GetStats
as	
	-------------------------- Percorre todos os clubes----------
	declare @c_name varchar(100);
	DECLARE c cursor FAST_FORWARD
		for select cl.Nome
		from PROJETO.Clube cl
		open c;
		fetch c into @c_name;
		begin try
		begin transaction
		WHILE @@FETCH_STATUS = 0
			begin
	------------------------ Percorre todos os jogos ----------------------------
				declare @wins int = 0, @draws int = 0, @loses int = 0, @clube1 varchar(100), @clube2 varchar(100), @resultado1 int, @resultado2 int;
				DECLARE c_2 cursor FAST_FORWARD
				for select j.Clube1,j.Clube2,j.Resultado1,j.Resultado2
				from PROJETO.Jogo j
				open c_2;
				fetch c_2 into @clube1, @clube2,@resultado1,@resultado2;
				begin try
				begin transaction
				WHILE @@FETCH_STATUS = 0
					begin

							if @c_name = @clube1
								begin
									if @resultado1 > @resultado2
										begin
											set @wins = @wins + 1;
										end
									else if @resultado1 = @resultado2
										begin
											set @draws = @draws + 1;
										end
									else
										begin
											set @loses = @loses + 1;
										end
								end
							else if @c_name = @clube2
								begin
									if @resultado1 < @resultado2
											begin
												set @wins = @wins + 1;
											end
										else if @resultado1 = @resultado2
											begin
												set @draws = @draws + 1;
											end
										else
											begin
												set @loses = @loses + 1;
											end
								end
						fetch c_2 into  @clube1, @clube2,@resultado1,@resultado2;
					end
					commit transaction
				end try
				begin catch
					rollback transaction
				end catch

				close c_2;
				deallocate c_2;

				UPDATE PROJETO.Clube
				SET Vitorias = @wins, Empates = @draws, Derrotas = @loses
				WHERE Nome = @c_name 
	------------------------------------  Fim dos jogos -------------------------------------------
			fetch c into  @c_name;
		end
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close c;
	deallocate c;
	--------------------------------------- Fim dos clubes --------------------------------------
go

exec PROJETO.GetStats
drop procedure PROJETO.GetStats
select j.Clube1,j.Resultado1, j.Clube2, j.Resultado2 from PROJETO.Jogo j where j.Clube1 = 'Argoncilhe' or j.Clube2 = 'Argoncilhe'

DELETE FROM
PROJETO.Jogo
WHERE Clube1 = Clube2
--drop procedure PROJETO.AddGame
--drop procedure PROJETO.FillGame
--drop procedure PROJETO.AddPlayer
----drop procedure PROJETO.Change_Trainer
--drop procedure PROJETO.GetTeamTrainer
--drop procedure PROJETO.TeamTitles
--drop procedure PROJETO.GetClub
--drop procedure PROJETO.getGolos
--drop procedure PROJETO.getDirecao
--drop procedure PROJETO.GetJornada
--drop procedure PROJETO.GetEquipa
--drop procedure PROJETO.GetTreinadores
--drop procedure PROJETO.infoJogo
--drop procedure PROJETO.ManagerHistory
--drop procedure PROJETO.TabelaClass
--drop procedure PROJETO.TCpontos