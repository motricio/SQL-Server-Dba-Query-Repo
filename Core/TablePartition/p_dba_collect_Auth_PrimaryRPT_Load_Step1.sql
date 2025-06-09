USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step1]    Script Date: 09-06-2025 19:04:54 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step1]
AS
BEGIN
	--------------------------------------------------------------------------------------------STEP I------------------------------------------------------------------------------------------------
	--Find records need to insert on _New table, duplicates row have not included
	INSERT INTO Admin.dbo.DBA_Auth_PrimaryRPT_control(RowNbr, TranID, PostTime, loaded)
	select distinct ROW_NUMBER() over(order by CAT.[TranID]) as 'RowNbr', CAT.[TranID], CAT.[PostTime], 0 AS loaded
	FROM CoreIssueRPT.dbo.Auth_Primary CAT WITH(NOLOCK) 
	WHERE CAT.[PostTime]>= '2023-05-01 00:00:00.000'
END
GO