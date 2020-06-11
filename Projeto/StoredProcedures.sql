
--Dado um clube devolve o Nome, Posicao e NrCamisola de todos os jogadores desse clube
create procedure PROJETO.GetEquipa @Clube varchar(100)
as
	select j.NrCamisola,j.Posicao,j.clube,p.Nome from
	PROJETO.Jogador j, PROJETO.Pessoa p
	where j.clube=@Clube and j.NrFederacao= p.NrFederacao
	order by j.Posicao;
go

--exec PROJETO.GetEquipa 'Sporting Clube de Fermentelos '
--drop procedure PROJETO.GetEquipa

--Dada uma posicao diz todos os jogadores que jogam nessa posicao e o seu clube
create procedure PROJETO.JogadoresPosicao @Posicao varchar (50)
as
	select p.Nome,Clube from
	PROJETO.Jogador j join PROJETO.Pessoa p on j.NrFederacao=p.NrFederacao, PROJETO.Clube c
	where j.Posicao=@Posicao and j.clube=c.Nome and j.NrFederacao=p.NrFederacao
	order by c.Nome;
go

--exec PROJETO.JogadoresPosicao 'Atacante'
--drop procedure PROJETO.JogadoresPosicao

--Dado o numero da jornada(1-35) retorna todos os jogos dessa jornada (clubes e resultado)
create procedure PROJETO.GetJornada @nr tinyint
as
	Select * from PROJETO.Jogo 
	where NrJornada=@nr
go

--exec PROJETO.GetJornada 1
--drop procedure PROJETO.GetJornada

--devolve os pontos de um clube
create procedure PROJETO.TCpontos @nome varchar(100)
as
	declare @pontos int = 0;
	select @pontos = c.Vitorias*3 + c.Empates
	from PROJETO.Clube c
	where c.Nome=@nome
	return @pontos
go

--exec PROJETO.TCpontos 'Calvao'
--drop procedure PROJETO.TCpontos

--devolve Golos Marcados, Golos sofridos
create procedure PROJETO.getGolos(@nome varchar(100))
as
	declare @gm int=0, @gs int=0, 
	@clube1 varchar(100), @clube2 varchar(100), @resultado1 int, @resultado2 int;
	declare @tempTable table (nome varchar(100),GM int, GS int);
	DECLARE c cursor FAST_FORWARD
	for select j.Clube1,j.Clube2,j.Resultado1,j.Resultado2
	from PROJETO.Jogo j
	where j.Resultado1 IS NOT NULL and j.Resultado2 IS NOT NULL
	open c;
	fetch c into @clube1, @clube2,@resultado1,@resultado2;
	begin try
	begin transaction
	WHILE @@FETCH_STATUS = 0
		begin

				if @nome = @clube1
					begin
						set @gm = @gm + @resultado1
						set @gs = @gs + @resultado2
					end
				else if @nome = @clube2
					begin
						set @gm = @gm + @resultado2
						set @gs = @gs + @resultado1
					end
			
			fetch c into  @clube1, @clube2,@resultado1,@resultado2;
				
		end
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close c;
	deallocate c;
	insert into @tempTable values(@nome,@gm,@gs);
	select * from @tempTable;
go
--exec PROJETO.getGolos 'ACRD Mosteiro';
drop procedure PROJETO.getGolos;
	


--Retorna a tabela de classficca��o
create procedure PROJETO.TabelaClass 
as
	declare @Pontos int =0;
	declare @Nome varchar(100), @Vitorias tinyint, @Derrotas tinyint,
	@Empates tinyint, @temp int =0;
	declare @tempTable table (nome varchar(100),pontos int, vitorias int, derrotas int, empates int);
	declare @golosTable table (nome varchar(100), gm int, gs int);
	declare @gm int=0, @gs int=0;
	DECLARE cur cursor FAST_FORWARD
	for select c.Nome, c.Vitorias,c.Derrotas,c.Empates
	from PROJETO.Clube c
	open cur;
	fetch cur into @nome,@vitorias,@derrotas,@empates;
	begin try
	begin transaction
		WHILE @@FETCH_STATUS = 0
			begin
				exec @temp = PROJETO.TCpontos @nome
				select @pontos =  @temp
				insert into @golosTable exec PROJETO.getGolos @nome;
				insert into @tempTable  values(@nome, @pontos , @vitorias , @derrotas , @empates);
				fetch cur into @nome,@vitorias,@derrotas,@empates;
			end;
			commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close cur;
	deallocate cur;
	select t.nome,t.pontos,t.vitorias,t.derrotas,t.empates,g.gm,g.gs from @tempTable t join @golosTable g on t.nome=g.nome
	order by pontos desc 
