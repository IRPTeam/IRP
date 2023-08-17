
// Tax rates

Function GetTaxRateByPriority(Parameters) Export
	If Not ValueIsFilled(Parameters.ItemKey)
		And Not ValueIsFilled(Parameters.Agreement)
		And Not ValueIsFilled(Parameters.TransactionType) Then
			
		QueryParameters = New Structure();
		QueryParameters.Insert("Date"    , Parameters.Date);
		QueryParameters.Insert("Tax"     , Parameters.Tax);
		QueryParameters.Insert("Company" , Parameters.Company);
		
		Return GetTaxRateByCompany(Parameters);
	EndIf;
	
	Return ServerReuse.GetTaxRateByPriority(Parameters);
EndFunction

Function _GetTaxRateByPriority(Parameters) Export	
	Query = New Query();
	Query.Text =
	"SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType_EmptyRef
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreements_EmptyRef) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreements_EmptyRef) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType_EmptyRef
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreement) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType_EmptyRef
	|	AND ItemKey = &ItemKey
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreements_EmptyRef) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType_EmptyRef
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreements_EmptyRef) AS T
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Tax = &Tax
	|	AND Company = &Company
	|	AND TransactionType = &TransactionType_EmptyRef
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType
	|	AND Agreement = &Agreements_EmptyRef) AS T";

	SetTaxRateQueryParameters(Query, Parameters);
	
	_ItemKey  = Catalogs.ItemKeys.EmptyRef();
	_Item     = Catalogs.ItemKeys.EmptyRef();
	_ItemType = Catalogs.ItemTypes.EmptyRef();
	If ValueIsFilled(Parameters.ItemKey) Then
		_ItemKey  = Parameters.ItemKey;
		_Item     = Parameters.ItemKey.Item;
		_ItemType = _Item.ItemType;
	EndIf;
	Query.SetParameter("ItemKey"  , _ItemKey);
	Query.SetParameter("Item"     , _Item);
	Query.SetParameter("ItemType" , _ItemType);
	
	_Agreement = Catalogs.Agreements.EmptyRef();
	If ValueIsFilled(Parameters.Agreement) Then
		_Agreement = Parameters.Agreement;
	EndIf;
	Query.SetParameter("Agreement" , _Agreement);

	_TransactionType = Undefined;
	If ValueIsFilled(Parameters.TransactionType) Then
		_TransactionType = Parameters.TransactionType;
	EndIf;
	Query.SetParameter("TransactionType" , _TransactionType);

	// Company, TransactionType, Agreement, ItemKey, Item, ItemType
	QueryResults = Query.ExecuteBatch();
	Result_Company         = QueryResults[0].Select();
	Result_TransactionType = QueryResults[1].Select();
	Result_Agreement       = QueryResults[2].Select();
	Result_ItemKey         = QueryResults[3].Select();
	Result_Item            = QueryResults[4].Select();
	Result_ItemType        = QueryResults[5].Select();
	
	If ValueIsFilled(Parameters.Agreement) Then
		If Result_Agreement.Next() Then
			Return Result_Agreement.TaxRate;
		EndIf;
	EndIf;
	
	If ValueIsFilled(Parameters.ItemKey) Then
		If Result_ItemKey.Next() Then
			Return Result_ItemKey.TaxRate;
		EndIf;
		
		If Result_Item.Next() Then
			Return Result_Item.TaxRate;
		EndIf;
		
		If Result_ItemType.Next() Then
			Return Result_ItemType.TaxRate;
		EndIf;		
	EndIf;
	
	If ValueIsFilled(Parameters.TransactionType) Then
		If Result_TransactionType.Next() Then
			Return Result_TransactionType.TaxRate;
		EndIf;
	EndIf;
	
	If Result_Company.Next() Then
		Return Result_Company.TaxRate;
	EndIf;
	
	Return Catalogs.TaxRates.EmptyRef();
EndFunction

Function GetTaxRateByCompany(Parameters) Export
	Return ServerReuse.GetTaxRateByCompany(Parameters);
EndFunction

