CREATE EVENT SESSION [DBA_DeadlockEvent] ON SERVER 
ADD EVENT sqlserver.lock_deadlock(
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.lock_deadlock_chain(
    ACTION(sqlserver.sql_text)),
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(package0.process_id,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_id,sqlserver.database_name,sqlserver.is_system,sqlserver.plan_handle,sqlserver.session_id,sqlserver.sql_text,sqlserver.tsql_frame,sqlserver.tsql_stack,sqlserver.username))
ADD TARGET package0.event_file(SET filename=N'H:\DBAutomation\XE\DBA_DeadlockEvent\DBA_DeadlockEvent.xel',max_file_size=(100),max_rollover_files=(20))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO

