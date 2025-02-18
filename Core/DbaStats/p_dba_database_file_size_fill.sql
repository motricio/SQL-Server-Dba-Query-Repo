USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_database_file_size_fill]    Script Date: 18-02-2025 18:01:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

  
  
  
-- =============================================  
-- Author:  MRR  
-- Create date: 20231102  
-- Description: Table fill [t_dba_database_file_size]  
-- =============================================  
CREATE PROCEDURE [dbo].[p_dba_database_file_size_fill]  
AS  
BEGIN  
 SET NOCOUNT ON;  
   DECLARE @DB_NAME AS VARCHAR(200);  
   DECLARE @DB_NAME_FILTER AS VARCHAR(200);  
   DECLARE @MEMBER_OF AS VARCHAR(200);  
   DECLARE @TSQL AS NVARCHAR(4000);  
   SET @DB_NAME='';  
   SET @MEMBER_OF='';  
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
     'SELECT '''+@@SERVERNAME+''' as DataBaseName,   
       '''+@DB_NAME+''' as DataBaseName,   
       DF.name AS FileName,  
       isnull(FG.name,''Log'') as [FileGroup],   
       DF.physical_name,  
       CurrentSizeMB,      
       FreeSpaceMB,  
       UsageMB,  
       DF.max_size,  
       [%FreeSpace],  
       [RecommendedReSizeMB],  
       [RecoveredDiskSpaceMB],  
       ''USE ['+@DB_NAME+ '];  
       DBCC SHRINKFILE   
       (N''''''+ DF.name +'''''',''+ CAST(cast(RecommendedReSizeMB as INT) AS NVARCHAR(200)) +'');''  
       AS [ScriptCompactDBFile],  
       @DATE as DateCapture  
       FROM sys.master_files AS DF  
       LEFT JOIN sys.filegroups AS FG ON (DF.data_space_id = FG.data_space_id)  
       CROSS APPLY(SELECT CAST(DF.size AS decimal(16,2))*8/1024 AS CurrentSizeMB) AS A  
      
       CROSS APPLY(SELECT CAST(FILEPROPERTY(DF.name, ''SpaceUsed'') AS decimal(16,2))*8/1024 AS UsageMB) AS C  
      
       CROSS APPLY(SELECT (CurrentSizeMB - UsageMB) AS FreeSpaceMB) AS B  
  
       CROSS APPLY(SELECT (cast(FreeSpaceMB as decimal(16,2))/cast(CurrentSizeMB as decimal(16,2))*100) AS [%FreeSpace]) AS D  
       CROSS APPLY(SELECT (CurrentSizeMB - FreeSpaceMB + 10) AS [RecommendedReSizeMB]) AS E  
       CROSS APPLY(SELECT (CurrentSizeMB - RecommendedReSizeMB) as [RecoveredDiskSpaceMB]) AS F  
       where   
       --DF.type = 1 and   
       DB_NAME(DF.database_id)= '''+@DB_NAME+'''  
       order by   
       [RecoveredDiskSpaceMB] desc  
       '  
      
--       PRINT @TSQL;  
       INSERT INTO [Admin].[dbo].[t_dba_database_file_size]([ServerName],[DataBaseName],[FileName],[FileGroup],[Physical_name],[CurrentSizeMB],[FreeSpaceMB],[UsageMB],[Max_size],[%FreeSpace],[RecommendedReSizeMB],[RecoveredDiskSpaceMB],[ScriptCompactDBFile],[DateCapture])  
       EXECUTE sp_executesql @TSQL;  
   
       FETCH NEXT FROM db_cursor INTO @DB_NAME     
   END     
   CLOSE db_cursor     
   DEALLOCATE db_cursor  
END  
GO