Function _GetTaxRateByCompany(Parameters) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	T.TaxRate AS TaxRate
	|FROM
	|	InformationRegister.TaxSettings.SliceLast(&Date, Company = &Company
	|	AND Tax = &Tax
	|	AND ItemKey = &ItemKey_EmptyRef
	|	AND Item = &Item_EmptyRef
	|	AND ItemType = &ItemType_EmptyRef
	|	AND Agreement = &Agreements_EmptyRef
	|	AND TransactionType = &TransactionType_EmptyRef) AS T";

	SetTaxRateQueryParameters(Query, Parameters);
	
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Return QuerySelection.TaxRate;
	EndIf;
	
	Return Catalogs.TaxRates.EmptyRef();
EndFunction

//#2093
//Function GetTaxRateByConsignorBatch(Parameters) Export
//	ConsignorCompany = Catalogs.Companies.EmptyRef();
//	
//	If Parameters.ConsignorBatches.Count() Then
//		Row = Parameters.ConsignorBatches[0];
//		If TypeOf(Row.Batch) = Type("DocumentRef.OpeningEntry") Then
//			ConsignorCompany = Row.Batch.LegalNameConsignor;
//		Else
//			ConsignorCompany = Row.Batch.LegalName;
//		EndIf;
//	EndIf;
//	
//	QueryParameters = New Structure();
//	QueryParameters.Insert("Date"    , Parameters.Date);
//	QueryParameters.Insert("Tax"     , Parameters.Tax);
//	QueryParameters.Insert("Company" , ConsignorCompany);
//	
//	Return GetTaxRateByCompany(QueryParameters);	
//EndFunction

Procedure SetTaxRateQueryParameters(Query, Parameters)
	Query.SetParameter("Agreements_EmptyRef", Catalogs.Agreements.EmptyRef());
	Query.SetParameter("ItemKey_EmptyRef"   , Catalogs.ItemKeys.EmptyRef());
	Query.SetParameter("Item_EmptyRef"      , Catalogs.Items.EmptyRef());
	Query.SetParameter("ItemType_EmptyRef"  , Catalogs.ItemTypes.EmptyRef());
	Query.SetParameter("TransactionType_EmptyRef"  , Undefined);
	
	Query.SetParameter("Company" , Parameters.Company);
	Query.SetParameter("Tax"     , Parameters.Tax);
	Query.SetParameter("Date"    , Parameters.Date);
EndProcedure

// Taxes

Function GetRequiredTaxesForDocument(Date, Company, DocumentName, TransactionType) Export
	RequiredTaxes = New Array();
	AllTaxes = GetTaxesInfo(Date, Company, DocumentName, TransactionType);
	For Each Item In AllTaxes Do
		RequiredTaxes.Add(Item.Tax);
	EndDo;
	Return RequiredTaxes;
EndFunction

Function GetTaxesInfo(Date, Company, DocumentName, TransactionType)
	Return ServerReuse.GetTaxesInfo(Date, Company, DocumentName, TransactionType);
EndFunction

Function _GetTaxesInfo(Date, Company, DocumentName, TransactionType) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxesSliceLast.Tax AS Tax,
	|	TaxesSliceLast.Tax.Type AS Type
	|INTO AllTaxes
	|FROM
	|	InformationRegister.Taxes.SliceLast(&Date, Company = &Company) AS TaxesSliceLast
	|WHERE
	|	TaxesSliceLast.Use
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllTaxes.Tax AS Tax,
	|	AllTaxes.Type AS Type,
	|	TaxesUseDocuments.DocumentName AS DocumentName
	|FROM
	|	AllTaxes AS AllTaxes
	|		INNER JOIN Catalog.Taxes.UseDocuments AS TaxesUseDocuments
	|		ON (AllTaxes.Tax = TaxesUseDocuments.Ref)
	|		AND (TaxesUseDocuments.DocumentName = &DocumentName)
	|GROUP BY
	|	AllTaxes.Tax,
	|	AllTaxes.Type,
	|	TaxesUseDocuments.DocumentName";
	
	Query.SetParameter("Date"         , Date);
	Query.SetParameter("Company"      , Company);	
	Query.SetParameter("DocumentName" , DocumentName);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfResults = New Array();
	While QuerySelection.Next() Do
		// for tax set silter by transaction type
		
		AvailableTax = False;	
		TransactionTypes = QuerySelection.Tax.TransactionTypes.FindRows(New Structure("DocumentName", DocumentName));
		If TransactionTypes.Count() And ValueIsFilled(TransactionType) Then
			For Each Row In TransactionTypes Do
				If Row.TransactionType = TransactionType Then
					AvailableTax = True;
					Break;
				EndIf;
			EndDo;
		Else
			AvailableTax = True;
		EndIf;
		
		If AvailableTax Then
			TaxInfo = New Structure();
			TaxInfo.Insert("Tax"  , QuerySelection.Tax);
			TaxInfo.Insert("Type" , QuerySelection.Type);
			ArrayOfResults.Add(TaxInfo);
		EndIf;
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

