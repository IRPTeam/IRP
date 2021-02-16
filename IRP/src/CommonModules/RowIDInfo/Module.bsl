
Procedure Posting_RowID(Source, Cancel, PostingMode) Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|   Table.Ref AS Recorder,
		|   Table.Ref.Date AS Period,
		|	*
		|INTO RowIDMovements
		|FROM
		|	Document." + Source.Metadata().Name + ".RowIDInfo AS Table
		|WHERE
		|	Table.Ref = &Ref
		|
		|;
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Table.CurrentStep AS Step,
		|	CASE When Table.Basis.Ref IS NULL Then
		|		&Ref
		|	ELSE
		|		Table.Basis
		|	END AS Basis, 
		|	*
		|FROM
		|	RowIDMovements AS Table
		|WHERE
		|	NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Table.NextStep AS Step,
		|	&Ref,
		|	*
		|FROM
		|	RowIDMovements AS Table
		|WHERE
		|	NOT Table.NextStep = VALUE(Catalog.MovementRules.EmptyRef)";

	Query.SetParameter("Ref", Source.Ref);
	
	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.T10000B_RowIDMovements.Load(QueryResult);
	
EndProcedure

Procedure BeforeWrite_RowID(Source, Cancel, WriteMode, PostingMode) Export
	
	If TypeOf(Source) = Type("DocumentObject.SalesOrder") Then
		SalesOrder_FillRowID(Source);	
	ElsIf TypeOf(Source) = Type("DocumentObject.SalesInvoice") Then
		//SalesInvoice_FillRowID(Source);
	EndIf;	

EndProcedure

// Description
// 	Fill Row ID List
// Parameters:
// 	Source - DocumentObject.SalesOrder
Procedure SalesOrder_FillRowID(Source)
	//@TEST
	If Source.RowIDInfo.Count() Then
		Return;
	EndIf;
	//
	
	Source.RowIDInfo.Clear();
	For Each Row In Source.ItemList Do
		
		If Row.Cancel Then
			Continue;
		EndIf;
		
		NewRow = Source.RowIDInfo.Add();
		NewRow.Key = Row.Key;
		NewRow.RowID = Row.Key;
		NewRow.Quantity = Row.QuantityInBaseUnit;
		
		NextStep = Catalogs.MovementRules.EmptyRef();
		
		If Row.ProcurementMethod = Enums.ProcurementMethods.Purchase Then
			NextStep = Catalogs.MovementRules.FromSOtoPO;
		Else
			If Source.ShipmentConfirmationsBeforeSalesInvoice Then
				NextStep = Catalogs.MovementRules.FromSOtoSC;
			Else
				NextStep = Catalogs.MovementRules.FromSOtoSI;
			EndIf;
		EndIf;
		
		NewRow.NextStep = NextStep;
		
		NewRow.RowRef = CreateRowIDCatalog(NewRow, Row, Source, NOT ValueIsFilled(NewRow.Basis));
	EndDo;
EndProcedure

// Description
// 	Fill Row ID List
// Parameters:
// 	Source - DocumentObject.SalesInvoice
Procedure SalesInvoice_FillRowID(Source)
	//@TEST
	If Source.RowIDInfo.Count() Then
		Return;
	EndIf;
	
	
	Source.RowIDInfo.Clear();
	For Each Row In Source.ItemList Do
		NewRow = Source.RowIDInfo.Add();
		NewRow.Key = Row.Key;
		NewRow.RowID = Row.Key;
		NewRow.Quantity = Row.QuantityInBaseUnit;
		
		NextStep = Catalogs.MovementRules.EmptyRef();
		
		If Row.UseShipmentConfirmation Then
			NextStep = Catalogs.MovementRules.FromSItoSC;
		EndIf;
		If Not Row.SalesOrder.IsEmpty() Then
			NewRow.Basis = Row.SalesOrder;
			NewRow.CurrentStep = Catalogs.MovementRules.FromSOtoSI;			
		EndIf;
		
		NewRow.NextStep = NextStep;
		NewRow.RowRef = CreateRowIDCatalog(NewRow, Row, Source, NOT ValueIsFilled(NewRow.Basis));
	EndDo;
EndProcedure
#Region FillBaseOnDocuments

#Region SalesInvoice

Procedure FillSalesInvoice(ArrayOfLinkedDocuments, Object) Export
	Object.RowIDInfo.Clear();
	For Each ItemOfArray In ArrayOfLinkedDocuments Do
		FillPropertyValues(Object.RowIDInfo.Add(), ItemOfArray);
	EndDo;
