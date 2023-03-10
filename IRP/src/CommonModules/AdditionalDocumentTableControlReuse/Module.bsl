
// Get query.
// 
// Parameters:
//  DocName - String - Doc name
// 
// Returns:
//  Structure - Get query:
// * Query - String -
// * Tables - Structure:
// ** TaxList - Undefined
// ** SpecialOffers - Undefined
// ** SerialLotNumbers - Undefined
Function GetQuery(DocName) Export
	
	Result = New Structure;
	Result.Insert("Query", "");
	Result.Insert("Tables", New Structure);
	MetaDoc = Metadata.Documents[DocName];
	
	ErrorsArray = New Array; // Array of Structure
	TmplDoc = Documents.SalesInvoice.EmptyRef();
	
	ErrorsArray.Add(ErrorItemList());
	
	If MetaDoc.TabularSections.Find("TaxList") = Undefined Then
		Result.Tables.Insert("TaxList", TmplDoc.TaxList.Unload());
	Else
		Result.Tables.Insert("TaxList", Undefined);
		ErrorsArray.Add(ErrorWithTax());
	EndIf;
	
	If MetaDoc.TabularSections.Find("SpecialOffers") = Undefined Then
		Result.Tables.Insert("SpecialOffers", TmplDoc.SpecialOffers.Unload());
	Else
		Result.Tables.Insert("SpecialOffers", Undefined);
		ErrorsArray.Add(ErrorWithOffers());
	EndIf;
		
	If MetaDoc.TabularSections.Find("SerialLotNumbers") = Undefined Then
		Result.Tables.Insert("SerialLotNumbers", TmplDoc.SerialLotNumbers.Unload());
	Else
		Result.Tables.Insert("SerialLotNumbers", Undefined);
		ErrorsArray.Add(ErrorWithSerialInTable());
	EndIf;
	
	ArrayOfFilter = New Array; // Array Of String
	ArrayOfFields = New Array; // Array Of String
	For Each Row In ErrorsArray Do
		For Each Filter In Row Do
			
			Skip = False;
			// @skip-check invocation-parameter-type-intersect, property-return-type
			For Each Field In StrSplit(Filter.Value.Fields, " ,", False) Do
				If MetaDoc.TabularSections.ItemList.Attributes.Find(Field) = Undefined Then
					Skip = True;
				EndIf;  
			EndDo;
			
			If Skip Then
				Continue;
			EndIf;
			
			ArrayOfFilter.Add(Filter.Key);
			ArrayOfFields.Add(Filter.Value.Query + " AS " + Filter.Key);
		EndDo;
	EndDo;
	
	Result.Query = StrTemplate(CheckDocumentsQuery(), 
		StrConcat(ArrayOfFields, "," + Chars.LF + Chars.Tab), 
		StrConcat(ArrayOfFilter, Chars.LF + "	OR	"),
		"Result." + StrConcat(ArrayOfFilter, "," + Chars.LF + "	Result."));
	Return Result;
EndFunction


Function ErrorItemList()
	Str = New Structure;
	
	Str.Insert("ErrorQuantityIsZero", New Structure("Query, Fields", 
		"ItemList.Quantity <= 0", 
		"Quantity"
	));
	
	Str.Insert("ErrorQuantityInBaseUnitIsZero",	New Structure("Query, Fields", 
		"ItemList.QuantityInBaseUnit <= 0", 
		"QuantityInBaseUnit"
	));
	
	Str.Insert("ErrorQuantityNotEqualQuantityInBaseUnit",	New Structure("Query, Fields", 
		"Unit.Quantity = 1 AND Not ItemList.QuantityInBaseUnit = ItemList.Quantity", 
		"Quantity, QuantityInBaseUnit, Unit"
	));
	
	Str.Insert("ErrorItemTypeIsNotService",	New Structure("Query, Fields",
		"Not ItemList.IsService = (ItemList.Item.ItemType.Type = VAlUE(Enum.ItemTypes.Service))", 
		"IsService, Item"
	));
	
	Str.Insert("ErrorItemNotEqualItemInItemKey", New Structure("Query, Fields", 
		"Not ItemList.Item = ItemList.ItemKey.Item",
		"Item, ItemKey"
	));
	
	Str.Insert("ErrorQuantityInItemListNotEqualQuantityInRowID", New Structure("Query, Fields",
		"Not ItemList.Quantity = isNull(RowIDInfo.Quantity, 0)",
		"Quantity"
	));
	
	Return Str;
EndFunction

Function ErrorWithTax()
	Str = New Structure;
	
	Str.Insert("ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList", New Structure("Query, Fields", 
		"Not ItemList.TaxAmount = isNull(TaxList.Amount, 0)",
		"TaxAmount"
	));
	
	Str.Insert("ErrorNetAmountGreaterTotalAmount", New Structure("Query, Fields", 
		"ItemList.NetAmount > ItemList.TotalAmount",
		"NetAmount, TotalAmount"
	));
	
	Str.Insert("ErrorTotalAmountMinusNetAmountNotEqualTaxAmount", New Structure("Query, Fields", 
		"Not ItemList.DontCalculateRow And Not (ItemList.TotalAmount - ItemList.NetAmount = ItemList.TaxAmount)",
		"DontCalculateRow, TotalAmount, NetAmount, TaxAmount"
	));
	
	Return Str;
EndFunction

Function ErrorWithOffers()
	Str = New Structure;
	
	Str.Insert("ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList", New Structure("Query, Fields", 
		"Not ItemList.OffersAmount = isNull(SpecialOffers.Amount, 0)",
		"OffersAmount"
	));
	
	Return Str;
EndFunction

Function ErrorWithSerialInTable()
	Str = New Structure;
	
	Str.Insert("ErrorItemTypeUseSerialNumbers", New Structure("Query, Fields", 
		"Not ItemList.UseSerialLotNumber = ItemList.Item.ItemType.UseSerialLotNumber",
		"UseSerialLotNumber, Item"
	));
	
	Str.Insert("ErrorUseSerialButSerialNotSet", New Structure("Query, Fields", 
		"ItemList.UseSerialLotNumber And isNull(SerialLotNumbers.Quantity, 0) = 0",
		"UseSerialLotNumber"
	));
	
	Str.Insert("ErrorNotTheSameQuantityInSerialListTableAndInItemList", New Structure("Query, Fields", 
		"ItemList.UseSerialLotNumber AND Not isNull(SerialLotNumbers.Quantity, 0) = ItemList.Quantity",
		"UseSerialLotNumber, Quantity"
	));
	Return Str;
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
	|	SUM(TaxList.ManualAmount) AS Amount
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
	|	%1
	|INTO Result
	|FROM
	|	ItemList AS ItemList
	|	LEFT JOIN SpecialOffers AS SpecialOffers
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
	|	Result.Key,
	|	Result.LineNumber,
	|	%3
	|FROM
	|	Result AS Result
	|WHERE %2";
EndFunction