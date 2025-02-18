USE [Admin]
GO

/****** Object:  Table [dbo].[t_dba_database_index_usage_stats]    Script Date: 18-02-2025 18:04:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[t_dba_database_index_usage_stats](
	[ServerName] [varchar](1000) NULL,
	[DataBaseName] [varchar](1000) NULL,
	[TableName] [nvarchar](128) NULL,
	[IndexName] [sysname] NULL,
	[UserSeeks] [bigint] NOT NULL,
	[UserScans] [bigint] NOT NULL,
	[UserLookups] [bigint] NOT NULL,
	[UserUpdates] [bigint] NOT NULL,
	[DateCapture] [datetime] NULL
) ON [PRIMARY]
GO

