&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	JorDocumentsServer.OnCreateAtServer(Cancel, StandardProcessing, ThisObject, Parameters);
EndProcedure

&AtClient
Procedure CommandSelect(Command)
	Close(GetSelectedData());
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	Close(GetSelectedData());
EndProcedure

&AtClient
Function GetSelectedData()
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	SelectedData = New Structure();
	SelectedData.Insert("BasisDocument" , CurrentData.Ref);
	SelectedData.Insert("Partner"       , CurrentData.Partner);
	SelectedData.Insert("Agreement"     , CurrentData.Agreement);
	SelectedData.Insert("Currency"      , CurrentData.Currency);
	SelectedData.Insert("LegalName"     , CurrentData.LegalName);
	SelectedData.Insert("Amount"        , CurrentData.DocumentAmount);
	Return SelectedData;
EndFunction
