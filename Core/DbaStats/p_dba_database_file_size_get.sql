USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_database_file_size_get]    Script Date: 18-02-2025 18:02:08 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		MRR
-- Create date: 20231102
-- Description:	Table get [t_dba_database_file_size]
-- =============================================
CREATE PROCEDURE [dbo].[p_dba_database_file_size_get]
(
	@ServerName varchar(1000)=null,
	@DataBaseName varchar(1000)=NULL,
	@FileName varchar(2000)=null,
	@FileGroup varchar(2000)=null,
	@Physical_name varchar(2000)=null,
	@DateCaptureStart Datetime=null,
	@DateCaptureEnd Datetime=null
)
AS
BEGIN
SELECT [ServerName]
	  ,[DateCapture]
      ,[DataBaseName]
      ,[FileName]
      ,[FileGroup]
      ,[Physical_name]
      ,[CurrentSizeMB]
      ,[FreeSpaceMB]
      ,[UsageMB]
      ,[Max_size]
      ,[%FreeSpace]
      ,[RecommendedReSizeMB]
      ,[RecoveredDiskSpaceMB]
      ,[ScriptCompactDBFile]
  FROM [dbo].[t_dba_database_file_size]
  WHERE 
			([DateCapture] >= isnull(@DateCaptureStart,[DateCapture]))
		AND	([DateCapture] <= isnull(@DateCaptureEnd,[DateCapture]))
		AND ([DataBaseName] like isnull('%'+@DataBaseName+'%',[DataBaseName])) 
		AND	([Physical_name] like isnull('%'+@Physical_name+'%',[Physical_name]))
		AND	([ServerName] like isnull('%'+@ServerName+'%',[ServerName]))
		AND	([FileName] like isnull('%'+@FileName+'%',[FileName]))
		AND	([FileGroup] like isnull('%'+@FileGroup+'%',[FileGroup]))
	order by 
	[DateCapture] asc
END
GO