EndProcedure

Procedure FillQueryParameters(Query, Parameters, FilterValues)
	For Each Parameter In Parameters Do
		Value = Undefined; Use = False;
		If FilterValues.Property(Parameter) Then
			Value = FilterValues[Parameter];
			Use = True;
		EndIf;
		Query.SetParameter("Filter_" + Parameter, Use);
		Query.SetParameter(Parameter, Value);
	EndDo;
EndProcedure	

Function GetBasisesForSalesInvoice(FilterValues) Export
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SI);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	Query = New Query;
	Query.SetParameter("StepArray", StepArray);	
		
	ParametersArray = New Array();
	ParametersArray.Add("Basises");
	ParametersArray.Add("Company");
	ParametersArray.Add("Partner");
	ParametersArray.Add("LegalName");
	ParametersArray.Add("Agreement");
	ParametersArray.Add("Currency");
	ParametersArray.Add("ItemKey");
	ParametersArray.Add("Store");
	
	FillQueryParameters(Query, ParametersArray, FilterValues);
	
//	Query.SetParameter("Company", FilterValues.Company);
//	Query.SetParameter("Partner", FilterValues.Partner);
//	Query.SetParameter("LegalName", FilterValues.LegalName);
//	Query.SetParameter("Agreement", FilterValues.Agreement);
//	Query.SetParameter("Currency", FilterValues.Currency);
	
	Ref = Documents.SalesInvoice.EmptyRef();
	Period =Undefined;
	If FilterValues.Property("Ref")	And ValueIsFilled(FilterValues.Ref) Then
		Ref = FilterValues.Ref;
		Period = New Boundary(FilterValues.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Period);
	
//	Filter_ItemKey = Undefined;
//	If FilterValues.Property("ItemKey") Then
//		Filter_ItemKey = FilterValues.ItemKey;
//	EndIf;
//	Query.SetParameter("Filter_ItemKey", ValueIsFilled(Filter_ItemKey));
//	Query.SetParameter("ItemKey", Filter_ItemKey);
//	
//	Filter_Store = Undefined;
//	If FilterValues.Property("Store") Then
//		Filter_Store = FilterValues.Store;
//	EndIf;
//	Query.SetParameter("Filter_Store", ValueIsFilled(Filter_Store));
//	Query.SetParameter("Store", Filter_Store);
	
	
	Query.Text =
		"SELECT
		|	RowInfo.RowID,
		|	RowInfo.Step,
		|	RowInfo.Basis,
		|	RowInfo.RowRef,
		|	RowInfo.QuantityBalance AS Quantity
		|INTO tmpQueryTable
		|FROM
		|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
		|	AND CASE
		|		WHEN &Filter_Basises
		|			THEN Basis IN (&Basises)
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_Company
		|			THEN RowRef.Company = &Company
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_Partner
		|			THEN RowRef.Partner = &Partner
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_LegalName
		|			THEN RowRef.LegalName = &LegalName
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_Agreement
		|			THEN RowRef.Agreement = &Agreement
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_Currency
		|			THEN RowRef.Currency = &Currency
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_ItemKey
		|			THEN RowRef.ItemKey = &ItemKey
		|		ELSE TRUE
		|	END
		|	AND CASE
		|		WHEN &Filter_Store
		|			THEN RowRef.Store = &Store
		|		ELSE TRUE
		|	END) AS RowInfo
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	Doc.ItemKey AS ItemKey,
		|	Doc.ItemKey.Item AS Item,
		|	Doc.Store AS Store,
		|	Doc.Ref AS Basis,
		|	Doc.Key AS Key,
		|	CASE
		|		WHEN Doc.ItemKey.Unit.Ref IS NULL
		|			THEN Doc.ItemKey.Item.Unit
		|		ELSE Doc.ItemKey.Unit
		|	END AS BasisUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	tmpQueryTable.RowRef AS RowRef,
		|	tmpQueryTable.RowID AS RowID,
		|	tmpQueryTable.Step AS CurrentStep
		|FROM
		|	Document.SalesOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.RowID = Doc.Key
		|		AND tmpQueryTable.Basis = Doc.Ref
		|
		|UNION ALL
		|
		|SELECT
		|	Doc.ItemKey,
		|	Doc.ItemKey.Item,
		|	Doc.Store,
		|	Doc.Ref,
		|	Doc.Key,
		|	CASE
		|		WHEN Doc.ItemKey.Unit.Ref IS NULL
		|			THEN Doc.ItemKey.Item.Unit
		|		ELSE Doc.ItemKey.Unit
		|	END,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.RowRef,
		|	tmpQueryTable.RowID,
		|	tmpQueryTable.Step
		|FROM
		|	Document.ShipmentConfirmation.ItemList AS Doc
		|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS ShipmentConfirmationRowIDInfo
		|			INNER JOIN tmpQueryTable AS tmpQueryTable
		|			ON tmpQueryTable.RowID = ShipmentConfirmationRowIDInfo.RowID
		|			AND tmpQueryTable.Basis = ShipmentConfirmationRowIDInfo.Ref
		|		ON Doc.Ref = ShipmentConfirmationRowIDInfo.Ref
		|		AND Doc.Key = ShipmentConfirmationRowIDInfo.Key";
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

