#Region Offers_for_document

Function GetAllActiveOffers_ForDocument(Val Object, AddInfo = Undefined) Export
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice") Then
		OffersDocumentTypesArray = New Array;
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf TypeOf(Object.Ref) = Type("DocumentRef.PurchaseOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
		OffersDocumentTypesArray = New Array;
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForDocument_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
		Raise StrTemplate(R()["S_013"], String(TypeOf(Object.Ref)));
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
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice") Then
		OffersDocumentTypesArray = New Array;
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Sales);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	ElsIf TypeOf(Object.Ref) = Type("DocumentRef.PurchaseOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
		OffersDocumentTypesArray = New Array;
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.Purchases);
		OffersDocumentTypesArray.Add(Enums.OffersDocumentTypes.PurchasesAndSales);
		Return GetAllActiveOffers_ForRow_ByDocumentTypes(Object, OffersDocumentTypesArray, AddInfo);
	Else
		Raise StrTemplate(R()["S_013"], String(TypeOf(Object.Ref)));
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
	CanGetAllAppliedOffers = TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice") 
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice"); 
	If CanGetAllAppliedOffers Then
		Return GetAllAppliedOffers_Documents(Object, AddInfo);
	Else
		Raise StrTemplate(R()["S_013"], String(TypeOf(Object.Ref)));
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

Function CreateOffersTreeAndPutToTmpStorage(Val Object,
		Val ItemList,
		Val SpecialOffers,
		ArrayOfOffers,
		ItemListRowKey = Undefined,
		AddInfo = Undefined) Export
	
	OffersTree = CreateOffersTree(Object,
			ItemList,
			SpecialOffers,
			ArrayOfOffers,
			ItemListRowKey,
			AddInfo);
	
	Return PutToTempStorage(OffersTree);
EndFunction

Function CreateOffersTree(Val Object,
		Val ItemList,
		Val SpecialOffers,
		ArrayOfOffers,
		ItemListRowKey = Undefined,
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
		|	0 AS TotalPercent,
		|	0 AS TotalAmount,
		|  UNDEFINED AS Rule,
		|  UNDEFINED AS Presentation
		|FROM
		|	Catalog.SpecialOffers AS SpecialOffers
		|WHERE
		|	SpecialOffers.Ref IN(&ArrayOfOffers)
		|
		|ORDER BY
		|	Priority
		|TOTALS
		|	SUM(isSelect)
		|BY
		|	Offer HIERARCHY
		|AUTOORDER";
	
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
	
	Return OffersTree;
EndFunction

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
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
			OffersTree = CalculateOffersTree_Documents(Object, OffersInfo, AddInfo);
	Else
		Raise StrTemplate(R()["S_013"], String(TypeOf(Object.Ref)));
	EndIf;
	Return OffersTree;
EndFunction

Function CalculateOffersTreeAndPutToTmpStorage_ForRow(Val Object, OffersInfo, AddInfo = Undefined) Export
	Return PutToTempStorage(CalculateOffersTree_ForRow(Object, OffersInfo, AddInfo));
EndFunction

Function CalculateOffersTree_ForRow(Val Object, OffersInfo, AddInfo = Undefined) Export
	If TypeOf(Object.Ref) = Type("DocumentRef.SalesOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.SalesInvoice")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseOrder")
		Or TypeOf(Object.Ref) = Type("DocumentRef.PurchaseInvoice") Then
			OffersTree = CalculateOffersTree_Documents(Object, OffersInfo, AddInfo);
	Else
		Raise StrTemplate(R()["S_013"], String(TypeOf(Object.Ref)));
	EndIf;
	Return OffersTree;
EndFunction

Function CalculateOffersTree_Documents(Object, OffersInfo, AddInfo = Undefined)
	OffersTree = GetFromTempStorage(OffersInfo.OffersAddress);
	DeleteFromTempStorage(OffersInfo.OffersAddress);
	OffersTree.Columns.Add("Key", New TypeDescription("UUID"));
	OffersTree.Columns.Add("Amount", New TypeDescription("Number"));
	OffersTree.Columns.Add("TotalInGroupOffers", New TypeDescription("Number"));
	OffersTree.Columns.Add("AllRuleIsOk", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("Manual", New TypeDescription("Boolean"));
	OffersTree.Columns.Add("ReadyOffer", New TypeDescription("Boolean"));
	
	CalculateOffersRecursion(Object, OffersTree, OffersInfo);
	
	// Delete row with Amount=0	
	ArrayForDelete = OffersTree.Rows.FindRows(New Structure("ReadyOffer, Amount", True, 0), True);
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
		If NOT StrOffers.isFolder AND StrOffers.isSelect Then
			AllRuleIsOk = True;
			
			For Each StrOfferRule In StrOffers.Offer.Rules Do
				If OffersInfo.Property("ItemListRowKey") Then
					AllRuleIsOk = CheckOfferRule_ForRow(Object,
							StrOffers,
							StrOfferRule.Rule,
							OffersInfo.ItemListRowKey);
				Else
					AllRuleIsOk = CheckOfferRule_ForDocument(Object,
							StrOffers,
							StrOfferRule.Rule);
				EndIf;
				If Not AllRuleIsOk Then
					Break;
				EndIf;
			EndDo;
			StrOffers.AllRuleIsOk = AllRuleIsOk;
			
			If StrOffers.AllRuleIsOk Then
				
				OfferCalculateIsOk = True;
				If OffersInfo.Property("ItemListRowKey") Then
					OfferCalculateIsOk = CalculateOffer_ForRow(Object,
							StrOffers,
							StrOffers.Offer.SpecialOfferType,
							OffersInfo.ItemListRowKey);
				Else
					OfferCalculateIsOk = CalculateOffer_ForDocument(Object,
							StrOffers,
							StrOffers.Offer.SpecialOfferType);
				EndIf;
				
				If OfferCalculateIsOk Then
					StrOffers.Amount = StrOffers.Rows.Total("Amount");
				Else
					OffersTree.Rows.Delete(StrOffers);
					StrOffersIndex = StrOffersIndex - 1;
					Step = Step - 1;
				EndIf;
			EndIf;
			
		ElsIf StrOffers.isFolder Then
			CalculateOffersRecursion(Object, StrOffers, OffersInfo, StrOffersIndex);
			
			StrOffers.Amount = StrOffers.Rows.Total("Amount");
			StrOffers.AllRuleIsOk = StrOffers.Rows.Total("AllRuleIsOk");
			
			If StrOffers.AllRuleIsOk Then
				CalculateOfferGroup(Object, StrOffers, StrOffers.Offer.SpecialOfferType);
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
		RowForArrayItem = New Structure("Key, Offer, Amount, Percent");
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
		If Not Row.Offer.Type = Enums.SpecialOfferTypes.ForRow
			Or Row.Key <> ItemListRowKey Then
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

Function OfferHaveManualInputValue(OfferRef) Export
	If OfferRef.IsFolder Then
		Return False;
	Else
		Return OfferRef.ManualInputValue;
	EndIf;
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
		RowForArrayItem = New Structure("Key, Offer, Amount, Percent");
		FillPropertyValues(RowForArrayItem, Row);
		ArrayOfRows.Add(RowForArrayItem);
	EndDo;
	Return ArrayOfRows;
EndFunction

