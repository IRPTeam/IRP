&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", New Structure("Basises, Ref", CommandParameter, PredefinedValue(
		"Document.PurchaseReturnOrder.EmptyRef")));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
	FormParameters.Insert("SetAllCheckedOnOpen", True);

	OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
		New NotifyDescription("AddDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure AddDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each FillingValues In Result.FillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.PurchaseReturnOrder.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure