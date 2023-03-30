
// Tax rates
Function GetTaxRatesForItemKey(Parameters) Export
	Return ServerReuse.GetTaxRatesForItemKey(Parameters.Date, Parameters.Company, Parameters.Tax, Parameters.ItemKey);
EndFunction

Function _GetTaxRatesForItemKey(Date, Company, Tax, ItemKey) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	tmp.ItemKey AS ItemKey,
	|	tmp.Company AS Company,
	|	tmp.Tax AS Tax
	|INTO ItemKeys
	|FROM
	|	&ItemKeys AS tmp
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(Taxes_ItemKey.Company, ItemKeys.Company) AS Company,
	|	ISNULL(Taxes_ItemKey.Tax, ItemKeys.Tax) AS Tax,
	|	ISNULL(Taxes_ItemKey.ItemKey, ItemKeys.ItemKey) AS ItemKey,
	|	Taxes_ItemKey.TaxRate AS TaxRate
	|INTO Taxes_ItemKeys
	|FROM
	|	ItemKeys AS ItemKeys
	|		LEFT JOIN InformationRegister.TaxSettings.SliceLast(&Date, (Company, Tax, ItemKey) IN
	|			(SELECT
	|				ItemKeys.Company AS Company,
	|				ItemKeys.Tax AS Tax,
	|				ItemKeys.ItemKey AS ItemKey
	|			FROM
	|				ItemKeys AS ItemKeys)
	|		AND ItemType = VALUE(Catalog.ItemTypes.EmptyRef)
	|		AND Item = VALUE(Catalog.Items.EmptyRef)) AS Taxes_ItemKey
	|		ON Taxes_ItemKey.Company = ItemKeys.Company
	|		AND Taxes_ItemKey.Tax = ItemKeys.Tax
	|		AND Taxes_ItemKey.ItemKey = ItemKeys.ItemKey
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Taxes_ItemKeys.Company AS Company,
	|	Taxes_ItemKeys.Tax AS Tax,
	|	Taxes_ItemKeys.ItemKey AS ItemKey,
	|	Taxes_ItemKeys.ItemKey.Item AS Item
	|INTO Items
	|FROM
	|	Taxes_ItemKeys AS Taxes_ItemKeys
	|WHERE
	|	Taxes_ItemKeys.TaxRate IS NULL
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(Taxes_Items.Company, Items.Company) AS Company,
	|	ISNULL(Taxes_Items.Tax, Items.Tax) AS Tax,
	|	ISNULL(Taxes_Items.Item, Items.Item) AS Item,
	|	Items.ItemKey AS ItemKey,
	|	Taxes_Items.TaxRate AS TaxRate
	|INTO Taxes_Items
	|FROM
	|	Items AS Items
	|		LEFT JOIN InformationRegister.TaxSettings.SliceLast(&Date, (Company, Tax, Item) IN
	|			(SELECT
	|				Items.Company AS Company,
	|				Items.Tax AS Tax,
	|				Items.Item AS Item
	|			FROM
	|				Items AS Items)
	|		AND ItemType = VALUE(Catalog.ItemTypes.EmptyRef)
	|		AND ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)) AS Taxes_Items
	|		ON Taxes_Items.Company = Items.Company
	|		AND Taxes_Items.Tax = Items.Tax
	|		AND Taxes_Items.Item = Items.Item
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Taxes_Items.Company AS Company,
	|	Taxes_Items.Tax AS Tax,
	|	Taxes_Items.ItemKey AS ItemKey,
	|	Taxes_Items.Item AS Item,
	|	Taxes_Items.Item.ItemType AS ItemType
	|INTO ItemTypes
	|FROM
	|	Taxes_Items AS Taxes_Items
	|WHERE
	|	Taxes_Items.TaxRate IS NULL
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(Taxes_ItemTypes.Company, ItemTypes.Company) AS Company,
	|	ISNULL(Taxes_ItemTypes.Tax, ItemTypes.Tax) AS Tax,
	|	ISNULL(Taxes_ItemTypes.ItemType, ItemTypes.ItemType) AS ItemType,
	|	ItemTypes.Item AS Item,
	|	ItemTypes.ItemKey AS ItemKey,
	|	Taxes_ItemTypes.TaxRate AS TaxRate
	|INTO Taxes_ItemTypes
	|FROM
	|	ItemTypes AS ItemTypes
	|		LEFT JOIN InformationRegister.TaxSettings.SliceLast(&Date, (Company, Tax, ItemType) IN
	|			(SELECT
	|				ItemTypes.Company AS Company,
	|				ItemTypes.Tax AS Tax,
	|				ItemTypes.ItemType AS ItemType
	|			FROM
	|				ItemTypes AS ItemTypes)
	|		AND ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|		AND Item = VALUE(Catalog.Items.EmptyRef)) AS Taxes_ItemTypes
	|		ON Taxes_ItemTypes.Company = ItemTypes.Company
	|		AND Taxes_ItemTypes.Tax = ItemTypes.Tax
	|		AND Taxes_ItemTypes.ItemType = ItemTypes.ItemType
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Taxes_ItemTypes.Company AS Company,
	|	Taxes_ItemTypes.Tax AS Tax,
	|	Taxes_ItemTypes.ItemKey AS ItemKey,
	|	Taxes_ItemTypes.Item AS Item,
	|	Taxes_ItemTypes.ItemType AS ItemType
	|INTO Companies
	|FROM
	|	Taxes_ItemTypes AS Taxes_ItemTypes
	|WHERE
	|	Taxes_ItemTypes.TaxRate IS NULL
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(Taxes_Companies.Company, Companies.Company) AS Company,
	|	ISNULL(Taxes_Companies.Tax, Companies.Tax) AS Tax,
	|	Companies.ItemType AS ItemType,
	|	Companies.Item AS Item,
	|	Companies.ItemKey AS ItemKey,
	|	Taxes_Companies.TaxRate AS TaxRate
	|INTO Taxes_Companies
	|FROM
	|	Companies AS Companies
	|		LEFT JOIN InformationRegister.TaxSettings.SliceLast(&Date, (Company, Tax) IN
	|			(SELECT
	|				Companies.Company AS Company,
	|				Companies.Tax AS Tax
	|			FROM
	|				Companies AS Companies)
	|		AND ItemType = VALUE(Catalog.ItemTypes.EmptyRef)
	|		AND Item = VALUE(Catalog.Items.EmptyRef)
	|		AND ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)) AS Taxes_Companies
	|		ON Taxes_Companies.Company = Companies.Company
	|		AND Taxes_Companies.Tax = Companies.Tax
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	1 AS Priority,
	|	Taxes_ItemKeys.Company AS Company,
	|	Taxes_ItemKeys.Tax AS Tax,
	|	Taxes_ItemKeys.ItemKey AS ItemKey,
	|	VALUE(Catalog.Items.EmptyRef) AS Item,
	|	VALUE(Catalog.ItemTypes.EmptyRef) AS ItemType,
	|	Taxes_ItemKeys.TaxRate AS TaxRate,
	|	Taxes_ItemKeys.TaxRate.Rate AS Rate
	|INTO TaxRatesByPriority
	|FROM
	|	Taxes_ItemKeys AS Taxes_ItemKeys
	|WHERE
	|	NOT Taxes_ItemKeys.TaxRate IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	2,
	|	Taxes_Items.Company,
	|	Taxes_Items.Tax,
	|	Taxes_Items.ItemKey,
	|	Taxes_Items.Item,
	|	VALUE(Catalog.ItemTypes.EmptyRef),
	|	Taxes_Items.TaxRate,
	|	Taxes_Items.TaxRate.Rate
	|FROM
	|	Taxes_Items AS Taxes_Items
	|WHERE
	|	NOT Taxes_Items.TaxRate IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	3,
	|	Taxes_ItemTypes.Company,
	|	Taxes_ItemTypes.Tax,
	|	Taxes_ItemTypes.ItemKey,
	|	Taxes_ItemTypes.Item,
	|	Taxes_ItemTypes.ItemType,
	|	Taxes_ItemTypes.TaxRate,
	|	Taxes_ItemTypes.TaxRate.Rate
	|FROM
	|	Taxes_ItemTypes AS Taxes_ItemTypes
	|WHERE
	|	NOT Taxes_ItemTypes.TaxRate IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	4,
	|	Taxes_Companies.Company,
	|	Taxes_Companies.Tax,
	|	Taxes_Companies.ItemKey,
	|	Taxes_Companies.Item,
	|	Taxes_Companies.ItemType,
	|	Taxes_Companies.TaxRate,
	|	Taxes_Companies.TaxRate.Rate
	|FROM
	|	Taxes_Companies AS Taxes_Companies
	|WHERE
	|	NOT Taxes_Companies.TaxRate IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxRatesByPriority.Priority AS Priority,
	|	TaxRatesByPriority.Company,
	|	TaxRatesByPriority.Tax,
	|	TaxRatesByPriority.ItemKey,
	|	TaxRatesByPriority.Item,
	|	TaxRatesByPriority.ItemType,
	|	TaxRatesByPriority.TaxRate,
	|	TaxRatesByPriority.Rate
	|FROM
	|	TaxRatesByPriority AS TaxRatesByPriority
	|ORDER BY
	|	Priority";

	ItemKeys = New ValueTable();
	ItemKeys.Columns.Add("Company" , New TypeDescription("CatalogRef.Companies"));
	ItemKeys.Columns.Add("ItemKey" , New TypeDescription("CatalogRef.ItemKeys"));
	ItemKeys.Columns.Add("Tax"     , New TypeDescription("CatalogRef.Taxes"));
	
	NewRow = ItemKeys.Add();
	NewRow.Company = Company;
	NewRow.ItemKey = ItemKey;
	NewRow.Tax = Tax;
	
	Query.SetParameter("ItemKeys" , ItemKeys);
	Query.SetParameter("Date"     , Date);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	ArrayOfTaxes = New Array();

	While QuerySelection.Next() Do
		Result = New Structure();
		Result.Insert("Company"  , QuerySelection.Company);
		Result.Insert("Tax"      , QuerySelection.Tax);
		Result.Insert("ItemKey"  , QuerySelection.ItemKey);
		Result.Insert("Item"     , QuerySelection.Item);
		Result.Insert("ItemType" , QuerySelection.ItemType);
		Result.Insert("TaxRate"  , QuerySelection.TaxRate);
		Result.Insert("Rate"     , QuerySelection.Rate);
		ArrayOfTaxes.Add(Result);
	EndDo;
	Return ArrayOfTaxes;
