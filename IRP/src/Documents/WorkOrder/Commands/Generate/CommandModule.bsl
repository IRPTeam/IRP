
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters) 
	ArrayOf_SalesOrder = New Array;
	ArrayOf_Issue = New Array;
	For Each Basis In CommandParameter Do
		If TypeOf(Basis) = Type("DocumentRef.SalesOrder") Then
			ArrayOf_SalesOrder.Add(Basis);
		Else
			ArrayOf_Issue.Add(Basis);
		EndIf;	
	EndDo;
	
	If ArrayOf_SalesOrder.Count() > 0 Then
		FormParameters = New Structure();
		FormParameters.Insert("Filter", New Structure("Basises, Ref", ArrayOf_SalesOrder, PredefinedValue("Document.WorkOrder.EmptyRef")));
		FormParameters.Insert("TablesInfo", RowIDInfoClient.GetTablesInfo());
		FormParameters.Insert("SetAllCheckedOnOpen", True);

		OpenForm("CommonForm.AddLinkedDocumentRows", FormParameters, , , , ,
			New NotifyDescription("AddDocumentRowsContinue", ThisObject), FormWindowOpeningMode.LockOwnerWindow);
	ElsIf ArrayOf_Issue.Count() > 0 Then       
		FillingValues = New Structure;
		FillingValues.Insert("BasedOn", ArrayOf_Issue);
		FillingValues.Insert("BasedOnType", PredefinedValue("Document.Issue.EmptyRef"));
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.WorkOrder.ObjectForm", FormParameters, , New UUID());	
	EndIf;

EndProcedure

&AtClient
Procedure AddDocumentRowsContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each FillingValues In Result.FillingValues Do
		FormParameters = New Structure("FillingValues", FillingValues);
		OpenForm("Document.WorkOrder.ObjectForm", FormParameters, , New UUID());
	EndDo;
EndProcedure