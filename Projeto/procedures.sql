
--Dado um clube devolve o Nome, Posicao e NrCamisola de todos os jogadores desse clube
create procedure PROJETO.GetEquipa @Clube varchar(100)
as
	select j.NrCamisola,j.Posicao,j.clube,p.Nome from
	PROJETO.Jogador j, PROJETO.Pessoa p
	where j.clube=@Clube and j.NrFederacao= p.NrFederacao
	order by j.Posicao;

--exec PROJETO.GetEquipa 'UD Mourisquense'
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
	open c;
	fetch c into @clube1, @clube2,@resultado1,@resultado2;
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
	close c;
	deallocate c;
	insert into @tempTable values(@nome,@gm,@gs);
	select * from @tempTable;

--exec PROJETO.getGolos 'ACRD Mosteiro';
--drop procedure PROJETO.getGolos;
	


--Retorna a tabela de classficcação
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
	WHILE @@FETCH_STATUS = 0
		begin
			exec @temp = PROJETO.TCpontos @nome
			select @pontos =  @temp
			insert into @golosTable exec PROJETO.getGolos @nome;
			insert into @tempTable  values(@nome, @pontos , @vitorias , @derrotas , @empates);
			fetch cur into @nome,@vitorias,@derrotas,@empates;
		end;
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
create procedure PROJETO.infoJogo @nr tinyint
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



