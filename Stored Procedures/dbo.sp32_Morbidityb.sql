USE [Clinic]
GO

/****** Object:  StoredProcedure [dbo].[sp32_Morbidityb]    Script Date: 12/12/2016 2:28:01 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROC [dbo].[sp32_Morbidityb]
       (
             @Begin_Visit_Date AS DATETIME2
             ,@End_Date AS DATETIME2
             ,@Facility AS VARCHAR(MAX)
             ,@Visit AS VARCHAR (50)
             
             )
       
AS

BEGIN

DECLARE @CurrentRow AS INT
DECLARE @QueryRowCount AS INT

SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SET @End_Date = CAST(@End_Date AS DATE)  
SET @End_Date= DATEADD(ns, -100, DATEADD(s, 86400, @End_Date))
SET @CurrentRow = 0
SET @QueryRowCount = 0

SET NOCOUNT ON

DECLARE @Temp TABLE
       (SortId INT
	   ,DiagnosisId  INT
       ,Diagnosis VARCHAR(100)
       --,Sup_DiagnosisId  INT
       --,Sup_Diagnosis  VARCHAR(100)
       ,MaleRefugeeUnderFive INT
       ,FemaleRefugeeUnderFive INT
       ,MaleRefugeeFiveOrOver INT
       ,FemaleRefugeeFiveOrOver INT
       ,MaleNationalUnderFive INT
       ,FemaleNationalUnderFive INT
       ,MaleNationalFiveOrOver INT
       ,FemaleNationalFiveOrOver INT)

INSERT INTO @Temp 
       (SortId,
	   DiagnosisId
       ,Diagnosis
       --,Sup_DiagnosisId
       --,Sup_Diagnosis
       ,MaleRefugeeUnderFive
       ,FemaleRefugeeUnderFive
       ,MaleRefugeeFiveOrOver
       ,FemaleRefugeeFiveOrOver
       ,MaleNationalUnderFive
       ,FemaleNationalUnderFive
       ,MaleNationalFiveOrOver
       ,FemaleNationalFiveOrOver)

SELECT
       diag.user_intrfc_sort_ord
	   ,diag.diag_id
	   ,diag_descn
      -- ,IsNull(supDiag.[splmtl_diag_id],0)
      -- ,Isnull(supDiag.[splmtl_diag_descn],' ')
	  ,0,0,0,0,0,0,0,0

FROM
       [dbo].[lkup_diag] AS diag 
       --LEFT JOIN [dbo].[lkup_splmtl_diag] AS supDiag ON diag.diag_id = supDiag.diag_id


DECLARE @QueryTable TABLE
       (RowId Int IDENTITY(1,1)   
       ,VisitId INT
       ,DiagnosisId INT
       ,Sup_DiagnosisId INT
       ,AgeYearsLow DECIMAL(10,4)
       ,FacilityId INT
       ,GenderId INT
       ,BeneficiaryId INT
       ,Revisitid INT)

INSERT INTO @QueryTable

SELECT
       ov.ov_id,od.diag_id
       ,isnull(od.splmtl_diag_id,0)
       ,ov.age_years_low,ov.faclty_id
       ,ov.gndr_id,ov.bnfcry_id
       ,ov.rvisit_id --,*

FROM
       [dbo].[ov_diag] AS od  
       INNER JOIN [dbo].[ov] ov ON od.ov_id = ov.ov_id
       JOIN [dbo].[lkup_faclty] lfac ON ov.faclty_id = lfac.faclty_id
       JOIN [dbo].[lkup_rvisit] rvst ON ov.rvisit_id = rvst.rvisit_id

WHERE 
       1=1
       AND OV.dt_of_visit >= @Begin_Visit_Date AND OV.dt_of_visit <= @End_Date 
       AND OV.rvisit_id = 1 --New Visit
       AND LFAC.setlmt + ' ' + LFAC.hlth_care_faclty IN (SELECT Value FROM fnSplit (@Facility, ','))
       AND RVST.rvisit_descn IN (SELECT Value FROM fnSplit (@Visit, ','))

       
--Enumerate query table


SET @CurrentRow = (SELECT TOP 1(RowId) FROM @QueryTable)
SET @QueryRowCount = (SELECT COUNT(*) FROM @QueryTable)

IF @QueryRowCount > 0
       WHILE @CurrentRow <= (SELECT MAX(RowId) FROM @QueryTable)

BEGIN

--Create Temp VARS

DECLARE @CurrentDiagId INT
DECLARE @CurrentSupDiagId INT
DECLARE @CurrentAge DECIMAL(10,4)
DECLARE @CurrentFaciiltyId INT
DECLARE @CurrentGenderId INT
DECLARE @CurrentBeneficiaryId INT
DECLARE @RevisitId INT

--Get current record from query table 

SET @CurrentDiagId = (SELECT DiagnosisId FROM @QueryTable WHERE RowId = @CurrentRow)
SET @CurrentSupDiagId = (SELECT Sup_DiagnosisId FROM @QueryTable WHERE RowId = @CurrentRow)
SET @CurrentAge = (SELECT AgeYearsLow FROM @QueryTable WHERE RowId = @CurrentRow)
SET    @CurrentFaciiltyId = (SELECT FacilityId FROM @QueryTable WHERE RowId = @CurrentRow)
SET    @CurrentGenderId = (SELECT GenderId FROM @QueryTable WHERE RowId = @CurrentRow)
SET    @CurrentBeneficiaryId = (SELECT BeneficiaryId FROM @QueryTable WHERE RowId = @CurrentRow)
SET    @RevisitId = (SELECT Revisitid FROM @QueryTable WHERE RowId = @CurrentRow)

--PRINT 'Current Visit' +CONVERT(VARCHAR(10),@CurrentRow)
--PRINT 'Current Diag ID ' +CONVERT(VARCHAR(10),@CurrentDiagId )
--PRINT 'Current Sup Diag ID ' +CONVERT(VARCHAR(10),@CurrentSupDiagId )
--PRINT 'Current Age ' +CONVERT(VARCHAR(10),@CurrentAge) 
--PRINT 'Current Facility ' +CONVERT(VARCHAR(10),@CurrentFaciiltyId)
--PRINT 'Current Gender ' +CONVERT(VARCHAR(10),@CurrentGenderId)
--PRINT 'Current Beneficiary ' +CONVERT(VARCHAR(10),@CurrentBeneficiaryId)
--PRINT 'Current Revisit ' +CONVERT(VARCHAR(10),@RevisitId) 

IF(@CurrentAge < 5.00 AND @CurrentGenderId =1 AND @CurrentBeneficiaryId= 1)
       BEGIN
             --PRINT 'Male National Under Five'
             UPDATE @Temp
             SET MaleNationalUnderFive = (SELECT MaleNationalUnderFive FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END
ELSE
       
IF(@CurrentAge < 5.00 AND @CurrentGenderId =1 AND @CurrentBeneficiaryId= 2)
       BEGIN
             UPDATE @Temp
             SET MaleRefugeeUnderFive = (SELECT MaleRefugeeUnderFive FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END

IF(@CurrentAge >= 5.00 AND @CurrentGenderId = 1 AND @CurrentBeneficiaryId = 1)
       BEGIN
             --PRINT 'Male National Over Five'
             UPDATE @Temp
             SET MaleNationalFiveOrOver = (SELECT MaleNationalFiveOrOver FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END
ELSE

IF(@CurrentAge >= 5.00 AND @CurrentGenderId =1 AND @CurrentBeneficiaryId = 2)
       BEGIN
             --PRINT 'Male Refugee Over Five'
             UPDATE @Temp
             SET MaleRefugeeFiveOrOver = (SELECT MaleRefugeeFiveOrOver FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END

----- Female

IF(@CurrentAge < 5.00 AND @CurrentGenderId = 2 AND @CurrentBeneficiaryId = 1)
       BEGIN
             --PRINT 'Female National Under Five'
             UPDATE @Temp
             SET FemaleNationalUnderFive = (SELECT FemaleNationalUnderFive FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END
ELSE
       
IF(@CurrentAge < 5.00 AND @CurrentGenderId = 2 AND @CurrentBeneficiaryId = 2)
       BEGIN
       --PRINT 'Female Refugee Under Five'
             UPDATE @Temp
             SET FemaleRefugeeUnderFive = (SELECT FemaleRefugeeUnderFive FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END
       
IF(@CurrentAge >= 5.00 AND @CurrentGenderId = 2 AND @CurrentBeneficiaryId = 1)
       BEGIN
       --PRINT 'Female National Over Five'
             UPDATE @Temp
             SET FemaleNationalFiveOrOver = (SELECT FemaleNationalFiveOrOver FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END
ELSE

IF(@CurrentAge >= 5.00 AND @CurrentGenderId = 2 AND @CurrentBeneficiaryId = 2)
       BEGIN
       --PRINT 'Female Refugee Over Five'
             UPDATE @Temp
             SET FemaleRefugeeFiveOrOver = (SELECT FemaleRefugeeFiveOrOver FROM @Temp WHERE DiagnosisId = @CurrentDiagId /*AND Sup_DiagnosisId = @CurrentSupDiagId*/) + 1
             WHERE DiagnosisId = @CurrentDiagId --AND Sup_DiagnosisId = @CurrentSupDiagId
       END

SET @CurrentRow = @CurrentRow + 1

END

SELECT * FROM @Temp AS t

--SELECT * FROM @QueryTable 

END




GO


