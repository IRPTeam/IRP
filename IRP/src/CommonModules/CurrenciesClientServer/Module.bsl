
Function GetParameters_BP(Object, Row) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Row.Agreement);
	Parameters.Insert("RowKey"         , Row.Key);
	Parameters.Insert("DocumentAmount" , Row.Amount);
	Parameters.Insert("Currencies"     , GetCurrenciesTable_Refactoring(Object.Currencies, Row.Key));
	Return Parameters;
EndFunction

Function GetParameters_SI(Object) Export
	Parameters = New Structure();
	Parameters.Insert("Ref"            , Object.Ref);
	Parameters.Insert("Date"           , Object.Date);
	Parameters.Insert("Company"        , Object.Company);
	Parameters.Insert("Currency"       , Object.Currency);
	Parameters.Insert("Agreement"      , Object.Agreement);
	Parameters.Insert("RowKey"         , "");
	Parameters.Insert("DocumentAmount" , Object.ItemList.Total("TotalAmount"));
	Parameters.Insert("Currencies"     , GetCurrenciesTable_Refactoring(Object.Currencies));
	Return Parameters;
EndFunction

Function GetCurrenciesTable_Refactoring(Currencies, RowKey = Undefined) Export
	ArrayOfCurrenciesRows = New Array();
	For Each Row In Currencies Do
		If RowKey <> Undefined And Row.Key <> RowKey Then
			Continue;
		EndIf;
		CurrenciesRow = New Structure("Key, IsFixed, CurrencyFrom, Rate, ReverseRate,
			|ShowReverseRate, Multiplicity, MovementType, Amount");
		FillPropertyValues(CurrenciesRow, Row);
		ArrayOfCurrenciesRows.Add(CurrenciesRow);
	EndDo;
	Return ArrayOfCurrenciesRows;
EndFunction

Procedure DeleteUnusedRowsFromCurrenciesTable_Refactoring(Currencies, MainTable) Export
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

Procedure DeleteRowsByKeyFromCurrenciesTable_Refactoring(Currencies, RowKey = Undefined) Export
	ArrayForDelete = New Array();
	For Each Row In Currencies Do
		If Row.Key = RowKey Or Not ValueIsFilled(RowKey) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Currencies.Delete(ItemForDelete);
	EndDo;
EndProcedure

Procedure CalculateAmount_Refactoring(CurrenciesTable, DocumentAmount) Export
	For Each Row In CurrenciesTable Do
		If Row.Multiplicity = 0 Or Row.Rate = 0 Then
			Row.Amount = 0;
			Continue;
		EndIf;
		CalculateAmountByRow_Refactoring(Row, DocumentAmount);
	EndDo;
EndProcedure

Procedure CalculateAmountByRow_Refactoring(CurrenciesRow, DocumentAmount) Export
	If CurrenciesRow.ShowReverseRate = True Then
		CurrenciesRow.Amount = (DocumentAmount / CurrenciesRow.ReverseRate) / CurrenciesRow.Multiplicity;
	Else
		CurrenciesRow.Amount = (DocumentAmount * CurrenciesRow.Rate) / CurrenciesRow.Multiplicity;
	EndIf;
EndProcedure
