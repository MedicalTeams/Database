USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp31_Consultation]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp31_Consultation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp31_Consultation]
GO
/****** Object:  StoredProcedure [dbo].[sp31_Consultation]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp31_Consultation]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
--3.1 Consultation  
--NewVisits and Revisits

CREATE PROC [dbo].[sp31_Consultation]
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
		X.Dt
		,X.setlmt
		,X.hlth_care_faclty
		,X.bnfcry
		,X.rvisit_descn
		,X.gndr_cd
		,COUNT(*) AS Visit_Count
		,X.Setlmt_Faclty

	FROM
		(SELECT CONVERT(varchar(10),OV.dt_of_visit,101) AS Dt
		,LFAC.setlmt
		,LFAC.hlth_care_faclty
		,RVST.rvisit_descn
		,BNFC.bnfcry
		,GNDR.gndr_cd
		,LFAC.setlmt+ '' '' + LFAC.hlth_care_faclty AS Setlmt_Faclty

	FROM
		dbo.ov AS OV
		JOIN dbo.lkup_rvisit AS RVST ON OV.rvisit_id = RVST.rvisit_id
		JOIN dbo.lkup_bnfcry AS BNFC ON BNFC.bnfcry_id = OV.bnfcry_id
		JOIN dbo.lkup_gndr AS GNDR ON GNDR.gndr_id = OV.gndr_id 
		JOIN dbo.lkup_faclty AS LFAC ON LFAC.faclty_id = OV.faclty_id

	WHERE
		1=1
		AND OV.dt_of_visit >= @Begin_Visit_Date AND OV.dt_of_visit <= @End_Date) AS X

	GROUP BY
		X.Dt
		,X.Setlmt
		,X.Setlmt_Faclty
		,X.hlth_care_faclty
		,X.bnfcry
		,X.rvisit_descn
		,X.gndr_cd

	ORDER BY
		X.Dt
		,X.Setlmt
		,X.Setlmt_Faclty
		,X.hlth_care_faclty
		,X.bnfcry
		,X.rvisit_descn
		,X.gndr_cd

END' 
END
GO
