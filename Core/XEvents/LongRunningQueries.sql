CREATE EVENT SESSION [LongRunningQueries] ON SERVER 
ADD EVENT sqlserver.module_end(SET collect_statement=(1)
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.transaction_id)
    WHERE ([package0].[greater_than_equal_uint64]([duration],(2000000)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(1)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(3)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(4)))),
ADD EVENT sqlserver.sp_statement_completed(SET collect_object_name=(1),collect_statement=(1)
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.transaction_id)
    WHERE ([package0].[greater_than_equal_int64]([duration],(2000000)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(1)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(3)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(4)))),
ADD EVENT sqlserver.sql_statement_completed(SET collect_statement=(1)
    ACTION(package0.event_sequence,sqlos.task_time,sqlserver.client_app_name,sqlserver.client_hostname,sqlserver.database_name,sqlserver.nt_username,sqlserver.query_hash,sqlserver.server_instance_name,sqlserver.server_principal_name,sqlserver.session_id,sqlserver.sql_text,sqlserver.transaction_id)
    WHERE ([package0].[greater_than_equal_int64]([duration],(2000000)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(1)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(3)) AND [package0].[not_equal_uint64]([sqlserver].[database_id],(4))))
ADD TARGET package0.event_counter,
ADD TARGET package0.event_file(SET filename=N'H:\DBAutomation\XE\LongrunningQueries\LongrunningQueries.xel',max_file_size=(100),max_rollover_files=(20))
WITH (MAX_MEMORY=250000 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=ON)
GO

