USE [Clinic]
GO
/****** Object:  View [dbo].[vw_processed_data_errs]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_processed_data_errs]'))
DROP VIEW [dbo].[vw_processed_data_errs]
GO
/****** Object:  View [dbo].[vw_processed_data_errs]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_processed_data_errs]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_processed_data_errs] as
select tvtp.visit_uuid, tvtp.opd_id, tvtp.rec_creat_dt, tvtp.proc_stat, 
tvtp.err_cd, lu_e.exception_descn 
from tmp_visit_to_proc tvtp
left outer join lkup_exceptions lu_e
on tvtp.err_cd = lu_e.err_cd
where tvtp.err_cd < 0' 
GO
