&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FormParameters = New Structure();
	FormParameters.Insert("Filter", New Structure("Basises, Ref", CommandParameter, PredefinedValue(
		"Document.InventoryTransfer.EmptyRef")));
	FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
	FormParameters.Insert("SetAllCheckedOnOpen", True);

	IsPI = False;
	For Each DocRef In CommandParameter Do
		If TypeOf(DocRef) = Type("DocumentRef.PurchaseInvoice") Then
			IsPI = True;
			Break;
		EndIf;
	EndDo;
	If IsPI Then
		BasedOnStructure = New Structure;
		BasedOnStructure.Insert("BasedOn", "PurchaiceInvoice");
		BasedOnStructure.Insert("Basis", CommandParameter);
		
		ParametersStructure = New Structure;
		ParametersStructure.Insert("Basis", BasedOnStructure);
		
		OpenForm("Document.InventoryTransfer.ObjectForm", ParametersStructure);
		Return;
	EndIf;
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
		OpenForm("Document.InventoryTransfer.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure