
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.DocumentAmount = Parameters.DocumentAmount;
	ThisObject.RowKey = Parameters.RowKey;
	CurrenciesServer.UpdateCurrencyTable_Refactoring(Parameters, ThisObject.Currencies);
	ThisObject.Currencies.Sort("MovementType");
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("Currencies", CurrenciesClientServer.GetCurrenciesTable_Refactoring(ThisObject.Currencies));
	Result.Insert("RowKey", ThisObject.RowKey);
	Close(Result);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtClient
Procedure CurrenciesSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = ThisObject.Items.Currencies.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("CurrenciesShowReverseRate") Then
		CurrentData.ShowReverseRate = Not CurrentData.ShowReverseRate;
		CurrentData.RatePresentation = ?(CurrentData.ShowReverseRate, CurrentData.ReverseRate, CurrentData.Rate);
	EndIf;
	If Upper(Field.Name) = Upper("CurrenciesIsFixed") Then
		CurrentData.IsFixed = Not CurrentData.IsFixed;
	Endif;
	If Not CurrentData.IsFixed Then
		CurrentData.Rate             = CurrentData.RateOrigin;
		CurrentData.ReverseRate      = CurrentData.ReverseRateOrigin;
		CurrentData.Multiplicity     = CurrentData.MultiplicityOrigin;
		CurrentData.RatePresentation = ?(CurrentData.ShowReverseRate, CurrentData.ReverseRate, CurrentData.Rate);
		CurrenciesClientServer.CalculateAmount_Refactoring(ThisObject.Currencies, ThisObject.DocumentAmount);
	EndIf;
EndProcedure

&AtClient
Procedure CurrenciesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure CurrenciesRatePresentationOnChange(Item)
	CurrentData = ThisObject.Items.Currencies.CurrentData;
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
	CurrenciesClientServer.CalculateAmount_Refactoring(ThisObject.Currencies, ThisObject.DocumentAmount);
	CurrentData.IsFixed = True;
EndProcedure

&AtClient
Procedure CurrenciesMultiplicityOnChange(Item)
	CurrentData = ThisObject.Items.Currencies.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrenciesClientServer.CalculateAmount_Refactoring(ThisObject.Currencies, ThisObject.DocumentAmount);
	CurrentData.IsFixed = True;
EndProcedure

&AtClient
Procedure CurrenciesAmountOnChange(Item)
	CurrentData = ThisObject.Items.Currencies.CurrentData;
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
