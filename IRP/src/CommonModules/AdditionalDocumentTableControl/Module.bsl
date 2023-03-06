
// Check document.
// 
// Parameters:
//  Document - DefinedType.AdditionalTableControlDocObject, DefinedType.AdditionalTableControlDocRef -
// 
// Returns:
//  Array of String
Function CheckDocument(Document) Export
	DocType = TypeOf(Document);
	If Metadata.DefinedTypes.AdditionalTableControlDocRef.Type.ContainsType(DocType) Then
		DocManager = Documents[Document.Metadata().Name];
	ElsIf Metadata.DefinedTypes.AdditionalTableControlDocObject.Type.ContainsType(DocType) Then
		DocManager = Document;
	Else
		Raise StrTemplate(R().ATC_001, DocType);
	EndIf;
	
	Tables = TablesStructure();
	DocManager.SetTablesForAdditionalCheck(Tables, Document);
	Return AdditionalTableControl(Tables, Document);
EndFunction

// Additional table control.
// 
// Parameters:
//  Tables - See TablesStructure
//  Object - DocumentObjectDocumentName, DocumentObject.SalesInvoice -
// 
// Returns:
//  Array of String
Function AdditionalTableControl(Tables, Object)
	
	Result = CheckDocumentsResult(Tables);
	Errors = New Array; // Array of String

	For Each Row In Result Do
		For Each Column In Result.Columns Do
			If StrStartsWith(Column.Name, "Error") Then
				If Row[Column.Name] Then
					Errors.Add(StrTemplate(R()["ATC_" + Column.Name], Row.LineNumber));
				EndIf;
			EndIf;
		EndDo;
	EndDo;
	
	Return Errors;
EndFunction

// Check documents result.
// 
// Parameters:
//  Tables - See TablesStructure
// 
// Returns:
//  ValueTable - Check documents result:
//	* Key - String
//	* LineNumber - Number
//	* ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList          - Boolean
//	* ErrorNetAmountGreaterTotalAmount                            - Boolean
//	* ErrorQuantityIsZero                                         - Boolean
//	* ErrorQuantityInBaseUnitIsZero                               - Boolean
//	* ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList - Boolean
//	* ErrorItemTypeIsNotService                                   - Boolean
//	* ErrorItemTypeUseSerialNumbers                               - Boolean
//	* ErrorUseSerialButSerialNotSet                               - Boolean
//	* ErrorNotTheSameQuantityInSerialListTableAndInItemList       - Boolean
//	* ErrorItemNotEqualItemInItemKey                              - Boolean
//	* ErrorTotalAmountMinusNetAmountNotEqualTaxAmount             - Boolean
//	* ErrorQuantityInItemListNotEqualQuantityInRowID              - Boolean
Function CheckDocumentsResult(Tables)
	Query = New Query;
	Query.Text = CheckDocumentsQuery();
		
	TmplDoc = Documents.SalesInvoice.EmptyRef();
	
	Query.SetParameter("ItemList", Tables.ItemList);
	Query.SetParameter("RowIDInfo", Tables.RowIDInfo);
	Query.SetParameter("IsAmount", Not Tables.ItemList.Columns.Find("TotalAmount") = Undefined);
	
	If Tables.TaxList = Undefined Then
		Query.SetParameter("TaxList", TmplDoc.TaxList.Unload());
		Query.SetParameter("IsTax", False);
	Else
		Query.SetParameter("TaxList", Tables.TaxList);
		Query.SetParameter("IsTax", True);
	EndIf;
	
	If Tables.SpecialOffers = Undefined Then
		Query.SetParameter("SpecialOffers", TmplDoc.SpecialOffers.Unload());
		Query.SetParameter("IsOffers", False);
	Else
		Query.SetParameter("SpecialOffers", Tables.SpecialOffers);
		Query.SetParameter("IsOffers", True);
	EndIf;
		
	If Tables.SerialLotNumbers = Undefined Then
		Query.SetParameter("SerialLotNumbers", TmplDoc.SerialLotNumbers.Unload());
		Query.SetParameter("IsSerial", False);
	Else
		Query.SetParameter("SerialLotNumbers", Tables.SerialLotNumbers);
		Query.SetParameter("IsSerial", True);
	EndIf;
	
	Return Query.Execute().Unload();
