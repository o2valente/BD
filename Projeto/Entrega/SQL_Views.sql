USE [p2g4]
GO

/****** Object:  View [PROJETO].[getIDea]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [PROJETO].[getIDea]
as
	select ea.ID from PROJETO.EquipaArbitragem ea;
GO

/****** Object:  View [PROJETO].[getNomeEstadio]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [PROJETO].[getNomeEstadio]
as
	select e.Nome from PROJETO.Estadio e;
GO

/****** Object:  View [PROJETO].[getNrJornada]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [PROJETO].[getNrJornada]
as
	select j.NrJornada from PROJETO.Jornada j;
GO

/****** Object:  View [PROJETO].[getNomesClube]    Script Date: 12/06/2020 17:32:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [PROJETO].[getNomesClube]
as
	select C.Nome from PROJETO.Clube C;
GO