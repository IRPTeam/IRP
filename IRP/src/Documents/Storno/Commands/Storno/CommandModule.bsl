
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	StornoRef = DocStornoServer.IsDocumentWithStorno(CommandParameter);
	If ValueIsFilled(StornoRef) Then
		Callback = New CallbackDescription("ShowQueryBox_OpenExistsEnd", ThisObject, New Structure("StornoRef", StornoRef));
		ShowQueryBox(Callback, R().QuestionToUser_034 , QuestionDialogMode.YesNo);
	Else
		If Not CommonFunctionsServer.GetRefAttribute(CommandParameter, "Posted") Then
			ShowMessageBox(,R().InfoMessage_PostingDocument);
		Else
			OpenFormNewStornoDocument(CommandParameter);
		EndIf;
	Endif;
EndProcedure

&AtClient
Procedure ShowQueryBox_OpenExistsEnd(Result, Params) Export
	If Result = DialogReturnCode.Yes Then
		OpenFormExistsStornoDocument(Params.StornoRef);
	EndIf;
EndProcedure

&AtClient
Procedure OpenFormNewStornoDocument(Basis)
	FormParameters = New Structure("FillingValues", 
		New Structure("Company, Basis", CommonFunctionsServer.GetRefAttribute(Basis, "Company"), Basis));
	OpenForm("Document.Storno.ObjectForm", FormParameters);	
EndProcedure

&AtClient
Procedure OpenFormExistsStornoDocument(StornoRef)
	FormParameters = New Structure("Key", StornoRef);
	OpenForm("Document.Storno.ObjectForm", FormParameters);
EndProcedure
