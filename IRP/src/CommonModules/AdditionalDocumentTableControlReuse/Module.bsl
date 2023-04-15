
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
// ** SourceOfOrigins - Undefined
Function GetQuery(DocName) Export
	
	Result = New Structure;
	Result.Insert("Query", "");
	Result.Insert("Tables", New Structure);
	MetaDoc = Metadata.Documents[DocName];
	
	TmplDoc = Documents.SalesInvoice.EmptyRef();
	
	ErrorsArray = New Array; // Array of Structure
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
	
	If MetaDoc.TabularSections.Find("SourceOfOrigins") = Undefined Then
		Result.Tables.Insert("SourceOfOrigins", TmplDoc.SourceOfOrigins.Unload());
	Else
		Result.Tables.Insert("SourceOfOrigins", Undefined);
		ErrorsArray.Add(SourceOfOrigins());
	EndIf;

	GetInfo_0 = GetFilterAndFields(ErrorsArray, MetaDoc, 0);
	GetInfo_1 = GetFilterAndFields(ErrorsArray, MetaDoc, 1);
	
	Result.Query = StrTemplate(CheckDocumentsQuery(), 
		GetInfo_0.Fields, GetInfo_0.Filters, GetInfo_0.Results,
		GetInfo_1.Fields, GetInfo_1.Filters, GetInfo_1.Results
		);
	Return Result;
EndFunction

// Get error list.
// 
// Returns:
//  Array - Get error list
Function GetErrorList() Export
	ErrorsArray = New Array; // Array of Structure
	ErrorsArray.Add(ErrorItemList());
	ErrorsArray.Add(ErrorWithTax());
	ErrorsArray.Add(ErrorWithOffers());
	ErrorsArray.Add(ErrorWithSerialInTable());
	ErrorsArray.Add(SourceOfOrigins());
	
	ErrorList = New ValueList();
	For Each Errors In ErrorsArray Do
		For Each Error In Errors Do
			ErrorList.Add(Error.Key, R()["ATC_" + Error.Key]);
		EndDo;
	EndDo;
	Return ErrorList;
EndFunction

// Get filter and fields.
// 
// Parameters:
//  ErrorsArray - Array - Errors array
//  MetaDoc - MetadataObjectDocument - Meta doc
//  QueryNumber - Number - Query number
// 
// Returns:
//  Structure - Get filter and fields:
// * Fields - String -
// * Filters - String -
// * Results - String -
Function GetFilterAndFields(Val ErrorsArray, MetaDoc, QueryNumber)
	ArrayOfFilter = New Array; // Array Of String
	ArrayOfFields = New Array; // Array Of String
	For Each Row In ErrorsArray Do
		For Each Filter In Row Do
			
			If Not Filter.Value.QueryNumber = QueryNumber Then
				Continue;
			EndIf;
			
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
	
	Str = New Structure;
	Str.Insert("Fields", StrConcat(ArrayOfFields, "," + Chars.LF + Chars.Tab));
	Str.Insert("Filters", StrConcat(ArrayOfFilter, Chars.LF + "	OR	"));
	Str.Insert("Results", "Result." + StrConcat(ArrayOfFilter, "," + Chars.LF + "	Result."));
	
	Return Str;
EndFunction

Function ErrorItemList()
	Str = New Structure;
	
	Str.Insert("ErrorQuantityIsZero", New Structure("Query, Fields, QueryNumber", 
		"ItemList.Quantity <= 0", 
		"Quantity",
		0
	));
	
	Str.Insert("ErrorQuantityInBaseUnitIsZero",	New Structure("Query, Fields, QueryNumber", 
		"ItemList.QuantityInBaseUnit <= 0", 
		"QuantityInBaseUnit",
		0
	));
	
	Str.Insert("ErrorQuantityNotEqualQuantityInBaseUnit",	New Structure("Query, Fields, QueryNumber", 
		"Unit.Quantity = 1 AND Not ItemList.QuantityInBaseUnit = ItemList.Quantity", 
		"Quantity, QuantityInBaseUnit, Unit",
		0
	));
	
	Str.Insert("ErrorItemTypeIsNotService",	New Structure("Query, Fields, QueryNumber",
		"Not ItemList.IsService = (ItemList.Item.ItemType.Type = VAlUE(Enum.ItemTypes.Service))", 
		"IsService, Item",
		0
	));
	
	Str.Insert("ErrorItemNotEqualItemInItemKey", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.Item = ItemList.ItemKey.Item",
		"Item, ItemKey",
		0
	));
	
	Str.Insert("ErrorQuantityInItemListNotEqualQuantityInRowID", New Structure("Query, Fields, QueryNumber",
		"Not ItemList.Quantity = isNull(RowIDInfo.Quantity, 0)",
		"Quantity",
		0
	));
	
	Return Str;
EndFunction

Function ErrorWithTax()
	Str = New Structure;
	
	Str.Insert("ErrorTaxAmountInItemListNotEqualTaxAmountInTaxList", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.TaxAmount = isNull(TaxList.Amount, 0)",
		"TaxAmount",
		0
	));
	
	Str.Insert("ErrorNetAmountGreaterTotalAmount", New Structure("Query, Fields, QueryNumber", 
		"ItemList.NetAmount > ItemList.TotalAmount",
		"NetAmount, TotalAmount",
		0
	));
	
	Str.Insert("ErrorTotalAmountMinusNetAmountNotEqualTaxAmount", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.DontCalculateRow And Not (ItemList.TotalAmount - ItemList.NetAmount = ItemList.TaxAmount)",
		"DontCalculateRow, TotalAmount, NetAmount, TaxAmount",
		0
	));
	
	Return Str;
EndFunction

Function ErrorWithOffers()
	Str = New Structure;
	
	Str.Insert("ErrorOffersAmountInItemListNotEqualOffersAmountInOffersList", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.OffersAmount = isNull(SpecialOffers.Amount, 0)",
		"OffersAmount",
		0
	));
	
	Return Str;
EndFunction

Function ErrorWithSerialInTable()
	Str = New Structure;
	
	Str.Insert("ErrorItemTypeUseSerialNumbers", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.UseSerialLotNumber = ItemList.Item.ItemType.UseSerialLotNumber",
		"UseSerialLotNumber, Item",
		0
	));
	
	Str.Insert("ErrorUseSerialButSerialNotSet", New Structure("Query, Fields, QueryNumber", 
		"ItemList.UseSerialLotNumber And isNull(SerialLotNumbers.Quantity, 0) = 0",
		"UseSerialLotNumber",
		0
	));
	
	Str.Insert("ErrorNotTheSameQuantityInSerialListTableAndInItemList", New Structure("Query, Fields, QueryNumber", 
		"ItemList.UseSerialLotNumber AND Not isNull(SerialLotNumbers.Quantity, 0) = ItemList.Quantity",
		"UseSerialLotNumber, Quantity",
		0
	));
	Return Str;
EndFunction

Function SourceOfOrigins()
	Str = New Structure;
	
	Str.Insert("ErrorNotFilledQuantityInSourceOfOrigins", New Structure("Query, Fields, QueryNumber", 
		"SourceOfOrigins.Quantity IS NULL AND NOT SerialLotNumbers.Quantity IS NULL",
		"Quantity",
		1
	));
	
	Str.Insert("ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber", New Structure("Query, Fields, QueryNumber", 
		"Not SerialLotNumbers.Quantity = SourceOfOrigins.Quantity",
		"Quantity",
		1
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
	|	SerialLotNumbers.Quantity,
	|	SerialLotNumbers.SerialLotNumber
	|INTO SerialLotNumbersTmp
	|FROM
	|	&SerialLotNumbers AS SerialLotNumbers
	|;      
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SourceOfOrigins.Key,
	|	SourceOfOrigins.Quantity,
	|	SourceOfOrigins.SerialLotNumber
	|INTO SourceOfOriginsTmp
	|FROM
	|	&SourceOfOrigins AS SourceOfOrigins
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SourceOfOrigins.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.Quantity AS Quantity
	|INTO SourceOfOrigins
	|FROM
	|	SourceOfOriginsTmp AS SourceOfOrigins
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SerialLotNumbers.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity AS Quantity
	|INTO SerialLotNumbersForSourceOfOrigins
	|FROM
	|	SerialLotNumbersTmp AS SerialLotNumbers
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
	|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
	|		ON False
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	ItemList.LineNumber,
	|	%4
	|INTO ResultSourceOfOrigins
	|FROM
	|	ItemList AS ItemList
	|		LEFT JOIN SerialLotNumbersForSourceOfOrigins AS SerialLotNumbers
	|		ON ItemList.Key = SerialLotNumbers.Key
	|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
	|		ON SerialLotNumbers.Key = SourceOfOrigins.Key 
	|		AND SerialLotNumbers.SerialLotNumber = SourceOfOrigins.SerialLotNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Key,
	|	Result.LineNumber,
	|	%3
	|FROM
	|	Result AS Result
	|WHERE %2
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Key,
	|	Result.LineNumber,
	|	%6
	|FROM
	|	ResultSourceOfOrigins AS Result
	|WHERE %5";
EndFunction