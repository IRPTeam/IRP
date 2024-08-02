
&AtServer
Procedure OnReadAtServer(CurrentObject)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Key.IsEmpty() Then
		SetVisibilityAvailability(Object, ThisObject);
	EndIf;
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClient
Procedure FormSetVisibilityAvailability() Export
	SetVisibilityAvailability(Object, ThisObject);
EndProcedure

&AtClientAtServerNoContext
Procedure SetVisibilityAvailability(Object, Form)
	Form.Items.EditCurrencies.Enabled = Not Form.ReadOnly;
	Form.Items.Errors.Visible = Object.Errors.Count() > 0;
EndProcedure

&AtClient
Procedure RecordsSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.Records.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	FormParams = GetRowFormParams(CurrentData.Key);
	OpenForm("Document.ExternalAccountingOperation.Form.RowForm", FormParams, ThisObject,,,,,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtServer
Function GetRowFormParams(RowKey)
	RowData = New Structure();
	Row = Object.Records.FindRows(New Structure("Key", RowKey));
	For Each Column In Metadata.Documents.ExternalAccountingOperation.TabularSections.Records.Attributes Do
		RowData.Insert(Column.Name, Row[0][Column.Name]);
	EndDo;
	Return New Structure("RowData", RowData);
EndFunction

#Region COMMANDS

&AtClient
Procedure EditCurrencies(Command)
	CurrentData = ThisObject.Items.Records.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = CurrenciesClientServer.GetParameters_V6(Object, CurrentData);
	NotifyParameters = New Structure();
	NotifyParameters.Insert("Object", Object);
	NotifyParameters.Insert("Form"  , ThisObject);
	Notify = New NotifyDescription("EditCurrenciesContinue", CurrenciesClient, NotifyParameters);
	OpenForm("CommonForm.EditCurrencies", FormParameters, , , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

&AtClient
Procedure ShowHiddenTables(Command)
	DocumentsClient.ShowHiddenTables(Object, ThisObject);
EndProcedure

#EndRegion
