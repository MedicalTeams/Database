USE [Clinic]
GO
/****** Object:  View [dbo].[vw_raw_data_errs]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_raw_data_errs]'))
DROP VIEW [dbo].[vw_raw_data_errs]
GO
/****** Object:  View [dbo].[vw_raw_data_errs]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_raw_data_errs]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_raw_data_errs] as
select rv.visit_uuid, rv.visit_json, tvtp.opd_id, rv.rec_creat_dt, rv.visit_stat, 
rv.err_cd, lu_e.exception_descn 
from raw_visit rv
left outer join lkup_exceptions lu_e
on rv.err_cd = lu_e.err_cd
left outer join tmp_visit_to_proc tvtp
on rv.visit_uuid = tvtp.visit_uuid
where rv.err_cd < 0' 
GO