#EndRegion

#Region SC
Function GetDocumentsForShipmentConfirmation(FilterValues) Export	
	QueryTableOrders = New Query(
			"SELECT ALLOWED
			|	Table.Ref AS ShipmentBasis
			|into tmp
			|FROM
			|	Document.SalesOrder AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|	AND Table.ShipmentConfirmationsBeforeSalesInvoice
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.SalesInvoice AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.PurchaseReturn AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Bundling AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Unbundling AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.InventoryTransfer AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT ALLOWED
			|	Table.Store AS Store,
			|	Table.ShipmentBasis AS ShipmentBasis,
			|	Table.Currency AS Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	SUM(Table.Quantity) AS Quantity,
			|	Table.RowKey
			|FROM
			|	(SELECT
			|		GoodsInTransitOutgoingBalance.Store AS Store,
			|		GoodsInTransitOutgoingBalance.ShipmentBasis AS ShipmentBasis,
			|		GoodsInTransitOutgoingBalance.ShipmentBasis.Currency AS Currency,
			|		GoodsInTransitOutgoingBalance.ItemKey,
			|		CASE
			|			WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|				THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
			|			ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
			|		END AS Unit,
			|		GoodsInTransitOutgoingBalance.QuantityBalance AS Quantity,
			|		GoodsInTransitOutgoingBalance.RowKey
			|	FROM
			|		AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN
			|			(select
			|				ShipmentBasis
			|			from
			|				tmp) AND CASE
			|							WHEN &FilterByItemKey
			|								THEN ItemKey = &ItemKey
			|							ELSE TRUE
			|						END) AS GoodsInTransitOutgoingBalance
			|
			|	UNION ALL
			|
			|	SELECT
			|		DocumentRecords.Store AS Store,
			|		DocumentRecords.ShipmentBasis AS ShipmentBasis,
			|		DocumentRecords.ShipmentBasis.Currency AS Currency,
			|		DocumentRecords.ItemKey,
			|		CASE
			|			WHEN DocumentRecords.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|				THEN DocumentRecords.ItemKey.Unit
			|			ELSE DocumentRecords.ItemKey.Item.Unit
			|		END AS Unit,
			|		CASE
			|			WHEN DocumentRecords.RecordType = VALUE(AccumulationRecordType.Receipt)
			|				THEN -DocumentRecords.Quantity
			|			ELSE DocumentRecords.Quantity
			|		END AS Quantity,
			|		DocumentRecords.RowKey
			|	FROM
			|		AccumulationRegister.GoodsInTransitOutgoing AS DocumentRecords
			|			INNER JOIN tmp AS tmp
			|			ON tmp.ShipmentBasis = DocumentRecords.ShipmentBasis
			|			AND DocumentRecords.Recorder = &Ref
			|			AND (CASE
			|					WHEN &FilterByItemKey
			|						THEN DocumentRecords.ItemKey = &ItemKey
			|					ELSE TRUE
			|				END)) AS Table
			|
			|GROUP BY
			|	Table.Store,
			|	Table.ShipmentBasis,
			|	Table.Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	Table.RowKey");
	QueryTableOrders.SetParameter("Company", FilterValues.Company);
	QueryTableOrders.SetParameter("Partner", ?(ValueIsFilled(FilterValues.Partner), FilterValues.Partner, Undefined));
	QueryTableOrders.SetParameter("LegalName", ?(ValueIsFilled(FilterValues.LegalName), FilterValues.LegalName, Undefined));
