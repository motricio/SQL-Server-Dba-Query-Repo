USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_database_index_usage_stats_fill]    Script Date: 18-02-2025 18:05:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		MRR
-- Create date: 20231103
-- Description:	Table fill [t_dba_database_index_usage_stats]
-- =============================================
	CREATE PROCEDURE [dbo].[p_dba_database_index_usage_stats_fill]
AS
BEGIN
	SET NOCOUNT ON;
			DECLARE @DB_NAME AS VARCHAR(200);
			DECLARE @DB_NAME_FILTER AS VARCHAR(200);
			DECLARE @TSQL AS NVARCHAR(4000);
			SET @DB_NAME='';
			SET @TSQL='';
 
			DECLARE db_cursor CURSOR FOR  
			--Fetch all user dbs
				SELECT db.name FROM master.dbo.sysdatabases db
					cross apply (select master.sys.fn_hadr_is_primary_replica (db.name) is_primary_replica) as AG
					WHERE db.name NOT IN ('master','model','msdb','tempdb','ReportServer','ReportServerTempDB')   
					and AG.is_primary_replica =1
			OPEN db_cursor   
			FETCH NEXT FROM db_cursor INTO @DB_NAME   
			
			WHILE @@FETCH_STATUS = 0   
			BEGIN 
				  SET @TSQL='DECLARE @DATE AS DATETIME;';
				  SET @TSQL=@TSQL+'SET @DATE = getdate();';
				  SET @TSQL= @TSQL+ 'USE [' + @DB_NAME+'];';
					SET @TSQL = @TSQL+
					'SELECT '''+@@SERVERNAME+''' as Servername, 
							'''+@DB_NAME+''' as DataBaseName, 
							OBJECT_NAME(S.[OBJECT_ID]) AS [OBJECT NAME], 
							I.[NAME] AS [INDEX NAME], 
							USER_SEEKS, 
							USER_SCANS, 
							USER_LOOKUPS, 
							USER_UPDATES,
							@DATE as DateCapture
						-- t_dba_database_index_usage
						FROM     SYS.DM_DB_INDEX_USAGE_STATS AS S 
									INNER JOIN SYS.INDEXES AS I 
									ON I.[OBJECT_ID] = S.[OBJECT_ID] 
										AND I.INDEX_ID = S.INDEX_ID 
						WHERE    OBJECTPROPERTY(S.[OBJECT_ID],''IsUserTable'') = 1 
						and I.type_desc <>''HEAP''
						and DB_ID('''+@DB_NAME+''') = s.database_id
						order by 1 asc,3 desc
							'
	   
							--PRINT @TSQL;
							INSERT INTO [Admin].[dbo].[t_dba_database_index_usage_stats]
							([ServerName],[DataBaseName],[TableName],[IndexName],[UserSeeks],[UserScans],[UserLookups],[UserUpdates],[DateCapture])
							EXECUTE sp_executesql @TSQL;
							
 
				   FETCH NEXT FROM db_cursor INTO @DB_NAME   
			END   
			CLOSE db_cursor   
			DEALLOCATE db_cursor
END
GO

