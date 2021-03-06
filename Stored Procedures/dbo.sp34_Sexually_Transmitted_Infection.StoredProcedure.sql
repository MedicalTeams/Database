USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp34_Sexually_Transmitted_Infection]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp34_Sexually_Transmitted_Infection]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp34_Sexually_Transmitted_Infection]
GO
/****** Object:  StoredProcedure [dbo].[sp34_Sexually_Transmitted_Infection]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp34_Sexually_Transmitted_Infection]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'

--3..4 Sexually Transmitted Infection (STI)  
--NewVisits and Revisits

CREATE PROC [dbo].[sp34_Sexually_Transmitted_Infection]
	(
		@Begin_Visit_Date AS DATETIME2
		,@End_Date AS DATETIME2
		,@Facility AS VARCHAR(50)
		,@Visit AS VARCHAR (10)
	)
	
AS

BEGIN

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET NOCOUNT ON;
SET @End_Date = CAST(@End_Date AS DATE) 
SET @End_Date= DATEADD(ns, -100, DATEADD(s, 86400, @End_Date))

	SELECT
		Z.Dt
		,Z.setlmt
		,Z.hlth_care_faclty
		,Z.Setlmt_Faclty
		,Z.rvisit_descn
		,Z.STI_Category
		,Z.bnfcry
		,SUBSTRING(Z.gndr_cd, 1, 1) gndr_cd
		,Z.age_range
		,Z.Age_Sort
		,SUM(STI_Count) AS STI_Count
		,SUM(cntct_trmnt_cnt) AS STI_Contact_Trmnt_Count

	FROM
		(SELECT
			X.ov_id
			,X.Dt
			,X.setlmt
			,X.hlth_care_faclty
			,X.setlmt + '' '' + X.hlth_care_faclty AS Setlmt_Faclty
			,X.rvisit_descn
			,X.STI_Category
			,X.bnfcry
			,X.gndr_cd
			,X.age_range
			,X.Age_Sort
			,COUNT(*) AS STI_Count
			,MAX(X.cntct_trmnt_cnt) AS cntct_trmnt_cnt

	FROM 
		(SELECT OV.ov_id
		,CONVERT(varchar(10),OV.dt_of_visit,101) AS Dt
		,LFAC.setlmt
		,LFAC.hlth_care_faclty
		,LFAC.setlmt+ '' '' + LFAC.hlth_care_faclty AS Setlmt_Faclty
		,RVST.rvisit_descn
		,LKDX.diag_descn
		,BNFC.bnfcry
		,GNDR.gndr_cd
		,DIAG.cntct_trmnt_cnt
	
	,CASE 
		WHEN DIAG.oth_splmtl_diag_descn IS NOT NULL THEN ''Other'' + '' '' + DIAG.oth_splmtl_diag_descn
		ELSE SPDX.splmtl_diag_descn
	END AS STI_Category
	
	,CASE
		WHEN OV.age_years_low <18.0000 THEN ''<18''
		WHEN OV.age_years_low >= 18.0000 THEN ''>18''
	END AS age_range
	
	,CASE
		WHEN OV.age_years_low <18.0000 THEN 1
		WHEN OV.age_years_low >= 18.0000 THEN 2   
	END AS Age_Sort

	FROM
		dbo.ov AS OV
		JOIN dbo.ov_diag AS DIAG ON OV.ov_id = DIAG.ov_id
		JOIN dbo.lkup_diag AS LKDX ON DIAG.diag_id = LKDX.diag_id
		LEFT OUTER JOIN lkup_splmtl_diag AS SPDX ON DIAG.splmtl_diag_id = SPDX.splmtl_diag_id
		JOIN dbo.lkup_rvisit AS RVST ON OV.rvisit_id = RVST.rvisit_id
		JOIN dbo.lkup_bnfcry AS BNFC ON BNFC.bnfcry_id = OV.bnfcry_id
		JOIN dbo.lkup_gndr AS GNDR ON GNDR.gndr_id = OV.gndr_id
		JOIN dbo.lkup_faclty AS LFAC ON LFAC.faclty_id = OV.faclty_id

	where
		1=1
		AND OV.dt_of_visit >= @Begin_Visit_Date AND OV.dt_of_visit <= @End_Date
		AND LKDX.diag_id = 16 --STI (non-HIV/AIDS)
		--and RVST.rvisit_descn in (@Visit)
		--and LFAC.setlmt+ '' '' + LFAC.hlth_care_faclty in (@Facility) 
	) AS X

	GROUP BY
		X.ov_id
		,X.Dt
		,X.setlmt
		,X.hlth_care_faclty
		,X.rvisit_descn
		,X.STI_Category
		,X.bnfcry
		,X.gndr_cd
		,X.age_range
		,X.Age_Sort
	) AS Z

	GROUP BY
		Z.Dt
		,Z.setlmt
		,Z.hlth_care_faclty
		,Z.Setlmt_Faclty
		,Z.rvisit_descn
		,Z.STI_Category
		,Z.bnfcry
		,Z.gndr_cd
		,Z.age_range
		,Z.Age_Sort

	ORDER BY 1, 2, 3, 4, 5, 6, 7 DESC, 8 DESC, 9, 10, 11

END
' 
END
GO
