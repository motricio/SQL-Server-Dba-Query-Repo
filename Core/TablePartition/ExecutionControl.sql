USE [Admin]
GO

/****** Object:  Table [dbo].[ExecutionControl]    Script Date: 09-06-2025 19:10:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ExecutionControl](
	[date_execute] [datetime] NULL,
	[is_executing] [bit] NULL
) ON [PRIMARY]
GO