go

--exec PROJETO.TabelaClass
--drop procedure PROJETO.TabelaClass


--dado um id de equipa de arbitragem devolve um varchar com os nomes dos arbitros
create procedure PROJETO.EquipaArb @id tinyint
as
	declare @nomes varchar(400),@a int,@al1 int,@al2 int, @qa int;
	set @a = (select ea.ArbitroCampo from PROJETO.EquipaArbitragem ea where ea.ID = @id); 
	set @al1 = (select ea.ArbitroLinha1 from PROJETO.EquipaArbitragem ea where ea.ID = @id); 
	set @al2 = (select ea.ArbitroLinha2 from PROJETO.EquipaArbitragem ea where ea.ID = @id); 
	set @qa = (select ea.QuartoArbitro from PROJETO.EquipaArbitragem ea where ea.ID = @id); 
	set @nomes = concat(PROJETO.nomePessoa(@a),' , ', PROJETO.nomePessoa(@al1), ' , ', PROJETO.nomePessoa(@al2) , ' , ' , PROJETO.nomePessoa(@qa));
	return @nomes;
go

--exec PROJETO.EquipaArb 8;
--drop procedure PROJETO.EquipaArb;


--dado um numero de jogo devolve infos do jogo
create procedure PROJETO.infoJogo @nr int
as
	declare @c1 varchar(100), @c2 varchar(100),@r1 int, @r2 int,
	@nomes varchar(400),@estadio varchar(100),@espetadores int, @equipaArb tinyint,
	@a varchar(100), @al1 varchar(100),@al2 varchar(100),@qa varchar(100);
	declare @tempTable table (c1 varchar(100),c2 varchar(100),r1 int,r2 int, 
	a varchar(100),al1 varchar(100),al2 varchar(100),qa varchar(100), estadio varchar(100),espetadores int);
	set @c1 = (select j.Clube1 from PROJETO.Jogo j where j.NrJogo=@nr);
	set @c2 = (select j.Clube2 from PROJETO.Jogo j where j.NrJogo=@nr);
	set @r1 = (select j.Resultado1 from PROJETO.Jogo j where j.NrJogo=@nr);
	set @r2 = (select j.Resultado2 from PROJETO.Jogo j where j.NrJogo=@nr);
	set @estadio = (select j.Estadio from PROJETO.Jogo j where j.NrJogo=@nr);
	set @espetadores = (select j.NrEspetadores from PROJETO.Jogo j where j.NrJogo=@nr);
	set @equipaArb = (select j.EquipaArbitragem from PROJETO.Jogo j where j.NrJogo=@nr);
	set @a = PROJETO.nomePessoa((select ea.ArbitroCampo from PROJETO.EquipaArbitragem ea join PROJETO.Jogo j on ea.ID=j.EquipaArbitragem where j.NrJogo=@nr));
	set @al1 = PROJETO.nomePessoa((select ea.ArbitroLinha1 from PROJETO.EquipaArbitragem ea join PROJETO.Jogo j on ea.ID=j.EquipaArbitragem where j.NrJogo=@nr));
	set @al2 = PROJETO.nomePessoa((select ea.ArbitroLinha2 from PROJETO.EquipaArbitragem ea join PROJETO.Jogo j on ea.ID=j.EquipaArbitragem where j.NrJogo=@nr));
	set @qa = PROJETO.nomePessoa((select ea.QuartoArbitro from PROJETO.EquipaArbitragem ea join PROJETO.Jogo j on ea.ID=j.EquipaArbitragem where j.NrJogo=@nr));
	insert into @tempTable values (@c1,@c2,@r1,@r2,@a,@al1,@al2,@qa, @estadio,@espetadores);
	select * from @tempTable;
