USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[spVisit_Details]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spVisit_Details]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[spVisit_Details]
GO
/****** Object:  StoredProcedure [dbo].[spVisit_Details]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[spVisit_Details]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

--Visit Details (aka HIS QA)

CREATE PROC [dbo].[spVisit_Details]
	
	(
		@Begin_Visit_Date AS DATE
		,@End_Date AS DATE
		,@STAFF_MBR AS NVARCHAR(MAX)
		,@OPD_ID AS VARCHAR (255)
	)
	
AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

	SELECT
	o.staff_mbr_name
	,CAST(o.opd_id AS VARCHAR) opd_id
	,o.age_years_low
	,o.dt_of_visit
	,r.rvisit_descn
	,g.gndr_descn
	,b.bnfcry
	,f.hlth_care_faclty
	,f.setlmt
	,f.setlmt+ '' '' + f.hlth_care_faclty AS ''Settlement and Facility''
	,o.rec_creat_dt
	,d.diag_descn
	,ds.splmtl_diag_descn
	,dc.splmtl_diag_cat
	,od.oth_diag_descn
	,od.oth_splmtl_diag_descn

FROM
	dbo.ov AS o 
	JOIN dbo.ov_diag AS od ON o.ov_id = od.ov_id
	JOIN dbo.lkup_diag AS d ON od.diag_id = d.diag_id
	JOIN dbo.lkup_gndr AS g ON o.gndr_id = g.gndr_id
	JOIN dbo.lkup_rvisit AS r ON o.rvisit_id = r.rvisit_id
	JOIN dbo.lkup_bnfcry AS b ON o.bnfcry_id = b.bnfcry_id
	JOIN dbo.lkup_faclty AS f ON o.faclty_id = f.faclty_id
	LEFT OUTER JOIN lkup_splmtl_diag AS ds ON od.splmtl_diag_id = ds.splmtl_diag_id
	LEFT OUTER JOIN lkup_splmtl_diag_cat AS dc ON od.splmtl_diag_cat_id = dc.splmtl_diag_cat_id

WHERE
	1=1 
	AND (o.staff_mbr_name IN (SELECT Value FROM fnSplit(@STAFF_MBR, '','')))
	AND (CAST(o.opd_id AS VARCHAR) IN (@OPD_ID) OR (''ALL'' IN (@OPD_ID)))
	AND o.dt_of_visit >= @Begin_Visit_Date AND o.dt_of_visit <= @End_Date
	
END
' 
END
GO
