USE [Clinic]
GO
/****** Object:  View [dbo].[vw_diag_alert]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_diag_alert]'))
DROP VIEW [dbo].[vw_diag_alert]
GO
/****** Object:  View [dbo].[vw_diag_alert]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_diag_alert]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_diag_alert] as
select diag_alert_thrshld_id, diag_id, case_cnt, baseln_multr 
from diag_alert_thrshld' 
GO
