&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", New Structure("Basises, Ref", CommandParameter, PredefinedValue(
		"Document.InventoryTransfer.EmptyRef")));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
	FormParameters.Insert("SetAllCheckedOnOpen", True);
	
	If TypeOf(CommandParameter[0]) = Type("DocumentRef.PurchaseInvoice") Then
		Result = DocInventoryTransferServer.GetDataFromPI(CommandParameter);
		AddDocumentRowsContinue(Result, New Structure);
	Else
		OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
			New NotifyDescription("AddDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
	EndIf;
EndProcedure
	
&AtClient
Procedure AddDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each FillingValues In Result.FillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.InventoryTransfer.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure