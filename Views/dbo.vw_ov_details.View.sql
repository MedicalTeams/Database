USE [Clinic]
GO
/****** Object:  View [dbo].[vw_ov_details]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ov_details]'))
DROP VIEW [dbo].[vw_ov_details]
GO
/****** Object:  View [dbo].[vw_ov_details]    Script Date: 9/21/2016 2:52:31 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_ov_details]'))
EXEC dbo.sp_executesql @statement = N'create view [dbo].[vw_ov_details] as
select ov.ov_id, ov.opd_id, ov.dt_of_visit, l_rvisit.rvisit_descn, l_fac.hlth_care_faclty, 
l_bnf.bnfcry, l_gnd.gndr_descn, ov.infnt_age_mos as ''age in years'', ov.faclty_hw_invtry_id, 
l_f_hw.mac_addr, l_f_hw.aplctn_vrsn, ov.staff_mbr_name, ov.rec_creat_dt 
from ov
left outer join lkup_faclty l_fac
on ov.faclty_id = l_fac.faclty_id
left outer join lkup_bnfcry l_bnf
on ov.bnfcry_id = l_bnf.bnfcry_id
left outer join lkup_gndr l_gnd
on ov.gndr_id = l_gnd.gndr_id
left outer join faclty_hw_invtry l_f_hw
on ov.faclty_hw_invtry_id = l_f_hw.faclty_hw_invtry_id
left outer join lkup_rvisit l_rvisit
on ov.rvisit_id = l_rvisit.rvisit_id' 
GO
