&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("MapOfSeparatedInternalSupplyRequests") Then
		FillStores(Parameters.MapOfSeparatedInternalSupplyRequests);
	Else
		Cancel = True;
	EndIf;
EndProcedure

&AtServer
Procedure FillStores(MapOfSeparatedInternalSupplyRequests)
	For Each KeyValue In MapOfSeparatedInternalSupplyRequests Do
		NewRow = ThisObject.Stores.Add();
		NewRow.Store = KeyValue.Key;
	EndDo;
EndProcedure

&AtClient
Procedure StoresUseOnChange(Item)
	CurrentRow = Items.Stores.CurrentRow;
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	CurrentData = ThisObject.Stores.FindByID(CurrentRow);
	If CurrentData.Use Then
		For Each Row In ThisObject.Stores Do
			If Row.Store = CurrentData.Store Then
				Continue;
			EndIf;
			Row.Use = False;
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure Ok(Command)
	SelectedStore = Undefined;
	For Each Row In ThisObject.Stores Do
		If Row.Use Then
			SelectedStore = Row.Store;
			Break;
		EndIf;
	EndDo;
	Close(SelectedStore);
EndProcedure

&AtClient
Procedure StoresBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure StoresBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

