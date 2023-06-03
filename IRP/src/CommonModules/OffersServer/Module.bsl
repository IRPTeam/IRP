// @strict-types

#Region FunctionForOffersCaluculate

// Calculate current row offers.
// 
// Parameters:
//  StrOffers - ValueTreeRow: See GetSelectedOffersTree
//  Row - DocumentTabularSectionRow.RetailSalesReceipt.SpecialOffers
// 
// Returns:
//  Number
Function Calculate_OffersAmountInRow(StrOffers, Row) Export
	CurrentRowOffers = 0;
	If Not StrOffers.Parent = Undefined Then
		CurrentLvlArray = StrOffers.Parent.Rows.FindRows(New Structure("Key, isFolder", Row.Key, False), True);
		For Each OfferRow In CurrentLvlArray Do // ValueTreeRow: See GetSelectedOffersTree
			CurrentRowOffers = CurrentRowOffers + OfferRow.Amount; 
		EndDo;
	EndIf;
	Return CurrentRowOffers;
EndFunction

// Calculate current offers amount spent on all rows.
// 
// Parameters:
//  StrOffers - ValueTreeRow: See GetSelectedOffersTree
//  Offer - CatalogRef.SpecialOffers -
// 
// Returns:
//  Number
Function Calculate_OffersUsedAmountInDocument(StrOffers, Offer) Export
	CurrentOffers = 0;
	If Not StrOffers.Parent = Undefined Then
		CurrentLvlArray = StrOffers.Parent.Rows.FindRows(New Structure("Offer, isFolder", Offer, False), True);
		For Each OfferRow In CurrentLvlArray Do // ValueTreeRow: See GetSelectedOffersTree
			CurrentOffers = CurrentOffers + OfferRow.Amount; 
		EndDo;
	EndIf;
	Return CurrentOffers;
EndFunction

// Calculate current row total amount without offers.
// 
// Parameters:
//  StrOffers - ValueTreeRow: See GetSelectedOffersTree
//  Row - DocumentTabularSectionRow.RetailSalesReceipt.ItemList
// 
// Returns:
//  Number
Function Calculate_TotalAmountWhithoutOffersInRow(StrOffers, Row) Export
	Return Row.Quantity * Row.Price;
EndFunction

#EndRegion

#Region API

// Recalculate offers.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers
//  Form - ClientApplicationForm -
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Recalculate offers:
// * OffersAddress - String -
// * ItemListRowKey - Undefined -
Function RecalculateOffers(Object, Form, AddInfo = Undefined) Export
	OpenFormArgs = OffersClientServer.GetOpenFormArgsPickupSpecialOffers_ForDocument(Object);
	
	OffersTree = CreateOffersTree(
			OpenFormArgs.Object, 
			OpenFormArgs.Object.ItemList,
			OpenFormArgs.Object.SpecialOffers, 
			OpenFormArgs.ArrayOfOffers
	);

	FillOffersTreeStatuses(
		OpenFormArgs.Object, 
		OffersTree,
		OpenFormArgs.ItemListRowKey
	);
	
	Result = New Structure();
	Result.Insert("OffersAddress", PutToTempStorage(OffersTree));
	If ValueIsFilled(OpenFormArgs.ItemListRowKey) Then
		Result.Insert("ItemListRowKey", OpenFormArgs.ItemListRowKey);
	EndIf;
	
	Return Result;
	
EndFunction

#EndRegion

#Region Settings
Function isSaleDoc(Ref)
	Return TypeOf(Ref) = Type("DocumentRef.SalesOrder") 
		Or TypeOf(Ref) = Type("DocumentRef.SalesInvoice")
		Or TypeOf(Ref) = Type("DocumentRef.SalesReturnOrder")
		Or TypeOf(Ref) = Type("DocumentRef.SalesReturn")
		Or TypeOf(Ref) = Type("DocumentRef.RetailSalesReceipt")
		Or TypeOf(Ref) = Type("DocumentRef.RetailReturnReceipt")
		Or TypeOf(Ref) = Type("DocumentRef.WorkOrder");
EndFunction

Function isPurchaseDoc(Ref)
	Return TypeOf(Ref) = Type("DocumentRef.PurchaseOrder") 
		Or TypeOf(Ref) = Type("DocumentRef.PurchaseInvoice")
		Or TypeOf(Ref) = Type("DocumentRef.PurchaseReturnOrder")
		Or TypeOf(Ref) = Type("DocumentRef.PurchaseReturn");
EndFunction 
#EndRegion

#Region Offers_for_document

// Get all active offers for document.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers -
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array - Get all active offers for document
Function GetAllActiveOffers_ForDocument(Val Object, AddInfo = Undefined) Export
	OffersDocumentTypesArray = New Array(); // Array Of EnumRef.OffersDocumentTypes
	If isSaleDoc(Object.Ref) Then
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf isPurchaseDoc(Object.Ref) Then
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
		//@skip-check property-return-type, invocation-parameter-type-intersect
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
EndFunction

Function GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	SpecialOffers.Ref AS Offer
	|FROM
	|	Catalog.SpecialOffers AS SpecialOffers
	|WHERE
	|	NOT SpecialOffers.DeletionMark
	|	AND SpecialOffers.StartOf <= &Date
	|	AND (SpecialOffers.EndOf >= &Date
	|	OR SpecialOffers.EndOf = DATETIME(1, 1, 1))
	|	AND SpecialOffers.Launch
	|	AND
	|	NOT SpecialOffers.IsFolder
	|	AND SpecialOffers.Type = VALUE(Enum.SpecialOfferTypes.ForDocument)
	|	AND SpecialOffers.DocumentType In(&OffersDocumentTypesArray)
	|AUTOORDER";

	Query.SetParameter("Date", Object.Date);
	Query.SetParameter("OffersDocumentTypesArray", OffersDocumentTypesArray);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable.UnloadColumn("Offer");
