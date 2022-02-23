
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	List.Parameters.SetParameterValue("Company", Parameters.Company);
	List.Parameters.SetParameterValue("CurrencyMovementType", ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency);
	List.Parameters.SetParameterValue("SelectedDocuments", Parameters.SelectedDocuments);
	BalancePeriod = Undefined;
	If ValueIsFilled(Parameters.Ref) And Parameters.Ref.Posted Then
		BalancePeriod = New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		BalancePeriod = EndOfDay(Parameters.Date);
	EndIf;
	List.Parameters.SetParameterValue("BalancePeriod", BalancePeriod);
EndProcedure

&AtClient
Function GetSelectedData()
	CurrentData = Items.List.CurrentData;
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	SelectedData = New Structure();
	SelectedData.Insert("Document" , CurrentData.Basis);
	SelectedData.Insert("Currency" , CurrentData.Currency);
	SelectedData.Insert("Amount"   , CurrentData.Amount);
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