Function GetArrayOfTaxInfo(Object, Date, Company, TransactionType) Export	
	DocumentName = Object.Ref.Metadata().Name;
	ArrayOfTaxes = GetTaxesInfo(Date, Company, DocumentName, TransactionType);
	ArrayOfTaxInfo = New Array();
	ArrayOfActualTax = New Array();
	For Each ItemOfTaxes In ArrayOfTaxes Do
		ColumnInfo = New Structure();
		ColumnInfo.Insert("Name" , "_" + StrReplace(String(ItemOfTaxes.Tax.UUID()), "-", ""));
		ColumnInfo.Insert("Tax"  , ItemOfTaxes.Tax);
		ColumnInfo.Insert("Type" , ItemOfTaxes.Type);
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

Procedure CreateFormControls(Object, Form, Parameters)
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
	ArrayOfTaxes = GetTaxesInfo(Parameters.Date, Parameters.Company, Parameters.DocumentName, Parameters.TransactionType);
	
	If ValueIsFilled(Parameters.TotalAmountColumnName) And ArrayOfTaxes.Count() Then
		Form.Items[Parameters.TotalAmountColumnName].ReadOnly = ArrayOfTaxes.Count() <> 1;
	EndIf;
	
	If ValueIsFilled(Parameters.HiddenFormItemsIfNotTaxes) Then
		FormItemNames = StrSplit(Parameters.HiddenFormItemsIfNotTaxes, ",");
		IsVisible = ArrayOfTaxes.Count();
		For Each FormItemName In FormItemNames Do
			FormItemName = TrimAll(FormItemName);
			If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, FormItemName) Then
				Form.Items[FormItemName].Visible = IsVisible;
			EndIf;
		EndDo;
	EndIf;
	
	ArrayOfColumns = New Array();
	ArrayOfTaxInfo = New Array();
	ArrayOfActualTax = New Array();
	For Each ItemOfTaxes In ArrayOfTaxes Do
		ColumnInfo = New Structure();
		ColumnInfo.Insert("Name" , "_" + StrReplace(String(ItemOfTaxes.Tax.UUID()), "-", ""));
		ColumnInfo.Insert("Tax"  , ItemOfTaxes.Tax);
		ColumnInfo.Insert("Type" , ItemOfTaxes.Type);
		If ItemOfTaxes.Type = Enums.TaxType.Rate Then
			ColumnType = New TypeDescription("CatalogRef.TaxRates");
		Else
			ColumnType = Metadata.DefinedTypes.typeAmount.Type;
		EndIf;
		ArrayOfColumns.Add(New FormAttribute(ColumnInfo.Name, ColumnType, Parameters.PathToTable, String(ItemOfTaxes.Tax), True));
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
		If ValueIsFilled(Parameters.FieldProperty) Then
			For Each FieldProperty In Parameters.FieldProperty Do
				NewColumn[FieldProperty.Key] = FieldProperty.Value;
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

Function GetCreateFormControlsParameters(Object, CustomParameters)
	Parameters = New Structure();
	Parameters.Insert("Date"          , Object.Date);
	Parameters.Insert("Company"       , Object.Company);
	Parameters.Insert("DocumentName"  , Object.Ref.Metadata().Name);
	
	FieldProperty = Undefined;
	If CustomParameters.Property("FieldProperty") Then
		FieldProperty = CustomParameters.FieldProperty;
	EndIf;	
	Parameters.Insert("FieldProperty" , FieldProperty);
	
	TransactionType = Undefined;
	If CommonFunctionsClientServer.ObjectHasProperty(Object, "TransactionType") Then
		TransactionType = Object.TransactionType;
	EndIf;
	Parameters.Insert("TransactionType", TransactionType);
	
	Parameters.Insert("PathToTable");
	Parameters.Insert("ItemParent");
	Parameters.Insert("ColumnOffset");
	Parameters.Insert("ItemListName");
	Parameters.Insert("TaxListName");
	Parameters.Insert("TotalAmountColumnName");
	Parameters.Insert("HiddenFormItemsIfNotTaxes");
	Return Parameters;
