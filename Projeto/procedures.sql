
--Dado um clube devolve o Nome, Posicao e NrCamisola de todos os jogadores desse clube
create procedure PROJETO.GetEquipa @Clube varchar(100)
as
	select j.NrCamisola,j.Posicao,j.clube,p.Nome from
	PROJETO.Jogador j, PROJETO.Pessoa p
	where j.clube=@Clube and j.NrFederacao= p.NrFederacao
	order by j.Posicao;

--exec PROJETO.GetEquipa 'Sporting Clube de Fermentelos '
--drop procedure PROJETO.GetEquipa

--Dada uma posicao diz todos os jogadores que jogam nessa posicao e o seu clube
create procedure PROJETO.JogadoresPosicao @Posicao varchar (50)
as
	select p.Nome,Clube from
	PROJETO.Jogador j join PROJETO.Pessoa p on j.NrFederacao=p.NrFederacao, PROJETO.Clube c
	where j.Posicao=@Posicao and j.clube=c.Nome and j.NrFederacao=p.NrFederacao
	order by c.Nome;

--exec PROJETO.JogadoresPosicao 'Atacante'
--drop procedure PROJETO.JogadoresPosicao

--Dado o numero da jornada(1-35) retorna todos os jogos dessa jornada (clubes e resultado)
create procedure PROJETO.GetJornada @nr tinyint
as
	Select * from PROJETO.Jogo 
	where NrJornada=@nr

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
	where j.Resultado1 != NULL or j.Resultado2 != NULL
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

--exec PROJETO.getGolos 'ACRD Mosteiro';
--drop procedure PROJETO.getGolos;
	


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


--exec PROJETO.TabelaClass
--drop procedure PROJETO.TabelaClass

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

--drop function PROJETO.nomePessoa


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

--exec PROJETO.infoJogo 1
--drop procedure PROJETO.infoJogo

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

--drop function PROJETO.getEstadioInfo;

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

	
--exec PROJETO.NomeTreinadores
--drop procedure PROJETO.Nometreinadores


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
	if @esp = 'Treinador Principal'
		delete from PROJETO.TreinadorPrincipal where NrFederacao=@nrFed
	else if @esp = 'Treinador Adjunto'
		delete from PROJETO.TreinadorAdjunto WHERE NrFederacao=@nrFed
	else 
		delete from PROJETO.TreinadorGuardaRedes WHERE NrFederacao=@nrFed
	delete from PROJETO.Treinador where NrFederacao=@nrFed
	

	--drop procedure PROJETO.ReformarTreinador;

	exec PROJETO.GetTeamTrainer 'ACRD Mosteiro'
	exec PROJETO.ReformarTreinador 'Yuma Holdren','ACRD Mosteiro'
