RESTORE DATABASE [CoreIssueRPT]
FROM DISK = N'K:\MSSQLBackup\Dress_rehersel\CoreIssueRPT_Diff.bak'
WITH FILE = 1
	,NORECOVERY
	,NOUNLOAD
	,STATS = 5
 
RESTORE LOG [CoreIssueRPT]
FROM DISK = N'K:\MSSQLBackup\Dress_rehersel\CoreIssueRPT_logback.trn'
WITH FILE = 1
	,NORECOVERY
	,NOUNLOAD
	,STATS = 5
GO
