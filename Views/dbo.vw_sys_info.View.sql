USE [Clinic]
GO
/****** Object:  View [dbo].[vw_sys_info]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_sys_info]'))
DROP VIEW [dbo].[vw_sys_info]
GO
/****** Object:  View [dbo].[vw_sys_info]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_sys_info]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_sys_info] as
select top 1 csi.itm_vrsn, csi.itm_descn, csi.dt_of_rlse 
from curr_sys_info csi
where csi.dt_of_rlse = (select max(dt_of_rlse) from curr_sys_info);' 
GO
