
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If ValueIsFilled(Parameters.Ref) Then
		ThisObject.List.Parameters.SetParameterValue("Period", 
			New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding));
	EndIf;
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	SelectAtClient();
EndProcedure

&AtClient
Procedure Select(Command)
	SelectAtClient();
EndProcedure

&AtClient
Procedure SelectAtClient()
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Result = New Structure();
	Result.Insert("Document", CurrentData.Document);
	Result.Insert("Order"   , CurrentData.InvoiceOrder);
	Result.Insert("Amount"  , CurrentData.Advance);
	
	Close(Result);
EndProcedure