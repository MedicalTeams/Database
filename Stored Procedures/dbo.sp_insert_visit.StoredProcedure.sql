USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_visit]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_visit]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_insert_visit]
GO
/****** Object:  StoredProcedure [dbo].[sp_insert_visit]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_visit]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
/****** Object:  StoredProcedure [dbo].[sp_insert_visit]    Script Date: 9/20/2016 1:29:59 PM ******/
--DROP PROCEDURE [dbo].[sp_insert_visit]
--GO

/****** Object:  StoredProcedure [dbo].[sp_insert_visit]    Script Date: 9/20/2016 1:29:59 PM ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO


CREATE PROCEDURE [dbo].[sp_insert_visit]
    @visit_uuid nvarchar(100) 
AS 
--=================================================================
-- Define variables
Declare @error_code int;
-- header data
Declare @faclty_id int, @staff_mbr_name varchar(50);

-- demographic data
Declare @gndr_id int, @bnfcry_id int, @age_years_low decimal(6,3),@age_years_high decimal(6,3);

-- visit data
Declare @opd_id int, @rvisit_id int, @dt_of_visit datetime, @faclty_hw_invtry_id int;

-- diagnosis data
Declare @diag_id int, @oth_diag_descn varchar(50);

-- supplemental diagnosis data
Declare @splmtl_diag_id int, @oth_splmtl_diag_descn varchar(50), @cntct_trmnt_cnt int, @splmtl_diag_cat_id int; 

-- workflow data
Declare @ov_id int, @temp_row_id int, @rec_id nvarchar(100);

-- Initialize
IF CURSOR_STATUS(''global'',''diag_cursor'')>=-1
BEGIN
 DEALLOCATE diag_cursor
END
IF CURSOR_STATUS(''global'',''supp_diag_cursor'')>=-1
BEGIN
 DEALLOCATE supp_diag_cursor
END

Set @ov_id = null;
Set @temp_row_id = null;
Set @error_code = -1;

-- Select visit data
	Select @rec_id = visit_uuid, @faclty_id = faclty_id, @gndr_id = gndr_id, @bnfcry_id = bnfcry_id, 
	@opd_id = opd_id, @faclty_hw_invtry_id = faclty_hw_invtry_id, 
	@dt_of_visit = dt_of_visit, @staff_mbr_name = staff_mbr_name, @age_years_low = age_years_low,@age_years_high =age_years_high,  
	@rvisit_id = rvisit_id
	From tmp_visit_to_proc
	group by visit_uuid, faclty_id, gndr_id, bnfcry_id, opd_id, faclty_hw_invtry_id, 
	dt_of_visit, staff_mbr_name, age_years_low,age_years_high, rvisit_id 
	having visit_uuid = @visit_uuid; 

	If @@rowcount <> 1 
	BEGIN
		--create error.
		Set @error_code  = -2;
		Return @error_code;
	END

--  Start Transaction 
Begin Transaction

-- Insert into OV Table
	BEGIN TRY
		Insert into ov (faclty_id,gndr_id, bnfcry_id, opd_id, faclty_hw_invtry_id,
		dt_of_visit, staff_mbr_name, age_years_low,age_years_high, rvisit_id)
		values 
		(@faclty_id, @gndr_id, @bnfcry_id, @opd_id, @faclty_hw_invtry_id, @dt_of_visit, @staff_mbr_name,@age_years_low,@age_years_high, @rvisit_id) ;
	END TRY

	BEGIN CATCH
		Set @error_code = -6;
		Rollback transaction;
		return @error_code;			
	END CATCH;

-- Retrieve ov_id
	set @ov_id = @@identity;

-- create cursor for initial diagnosis
	DECLARE diag_cursor CURSOR FOR

	--select diagnosis data, other if appropriate.  Can have multiple others, 
	--but should only have 1 of each general diagnosis.

	select visit_uuid, diag_id, null as oth_diag_descn
	from tmp_visit_to_proc
	group by visit_uuid, diag_id, oth_diag_descn
	having visit_uuid = @visit_uuid
	and diag_id <> 23
	Union
	select visit_uuid, diag_id, oth_diag_descn
	from tmp_visit_to_proc
	group by visit_uuid, diag_id, oth_diag_descn
	having visit_uuid = @visit_uuid 
	and diag_id = 23
	Order by diag_id;

	OPEN diag_cursor

	FETCH NEXT FROM diag_cursor into @rec_id, @diag_id, @oth_diag_descn;
	WHILE @@FETCH_STATUS = 0 
	BEGIN
	-- insert general diagnosis 
		If @diag_id not in (16, 19, 20, 21, 23) -- NO supplemental info
		BEGIN
			BEGIN TRY
				Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
				splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
				values 
				(@ov_id, null, @diag_id, null, null, null, null);
			END TRY

			BEGIN CATCH
				Set @error_code = -6;
				Rollback transaction;
				return @error_code;			
			END CATCH;
		END

		If @diag_id = 23 -- ''other'' 	
		BEGIN

			If (@diag_id = 23)  and (@oth_diag_descn is null) --other
			BEGIN
				Set @error_code = -3;
				Rollback transaction;
				return @error_code;
			END

			BEGIN TRY

				Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
				splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
				values 
				(@ov_id, null, @diag_id, null, null, @oth_diag_descn, null);

			END TRY

			BEGIN CATCH
				Set @error_code = -6;
				Rollback transaction;
				return @error_code;			
			END CATCH;

		END

	-- Special Cases 16=STI, 19=Chronic, 20=Mental Health, 21=Injuries, 23=Other

		--If 16,19,20,21; we need to go to get supplemental data.  Start new loop because their may be multi-rows.
	If @diag_id in (16,19,20,21)
	BEGIN
		DECLARE supp_diag_cursor CURSOR FOR
			--select visit_uuid, diag_id, splmtl_diag_id, oth_splmtl_diag_desc, splmtl_diag_cat_id, cntct_trmnt_cnt
			--Can consider doing a group by, but might mask a problem.
			select splmtl_diag_id, oth_splmtl_diag_descn, splmtl_diag_cat_id, cntct_trmnt_cnt
			from tmp_visit_to_proc
			where visit_uuid = @visit_uuid
			and diag_id = @diag_id
			order by 3;

		OPEN supp_diag_cursor;

		FETCH NEXT FROM supp_diag_cursor into @splmtl_diag_id, @oth_splmtl_diag_descn, @splmtl_diag_cat_id, @cntct_trmnt_cnt;
		WHILE @@FETCH_STATUS = 0 
		BEGIN

			If @diag_id in (16, 19, 20, 21) and (@splmtl_diag_id is null) --supplemental value
			BEGIN
				--Throw error
				Set @error_code  = -3;
				Rollback transaction;
				return @error_code;
			END

		If @diag_id = 16--sti / requires contact counter
		BEGIN

			BEGIN TRY
			Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
			splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
			values 
			(@ov_id, @splmtl_diag_id, @diag_id, coalesce (@cntct_trmnt_cnt, 0), null, null, null);
			END TRY

			BEGIN CATCH
				Set @error_code = -6;
				Rollback transaction;
				return @error_code;			
			END CATCH;

		END

		If @diag_id = 19 --chronic / may have an other
		BEGIN
			If (@splmtl_diag_cat_id = 54) and (@oth_splmtl_diag_descn is null)
			BEGIN
				--Throw error
				set @error_code = -3;
				rollback transaction;
				return @error_code;
			END

			BEGIN TRY
				Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
				splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
				values 
				(@ov_id, @splmtl_diag_id, @diag_id, null, null, null, @oth_splmtl_diag_descn);
			END TRY

			BEGIN CATCH
				Set @error_code = -6;
				Rollback transaction;
				return @error_code;			
			END CATCH;

		END

		If @diag_id = 20 --mental health / may have an other
		BEGIN
				If (@splmtl_diag_cat_id = 62) and (@oth_splmtl_diag_descn is null)
				BEGIN
					--Throw error
					set @error_code = -3;
					rollback transaction;
					return @error_code;
				END
				BEGIN TRY

				Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
				splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
				values 
				(@ov_id, @splmtl_diag_id, @diag_id, null, null, null, @oth_splmtl_diag_descn);

				END TRY

				BEGIN CATCH
					Set @error_code = -6;
					Rollback transaction;
					return @error_code;			
				END CATCH;

		END

		If @diag_id = 21 --injuries / requires location
		BEGIN
			If @splmtl_diag_cat_id is null
			BEGIN
				--Throw error
				set @error_code = -3;
				rollback transaction;
				return @error_code;
			END

			BEGIN TRY

			Insert into ov_diag(ov_id, splmtl_diag_id, diag_id, cntct_trmnt_cnt, 
			splmtl_diag_cat_id, oth_diag_descn, oth_splmtl_diag_descn)
			values 
			(@ov_id, @splmtl_diag_id, @diag_id, null, @splmtl_diag_cat_id, null, null);

			END TRY

			BEGIN CATCH
				Set @error_code = -6;
				Rollback transaction;
				return @error_code;			
			END CATCH;

		END

		--End inner diag loop
			FETCH NEXT FROM supp_diag_cursor into @splmtl_diag_id, @oth_splmtl_diag_descn, @splmtl_diag_cat_id, @cntct_trmnt_cnt;
		END;
		CLOSE supp_diag_cursor;
		DEALLOCATE supp_diag_cursor;
	
	END

	  FETCH NEXT FROM diag_cursor into @rec_id, @diag_id, @oth_diag_descn;
	END;
	CLOSE diag_cursor;
	DEALLOCATE diag_cursor;

	Set @error_code = 0;
Commit Transaction;

--=================================================================

Return @error_code;

' 
END
GO
