
Procedure CurrenciesTable_Selection(Object, Form, Item, RowSelected, Field, StandardProcessing, AddInfo = Undefined) Export	
	If Not ValueIsFilled(StrFind(Field.Name, "ShowReverseRate")) Then
		Return;
	EndIf;
	CurrentData = Form.Items[StrReplace(Field.Name, "ShowReverseRate", "")].CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	CurrentData.ShowReverseRate = Not CurrentData.ShowReverseRate;
	Form.Modified = True;
	
	If ExecuteAtClient(AddInfo) Then
		SetRatePresentation(Object, Form, AddInfo);
		Return;
	EndIf;
		
	// legacy code compatibility
	
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Procedure CurrenciesTable_RatePresentationOnChange(Object, Form, Item, AddInfo = Undefined) Export
	If Not ValueIsFilled(StrFind(Item.Name, "RatePresentation")) Then
		Return;
	EndIf;
	
	If ExecuteAtClient(AddInfo) Then
		CurrentData = Form.Items.ObjectCurrencies.CurrentData;
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
		CalculateAmount(Object, Form, AddInfo);
		SetRatePresentation(Object, Form, AddInfo);
		Return;
	EndIf;
	
	// legacy code compatibility
	
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

Procedure CurrenciesTable_MultiplicityOnChange(Object, Form, Item, AddInfo = Undefined) Export
	If Not ValueIsFilled(StrFind(Item.Name, "Multiplicity")) Then
		Return;
	EndIf;
	
	If ExecuteAtClient(AddInfo) Then
		CalculateAmount(Object, Form, AddInfo);
		SetRatePresentation(Object, Form, AddInfo);
		Return;
	EndIf;
	
	// legacy code compatibility
	
	MainTableInfo = GetMainTableInfo(Object, Form, Item, "Multiplicity");
	If Not MainTableInfo.Calculate Then
		Return;
	EndIf;
	
	Form.Currencies_CalculateAmount(MainTableInfo.Amount, MainTableInfo.CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Procedure CurrenciesTable_AmountOnChange(Object, Form, Item, AddInfo = Undefined) Export
	If Not ValueIsFilled(StrFind(Item.Name, "Amount")) Then
		Return;
	EndIf;
	
	If ExecuteAtClient(AddInfo) Then
		CurrentData = Form.Items.ObjectCurrencies.CurrentData;
		If CurrentData = Undefined Then
			Return;
		EndIf;
		
		TotalAmount = Object.ItemList.Total("TotalAmount");
		CalculateRate(Object, Form, TotalAmount, CurrentData.MovementType, CurrentData.Key, Undefined, AddInfo);
		SetRatePresentation(Object, Form, AddInfo);
		Return;
	EndIf;
	
	// legacy code compatibility
	
	MainTableInfo = GetMainTableInfo(Object, Form, Item, "Amount");
	If Not MainTableInfo.Calculate Then
		Return;
	EndIf;
	
	Form.Currencies_CalculateRate(MainTableInfo.Amount, MainTableInfo.CurrentData.MovementType, MainTableInfo.CurrentData.Key);
	Form.Currencies_UpdateRatePresentation();
EndProcedure

Function GetMainTableInfo(Object, Form, Item, ColumnName)
	Result = New Structure;
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

Function ExecuteAtClient(AddInfo)
	Return CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ExecuteAtClient") <> Undefined 
		And AddInfo.ExecuteAtClient;
EndFunction

Procedure FullRefreshTable(Object, Form, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	ClearTable(Object, Form, Undefined, AddInfo);
	FillTable(Object, Form, ServerData.ArrayOfCurrenciesRows, AddInfo);
	CalculateAmount(Object, Form, AddInfo);
	SetRatePresentation(Object, Form);
	SetVisibleRows(Object, Form, AddInfo);
EndProcedure	

Procedure SerFaceTable(Object, Form, AddInfo = Undefined) Export
	SetRatePresentation(Object, Form);
	SetVisibleRows(Object, Form, AddInfo);	
EndProcedure	

Procedure ClearTable(Object, Form, RowKey = Undefined, AddInfo = Undefined) Export
	If RowKey = Undefined Then
		Object.Currencies.Clear();
	Else
		ArrayForDelete = New Array();
		For Each Row In Object.Currencies Do
			If Row.Key = RowKey Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			Object.Currencies.Delete(ItemForDelete);
		EndDo;
	EndIf;
EndProcedure

Procedure FillTable(Object, Form, ArrayOfCurrenciesRows, AddInfo = Undefined) Export
	For Each ItemOfCurrenciesRows In ArrayOfCurrenciesRows Do
		FillPropertyValues(Object.Currencies.Add(), ItemOfCurrenciesRows);
	EndDo;
EndProcedure

Procedure CalculateAmount(Object, Form, AddInfo = Undefined) Export
	For Each Row In Object.Currencies Do
		If Row.Multiplicity = 0 Or Row.Rate = 0 Then
			Row.Amount = 0;
			Continue;
		EndIf;
		DocumentAmount = Object.ItemList.Total("TotalAmount");
		
		If Row.ShowReverseRate Then
			Row.Amount = (DocumentAmount * Row.ReverseRate) / Row.Multiplicity;
		Else
			Row.Amount = DocumentAmount / (Row.Rate * Row.Multiplicity);
		EndIf;
	EndDo;
EndProcedure

Procedure CalculateRate(Object, Form, DocumentAmount, MovementType, RowKeyFilter, CurrencyFilter = Undefined, AddInfo = Undefined) Export
	For Each Row In Object.Currencies Do
		If Row.MovementType <> MovementType Then
			Continue;
		EndIf;
		If RowKeyFilter <> Undefined And Row.Key <> RowKeyFilter Then
			Continue;
		EndIf;
		If CurrencyFilter <> Undefined And Row.CurrencyFrom <> CurrencyFilter Then
			Continue;
		EndIf;
		
		If Row.Amount = 0 Or Row.Multiplicity  = 0 Then
			Row.Rate = 0;
			Continue;
		EndIf;
		Row.ReverseRate = Row.Amount * Row.Multiplicity / DocumentAmount;		
		Row.Rate = DocumentAmount / (Row.Amount * Row.Multiplicity);
	EndDo;
EndProcedure

Procedure SetRatePresentation(Object, Form, AddInfo = Undefined) Export
	For Each Row In Object.Currencies Do
		Row.RatePresentation = ?(Row.ShowReverseRate, Row.ReverseRate, Row.Rate);
	EndDo;
EndProcedure

Procedure SetVisibleRows(Object, Form, AddInfo = Undefined) Export
	ServerData = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "ServerData");
	
	For Each Row In Object.Currencies Do
		For Each ItemOfArray In ServerData.ArrayOfCurrenciesByMovementTypes Do
			If ItemOfArray.MovementType = Row.MovementType Then
				Row.IsVisible = Row.CurrencyFrom <> ItemOfArray.Currency;
				Break;
			EndIf;
		EndDo;
	EndDo;
EndProcedure