EndFunction

Function CheckDocumentsQuery()
	Return 
	"SELECT
	|	ItemList.LineNumber,
	|	ItemList.Key,
	|	ItemList.*
	|INTO ItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SpecialOffers.Key,
	|	SpecialOffers.Amount
	|INTO SpecialOffersTmp
	|FROM
	|	&SpecialOffers AS SpecialOffers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SpecialOffers.Key,
	|	SUM(SpecialOffers.Amount) AS Amount
	|INTO SpecialOffers
	|FROM
	|	SpecialOffersTmp AS SpecialOffers
	|GROUP BY
	|	SpecialOffers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxList.Key,
	|	TaxList.Amount,
	|	TaxList.ManualAmount
	|INTO TaxListTmp
	|FROM
	|	&TaxList AS TaxList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TaxList.Key,
	|	SUM(TaxList.Amount) AS Amount,
	|	SUM(TaxList.ManualAmount) AS ManualAmount
	|INTO TaxList
	|FROM
	|	TaxListTmp AS TaxList
	|GROUP BY
	|	TaxList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.Quantity
	|INTO SerialLotNumbersTmp
	|FROM
	|	&SerialLotNumbers AS SerialLotNumbers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SUM(SerialLotNumbers.Quantity) AS Quantity
	|INTO SerialLotNumbers
	|FROM
	|	SerialLotNumbersTmp AS SerialLotNumbers
	|GROUP BY
	|	SerialLotNumbers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.Key,
	|	RowIDInfo.Quantity
	|INTO RowIDInfoTmp
	|FROM
	|	&RowIDInfo AS RowIDInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.Key,
	|	SUM(RowIDInfo.Quantity) AS Quantity
	|INTO RowIDInfo
	|FROM
	|	RowIDInfoTmp AS RowIDInfo
	|GROUP BY
	|	RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	ItemList.LineNumber,
	|	ISNULL(RowIDInfo.Quantity, 0) AS RowIDQuantity,
	|	ISNULL(SerialLotNumbers.Quantity, 0) AS SerialLotNumbersQuantity,
	|	ISNULL(SpecialOffers.Amount, 0) AS SpecialOffersAmount,
	|	ISNULL(TaxList.ManualAmount, 0) AS TaxManualAmount,
	|	ItemList.*
	|INTO ResultTable
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN SpecialOffers AS SpecialOffers
	|		ON ItemList.Key = SpecialOffers.Key
	|		LEFT JOIN RowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|		LEFT JOIN SerialLotNumbers AS SerialLotNumbers
	|		ON ItemList.Key = SerialLotNumbers.Key
	|		LEFT JOIN TaxList AS TaxList
	|		ON ItemList.Key = TaxList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ResultTable.Key,
	|	ResultTable.LineNumber,
	|	CASE WHEN &IsTax THEN
	|		Not ResultTable.TaxAmount = ResultTable.TaxManualAmount
	|	ELSE
	|		FALSE
	|	END	AS ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList,
	|	CASE WHEN &IsAmount THEN
	|		ResultTable.NetAmount > ResultTable.TotalAmount 
	|	ELSE
	|		FALSE
	|	END	AS ErrorNetAmountGreaterTotalAmount,
	|	ResultTable.Quantity <= 0 AS ErrorQuantityIsZero,
	|	ResultTable.QuantityInBaseUnit <= 0 AS ErrorQuantityInBaseUnitIsZero,
	|	CASE WHEN &IsOffers THEN
	|		Not ResultTable.OffersAmount = ResultTable.SpecialOffersAmount
	|	ELSE
	|		FALSE
	|	END	AS ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList,
	|	Not ResultTable.IsService = (ResultTable.Item.ItemType.Type = VAlUE(Enum.ItemTypes.Service)) AS ErrorItemTypeIsNotService,
	|	CASE WHEN &IsSerial THEN
	|		Not ResultTable.UseSerialLotNumber = ResultTable.Item.ItemType.UseSerialLotNumber
	|	ELSE
	|		FALSE
	|	END AS ErrorItemTypeUseSerialNumbers,
	|	CASE WHEN &IsSerial THEN
	|		ResultTable.UseSerialLotNumber And ResultTable.SerialLotNumbersQuantity = 0
	|	ELSE
	|		FALSE
	|	END AS ErrorUseSerialButSerialNotSet,
	|	CASE WHEN &IsSerial THEN
	|		ResultTable.UseSerialLotNumber AND Not ResultTable.SerialLotNumbersQuantity = ResultTable.Quantity
	|	ELSE
	|		FALSE
	|	END AS ErrorNotTheSameQuantityInSerialListTableAndInItemList,
	|	Not ResultTable.Item = ResultTable.ItemKey.Item AS ErrorItemNotEqualItemInItemKey,
	|	CASE WHEN &IsTax THEN
	|		Not ResultTable.DontCalculateRow And Not (ResultTable.TotalAmount - ResultTable.NetAmount = ResultTable.TaxAmount) 
	|	ELSE
	|		FALSE
	|	END AS ErrorTotalAmountMinusNetAmountNotEqualTaxAmount,
	|	Not ResultTable.Quantity = ResultTable.RowIDQuantity AS ErrorQuantityInItemListNotEqualQuantityInRowID
	|INTO Result
	|FROM
	|	ResultTable AS ResultTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Key,
	|	Result.LineNumber,
	|	Result.ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList,
	|	Result.ErrorNetAmountGreaterTotalAmount,
	|	Result.ErrorQuantityIsZero,
	|	Result.ErrorQuantityInBaseUnitIsZero,
	|	Result.ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList,
	|	Result.ErrorItemTypeIsNotService,
	|	Result.ErrorItemTypeUseSerialNumbers,
	|	Result.ErrorUseSerialButSerialNotSet,
	|	Result.ErrorNotTheSameQuantityInSerialListTableAndInItemList,
	|	Result.ErrorItemNotEqualItemInItemKey,
	|	Result.ErrorTotalAmountMinusNetAmountNotEqualTaxAmount,
	|	Result.ErrorQuantityInItemListNotEqualQuantityInRowID
	|FROM
	|	Result AS Result
	|WHERE
	|	ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList
	|	OR ErrorNetAmountGreaterTotalAmount
	|	OR ErrorQuantityIsZero
	|	OR ErrorQuantityInBaseUnitIsZero
	|	OR ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList
	|	OR ErrorItemTypeIsNotService
	|	OR ErrorItemTypeUseSerialNumbers
	|	OR ErrorUseSerialButSerialNotSet
	|	OR ErrorNotTheSameQuantityInSerialListTableAndInItemList
	|	OR ErrorItemNotEqualItemInItemKey
	|	OR ErrorTotalAmountMinusNetAmountNotEqualTaxAmount
	|	OR ErrorQuantityInItemListNotEqualQuantityInRowID";
EndFunction

// Tables structure.
// 
// Returns:
//  Structure - Tables structure:
// * ItemList - ValueTable -
// * SpecialOffers - ValueTable -
// * TaxList - ValueTable -
// * SerialLotNumbers - ValueTable -
// * RowIDInfo - ValueTable -
Function TablesStructure() Export
	
	Str = New Structure;
	Str.Insert("ItemList", Undefined);
	Str.Insert("SpecialOffers", Undefined);
	Str.Insert("TaxList", Undefined);
	Str.Insert("SerialLotNumbers", Undefined);
	Str.Insert("RowIDInfo", Undefined);
	Return Str;
EndFunction