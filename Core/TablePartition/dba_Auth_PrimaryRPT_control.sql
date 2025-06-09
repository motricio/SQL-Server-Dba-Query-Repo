USE [Admin]
GO

/****** Object:  Table [dbo].[dba_Auth_PrimaryRPT_control]    Script Date: 09-06-2025 19:09:32 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[dba_Auth_PrimaryRPT_control](
	[RowNbr] [int] NOT NULL,
	[TranId] [decimal](19, 0) NOT NULL,
	[PostTime] [datetime] NOT NULL,
	[loaded] [bit] NOT NULL
) ON [PRIMARY]
GO