EndFunction

#EndRegion

#Region Offers_for_row

// Get all active offers for row.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array - Get all active offers for row
Function GetAllActiveOffers_ForRow(Val Object, AddInfo = Undefined) Export
	OffersDocumentTypesArray = New Array(); // Array Of EnumRef.OffersDocumentTypes
	If isSaleDoc(Object.Ref) Then
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf isPurchaseDoc(Object.Ref) Then
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
		//@skip-check invocation-parameter-type-intersect, property-return-type
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
EndFunction

Function GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo = Undefined)
	Query = New Query();
	Query.Text =
	"SELECT
	|	SpecialOffers.Ref AS Offer
	|FROM
	|	Catalog.SpecialOffers AS SpecialOffers
	|WHERE
	|	NOT SpecialOffers.DeletionMark
	|	AND SpecialOffers.StartOf <= &Date
	|	AND (SpecialOffers.EndOf >= &Date
	|	OR SpecialOffers.EndOf = DATETIME(1, 1, 1))
	|	AND SpecialOffers.Launch
	|	AND
	|	NOT SpecialOffers.IsFolder
	|	AND SpecialOffers.Type = VALUE(Enum.SpecialOfferTypes.ForRow)
	|	AND SpecialOffers.DocumentType In(&OffersDocumentTypesArray)
	|AUTOORDER";

	Query.SetParameter("Date", Object.Date);
	Query.SetParameter("OffersDocumentTypesArray", OffersDocumentTypesArray);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable.UnloadColumn("Offer");
EndFunction

#EndRegion

#Region Offers_for_group

