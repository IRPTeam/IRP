
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
			NextStep = Catalogs.MovementRules.PO;
		Else
			If Source.ShipmentConfirmationsBeforeSalesInvoice Then
				NextStep = Catalogs.MovementRules.SC;
			Else
				NextStep = Catalogs.MovementRules.SI;
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

Function ExtractData(BasisesTable) Export
	Basises_SO = BasisesTable.CopyColumns();
	Basises_SC = BasisesTable.CopyColumns();
	Basises_SO_SC = BasisesTable.CopyColumns();
	Basises_SO_SC.Columns.Add("SalesOrder", New TypeDescription("DocumentRef.SalesOrder"));
	
	For Each Row In BasisesTable Do
		If TypeOf(Row.Basis) = Type("DocumentRef.SalesOrder") Then
			FillPropertyValues(Basises_SO.Add(), Row);
		ElsIf TypeOf(Row.Basis) = Type("DocumentRef.ShipmentConfirmation") Then
			If TypeOf(Row.RowRef.Basis) = Type("DocumentRef.SalesOrder") Then
				NewRow = Basises_SO_SC.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.SalesOrder = Row.RowRef.Basis;
			Else
				FillPropertyValues(Basises_SC.Add(), Row);
			EndIf;
		EndIf;
	EndDo;
	
	ExtractedData = New Array();
	ExtractedData.Add(ExtractData_SalesOrder(Basises_SO, Basises_SO_SC));
	Return ExtractedData;
EndFunction

