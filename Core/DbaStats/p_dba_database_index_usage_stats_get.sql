USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_database_index_usage_stats_get]    Script Date: 18-02-2025 18:06:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		MRR
-- Create date: 20240305
-- Description:	Table get [t_dba_database_index_usage_stats] Report
-- =============================================
CREATE PROCEDURE [dbo].[p_dba_database_index_usage_stats_get]
(
	@DataBaseName varchar(1000)=NULL,
	@TableName varchar(2000)=null,
	@IndexName varchar(2000)=null,
	@DateCaptureStart Datetime=null,
	@DateCaptureEnd Datetime=null
)
AS
BEGIN
		DECLARE @Index_usage_stats_var TABLE
		(
			--[ServerName] varchar(100),
			[DataBaseName] varchar(1000),
			[TableName] varchar(256),
			[IndexName] varchar(1000),
			[DateCapture] date,
			[UserSeeks] int,
			[UserScans] int,
			[UserUpdates] int,
			[previous_DateCapture] datetime,
			[previous_UserUpdates] int,
			[Dif_UserUpdates] int
		)

		DECLARE @Index_usage_scan_report TABLE
		(
			--[ServerName] varchar(100),
			[DataBaseName] varchar(1000),
			[TableName] varchar(256),
			[IndexName] varchar(1000),
			[Index_frag_type] varchar(10),
			[DateCapture] date,
			[UserUpdates] int,
			[previous_DateCapture] datetime,
			[previous_UserUpdates] int,
			[Dif_UserUpdates] int,
			[Page_count] int,
			[PartitionNumber] int,
			[Fragmentation] int
		)

		INSERT INTO @Index_usage_stats_var(DataBaseName,TableName,IndexName,DateCapture,[UserSeeks], [USerScans],UserUpdates,previous_DateCapture,previous_UserUpdates,Dif_UserUpdates)
		SELECT 
			 --u.ServerName
			 U.DataBaseName
			,U.TableName
			,U.IndexName
			,CONVERT(DATE,U.DateCapture) as DateCapture
			,U.[UserSeeks]
			,U.[UserScans]
			,U.UserUpdates
			,LAG(U.DateCapture) OVER (PARTITION BY U.DataBaseName,U.TableName,U.IndexName order by U.DateCapture) previous_DateCapture
			,LAG(U.UserUpdates) OVER (PARTITION BY U.DataBaseName,U.TableName,U.IndexName order by U.DateCapture) previous_UserUpdates
			,U.UserUpdates-LAG(U.UserUpdates) OVER (PARTITION BY U.DataBaseName,U.TableName,U.IndexName order by U.DateCapture) Dif_UserUpdates
		from [t_dba_database_index_usage_stats] U
		where 
		U.DatabaseName<>'Admin'
		order by U.DataBaseName,U.TableName,U.IndexName, DateCapture

		
		select 
				 U.DataBaseName
				,U.TableName
				,U.IndexName
				,DateCapture
				,U.[UserSeeks]
				,U.[UserScans]
				,U.UserUpdates
				,u.previous_DateCapture
				,u.previous_UserUpdates
				,u.Dif_UserUpdates
			from @Index_usage_stats_var U
			where 
				([U].[DataBaseName]= isnull(@DataBaseName,[U].[DataBaseName]))
			AND	([U].[TableName] like isnull('%'+@TableName+'%',[U].[TableName]))
			AND	([U].[IndexName] like isnull('%'+@IndexName+'%',[U].[IndexName]))
			AND	([U].[DateCapture] >= isnull(@DateCaptureStart,[U].[DateCapture]))
			AND	([U].[DateCapture] <= isnull(@DateCaptureEnd,[U].[DateCapture]))
			order by U.DataBaseName,U.TableName,U.IndexName, DateCapture asc
END
GO