go

--exec PROJETO.infoJogo 1
--drop procedure PROJETO.infoJogo



create procedure PROJETO.getDirecao @clube varchar(100)
as
	declare @tempTable table(pres varchar(100),presAss varchar(100),admini varchar(100));
	declare @pres varchar(100),@presAss varchar(100),@admini varchar(100);
	set @pres = PROJETO.nomePessoa((select d.Presidente from PROJETO.Direcao d where d.nome_clube=@clube));
	set @presAss = PROJETO.nomePessoa((select d.PresAssGeral from PROJETO.Direcao d where d.nome_clube=@clube));
	set @admini = PROJETO.nomePessoa((select d.Administrador from PROJETO.Direcao d where d.nome_clube=@clube));

	insert into @tempTable values (@pres,@presAss,@admini)
	select * from @tempTable;
	
	
--drop procedure PROJETO.getDirecao
--exec PROJETO.getDirecao 'CRAC'

create procedure PROJETO.NomeTreinadores
as
	declare @tableTemp table(Nome varchar(100));
	declare @treinador int;
	DECLARE cur cursor FAST_FORWARD
	for select t.NrFederacao
	from PROJETO.TreinadorPrincipal t
	open cur;
	fetch cur into @treinador;
	begin try
	begin transaction
	WHILE @@FETCH_STATUS = 0
		begin
			declare @name varchar(100);
			set @name = (PROJETO.nomePessoa(@treinador));
			INSERT into @tableTemp values(@name);
			fetch cur into @treinador
		end;
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch
	close cur;
	deallocate cur;
	select * from @tableTemp order by Nome;
go
	
--exec PROJETO.NomeTreinadores
--drop procedure PROJETO.Nometreinadores



create procedure PROJETO.ReformarJogador @nome varchar(100), @clube varchar(100)
as
	declare @nrFed int;
	set @nrFed = PROJETO.GetNrFed(@nome);
	delete from PROJETO.Jogador where NrFederacao = @nrFed  and clube=@clube

--exec PROJETO.RemoveJogador 'Talia Lambot','Sporting Clube de Fermentelos '
--drop procedure PROJETO.RemoveJogador;

create procedure PROJETO.ReformarTreinador @nome varchar(100), @equipa varchar(100)
as
	declare @nrFed int,  @esp varchar(100);
	declare @tempTable table(Nome varchar(100),Esp varchar(100));
	set @nrFed = PROJETO.GetNrFed(@nome);
	insert into @tempTable exec PROJETO.GetTeamTrainer @equipa;
	set @esp = (select t.Esp from @tempTable t where t.Nome =@nome);
	begin try
	begin transaction
		if @esp = 'Treinador Principal'
			delete from PROJETO.TreinadorPrincipal where NrFederacao=@nrFed
		else if @esp = 'Treinador Adjunto'
			delete from PROJETO.TreinadorAdjunto WHERE NrFederacao=@nrFed
		else 
			delete from PROJETO.TreinadorGuardaRedes WHERE NrFederacao=@nrFed
		delete from PROJETO.Treinador where NrFederacao=@nrFed
		commit transaction
	end try
	begin catch
		rollback transaction
	end catch

	--drop procedure PROJETO.ReformarTreinador;

	--exec PROJETO.GetTeamTrainer 'ACRD Mosteiro'
	--exec PROJETO.ReformarTreinador 'Yuma Holdren','ACRD Mosteiro'




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
	select * from @tableTemp order by Nome;

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

	--exec PROJETO.GetTeamTrainer 'CRAC';
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
				WHERE j.Resultado1 IS NOT NULL and j.Resultado2 IS NOT NULL
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
--drop procedure PROJETO.Change_Trainer
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