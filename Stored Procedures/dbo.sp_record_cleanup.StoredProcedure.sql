USE [Clinic]
GO
/****** Object:  StoredProcedure [dbo].[sp_record_cleanup]    Script Date: 9/21/2016 2:52:27 PM ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_record_cleanup]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_record_cleanup]
GO
/****** Object:  StoredProcedure [dbo].[sp_record_cleanup]    Script Date: 9/21/2016 2:52:27 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_record_cleanup]') AND type in (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'Create Procedure [dbo].[sp_record_cleanup] as
--Table Clean Up --30 Days

Begin Transaction

Begin Try
	Delete from tmp_visit_to_proc 
	where rec_creat_dt < (getdate()-30)
	and proc_stat = ''P''
	and err_cd > -1;

	Delete from raw_visit 
	where rec_creat_dt < (getdate()-30)
	and visit_stat = ''P''
	and err_cd > -1
	and visit_uuid not in (select tvtp.visit_uuid from tmp_visit_to_proc tvtp);

End Try

Begin Catch
	Rollback transaction;
End Catch;

Commit transaction;

' 
END
GO