// Calculate offer group.
// 
// Parameters:
//  Params - See OffersServer.GetCalculateOfferParam
// 
// Returns:
//  Boolean
Function CalculateOfferGroup_Internal(Params) Export
	StrOffers = Params.StrOffers;
	OfferType = Params.OfferType;
	
	If StrOffers.isFolder Then
	
		StrOffers.Rows.Sort("Priority Asc");
		
		If StrOffers.OfferGroupType = Enums.OfferGroupType.Sum Then
			Return True;
		ElsIf StrOffers.OfferGroupType = Enums.OfferGroupType.Max Then
			If StrOffers.Rows.Count() > 1 Then
				StrOffers.Rows.Sort("Amount Desc, Priority Asc");
				CalculateOfferGroup_RemoveOther(StrOffers.Rows);
			EndIf;
		ElsIf StrOffers.OfferGroupType = Enums.OfferGroupType.MaxByRow Then	
			
			ValueTable = New ValueTable(); 
			ValueTable.Columns.Add("Amount" , New TypeDescription("Number"));
			ValueTable.Columns.Add("Key"    , New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
			ValueTable.Columns.Add("Offer"  , New TypeDescription("CatalogRef.SpecialOffers"));
			ValueTable.Columns.Add("Row");
			
			ArrayOfRows = StrOffers.Rows.FindRows(New Structure("ReadyOffer", True), True);
			
			For Each ItemOfRows In ArrayOfRows Do
				NewRow = ValueTable.Add();  // Array Of ValueTreeRow: See GetSelectedOffersTree
				FillPropertyValues(NewRow, ItemOfRows);			
				//@skip-check property-return-type
				NewRow.Row = ItemOfRows;
			EndDo;	
			
			Query = New Query();
			Query.Text = 
			"SELECT
			|	T.Amount AS Amount,
			|	T.Key AS Key,
			|	T.Offer AS Offer
			|INTO temp
			|FROM
			|	&T AS T
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT
			|	MAX(temp.Amount) AS Amount,
			|	temp.Key AS Key
			|INTO tmp2
			|FROM
			|	temp AS temp
			|GROUP BY
			|	temp.Key
			|;
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT
			|	tmp2.Key AS Key,
			|	tmp2.Amount AS Amount,
			|	MAX(temp.Offer) AS Offer
			|FROM
			|	tmp2 AS tmp2
			|		LEFT JOIN temp AS temp
			|		ON (tmp2.Key = temp.Key)
			|		AND (tmp2.Amount = temp.Amount)
			|GROUP BY
			|	tmp2.Key,
			|	tmp2.Amount";
			Query.SetParameter("T", ValueTable);
			QueryResult = Query.Execute();
			TableOfKeys = QueryResult.Unload();
			
			For Each RowValueTable In ValueTable Do
				//@skip-check structure-consructor-value-type, property-return-type
				If Not TableOfKeys.FindRows(New Structure("Key, Offer", RowValueTable.Key, RowValueTable.Offer)).Count() Then		
					//@skip-check property-return-type, dynamic-access-method-not-found
					RowValueTable.Row.Parent.Rows.Delete(RowValueTable.Row);
				EndIf;
			EndDo;
		
		ElsIf StrOffers.OfferGroupType = Enums.OfferGroupType.Min Then
			If StrOffers.Rows.Count() > 1 Then
				StrOffers.Rows.Sort("AllRuleIsOk Desc, Amount Asc, Priority Asc");
				CalculateOfferGroup_RemoveOther(StrOffers.Rows);
			EndIf;        
		ElsIf StrOffers.OfferGroupType = Enums.OfferGroupType.Consequentially Then
			For Each ChildRow In StrOffers.Rows Do  // ValueTreeRow: See GetSelectedOffersTree
				StrOffers.TotalInGroupOffers = StrOffers.TotalInGroupOffers + ChildRow.Amount;
			EndDo;
		EndIf;
		
	Else
		
		If StrOffers.OfferGroupType = Enums.OfferGroupType.Consequentially Then
			StrOffers.TotalInGroupOffers = 0;
			For Each ParentChildRow In StrOffers.Parent.Rows Do // ValueTreeRow: See GetSelectedOffersTree
				StrOffers.TotalInGroupOffers = StrOffers.TotalInGroupOffers + ParentChildRow.Amount;
			EndDo;
		EndIf;
		
	EndIf;	
		
	Return True;
EndFunction

Procedure CalculateOfferGroup_RemoveOther(StrOffers)	
	For Index = 1 To StrOffers.Count() - 1 Do
		StrOffers.Delete(1);
	EndDo;	
EndProcedure

#EndRegion

#Region AppliedOffers

// Get all applied offers.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - 
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Array - Get all applied offers
Function GetAllAppliedOffers(Val Object, AddInfo = Undefined) Export
	CanGetAllAppliedOffers = isSaleDoc(Object.Ref) Or isPurchaseDoc(Object.Ref);
	If CanGetAllAppliedOffers Then
		Return GetAllAppliedOffers_Documents(Object, AddInfo);
	Else
		//@skip-check property-return-type, invocation-parameter-type-intersect
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
EndFunction

Function GetAllAppliedOffers_Documents(Object, AddInfo)
	TableOfOffers = New ValueTable();
	TableOfOffers.Columns.Add("Offer", New TypeDescription("CatalogRef.SpecialOffers"));
	For Each Row In Object.SpecialOffers Do
		NewRow = TableOfOffers.Add();
		NewRow.Offer = Row.Offer;
	EndDo;
	TableOfOffers.GroupBy("Offer");
	Return TableOfOffers.UnloadColumn("Offer");
EndFunction

#EndRegion

// Get selected offers tree.
// 
// Parameters:
//  Form - See CommonForm.PickupSpecialOffers
// 
// Returns:
//  ValueTree:
// * AddInfo - DefinedType.typeSpecialOfferAddInfo -
// * AllRuleIsOk - Boolean -
// * Amount - DefinedType.typeAmount -
// * Auto - Boolean -
// * Bonus - DefinedType.typeSpecialOfferBonus -
// * isFolder - Boolean -
// * isRule - Boolean -
// * isSelect - Boolean -
// * isSequential - Boolean -
// * Key - DefinedType.typeRowID -
// * Manual - Boolean -
// * ManualInputValue - Boolean -
// * Offer - CatalogRef.SpecialOffers, CatalogRef.SpecialOfferRules -
// * OfferGroupType - EnumRef.OfferGroupType -
// * Percent - Number -
// * Presentation - String -
// * Priority - Number -
// * ReadyOffer - Boolean -
// * Rule - CatalogRef.SpecialOfferRules -
// * RuleStatus - Number -
// * TotalAmount - DefinedType.typeAmount -
// * TotalInGroupOffers - DefinedType.typeAmount -
// * TotalPercent - DefinedType.typePercent -
Function GetSelectedOffersTree(Form) Export
	//@skip-check constructor-function-return-section
	Return Form.FormAttributeToValue("Offers");
EndFunction

// Offer have manual input value.
// 
// Parameters:
//  OfferRef - CatalogRef.SpecialOffers -
// 
// Returns:
//  Boolean - Offer have manual input value
Function OfferHaveManualInputValue(OfferRef) Export
	If OfferRef.IsFolder Then
		Return False;
	Else
		Return OfferRef.ManualInputValue;
	EndIf;
EndFunction

// Create offers tree and put to tmp storage.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
//  ItemList - See Document.RetailSalesReceipt.ItemList
//  SpecialOffers - See Document.RetailSalesReceipt.SpecialOffers
//  ArrayOfOffers - Array - Array of offers
//  ItemListRowKey - Undefined - Item list row key
//  AddInfo - Undefined, Structure - Add info
// 
// Returns:
//  String Of See CreateOffersTree - Create offers tree and put to tmp storage
Function CreateOffersTreeAndPutToTmpStorage(Val Object, Val ItemList, Val SpecialOffers, ArrayOfOffers,
	ItemListRowKey = Undefined, AddInfo = Undefined) Export

	OffersTree = CreateOffersTree(Object, ItemList, SpecialOffers, ArrayOfOffers, ItemListRowKey, AddInfo);

	Return PutToTempStorage(OffersTree);
EndFunction

// Create offers tree.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
//  ItemList - See Document.RetailSalesReceipt.ItemList
//  SpecialOffers - See Document.RetailSalesReceipt.SpecialOffers
//  ArrayOfOffers - Array Of CatalogRef.SpecialOffers
//  ItemListRowKey - Undefined, String - Item list row key
//  AddInfo - Structure - Add info:
//  	* Call_CalculateOfferAmount - Boolean -
// 
// Returns:
//  See OffersServer.GetSelectedOffersTree
Function CreateOffersTree(Val Object, Val ItemList, Val SpecialOffers, ArrayOfOffers, ItemListRowKey = Undefined,
	AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	SpecialOffers.Ref AS Offer,
	|	SpecialOffers.OfferGroupType AS OfferGroupType,
	|	SpecialOffers.IsFolder AS isFolder,
	|	CASE
	|		WHEN SpecialOffers.Manually
	|			THEN 0
	|		ELSE 1
	|	END AS isSelect,
	|	NOT SpecialOffers.Manually AS Auto,
	|	SpecialOffers.Priority AS Priority,
	|	SpecialOffers.SequentialCalculationForEachRow AS isSequential,
	|	ISNULL(SpecialOffers.ManualInputValue, False) AS ManualInputValue
	|FROM
	|	Catalog.SpecialOffers AS SpecialOffers
	|WHERE
	|	SpecialOffers.Ref IN (&ArrayOfOffers)
	|
	|ORDER BY
	|	Priority
	|TOTALS
	|BY
	|	Offer HIERARCHY";

	Query.SetParameter("ArrayOfOffers", ArrayOfOffers);
	QueryResult = Query.Execute();
	OffersTree = QueryResult.Unload(QueryResultIteration.ByGroupsWithHierarchy); // See CreateOffersTree
	DeleteDoublesGroups(OffersTree);
	
	OffersTree.Columns.Add("AddInfo", Metadata.DefinedTypes.typeSpecialOfferAddInfo.Type);
	OffersTree.Columns.Add("Presentation", New TypeDescription("String", , , , New StringQualifiers(1024)));
	OffersTree.Columns.Add("Key", New TypeDescription("String", , , , New StringQualifiers(36)));
	OffersTree.Columns.Add("TotalPercent", New TypeDescription("Number", , , New NumberQualifiers(6, 3)));
	OffersTree.Columns.Add("Percent", New TypeDescription("Number", , , New NumberQualifiers(6, 3)));
	OffersTree.Columns.Add("RuleStatus", New TypeDescription("Number", , , New NumberQualifiers(1, 0)));
	OffersTree.Columns.Add("TotalAmount", Metadata.DefinedTypes.typeAmount.Type);
	OffersTree.Columns.Add("Amount", Metadata.DefinedTypes.typeAmount.Type);
	OffersTree.Columns.Add("TotalInGroupOffers", Metadata.DefinedTypes.typeAmount.Type);
	OffersTree.Columns.Add("Bonus", Metadata.DefinedTypes.typeSpecialOfferBonus.Type);
	OffersTree.Columns.Add("Rule", New TypeDescription("CatalogRef.SpecialOfferRules"));
	OffersTree.Columns.Add("AllRuleIsOk", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("Manual", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("ReadyOffer", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("isRule", New TypeDescription("Boolean"));

	Call_CalculateOfferAmount = True;
	If AddInfo <> Undefined And AddInfo.Property("Call_CalculateOfferAmount") Then
		Call_CalculateOfferAmount = AddInfo.Call_CalculateOfferAmount;
	EndIf;
	If Call_CalculateOfferAmount Then
		CalculateOfferAmount(OffersTree, ItemList.Unload(), SpecialOffers.Unload(), ItemListRowKey);
	EndIf;

	For Each Row In SpecialOffers Do
		SearchFilter = New Structure("Offer", Row.Offer);
		ArrayOfSearch = OffersTree.Rows.FindRows(SearchFilter, True);
		For Each ItemArrayOfSearch In ArrayOfSearch Do
			ItemArrayOfSearch.isSelect = True;
		EndDo;
	EndDo;
	
	//@skip-check constructor-function-return-section
	Return OffersTree;
EndFunction

Procedure FillOffersTreeStatuses(Val Object, OffersTree, ItemListRowKey) Export
	ArrayOfOffers = GetAllOffersInTreeAsArray(OffersTree, True);
	For Each ItemArrayOfOffers In ArrayOfOffers Do
		AllRuleIsOk = True;
		RowWithRules = False;
		For Each RowOfferRules In ItemArrayOfOffers.Offer.Rules Do
			
			CalculateOfferParam = GetCalculateOfferParam();
			CalculateOfferParam.Object = Object;
			CalculateOfferParam.Rule = RowOfferRules.Rule;
			CalculateOfferParam.ItemListRowKey = ItemListRowKey;
			CalculateOfferParam.StrOffers = ItemArrayOfOffers;
			
			AllRuleIsOk = CheckRule(CalculateOfferParam);
			
			If Not AllRuleIsOk Then
				AllRuleIsOk = False;
			EndIf;
			
			RowWithRules = True;
		EndDo;

		If AllRuleIsOk And RowWithRules Then
			ItemArrayOfOffers.RuleStatus = 3;
		ElsIf Not AllRuleIsOk And RowWithRules Then
			ItemArrayOfOffers.RuleStatus = 1;
		EndIf;

	EndDo;
EndProcedure

Function CheckRule(CalculateOfferParam)
	
	If IsBlankString(CalculateOfferParam.ItemListRowKey) Then
		Result = CheckOfferRule_ForDocument(CalculateOfferParam); // See GetRuleResult
	Else
		Result = CheckOfferRule_ForRow(CalculateOfferParam); // See GetRuleResult
	EndIf;

	NewRule = CalculateOfferParam.StrOffers.Rows.Add(); // ValueTreeRow: See OffersServer.GetSelectedOffersTree
	NewRule.Rule = CalculateOfferParam.Rule;
	NewRule.isSelect = Result.Success;
	NewRule.isRule = True;
	
	If IsBlankString(Result.Message) Then
		NewRule.Presentation = String(CalculateOfferParam.Rule);
	Else
		NewRule.Presentation = Result.Message;
	EndIf;
	
	If Result.Success Then
		NewRule.RuleStatus = 3;
	Else
		NewRule.RuleStatus = 1;
	EndIf;
	
	Return Result.Success;
EndFunction

Procedure DeleteDoublesGroups(OffersTree)
	For Each Str In OffersTree.Rows Do
		
		If Str.isFolder Then
			
		EndIf;
		
		If Str.Rows.Count() Then
			DeleteDoublesGroups(Str);
		Else
			OffersTree.Rows.Delete(Str);
		EndIf;
	EndDo;
EndProcedure

Procedure CalculateOfferAmount(OffersTree, ItemList, SpecialOffers, ItemListRowKey)
	For Each Row In OffersTree.Rows Do
		If ValueIsFilled(Row.Offer) And Not Row.isFolder Then
			SearchFilter = New Structure();
			SearchFilter.Insert("Offer", Row.Offer);

			If ValueIsFilled(ItemListRowKey) Then
				SearchFilter.Insert("Key", ItemListRowKey);
			EndIf;

			SpecialOffersCopy = SpecialOffers.Copy(SearchFilter);
			Row.TotalAmount = SpecialOffersCopy.Total("Amount");
			sum = 0;
			For Each i In SpecialOffersCopy Do
				SearchFilter = New Structure();
				SearchFilter.Insert("Key", i.Key);
				ItemListCopy = ItemList.Copy(SearchFilter);
				For Each j In ItemListCopy Do
					If ValueIsFilled(j.Unit) And j.Unit.Quantity > 0 Then
						sum = sum + (j.Price * j.Quantity * j.Unit.Quantity);
					Else
						sum = sum + (j.Price * j.Quantity);
					EndIf;
				EndDo;
			EndDo;
			If sum <> 0 Then
				Row.TotalPercent = Row.TotalAmount / (sum / 100);
			Else
				Row.TotalPercent = 0;
			EndIf;

			If ValueIsFilled(Row.TotalPercent) And IsOfferForRow(Row.Offer) And Row.Offer.Manually Then
				Row.IsSelect = True;
			EndIf;

		EndIf;

		CalculateOfferAmount(Row, ItemList, SpecialOffers, ItemListRowKey);
	EndDo;

EndProcedure

Function CalculateOffersTreeAndPutToTmpStorage_ForDocument(Val Object, OffersInfo, AddInfo = Undefined) Export
	Return PutToTempStorage(CalculateOffersTree_ForDocument(Object, OffersInfo, AddInfo));
EndFunction

Function CalculateOffersTree_ForDocument(Val Object, OffersInfo, AddInfo = Undefined) Export
	isTaxDocRef = isSaleDoc(Object.Ref) Or isPurchaseDoc(Object.Ref);
	If isTaxDocRef Then
		OffersTree = CalculateOffersTree_Documents(Object, OffersInfo, AddInfo);
	Else
		//@skip-check invocation-parameter-type-intersect
		//@skip-check property-return-type
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
	Return OffersTree;
EndFunction

Function CalculateOffersTreeAndPutToTmpStorage_ForRow(Val Object, OffersInfo, AddInfo = Undefined) Export
	Return PutToTempStorage(CalculateOffersTree_ForRow(Object, OffersInfo, AddInfo));
EndFunction

Function CalculateOffersTree_ForRow(Val Object, OffersInfo, AddInfo = Undefined) Export
	isTaxDocRef = isSaleDoc(Object.Ref) Or isPurchaseDoc(Object.Ref);
	If isTaxDocRef Then
		OffersTree = CalculateOffersTree_Documents(Object, OffersInfo, AddInfo);
	Else
		//@skip-check invocation-parameter-type-intersect
		//@skip-check property-return-type
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
	Return OffersTree;
EndFunction

Function CalculateOffersTree_Documents(Object, OffersInfo, AddInfo = Undefined)
	OffersTree = GetFromTempStorage(OffersInfo.OffersAddress); // See GetSelectedOffersTree
	DeleteFromTempStorage(OffersInfo.OffersAddress);

	CalculateOffersRecursion(Object, OffersTree, OffersInfo);
	
	// Delete row with Amount=0	
	ArrayForDelete = OffersTree.Rows.FindRows(New Structure("ReadyOffer, Amount, Bonus", True, 0, 0), True);
	For Each Row In ArrayForDelete Do
		Row.Parent.Rows.Delete(Row);
	EndDo;

	Return OffersTree;
EndFunction

#Region ExternalDataProcExecutors

// Check offer rule for document.
// 
// Parameters:
//  CalculateOfferParam - See GetCalculateOfferParam
// 
// Returns:
//  Boolean - Check offer rule for document
Function CheckOfferRule_ForDocument(CalculateOfferParam) Export
	Info = AddDataProcServer.AddDataProcInfo(CalculateOfferParam.Rule);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info); // DataProcessorObjectDataProcessorName
	If AddDataProc = Undefined Then
		Return False;
	Else
		//@skip-check dynamic-access-method-not-found
		Return AddDataProc.CheckOfferRule(CalculateOfferParam);
	EndIf;

EndFunction

// Check offer rule for row.
// 
// Parameters:
//  CalculateOfferParam - See GetCalculateOfferParam
// 
// Returns:
//  See GetRuleResult
Function CheckOfferRule_ForRow(CalculateOfferParam) Export
	Info = AddDataProcServer.AddDataProcInfo(CalculateOfferParam.Rule);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		//@skip-check dynamic-access-method-not-found
		Return AddDataProc.CheckOfferRule(CalculateOfferParam);
	EndIf;
EndFunction

// Calculate offer for document.
// 
// Parameters:
//  CalculateOfferParam - See GetCalculateOfferParam
// 
// Returns:
//  Boolean - Calculate offer for document
Function CalculateOffer_ForDocument(CalculateOfferParam) Export
	Info = AddDataProcServer.AddDataProcInfo(CalculateOfferParam.OfferType);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		//@skip-check dynamic-access-method-not-found
		Return AddDataProc.CalculateOffer(CalculateOfferParam);
	EndIf;
EndFunction

// Calculate offer for row.
// 
// Parameters:
//  CalculateOfferParam - See GetCalculateOfferParam
// 
// Returns:
//  Boolean - Calculate offer for row
Function CalculateOffer_ForRow(CalculateOfferParam) Export
	Info = AddDataProcServer.AddDataProcInfo(CalculateOfferParam.OfferType);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		//@skip-check dynamic-access-method-not-found
		Return AddDataProc.CalculateOffer(CalculateOfferParam);
	EndIf;
EndFunction

// Calculate offer group.
// 
// Parameters:
//  CalculateOfferParam - See GetCalculateOfferParam
// 
// Returns:
//  Boolean - Calculate offer group
Function CalculateOfferGroup(CalculateOfferParam) Export
	If CalculateOfferParam.StrOffers.OfferGroupType = Enums.OfferGroupType.UseExternalCalculation Then
		Info = AddDataProcServer.AddDataProcInfo(CalculateOfferParam.OfferType);
		Info.Create = True;
		AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
		If AddDataProc = Undefined Then
			Return False;
		Else
			//@skip-check dynamic-access-method-not-found
			Return AddDataProc.CalculateOfferGroup(CalculateOfferParam);
		EndIf;
	Else
		Return CalculateOfferGroup_Internal(CalculateOfferParam);
	EndIf;
EndFunction

// Get calculate offer param.
// 
// Returns:
//  Structure - Get calculate offer param:
// * Object - DefinedType.typeObjectWithSpecialOffers -
// * StrOffers - ValueTreeRow: See OffersServer.GetSelectedOffersTree
// * Rule - CatalogRef.SpecialOfferRules -
// * OfferType - CatalogRef.SpecialOfferTypes -
// * ItemListRowKey - Undefined, String -
Function GetCalculateOfferParam() Export
	Str = New Structure;
	Str.Insert("Object", Undefined);
	Str.Insert("StrOffers", Undefined);
	Str.Insert("OfferType", Catalogs.SpecialOfferTypes.EmptyRef());
	Str.Insert("Rule", Catalogs.SpecialOfferRules.EmptyRef());
	Str.Insert("ItemListRowKey", "");
	//@skip-check constructor-function-return-section
	Return Str;
EndFunction

#EndRegion

// Calculate offers recursion.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - 
//  OffersTree - See GetSelectedOffersTree
//  OffersInfo - Structure - Offers info:
// * ItemListRowKey - String
//  StrOffersIndexParent - Number - Str offers index parent
Procedure CalculateOffersRecursion(Object, OffersTree, OffersInfo, StrOffersIndexParent = 0)
	Step = OffersTree.Rows.Count() - 1;
	StrOffersIndex = 0;
	While StrOffersIndex <= Step Do
		StrOffers = OffersTree.Rows[StrOffersIndex]; // See GetSelectedOffersTree
		If Not StrOffers.isFolder And StrOffers.isSelect Then
			AllRuleIsOk = True;

			For Each StrOfferRule In StrOffers.Offer.Rules Do
				
				CalculateOfferParam = GetCalculateOfferParam();
				CalculateOfferParam.Object = Object;
				CalculateOfferParam.Rule = StrOfferRule.Rule;
				CalculateOfferParam.ItemListRowKey = OffersInfo.ItemListRowKey;
				CalculateOfferParam.StrOffers = StrOffers;
				If Not CheckRule(CalculateOfferParam) Then
					Break;
				EndIf;
			EndDo;
			StrOffers.AllRuleIsOk = AllRuleIsOk;

			If StrOffers.AllRuleIsOk Then

				If Not StrOffers.Offer.Parent.isEmpty() Then
					CalculateOfferParam = GetCalculateOfferParam();
					CalculateOfferParam.Object = Object;
					CalculateOfferParam.OfferType = StrOffers.Offer.Parent.SpecialOfferType;
					CalculateOfferParam.ItemListRowKey = OffersInfo.ItemListRowKey;
					CalculateOfferParam.StrOffers = StrOffers;
					CalculateOfferGroup(CalculateOfferParam);
				EndIf;
				
				CalculateOfferParam = GetCalculateOfferParam();
				CalculateOfferParam.Object = Object;
				CalculateOfferParam.OfferType = StrOffers.Offer.SpecialOfferType;
				CalculateOfferParam.ItemListRowKey = OffersInfo.ItemListRowKey;
				CalculateOfferParam.StrOffers = StrOffers;
				OfferCalculateIsOk = True;
				If OffersInfo.Property("ItemListRowKey") Then
					OfferCalculateIsOk = CalculateOffer_ForRow(CalculateOfferParam);
				Else
					OfferCalculateIsOk = CalculateOffer_ForDocument(CalculateOfferParam);
				EndIf;

				If OfferCalculateIsOk Then
					If OffersInfo.Property("ItemListRowKey") Then
						StrOffers.Amount = 0;
						KeyRows = StrOffers.Rows.FindRows(New Structure("Key", OffersInfo.ItemListRowKey));
						For Each KeyRow In KeyRows Do
							StrOffers.Amount = StrOffers.Amount + KeyRow.Amount;
							StrOffers.Bonus = StrOffers.Bonus + KeyRow.Bonus;
						EndDo;
					Else
						StrOffers.Amount = StrOffers.Rows.Total("Amount");
						StrOffers.Bonus = StrOffers.Rows.Total("Bonus");
					EndIf;
				Else
					OffersTree.Rows.Delete(StrOffers);
					StrOffersIndex = StrOffersIndex - 1;
					Step = Step - 1;
				EndIf;
			EndIf;

		ElsIf StrOffers.isFolder Then
			
			If StrOffers.isSequential And Not OffersInfo.Property("ItemListRowKey") And Object.ItemList.Count() > 0 Then
				
				RowOffersInfo = New Structure;
				RowOffersInfo.Insert("ItemListRowKey", "");
				For Each InfoKeyValue In OffersInfo Do
					RowOffersInfo.Insert(InfoKeyValue.Key, InfoKeyValue.Value);
				EndDo;
				
				For Each ItemListRow In Object.ItemList Do
					RowOffersInfo.ItemListRowKey = ItemListRow.Key;
					
					CalculateOffersRecursion(Object, StrOffers, RowOffersInfo, StrOffersIndex);

					StrOffers.Amount = StrOffers.Rows.Total("Amount");
					StrOffers.Bonus = StrOffers.Rows.Total("Bonus");
					StrOffers.AllRuleIsOk = StrOffers.Rows.FindRows(New Structure("AllRuleIsOk", False)).Count() = 0;

					If StrOffers.AllRuleIsOk Then
						CalculateOfferParam = GetCalculateOfferParam();
						CalculateOfferParam.Object = Object;
						CalculateOfferParam.OfferType = StrOffers.Offer.SpecialOfferType;
						CalculateOfferParam.StrOffers = StrOffers;
						CalculateOfferGroup(CalculateOfferParam);
					EndIf;
					
					ClearAmountInRows(StrOffers);
				EndDo;
				
				RestoreAmountInRows(StrOffers, Object);
			
			Else
			
				CalculateOffersRecursion(Object, StrOffers, OffersInfo, StrOffersIndex);

				StrOffers.Amount = StrOffers.Rows.Total("Amount");
				StrOffers.Bonus = StrOffers.Rows.Total("Bonus");
				StrOffers.AllRuleIsOk = StrOffers.Rows.FindRows(New Structure("AllRuleIsOk", False)).Count() = 0;

				If StrOffers.AllRuleIsOk Then
					CalculateOfferParam = GetCalculateOfferParam();
					CalculateOfferParam.Object = Object;
					CalculateOfferParam.OfferType = StrOffers.Offer.SpecialOfferType;
					CalculateOfferParam.StrOffers = StrOffers;
					CalculateOfferGroup(CalculateOfferParam);
				EndIf;
				
			EndIf;

		EndIf;

		StrOffersIndex = StrOffersIndex + 1;
	EndDo;
EndProcedure

Function GetArrayOfAllOffers_ForDocument(Val Object, OffersAddress) Export
	OffersTree = GetFromTempStorage(OffersAddress); // See GetSelectedOffersTree
	OffersTable = Object.SpecialOffers.Unload();
	NewOffersTable = WriteOffersInObject_ForDocument(OffersTable, OffersTree);
	ArrayOfRows = New Array(); // Array Of See GetOffersTableRow 
	For Each Row In NewOffersTable Do
		RowForArrayItem = GetOffersTableRow();
		FillPropertyValues(RowForArrayItem, Row);
		ArrayOfRows.Add(RowForArrayItem);
	EndDo;
	Return ArrayOfRows;
EndFunction

Function WriteOffersInObject_ForDocument(OffersTable, OffersTree, AddInfo = Undefined)
	OffersTableCopy = OffersTable.Copy();
	OffersTableCopy.Clear();

	For Each Row In OffersTable Do
		If Row.Offer.Type = Enums.SpecialOfferTypes.ForRow Then
			NewRow = OffersTableCopy.Add();
			FillPropertyValues(NewRow, Row);
		EndIf;
	EndDo;

	OffersToObject = OffersTree.Rows.FindRows(New Structure("ReadyOffer", True), True);
	For Each Row In OffersToObject Do
		NewRow = OffersTableCopy.Add();
		FillPropertyValues(NewRow, Row);
	EndDo;

	Return OffersTableCopy;
EndFunction

Function WriteOffersInObject_ForRow(OffersTable, OffersTree, ItemListRowKey, AddInfo = Undefined) Export
	OffersTableCopy = OffersTable.Copy();
	OffersTableCopy.Clear();

	For Each Row In OffersTable Do
		If Not Row.Offer.Type = Enums.SpecialOfferTypes.ForRow Or Row.Key <> ItemListRowKey Then
			NewRow = OffersTableCopy.Add();
			FillPropertyValues(NewRow, Row);
		EndIf;
	EndDo;

	OffersToObject = OffersTree.Rows.FindRows(New Structure("ReadyOffer", True), True);
	For Each Row In OffersToObject Do
		NewRow = OffersTableCopy.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Percent = Row.TotalPercent;
	EndDo;

	Return OffersTableCopy;
EndFunction

// Get all offers in tree as array.
// 
// Parameters:
//  OffersTree - See CreateOffersTree
// 
// Returns:
//  Array Of ValueTreeRow: See OffersServer.GetSelectedOffersTree - Get all offers in tree as array
Function GetAllOffersInTreeAsArray(OffersTree, IncludeFolders = False) Export
	ArrayOfResults = New Array(); // Array Of ValueTreeRow: See CreateOffersTree
	SearchFilter = New Structure();
	SearchFilter.Insert("isFolder", False);

	SearchResult = OffersTree.Rows.FindRows(SearchFilter, True);
	For Each ItemSearchResult In SearchResult Do
		ArrayOfResults.Add(ItemSearchResult);
	EndDo;

	If IncludeFolders Then
		SearchFilter.isFolder = True;
		SearchResult = OffersTree.Rows.FindRows(SearchFilter, True);
		For Each ItemSearchResult In SearchResult Do
			ArrayOfResults.Add(ItemSearchResult);
		EndDo;
	EndIf;

	Return ArrayOfResults;
EndFunction

Function IsOfferForRow(OfferRef) Export
	Return OfferRef.Type = Enums.SpecialOfferTypes.ForRow;
EndFunction

Function GetArrayOfAllOffers_ForRow(Val Object, OffersAddress, ItemListRowKey) Export
	OffersTree = GetFromTempStorage(OffersAddress); // See GetSelectedOffersTree
	OffersTable = Object.SpecialOffers.Unload();
	NewOffersTable = WriteOffersInObject_ForRow(OffersTable, OffersTree, ItemListRowKey);
	ArrayOfRows = New Array(); // Array Of See GetOffersTableRow
	For Each Row In NewOffersTable Do
		RowForArrayItem = GetOffersTableRow();
		FillPropertyValues(RowForArrayItem, Row);
		ArrayOfRows.Add(RowForArrayItem);
	EndDo;
	Return ArrayOfRows;
EndFunction

// Clear amount in rows.
// 
// Parameters:
//  Row - ValueTreeRow: See CreateOffersTree
Procedure ClearAmountInRows(Row)

	Row.Amount = 0;
	Row.TotalInGroupOffers = 0;
	
	If Row.isFolder Then
		For Each ChildRow In Row.Rows Do
			ClearAmountInRows(ChildRow);
		EndDo;
	EndIf;

EndProcedure

// Restore amount in rows.
// 
// Parameters:
//  StrOffers - ValueTreeRow: See CreateOffersTree
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
Procedure RestoreAmountInRows(StrOffers, Object)

	If StrOffers.isFolder Then
		For Each ChildRow In StrOffers.Rows Do
			RestoreAmountInRows(ChildRow, Object);
		EndDo;
	EndIf;
	
	StrOffers.Amount = StrOffers.Rows.Total("Amount");
	If StrOffers.isFolder And StrOffers.AllRuleIsOk Then
		CalculateOfferParam = GetCalculateOfferParam();
		CalculateOfferParam.Object = Object;
		CalculateOfferParam.OfferType = StrOffers.Offer.SpecialOfferType;
		CalculateOfferParam.StrOffers = StrOffers;
		CalculateOfferGroup(CalculateOfferParam);
	EndIf;

EndProcedure // RestoreAmountInRows()

// Recalculate applied offers for row.
// 
// Parameters:
//  Object  - DefinedType.typeObjectWithSpecialOffers - Object
//  AddInfo - Undefined - Add info
Procedure RecalculateAppliedOffers_ForRow(Object, AddInfo = Undefined) Export
	For Each Row In Object.SpecialOffers Do
		
		isOfferRow = ValueIsFilled(Row.Offer) 
			And IsOfferForRow(Row.Offer) 
			And ValueIsFilled(Row.Percent)
			And ValueIsFilled(Row.Key);
			
		If isOfferRow Then

			ArrayOfOffers = New Array(); // Array Of CatalogRef.SpecialOffers
			ArrayOfOffers.Add(Row.Offer);

			TreeByOneOfferAddress = CreateOffersTreeAndPutToTmpStorage(
				Object, 
				Object.ItemList,
				Object.SpecialOffers,
				ArrayOfOffers,
				Row.Key
			);

			CalculateAndLoadOffers_ForRow(Object, TreeByOneOfferAddress, Row.Key);

		EndIf;
	EndDo;
EndProcedure

Procedure CalculateAndLoadOffers_ForRow(Object, OffersAddress, ItemListRowKey) Export
	OffersInfo = New Structure();
	OffersInfo.Insert("OffersAddress"  , OffersAddress);
	OffersInfo.Insert("ItemListRowKey" , ItemListRowKey);
	
	TreeByOneOfferAddress = CalculateOffersTreeAndPutToTmpStorage_ForRow(Object, OffersInfo);
	
	ArrayOfOffers = GetArrayOfAllOffers_ForRow(Object, TreeByOneOfferAddress, ItemListRowKey);
	
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

// Calculate and load offers for document.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
//  OffersAddress - String - Offers address
Procedure CalculateAndLoadOffers_ForDocument(Object, OffersAddress) Export
	OffersInfo = New Structure();
	OffersInfo.Insert("OffersAddress", OffersAddress);
	OffersInfo.Insert("ItemListRowKey", "");
	
	OffersAddress = CalculateOffersTreeAndPutToTmpStorage_ForDocument(Object, OffersInfo);
	
	ArrayOfOffers = GetArrayOfAllOffers_ForDocument(Object, OffersAddress);
	
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

// Clear auto calculated offers.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
Procedure ClearAutoCalculatedOffers(Object) Export
	ArrayForDelete = New Array(); // Array Of DocumentTabularSectionRow.RetailSalesReceipt.SpecialOffers
	For Each Row In Object.SpecialOffers Do
		If ValueIsFilled(Row.Offer) And OfferHaveManualInputValue(Row.Offer)
			And Object.ItemList.FindRows(New Structure("Key", Row.Key)).Count() Then
			Continue;
		EndIf;
		ArrayForDelete.Add(Row);
	EndDo;
	For Each Row In ArrayForDelete Do
		Object.SpecialOffers.Delete(Row);
	EndDo;
EndProcedure

// Calculate offers after set.
// 
// Parameters:
//  OffersInfo - See GetOffersInfoParam 
//  Object - DefinedType.typeObjectWithSpecialOffers - Object
Procedure CalculateOffersAfterSet(OffersInfo, Object) Export
	ClearAutoCalculatedOffers(Object);
	CalculateAndLoadOffers_ForDocument(Object, OffersInfo.OffersAddress);
	RecalculateAppliedOffers_ForRow(Object);
EndProcedure

// Get offers info param.
// 
// Returns:
//  Structure - Get offers info param:
// * OffersAddress - String Of See CommonForm.PickupSpecialOffers.Offers -
// * ItemListRowKey - String -
Function GetOffersInfoParam() Export
	Str = New Structure;
	Str.Insert("OffersAddress", "");
	Str.Insert("ItemListRowKey", "");
	Return Str;
EndFunction

// Get offers table row.
// 
// Returns:
//  Structure - Get offers table row:
// * Key - See Document.RetailSalesReceipt.SpecialOffers.Key
// * Offer - See Document.RetailSalesReceipt.SpecialOffers.Offer
// * Amount - See Document.RetailSalesReceipt.SpecialOffers.Amount
// * Percent - See Document.RetailSalesReceipt.SpecialOffers.Percent
// * Bonus - See Document.RetailSalesReceipt.SpecialOffers.Bonus
// * AddInfo - See Document.RetailSalesReceipt.SpecialOffers.AddInfo
Function GetOffersTableRow() Export
	Str = New Structure;
	Str.Insert("Key", "");
	Str.Insert("Offer", Catalogs.SpecialOffers.EmptyRef());
	Str.Insert("Amount", 0);
	Str.Insert("Percent", 0);
	Str.Insert("Bonus", 0);
	Str.Insert("AddInfo", Undefined);
	//@skip-check constructor-function-return-section
	Return Str;
EndFunction

// Get rule result.
// 
// Returns:
//  Structure - Get rule result:
// * Success - Boolean -
// * Message - String -
Function GetRuleResult() Export
	Str = New Structure;
	Str.Insert("Success", False);
	Str.Insert("Message", "");
	Return Str;
EndFunction
