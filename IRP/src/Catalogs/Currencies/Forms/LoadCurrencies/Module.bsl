
&AtClient
Procedure OnOpen(Cancel)
	AttachIdleHandler("LoadCurrencyList", 0.1, True);
EndProcedure

&AtClient
Procedure CreateSelected(Command)
	RowIDList = New Array;
	For Each RowID In Items.CurrencyList.SelectedRows Do
		RowIDList.Add(RowID);
	EndDo;
	CreateSelectedAtServer(RowIDList);
	
	NotifyChanged(Type("CatalogRef.Currencies"));
EndProcedure

&AtServer
Procedure CreateSelectedAtServer(RowIDList)
	
	For Each RowID In RowIDList Do
		Row = CurrencyList.FindByID(RowID);
		If Row.Exists Then
			Continue;
		EndIf; 
		
		Currency = CommonFunctionsServer.DeserializeXMLUseXDTO(Row.Data).Get().Value;
		
		NewCurrency = Catalogs.Currencies.CreateItem();
		NewCurrency.Code = Currency.iso.code;
		NewCurrency.NumericCode = Currency.iso.number;
		NewCurrency.Symbol = Currency.units.major.name;
		NewCurrency.Description_en = Currency.Name;
		
		NewCurrency.Write();
		Row.Exists = True;
	EndDo;
EndProcedure

&AtClient
Procedure LoadCurrencyList()
	LoadCurrencyListAtServer();
	Items.GroupLoading.Visible = False;
EndProcedure

&AtServer
Procedure LoadCurrencyListAtServer()
	ZIP = Catalogs.Currencies.GetTemplate("CurrencyList");
	JSONBD = CommonFunctionsServer.StringFromBase64ZIP(ZIP);
	JSON = GetStringFromBinaryData(JSONBD);
	CurrencyData = CommonFunctionsServer.DeserializeJSON(JSON); // Array Of Structure
	
	For Each Currency In CurrencyData Do
		NewRow = CurrencyList.Add();
		NewRow.Code = Currency.Key;
		NewRow.Description = Currency.Value.name;
		NewRow.NumericCode = Currency.Value.iso.number;
		NewRow.Symbol = Currency.Value.units.major.symbol;
		NewRow.Exists = Not Catalogs.Currencies.FindByCode(NewRow.Code).IsEmpty();
		NewRow.Data = CommonFunctionsServer.SerializeXMLUseXDTO(New ValueStorage(Currency, New Deflation(9)));
	EndDo;
	
EndProcedure