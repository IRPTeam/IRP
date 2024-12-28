Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
		
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("BasedOn") Then
		ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
		Filling_BasedOn(FillingData);
	EndIf;
EndProcedure

Procedure Filling_BasedOn(FillingData)
	FillPropertyValues(ThisObject, FillingData);
	For Each Row In FillingData.ItemList Do
		NewRow = ThisObject.ItemList.Add();
		FillPropertyValues(NewRow, Row);
		If Not ValueIsFilled(NewRow.Key) Then
			NewRow.Key = New UUID();
		EndIf;
	EndDo;
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
