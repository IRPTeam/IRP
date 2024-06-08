
// Tax rates

// Get vat ref.
// 
// Returns:
//  CatalogRef.Taxes -  Get vat ref
Function GetVatRef() Export
	Return ServerReuse.GetVatRef();
EndFunction

Function _GetVatRef() Export
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	Taxes.Ref
	|FROM
	|	Catalog.Taxes AS Taxes
	|WHERE
	|	Taxes.Kind = VALUE(Enum.TaxKind.VAT)
	|	AND NOT Taxes.DeletionMark";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	_vat = Undefined;
	If QuerySelection.Next() Then
		_vat = QuerySelection.Ref;
	EndIf;
	Return _vat;
EndFunction

Function GetVatRateByPriority(Parameters) Export
	
	_vat = GetVatRef();
	
	If Not ValueIsFilled(_vat) Then
		Return Catalogs.TaxRates.EmptyRef();
	EndIf;
	
	Parameters.Insert("Tax", _vat);
	
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

Function GetTaxesInfo(Date, Company, DocumentName, TransactionType, TaxKind = Undefined) Export
	Return _GetTaxesInfo(Date, Company, DocumentName, TransactionType, TaxKind);
EndFunction

Function _GetTaxesInfo(Date, Company, DocumentName, TransactionType, TaxKind) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	TaxesSliceLast.Tax AS Tax,
	|	TaxesSliceLast.Tax.Type AS Type
	|INTO AllTaxes
	|FROM
	|	InformationRegister.Taxes.SliceLast(&Date, Company = &Company
	|	AND Tax.Kind = &TaxKind) AS TaxesSliceLast
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
	Query.SetParameter("TaxKind"        , TaxKind);
	
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

Function GetDocumentsWithTax() Export
	List = New ValueList();
	For Each Document In Metadata.Documents Do
		FindTaxInTabularSection(Document, "PaymentList"  , List);
		FindTaxInTabularSection(Document, "ItemList"     , List);
		FindTaxInTabularSection(Document, "Transactions" , List);
		
//		If Document.TabularSections.Find("PaymentList") <> Undefined Then
//			For Each _column In Document.TabularSections.PaymentList.Attributes Do
//				If Upper(_column.Name) = Upper("VatRate") Then
//					List.Add(Document.Name, Document.Synonym);
//					Break;
//				EndIf;
//			EndDo;					
//		EndIf;
//		
//		If Document.TabularSections.Find("ItemList") <> Undefined Then
//			For Each _column In Document.TabularSections.ItemList.Attributes Do
//				If Upper(_column.Name) = Upper("VatRate") Then
//					List.Add(Document.Name, Document.Synonym);
//					Break;
//				EndIf;
//			EndDo;					
//		EndIf;
		
	EndDo;
	Return List;
EndFunction

Procedure FindTaxInTabularSection(Document, TabularSectionName, List)
	If Document.TabularSections.Find(TabularSectionName) <> Undefined Then
		For Each _column In Document.TabularSections[TabularSectionName].Attributes Do
			If Upper(_column.Name) = Upper("VatRate") Then
				List.Add(Document.Name, Document.Synonym);
				Break;
			EndIf;
		EndDo;					
	EndIf;
EndProcedure



