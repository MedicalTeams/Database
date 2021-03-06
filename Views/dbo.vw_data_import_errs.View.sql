USE [Clinic]
GO
/****** Object:  View [dbo].[vw_data_import_errs]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_data_import_errs]'))
DROP VIEW [dbo].[vw_data_import_errs]
GO
/****** Object:  View [dbo].[vw_data_import_errs]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_data_import_errs]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_data_import_errs] as 
select visit_uuid, opd_id, rec_creat_dt,visit_stat, err_cd, exception_descn 
from vw_raw_data_errs
group by visit_uuid, opd_id, rec_creat_dt,visit_stat, err_cd, exception_descn ' 
GO