//	QueryTableOrders.SetParameter("Ref", Ref);
	
	ItemKey = Undefined;
	QueryTableOrders.SetParameter("FilterByItemKey", FilterValues.Property("ItemKey", ItemKey));
	QueryTableOrders.SetParameter("ItemKey", ItemKey);
	
	
	QueryTable = QueryTableOrders.Execute().Unload();
	
	Query = New Query();
	Query.TempTablesManager = DocShipmentConfirmationServer.PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ShipmentBasis AS ShipmentBasis,
		|	tmpQueryTable.Currency AS Currency,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|
		|	MAX(CASE
		|		WHEN NOT DocSalesInvoice.Unit IS NULL
		|			THEN DocSalesInvoice.Unit
		|		WHEN NOT DocSalesOrder.Unit IS NULL
		|			THEN DocSalesOrder.Unit
		|		WHEN NOT DocBundling.Unit IS NULL
		|			THEN DocBundling.Unit
		|		WHEN NOT DocUnbundling.Unit IS NULL
		|			THEN DocUnbundling.Unit
		|		WHEN NOT DocInventoryTransfer.Unit IS NULL
		|			THEN DocInventoryTransfer.Unit
		|		WHEN NOT DocPurchaseReturn.Unit IS NULL
		|			THEN DocPurchaseReturn.Unit
		|		ELSE tmpQueryTable.Unit
		|	END) AS Unit
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|
		|		LEFT JOIN Document.SalesInvoice.ItemList AS DocSalesInvoice
		|		ON tmpQueryTable.Key = DocSalesInvoice.Key
		|		AND tmpQueryTable.ShipmentBasis = DocSalesInvoice.Ref
		|
		|		LEFT JOIN Document.SalesOrder.ItemList AS DocSalesOrder
		|		ON tmpQueryTable.Key = DocSalesOrder.Key
		|		AND tmpQueryTable.ShipmentBasis = DocSalesOrder.Ref
		|
		|		LEFT JOIN Document.Bundling.ItemList AS DocBundling
		|		ON tmpQueryTable.Key = DocBundling.Key
		|		AND tmpQueryTable.ShipmentBasis = DocBundling.Ref
		|
		|		LEFT JOIN Document.Unbundling.ItemList AS DocUnbundling
		|		ON tmpQueryTable.Key = DocUnbundling.Key
		|		AND tmpQueryTable.ShipmentBasis = DocUnbundling.Ref
		|
		|		LEFT JOIN Document.InventoryTransfer.ItemList AS DocInventoryTransfer
		|		ON tmpQueryTable.Key = DocInventoryTransfer.Key
		|		AND tmpQueryTable.ShipmentBasis = DocInventoryTransfer.Ref
		|
		|		LEFT JOIN Document.PurchaseReturn.ItemList AS DocPurchaseReturn
		|		ON tmpQueryTable.Key = DocPurchaseReturn.Key
		|		AND tmpQueryTable.ShipmentBasis = DocPurchaseReturn.Ref
		|
		|GROUP BY
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ShipmentBasis,
		|	tmpQueryTable.Currency,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item,
		|	tmpQueryTable.Unit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey
		|";
	
	Return Query.Execute().Unload();
EndFunction
#EndRegion

#EndRegion

#Region Service
Function GetRowInfo(RowIDList, StepArray)
	Query = New Query;
	Query.Text =
		"SELECT
		|	RowInfo.RowID,
		|	RowInfo.Step,
		|	RowInfo.Basis,
		|	RowInfo.QuantityBalance
		|FROM
		|	AccumulationRegister.T10000B_RowIDMovements.Balance(, Step IN (&StepArray)
		|	AND RowID IN (&RowIDList)) AS RowInfo";
	
	Query.SetParameter("RowIDList", RowIDList);
	Query.SetParameter("StepArray", StepArray);
	
	Return Query.Execute().Unload();
EndFunction

Function CreateRowIDCatalog(NewRow, Row, Source, Update = False)
	Query = New Query;
	Query.Text =
		"SELECT
		|	RowIDs.Ref
		|FROM
		|	Catalog.RowIDs AS RowIDs
		|WHERE
		|	RowIDs.RowID = &RowID";
	
	Query.SetParameter("RowID", NewRow.RowID);
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		If Not Update Then
			Return QueryResult.Ref;
		Else
			RowRefObject = QueryResult.Ref.GetObject();
		EndIf;
	Else
		RowRefObject = Catalogs.RowIDs.CreateItem();
	EndIf;
	FillPropertyValues(RowRefObject, Source);
	FillPropertyValues(RowRefObject, Row);
	RowRefObject.Basis = Source.Ref;
	RowRefObject.RowID = NewRow.RowID;
	RowRefObject.Description = NewRow.RowID;
	RowRefObject.Write();
	Return RowRefObject.Ref;
EndFunction
#EndRegion
