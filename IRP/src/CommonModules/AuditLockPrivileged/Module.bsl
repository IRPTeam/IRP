
Function LockIsSet(DocRef) Export
	If Not ValueIsFilled(DocRef) Then
		Return False;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	AuditLock.Document
	|FROM
	|	InformationRegister.AuditLock AS AuditLock
	|WHERE
	|	AuditLock.Document = &Document";
	Query.SetParameter("Document", DocRef);
	
	QueryResult = Query.Execute();
	
	Return Not QueryResult.IsEmpty();
EndFunction

Procedure BeforeWrite_AuditLockBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	If DocumentIsLocked(Source.Ref) Then
		Cancel = True;
	EndIf;
EndProcedure

Function DocumentIsLocked(DocRef) Export
	If LockIsSet(DocRef) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_004);
		Return True;
	EndIf;
	
	If TypeOf(DocRef) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(DocRef) = Type("DocumentRef.RetailReturnReceipt") Then
		
		If ValueIsFilled(DocRef.ConsolidatedRetailSales) Then
			If LockIsSet(DocRef.ConsolidatedRetailSales) Then
				CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_004);
				Return True;
			EndIf;
		EndIf;
		
	EndIf;
	
	Return False;
EndFunction	

Procedure SetLock(DocRef) Export
	If Not (IsInRole(Metadata.Roles.AuditLockSet) OR IsInRole(Metadata.Roles.FullAccess)) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_003);
		Return;
	EndIf;
	
	RecordSet = InformationRegisters.AuditLock.CreateRecordSet();
	RecordSet.Filter.Document.Set(DocRef);
	NewRecord = RecordSet.Add();
	NewRecord.Document = DocRef;
	RecordSet.Write();
	
	WriteHistory(DocRef, Enums.AuditLockActions.Lock);
EndProcedure

Procedure UnsetLock(DocRef) Export
	If Not (IsInRole(Metadata.Roles.AuditLockUnset) OR IsInRole(Metadata.Roles.FullAccess)) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_003);
		Return;
	EndIf;
	
	RecordSet = InformationRegisters.AuditLock.CreateRecordSet();
	RecordSet.Filter.Document.Set(DocRef);
	RecordSet.Clear();
	RecordSet.Write();
	
	WriteHistory(DocRef, Enums.AuditLockActions.Unlock);	
EndProcedure

Procedure WriteHistory(DocRef, Action)
	Date = CommonFunctionsServer.GetCurrentSessionDate();
	
	RecordSetHistory = InformationRegisters.AuditLockHistory.CreateRecordSet();
	RecordSetHistory.Filter.Date.Set(Date);
	RecordSetHistory.Filter.Document.Set(DocRef);
	RecordSetHistory.Filter.User.Set(SessionParameters.CurrentUser);
	
	NewRecordHistory = RecordSetHistory.Add();
	NewRecordHistory.Date = Date;
	NewRecordHistory.Document = DocRef;
	NewRecordHistory.User = SessionParameters.CurrentUser;
	
	NewRecordHistory.Action = Action;
	RecordSetHistory.Write();	
EndProcedure
