
// Fill check processing

Procedure FillCheckProcessing_Purchase(Cancel, ItemList, TransactionType) Export
	ConsignorsByItemListTable = GetConsignorsByItemList(ItemList);
	Filter = New Structure("IsOwnStocks", False);
	ErrorRows = ConsignorsByItemListTable.FindRows(Filter);
	For Each ErrorRow In ErrorRows Do
		ErrorMessage = StrTemplate(R().Error_129, TransactionType, ErrorRow.Item, ErrorRow.ItemKey, ErrorRow.Consignor);
		CommonFunctionsClientServer.ShowUsersMessage(
			ErrorMessage, "Object.ItemList[" + (ErrorRow.LineNumber - 1) + "].ItemKey", "Object.ItemList");
		Cancel = True;
	EndDo;
EndProcedure

Procedure FillCheckProcessing_ReceiptFromConsignor(Cancel, ItemList, TransactionType) Export
	ConsignorsByItemListTable = GetConsignorsByItemList(ItemList);
	For Each Row In ConsignorsByItemListTable Do
		ErrorMessage = "";
		If Row.IsOwnStocks Then
			ErrorMessage = StrTemplate(R().Error_130, TransactionType, Row.Item, Row.ItemKey);
			Cancel = True;
		Else
			If Row.LegalName <> Row.Consignor Then
				ErrorMessage = StrTemplate(R().Error_131, Row.Item, Row.ItemKey, Row.LegalName);
				Cancel = True;
			EndIf;
		EndIf;
		
		If ValueIsFilled(ErrorMessage) Then
			CommonFunctionsClientServer.ShowUsersMessage(
				ErrorMessage, "Object.ItemList[" + (Row.LineNumber - 1) + "].ItemKey", "Object.ItemList");
		EndIf;
	EndDo;
EndProcedure

Procedure FillCheckProcessing_ShipmentToTradeAgent(Cancel, ItemList, TransactionType) Export
	ConsignorsByItemListTable = GetConsignorsByItemList(ItemList);
	Filter = New Structure("IsOwnStocks", False);
	ErrorRows = ConsignorsByItemListTable.FindRows(Filter);
	For Each ErrorRow In ErrorRows Do
		ErrorMessage = StrTemplate(R().Error_129, TransactionType, ErrorRow.Item, ErrorRow.ItemKey, ErrorRow.Consignor);
		CommonFunctionsClientServer.ShowUsersMessage(
			ErrorMessage, "Object.ItemList[" + (ErrorRow.LineNumber - 1) + "].ItemKey", "Object.ItemList");
		Cancel = True;
	EndDo;
EndProcedure

Procedure FillCheckProcessing_ConsignorsInfo(Cancel, CatalogObject) Export
	ConsignorInfoTable = CatalogObject.ConsignorsInfo.Unload();
	ConsignorInfoTable.Columns.Add("Counter");
	ConsignorInfoTable.FillValues(1,"Counter");
	ConsignorInfoTable.GroupBy("Company", "Counter");
	
	ArrayOfPrecessedCompanies = New Array();
	For Each Row In ConsignorInfoTable Do
		If Row.Counter > 1 And ArrayOfPrecessedCompanies.Find(Row.Company) = Undefined Then
			Cancel = True;
			ArrayOfPrecessedCompanies.Add(Row.Company);
			ErrorMessage = StrTemplate(R().Error_132, Row.Company);
			
			ConsignorInfoRows = CatalogObject.ConsignorsInfo.FindRows(New Structure("Company", Row.Company));
			If ConsignorInfoRows.Count() Then
				CommonFunctionsClientServer.ShowUsersMessage(
					ErrorMessage, "Object.ConsignorsInfo[" + (ConsignorInfoRows[0].LineNumber - 1) + "].Company", "Object.ConsignorsInfo");
			EndIf;
		EndIf;
	EndDo;
EndProcedure

Function GetEmptyItemListTable() Export
	ItemListTable = New ValueTable();
	ItemListTable.Columns.Add("Company"    , New TypeDescription("CatalogRef.Companies"));
	ItemListTable.Columns.Add("LegalName"  , New TypeDescription("CatalogRef.Companies"));
	ItemListTable.Columns.Add("Item"       , New TypeDescription("CatalogRef.Items"));
	ItemListTable.Columns.Add("ItemKey"    , New TypeDescription("CatalogRef.ItemKeys"));
	ItemListTable.Columns.Add("LineNumber" , New TypeDescription("Number"));
	
	Return ItemListTable;
EndFunction

Function GetItemListTable(DocObject) Export
	ItemListTable = GetEmptyItemListTable();
	
	For Each Row In DocObject.ItemList Do
		NewRow = ItemListTable.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Company   = DocObject.Company;
		NewRow.LegalName = DocObject.LegalName;
	EndDo;
	
	Return ItemListTable;
EndFunction

