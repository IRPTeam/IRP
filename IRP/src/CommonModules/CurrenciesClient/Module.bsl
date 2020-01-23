
Procedure CurrenciesTable_Selection(Object, Form, Item, RowSelected, Field, StandardProcessing) Export
	If Not ValueIsFilled(Find(Field.Name, "ShowReverseRate")) Then
		Return;
	EndIf;
	CurrentData = Form.Items[StrReplace(Field.Name, "ShowReverseRate", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.ShowReverseRate = Not CurrentData.ShowReverseRate;
	Form.Modified = True;
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Procedure CurrenciesTable_RatePresentationOnChange(Object, Form, Item) Export
	If Not ValueIsFilled(Find(Item.Name, "RatePresentation")) Then
		Return;
	EndIf;
	
	MainTableInfo = GetMainTableInfo(Object, Form, Item, "RatePresentation");
	If Not MainTableInfo.Calculate Then
		Return;
	EndIf;
	
	If MainTableInfo.CurrentData.RatePresentation = 0 Then
		MainTableInfo.CurrentData.Rate = 0;
		MainTableInfo.CurrentData.ReverseRate = 0;
	Else
		If MainTableInfo.CurrentData.ShowReverseRate Then
			MainTableInfo.CurrentData.Rate = 1 / MainTableInfo.CurrentData.RatePresentation;
			MainTableInfo.CurrentData.ReverseRate = MainTableInfo.CurrentData.RatePresentation;
		Else
			MainTableInfo.CurrentData.Rate = MainTableInfo.CurrentData.RatePresentation;
			MainTableInfo.CurrentData.ReverseRate = 1 / MainTableInfo.CurrentData.RatePresentation;
		EndIf;
	EndIf;
	Form.Currencies_CalculateAmount(MainTableInfo.Amount, MainTableInfo.CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
EndProcedure

&AtClient
Procedure CurrenciesTable_MultiplicityOnChange(Object, Form, Item) Export
	If Not ValueIsFilled(Find(Item.Name, "Multiplicity")) Then
		Return;
	EndIf;
	
	MainTableInfo = GetMainTableInfo(Object, Form, Item, "Multiplicity");
	If Not MainTableInfo.Calculate Then
		Return;
	EndIf;
	
	Form.Currencies_CalculateAmount(MainTableInfo.Amount, MainTableInfo.CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
EndProcedure

&AtClient
Procedure CurrenciesTable_AmountOnChange(Object, Form, Item) Export
	If Not ValueIsFilled(Find(Item.Name, "Amount")) Then
		Return;
	EndIf;
	
	MainTableInfo = GetMainTableInfo(Object, Form, Item, "Amount");
	If Not MainTableInfo.Calculate Then
		Return;
	EndIf;
	
	Form.Currencies_CalculateRate(MainTableInfo.Amount, MainTableInfo.CurrentData.MovementType, MainTableInfo.CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Function GetMainTableInfo(Object, Form, Item, ColumnName)
	Result = New Structure();
	Result.Insert("Calculate", False);
	Result.Insert("CurrentData", Undefined);
	Result.Insert("Amount", 0);
	
	LibraryData = CurrenciesClientServer.GetLibraryData(Object, Form, Undefined);
	CurrencyTableName = StrReplace(Item.Name, ColumnName, "");
	
	If LibraryData.Version = "1.0" Then
		
		MainTableName = StrReplace(CurrencyTableName, "Currencies", "");
		CurrentData = Form.Items[CurrencyTableName].CurrentData;
		If CurrentData <> Undefined Then
			OwnerRow = CurrenciesClientServer.FindRowByUUID(Object, MainTableName, CurrentData.Key);
			If OwnerRow <> Undefined Then
				Names = CurrenciesClientServer.ReplacePropertyNames(MainTableName, LibraryData);
				Result.Calculate = True;
				Result.CurrentData = CurrentData;
				Result.Amount = OwnerRow[Names.Columns.Amount];
			EndIf;
		EndIf;
		
	ElsIf LibraryData.Version = "2.0" Then

		MainTableName = LibraryData.MainTableName;
		CurrentData = Form.Items[CurrencyTableName].CurrentData;
		If CurrentData <> Undefined Then
			Names = CurrenciesClientServer.ReplacePropertyNames(MainTableName, LibraryData);
			Result.Calculate = True;
			Result.CurrentData = CurrentData;
			Result.Amount = Object[MainTableName].Total(Names.Columns.Amount);
		EndIf;
		
	ElsIf LibraryData.Version = "3.0" Then
	
		CurrentData = Form.Items[CurrencyTableName].CurrentData;
		If CurrentData <> Undefined Then
			Result.Calculate = True;
			Result.CurrentData = CurrentData;
			
			If CurrentData.Key = Object.SendUUID Then 
				Result.Amount = Object.SendAmount;
			ElsIf CurrentData.Key = Object.ReceiveUUID Then
				Result.Amount = Object.ReceiveAmount;
			Else
				Raise R().Exc_008;
			EndIf;
			
		EndIf;
		
	Else
		Raise R().Exc_006;
	EndIf;
	
	Return Result;
EndFunction

