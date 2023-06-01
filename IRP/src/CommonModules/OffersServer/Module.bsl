
#Region FunctionForOffersCaluclate

// Calculate current row offers.
// 
// Parameters:
//  StrOffers - See CreateOffersTree
//  Row - FormDataCollectionItem Of See DocumentRef.RetailSalesReceipt.SpecialOffers
// 
// Returns:
//  Number
Function Calculate_OffersAmountInRow(StrOffers, Row) Export
	CurrentRowOffers = 0;
	If Not StrOffers.Parent = Undefined Then
		For Each OfferRow In StrOffers.Parent.Rows.FindRows(New Structure("Key, isFolder", Row.Key, False), True) Do
			CurrentRowOffers = CurrentRowOffers + OfferRow.Amount; 
		EndDo;
	EndIf;
	Return CurrentRowOffers;
EndFunction

// Calculate current offers amount spent on all rows.
// 
// Parameters:
//  StrOffers - ValueTreeRow Of See CreateOffersTree
//  Offer - CatalogRef.SpecialOffers
// 
// Returns:
//  Number
Function Calculate_OffersUsedAmountInDocument(StrOffers, Offer) Export
	CurrentOffers = 0;
	If Not StrOffers.Parent = Undefined Then
		For Each OfferRow In StrOffers.Parent.Rows.FindRows(New Structure("Offer, isFolder", Offer, False), True) Do
			CurrentOffers = CurrentOffers + OfferRow.Amount; 
		EndDo;
	EndIf;
	Return CurrentOffers;
EndFunction

// Calculate current row total amount without offers.
// 
// Parameters:
//  StrOffers - See CreateOffersTree
//  Row - LineOfATabularSection: See Document.RetailSalesReceipt.SpecialOffers
// 
// Returns:
//  Number
Function Calculate_TotalAmountWhithoutOffersInRow(StrOffers, Row) Export
	Return Row.Quantity * Row.Price;
EndFunction

#EndRegion

#Region API

