
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocRef = Parameters.DocRef;
	ThisObject.Date = Parameters.DocRef.Date;
EndProcedure

&AtClient
Procedure Save(Command)
	If CheckFilling() Then
		Success = SaveAtServer();
		If Success Then
			Close(New Structure("Success", Success));
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function SaveAtServer()
	ArrayOfClosingOrders = DocOrderClosingServer.GetArrayOfClosingOrders(ThisObject.DocRef);
	HaveError = False;
	BeginTransaction();
	Try
		For Each OrderClosingRef In ArrayOfClosingOrders Do
			If ThisObject.Date >= OrderClosingRef.Date Then
				OrderClosingObject = OrderClosingRef.GetObject();
				OrderClosingObject.Date = ThisObject.Date + 1;
				OrderClosingObject.AdditionalProperties.Insert("CheckAfterWrite", False);
				OrderClosingObject.Write(DocumentWriteMode.Posting);
			EndIf;
		EndDo;
		DocObject = ThisObject.DocRef.GetObject();
		DocObject.Date = ThisObject.Date;
		DocObject.Write(?(ThisObject.DocRef.Posted, DocumentWriteMode.Posting, DocumentWriteMode.Write));
	Except
		HaveError = True;
		CommonFunctionsClientServer.ShowUsersMessage(ErrorDescription());
	EndTry;
	
	If HaveError Then
		RollbackTransaction();
	Else
		CommitTransaction();
	EndIf;
	Return Not HaveError;
EndFunction