EndFunction

Function GetTaxRatesForAgreement(Parameters) Export
	Return ServerReuse.GetTaxRatesForAgreement(Parameters.Date, Parameters.Company, Parameters.Tax, Parameters.Agreement);
EndFunction

Function _GetTaxRatesForAgreement(Date, Company, Tax, Agreement) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxRatesSliceLast.Company,
	|	TaxRatesSliceLast.Tax,
	|	TaxRatesSliceLast.Agreement,
	|	TaxRatesSliceLast.TaxRate,
	|	TaxRatesSliceLast.TaxRate.Rate AS Rate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Company = &Company
	|	AND Tax = &Tax
	|	AND Agreement = &Agreement) AS TaxRatesSliceLast";

	Query.SetParameter("Date"      , Date);
	Query.SetParameter("Company"   , Company);
	Query.SetParameter("Agreement" , Agreement);
	Query.SetParameter("Tax"       , Tax);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	ArrayOfTaxes = New Array();

	While QuerySelection.Next() Do
		Result = New Structure();
		Result.Insert("Company"   , QuerySelection.Company);
		Result.Insert("Tax"       , QuerySelection.Tax);
		Result.Insert("Agreement" , QuerySelection.Agreement);
		Result.Insert("TaxRate"   , QuerySelection.TaxRate);
		Result.Insert("Rate"      , QuerySelection.Rate);
		ArrayOfTaxes.Add(Result);
	EndDo;
	Return ArrayOfTaxes;
