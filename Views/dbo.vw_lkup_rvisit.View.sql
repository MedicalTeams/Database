USE [Clinic]
GO
/****** Object:  View [dbo].[vw_lkup_rvisit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_rvisit]'))
DROP VIEW [dbo].[vw_lkup_rvisit]
GO
/****** Object:  View [dbo].[vw_lkup_rvisit]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_rvisit]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_lkup_rvisit] as 
select rvisit_id, rvisit_descn, rvisit_ind, user_intrfc_sort_ord 
from lkup_rvisit;' 
GO
