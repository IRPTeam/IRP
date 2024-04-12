
&AtClient
Procedure DescriptionStartChoice(Item, ChoiceData, StandardProcessing)
	
	StandardProcessing = False;
	CallbackDescription = New NotifyDescription("AfterDocTypeSelect", ThisObject, New Structure);
	OpenForm(
		"Catalog.AttachedDocumentSettings.Form.FormChoiseDocsName", 
		,
		,
		,
		,
		,
		CallbackDescription,
		FormWindowOpeningMode.LockOwnerWindow);	
	
EndProcedure

&AtClient
Procedure AfterDocTypeSelect(Result, AdditionalParameters) Export
	
	If Result <> Undefined Then
		Object.Description = Result;
	EndIf;	
	
EndProcedure	
