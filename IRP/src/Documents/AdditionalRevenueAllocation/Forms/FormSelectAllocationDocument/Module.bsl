
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	List.Parameters.SetParameterValue("Company", Parameters.Company);
EndProcedure

&AtClient
Function GetSelectedData()
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	SelectedData = New Structure();
	SelectedData.Insert("Document" , CurrentData.Basis);
	Return SelectedData;	
EndFunction

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	Close(GetSelectedData());
EndProcedure

&AtClient
Procedure Select(Command)
	Close(GetSelectedData());
EndProcedure