EndFunction

Function GetTaxRatesForCompany(Parameters) Export
	Return ServerReuse.GetTaxRatesForCompany(Parameters.Date, Parameters.Company, Parameters.Tax);
EndFunction

Function _GetTaxRatesForCompany(Date, Company, Tax) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxRatesSliceLast.Company,
	|	TaxRatesSliceLast.Tax,
	|	TaxRatesSliceLast.TaxRate,
	|	TaxRatesSliceLast.TaxRate.Rate AS Rate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Company = &Company
	|	AND Tax = &Tax
	|	AND ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|	AND Item = VALUE(Catalog.Items.EmptyRef)
	|	AND ItemType = VALUE(Catalog.ItemTypes.EmptyRef)
	|	AND Agreement = VALUE(Catalog.Agreements.EmptyRef)) AS TaxRatesSliceLast";

	Query.SetParameter("Date"    , Date);
	Query.SetParameter("Company" , Company);
	Query.SetParameter("Tax"     , Tax);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();

	ArrayOfTaxes = New Array();

	While QuerySelection.Next() Do
		Result = New Structure();
		Result.Insert("Company" , QuerySelection.Company);
		Result.Insert("Tax"     , QuerySelection.Tax);
		Result.Insert("TaxRate" , QuerySelection.TaxRate);
		Result.Insert("Rate"    , QuerySelection.Rate);
		ArrayOfTaxes.Add(Result);
	EndDo;
	Return ArrayOfTaxes;
