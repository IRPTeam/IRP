
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocRef = Parameters.DocRef;
	ThisObject.Date = Parameters.DocRef.Date;
	UpdateOrerClosingTable();
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

&AtClient
Procedure DateOnChange(Item)
	UpdateOrerClosingTable();
EndProcedure

&AtClient
Procedure OrderClosingTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure OrderClosingTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtServer
Procedure UpdateOrerClosingTable()
	ArrayOfClosingOrders = DocOrderClosingServer.GetArrayOfClosingOrders(ThisObject.DocRef);
	ThisObject.OrderClosingTable.Clear();
	For Each ClosingOrder in ArrayOfClosingOrders Do
		NewRow = ThisObject.OrderClosingTable.Add();
		NewRow.DocRef = String(ClosingOrder); 
		NewRow.Icon = 1;
	EndDo;
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
		If Not DocObject.CheckFilling() Then
			Raise "";
		EndIf;
		DocObject.Write(?(ThisObject.DocRef.Posted, DocumentWriteMode.Posting, DocumentWriteMode.Write));
	Except
		HaveError = True;
		ThisObject.Items.Expander.Visible = True;
		CommonFunctionsClientServer.ShowUsersMessage(ErrorDescription());
	EndTry;
	
	If HaveError Then
		RollbackTransaction();
	Else
		CommitTransaction();
		RefreshReusableValues();
	EndIf;
	Return Not HaveError;
EndFunction
