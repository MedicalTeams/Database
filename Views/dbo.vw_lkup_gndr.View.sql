USE [Clinic]
GO
/****** Object:  View [dbo].[vw_lkup_gndr]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_gndr]'))
DROP VIEW [dbo].[vw_lkup_gndr]
GO
/****** Object:  View [dbo].[vw_lkup_gndr]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_gndr]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_lkup_gndr] as
select gndr_id, gndr_descn, gndr_cd
from lkup_gndr;' 
GO