Function GetConsignorsByItemList(ItemList) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Company AS Company,
	|	ItemList.LegalName AS LegalName,
	|	ItemList.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.LineNumber AS LineNumber
	|INTO ItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Company AS Company,
	|	ItemList.LegalName AS LegalName,
	|	ItemList.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	CASE
	|		WHEN ItemKeysConsignorsInfo.Consignor = VALUE(Catalog.Companies.EmptyRef)
	|			THEN TRUE
	|		WHEN ItemKeysConsignorsInfo.Consignor IS NULL
	|		AND ItemsConsignorsInfo.Consignor.Ref IS NULL
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsOwnStocks,
	|	CASE
	|		WHEN ItemKeysConsignorsInfo.Consignor = VALUE(Catalog.Companies.EmptyRef)
	|			THEN VALUE(Catalog.Companies.EmptyRef)
	|		WHEN ItemKeysConsignorsInfo.Consignor IS NULL
	|		AND ItemsConsignorsInfo.Consignor.Ref IS NULL
	|			THEN VALUE(Catalog.Companies.EmptyRef)
	|		ELSE CASE
	|			WHEN NOT ItemKeysConsignorsInfo.Consignor IS NULL
	|				THEN ItemKeysConsignorsInfo.Consignor
	|			ELSE ItemsConsignorsInfo.Consignor
	|		END
	|	END AS Consignor
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN Catalog.ItemKeys.ConsignorsInfo AS ItemKeysConsignorsInfo
	|		ON ItemList.ItemKey = ItemKeysConsignorsInfo.Ref
	|		AND ItemList.Company = ItemKeysConsignorsInfo.Company
	|		LEFT JOIN Catalog.Items.ConsignorsInfo AS ItemsConsignorsInfo
	|		ON ItemList.Item = ItemsConsignorsInfo.Ref
	|		AND ItemList.Company = ItemsConsignorsInfo.Company";
	Query.SetParameter("ItemList", ItemList);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetInventoryOriginAndConsignor(Company, Item, ItemKey) Export
	Return ServerReuse.GetInventoryOriginAndConsignor(Company, Item, ItemKey);
EndFunction

Function _GetInventoryOriginAndConsignor(Company, Item, ItemKey) Export
	ItemListTable = GetEmptyItemListTable();
	NewRow = ItemListTable.Add();
	NewRow.Company = Company;
	NewRow.Item    = Item;
	NewRow.ItemKey = ItemKey;
	
	ConsignorTable = GetConsignorsByItemList(ItemListTable);
	
	Result = New Structure();
	Result.Insert("InventoryOrigin", Enums.InventoryOriginTypes.OwnStocks);
	Result.Insert("Consignor", Undefined);
	
	If Not ConsignorTable[0].IsOwnStocks Then
		Result.InventoryOrigin = Enums.InventoryOriginTypes.ConsignorStocks;
		Result.Consignor       = ConsignorTable[0].Consignor;
	EndIf;
	
	Return Result;
EndFunction

Function GetSalesReportToConsignorList() Export
	Return CommissionTradePrivileged.GetSalesReportToConsignorList();
EndFunction
	
Function __GetSalesReportToConsignorList() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PRESENTATION(SalesReportToConsignor.Company) AS CompanyPresentation,
	|	SalesReportToConsignor.Date,
	|	SalesReportToConsignor.Number,
	|	SalesReportToConsignor.StartDate,
	|	SalesReportToConsignor.EndDate,
	|	SalesReportToConsignor.Ref AS SalesReportRef,
	|	PRESENTATION(SalesReportToConsignor.Ref.LegalName) AS LegalNamePresentation,
	|	PRESENTATION(SalesReportToConsignor.Ref.Agreement) AS PartnerTermPresentation
	|FROM
	|	Document.SalesReportToConsignor AS SalesReportToConsignor
	|WHERE
	|	SalesReportToConsignor.Posted";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;	
EndFunction

Function GetFillingDataBySalesReportToConsignor(DocRef) Export
	Return CommissionTradePrivileged.GetFillingDataBySalesReportToConsignor(DocRef);
EndFunction	

Function __GetFillingDataBySalesReportToConsignor(DocRef) Export
	FillingData = New Structure("BasedOn", "SalesReportToConsignor");
	FillingData.Insert("ItemList"         , New Array());
	FillingData.Insert("SerialLotNumbers" , New Array());
	FillingData.Insert("SourceOfOrigins"  , New Array());
	
	FillingData.Insert("Partner", DocRef.Company.Partner);
	
	For Each Row In DocRef.ItemList Do
		NewRow = New Structure("Key, Item, ItemKey, Unit, Quantity, Price, PriceType, 
		|VatRate, TaxAmount, TotalAmount, NetAmount, DontCalculateRow,
		|ConsignorPrice, TradeAgentFeePercent, TradeAgentFeeAmount");
		FillPropertyValues(NewRow, Row);
		FillingData.ItemList.Add(NewRow);
	EndDo;
	
	For Each Row In DocRef.SerialLotNumbers Do
		NewRow = New Structure("Key, SerialLotNumber, Quantity");
		FillPropertyValues(NewRow, Row);
		FillingData.SerialLotNumbers.Add(NewRow);
	EndDo;
	
	For Each Row In DocRef.SourceOfOrigins Do
		NewRow = New Structure("Key, SerialLotNumber, SourceOfOrigin, Quantity");
		FillPropertyValues(NewRow, Row);
		FillingData.SourceOfOrigins.Add(NewRow);
	EndDo;
	
	Return FillingData;
EndFunction	
