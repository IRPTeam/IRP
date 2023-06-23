Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoPrivileged.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoPrivileged.OnWrite_RowID(ThisObject, Cancel);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	Return;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure OnCopy(CopiedObject)
	LinkedTables = New Array();
	DocumentsServer.SetNewTableUUID(ItemList, LinkedTables);
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	If Not ThisObject.Company.IsEmpty() And Not ThisObject.Store.IsEmpty() Then
		StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.Store, "Company");
		If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
			Cancel = True;
			MessageText = StrTemplate(
				R().Error_Store_Company,
				ThisObject.Store,
				ThisObject.Company);
			CommonFunctionsClientServer.ShowUsersMessage(
				MessageText, 
				"Object.Store", 
				"Object");
		EndIf;
	EndIf;
		
EndProcedure