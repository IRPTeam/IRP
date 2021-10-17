
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Ref            = Parameters.Ref;
	ThisObject.Date           = Parameters.Date;
	ThisObject.Company        = Parameters.Company;
	ThisObject.Currency       = Parameters.Currency;
	ThisObject.Agreement      = Parameters.Agreement;
	ThisObject.RowKey         = Parameters.RowKey;
	ThisObject.DocumentAmount = Parameters.DocumentAmount;
	For Each Row In Parameters.Currencies Do
		FillPropertyValues(ThisObject.CurrenciesFromDocument.Add(), Row);
	EndDo;
	UpdateAtServer();
EndProcedure

&AtServer
Procedure UpdateAtServer()
	For Each Row In ThisObject.Currencies Do
		Filter = New Structure("CurrencyFrom, MovementType");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = ThisObject.CurrenciesFromDocument.FindRows(Filter);
		If ArrayOfRows.Count() Then
			For Each ItemOfArray In ArrayOfRows Do
				FillPropertyValues(ItemOfArray, Row);
			EndDo;
		Else
			FillPropertyValues(ThisObject.CurrenciesFromDocument.Add(), Row);
		EndIf;
	EndDo;
	
	UpdateParameters = New Structure();
	UpdateParameters.Insert("Ref"            , ThisObject.Ref);
	UpdateParameters.Insert("Date"           , ThisObject.Date);
	UpdateParameters.Insert("Company"        , ThisObject.Company);
	UpdateParameters.Insert("Currency"       , ThisObject.Currency);
	UpdateParameters.Insert("Agreement"      , ThisObject.Agreement);
	UpdateParameters.Insert("RowKey"         , ThisObject.RowKey);
	UpdateParameters.Insert("DocumentAmount" , ThisObject.DocumentAmount);
	UpdateParameters.Insert("Currencies"     ,
		CurrenciesClientServer.GetCurrenciesTable(ThisObject.CurrenciesFromDocument));
	
	ThisObject.Currencies.Clear();	
	CurrenciesServer.UpdateCurrencyTable(UpdateParameters, ThisObject.Currencies);
	ThisObject.Currencies.Sort("MovementType");
	For Each Row In ThisObject.Currencies Do
		Row.RatePresentation = ?(Row.ShowReverseRate, Row.ReverseRate, Row.Rate);
	EndDo;
	VisibleRows = ThisObject.Currencies.FindRows(New Structure("IsVisible", True));
	If VisibleRows.Count() Then
		ThisObject.Items.CurrenciesTable.CurrentRow = VisibleRows[0].GetID();
	EndIf;
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
Procedure Update(Command)
	UpdateAtServer();
EndProcedure

&AtClient
Procedure CurrencyRates(Command)
	CurrentData = ThisObject.Items.CurrenciesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	FormParameters = GetCurrencyRatesParameters(CurrentData.CurrencyFrom, CurrentData.MovementType);
	OpenForm("InformationRegister.CurrencyRates.ListForm", FormParameters, , , , , , FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtServerNoContext
Function GetCurrencyRatesParameters(CurrencyFrom, MovementType)
	Filter = New Structure();
	Filter.Insert("CurrencyFrom" , CurrencyFrom);
	Filter.Insert("CurrencyTo"   , MovementType.Currency);
	Filter.Insert("Source"       , MovementType.Source);
	Return New Structure("Filter", Filter);
EndFunction

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
	EndIf;
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
