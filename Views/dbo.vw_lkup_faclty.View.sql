USE [Clinic]
GO
/****** Object:  View [dbo].[vw_lkup_faclty]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_faclty]'))
DROP VIEW [dbo].[vw_lkup_faclty]
GO
/****** Object:  View [dbo].[vw_lkup_faclty]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_lkup_faclty]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_lkup_faclty] as
select faclty_id, hlth_care_faclty, setlmt, cntry, rgn, user_intrfc_sort_ord
from lkup_faclty
where faclty_stat = ''A'';' 
GO