EndFunction

Function GetTaxRatesForConsignorBatches(Parameters) Export
	ArrayOfCompany = New Array();
	For Each Row In Parameters.ConsignorBatches Do
		If TypeOf(Row.Batch) = Type("DocumentRef.OpeningEntry") Then
			Company = Row.Batch.LegalNameConsignor;
		Else
			Company = Row.Batch.LegalName;
		EndIf;
		If ValueIsFilled(Company) And ArrayOfCompany.Find(Company) = Undefined Then
			ArrayOfCompany.Add(Company);
		EndIf;
	EndDo;
	
	TotalArrayOfTaxes = New Array();
	
	For Each ItemOfCompany In ArrayOfCompany Do
		QueryParameters = New Structure();
		QueryParameters.Insert("Date"    , Parameters.Date);
		QueryParameters.Insert("Tax"     , Parameters.Tax);
		QueryParameters.Insert("Company" , ItemOfCompany);
		ArrayOfTaxes = GetTaxRatesForCompany(QueryParameters);
		For Each ItemOfTaxes In ArrayOfTaxes Do
			TotalArrayOfTaxes.Add(ItemOfTaxes);
		EndDo;
	EndDo;
	
	Return TotalArrayOfTaxes;
EndFunction

// Taxes
Function GetTaxesByCompany(Date, Company) Export
	Return ServerReuse.GetTaxesByCompany(Date, Company);
EndFunction

Function _GetTaxesByCompany(Date, Company) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxesSliceLast.Tax,
	|	TaxesSliceLast.Tax.Type AS Type,
	|	TaxesSliceLast.Tax.UseDocuments.(
	|		DocumentName) AS UseDocuments
	|FROM
	|	InformationRegister.Taxes.SliceLast(&Date, Company = &Company) AS TaxesSliceLast
	|WHERE
	|	TaxesSliceLast.Use
	|ORDER BY
	|	TaxesSliceLast.Priority";
	Query.SetParameter("Date"    , Date);
	Query.SetParameter("Company" , Company);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		TaxInfo = New Structure();
		TaxInfo.Insert("Tax"          , QuerySelection.Tax);
		TaxInfo.Insert("Type"         , QuerySelection.Type);
		TaxInfo.Insert("UseDocuments" , QuerySelection.UseDocuments.Unload());
		ArrayOfResults.Add(TaxInfo);
	EndDo;
	Return ArrayOfResults;
EndFunction

Function GetTaxRatesByTax(Tax) Export
	Return ServerReuse.GetTaxRatesByTax(Tax);
EndFunction

Function _GetTaxRatesByTax(Tax) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxesTaxRates.TaxRate
	|FROM
	|	Catalog.Taxes.TaxRates AS TaxesTaxRates
	|WHERE
	|	TaxesTaxRates.Ref = &Ref";
	Query.SetParameter("Ref", Tax);
	Return Query.Execute().Unload().UnloadColumn("TaxRate");
EndFunction
		
Function CalculateTax(Parameters) Export
	Return ServerReuse.CalculateTax(Parameters.Tax, 
		Parameters.TaxRateOrAmount, 
		Parameters.PriceIncludeTax, 
		Parameters.Key, 
		Parameters.TotalAmount, 
		Parameters.NetAmount, 
		Parameters.Ref, 
		Parameters.Reverse);
EndFunction

