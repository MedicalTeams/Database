USE [Clinic]
GO
/****** Object:  View [dbo].[vw_lkup_injury_mode_diag]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_injury_mode_diag]'))
DROP VIEW [dbo].[vw_lkup_injury_mode_diag]
GO
/****** Object:  View [dbo].[vw_lkup_injury_mode_diag]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_injury_mode_diag]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_lkup_injury_mode_diag] as 
select diag_id, splmtl_diag_id, splmtl_diag_descn, user_intrfc_sort_ord
from lkup_splmtl_diag
where splmtl_diag_stat = ''A''
and diag_id = 21;' 
GO
