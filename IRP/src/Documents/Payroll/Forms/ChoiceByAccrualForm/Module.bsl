
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.Parameters.SetParameterValue("Company"  , Parameters.Company);
	ThisObject.List.Parameters.SetParameterValue("Branch"   , Parameters.Branch);
	ThisObject.List.Parameters.SetParameterValue("Currency" , Parameters.Currency);
	ThisObject.List.Parameters.SetParameterValue("ArrayOfEmployee" , Parameters.ArrayOfEmployee);
	If ValueIsFilled(Parameters.Ref) Then
		ThisObject.List.Parameters.SetParameterValue("Boundary" , 
			New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding));
	Else
		ThisObject.List.Parameters.SetParameterValue("Boundary" , 
			CommonFunctionsServer.GetCurrentSessionDate());
	EndIf;		
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	ProceedSelectedRows();
EndProcedure

&AtClient
Procedure Select(Command)
	ProceedSelectedRows();
EndProcedure

&AtClient
Procedure ProceedSelectedRows()
	ArrayOfDataRows = New Array();
	For Each Row In Items.List.SelectedRows Do
		NewRow = New Structure("Employee, PaymentPeriod, CalculationType, Amount");
		FillPropertyValues(NewRow, Items.List.RowData(Row));
		If NewRow.Amount > 0 Then
			ArrayOfDataRows.Add(NewRow);
		EndIf;
	EndDo;
	If ArrayOfDataRows.Count() > 0 Then
		Close(New Structure("ArrayOfDataRows", ArrayOfDataRows));
	EndIf;
EndProcedure