Function _CalculateTax(Tax, TaxRateOrAmount, PriceIncludeTax, _Key, TotalAmount, NetAmount, Ref, Reverse) Export
	Result = New Array();
	If Tax.Type = Enums.TaxType.Rate Then
		Info = AddDataProcServer.AddDataProcInfo(Tax.ExternalDataProc);
		Info.Create = True;
		AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
		If Not AddDataProc = Undefined Then
			DataProcParameters = New Structure();
			DataProcParameters.Insert("Tax"             , Tax);
			DataProcParameters.Insert("TaxRateOrAmount" , TaxRateOrAmount);
			DataProcParameters.Insert("PriceIncludeTax" , PriceIncludeTax);
			DataProcParameters.Insert("Key"             , _Key);
			DataProcParameters.Insert("TotalAmount"     , TotalAmount);
			DataProcParameters.Insert("NetAmount"       , NetAmount);
			DataProcParameters.Insert("Ref"             , Ref);
			DataProcParameters.Insert("Reverse"         , Reverse);
			
			Result = AddDataProc.CalculateTax(DataProcParameters);
		EndIf;
	Else
		Result.Add(New Structure("Amount", TaxRateOrAmount));
	EndIf;

	For Each Row In Result Do
		If Not Row.Property("Tax") Then
			Row.Insert("Tax", Tax);
		EndIf;
		If Not Row.Property("TaxRate") Then
			Row.Insert("TaxRate", TaxRateOrAmount);
		EndIf;
		If Not Row.Property("IncludeToTotalAmount") Then
			Row.Insert("IncludeToTotalAmount", True);
		EndIf;
		If Not Row.Property("Analytics") Then
			Row.Insert("Analytics", Undefined);
		EndIf;
	EndDo;
	Return Result;
EndFunction

Procedure PutToTaxTable(Form, Key, Tax, Value)
	Filter = New Structure("Key, Tax", Key, Tax);
	ArrayOfRowsTaxTable = Form.TaxesTable.FindRows(Filter);
	TaxTableRow = Undefined;
	If ArrayOfRowsTaxTable.Count() = 0 Then
		TaxTableRow = Form.TaxesTable.Add();
	ElsIf ArrayOfRowsTaxTable.Count() = 1 Then
		TaxTableRow = ArrayOfRowsTaxTable[0];
	Else
		Raise StrTemplate(R().Error_041, Filter.Key, Filter.Tax);
	EndIf;
	TaxTableRow.Key   = Filter.Key;
	TaxTableRow.Tax   = Filter.Tax;
	TaxTableRow.Value = Value;
EndProcedure

Function GetFromTaxTable(Form, Key, Tax)
	Filter = New Structure("Key, Tax", Key, Tax);
	ArrayOfRowsTaxTable = Form.TaxesTable.FindRows(Filter);
	If ArrayOfRowsTaxTable.Count() = 1 Then
		Return ArrayOfRowsTaxTable[0].Value;
	ElsIf ArrayOfRowsTaxTable.Count() > 1 Then
		Raise StrTemplate(R().Error_041, Filter.Key, Filter.Tax);
	Else
		Return Undefined;
	EndIf;
	Return Undefined;
EndFunction

// Template date for testing
Function _GetArrayOfTaxInfo(Object, Date, Company) Export
	
	ArrayOfTaxes = New Array();
	DocumentName = Object.Ref.Metadata().Name;
	ArrayOfAllTaxes = GetTaxesByCompany(Date, Company);
	For Each ItemOfAllTaxes In ArrayOfAllTaxes Do
		If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
			ArrayOfTaxes.Add(ItemOfAllTaxes);
		EndIf;
	EndDo;
	
	ArrayOfTaxInfo = New Array();
	ArrayOfActualTax = New Array();
	For Each ItemOfTaxes In ArrayOfTaxes Do
		ColumnInfo = New Structure();
		ColumnInfo.Insert("Name", "_" + StrReplace(String(New UUID()), "-", ""));
		ColumnInfo.Insert("Tax", ItemOfTaxes.Tax);
		ColumnInfo.Insert("Type", ItemOfTaxes.Type);
		ArrayOfTaxInfo.Add(ColumnInfo);
		ArrayOfActualTax.Add(ItemOfTaxes.Tax);
	EndDo;

	ArrayOfDeleteRowsFromTaxList = New Array();
	For Each RowTaxList In Object.TaxList Do
		If ArrayOfActualTax.Find(RowTaxList.Tax) = Undefined Then
			ArrayOfDeleteRowsFromTaxList.Add(RowTaxList);
		EndIf;
	EndDo;
	For Each ItemOfDeleteRowsFromTaxList In ArrayOfDeleteRowsFromTaxList Do
		Object.TaxList.Delete(ItemOfDeleteRowsFromTaxList);
	EndDo;

	Return ArrayOfTaxInfo;
