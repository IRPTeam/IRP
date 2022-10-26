Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
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
