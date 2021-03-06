USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp_load_visit_to_proc]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_load_visit_to_proc]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_load_visit_to_proc]
GO
/****** Object:  StoredProcedure [dbo].[sp_load_visit_to_proc]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_load_visit_to_proc]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'



CREATE PROCEDURE [dbo].[sp_load_visit_to_proc] 

AS 
BEGIN 
		-- Declare variables
		DECLARE @visit_uuid nvarchar(100)
		DECLARE @mth int = 12

		-- Declare cursors
		DECLARE visit_cursor CURSOR FOR 
			SELECT distinct visit_uuid		
			FROM tmp_JsonVisit
			WHERE visit_uuid is not null; 

		OPEN visit_cursor   /* open cursor */ 

		FETCH NEXT FROM visit_cursor 
		INTO @visit_uuid;

		/* cursor loop */ 
		WHILE (@@FETCH_STATUS <> -1) 
		BEGIN TRY
			BEGIN TRANSACTION;
			-- This query will flatten the JSON record and insert it into the tmp_visit_to_proc table.
			insert into tmp_visit_to_proc (visit_uuid, bnfcry_id, faclty_hw_invtry_id, faclty_id, gndr_id, splmtl_diag_cat_id,
			rvisit_id, opd_id, age_years_low,age_years_high, staff_mbr_name, cntct_trmnt_cnt, dt_of_visit, diag_id, splmtl_diag_id, oth_diag_descn, 
			oth_splmtl_diag_descn) 
			-- Pivot the header data into the flattened structure
			select 
			a.visit_uuid,
			a.bnfcry_id,
			(select faclty_hw_invtry_id from faclty_hw_invtry where mac_addr = a.faclty_hw_invtry_id and hw_stat =''A'') faclty_hw_invtry_id,
			a.faclty_id,
			--case a.gndr_id when ''male'' then 1 else 2 end gndr_id,
			--modified 12/9/15 RR
			case Upper(a.gndr_id) when ''M'' then 1 else 2 end gndr_id,
			case b.diag when 21 then a.splmtl_diag_cat_id else 0 end splmtl_diag_cat_id,
			case a.rvisit_id when ''false'' then 1 else 2 end rvisit_id ,
			a.opd_id,
			cast(cast(a.age_years_low as decimal(6,3))/@mth as decimal(6,3)) age_years_low,
			cast(cast(a.age_years_high as decimal(6,3))/@mth as decimal(6,3)) age_years_high,
			a.staff_mbr_name,
			case b.diag when 16 then a.cntct_trmnt_cnt else 0 end cntct_trmnt_cnt,
			convert(datetime, left(a.dt_of_visit, 19), 126) dt_of_visit,
			b.diag diag_id,
			b.supp_diag splmtl_diag_id,
			case b.diag when 23 then b.oth_diag_nm else null end oth_diag_nm ,
			case b.supp_diag when 54 then b.oth_sup_diag_nm when 68 then b.oth_sup_diag_nm when 62 then b.oth_sup_diag_nm else null end oth_sup_diag_nm
			 from 
			(
			select 
			visit_uuid
			, max(beneficiaryType) bnfcry_id
			, max(deviceId) faclty_hw_invtry_id
			, max(facility) faclty_id
			, max(gender) gndr_id
			, max(injuryLocation) splmtl_diag_cat_id
			, max(isRevisit) rvisit_id
			, max(OPD) opd_id
			, max(patientAgeMonthsLow) age_years_low
			, max(patientAgeMonthsHigh) age_years_high
			, max(patientDiagnosis) diag_id
			, max(staffMemberName) staff_mbr_name
			, max(stiContactsTreated) cntct_trmnt_cnt
			, max(visitDate) dt_of_visit
			 from tmp_JsonVisit
			 pivot
			 (
				max(StringValue)
				for Name in ([beneficiaryType], [deviceId], [facility], [gender], [injuryLocation], [isRevisit], [OPD], [patientAgeMonthsLow],[patientAgeMonthsHigh],
				[patientDiagnosis], [staffMemberName], [stiContactsTreated], [visitDate], [visitId])
			) as p
			where visit_uuid = @visit_uuid
			group by visit_uuid
			) as  a
			JOIN
			(
			select v.visit_uuid, sup.StringValue diag, sup_nm.StringValue oth_diag_nm, sup_val.sup_diag_id supp_diag, sup_val.oth_sup_diag_nm
			from  tmp_JsonVisit v
				INNER JOIN tmp_JsonVisit diag
					ON v.visit_uuid = diag.visit_uuid and v.object_id = diag.parent_id
				INNER JOIN tmp_JsonVisit sup
					ON diag.object_id = sup.parent_id and diag.visit_uuid = sup.visit_uuid
				INNER JOIN tmp_JsonVisit sup_nm
					ON diag.object_id = sup_nm.parent_id and diag.visit_uuid = sup_nm.visit_uuid
				LEFT OUTER JOIN 
					(
					select v.visit_uuid, v.parent_id, sup_id_val.StringValue sup_diag_id , sup_id_nm.StringValue oth_sup_diag_nm
					from 
					tmp_JsonVisit v,
					tmp_JsonVisit sup,
					tmp_JsonVisit sup_id_val,
					tmp_JsonVisit sup_id_nm
					where 
					v.visit_uuid = sup.visit_uuid 
					and v.object_id = sup.parent_id
					and sup.visit_uuid = sup_id_val.visit_uuid
					and sup.object_id = sup_id_val.parent_id
					and sup.visit_uuid = sup_id_nm.visit_uuid
					and sup.object_id = sup_id_nm.parent_id
					and v.visit_uuid = @visit_uuid
					and v.name = ''supplementals''
					and sup_id_val.name = ''id''
					and sup_id_nm.name = ''name''
					) sup_val
				ON sup.parent_id = sup_val.parent_id
			where
			(v.name in (''patientDiagnosis'', ''id'', ''name'') or v.name is null)
			and v.visit_uuid = @visit_uuid
			and sup.name = ''id''
			and sup_nm.name = ''name''
			) b
			ON a.visit_uuid = b.visit_uuid


			-- Update the table as the record being processed successfully!
			UPDATE raw_visit
				set visit_stat = ''P'', err_cd = 0
				where visit_uuid = @visit_uuid

			-- If no errors, commit transactioin to the database
			COMMIT TRANSACTION;

		-- move to the next record 
		FETCH NEXT FROM visit_cursor 
		INTO @visit_uuid 
		
		END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;

		
		-- Update the raw_visit table with an error code of 1
		-- Since the record could not be processed
		UPDATE raw_visit set err_cd = -1, visit_stat = ''P''
			where visit_uuid = @visit_uuid;
		

		DECLARE @ErrNbr INT = ERROR_NUMBER();
		DECLARE @ErrMsg NVARCHAR(100) = ERROR_MESSAGE();
	
		PRINT ''errno: '' + CAST(@ErrNbr AS VARCHAR(10));
		PRINT ''errmsg: '' + CAST(@ErrMsg AS VARCHAR(100));
		PRINT ''visit_uuid: '' + @visit_uuid;

		THROW;

		FETCH NEXT FROM visit_cursor INTO @visit_uuid 
		CONTINUE

	END CATCH


		/* release data structures that was allocated by cursor */ 
		CLOSE visit_cursor; 
		DEALLOCATE visit_cursor; 


-- end of procedure 
END 




' 
END
GO