EndFunction

Procedure CreateFormControls(Object, Form, Parameters) Export
	If Not CommonFunctionsServer.FormHaveAttribute(Form, "TaxesCache") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("TaxesCache", New TypeDescription("String")));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;

	If Not CommonFunctionsServer.FormHaveAttribute(Form, "TaxesTable") Then
		ArrayOfNewAttribute = New Array();
		ArrayOfNewAttribute.Add(New FormAttribute("TaxesTable", New TypeDescription("ValueTable")));
		ArrayOfNewAttribute.Add(New FormAttribute("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type), "TaxesTable"));
		ArrayOfNewAttribute.Add(New FormAttribute("Tax", New TypeDescription("CatalogRef.Taxes"), "TaxesTable"));

		ArrayOfValueTypes = New Array();
		ArrayOfValueTypes.Add(Type("CatalogRef.TaxRates"));
		ArrayOfValueTypes.Add(Metadata.DefinedTypes.typeAmount.Type.Types()[0]);

		ArrayOfNewAttribute.Add(New FormAttribute("Value", New TypeDescription(ArrayOfValueTypes), "TaxesTable"));
		Form.ChangeAttributes(ArrayOfNewAttribute);
	EndIf;

	Form.TaxesTable.Clear();

	BufferTable = New ValueTable();
	BufferTable.Columns.Add("Key");
	BufferTable.Columns.Add("Tax");
	BufferTable.Columns.Add("TaxRate");
	BufferTable.Columns.Add("Amount");

	For Each RowTaxList In Object[Parameters.TaxListName] Do
		NewRow = BufferTable.Add();
		NewRow.Key = RowTaxList.Key;
		NewRow.Tax = RowTaxList.Tax;
		If RowTaxList.Tax.Type = Enums.TaxType.Rate Then
			NewRow.TaxRate = RowTaxList.TaxRate;
		Else
			NewRow.Amount = RowTaxList.Amount;
		EndIf;
	EndDo;
	BufferTable.GroupBy("Key, Tax, TaxRate", "Amount");
	For Each RowBufferTable In BufferTable Do
		PutToTaxTable(Form, RowBufferTable.Key, RowBufferTable.Tax, ?(ValueIsFilled(RowBufferTable.TaxRate),
			RowBufferTable.TaxRate, RowBufferTable.Amount));
	EndDo;

	SavedDataStructure = TaxesClientServer.GetTaxesCache(Form);
	
	// Delete
	ArrayOfDeleteAttribute = New Array();
	For Each ItemOfColumnsInfo In SavedDataStructure.ArrayOfTaxInfo Do
		ArrayOfDeleteAttribute.Add(ItemOfColumnsInfo.DataPath);
		Form.Items.Delete(Form.Items[ItemOfColumnsInfo.Name]);
	EndDo;
	If ArrayOfDeleteAttribute.Count() Then
		Form.ChangeAttributes( , ArrayOfDeleteAttribute);
	EndIf;
	
	// Create columns
	ArrayOfTaxes = New Array();
	DocumentName = Object.Ref.Metadata().Name;
	ArrayOfAllTaxes = GetTaxesByCompany(Parameters.Date, Parameters.Company);
	For Each ItemOfAllTaxes In ArrayOfAllTaxes Do
		If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
			ArrayOfTaxes.Add(ItemOfAllTaxes);
		EndIf;
	EndDo;
	
	If ValueIsFilled(Parameters.TotalAmountColumnName) And ArrayOfTaxes.Count() Then
		Form.Items[Parameters.TotalAmountColumnName].ReadOnly = ArrayOfTaxes.Count() <> 1;
	EndIf;
	
	If ValueIsFilled(Parameters.InvisibleColumnsIfNotTaxes) Then
		ArrayOfAmountColumns = StrSplit(Parameters.InvisibleColumnsIfNotTaxes, ",");
		For Each AmountColumn In ArrayOfAmountColumns Do
			Form.Items[TrimAll(AmountColumn)].Visible = ArrayOfTaxes.Count();
		EndDo;
	EndIf;
	
	ArrayOfColumns = New Array();
	ArrayOfTaxInfo = New Array();
	ArrayOfActualTax = New Array();
	For Each ItemOfTaxes In ArrayOfTaxes Do
		ColumnInfo = New Structure();
		ColumnInfo.Insert("Name", "_" + StrReplace(String(New UUID()), "-", ""));
		ColumnInfo.Insert("Tax", ItemOfTaxes.Tax);
		ColumnInfo.Insert("Type", ItemOfTaxes.Type);
		If ItemOfTaxes.Type = Enums.TaxType.Rate Then
			ColumnType = New TypeDescription("CatalogRef.TaxRates");
		Else
			ColumnType = Metadata.DefinedTypes.typeAmount.Type;
		EndIf;
		ArrayOfColumns.Add(New FormAttribute(ColumnInfo.Name, ColumnType, Parameters.PathToTable, String(
			ItemOfTaxes.Tax), True));
		ArrayOfTaxInfo.Add(ColumnInfo);
		ArrayOfActualTax.Add(ItemOfTaxes.Tax);
	EndDo;
	Form.ChangeAttributes(ArrayOfColumns);

	ArrayOfDeleteRowsFromTaxList = New Array();
	For Each RowTaxList In Object[Parameters.TaxListName] Do
		If ArrayOfActualTax.Find(RowTaxList.Tax) = Undefined Then
			ArrayOfDeleteRowsFromTaxList.Add(RowTaxList);
		EndIf;
	EndDo;
	For Each ItemOfDeleteRowsFromTaxList In ArrayOfDeleteRowsFromTaxList Do
		Object[Parameters.TaxListName].Delete(ItemOfDeleteRowsFromTaxList);
	EndDo;

	For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
		NewColumn = Form.Items.Insert(ItemOfTaxInfo.Name, Type("FormField"), Parameters.ItemParent,
			Parameters.ColumnOffset);
		NewColumn.Type = FormFieldType.InputField;
		NewColumn.DataPath = Parameters.PathToTable + "." + NewColumn.Name;
		ItemOfTaxInfo.Insert("DataPath", NewColumn.DataPath);
		If ItemOfTaxInfo.Type = Enums.TaxType.Rate Then
			NewColumn.ListChoiceMode = True;
			NewColumn.ChoiceList.LoadValues(GetTaxRatesByTax(ItemOfTaxInfo.Tax));
		EndIf;
		NewColumn.SetAction("OnChange", "TaxValueOnChange");
		If ValueIsFilled(Parameters.ColumnFieldParameters) Then
			For Each FieldParameter In Parameters.ColumnFieldParameters Do
				NewColumn[FieldParameter.Key] = FieldParameter.Value;
			EndDo;
		EndIf;
	EndDo;
	
	// Update columns
	For Each RowItemList In Object[Parameters.ItemListName] Do
		For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
			RowItemList[ItemOfTaxInfo.Name] = GetFromTaxTable(Form, RowItemList.Key, ItemOfTaxInfo.Tax);
		EndDo;
	EndDo;
	Form.TaxesCache = CommonFunctionsServer.SerializeXMLUseXDTO(New Structure("ArrayOfTaxInfo", ArrayOfTaxInfo));
EndProcedure

Function CreateFormControls_ItemList(Object, Form, ColumnOffset = Undefined) Export
	TaxesParameters = GetCreateFormControlsParameters();
	TaxesParameters.Date                  = Object.Date;
	TaxesParameters.Company               = Object.Company;
	TaxesParameters.PathToTable           = "Object.ItemList";
	TaxesParameters.ItemParent            = Form.Items.ItemList;
	
	If ColumnOffset = Undefined Then
		TaxesParameters.ColumnOffset = Form.Items.ItemListOffersAmount;
	Else
		TaxesParameters.ColumnOffset = ColumnOffset;
	EndIf;
	
	TaxesParameters.ItemListName          = "ItemList";
	TaxesParameters.TaxListName           = "TaxList";
	TaxesParameters.TotalAmountColumnName = "ItemListTotalAmount";
	TaxesParameters.InvisibleColumnsIfNotTaxes = "ItemListTaxAmount";
	CreateFormControls(Object, Form, TaxesParameters);
	
	Return GetArrayOfTaxInfo(Object, Form);
EndFunction

Function CreateFormControls_PaymentList(Object, Form, AddInfo = Undefined) Export
	TaxesParameters = GetCreateFormControlsParameters();
	TaxesParameters.Date                  = Object.Date;
	TaxesParameters.Company               = Object.Company;
	TaxesParameters.PathToTable           = "Object.PaymentList";
	TaxesParameters.ItemParent            = Form.Items.PaymentList;
	TaxesParameters.ColumnOffset          = Form.Items.PaymentListNetAmount;
	TaxesParameters.ItemListName          = "PaymentList";
	TaxesParameters.TaxListName           = "TaxList";
	TaxesParameters.TotalAmountColumnName = "PaymentListTotalAmount";
	TaxesParameters.InvisibleColumnsIfNotTaxes = "PaymentListTaxAmount, PaymentListNetAmount";
	CreateFormControls(Object, Form, TaxesParameters);
	
	Return GetArrayOfTaxInfo(Object, Form);
EndFunction

Function GetArrayOfTaxInfo(Object, Form)
	// update tax cache after rebuild form controls
	TaxesCache = New Structure();
	TaxesCache.Insert("Cache"   , Form.TaxesCache);
	TaxesCache.Insert("Ref"     , Object.Ref);
	TaxesCache.Insert("Date"    , Object.Date);
	TaxesCache.Insert("Company" , Object.Company);

	Parameters = New Structure("TaxesCache", TaxesCache);
	Result = GetFromTaxesCache(Parameters);
	
	Return Result.ArrayOfTaxInfo;
EndFunction

Function GetFromTaxesCache(Parameters)
	Result = New Structure();
	ArrayOfTaxInfo = New Array();

	If ValueIsFilled(Parameters.TaxesCache.Cache) Then

		ArrayOfTaxesInCache = New Array();

		ArrayOfTaxes = New Array();

		DocumentName = Parameters.TaxesCache.Ref.Metadata().Name;
		ArrayOfAllTaxes = GetTaxesByCompany(Parameters.TaxesCache.Date, Parameters.TaxesCache.Company);
		For Each ItemOfAllTaxes In ArrayOfAllTaxes Do
			If ItemOfAllTaxes.UseDocuments.FindRows(New Structure("DocumentName", DocumentName)).Count() Then
				ArrayOfTaxes.Add(ItemOfAllTaxes.Tax);
			EndIf;
		EndDo;

		AllTaxesInCache = True;
		For Each ItemOfTaxes In ArrayOfTaxes Do
			If ArrayOfTaxesInCache.Find(ItemOfTaxes) = Undefined Then
				AllTaxesInCache = False;
				Break;
			EndIf;
		EndDo;
		If AllTaxesInCache Then
			For Each ItemOfTaxesInCache In ArrayOfTaxesInCache Do
				If ArrayOfTaxes.Find(ItemOfTaxesInCache) = Undefined Then
					AllTaxesInCache = False;
					Break;
				EndIf;
			EndDo;
		EndIf;

	EndIf;

	Result.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
	Return Result;
EndFunction

Function GetCreateFormControlsParameters() Export
	Parameters = New Structure();
	Parameters.Insert("Date");
	Parameters.Insert("Company");
	Parameters.Insert("PathToTable");
	Parameters.Insert("ItemParent");
	Parameters.Insert("ColumnOffset");
	Parameters.Insert("ItemListName");
	Parameters.Insert("TaxListName");
	Parameters.Insert("TotalAmountColumnName");
	Parameters.Insert("ColumnFieldParameters");
	Parameters.Insert("InvisibleColumnsIfNotTaxes");
	Return Parameters;
EndFunction

Function GetDocumentsWithTax() Export
	List = New ValueList();
	For Each Document In Metadata.Documents Do
		If Not Document.TabularSections.Find("TaxList") = Undefined Then
			List.Add(Document.Name, Document.Synonym);
		EndIf;
	EndDo;
	Return List;
EndFunction
