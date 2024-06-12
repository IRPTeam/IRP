
Function GetParameters_V2(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	Parameters.Insert("Agreement"      , Undefined);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.TotalAmount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V3(Object) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Object.Agreement);
	Parameters.Insert("RowKey"         , "");
	Parameters.Insert("DocumentAmount" , Object.ItemList.Total("TotalAmount"));
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies));
	Return Parameters;
EndFunction

Function GetParameters_V4(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	Parameters.Insert("Agreement"      , Row.Agreement);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V5(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Undefined);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V6(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	Parameters.Insert("Agreement"      , Undefined);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V7(Object, RowKey, Currency, Amount, Agreement = Undefined) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Currency);
	Parameters.Insert("Agreement"      , Agreement);
	Parameters.Insert("RowKey"         , RowKey);
	Parameters.Insert("DocumentAmount" , Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, RowKey));
	Return Parameters;
EndFunction

Function GetParameters_V8(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Row.Agreement);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.TotalAmount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V9(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	Parameters.Insert("Agreement"      , Object.AgreementConsignor);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V10(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	If ValueIsFilled(Row.Invoice) Then
		Parameters.Insert("Agreement"      , Row.Invoice.Agreement);
	Else
		Parameters.Insert("Agreement"      , Undefined);
	EndIf;
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.TotalAmount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V11(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Row.Currency);
	Parameters.Insert("Agreement"      , Undefined);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.BalanceAmount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_V12(Object) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Undefined);
	Parameters.Insert("RowKey"         , "");
	Parameters.Insert("DocumentAmount" , Object.CostList.Total("Amount"));
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies));
	Return Parameters;
EndFunction

Function GetParameters_V13(Object) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Object.Agreement);
	Parameters.Insert("RowKey"         , Undefined);
	Parameters.Insert("DocumentAmount" , Object.TaxesDifference.Total("Amount"));
	Parameters.Insert("Currencies"     , GetCurrenciesTable(Object.Currencies));
	Return Parameters;
EndFunction

Function GetCurrenciesTable(Currencies, RowKey = Undefined) Export
	ArrayOfCurrenciesRows = New Array();
	RowColumns = "Key, IsFixed, CurrencyFrom, Rate, ReverseRate,
				|ShowReverseRate, Multiplicity, MovementType, Amount";
	
	If RowKey = Undefined Then
		For Each Row In Currencies Do
			CurrenciesRow = New Structure(RowColumns);
			FillPropertyValues(CurrenciesRow, Row);
			ArrayOfCurrenciesRows.Add(CurrenciesRow);
		EndDo;
	Else
		FilteredCurrencies = Currencies.FindRows(New Structure("Key", RowKey));
		For Each Row In FilteredCurrencies Do
			CurrenciesRow = New Structure(RowColumns);
			FillPropertyValues(CurrenciesRow, Row);
			ArrayOfCurrenciesRows.Add(CurrenciesRow);			
		EndDo;
	EndIf;
	
	Return ArrayOfCurrenciesRows;
EndFunction

Procedure DeleteUnusedRowsFromCurrenciesTable(Currencies, MainTable) Export
	ArrayForDelete = New Array();
	For Each Row In Currencies Do
		If Not MainTable.FindRows(New Structure("Key", Row.Key)).Count() Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Currencies.Delete(ItemForDelete);
	EndDo;
EndProcedure

Procedure DeleteRowsByKeyFromCurrenciesTable(Currencies, RowKey = Undefined) Export
	ArrayForDelete = New Array();
	If Not ValueIsFilled(RowKey) Then
		For Each Row In Currencies Do
			ArrayForDelete.Add(Row);
		EndDo;
	Else
		FilteredCurrencies = Currencies.FindRows(New Structure("Key", RowKey));
		For Each Row In FilteredCurrencies Do
			ArrayForDelete.Add(Row);
		EndDo;
	EndIf;
	For Each ItemForDelete In ArrayForDelete Do
		Currencies.Delete(ItemForDelete);
	EndDo;
EndProcedure

Procedure CalculateAmount(CurrenciesTable, DocumentAmount) Export
	For Each Row In CurrenciesTable Do
		If Row.Multiplicity = 0 Or Row.Rate = 0 Then
			Row.Amount = 0;
			Continue;
		EndIf;
		CalculateAmountByRow(Row, DocumentAmount);
	EndDo;
EndProcedure

Procedure CalculateAmountByRow(CurrenciesRow, DocumentAmount) Export
	If CurrenciesRow.ShowReverseRate = True Then
		CurrenciesRow.Amount = (DocumentAmount / CurrenciesRow.ReverseRate) / CurrenciesRow.Multiplicity;
	Else
		CurrenciesRow.Amount = (DocumentAmount * CurrenciesRow.Rate) / CurrenciesRow.Multiplicity;
	EndIf;
EndProcedure
