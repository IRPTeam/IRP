&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", 
		New Structure("Basises, Ref", CommandParameter, 
		PredefinedValue("Document.GoodsReceipt.EmptyRef")));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
	FormParameters.Insert("SetAllCheckedOnOpen", True);
	RowIDInfoClient.OpenForm_AddLinkedDocumentRows(Undefined, ThisObject, FormParameters, "AddDocumentRowsContinue");
EndProcedure

&AtClient
Procedure AddDocumentRowsContinue(Result, NotifyParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each FillingValues In Result.FillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.GoodsReceipt.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure