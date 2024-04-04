
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
// ** RowIDInfo - Undefined
// ** Payments - Undefined
Function GetQuery(DocName) Export
	
	Result = New Structure;
	Result.Insert("Query", "");
	Result.Insert("Tables", New Structure);
	MetaDoc = Metadata.Documents[DocName];
	
	TmplDoc = Documents.RetailSalesReceipt.EmptyRef();
	
	ErrorsArray = New Array; // Array of Structure
	ErrorsArray.Add(ErrorWithHeaders(MetaDoc));
	
	If MetaDoc.TabularSections.Find("ItemList") = Undefined Then
		Result.Tables.Insert("ItemList", TmplDoc.ItemList.Unload());
	Else
		Result.Tables.Insert("ItemList", Undefined);
		ErrorsArray.Add(ErrorWithItemList());
	EndIf;
		
	If MetaDoc.TabularSections.Find("RowIDInfo") = Undefined Then
		Result.Tables.Insert("RowIDInfo", TmplDoc.RowIDInfo.Unload());
	Else
		Result.Tables.Insert("RowIDInfo", Undefined);
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
		ErrorsArray.Add(ErrorWithSourceOfOrigins());
	EndIf;

	If MetaDoc.TabularSections.Find("Payments") = Undefined Then
		Result.Tables.Insert("Payments", TmplDoc.Payments.Unload());
	Else
		Result.Tables.Insert("Payments", Undefined);
		ErrorsArray.Add(ErrorWithPayments());
	EndIf;

	GetInfo_0 = GetFilterAndFields(ErrorsArray, MetaDoc, 0); // Other tables
	GetInfo_1 = GetFilterAndFields(ErrorsArray, MetaDoc, 1); // SourceOfOrigins table
	GetInfo_2 = GetFilterAndFields(ErrorsArray, MetaDoc, 2); // Headers table
	GetInfo_3 = GetFilterAndFields(ErrorsArray, MetaDoc, 3); // Payments table
	
	TextQuery = CheckDocumentsQuery();
	TextQuery = StrReplace(TextQuery, "%10", GetInfo_3.Fields);
	TextQuery = StrReplace(TextQuery, "%11", GetInfo_3.Filters);
	TextQuery = StrReplace(TextQuery, "%12", GetInfo_3.Results);
	Result.Query = StrTemplate(TextQuery, 
		GetInfo_0.Fields, GetInfo_0.Filters, GetInfo_0.Results,
		GetInfo_1.Fields, GetInfo_1.Filters, GetInfo_1.Results,
		GetInfo_2.Fields, GetInfo_2.Filters, GetInfo_2.Results
		);
	Return Result;
EndFunction

// Get error list.
// 
// Returns:
//  Array - Get error list
Function GetErrorList() Export
	ErrorsArray = New Array; // Array of Structure
	ErrorsArray.Add(ErrorWithHeaders());
	ErrorsArray.Add(ErrorWithItemList());
	ErrorsArray.Add(ErrorWithOffers());
	ErrorsArray.Add(ErrorWithSerialInTable());
	ErrorsArray.Add(ErrorWithSourceOfOrigins());
	ErrorsArray.Add(ErrorWithPayments());
	
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
	
	Exceptions = GetExceptionsByDocument();
	
	DocName = MetaDoc.Name;
	For Each Row In ErrorsArray Do
		For Each Filter In Row Do
			
			If Not Filter.Value.QueryNumber = QueryNumber Then
				Continue;
			EndIf;
			
			If Exceptions.Property(DocName) Then
				ArrayOfExceptions = StrSplit(Exceptions[DocName], ",");
				IsException = False;
				For Each ItemOfException In ArrayOfExceptions Do
					If Upper(TrimAll(Filter.Key)) = Upper(TrimAll(ItemOfException)) Then
						IsException = True;
					EndIf;
				EndDo;
				If IsException Then
					Continue;
				EndIf;
			EndIf;
			
			Skip = False;
			// @skip-check invocation-parameter-type-intersect, property-return-type
			If QueryNumber = 2 Then // headers of documents
				For Each Field In StrSplit(Filter.Value.Fields, " ,", False) Do
					If MetaDoc.Attributes.Find(Field) = Undefined Then
						Skip = True;
					EndIf;  
				EndDo;
			ElsIf QueryNumber = 3 Then // payments
				For Each Field In StrSplit(Filter.Value.Fields, " ,", False) Do
					If MetaDoc.TabularSections.Payments.Attributes.Find(Field) = Undefined Then
						Skip = True;
					EndIf;  
				EndDo;
			Else
				If Not MetaDoc.TabularSections.Find("ItemList") = Undefined Then
					For Each Field In StrSplit(Filter.Value.Fields, " ,", False) Do
						If MetaDoc.TabularSections.ItemList.Attributes.Find(Field) = Undefined Then
							Skip = True;
						EndIf;  
					EndDo;
				Else
					Skip = True;
				EndIf;
			EndIf;
			
			If Skip Then
				Continue;
			EndIf;
			
			ArrayOfFilter.Add(Filter.Key);
			ArrayOfFields.Add(Filter.Value.Query + " AS " + Filter.Key);
		EndDo;
	EndDo;
	
	Str = New Structure;
	If ArrayOfFields.Count() = 0 Then
		Str.Insert("Fields", "FALSE");
	Else
		Str.Insert("Fields", StrConcat(ArrayOfFields, "," + Chars.LF + Chars.Tab));
	EndIf;
	
	If ArrayOfFilter.Count() = 0 Then
		Str.Insert("Filters", "FALSE");
		Str.Insert("Results", "FALSE");
	Else
		Str.Insert("Filters", StrConcat(ArrayOfFilter, Chars.LF + "	OR	"));
		Str.Insert("Results", "Result." + StrConcat(ArrayOfFilter, "," + Chars.LF + "	Result."));
	EndIf;
	
	Return Str;
EndFunction

Function GetExceptionsByDocument()
	Var Exceptions;
	Exceptions = New Structure();
	Exceptions.Insert("SalesReportToConsignor", 
		"ErrorQuantityIsZero, ErrorQuantityInBaseUnitIsZero, ErrorNetAmountGreaterTotalAmount,
		|ErrorTotalAmountMinusNetAmountNotEqualTaxAmount");
		
	Exceptions.Insert("SalesReportFromTradeAgent", 
		"ErrorQuantityIsZero, ErrorQuantityInBaseUnitIsZero, ErrorNetAmountGreaterTotalAmount,
		|ErrorTotalAmountMinusNetAmountNotEqualTaxAmount");
	Return Exceptions
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
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SourceOfOrigins.Key,
	|	SUM(SourceOfOrigins.Quantity) AS Quantity
	|INTO SourceOfOrigins
	|FROM
	|	SourceOfOriginsTmp AS SourceOfOrigins
	|GROUP BY
	|	SourceOfOrigins.Key
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SourceOfOrigins.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.Quantity AS Quantity
	|INTO SourceOfOriginsForSourceOfOrigins
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
	|		LEFT JOIN SourceOfOrigins AS SourceOfOrigins
	|		ON ItemList.Key = SourceOfOrigins.Key
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
	|		LEFT JOIN SourceOfOriginsForSourceOfOrigins AS SourceOfOrigins
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
	|WHERE %5
	|
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Headers.Ref,
	|	%7
	|INTO Headers
	|FROM
	|	&Headers AS Headers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Ref,
	|	"""" AS Key,
	|	0 AS LineNumber,
	|	%9
	|FROM
	|	Headers AS Result
	|WHERE %8
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Payments.LineNumber,
	|	Payments.Key,
	|	Payments.*
	|INTO tmpPayments
	|FROM
	|	&Payments AS Payments
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Payments.LineNumber,
	|	Payments.Key,
	|	%10
	|INTO Payments
	|FROM
	|	tmpPayments AS Payments
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Key,
	|	Result.LineNumber,
	|	%12
	|FROM
	|	Payments AS Result
	|WHERE %11";
EndFunction

// Get query for documents array.
// 
// Parameters:
//  MetaDocName - String - Name of document
// 
// Returns:
//  String - A query for document array
Function GetQueryForDocumentArray(MetaDocName) Export
	
	MetaDoc = Metadata.Documents[MetaDocName];
	ErrorsArray = New Array; // Array of Structure
	ErrorsArray.Add(ErrorWithHeaders(MetaDoc));

	QueryTextArray = New Array; // Array Of String

	Exists_ItemList 		= MetaDoc.TabularSections.Find("ItemList") 			<> Undefined;
	If Exists_ItemList Then // ignore price list
		Exists_ItemList = MetaDoc.TabularSections.ItemList.Attributes.Find("Key") <> Undefined;
	EndIf;
	
	Exists_RowIDInfo 		= MetaDoc.TabularSections.Find("RowIDInfo") 		<> Undefined;
	Exists_SpecialOffers 	= MetaDoc.TabularSections.Find("SpecialOffers") 	<> Undefined;
	Exists_SerialLotNumbers = MetaDoc.TabularSections.Find("SerialLotNumbers") 	<> Undefined;
	Exists_SourceOfOrigins 	= MetaDoc.TabularSections.Find("SourceOfOrigins") 	<> Undefined;
	Exists_Payments 		= MetaDoc.TabularSections.Find("Payments") 			<> Undefined;

	If Exists_ItemList Then	
		QueryTextArray.Add(GetQuery_ItemList());
		ErrorsArray.Add(ErrorWithItemList());
	EndIf;
	
	If Exists_RowIDInfo Then
		QueryTextArray.Add(GetQuery_RowIDInfo());
	EndIf;
	
	If Exists_SpecialOffers Then
		QueryTextArray.Add(GetQuery_SpecialOffers());
		ErrorsArray.Add(ErrorWithOffers());
	EndIf;

	If Exists_SerialLotNumbers Then
		QueryTextArray.Add(GetQuery_SerialLotNumbers());
		ErrorsArray.Add(ErrorWithSerialInTable());
	EndIf;
	
	If Exists_SourceOfOrigins Then
		QueryTextArray.Add(GetQuery_SourceOfOrigins(MetaDoc));
		ErrorsArray.Add(ErrorWithSourceOfOrigins());
	EndIf;
	
	GetInfo_0 = GetFilterAndFields(ErrorsArray, MetaDoc, 0); // Other tables
	GetInfo_1 = GetFilterAndFields(ErrorsArray, MetaDoc, 1); // SourceOfOrigins table
	GetInfo_2 = GetFilterAndFields(ErrorsArray, MetaDoc, 2); // Headers table
	GetInfo_3 = GetFilterAndFields(ErrorsArray, MetaDoc, 3); // Payments table

	If Exists_Payments Then
		QueryTextArray.Add(GetQuery_Payments(GetInfo_3));
		ErrorsArray.Add(ErrorWithPayments());
	EndIf;
	
	If Exists_ItemList Then
		ItemListQuery = New Array; // Array Of String
		ItemListQuery.Add("SELECT
			|	ItemList.Ref,
			|	ItemList.Key,
			|	ItemList.LineNumber,
			|	" + GetInfo_0.Fields + "
			|INTO Result
			|FROM
			|	ItemList AS ItemList");
			
		If Exists_SpecialOffers Then
			ItemListQuery.Add("
			|	LEFT JOIN SpecialOffers AS SpecialOffers
			|		ON ItemList.Ref = SpecialOffers.Ref AND ItemList.Key = SpecialOffers.Key");
		EndIf;	
		If Exists_RowIDInfo Then
			ItemListQuery.Add("
			|	LEFT JOIN RowIDInfo AS RowIDInfo
			|		ON ItemList.Ref = RowIDInfo.Ref AND ItemList.Key = RowIDInfo.Key");
		EndIf;			
		If Exists_SerialLotNumbers Then
			ItemListQuery.Add("
			|	LEFT JOIN SerialLotNumbers AS SerialLotNumbers
			|		ON ItemList.Ref = SerialLotNumbers.Ref AND ItemList.Key = SerialLotNumbers.Key");
		EndIf;				
		If Exists_SourceOfOrigins Then
			ItemListQuery.Add("
			|	LEFT JOIN SourceOfOrigins AS SourceOfOrigins
			|		ON ItemList.Ref = SourceOfOrigins.Ref AND ItemList.Key = SourceOfOrigins.Key");
			ItemListQuery.Add(Chars.LF + ";" + Chars.LF);
			ItemListQuery.Add("
			|SELECT
			|	ItemList.Ref,
			|	ItemList.Key,
			|	ItemList.LineNumber,
			|	" + GetInfo_1.Fields + "
			|INTO ResultSourceOfOrigins
			|FROM
			|	ItemList AS ItemList
			|		LEFT JOIN SerialLotNumbersForSourceOfOrigins AS SerialLotNumbers
			|		ON ItemList.Ref = SerialLotNumbers.Ref
			|			AND ItemList.Key = SerialLotNumbers.Key
			|		LEFT JOIN SourceOfOriginsForSourceOfOrigins AS SourceOfOrigins
			|		ON SerialLotNumbers.Ref = SourceOfOrigins.Ref 
			|			AND SerialLotNumbers.Key = SourceOfOrigins.Key 
			|			AND SerialLotNumbers.SerialLotNumber = SourceOfOrigins.SerialLotNumber");
			ItemListQuery.Add(Chars.LF + ";" + Chars.LF);
			ItemListQuery.Add("		
			|SELECT
			|	Result.Ref,
			|	Result.Key,
			|	Result.LineNumber,
			|	" + GetInfo_1.Results + "
			|FROM
			|	ResultSourceOfOrigins AS Result
			|WHERE " + GetInfo_1.Filters);
		EndIf;

		ItemListQuery.Add(Chars.LF + ";" + Chars.LF);
		ItemListQuery.Add("
			|SELECT
			|	Result.Ref,
			|	Result.Key,
			|	Result.LineNumber,
			|	" + GetInfo_0.Results + "
			|FROM
			|	Result AS Result
			|WHERE " + GetInfo_0.Filters);	
		QueryTextArray.Add(StrConcat(ItemListQuery, Chars.LF));
	EndIf;
	
	QueryTextArray.Add("
	|SELECT
	|	Headers.Ref,
	|	" + GetInfo_2.Fields + "
	|INTO Headers
	|FROM
	|	%1 AS Headers
	|WHERE
	|	Headers.Ref IN (&Refs)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Result.Ref,
	|	"""" AS Key,
	|	0 AS LineNumber,
	|	" + GetInfo_2.Results + "
	|FROM
	|	Headers AS Result
	|WHERE " + GetInfo_2.Filters + "
	|");
	
	QueryText = StrTemplate(StrConcat(QueryTextArray, Chars.LF + ";" + Chars.LF), MetaDoc.FullName());
	
	Return QueryText;
	
EndFunction

#Region GetQuery_ForExistsTable

Function GetQuery_Payments(GetInfo_3)
	Return "
		|SELECT
		|	Payments.Ref,
		|	Payments.Key,
		|	Payments.LineNumber,
		|	" + GetInfo_3.Fields + "
		|INTO Payments
		|FROM
		|	%1.Payments AS Payments
		|WHERE
		|	Payments.Ref IN (&Refs)
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Result.Ref,
		|	Result.Key,
		|	Result.LineNumber,
		|	" + GetInfo_3.Results + "
		|FROM
		|	Payments AS Result
		|WHERE " + GetInfo_3.Filters;
EndFunction

Function GetQuery_SerialLotNumbers()
	Return "SELECT
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity
		|INTO SerialLotNumbersTmp
		|FROM
		|	%1.SerialLotNumbers AS SerialLotNumbers
		|WHERE
		|	SerialLotNumbers.Ref IN (&Refs)
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key,
		|	SUM(SerialLotNumbers.Quantity) AS Quantity
		|INTO SerialLotNumbers
		|FROM
		|	SerialLotNumbersTmp AS SerialLotNumbers
		|GROUP BY
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SerialLotNumbers.Ref,
		|	SerialLotNumbers.Key,
		|	SerialLotNumbers.SerialLotNumber,
		|	SerialLotNumbers.Quantity AS Quantity
		|INTO SerialLotNumbersForSourceOfOrigins
		|FROM
		|	SerialLotNumbersTmp AS SerialLotNumbers";
EndFunction

Function GetQuery_SpecialOffers()
	Return "SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SUM(SpecialOffers.Amount) As Amount
		|INTO SpecialOffers
		|FROM
		|	%1.SpecialOffers AS SpecialOffers
		|WHERE
		|	SpecialOffers.Ref IN (&Refs)
		|GROUP BY
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key";
EndFunction

Function GetQuery_RowIDInfo()
	Return "SELECT
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key,
		|	SUM(RowIDInfo.Quantity) As Quantity
		|INTO RowIDInfo
		|FROM
		|	%1.RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Ref IN (&Refs)
		|GROUP BY
		|	RowIDInfo.Ref,
		|	RowIDInfo.Key";
EndFunction

Function GetQuery_ItemList()
	Return "SELECT
		|	ItemList.Ref,
		|	ItemList.LineNumber,
		|	ItemList.Key,
		|	ItemList.*
		|INTO ItemList
		|FROM
		|	%1.ItemList AS ItemList
		|WHERE
		|	ItemList.Ref IN (&Refs)";
EndFunction

Function GetQuery_SourceOfOrigins(MetaDoc)
	Return "SELECT
		|	SourceOfOrigins.Ref,
		|	SourceOfOrigins.Key,
		|	SourceOfOrigins.SerialLotNumber,
		|	SourceOfOrigins.SourceOfOrigin,
		|	SourceOfOrigins.Quantity
		|INTO SourceOfOriginsTmp
		|FROM
		|	%1.SourceOfOrigins AS SourceOfOrigins
		|WHERE
		|	SourceOfOrigins.Ref IN (&Refs)
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SourceOfOrigins.Ref,
		|	SourceOfOrigins.Key,
		|	SUM(SourceOfOrigins.Quantity) AS Quantity
		|INTO SourceOfOrigins
		|FROM
		|	SourceOfOriginsTmp AS SourceOfOrigins
		|GROUP BY
		|	SourceOfOrigins.Ref,
		|	SourceOfOrigins.Key
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SourceOfOrigins.Ref,
		|	SourceOfOrigins.Key,
		|	SourceOfOrigins.SerialLotNumber,
		|	SourceOfOrigins.Quantity AS Quantity
		|INTO SourceOfOriginsForSourceOfOrigins
		|FROM
		|	SourceOfOriginsTmp AS SourceOfOrigins";
EndFunction

#EndRegion

// Get all errors description.
// 
// Returns:
//  Structure - Get all errors description:
//	* Key - String - Error ID
//	* Value - See GetErrorDescription
Function GetAllErrorsDescription() Export
	
	Result = New Structure;
	
	ErrorList = GetErrorList();
	For Each ErrorListItem In ErrorList Do
		NewDescription = GetErrorDescription();
		ErrorDescription = ErrorListItem.Presentation;
		ErrorDescription = StrReplace(ErrorDescription, "%1", "<?>");
		ErrorDescription = StrReplace(ErrorDescription, "%2", "<?>");
		NewDescription.ErrorDescription = ErrorDescription;
		NewDescription.FixDescription = GetFixErrorDescription(ErrorListItem.Value);
		Result.Insert(ErrorListItem.Value, NewDescription);
	EndDo;	
	
	Return Result;
	
EndFunction
 
// Get error description.
// 
// Returns:
//  Structure - Get error description:
// * ErrorDescription - String -
// * FixDescription - String -
Function GetErrorDescription()
	Result = New Structure;
	Result.Insert("ErrorDescription", "");
	Result.Insert("FixDescription", "");
	Return Result;
EndFunction

// Get fix error description.
// 
// Parameters:
//  ErrorID - String - Error ID
// 
// Returns:
//  String
Function GetFixErrorDescription(ErrorID)
	ErrorKey = "ATC_FIX_" + ErrorID;
	If R().Property(ErrorKey) Then
		Return R()[ErrorKey];
	EndIf;
	Return R().ATC_NotSupported;
EndFunction

#Region ErrorWithTables

Function ErrorWithHeaders(MetaDoc = Undefined)
	Str = New Structure;
	
	If MetaDoc = Undefined OR MetaDoc = Metadata.Documents.RetailSalesReceipt
			 OR MetaDoc = Metadata.Documents.RetailReturnReceipt Then
		Str.Insert("ErrorNotFilledPaymentMethod", New Structure("Query, Fields, QueryNumber", 
			"PaymentMethod = VALUE(ENUM.ReceiptPaymentMethods.EmptyRef)", 
			"PaymentMethod",
			2
		));
	EndIf;
	
	If MetaDoc = Undefined OR MetaDoc = Metadata.Documents.PurchaseInvoice
			 OR MetaDoc = Metadata.Documents.PurchaseOrder
			 OR MetaDoc = Metadata.Documents.PurchaseOrderClosing Then
		Str.Insert("ErrorNotFilledPurchaseTransactionType", New Structure("Query, Fields, QueryNumber", 
			"TransactionType = VALUE(ENUM.PurchaseTransactionTypes.EmptyRef)", 
			"TransactionType",
			2
		));
	EndIf;
	
	If MetaDoc = Undefined OR MetaDoc = Metadata.Documents.SalesInvoice
			 OR MetaDoc = Metadata.Documents.SalesOrder
			 OR MetaDoc = Metadata.Documents.SalesOrderClosing Then
		Str.Insert("ErrorNotFilledSalesTransactionType", New Structure("Query, Fields, QueryNumber", 
			"TransactionType = VALUE(ENUM.SalesTransactionTypes.EmptyRef)", 
			"TransactionType",
			2
		));
	EndIf;
	
	If MetaDoc = Undefined OR MetaDoc = Metadata.Documents.SalesReturn
			 OR MetaDoc = Metadata.Documents.SalesReturnOrder Then
		Str.Insert("ErrorNotFilledSalesReturnTransactionType", New Structure("Query, Fields, QueryNumber", 
			"TransactionType = VALUE(ENUM.SalesReturnTransactionTypes.EmptyRef)", 
			"TransactionType",
			2
		));
	EndIf;
	
	If MetaDoc = Undefined OR MetaDoc = Metadata.Documents.PurchaseReturn
			 OR MetaDoc = Metadata.Documents.PurchaseReturnOrder
			 OR MetaDoc = Metadata.Documents.PurchaseOrderClosing Then
		Str.Insert("ErrorNotFilledPurchaseReturnTransactionType", New Structure("Query, Fields, QueryNumber", 
			"TransactionType = VALUE(ENUM.SalesTransactionTypes.EmptyRef)", 
			"TransactionType",
			2
		));
	EndIf;
	
	Return Str;
EndFunction

Function ErrorWithItemList()
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
		"Not ItemList.IsService = ((ItemList.Item.ItemType.Type = VAlUE(Enum.ItemTypes.Certificate)) OR (ItemList.Item.ItemType.Type = VAlUE(Enum.ItemTypes.Service)))", 
		"IsService, Item",
		0
	));
	
	Str.Insert("ErrorItemNotEqualItemInItemKey", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.Item = ItemList.ItemKey.Item",
		"Item, ItemKey",
		0
	));
		
	Str.Insert("ErrorNotFilledUnit",	New Structure("Query, Fields, QueryNumber",
		"ItemList.Unit = VAlUE(Catalog.Units.EmptyRef)", 
		"Unit",
		0
	));
	
	Str.Insert("ErrorNotFilledInventoryOrigin",	New Structure("Query, Fields, QueryNumber",
		"ItemList.InventoryOrigin = VAlUE(Enum.InventoryOriginTypes.EmptyRef)", 
		"InventoryOrigin",
		0
	));
		
	Str.Insert("ErrorNetAmountGreaterTotalAmount", New Structure("Query, Fields, QueryNumber", 
		"ItemList.NetAmount > ItemList.TotalAmount",
		"NetAmount, TotalAmount",
		0
	));
	
	Str.Insert("ErrorTotalAmountMinusNetAmountNotEqualTaxAmount", New Structure("Query, Fields, QueryNumber", 
		"Not ItemList.DontCalculateRow 
		|And Not ItemList.TotalAmount - ItemList.NetAmount - ItemList.TaxAmount = 0",
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
		"Not ItemList.UseSerialLotNumber AND ItemList.Item.ItemType.UseSerialLotNumber",
		"UseSerialLotNumber, Item",
		0
	));
	
	Str.Insert("ErrorItemTypeNotUseSerialNumbers", New Structure("Query, Fields, QueryNumber", 
		"ItemList.UseSerialLotNumber AND Not ItemList.Item.ItemType.UseSerialLotNumber",
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

Function ErrorWithSourceOfOrigins()
	Str = New Structure;
	
	Str.Insert("ErrorNotFilledQuantityInSourceOfOrigins", New Structure("Query, Fields, QueryNumber", 
		"SourceOfOrigins.Quantity IS NULL",
		"Quantity",
		1
	));
	
	Str.Insert("ErrorNotFilledQuantityInSourceOfOrigins", New Structure("Query, Fields, QueryNumber", 
		"SourceOfOrigins.Quantity IS NULL",
		"Quantity",
		0
	));
	
	Str.Insert("ErrorQuantityInSourceOfOriginsDiffQuantityInSerialLotNumber", New Structure("Query, Fields, QueryNumber", 
		"ItemList.UseSerialLotNumber AND Not SerialLotNumbers.Quantity = SourceOfOrigins.Quantity",
		"Quantity, UseSerialLotNumber",
		1
	));

	Str.Insert("ErrorQuantityInSourceOfOriginsDiffQuantityInItemList", New Structure("Query, Fields, QueryNumber", 
		"ItemList.UseSerialLotNumber AND Not ItemList.Quantity = SourceOfOrigins.Quantity",
		"Quantity, UseSerialLotNumber",
		0
	));
		
	Return Str;
EndFunction

Function ErrorWithPayments()
	Str = New Structure;
	
	Str.Insert("ErrorPaymentsAmountIsZero", New Structure("Query, Fields, QueryNumber", 
		"Payments.Amount = 0",
		"Amount",
		3
	));
	
	Return Str;
EndFunction

#EndRegion
