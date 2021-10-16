
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentAmount = Parameters.DocumentAmount;
	ThisObject.RowKey = Parameters.RowKey;
	CurrenciesServer.UpdateCurrencyTable(Parameters, ThisObject.Currencies);
	ThisObject.Currencies.Sort("MovementType");
	For Each Row In ThisObject.Currencies Do
		Row.RatePresentation = ?(Row.ShowReverseRate, Row.ReverseRate, Row.Rate);
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("Currencies", CurrenciesClientServer.GetCurrenciesTable(ThisObject.Currencies));
	Result.Insert("RowKey", ThisObject.RowKey);
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure CurrenciesTableSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = ThisObject.Items.CurrenciesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("CurrenciesTableShowReverseRate") Then
		CurrentData.ShowReverseRate = Not CurrentData.ShowReverseRate;
		CurrentData.RatePresentation = ?(CurrentData.ShowReverseRate, CurrentData.ReverseRate, CurrentData.Rate);
	EndIf;
	If Upper(Field.Name) = Upper("CurrenciesTableIsFixed") Then
		CurrentData.IsFixed = Not CurrentData.IsFixed;
	Endif;
	If Not CurrentData.IsFixed Then
		CurrentData.Rate             = CurrentData.RateOrigin;
		CurrentData.ReverseRate      = CurrentData.ReverseRateOrigin;
		CurrentData.Multiplicity     = CurrentData.MultiplicityOrigin;
		CurrentData.RatePresentation = ?(CurrentData.ShowReverseRate, CurrentData.ReverseRate, CurrentData.Rate);
		CurrenciesClientServer.CalculateAmount(ThisObject.Currencies, ThisObject.DocumentAmount);
	EndIf;
EndProcedure

&AtClient
Procedure CurrenciesTableBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesTableBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesTableRatePresentationOnChange(Item)
	CurrentData = ThisObject.Items.CurrenciesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If CurrentData.RatePresentation = 0 Then
		CurrentData.Rate = 0;
		CurrentData.ReverseRate = 0;
	Else
		If CurrentData.ShowReverseRate Then
			CurrentData.Rate = 1 / CurrentData.RatePresentation;
			CurrentData.ReverseRate = CurrentData.RatePresentation;
		Else
			CurrentData.Rate = CurrentData.RatePresentation;
			CurrentData.ReverseRate = 1 / CurrentData.RatePresentation;
		EndIf;
	EndIf;
	CurrenciesClientServer.CalculateAmount(ThisObject.Currencies, ThisObject.DocumentAmount);
	CurrentData.IsFixed = True;
EndProcedure

&AtClient
Procedure CurrenciesTableMultiplicityOnChange(Item)
	CurrentData = ThisObject.Items.CurrenciesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrenciesClientServer.CalculateAmount(ThisObject.Currencies, ThisObject.DocumentAmount);
	CurrentData.IsFixed = True;
EndProcedure

&AtClient
Procedure CurrenciesTableAmountOnChange(Item)
	CurrentData = ThisObject.Items.CurrenciesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	If CurrentData.Amount = 0 Or CurrentData.Multiplicity = 0 Then
		CurrentData.Rate = 0;
		CurrentData.ReverseRate = 0;
		Return;
	EndIf;
	CurrentData.Rate = CurrentData.Amount * CurrentData.Multiplicity / ThisObject.DocumentAmount;
	CurrentData.ReverseRate = ThisObject.DocumentAmount / (CurrentData.Amount * CurrentData.Multiplicity);
	CurrentData.RatePresentation = ?(CurrentData.ShowReverseRate, CurrentData.ReverseRate, CurrentData.Rate);
	CurrentData.IsFixed = True;
EndProcedure

&AtClient
Procedure ShowRowKey(Command)
	DocumentsClient.ShowRowKey(ThisObject);
EndProcedure

