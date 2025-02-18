USE [Admin]
GO

/****** Object:  Table [dbo].[t_dba_database_file_size]    Script Date: 18-02-2025 18:00:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_dba_database_file_size](
	[ServerName] [varchar](1000) NULL,
	[DataBaseName] [varchar](1000) NULL,
	[FileName] [varchar](2000) NULL,
	[FileGroup] [varchar](2000) NULL,
	[Physical_name] [varchar](2000) NULL,
	[CurrentSizeMB] [varchar](200) NULL,
	[FreeSpaceMB] [varchar](200) NULL,
	[UsageMB] [varchar](200) NULL,
	[Max_size] [varchar](200) NULL,
	[%FreeSpace] [varchar](200) NULL,
	[RecommendedReSizeMB] [varchar](200) NULL,
	[RecoveredDiskSpaceMB] [varchar](200) NULL,
	[ScriptCompactDBFile] [varchar](4000) NULL,
	[DateCapture] [datetime] NULL
) ON [PRIMARY]
GO

