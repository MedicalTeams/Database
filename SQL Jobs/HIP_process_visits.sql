USE [msdb]
GO

/****** Object:  Job [HIP_process_visits]    Script Date: 9/21/2016 10:05:26 PM ******/
EXEC msdb.dbo.sp_delete_job @job_id=N'b08b9895-a681-45db-9d28-63f89ee6e02c', @delete_unused_schedule=1
GO

/****** Object:  Job [HIP_process_visits]    Script Date: 9/21/2016 10:05:26 PM ******/
BEGIN TRANSACTION
DECLARE @ReturnCode INT
SELECT @ReturnCode = 0
/****** Object:  JobCategory [[Uncategorized (Local)]]    Script Date: 9/21/2016 10:05:26 PM ******/
IF NOT EXISTS (SELECT name FROM msdb.dbo.syscategories WHERE name=N'[Uncategorized (Local)]' AND category_class=1)
BEGIN
EXEC @ReturnCode = msdb.dbo.sp_add_category @class=N'JOB', @type=N'LOCAL', @name=N'[Uncategorized (Local)]'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback

END

DECLARE @jobId BINARY(16)
EXEC @ReturnCode =  msdb.dbo.sp_add_job @job_name=N'HIP_process_visits', 
		@enabled=1, 
		@notify_level_eventlog=0, 
		@notify_level_email=0, 
		@notify_level_netsend=0, 
		@notify_level_page=0, 
		@delete_level=0, 
		@description=N'Moves parsed data to the tmp_visit_to_proc table and assigned success/error codes', 
		@category_name=N'[Uncategorized (Local)]', 
		@owner_login_name=N'MEDICALTEAMS\salzheimer', @job_id = @jobId OUTPUT
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
/****** Object:  Step [exec sp_load_visit_to_proc]    Script Date: 9/21/2016 10:05:26 PM ******/
EXEC @ReturnCode = msdb.dbo.sp_add_jobstep @job_id=@jobId, @step_name=N'exec sp_load_visit_to_proc', 
		@step_id=1, 
		@cmdexec_success_code=0, 
		@on_success_action=1, 
		@on_success_step_id=0, 
		@on_fail_action=2, 
		@on_fail_step_id=0, 
		@retry_attempts=0, 
		@retry_interval=0, 
		@os_run_priority=0, @subsystem=N'TSQL', 
		@command=N'exec sp_serveroption @server=''HIP_AzureDb'', @optname=''rpc'', @optvalue=''true'';

exec sp_serveroption @server=''HIP_AzureDb'', @optname=''rpc out'', @optvalue=''true'';

exec HIP_AzureDb.Clinic.dbo.sp_process_visits; 

exec sp_serveroption @server=''HIP_AzureDb'', @optname=''rpc'', @optvalue=''false'';

exec sp_serveroption @server=''HIP_AzureDb'', @optname=''rpc out'', @optvalue=''false'';', 
		@database_name=N'master', 
		@flags=4
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_update_job @job_id = @jobId, @start_step_id = 1
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobschedule @job_id=@jobId, @name=N'sched_sp_process_visits', 
		@enabled=1, 
		@freq_type=4, 
		@freq_interval=1, 
		@freq_subday_type=4, 
		@freq_subday_interval=3, 
		@freq_relative_interval=0, 
		@freq_recurrence_factor=0, 
		@active_start_date=20151125, 
		@active_end_date=99991231, 
		@active_start_time=2, 
		@active_end_time=235959, 
		@schedule_uid=N'42fce158-8d1f-46dd-af04-6f5bf5507915'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
EXEC @ReturnCode = msdb.dbo.sp_add_jobserver @job_id = @jobId, @server_name = N'(local)'
IF (@@ERROR <> 0 OR @ReturnCode <> 0) GOTO QuitWithRollback
COMMIT TRANSACTION
GOTO EndSave
QuitWithRollback:
    IF (@@TRANCOUNT > 0) ROLLBACK TRANSACTION
EndSave:

GO