Function RecalculateOffers(Object, Form, AddInfo = Undefined) Export
	OpenFormArgs = OffersClientServer.GetOpenFormArgsPickupSpecialOffers_ForDocument(Object);
	
	FormType = "Offers_ForDocument";
	OffersTree = CreateOffersTree(
			OpenFormArgs.Object, 
			OpenFormArgs.Object.ItemList,
			OpenFormArgs.Object.SpecialOffers, 
			OpenFormArgs.ArrayOfOffers
	);

	FillOffersTreeStatuses(
		OpenFormArgs.Object, 
		OffersTree,
		FormType, 
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

Function GetAllActiveOffers_ForDocument(Val Object, AddInfo = Undefined) Export
	If isSaleDoc(Object.Ref) Then
		OffersDocumentTypesArray = New Array();
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf isPurchaseDoc(Object.Ref) Then
		OffersDocumentTypesArray = New Array();
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
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

Function GetAllActiveOffers_ForRow(Val Object, AddInfo = Undefined) Export
	If isSaleDoc(Object.Ref) Then
		OffersDocumentTypesArray = New Array();
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf isPurchaseDoc(Object.Ref) Then
		OffersDocumentTypesArray = New Array();
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
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

#Region AppliedOffers

Function GetAllAppliedOffers(Val Object, AddInfo = Undefined) Export
	CanGetAllAppliedOffers = isSaleDoc(Object.Ref) Or isPurchaseDoc(Object.Ref);
	If CanGetAllAppliedOffers Then
		Return GetAllAppliedOffers_Documents(Object, AddInfo);
	Else
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
EndFunction

Function GetAllAppliedOffers_Documents(Object, AddInfo)
	TableOfOffers = New ValueTable();
	TableOfOffers.Columns.Add("Offer");
	For Each Row In Object.SpecialOffers Do
		TableOfOffers.Add().Offer = Row.Offer;
	EndDo;
	TableOfOffers.GroupBy("Offer");
	Return TableOfOffers.UnloadColumn("Offer");
EndFunction

#EndRegion

Function OfferHaveManualInputValue(OfferRef) Export
	If OfferRef.IsFolder Then
		Return False;
	Else
		Return OfferRef.ManualInputValue;
	EndIf;
EndFunction

Function SetIsSelectForAppliedOffers(OffersTreeAddress, ArrayOfAppliedOffers) Export
	OffersTree = GetFromTempStorage(OffersTreeAddress);
	For Each Row In ArrayOfAppliedOffers Do
		Filter = New Structure("Offer", Row);
		ArrayOfRows = OffersTree.Rows.FindRows(Filter, True);
		If ArrayOfRows.Count() Then
			ArrayOfRows[0].IsSelect = True;
		EndIf;
	EndDo;
	Return PutToTempStorage(OffersTree);
EndFunction

Function CreateOffersTreeAndPutToTmpStorage(Val Object, Val ItemList, Val SpecialOffers, ArrayOfOffers,
	ItemListRowKey = Undefined, AddInfo = Undefined) Export

	OffersTree = CreateOffersTree(Object, ItemList, SpecialOffers, ArrayOfOffers, ItemListRowKey, AddInfo);

	Return PutToTempStorage(OffersTree);
EndFunction

// Create offers tree.
// 
// Parameters:
//  Object- DocumentObject.RetailSalesReceipt - Object
//  ItemList - See Document.RetailSalesReceipt.ItemList
//  SpecialOffers - CatalogRef.SpecialOffers -  Special offers
//  ArrayOfOffers - Array Of CatalogRef.SpecialOffers
//  ItemListRowKey - Undefined, String - Item list row key
//  AddInfo - Undefined - Add info
// 
// Returns:
//  ValueTree - Create offers tree:
//  * Offer - CatalogRef.SpecialOffers -
//  * isFolder - Boolean - 
//  * isSelect - Boolean - Offer is selected
//  * Auto - Boolean - is offer calculate automatic
//  * Priority  - Number - 
//  * isSequential - Boolean - is group sequenetial calculate each row
//  * TotalPercent - Number -
//  * TotalAmount - Number -
//  * Rule - Undefined -
//  * Presentation - Undefined -
//  * RuleStatus - Number - Rule status: 1 - Not success; 2 - success; 3 - all rules is success
//  * ManualInputValue - Boolean -
Function CreateOffersTree(Val Object, Val ItemList, Val SpecialOffers, ArrayOfOffers, ItemListRowKey = Undefined,
	AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	SpecialOffers.Ref AS Offer,
	|	SpecialOffers.IsFolder AS isFolder,
	|	CASE
	|		WHEN SpecialOffers.Manually
	|			THEN 0
	|		ELSE 1
	|	END AS isSelect,
	|	NOT SpecialOffers.Manually AS Auto,
	|	SpecialOffers.Priority AS Priority,
	|	SpecialOffers.SequentialCalculationForEachRow AS isSequential,
	|	0 AS TotalPercent,
	|	0 AS TotalAmount,
	|	UNDEFINED AS Rule,
	|	UNDEFINED AS Presentation,
	|	0 AS RuleStatus, // Rule status: 1 - Not success; 2 - success; 3 - all rules is success
	|	ISNULL(SpecialOffers.ManualInputValue, False) AS ManualInputValue
	|FROM
	|	Catalog.SpecialOffers AS SpecialOffers
	|WHERE
	|	SpecialOffers.Ref IN (&ArrayOfOffers)
	|
	|ORDER BY
	|	Priority
	|AUTOORDER
	|TOTALS
	|	SUM(isSelect)
	|BY
	|	Offer HIERARCHY";

	Query.SetParameter("ArrayOfOffers", ArrayOfOffers);
	QueryResult = Query.Execute();
	OffersTree = QueryResult.Unload(QueryResultIteration.ByGroupsWithHierarchy);
	DeleteDoublesGroups(OffersTree);

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
	
	Return OffersTree;
EndFunction

Procedure FillOffersTreeStatuses(Val Object, OffersTree, FormType, ItemListRowKey) Export
	ArrayOfOffers = GetAllOffersInTreeAsArray(OffersTree, True);
	For Each ItemArrayOfOffers In ArrayOfOffers Do
		AllRuleIsOk = True;
		RowWithRules = False;
		For Each RowOfferRules In ItemArrayOfOffers.Offer.Rules Do
			RuleIsOk = False;
			If FormType = "Offers_ForDocument" Then
				RuleIsOk = CheckOfferRule_ForDocument(Object, ItemArrayOfOffers, RowOfferRules.Rule);
			ElsIf FormType = "Offers_ForRow" Then
				RuleIsOk = CheckOfferRule_ForRow(Object, ItemArrayOfOffers,	RowOfferRules.Rule, ItemListRowKey);
			EndIf;
			If Not RuleIsOk Then
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

Procedure DeleteDoublesGroups(OffersTree)
	For Each Str In OffersTree.Rows Do
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
		Raise StrTemplate(R().S_013, String(TypeOf(Object.Ref)));
	EndIf;
	Return OffersTree;
EndFunction

Function CalculateOffersTree_Documents(Object, OffersInfo, AddInfo = Undefined)
	OffersTree = GetFromTempStorage(OffersInfo.OffersAddress);
	DeleteFromTempStorage(OffersInfo.OffersAddress);
	OffersTree.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	OffersTree.Columns.Add("Amount", New TypeDescription("Number"));
	OffersTree.Columns.Add("TotalInGroupOffers", New TypeDescription("Number"));
	OffersTree.Columns.Add("AllRuleIsOk", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("Manual", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("ReadyOffer", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("Bonus", New TypeDescription("Number"));
	OffersTree.Columns.Add("AddInfo");

	CalculateOffersRecursion(Object, OffersTree, OffersInfo);
	
	// Delete row with Amount=0	
	ArrayForDelete = OffersTree.Rows.FindRows(New Structure("ReadyOffer, Amount, Bonus", True, 0, 0), True);
	For Each Row In ArrayForDelete Do
		Row.Parent.Rows.Delete(Row);
	EndDo;

	Return OffersTree;
EndFunction

#Region ExternalDataProcExecutors

Function CheckOfferRule_ForDocument(Object, StrOffers, Rule) Export
	Info = AddDataProcServer.AddDataProcInfo(Rule);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		Return AddDataProc.CheckOfferRule(Object, StrOffers, Rule);
	EndIf;

EndFunction

Function CheckOfferRule_ForRow(Object, StrOffers, Rule, ItemListRowKey) Export
	Info = AddDataProcServer.AddDataProcInfo(Rule);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		Return AddDataProc.CheckOfferRule(Object, StrOffers, Rule, ItemListRowKey);
	EndIf;
EndFunction

Function CalculateOffer_ForDocument(Object, StrOffers, OfferType) Export
	Info = AddDataProcServer.AddDataProcInfo(OfferType);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		Return AddDataProc.CalculateOffer(Object, StrOffers, OfferType);
	EndIf;
EndFunction

Function CalculateOffer_ForRow(Object, StrOffers, OfferType, ItemListRowKey) Export
	Info = AddDataProcServer.AddDataProcInfo(OfferType);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		Return AddDataProc.CalculateOffer(Object, StrOffers, OfferType, ItemListRowKey);
	EndIf;
EndFunction

Function CalculateOfferGroup(Object, StrOffers, OfferType) Export
	Info = AddDataProcServer.AddDataProcInfo(OfferType);
	Info.Create = True;
	AddDataProc = AddDataProcServer.CallMethodAddDataProc(Info);
	If AddDataProc = Undefined Then
		Return False;
	Else
		Return AddDataProc.CalculateOfferGroup(Object, StrOffers, OfferType);
	EndIf;
EndFunction

#EndRegion

Procedure CalculateOffersRecursion(Object, OffersTree, OffersInfo, StrOffersIndexParent = 0)
	Step = OffersTree.Rows.Count() - 1;
	StrOffersIndex = 0;
	While StrOffersIndex <= Step Do
		StrOffers = OffersTree.Rows[StrOffersIndex];
		If Not StrOffers.isFolder And StrOffers.isSelect Then
			AllRuleIsOk = True;

			For Each StrOfferRule In StrOffers.Offer.Rules Do
				If OffersInfo.Property("ItemListRowKey") Then
					AllRuleIsOk = CheckOfferRule_ForRow(Object, StrOffers, StrOfferRule.Rule, OffersInfo.ItemListRowKey);
				Else
					AllRuleIsOk = CheckOfferRule_ForDocument(Object, StrOffers, StrOfferRule.Rule);
				EndIf;
				If Not AllRuleIsOk Then
					Break;
				EndIf;
			EndDo;
			StrOffers.AllRuleIsOk = AllRuleIsOk;

			If StrOffers.AllRuleIsOk Then

				If Not StrOffers.Offer.Parent.isEmpty() Then
					CalculateOfferGroup(Object, StrOffers, StrOffers.Offer.Parent.SpecialOfferType);
				EndIf;
				
				OfferCalculateIsOk = True;
				If OffersInfo.Property("ItemListRowKey") Then
					OfferCalculateIsOk = CalculateOffer_ForRow(Object, StrOffers, StrOffers.Offer.SpecialOfferType,
						OffersInfo.ItemListRowKey);
				Else
					OfferCalculateIsOk = CalculateOffer_ForDocument(Object, StrOffers, StrOffers.Offer.SpecialOfferType);
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
				RowOffersInfo.Insert("ItemListRowKey");
				For Each InfoKeyValue In OffersInfo Do
					RowOffersInfo.Insert(InfoKeyValue.Key, InfoKeyValue.Value);
				EndDo;
				
				For Each ItemListRow In Object.ItemList Do
					RowOffersInfo.ItemListRowKey = ItemListRow.Key;
					
					CalculateOffersRecursion(Object, StrOffers, RowOffersInfo, StrOffersIndex);

					StrOffers.Amount = StrOffers.Rows.Total("Amount");
					StrOffers.Bonus = StrOffers.Rows.Total("Bonus");
					StrOffers.AllRuleIsOk = StrOffers.Rows.Total("AllRuleIsOk");

					If StrOffers.AllRuleIsOk Then
						CalculateOfferGroup(Object, StrOffers, StrOffers.Offer.SpecialOfferType);
					EndIf;
					
					ClearAmountInRows(StrOffers);
				EndDo;
				
				RestoreAmountInRows(StrOffers, Object);
			
			Else
			
				CalculateOffersRecursion(Object, StrOffers, OffersInfo, StrOffersIndex);

				StrOffers.Amount = StrOffers.Rows.Total("Amount");
				StrOffers.Bonus = StrOffers.Rows.Total("Bonus");
				StrOffers.AllRuleIsOk = StrOffers.Rows.Total("AllRuleIsOk");

				If StrOffers.AllRuleIsOk Then
					CalculateOfferGroup(Object, StrOffers, StrOffers.Offer.SpecialOfferType);
				EndIf;
				
			EndIf;

		EndIf;

		StrOffersIndex = StrOffersIndex + 1;
	EndDo;
EndProcedure

Function GetArrayOfAllOffers_ForDocument(Val Object, OffersAddress) Export
	OffersTree = GetFromTempStorage(OffersAddress);
	OffersTable = Object.SpecialOffers.Unload();
	NewOffersTable = WriteOffersInObject_ForDocument(OffersTable, OffersTree);
	ArrayOfRows = New Array();
	For Each Row In NewOffersTable Do
		RowForArrayItem = New Structure("Key, Offer, Amount, Percent, Bonus, AddInfo");
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

Function GetAllOffersInTreeAsArray(OffersTree, IncludeFolders = False) Export
	ArrayOfResults = New Array();
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

Function IsOfferForDocument(OfferRef) Export
	Return OfferRef.Type = Enums.SpecialOfferTypes.ForDocument;
EndFunction

Function GetArrayOfAllOffers_ForRow(Val Object, OffersAddress, ItemListRowKey) Export
	OffersTree = GetFromTempStorage(OffersAddress);
	OffersTable = Object.SpecialOffers.Unload();
	NewOffersTable = WriteOffersInObject_ForRow(OffersTable, OffersTree, ItemListRowKey);
	ArrayOfRows = New Array();
	For Each Row In NewOffersTable Do
		RowForArrayItem = New Structure("Key, Offer, Amount, Percent, Bonus, AddInfo");
		FillPropertyValues(RowForArrayItem, Row);
		ArrayOfRows.Add(RowForArrayItem);
	EndDo;
	Return ArrayOfRows;
EndFunction

Procedure ClearAmountInRows(Row)

	Row.Amount = 0;
	Row.TotalInGroupOffers = 0;
	
	If Row.isFolder Then
		For Each ChildRow In Row.Rows Do
			ClearAmountInRows(ChildRow);
		EndDo;
	EndIf;

EndProcedure

Procedure RestoreAmountInRows(Row, Object)

	If Row.isFolder Then
		For Each ChildRow In Row.Rows Do
			RestoreAmountInRows(ChildRow, Object);
		EndDo;
	EndIf;
	
	Row.Amount = Row.Rows.Total("Amount");
	If Row.isFolder And Row.AllRuleIsOk Then
		CalculateOfferGroup(Object, Row, Row.Offer.SpecialOfferType);
	EndIf;

EndProcedure // RestoreAmountInRows()

Procedure RecalculateAppliedOffers_ForRow(Object, AddInfo = Undefined) Export
	For Each Row In Object.SpecialOffers Do
		
		isOfferRow = ValueIsFilled(Row.Offer) 
			And IsOfferForRow(Row.Offer) 
			And ValueIsFilled(Row.Percent)
			And ValueIsFilled(Row.Key);
			
		If isOfferRow Then

			ArrayOfOffers = New Array();
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

Procedure CalculateAndLoadOffers_ForDocument(Object, OffersAddress) Export
	OffersInfo = New Structure();
	OffersInfo.Insert("OffersAddress", OffersAddress);
	
	OffersAddress = CalculateOffersTreeAndPutToTmpStorage_ForDocument(Object, OffersInfo);
	
	ArrayOfOffers = GetArrayOfAllOffers_ForDocument(Object, OffersAddress);
	
	Object.SpecialOffers.Clear();
	For Each Row In ArrayOfOffers Do
		FillPropertyValues(Object.SpecialOffers.Add(), Row);
	EndDo;
EndProcedure

Procedure ClearAutoCalculatedOffers(Object) Export
	ArrayForDelete = New Array();
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

Procedure CalculateOffersAfterSet(OffersInfo, Object) Export
	ClearAutoCalculatedOffers(Object);
	CalculateAndLoadOffers_ForDocument(Object, OffersInfo.OffersAddress);
	RecalculateAppliedOffers_ForRow(Object);
EndProcedure