EndFunction

Procedure CreateFormControls_ItemList(Object, Form, CustomParameters = Undefined) Export
	If CustomParameters = Undefined Then
		CustomParameters = New Structure();
	EndIf;
	
	TaxesParameters = GetCreateFormControlsParameters(Object, CustomParameters);
	TaxesParameters.PathToTable   = "Object.ItemList";
	TaxesParameters.ItemParent    = Form.Items.ItemList;
	
	If CustomParameters.Property("ColumnOffser") Then
		TaxesParameters.ColumnOffset = CustomParameters.ColumnOffset;
	Else
		If CommonFunctionsClientServer.ObjectHasProperty(Form.Items, "ItemListOffersAmount") Then
			TaxesParameters.ColumnOffset = Form.Items.ItemListOffersAmount;
		Else
			TaxesParameters.ColumnOffset = Form.Items.ItemListNetAmount;
		EndIf;
	EndIf;
	
	DefaultParameters = New Structure();
	DefaultParameters.Insert("ItemListName"              , "ItemList");
	DefaultParameters.Insert("TaxListName"               , "TaxList");
	DefaultParameters.Insert("TotalAmountColumnName"     , "ItemListTotalAmount");
	DefaultParameters.Insert("HiddenFormItemsIfNotTaxes", 
		"ItemListTaxAmount, ItemListNetAmount, ItemListTotalTaxAmount, ItemListTotalNetAmount");
	
	ReplaceDefaultParameters(CustomParameters, DefaultParameters, TaxesParameters);
	
	CreateFormControls(Object, Form, TaxesParameters);
EndProcedure

Procedure CreateFormControls_PaymentList(Object, Form, CustomParameters = Undefined) Export
	If CustomParameters = Undefined Then
		CustomParameters = New Structure();
	EndIf;
	
	TaxesParameters = GetCreateFormControlsParameters(Object, CustomParameters);
	TaxesParameters.PathToTable   = "Object.PaymentList";
	TaxesParameters.ItemParent    = Form.Items.PaymentList;
	
	If CustomParameters.Property("ColumnOffser")Then
		TaxesParameters.ColumnOffset = CustomParameters.ColumnOffset;
	Else
		TaxesParameters.ColumnOffset = Form.Items.PaymentListNetAmount;
	EndIf;
	
	DefaultParameters = New Structure();
	DefaultParameters.Insert("ItemListName"               , "PaymentList");
	DefaultParameters.Insert("TaxListName"                , "TaxList");
	DefaultParameters.Insert("TotalAmountColumnName"      , "PaymentListTotalAmount");
	DefaultParameters.Insert("HiddenFormItemsIfNotTaxes" , 
		"PaymentListTaxAmount, PaymentListNetAmount, PaymentListTotalTaxAmount, PaymentListTotalNetAmount");
	
	ReplaceDefaultParameters(CustomParameters, DefaultParameters, TaxesParameters);
	
	CreateFormControls(Object, Form, TaxesParameters);
EndProcedure

Procedure ReplaceDefaultParameters(Parameters, DefaultParameters, TaxesParameters)
	For Each DefaultParametr In DefaultParameters Do
		If Parameters.Property(DefaultParametr.Key) Then
			TaxesParameters[DefaultParametr.Key] = Parameters[DefaultParametr.Key];
		Else
			TaxesParameters[DefaultParametr.Key] = DefaultParametr.Value;
		EndIf;
	EndDo;
EndProcedure

Function GetDocumentsWithTax() Export
	List = New ValueList();
	For Each Document In Metadata.Documents Do
		If Not Document.TabularSections.Find("TaxList") = Undefined Then
			List.Add(Document.Name, Document.Synonym);
		EndIf;
	EndDo;
	Return List;
EndFunction
