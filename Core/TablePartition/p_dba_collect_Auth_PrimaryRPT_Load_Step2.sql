USE [Admin]
GO

/****** Object:  StoredProcedure [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step2]    Script Date: 09-06-2025 19:06:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[p_dba_collect_Auth_PrimaryRPT_Load_Step2] 
(@batchSize INT = 100000, @CommitSize INT = 10000)
AS
BEGIN
	SET NOCOUNT ON;
	--------------------------------------------------------------------------------------------STEP II-----------------------------------------------------------------------------------------------
	DECLARE @PVT INT = 0;
	PRINT '---- Batch load started at: '+convert(varchar(30),getdate(),121);
	WHILE (@PVT < @batchSize)
	BEGIN

					
				DECLARE @id_control INT;
				DECLARE @results INT =1;
				SELECT @id_control = MIN(RowNbr) from Admin.dbo.DBA_Auth_PrimaryRPT_control WHERE loaded = 0
				
				--Load records into temp table
				DROP TABLE IF EXISTS #temp3
				create table #temp3 (RowNbr int NOT NULL, [TranID] [decimal](19, 0) NOT NULL, PostTime DATETIME NOT NULL)
				INSERT INTO #temp3(RowNbr, [TranID], PostTime) 
				select RowNbr,[TranID], PostTime
				from Admin.dbo.DBA_Auth_PrimaryRPT_control
				where RowNbr between @id_control and (@id_control+@CommitSize-1) and loaded = 0
	
				declare @is_executing as bit;
				select @is_executing=is_executing from ExecutionControl
	
				BEGIN TRY
					BEGIN TRAN
						IF (@is_executing=0)
						BEGIN
							SET IDENTITY_INSERT CoreIssueRPT.dbo.Auth_Primary_New ON       
							-- Insert into Auth_Primary_New
							insert into CoreIssueRPT.dbo.Auth_Primary_New
							([UniqueID],[GroupId],[TranId],[TranTime],[PostTime],[CMTTRANTYPE],[TranRef],[TxnAcctId],[ATID],[Reversed],[RevTgt],[StateStatus],[StatementDate],[priority],[AccountNumber],[CPMgroup],[creditplanmaster],[TxnCode_Internal],[PostingFlag],[PostingReason],[PostingRef],[BatchAcctId],[RejectBatchAcctId],[ARTxnType],[TxnSource],[PaymentCreditFlag],[AuthStatus],[PrimaryCurrencyCode],[SecondaryCurrencyCode],[TertiaryCurrencyCode],[tranorig],[PrimaryAccountNumber],[ProcCode],[ProcCodeFromAccType],[ProcCodeToAccType],[TransactionAmount],[TransmissionDateTime],[SystemTraceAuditNumber],[TimeLocalTransaction],[DateLocalTransaction],[ExpirationDate],[CaptureDate],[MerchantType],[CardDataEntryMode],[AcquiringInsitutionIDCode],[RetrievalReferenceNumber],[AuthorizationResponseCode],[ResponseCode],[CardAcceptorTerminalID],[CardAcceptorNameLocation],[TransactionCurrencyCode],[TxnSrcAmt],[ApprovalCode],[OriginalAmount_],[ResponseMTI],[RequestRC],[ResponseTranType],[NetworkName],[FunctionCode],[POSCountryCode],[OriginalDEs],[IResponseCode],[CalcOTB],[PurgeDate],[AcquiringInstCountryCode],[ForwardingInstCountryCode],[AcqTranId],[AuthDecisionControlLog],[CustomerId],[PAN_Hash],[CardNumber4Digits],[TransactionLifeCycleUniqueID],[TxnCategory],[CoreAuthTranId],[MessageIndicator],[OutstandingAmount],[MessageTypeIdentifier],[PINExist],[EffectiveDate_ForAgeOff],[POSTermOpEnv],[PhysicalSource],[InstitutionID],[ProductID],[ReconciliationIndicator],[EffectiveDate],[AuthMatchedFlag],[PlusChekIndicator],[AVReqOptCode],[CardAcceptorIdCode],[ReconciliationDate],[MerchantNameandAddress],[SKey],[MatchAgedOffPreAuth],[MulCountSeqNo],[BalanceAdjustment],[AuthInitiatingTime],[AuthProcessedTime],[FeeWaiveIndicator],[TxnCode_InternalClr],[CountryCode],[CustomAcctID],[CrossBorderTxnIndicator],[AuthType],[CurrentBalance],[TotalOutStgAuthAmt],[WalletAcctID],[CashBackAmount],[DrCrIndicator],[CardVendorId],[CardProductAID],[ESource],[usrId],[MatchedAdvice],[AuthDataDetail],[SettlementServiceSelected],[TxnLinkId],[ActualSettlementAmt],[ActualBillingAmt],[RowChangedDate]) 
							SELECT 
							[UniqueID],[GroupId],A.[TranId],[TranTime],A.[PostTime],[CMTTRANTYPE],[TranRef],[TxnAcctId],[ATID],[Reversed],[RevTgt],[StateStatus],[StatementDate],[priority],[AccountNumber],[CPMgroup],[creditplanmaster],[TxnCode_Internal],[PostingFlag],[PostingReason],[PostingRef],[BatchAcctId],[RejectBatchAcctId],[ARTxnType],[TxnSource],[PaymentCreditFlag],[AuthStatus],[PrimaryCurrencyCode],[SecondaryCurrencyCode],[TertiaryCurrencyCode],[tranorig],[PrimaryAccountNumber],[ProcCode],[ProcCodeFromAccType],[ProcCodeToAccType],[TransactionAmount],[TransmissionDateTime],[SystemTraceAuditNumber],[TimeLocalTransaction],[DateLocalTransaction],[ExpirationDate],[CaptureDate],[MerchantType],[CardDataEntryMode],[AcquiringInsitutionIDCode],[RetrievalReferenceNumber],[AuthorizationResponseCode],[ResponseCode],[CardAcceptorTerminalID],[CardAcceptorNameLocation],[TransactionCurrencyCode],[TxnSrcAmt],[ApprovalCode],[OriginalAmount_],[ResponseMTI],[RequestRC],[ResponseTranType],[NetworkName],[FunctionCode],[POSCountryCode],[OriginalDEs],[IResponseCode],[CalcOTB],[PurgeDate],[AcquiringInstCountryCode],[ForwardingInstCountryCode],[AcqTranId],[AuthDecisionControlLog],[CustomerId],[PAN_Hash],[CardNumber4Digits],[TransactionLifeCycleUniqueID],[TxnCategory],[CoreAuthTranId],[MessageIndicator],[OutstandingAmount],[MessageTypeIdentifier],[PINExist],[EffectiveDate_ForAgeOff],[POSTermOpEnv],[PhysicalSource],[InstitutionID],[ProductID],[ReconciliationIndicator],[EffectiveDate],[AuthMatchedFlag],[PlusChekIndicator],[AVReqOptCode],[CardAcceptorIdCode],[ReconciliationDate],[MerchantNameandAddress],[SKey],[MatchAgedOffPreAuth],[MulCountSeqNo],[BalanceAdjustment],[AuthInitiatingTime],[AuthProcessedTime],[FeeWaiveIndicator],[TxnCode_InternalClr],[CountryCode],[CustomAcctID],[CrossBorderTxnIndicator],[AuthType],[CurrentBalance],[TotalOutStgAuthAmt],[WalletAcctID],[CashBackAmount],[DrCrIndicator],[CardVendorId],[CardProductAID],[ESource],[usrId],[MatchedAdvice],[AuthDataDetail],[SettlementServiceSelected],[TxnLinkId],[ActualSettlementAmt],[ActualBillingAmt],A.[Posttime] as RowChangedDate
							FROM CoreIssueRPT.dbo.Auth_Primary A WITH(NOLOCK) 
							INNER JOIN #temp3 t ON (A.[TranID] = T.[TranID])
						
							UPDATE C SET C.loaded = 1 
							FROM Admin.dbo.DBA_Auth_PrimaryRPT_control C 
							INNER JOIN #temp3 t ON (C.[TranID] = T.[TranID])
							SET @results = @@ROWCOUNT
							print '-- We have inserted: '+convert(varchar(10),@results)+'; '+'Loaded from: '+convert(varchar(10),@id_control)+' To: '+convert(varchar(10),@id_control+@results-1)	
							SET IDENTITY_INSERT CoreIssueRPT.dbo.Auth_Primary_New OFF 

							END
						ELSE
						BEGIN
							-- @is_executing = 1
							ROLLBACK TRAN
							print '-- Process stopped due to additional control Table.';
							BREAK;
						END

					COMMIT TRAN
				END TRY
 
				BEGIN CATCH
					IF @@TRANCOUNT >= 1
					BEGIN  
						ROLLBACK TRAN
						SELECT  
							ERROR_NUMBER() AS ErrorNumber  
							,ERROR_SEVERITY() AS ErrorSeverity  
							,ERROR_STATE() AS ErrorState  
							,ERROR_PROCEDURE() AS ErrorProcedure  
							,ERROR_LINE() AS ErrorLine  
							,ERROR_MESSAGE() AS ErrorMessage;  
							BREAK;
					END
 
				   END CATCH
				   
			   SET  @PVT = @PVT + @CommitSize;
			--
		END
		PRINT '---- Batch load completed at: '+convert(varchar(30),getdate(),121);
	--- End while
END
GO


