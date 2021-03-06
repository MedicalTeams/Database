USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp_load_json_visits]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_load_json_visits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_load_json_visits]
GO
/****** Object:  StoredProcedure [dbo].[sp_load_json_visits]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_load_json_visits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[sp_load_json_visits]
	-- Add the parameters for the stored procedure here
AS
BEGIN 

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	BEGIN TRY
	-- Clear the temp table before processing
	truncate table dbo.tmp_jsonvisit

	BEGIN TRANSACTION;
    -- Insert statement to load the tmp_JsonVisit with unpacked JSON messages from the raw_visits table
	-- The conditions for the pull from the raw_visits table are any recods that have not yet been processed (visit_stat = ''N'')
	-- and any record that does not have an error code (err_cd is null)
	insert into dbo.tmp_jsonvisit (visit_uuid, element_id, sequenceNo, parent_ID, Object_ID, Name, StringValue, ValueType)  
		select 
			r.visit_uuid
			, j.element_id
			, j.sequenceNo
			, j.parent_ID
			, j.Object_ID
			, j.NAME
			, j.StringValue
			, j.ValueType
		from raw_visit r
		cross apply parseJson(r.visit_json) as j
		where 
			r.visit_stat = ''N''
			and r.err_cd is null
		order by rec_creat_dt desc

	COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH
		IF @@TRANCOUNT > 0
		ROLLBACK TRANSACTION;
		
		DECLARE @ErrNbr INT = ERROR_NUMBER();
		DECLARE @ErrMsg NVARCHAR(100) = ERROR_MESSAGE();
		DECLARE @ErrLn  INT = ERROR_LINE();
		DECLARE @ErrSev INT = ERROR_SEVERITY();
		DECLARE @ErrSt  INT = ERROR_STATE();


		PRINT ''errno: '' + CAST(@ErrNbr AS VARCHAR(10));
		PRINT ''errln: '' + CAST(@ErrLn AS VARCHAR(10));
		PRINT ''errmsg: '' + CAST(@ErrMsg AS VARCHAR(100));

		THROW;

	END CATCH

END

' 
END
GO
