
#Region SetUnset

Procedure SetLock(DocRef) Export
	If Not (IsInRole(Metadata.Roles.AuditLockSet) OR IsInRole(Metadata.Roles.FullAccess)) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_003);
		Return;
	EndIf;
	
	If DocRef.Metadata().Posting = Metadata.ObjectProperties.Posting.Allow
		And Not DocRef.Posted Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_005);
		Return;			
	EndIf;
	
	If DocRef.DeletionMark Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_006);
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

#EndRegion

#Region CheckSet

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

#EndRegion

#Region Events

Procedure BeforeWrite_AuditLockBeforeWrite(Source, Cancel, WriteMode, PostingMode) Export
	If DocumentAttributesChanged(Source) Then
		Cancel = True;
	EndIf;
EndProcedure

// Document attributes changed.
// 
// Parameters:
//  Source - DocumentObject - Source
// 
// Returns:
//  Boolean - Document attributes changed
Function DocumentAttributesChanged(Source)
	
	If Source.Ref.IsEmpty() Then
		Return False;
	EndIf;
	
	RefLocked = LockIsSet(Source.Ref);
	SourceCopy = Source.Ref.GetObject();
	
	If Not RefLocked And 
			(TypeOf(Source.Ref) = Type("DocumentRef.RetailSalesReceipt")
				Or TypeOf(Source.Ref) = Type("DocumentRef.RetailReturnReceipt")) Then
		RefLocked = 
			ValueIsFilled(SourceCopy.ConsolidatedRetailSales) 
				And LockIsSet(SourceCopy.ConsolidatedRetailSales);
	EndIf;
	
	If Not RefLocked Then
		Return False;
	EndIf;
		
	FullCheck = True;
	AllAttributes = CatConfigurationMetadataServer.GetAttributeNamesByObject(Source);
	NotAuditAttributes = CatConfigurationMetadataServer.GetCustomizedAttributesByObject(Source).NotAudit;
	For Each TableKV In NotAuditAttributes Do
		TableName = TableKV.Key;
		For Each AttributeName In TableKV.Value Do
			If TableName = "" Then
				AllAttributes.Attributes.Delete(AttributeName);
			Else
				AllAttributes.Tables[TableName].Attributes.Delete(AttributeName);
			EndIf;
			FullCheck = False;
		EndDo;
	EndDo;
	
	ChangedAttributes = New Array();
	
	For Each AttributeKV In AllAttributes.Attributes Do
		AttributeName = AttributeKV.Key;
		If Source[AttributeName] <> SourceCopy[AttributeName]  Then
			ChangedAttributes.Add(AttributeKV.Value);
		EndIf;
	EndDo;
	
	For Each TableKV In AllAttributes.Tables Do
		TableName = TableKV.Key;
		SourceTable = Source[TableName]; // TabularSection
		CopyTable = SourceCopy[TableName]; // TabularSection
		If SourceTable.Count() <> CopyTable.Count() Then
			ChangedAttributes.Add("[" + TableKV.Value.Synonym + "]");
		Else
			TableAttributes = TableKV.Value.Attributes;
			For Index = 0 To SourceTable.Count() - 1 Do
				For Each AttributeKV In TableAttributes Do
					AttributeName = AttributeKV.Key;
					If SourceTable[Index][AttributeName] <> CopyTable[Index][AttributeName]  Then
						ChangedAttributes.Add(StrTemplate("[%1][%2][%3]",
							TableKV.Value.Synonym, Index + 1, AttributeKV.Value));
					EndIf;
				EndDo;
			EndDo;
		EndIf;
	EndDo;

	If ChangedAttributes.Count() > 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().AuditLock_004);
		If Not FullCheck Then
			CommonFunctionsClientServer.ShowUsersMessage(
				StrTemplate(R().SDR_AuditLockChangedAttributes, StrConcat(ChangedAttributes, ", ")));
		EndIf;
		Return True;
	EndIf;

	Return False;
	
EndFunction

#EndRegion
