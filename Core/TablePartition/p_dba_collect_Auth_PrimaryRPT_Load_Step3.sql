USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step3]    Script Date: 09-06-2025 19:08:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step3] (@CopyDate as datetime)
AS
BEGIN
	--------------------------------------------------------------------------------------------STEP III------------------------------------------------------------------------------------------------
	-- Find records need to insert on _New table after Step #1 load completed
	----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
			Drop table if exists #Auth_Primary;
			SELECT AP.[TranId], AP.[PostTime]
			into #Auth_Primary
			FROM CoreIssueRPT.dbo.Auth_Primary AP WITH(NOLOCK)
			WHERE AP.[PostTime]>= @CopyDate
			
			INSERT INTO Admin.dbo.dba_Auth_PrimaryRPT_control(RowNbr, TranID, PostTime, loaded)
			SELECT 
				distinct ROW_NUMBER() over(order by AP.[TranID]) as 'RowNbr', AP.[TranID], AP.[PostTime], 0 AS loaded
			FROM 
				CoreIssueRPT.dbo.Auth_Primary AP WITH(NOLOCK) 
				INNER JOIN #Auth_Primary CP WITH(NOLOCK) ON (AP.[TranId] = CP.[TranId] AND AP.PostTime = CP.PostTime) 
				LEFT JOIN CoreIssueRPT.dbo.Auth_Primary_New CN ON (AP.[TranId] = CN.[TranId] AND AP.PostTime = CN.PostTime)
			WHERE 
			CN.[TranId] IS NULL 
			AND CN.PostTime IS NULL
END
GO