Function ExtractData_SalesOrder(BasisesTable, ShipmentConfirmationsTable)
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|INTO BasisesTable
		|FROM
		|	&BasisesTable AS BasisesTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ShipmentConfirmationsTable.Key,
		|	ShipmentConfirmationsTable.RowID,
		|	ShipmentConfirmationsTable.CurrentStep,
		|	ShipmentConfirmationsTable.RowRef,
		|	ShipmentConfirmationsTable.Basis,
		|	ShipmentConfirmationsTable.SalesOrder,
		|	ShipmentConfirmationsTable.BasisUnit,
		|	ShipmentConfirmationsTable.Quantity
		|INTO ShipmentConfirmationsTable
		|FROM
		|	&ShipmentConfirmationsTable AS ShipmentConfirmationsTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	BasisesTable.Key AS Key,
		|	BasisesTable.Basis AS Basis,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	"""" AS ShipmentKey,
		|	BasisesTable.Quantity AS Quantity
		|INTO FilterItemList
		|FROM
		|	BasisesTable AS BasisesTable
		|
		|UNION
		|
		|SELECT
		|	ShipmentConfirmationsTable.RowID,
		|	ShipmentConfirmationsTable.SalesOrder,
		|	ShipmentConfirmationsTable.BasisUnit,
		|	ShipmentConfirmationsTable.Key,
		|	SUM(ShipmentConfirmationsTable.Quantity)
		|FROM
		|	ShipmentConfirmationsTable AS ShipmentConfirmationsTable
		|GROUP BY
		|	ShipmentConfirmationsTable.RowID,
		|	ShipmentConfirmationsTable.SalesOrder,
		|	ShipmentConfirmationsTable.BasisUnit,
		|	ShipmentConfirmationsTable.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	ItemList.Ref AS Ref,
		|	ItemList.Ref AS SalesOrder,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.ManagerSegment AS ManagerSegment,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Key,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Unit AS Unit,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	FilterItemList.BasisUnit AS BasisUnit,
		|	FilterItemList.Quantity AS QuantityInBaseUnit,
		|	FilterItemList.ShipmentKey,
		|	CASE
		|		WHEN FilterItemList.ShipmentKey = """"
		|			THEN FALSE
		|		ELSE TRUE
		|	END AS HaveShipment
		|FROM
		|	FilterItemList AS FilterItemList
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON FilterItemList.Basis = ItemList.Ref
		|		AND FilterItemList.Key = ItemList.Key
		|ORDER BY
		|	LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	BasisesTable.Key,
		|	ItemList.Ref,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.Quantity,
		|	"""" AS ShipmentKey
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.Key = ItemList.Key
		|
		|UNION
		|
		|SELECT
		|	ShipmentConfirmationsTable.RowID,
		|	ItemList.Ref,
		|	ShipmentConfirmationsTable.RowID,
		|	ShipmentConfirmationsTable.CurrentStep,
		|	ShipmentConfirmationsTable.RowRef,
		|	ShipmentConfirmationsTable.Basis,
		|	ShipmentConfirmationsTable.Quantity,
		|	ShipmentConfirmationsTable.Key
		|FROM
		|	ShipmentConfirmationsTable AS ShipmentConfirmationsTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON ShipmentConfirmationsTable.SalesOrder = ItemList.Ref
		|		AND ShipmentConfirmationsTable.RowID = ItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	TaxList.Ref,
		|	TaxList.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.SalesOrder.TaxList AS TaxList
		|		INNER JOIN FilterItemList AS FilterItemList
		|		ON FilterItemList.Key = TaxList.Key
		|		AND FilterItemList.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.SalesOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN FilterItemList AS FilterItemList
		|		ON FilterItemList.Basis = SpecialOffers.Ref
		|		AND FilterItemList.Key = SpecialOffers.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	ShipmentConfirmationsTable.SalesOrder AS Ref,
		|	ShipmentConfirmationsTable.RowID AS Key,
		|	ShipmentConfirmationsTable.Basis AS ShipmentConfirmation,
		|	ShipmentConfirmationsTable.Quantity,
		|	ShipmentConfirmationsTable.Quantity AS QuantityInShipmentConfirmation,
		|	ShipmentConfirmationsTable.Key AS ShipmentKey
		|FROM
		|	ShipmentConfirmationsTable
		|		INNER JOIN FilterItemList AS FilterItemList
		|		ON FilterItemLIst.Basis = ShipmentConfirmationsTable.SalesOrder
		|		AND FilterItemList.Key = ShipmentConfirmationsTable.RowID
		|GROUP BY
		|	ShipmentConfirmationsTable.SalesOrder,
		|	ShipmentConfirmationsTable.RowID,
		|	ShipmentConfirmationsTable.Basis,
		|	ShipmentConfirmationsTable.Quantity,
		|	ShipmentConfirmationsTable.Key";

	
	Query.SetParameter("BasisesTable", BasisesTable);
	Query.SetParameter("ShipmentConfirmationsTable", ShipmentConfirmationsTable);
	QueryResults = Query.ExecuteBatch();
	
	Table_ItemList = QueryResults[3].Unload();
	
	Table_RowIDInfo = QueryResults[4].Unload(); 
	Table_RowIDInfo.Columns.Add("TempKey");
	
	Table_TaxList_Temp = QueryResults[5].Unload();
	Table_TaxList = Table_TaxList_Temp.CopyColumns();
	
	Table_SpecialOffers_Temp = QueryResults[6].Unload();
	Table_SpecialOffers = Table_SpecialOffers_Temp.CopyColumns();
	
	Table_ShipmentConfirmations = QueryResults[7].Unload();
	Table_ShipmentConfirmations.Columns.Add("TempKey");
	
	Table_TransferKeys = New ValueTable();
	Table_TransferKeys.Columns.Add("Ref");
	Table_TransferKeys.Columns.Add("OldKey");
	Table_TransferKeys.Columns.Add("TempKey");
	Table_TransferKeys.Columns.Add("HaveShipment");
	
	For Each Row_ItemList In Table_ItemList Do
		TempKey = String(New UUID());
		
		NewRow = Table_TransferKeys.Add();
		NewRow.Ref          = Row_ItemList.Ref;
		NewRow.OldKey       = Row_ItemList.Key;
		NewRow.TempKey      = TempKey;
		NewRow.HaveShipment = Row_ItemList.HaveShipment;

		Filter = New Structure();
		Filter.Insert("Ref", Row_ItemList.Ref);
		Filter.Insert("Key", Row_ItemList.Key);
		Filter.Insert("ShipmentKey", Row_ItemList.ShipmentKey);
		
		For Each Row_ShipmentConfirmations In Table_ShipmentConfirmations.FindRows(Filter) Do
			Row_ShipmentConfirmations.TempKey = TempKey;
		EndDo;
		
		For Each Row_RowIDInfo In Table_RowIDInfo.FindRows(Filter) Do
			Row_RowIDInfo.TempKey = TempKey;
		EndDo;		
	EndDo;
	
	Table_ItemList.GroupBy("BasedOn, Key, Ref, SalesOrder, Partner, LegalName, PriceIncludeTax, Agreement, 
			|ManagerSegment, Currency, Company, ItemKey, Unit, Store, PriceType, DeliveryDate,
			|DontCalculateRow, Quantity, OriginalQuantity, Price, TaxAmount, TotalAmount, NetAmount,
			|OffersAmount, LineNumber, BasisUnit, HaveShipment" , "QuantityInBaseUnit");
	
	For Each Row_ItemList In Table_ItemList Do
		NewKey = String(New UUID());
		
		Filter_TransferKeys = New Structure();
		Filter_TransferKeys.Insert("OldKey"       , Row_ItemList.Key);
		Filter_TransferKeys.Insert("Ref"          , Row_ItemList.Ref);
		Filter_TransferKeys.Insert("HaveShipment" , Row_ItemList.HaveShipment);
		For Each Row_TransferKeys In Table_TransferKeys.FindRows(Filter_TransferKeys) Do
			Filter_TempKey = New Structure();
			Filter_TempKey.Insert("Ref"     , Row_TransferKeys.Ref);
			Filter_TempKey.Insert("Key"     , Row_TransferKeys.OldKey);
			Filter_TempKey.Insert("TempKey" , Row_TransferKeys.TempKey);
			
			For Each Row_ShipmentConfirmations In Table_ShipmentConfirmations.FindRows(Filter_TempKey) Do
				Row_ShipmentConfirmations.Key = NewKey;
			EndDo;
			
			For Each Row_Table_RowIDInfo In Table_RowIDInfo.FindRows(Filter_TempKey) Do
				Row_Table_RowIDInfo.Key = NewKey;
			EndDo;
		EndDo;
		
		If Row_ItemList.Unit <> Row_ItemList.BasisUnit Then
			UnitFactor = Catalogs.Units.GetUnitFactor(Row_ItemList.BasisUnit, Row_ItemList.Unit);		
			Row_ItemList.Quantity = Row_ItemList.QuantityInBaseUnit * UnitFactor;
		Else
			Row_ItemList.Quantity = Row_ItemList.QuantityInBaseUnit;
		EndIf;
		
		// ItemList
		If Row_ItemList.OriginalQuantity = 0 Then
			Row_ItemList.TaxAmount    = 0;
			Row_ItemList.NetAmount    = 0;
			Row_ItemList.TotalAmount  = 0;
			Row_ItemList.OffersAmount = 0;
		ElsIf Row_ItemList.OriginalQuantity <> Row_ItemList.QuantityInBaseUnit Then
			Row_ItemList.TaxAmount    = Row_ItemList.TaxAmount    / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
			Row_ItemList.NetAmount    = Row_ItemList.NetAmount    / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
			Row_ItemList.TotalAmount  = Row_ItemList.TotalAmount  / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
			Row_ItemList.OffersAmount = Row_ItemList.OffersAmount / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
		EndIf;	
		
		Filter = New Structure("Ref, Key", Row_ItemList.Ref, Row_ItemList.Key);
		
		// TaxList
		For Each Row_TaxList In Table_TaxList_Temp.FindRows(Filter) Do
			NewRow_TaxList = Table_TaxList.Add();
			FillPropertyValues(NewRow_TaxList, Row_TaxList);
			If Row_ItemList.OriginalQuantity = 0 Then
				NewRow_TaxList.Amount       = 0;
				NewRow_TaxList.ManualAmount = 0;
			Else
				NewRow_TaxList.Amount       = NewRow_TaxList.Amount       / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
				NewRow_TaxList.ManualAmount = NewRow_TaxList.ManualAmount / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;								
			EndIf;
			NewRow_TaxList.Key = NewKey;
		EndDo;
		
		// SpecialOffers
		For Each Row_SpecialOffers In Table_SpecialOffers_Temp.FindRows(Filter) Do
			NewRow_SpecialOffers = Table_SpecialOffers.Add();
			FillPropertyValues(NewRow_SpecialOffers, Row_SpecialOffers);
			If Row_ItemList.OriginalQuantity = 0 Then
				NewRow_SpecialOffers.Amount = 0;
			Else
				NewRow_SpecialOffers.Amount = NewRow_SpecialOffers.Amount / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
			EndIf;
			NewRow_SpecialOffers.Key = NewKey;
		EndDo;		
				
		Row_ItemList.Key = NewKey;
	EndDo;
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , Table_ItemList);
	Tables.Insert("RowIDInfo"             , Table_RowIDInfo);
	Tables.Insert("TaxList"               , Table_TaxList);
	Tables.Insert("SpecialOffers"         , Table_SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , Table_ShipmentConfirmations);
	Return Tables;
EndFunction

#Region FillBaseOnDocuments

#Region SalesInvoice

Procedure FillSalesInvoice(ArrayOfLinkedDocuments, Object) Export
	Object.RowIDInfo.Clear();
	For Each ItemOfArray In ArrayOfLinkedDocuments Do
		FillPropertyValues(Object.RowIDInfo.Add(), ItemOfArray);
	EndDo;
EndProcedure


#EndRegion

#Region ShipmentConfirmation


#EndRegion

#EndRegion

#Region GetBasises

Function GetBasisesFor_SalesInvoice(FilterValues) Export
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SI);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	BasisesVariants = GetBasisesVariants();
	BasisesVariants.SO = True;
	BasisesVariants.SC = True;
	
	Return GetBasises(StepArray, FilterValues, BasisesVariants);
EndFunction

Function GetBasisesFor_ShipmentConfirmation(FilterValues) Export	
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SC);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	BasisesVariants = GetBasisesVariants();
	BasisesVariants.SO = True;
	
	Return GetBasises(StepArray, FilterValues, BasisesVariants);
EndFunction

Function GetBasises(StepArray, FilterValues, BasisesVariants)				
	Query = New Query;
	FillQueryParameters(Query, FilterValues);
	
	Query.SetParameter("StepArray", StepArray);
	Query.SetParameter("SO", BasisesVariants.SO);
	Query.SetParameter("SC", BasisesVariants.SC);
	
	Basises = New Array();
	Filter_Basises = False;
	If FilterValues.Property("Basises") And FilterValues.Basises.Count() Then
		Basises = FilterValues.Basises;
		Filter_Basises = True;
	EndIf;
	Query.SetParameter("Basises", Basises);
	Query.SetParameter("Filter_Basises", Filter_Basises);
	
	Ref = Documents.SalesInvoice.EmptyRef();
	Period = Undefined;
	If FilterValues.Property("Ref")	And ValueIsFilled(FilterValues.Ref) Then
		Ref = FilterValues.Ref;
		Period = New Boundary(FilterValues.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Period);
	
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, &SO AND Step IN (&StepArray)
	|	AND RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Basises
	|					THEN RowRef.Basis IN (&Basises)
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Agreement
	|					THEN RowRef.Agreement = &Agreement
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Currency
	|					THEN RowRef.Currency = &Currency
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END)) AS RowIDMovements
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, &SC AND Step IN (&StepArray)
	|	AND RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Basises
	|					THEN RowRef.Basis IN (&Basises)
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Partner
	|					THEN RowRef.Partner = &Partner
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalName
	|					THEN RowRef.LegalName = &LegalName
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE TRUE
	|			END)) AS RowIDMovements
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
	|	RowIDMovements.Quantity AS Quantity,
	|	RowIDMovements.RowRef AS RowRef,
	|	RowIDMovements.RowID AS RowID,
	|	RowIDMovements.Step AS CurrentStep
	|FROM
	|	Document.SalesOrder.ItemList AS Doc
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SO AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref
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
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS Doc
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetBasisesVariants()
	Result = New Structure();
	Result.Insert("SO", False);
	Result.Insert("SC", False);
	Return Result;
EndFunction

Procedure FillQueryParameters(Query, FilterValues)
	For Each Attribute In Metadata.Catalogs.RowIDs.Attributes Do
		Value = Undefined; Use = False;
		If FilterValues.Property(Attribute.Name) And ValueIsFilled(FilterValues[Attribute.Name]) Then
			Value = FilterValues[Attribute.Name];
			Use = True;
		EndIf;
		Query.SetParameter("Filter_" + Attribute.Name, Use);
		Query.SetParameter(Attribute.Name, Value);
	EndDo;
EndProcedure	

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

#Region DocumntGeneration

Function ConvertDataToFillingValues(DocReceiverMetadata, ExtractedData)	 Export

	Tables = JoinAllExtractedData(ExtractedData);
	
	DepTables = New Array();
	DepTables.Add("RowIDInfo");
	DepTables.Add("TaxList");
	DepTables.Add("SpecialOffers");
	DepTables.Add("ShipmentConfirmations");
	
	HeaderAttributes = New Array();
	HeaderAttributes.Add("BasedOn");
	For Each Column In Tables.ItemList.Columns Do
		If DocReceiverMetadata.Attributes.Find(Column.Name) <> Undefined Then
			HeaderAttributes.Add(Column.Name);
		EndIf;
	EndDo;
	SeparatorColumns = StrConcat(HeaderAttributes, ",");
	
	UniqueRows = Tables.ItemList.Copy();
	UniqueRows.GroupBy(SeparatorColumns);
		
	MainFilter = New Structure(SeparatorColumns);
	ArrayOfFillingValues = New Array();
	
	For Each Row In UniqueRows Do
		FillPropertyValues(MainFilter, Row);
		TablesFilters = New Array();
		
		FillingValues = New Structure(SeparatorColumns);
		FillPropertyValues(FillingValues, Row);			
		
		FillingValues.Insert("ItemList", New Array());
		For Each DepTable In DepTables Do
			FillingValues.Insert(DepTable, New Array());
		EndDo;
				
		For Each Row In Tables.ItemList.Copy(MainFilter) Do
			TablesFilters.Add(New Structure("Ref, Key", Row.Ref, Row.Key));			
			FillingValues.ItemList.Add(ValueTableRowToStructure(Tables.ItemList.Columns, Row));
		EndDo;
		
		For Each TableFilter In TablesFilters Do
			For Each DepTable In DepTables Do
				For Each Row In Tables[DepTable].Copy(TableFilter) Do
					FillingValues[DepTable].Add(ValueTableRowToStructure(Tables[DepTable].Columns, Row));
				EndDo;
			EndDo;
		EndDo;			
		ArrayOfFillingValues.Add(FillingValues);
	EndDo;	
	Return ArrayOfFillingValues;
EndFunction

Function JoinAllExtractedData(ArrayOfData)
	Tables = New Structure();
	Tables.Insert("ItemList"              , GetEmptyTable_ItemList());
	Tables.Insert("RowIDInfo"             , GetEmptyTable_RowIDInfo());
	Tables.Insert("TaxList"               , GetEmptyTable_TaxList());
	Tables.Insert("SpecialOffers"         , GetEmptyTable_SpecialOffers());
	Tables.Insert("ShipmentConfirmations" , GetEmptyTable_ShipmentConfirmation());
	
	For Each Data In ArrayOfData Do
		For Each Table In Tables Do
			If Data.Property(Table.Key) Then
				CopyTable(Table.Value, Data[Table.Key]);
			EndIf;
		EndDo;
	EndDo;
	Return Tables;
EndFunction

Procedure CopyTable(Receiver, Source)
	For Each Row In Source Do
		FillPropertyValues(Receiver.Add(), Row);
	EndDo;
EndProcedure

Function ValueTableRowToStructure(Columns,Row)
	Result = New Structure();
	For Each Column In Columns Do
		Result.Insert(Column.Name, Row[Column.Name]);
	EndDo;
	Return Result;
EndFunction

#Region EmptyTables

Function GetEmptyTable_ItemList()
	Columns = 
	"Ref,
	|Key,
	|BasedOn,
	|Company,
	|Partner,
	|LegalName,
	|Agreement,
	|Currency,
	|PriceIncludeTax,
	|ManagerSegment,
	|Store,
	|ItemKey,
	|SalesOrder,
	|Unit,
	|Quantity,
	|TaxAmount,
	|TotalAmount,
	|NetAmount,
	|OffersAmount,
	|PriceType,
	|Price,
	|DeliveryDate,
	|DontCalculateRow";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;
EndFunction

Function GetEmptyTable_RowIDInfo()
	Columns = "Ref, Key, RowID, Quantity, Basis, CurrentStep, NextStep, RowRef";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction

Function GetEmptyTable_TaxList()
	Columns = "Ref, Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction
	
Function GetEmptyTable_SpecialOffers()
	Columns = "Ref, Key, Offer, Amount, Percent";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction

Function GetEmptyTable_ShipmentConfirmation()
	Columns = "Ref, Key, ShipmentConfirmation, Quantity, QuantityInShipmentConfirmation";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction
	
//Function GetEmptyTable_Basises() Export
//	Table = New ValueTable();
//	Table.Columns.Add("ItemKey"     , New TypeDescription("CatalogRef.ItemKeys"));
//	Table.Columns.Add("Item"        , New TypeDescription("CatalogRef.Items"));
//	Table.Columns.Add("Store"       , New TypeDescription("CatalogRef.Stores"));
//	Table.Columns.Add("BasisUnit"   , New TypeDescription("CatalogRef.Units"));
//	Table.Columns.Add("CurrentStep" , New TypeDescription("CatalogRef.MovementRules"));
//	Table.Columns.Add("RowRef"      , New TypeDescription("CatalogRef.RowIDs"));
//	Table.Columns.Add("Key"         , Metadata.DefinedTypes.typeRowID.Type);
//	Table.Columns.Add("RowID"       , Metadata.DefinedTypes.typeRowID.Type);
//	Table.Columns.Add("Quantity"    , Metadata.DefinedTypes.typeQuantity.Type);
//	Table.Columns.Add("Basis"       , Metadata.AccumulationRegisters.T10000B_RowIDMovements.Dimensions.Basis.Type);
//	Return Table;
//EndFunction
	
#EndRegion

#EndRegion

