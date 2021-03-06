USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp_process_visits]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_process_visits]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_process_visits]
GO
/****** Object:  StoredProcedure [dbo].[sp_process_visits]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_process_visits]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'
CREATE PROCEDURE [dbo].[sp_process_visits] 

AS
BEGIN 
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Declare variables and cursors
	DECLARE @visit_uuid nvarchar(100)
	DECLARE @ret_cd INT
	DECLARE @tran_cnt INT


	DECLARE UnProc_Cursor CURSOR FOR
		SELECT distinct visit_uuid
		FROM tmp_visit_to_proc
		WHERE proc_stat = ''N''
		and err_cd is NULL;

	OPEN UnProc_cursor   /* open cursor */ 
		FETCH NEXT FROM UnProc_cursor 
		INTO @visit_uuid;

	WHILE (@@FETCH_STATUS = 0)	-- Loop thru the cursor
		BEGIN TRY
			SELECT @tran_cnt = @@TRANCOUNT

			IF @tran_cnt = 0
			BEGIN TRANSACTION;

			/* Call the insert stored procedure here */
			EXEC @ret_cd = sp_insert_visit @visit_uuid

			/* 
				Once record is landed and ret_cd = 0 then update the raw_visit
				table visit_stat column value to ''P'' for processed.
			*/
			IF (@ret_cd = 0) 
				BEGIN
					UPDATE raw_visit
						set visit_stat = ''P'', err_cd  = @ret_cd
						where visit_uuid = @visit_uuid;

					UPDATE tmp_visit_to_proc
						set proc_stat = ''P'', err_cd = @ret_cd
						where visit_uuid = @visit_uuid;

					print ''Visit UUID: '' + @visit_uuid + '' successfully inserted!''

				END
			ELSE
			/*  
				If the stored procedure, sp_insert_visit, returns a code other than 0
				it is considered an error.  Update the record in the raw visits table
				with the returned code
			*/
				BEGIN
					UPDATE raw_visit
						set err_cd = @ret_cd, visit_stat = ''P''
						where visit_uuid = @visit_uuid;

					UPDATE tmp_visit_to_proc
						set err_cd = @ret_cd, proc_stat = ''P''
						where visit_uuid = @visit_uuid;

					print ''Visit UUID: '' + @visit_uuid + '' failed!''

				END

			If @tran_cnt = 0
			COMMIT TRANSACTION;

			-- move to the next record 
			FETCH NEXT FROM UnProc_cursor 
			INTO @visit_uuid 

		END TRY


	BEGIN CATCH

		IF XACT_STATE() <> 0 AND @tran_cnt = 0
		ROLLBACK TRANSACTION;
		
		/* UPDATE record in raw_visit table with returned error identifier */
		UPDATE raw_visit
			set err_cd = @ret_cd, visit_stat = ''P''
			where visit_uuid = @visit_uuid;

		UPDATE tmp_visit_to_proc
			set err_cd = @ret_cd, proc_stat = ''P''
			where visit_uuid = @visit_uuid;
			

		DECLARE @ErrNbr INT = ERROR_NUMBER();
		DECLARE @ErrMsg NVARCHAR(100) = ERROR_MESSAGE();
	
		-- Print the visit uuid and error number 
		PRINT ''VISIT UUID: '' + @visit_uuid + '' errno: '' + CAST(@ErrNbr AS VARCHAR(10)) + '' errmsg: '' + CAST(@ErrMsg AS VARCHAR(100));

		--THROW;

		-- move to the next record 
		FETCH NEXT FROM UnProc_cursor INTO @visit_uuid 
		CONTINUE

	END CATCH



		/* release data structures that was allocated by cursor */ 
		CLOSE UnProc_cursor; 
		DEALLOCATE UnProc_cursor; 

END
' 
END
GO
