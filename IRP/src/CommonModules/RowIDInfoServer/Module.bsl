
Procedure Posting_RowID(Source, Cancel, PostingMode) Export
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	Table.Ref AS Recorder,
		|	Table.Ref.Date AS Period,
		|	*
		|INTO RowIDMovements
		|FROM
		|	Document." + Source.Metadata().Name + ".RowIDInfo AS Table
		|WHERE
		|	Table.Ref = &Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Table.Recorder,
		|	Table.Period,
		|	Table.RowID,
		|	Table.CurrentStep AS Step,
		|	CASE
		|		WHEN Table.Basis.Ref IS NULL
		|			THEN &Ref
		|		ELSE Table.Basis
		|	END AS Basis,
		|	Table.RowRef,
		|	CASE
		|		WHEN ISNULL(T10000B_RowIDMovements.QuantityBalance, 0) < Table.Quantity
		|			THEN ISNULL(T10000B_RowIDMovements.QuantityBalance, 0)
		|		ELSE Table.Quantity
		|	END AS Quantity
		|FROM
		|	RowIDMovements AS Table
		|		INNER JOIN AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, (RowID, Step, Basis, RowRef) IN
		|			(SELECT
		|				Table.RowID,
		|				Table.CurrentStep,
		|				Table.Basis,
		|				Table.RowRef
		|			FROM
		|				RowIDMovements AS Table
		|			WHERE
		|				NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef))) AS T10000B_RowIDMovements
		|		ON T10000B_RowIDMovements.RowID = Table.RowID
		|		AND T10000B_RowIDMovements.Step = Table.CurrentStep
		|		AND T10000B_RowIDMovements.Basis = Table.Basis
		|		AND T10000B_RowIDMovements.RowRef = Table.RowRef
		|WHERE
		|	NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef)
		|
		|UNION ALL
		|
		|SELECT
		|	VALUE(AccumulationRecordType.Receipt),
		|	Table.Recorder,
		|	Table.Period,
		|	Table.RowID,
		|	Table.NextStep AS Step,
		|	&Ref,
		|	Table.RowRef,
		|	Table.Quantity
		|FROM
		|	RowIDMovements AS Table
		|WHERE
		|	NOT Table.NextStep = VALUE(Catalog.MovementRules.EmptyRef)";

	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("Period", New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding));
	
	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.T10000B_RowIDMovements.Load(QueryResult);
EndProcedure

Procedure BeforeWrite_RowID(Source, Cancel, WriteMode, PostingMode) Export
	If TypeOf(Source) = Type("DocumentObject.SalesOrder") Then
		FillRowID_SO(Source);	
	ElsIf TypeOf(Source) = Type("DocumentObject.SalesInvoice") Then
		FillRowID_SI(Source);
	ElsIf TypeOf(Source) = Type("DocumentObject.ShipmentConfirmation") Then	
		FillRowID_SC(Source);
	EndIf;
EndProcedure

Procedure OnWrite_RowIDOnWrite(Source, Cancel) Export
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.RowRef.Basis) Then
			RowRefObject = Row.RowRef.GetObject();
			RowRefObject.Basis = Source.Ref;
			RowRefObject.Write();
		EndIf;
	EndDo;
EndProcedure

#Region RowID

Procedure FillRowID_SO(Source)
	For Each RowItemList In Source.ItemList Do
	
		If RowItemList.Cancel Then
			Continue;
		EndIf;
		
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Source, Row, RowItemList);
		Row.NextStep = GetNextStep_SO(Source, RowItemList, Row);
	EndDo;
EndProcedure

Function GetNextStep_SO(Source, RowItemList, Row)
	If ValueIsFilled(Row.NextStep) Then
		Return Row.NextStep;
	EndIf;
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.ProcurementMethod = Enums.ProcurementMethods.Purchase Then
		NextStep = Catalogs.MovementRules.PO;
	Else
		If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
			NextStep = Catalogs.MovementRules.SI;
		Else
			NextStep = Catalogs.MovementRules.SI_SC;
		EndIf;
	EndIf;
	Return NextStep;
EndFunction	

Procedure FillRowID_SI(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Function GetNextStep_SI(Source, RowItemList, Row)
	If ValueIsFilled(Row.NextStep) Then
		Return Row.NextStep;
	EndIf;
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseShipmentConfirmation
		And Not Source.ShipmentConfirmations.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
			NextStep = Catalogs.MovementRules.SC;
	EndIf;
	Return NextStep;
EndFunction	

Procedure FillRowID_SC(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_SC(Source, RowItemList, Row);
		Else
			
			IDInfoRowsTable = Source.RowIDInfo.Unload().Copy(New Structure("Key", RowItemList.Key));
			CurrentStep = Undefined;
			For Each Row In IDInfoRowsTable Do
				If ValueIsFilled(Row.CurrentStep) Then
					CurrentStep = Row.CurrentStep;
					Break;
				EndIf;
			EndDo;
			IDInfoRowsTable.FillValues(CurrentStep, "CurrentStep");
			IDInfoRowsTable.GroupBy("Key, RowID, Basis, CurrentStep, RowRef, BasisKey");
			For Each Row In IDInfoRows Do
		    	Source.RowIDInfo.Delete(Row);
			EndDo;
			TotalQuantity = 0;
			For Each Row In IDInfoRowsTable Do
				NewRow = Source.RowIDInfo.Add();
				FillPropertyValues(NewRow, Row);
				NewRow.NextStep = GetNextStep_SC(Source, RowItemList, NewRow);
				If ValueIsFilled(Row.Basis) Then
			    	BalanceQuantity = GetBalanceQuantity(Source, Row);
					NewRow.Quantity = Min(BalanceQuantity, RowItemList.QuantityInBaseUnit);
				Else
					NewRow.Quantity = RowItemList.QuantityInBaseUnit;
				EndIf;
				TotalQuantity = TotalQuantity + NewRow.Quantity;
			EndDo;
			If RowItemList.QuantityInBaseUnit > TotalQuantity Then
				For Each Row In IDInfoRowsTable Do
					NewRow = Source.RowIDInfo.Add();
					FillPropertyValues(NewRow, Row);
					NewRow.CurrentStep = Undefined;
					NewRow.NextStep = Catalogs.MovementRules.SI;
					NewRow.Quantity = RowItemList.QuantityInBaseUnit - TotalQuantity;
				EndDo;	
			EndIf;		
		EndIf;
	EndDo;
EndProcedure

Function GetNextStep_SC(Source, ItemList, Row)
	If ValueIsFilled(Row.NextStep) Then
		Return Row.NextStep;
	EndIf;
	NextStep = Catalogs.MovementRules.EmptyRef();
	If Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales
		And Not ValueIsFilled(ItemList.SalesInvoice) Then
		NextStep = Catalogs.MovementRules.SI;
	EndIf;
	Return NextStep;
EndFunction	

Procedure FillRowID_PO(Source)
	For Each RowItemList In Source.ItemList Do	
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Source, Row, RowItemList);
			Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
				 	Continue;
				EndIf;
				FillRowID(Source, Row, RowItemList);
				Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Function GetNextStep_PO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
		NextStep = Catalogs.MovementRules.SI;
	Else
		NextStep = Catalogs.MovementRules.SI_SC;
	EndIf;
	Return NextStep;
EndFunction	



Procedure FillRowID(Source, Row, RowItemList)
	Row.Key      = RowItemList.Key;
	Row.RowID    = RowItemList.Key;
	Row.Quantity = RowItemList.QuantityInBaseUnit;
	Row.RowRef = CreateRowIDCatalog(Row, RowItemList, Source);	
EndProcedure

Function CreateRowIDCatalog(RowIdInfoRow, Row, Source)
	Query = New Query;
	Query.Text =
		"SELECT
		|	RowIDs.Ref
		|FROM
		|	Catalog.RowIDs AS RowIDs
		|WHERE
		|	RowIDs.RowID = &RowID";
	
	Query.SetParameter("RowID", RowIdInfoRow.RowID);
	QueryResult = Query.Execute().Select();
	
	If QueryResult.Next() Then
		RowRefObject = QueryResult.Ref.GetObject();
	Else
		RowRefObject = Catalogs.RowIDs.CreateItem();
	EndIf;
	FillPropertyValues(RowRefObject, Source);
	FillPropertyValues(RowRefObject, Row);
	
	RowRefObject.RowID = RowIdInfoRow.RowID;
	RowRefObject.Description = RowIdInfoRow.RowID;
	RowRefObject.Write();
	Return RowRefObject.Ref;
EndFunction

Function GetBalanceQuantity(Source, Row)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T10000B_RowIDMovementsBalance.QuantityBalance
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, RowID = &RowID
	|	AND Step = &Step
	|	AND Basis = &Basis
	|	AND RowRef = &RowRef) AS T10000B_RowIDMovementsBalance";
	Period = Undefined;
	If ValueIsFilled(Source.Ref) Then
		Period = New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Period" , Period);
	Query.SetParameter("RowID"  , Row.RowID);
	Query.SetParameter("Step"   , Row.CurrentStep);
	Query.SetParameter("Basis"  , Row.Basis);
	Query.SetParameter("RowRef" , Row.RowRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.QuantityBalance;
	Else
		Return 0;
	EndIf;
EndFunction

#EndRegion

#Region ExtractData

Function ExtractData(BasisesTable, DataReceiver) Export
	Basises_SO = BasisesTable.CopyColumns();
	Basises_SO_SC = BasisesTable.CopyColumns();
	Basises_SO_SC.Columns.Add("SalesOrder", New TypeDescription("DocumentRef.SalesOrder"));
	
	Basises_SC = BasisesTable.CopyColumns();
	Basises_SI = BasisesTable.CopyColumns();
	
	For Each Row In BasisesTable Do
		If TypeOf(Row.Basis) = Type("DocumentRef.SalesOrder") Then
			FillPropertyValues(Basises_SO.Add(), Row);
		ElsIf TypeOf(Row.Basis) = Type("DocumentRef.SalesInvoice") Then
			FillPropertyValues(Basises_SI.Add(), Row);
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
	
	If Basises_SO.Count() Then
		ExtractedData.Add(ExtractData_SO(Basises_SO, DataReceiver));
	EndIf;
	
	If Basises_SI.Count() Then
		ExtractedData.Add(ExtractData_SI(Basises_SI, DataReceiver));
	EndIf;
	
	If Basises_SC.Count() Then
		ExtractedData.Add(ExtractData_SC(Basises_SC, DataReceiver));
	EndIf;
	
	If Basises_SO_SC.Count() Then
		ExtractedData.Add(ExtractData_SO_SC(Basises_SO_SC, DataReceiver));
	EndIf;
	
	Return ExtractedData;
EndFunction

Function ExtractData_SO(BasisesTable, DataReceiver)
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
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
		|SELECT ALLOWED
		|	""SalesOrder"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref AS SalesOrder,
		|	ItemList.Ref AS ShipmentBasis,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
		|	ItemList.Ref.Agreement AS Agreement,
		|	ItemList.Ref.ManagerSegment AS ManagerSegment,
		|	ItemList.Ref.Currency AS Currency,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.Unit AS Unit,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	ItemList.BusinessUnit AS BusinessUnit,
		|	ItemList.RevenueType AS RevenueType,
		|	ItemList.Detail AS Detail,
		|	ItemList.Store.UseShipmentConfirmation 
		|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) 
		|	AS UseShipmentConfirmation,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
		|	ItemList.LineNumber AS LineNumber,
		|	ItemList.Key AS SalesOrderItemListKey,
		|	BasisesTable.Key,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.Quantity AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key AS Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	TaxList.Tax,
		|	TaxList.Analytics,
		|	TaxList.TaxRate,
		|	TaxList.Amount,
		|	TaxList.IncludeToTotalAmount,
		|	TaxList.ManualAmount
		|FROM
		|	Document.SalesOrder.TaxList AS TaxList
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.BasisKey = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.SalesOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	Table_ItemList      = QueryResults[1].Unload();	
	Table_RowIDInfo     = QueryResults[2].Unload();
	Table_TaxList       = QueryResults[3].Unload();
	Table_SpecialOffers = QueryResults[4].Unload();
	
	For Each RowItemList In Table_ItemList Do
		
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
		
		// ItemList
		If RowItemList.OriginalQuantity = 0 Then
			RowItemList.TaxAmount    = 0;
			RowItemList.NetAmount    = 0;
			RowItemList.TotalAmount  = 0;
			RowItemList.OffersAmount = 0;
		ElsIf RowItemList.OriginalQuantity <> RowItemList.QuantityInBaseUnit Then
			RowItemList.TaxAmount    = RowItemList.TaxAmount    / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.NetAmount    = RowItemList.NetAmount    / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.TotalAmount  = RowItemList.TotalAmount  / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			RowItemList.OffersAmount = RowItemList.OffersAmount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
		EndIf;	
		
		Filter = New Structure("Ref, Key", RowItemList.Ref, RowItemList.Key);
		
		// TaxList
		For Each RowTaxList In Table_TaxList.FindRows(Filter) Do
			If RowItemList.OriginalQuantity = 0 Then
				RowTaxList.Amount       = 0;
				RowTaxList.ManualAmount = 0;
			Else
				RowTaxList.Amount       = RowTaxList.Amount       / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
				RowTaxList.ManualAmount = RowTaxList.ManualAmount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;								
			EndIf;
		EndDo;
		
		// SpecialOffers
		For Each RowSpecialOffers In Table_SpecialOffers.FindRows(Filter) Do
			If RowItemList.OriginalQuantity = 0 Then
				RowSpecialOffers.Amount = 0;
			Else
				RowSpecialOffers.Amount = RowSpecialOffers.Amount / RowItemList.OriginalQuantity * RowItemList.QuantityInBaseUnit;
			EndIf;
		EndDo;
	EndDo;
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , Table_ItemList);
	Tables.Insert("RowIDInfo"             , Table_RowIDInfo);
	Tables.Insert("TaxList"               , Table_TaxList);
	Tables.Insert("SpecialOffers"         , Table_SpecialOffers);
	
	Return Tables;
EndFunction

Function ExtractData_SI(BasisesTable, DataReceiver)
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
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
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	""SalesInvoice"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref AS ShipmentBasis,
		|	ItemList.Ref AS SalesInvoice,
		|	ItemList.SalesOrder AS SalesOrder,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Unit AS Unit,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.Quantity AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesInvoice.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable";
		
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	Table_ItemList = QueryResults[1].Unload();
	Table_RowIDInfo = QueryResults[2].Unload(); 
	
	For Each RowItemList In Table_ItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
	
	Tables = New Structure();
	Tables.Insert("ItemList"  , Table_ItemList);
	Tables.Insert("RowIDInfo" , Table_RowIDInfo);
	
	Return Tables;
EndFunction

Function ExtractData_SC(BasisesTable, DataReceiver)
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
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
		|SELECT ALLOWED
		|	""ShipmentConfirmation"" AS BasedOn,
		|	UNDEFINED AS Ref,
		|	ItemList.Ref.Company AS Company,
		|	ItemList.Ref.Partner AS Partner,
		|	ItemList.Ref.LegalName AS LegalName,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Unit AS Unit,
		|	TRUE AS UseShipmentConfirmation,
		|	0 AS Quantity,
		|	BasisesTable.Key,
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	BasisesTable.Quantity AS QuantityInBaseUnit
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.BasisKey = ItemList.Key
		|ORDER BY
		|	ItemList.LineNumber
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Unit AS Unit,
		|	ShipmentConfirmations.Key,
		|	ShipmentConfirmations.BasisKey,
		|	ShipmentConfirmations.Basis AS ShipmentConfirmation,
		|	ShipmentConfirmations.Quantity AS Quantity,
		|	ShipmentConfirmations.Quantity AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS ShipmentConfirmations
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON ShipmentConfirmations.Basis = ItemList.Ref
		|		AND ShipmentConfirmations.BasisKey = ItemList.Key";
			
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	Table_ItemList              = QueryResults[1].Unload();
	Table_RowIDInfo             = QueryResults[2].Unload(); 
	Table_ShipmentConfirmations = QueryResults[3].Unload();
	
	For Each RowItemList In Table_ItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;
		
	Tables = New Structure();
	Tables.Insert("ItemList"             , Table_ItemList);
	Tables.Insert("RowIDInfo"            , Table_RowIDInfo);
	Tables.Insert("ShipmentConfirmations", Table_ShipmentConfirmations);
	
	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Store, Unit");
EndFunction

Function ExtractData_SO_SC(BasisesTable, DataReceiver)
	Query = New Query();
	Query.Text =
		"SELECT
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.SalesOrder,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|INTO BasisesTable
		|FROM
		|	&BasisesTable AS BasisesTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT ALLOWED
		|	BasisesTable.Key,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.SalesOrder AS Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
		|		ON BasisesTable.Basis = RowIDInfo.Ref
		|		AND BasisesTable.BasisKey = RowIDInfo.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	BasisesTable.Key,
		|	BasisesTable.BasisKey,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT DISTINCT
		|	UNDEFINED AS Ref,
		|	ItemList.Store AS Store,
		|	ItemList.ItemKey.Item AS Item,
		|	ItemList.ItemKey AS ItemKey,
		|	ItemList.Unit AS Unit,
		|	ShipmentConfirmations.Key,
		|	ShipmentConfirmations.BasisKey,
		|	ShipmentConfirmations.Basis AS ShipmentConfirmation,
		|	ShipmentConfirmations.Quantity AS Quantity,
		|	ShipmentConfirmations.Quantity AS QuantityInShipmentConfirmation
		|FROM
		|	BasisesTable AS ShipmentConfirmations
		|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
		|		ON ShipmentConfirmations.Basis = ItemList.Ref
		|		AND ShipmentConfirmations.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	Tables_SO = ExtractData_SO(QueryResults[1].Unload(), DataReceiver);
	Tables_SO.ItemList.FillValues(True, "UseShipmentConfirmation");
	
	Table_RowIDInfo             = QueryResults[2].Unload(); 
	Table_ShipmentConfirmations = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , Tables_SO.ItemList);
	Tables.Insert("RowIDInfo"             , Table_RowIDInfo);
	Tables.Insert("TaxList"               , Tables_SO.TaxList);
	Tables.Insert("SpecialOffers"         , Tables_SO.SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , Table_ShipmentConfirmations);
	
	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey");
EndFunction

Function CollapseRepeatingItemListRows(Tables, UniqueColumnNames)
	ItemListGrouped = Tables.ItemList.Copy();
	ItemListGrouped.GroupBy(UniqueColumnNames, "Quantity, QuantityInBaseUnit");
	ItemListResult = Tables.ItemList.CopyColumns();
	
	For Each RowGrouped In ItemListGrouped Do
		Filter = New Structure(UniqueColumnNames);
		FillPropertyValues(Filter, RowGrouped);
		ArrayOfItemListRows = Tables.ItemList.FindRows(Filter);
		
		If ArrayOfItemListRows.Count() = 1 Then
			FillPropertyValues(ItemListResult.Add(), ArrayOfItemListRows[0]);
			Continue;
		Else
			KeyTable = New ValueTable();
			KeyTable.Columns.Add("Key");
			For Each Row In ArrayOfItemListRows Do
				KeyTable.Add().Key = Row.Key;
			EndDo;
			 KeyTable.GroupBy("Key");
			 If KeyTable.Count() = 1 Then
			 	FillPropertyValues(ItemListResult.Add(), ArrayOfItemListRows[0]);
			 	Continue;
			 EndIf;
		EndIf;
		
		NewKey = String(New UUID());
		
		For Each ItemOfArray In ArrayOfItemListRows Do
			Filter = New Structure("Key" , ItemOfArray.Key);
			
			If Tables.Property("RowIDInfo") Then
				For Each Row In Tables.RowIDInfo.FindRows(Filter) Do
					Row.Key = NewKey;
				EndDo;
			EndIf;
			
			If Tables.Property("TaxList") Then
				For Each Row In Tables.TaxList.FindRows(Filter) Do
					Row.Key = NewKey;
				EndDo;
			EndIf;
			
			If Tables.Property("SpecialOffers") Then
				For Each Row In Tables.SpecialOffers.FindRows(Filter) Do
					Row.Key = NewKey;
				EndDo;
			EndIf;
			
			If Tables.Property("ShipmentConfirmations") Then
				For Each Row In Tables.ShipmentConfirmations.FindRows(Filter) Do
					Row.Key = NewKey;
				EndDo;
			EndIf;
		EndDo;
		
		NewRow = ItemListResult.Add();
		FillPropertyValues(NewRow, ArrayOfItemListRows[0]);
		NewRow.Quantity           = RowGrouped.Quantity;
		NewRow.QuantityInBaseUnit = RowGrouped.QuantityInBaseUnit;
		NewRow.Key = NewKey;
	EndDo;
	
	Tables.ItemList = ItemListResult;
	Return Tables;
EndFunction

#EndRegion

#Region AddLinkUnlinkDocumentRow

Procedure AddLinkedDocumentRows(Object, FillingValues) Export
	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		Return;
	EndIf;
	
	TableNames_Refreshable = GetTableNames_Refreshable();
	
	For Each Row_ItemList In FillingValue.ItemList Do
		NewKey = String(New UUID());
		
		For Each TableName In TableNames_Refreshable Do
			If Not FillingValue.Property(TableName) Then
				Continue;
			EndIf;
			For Each Row In FillingValue[TableName] Do
				If CommonFunctionsClientServer.ObjectHasProperty(Row, "Key") 
					And Row.Key = Row_ItemList.Key Then
					Row.Key = NewKey;
				EndIf;
			EndDo;
		EndDo;
		Row_ItemList.Key = NewKey;
	EndDo;
	
	TableNames_Refreshable.Add("ItemList");
	
	For Each TableName In TableNames_Refreshable Do
		If FillingValue.Property(TableName) 
			And CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			For Each Row In FillingValue[TableName] Do
				FillPropertyValues(Object[TableName].Add(), Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure LinkUnlinkDocumentRows(Object, FillingValues) Export
	
	// таблицы в которых есть связанные документы (будут очищены при отвязке строки)
	TableNames_LinkedDocuments = New Array();
	TableNames_LinkedDocuments.Add("ShipmentConfirmations");
	TableNames_LinkedDocuments.Add("GoodsReceipts");
	
	// реквизиты таб. части ItemList котрые хранят данные о связанных документах
	AttributeNames_LinkedDocuments = New Array();
	AttributeNames_LinkedDocuments.Add("SalesOrder");
	AttributeNames_LinkedDocuments.Add("ShipmentBasis");
	AttributeNames_LinkedDocuments.Add("SalesInvoice");
	
	// таблицы в которых есть реквизит Key
	TableNames_WithKeys = New Array();
	TableNames_WithKeys.Add("ItemList");
	TableNames_WithKeys.Add("SpecialOffers");
	TableNames_WithKeys.Add("TaxList");
	TableNames_WithKeys.Add("Currencies");
	TableNames_WithKeys.Add("SerialLotNumbers");
	TableNames_WithKeys.Add("ShipmentConfirmations");
	TableNames_WithKeys.Add("GoodsReceipts");
	
	// таблицы которые обновлются при привязке документа (будут заполнены при привязке строки)
	TableNames_Refreshable = GetTableNames_Refreshable();
	
	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		UnlinkRows = New Array();
		For Each OldRow In Object.RowIDInfo Do
			UnlinkRows.Add(OldRow);
		EndDo;
		Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments);
		Object.RowIDInfo.Clear();
		Return;
	EndIf;
	
	// Unlink
	UnlinkRows = GetUnlinkRows(Object, FillingValue);
	Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments);
		
	// Link
	LinkRows = GetLinkRows(Object, FillingValue);
	Link(Object, FillingValue, LinkRows, TableNames_Refreshable);
	
	Object.RowIDInfo.Clear();
	For Each Row In FillingValue.RowIDInfo Do
		FillPropertyValues(Object.RowIDInfo.Add(), Row);
	EndDo;	
EndProcedure

Function GetFillingValue(FillingValues)
	If TypeOf(FillingValues) = Type("Structure") Then
		Return FillingValues;
	ElsIf TypeOf(FillingValues) = Type("Array") And FillingValues.Count() = 1 Then
		Return FillingValues[0];
	EndIf;
	Return Undefined;
EndFunction

#Region Unlink

Procedure Unlink(Object, UnlinkRows, TableNames, AttributeNames)
	For Each UnlinkRow In UnlinkRows Do
		UnlinkTables(Object, UnlinkRow, TableNames);
		
		// Clear attributes in ItemList
		LinkedRows = Object.ItemList.FindRows(New Structure("Key", UnlinkRow.Key));
		For Each LinkedRow In LinkedRows Do			
			If Not IsCanUnlinkAttributes(Object, UnlinkRow, TableNames) Then
				Continue;
			EndIf;
			UnlinkAttributes(LinkedRow, AttributeNames);
		EndDo;
	EndDo;
EndProcedure

Function GetUnlinkRows(Object, FillingValue)
	UnlinkRows = New Array();
	For Each OldRow In Object.RowIDInfo Do
		IsUnlink = True;
		For Each NewRow In FillingValue.RowIDInfo Do
			If OldRow.Key = NewRow.Key 
				And OldRow.BasisKey = NewRow.BasisKey 
				And OldRow.Basis = NewRow.Basis Then
				IsUnlink = False;
				Break;
			EndIf;
		EndDo;		
		If IsUnlink Then
			UnlinkRows.Add(OldRow);
		EndIf;
	EndDo;
	Return UnlinkRows;
EndFunction

Procedure UnlinkTables(Object, UnlinkRow, TableNames)
	For Each TableName In TableNames Do
		If Not Object.Property(TableName) Then
			Continue;
		EndIf;
			
		Filter = New Structure("Key, BasisKey", UnlinkRow.Key, UnlinkRow.BasisKey);
		LinkedRows = Object[TableName].FindRows(Filter);
			
		For Each LinkedRow In LinkedRows Do
			Object[TableName].Delete(LinkedRow);
		EndDo;
	EndDo;
EndProcedure

Function IsCanUnlinkAttributes(Object, UnlinkRow, TableNames)
	IsCanUnlink = True;
	For Each TableName In TableNames Do
		If Not Object.Property(TableName) Then
			Continue;
		EndIf;
			
		Filter = New Structure("Key", UnlinkRow.Key);
		LinkedRows = Object[TableName].FindRows(Filter);
		If LinkedRows.Count() Then
			IsCanUnlink = False;
			Break;
		EndIf;
	EndDo;
	Return IsCanUnlink;
EndFunction

Procedure UnlinkAttributes(LinkedRow, AttributeNames)
	For Each AttributeName In AttributeNames Do
		If LinkedRow.Property(AttributeName) Then
			LinkedRow[AttributeName] = Undefined;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Link

Procedure Link(Object, FillingValue, LinkRows, TableNames)
	For Each LinkRow In LinkRows Do
		// Update ItemList row
		LinkAttributes(Object, FillingValue, LinkRow);
		
		// Update tables
		LinkTables(Object, FillingValue, LinkRow, TableNames);		
	EndDo;
EndProcedure	

Function GetLinkRows(Object, FillingValue)
	LinkRows = New Array();
	For Each NewRow In FillingValue.RowIDInfo Do
		IsLink = True;
		For Each OldRow In Object.RowIDInfo Do
			If NewRow.Key = OldRow.Key
				And NewRow.BasisKey = OldRow.BasisKey
				And NewRow.Basis = OldRow.Basis Then
				IsLink = False;
				Break;
			EndIf;
		EndDo;
		If IsLink Then
			LinkRows.Add(NewRow);
		EndIf;
	EndDo;	
	Return LinkRows;
EndFunction

Procedure LinkTables(Object, FillingValue, LinkRow, TableNames)
	For Each TableName In TableNames Do
		If Upper(TableName) = Upper("RowIDInfo") Then
			Continue;
		EndIf;
		If Object.Property(TableName) Then
			For Each DeletionRow In Object[TableName].FindRows(New Structure("Key", LinkRow.Key)) Do
				Object[TableName].Delete(DeletionRow);
			EndDo;
		Else
			Continue;
		EndIf;
			
		If Not FillingValue.Property(TableName) Then
			Continue;
		EndIf;
				
		For Each Row In FillingValue[TableName] Do
			If Row.Key = LinkRow.Key Then
				FillPropertyValues(Object[TableName].Add(), Row);
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure LinkAttributes(Object, FillingValue, LinkRow)
	For Each Row_ItemLIst In FillingValue.ItemList Do
		If LinkRow.Key <> Row_ItemList.Key Then
			Continue;
		EndIf;
		For Each Row In Object.ItemList.FindRows(New Structure("Key", LinkRow.Key)) Do
				FillPropertyValues(Row, Row_ItemList);
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#EndRegion

#Region GetBasises

Function GetBasises(Ref, FilterValues) Export
	If TypeOf(Ref) = Type("DocumentRef.SalesInvoice") Then
		Return GetBasises_SI(FilterValues);
	ElsIf TypeOf(Ref) = Type("DocumentRef.ShipmentConfirmation") Then
		Return GetBasises_SC(FilterValues);
	EndIf;
EndFunction

Function GetBasises_SI(FilterValues)
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SI);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	BasisesTypes = GetBasisesTypes();
	BasisesTypes.SO = True;
	BasisesTypes.SC = True;
	
	Return GetBasisesTable(StepArray, FilterValues, BasisesTypes);
EndFunction

Function GetBasises_SC(FilterValues)	
	StepArray = New Array;
	StepArray.Add(Catalogs.MovementRules.SC);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	
	BasisesTypes = GetBasisesTypes();
	BasisesTypes.SO = True;
	BasisesTypes.SI = True;
	
	Return GetBasisesTable(StepArray, FilterValues, BasisesTypes);
EndFunction

Function GetBasisesTypes()
	Result = New Structure();
	Result.Insert("SO", False);
	Result.Insert("SC", False);
	Result.Insert("SI", False);
	Return Result;
EndFunction

Function GetBasisesTable(StepArray, FilterValues, BasisesTypes)				
	Query = New Query;
	FillQueryParameters(Query, FilterValues);
	
	Query.SetParameter("StepArray", StepArray);
	For Each KeyValue In BasisesTypes Do
		Query.SetParameter(KeyValue.Key, KeyValue.Value);
	EndDo;
	
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
	
	Query.TempTablesManager = New TempTablesManager();
	CreateTempTable_RowIDMovements_SO(Query);
	CreateTempTable_RowIDMovements_SI(Query);
	CreateTempTable_RowIDMovements_SC(Query);
	Query.Text =
	"SELECT ALLOWED
	|	Doc.ItemKey AS ItemKey,
	|	Doc.ItemKey.Item AS Item,
	|	Doc.Store AS Store,
	|	Doc.Ref AS Basis,
	|	Doc.Key AS Key,
	|	Doc.Key AS BasisKey,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END AS BasisUnit,
	|	RowIDMovements.Quantity AS Quantity,
	|	RowIDMovements.RowRef AS RowRef,
	|	RowIDMovements.RowID AS RowID,
	|	RowIDMovements.Step AS CurrentStep,
	|	Doc.LineNumber AS LineNumber
	|into AllData
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
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.SalesInvoice.ItemList AS Doc
	|		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SI AS RowIDMovements
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
	|	Doc.Key,
	|	CASE
	|		WHEN Doc.ItemKey.Unit.Ref IS NULL
	|			THEN Doc.ItemKey.Item.Unit
	|		ELSE Doc.ItemKey.Unit
	|	END,
	|	RowIDMovements.Quantity,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	Doc.LineNumber
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS Doc
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON Doc.Ref = RowIDInfo.Ref
	|		AND Doc.Key = RowIDInfo.Key
	|		INNER JOIN RowIDMovements_SC AS RowIDMovements
	|		ON RowIDMovements.RowID = RowIDInfo.RowID
	|		AND RowIDMovements.Basis = RowIDInfo.Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AllData.ItemKey,
	|	AllData.Item,
	|	AllData.Store,
	|	AllData.Basis AS Basis,
	|	AllData.Key,
	|	AllData.BasisKey,
	|	AllData.BasisUnit,
	|	AllData.Quantity,
	|	AllData.RowRef,
	|	AllData.RowID,
	|	AllData.CurrentStep,
	|	AllData.LineNumber AS LineNumber
	|FROM
	|	AllData AS AllData
	|ORDER BY
	|	Basis,
	|	LineNumber
	|AUTOORDER";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	Return QueryTable;
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

Procedure CreateTempTable_RowIDMovements_SO(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, &SO
	|	AND Step IN (&StepArray)
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
	|			END)) AS RowIDMovements";
	Query.Execute();
EndProcedure	

Procedure CreateTempTable_RowIDMovements_SC(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, &SC
	|	AND Step IN (&StepArray)
	|	AND (Basis IN (&Basises) OR
	|	  RowRef IN
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
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure CreateTempTable_RowIDMovements_SI(Query)
	Query.Text = 
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SI
	|FROM
	|	AccumulationRegister.T10000B_RowIDMovements.Balance(&Period, &SI
	|	AND Step IN (&StepArray)
	|	AND CASE
	|			WHEN &Filter_Basises
	|				THEN Basis IN (&Basises)
	|			ELSE TRUE
	|		END
	|	AND RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
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
	|			END)) AS RowIDMovements";
	Query.Execute();
EndProcedure

#EndRegion

#Region DataToFillingValues

Function ConvertDataToFillingValues(DocReceiverMetadata, ExtractedData, SeparateByBasedOn = True) Export

	Tables = JoinAllExtractedData(ExtractedData);
	
	TableNames_Refreshable = GetTableNames_Refreshable();
	
	HeaderAttributes = New Array();
	If SeparateByBasedOn Then
		HeaderAttributes.Add("BasedOn");
	EndIf;
	For Each Column In Tables.ItemList.Columns Do
		If DocReceiverMetadata.Attributes.Find(Column.Name) <> Undefined Then
			HeaderAttributes.Add(Column.Name);
		EndIf;
	EndDo;
	SeparatorColumns = StrConcat(HeaderAttributes, ",");
	
	UniqueRows = Tables.ItemList.Copy();
	UniqueRows.GroupBy(SeparatorColumns);
	
	FullFilledUniqueRows = New Array();
	For Each UniqueRow In UniqueRows Do
		AllColumnsIsNotUndefined = True;
		For Each Column In UniqueRows.Columns Do
			If UniqueRow[Column.Name] = Undefined Then
				AllColumnsIsNotUndefined = False;
				Break;
			EndIf;
		EndDo;
		
		If AllColumnsIsNotUndefined Then
			FullFilledUniqueRows.Add(UniqueRow);
		EndIf;	
	EndDo;
	
	If FullFilledUniqueRows.Count() = 1 Then
		For Each Column In UniqueRows.Columns Do
			For Each UniqueRow In UniqueRows Do
				UniqueRow[Column.Name] = FullFilledUniqueRows[0][Column.Name]; 
			EndDo;
			For Each RowItemList In Tables.ItemList Do
				RowItemList[Column.Name] = FullFilledUniqueRows[0][Column.Name];
			EndDo;
		EndDo;
		UniqueRows.GroupBy(SeparatorColumns);
	EndIf;	
		
	MainFilter = New Structure(SeparatorColumns);
	ArrayOfFillingValues = New Array();
	
	For Each UniqueRow In UniqueRows Do
		FillPropertyValues(MainFilter, UniqueRow);
		TablesFilters = New Array();
		
		FillingValues = New Structure(SeparatorColumns);
		FillPropertyValues(FillingValues, UniqueRow);			
		
		FillingValues.Insert("ItemList", New Array());
		For Each TableName_Refreshable In TableNames_Refreshable Do
			FillingValues.Insert(TableName_Refreshable, New Array());
		EndDo;
				
		For Each RowItemList In Tables.ItemList.Copy(MainFilter) Do
			TablesFilters.Add(New Structure("Ref, Key", RowItemList.Ref, RowItemList.Key));			
			FillingValues.ItemList.Add(ValueTableRowToStructure(Tables.ItemList.Columns, RowItemList));
		EndDo;
		
		For Each TableFilter In TablesFilters Do
			For Each TableName_Refreshable In TableNames_Refreshable Do
				If Not CommonFunctionsClientServer.ObjectHasProperty(Tables, TableName_Refreshable) Then
					Continue;
				EndIf;
				For Each Row_DepTable In Tables[TableName_Refreshable].Copy(TableFilter) Do
					FillingValues[TableName_Refreshable].Add(ValueTableRowToStructure(Tables[TableName_Refreshable].Columns, Row_DepTable));
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
	Tables.Insert("GoodsReceipts"         , GetEmptyTable_GoodsReceipts());
	For Each Data In ArrayOfData Do
		For Each Table In Tables Do
			If Data.Property(Table.Key) Then
				CopyTable(Table.Value, Data[Table.Key]);
			EndIf;
		EndDo;
	EndDo;
	Return Tables;
EndFunction

Function GetTableNames_Refreshable()
	TableNames_Refreshable = New Array();
	TableNames_Refreshable.Add("RowIDInfo");
	TableNames_Refreshable.Add("TaxList");
	TableNames_Refreshable.Add("SpecialOffers");
	TableNames_Refreshable.Add("ShipmentConfirmations");
	TableNames_Refreshable.Add("GoodsReceipts");
	Return TableNames_Refreshable;
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
	|Item,
	|SalesOrder,
	|ShipmentBasis,
	|SalesInvoice,
	|Unit,
	|Quantity,
	|QuantityInBaseUnit,
	|TaxAmount,
	|TotalAmount,
	|NetAmount,
	|OffersAmount,
	|PriceType,
	|Price,
	|DeliveryDate,
	|DontCalculateRow,
	|BusinessUnit,
	|RevenueType,
	|Detail,
	|UseShipmentConfirmation";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;
EndFunction

Function GetEmptyTable_RowIDInfo()
	Columns = "Ref, Key, RowID, Quantity, BasisKey, Basis, CurrentStep, NextStep, RowRef";
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
	Columns = "Ref, Key, BasisKey, ShipmentConfirmation, Quantity, QuantityInShipmentConfirmation";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction

Function GetEmptyTable_GoodsReceipts()
	Columns = "Ref, Key, BasisKey, GoodsReceipt, Quantity, QuantityInGoodsReceipt";
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;	
EndFunction
	
#EndRegion

#EndRegion


#Region BasisesTree

&AtServer
Function CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, BasisesTreeRows) Export
	TreeReverse = TreeReverseInfo.Tree;
	
	BasisTable = New ValueTable();
	BasisTable.Columns.Add("Basis");
	
	FilterTable = New ValueTable();
	FilterTable.Columns.Add("Basis");
	FilterTable.Columns.Add("Level");
	FilterTable.Columns.Add("BasisKey");
	FilterTable.Columns.Add("RowID");
	FilterTable.Columns.Add("RowRef");
	
	LastRows = TreeReverse.Rows.FindRows(New Structure("LastRow", True), True);
	If Not LastRows.Count() Then
		Return Undefined;
	EndIf;
	
	For Each LastRow In LastRows Do
		LastRow.LastRow = False;
		
		FillPropertyValues(BasisTable.Add(), LastRow);
		
		NewFilterRow = FilterTable.Add();
		FillPropertyValues(NewFilterRow, LastRow);
		NewFilterRow.Level    = LastRow.Level - 1;
		NewFilterRow.BasisKey = LastRow.Key;
	EndDo;
	
	BasisTable.GroupBy("Basis");
	FilterTable.GroupBy("Basis, Level, BasisKey, RowID, RowRef");
		
	For Each RowBasis In BasisTable Do
		NewBasisesTreeRow = BasisesTreeRows.Add();
		NewBasisesTreeRow.Picture = 1;
		NewBasisesTreeRow.RowPresentation = String(RowBasis.Basis);
		
		FillPropertyValues(NewBasisesTreeRow, RowBasis);
		
		For Each RowFilter In FilterTable.FindRows(New Structure("Basis", RowBasis.Basis)) Do
		
			ParentFilter = New Structure("Level, BasisKey, RowID, RowRef");
			FillPropertyValues(ParentFilter, RowFilter);
			ParentRows = TreeReverse.Rows.FindRows(ParentFilter, True);
		
			If Not ParentRows.Count() Then
				BasisesFilter = New Structure();
				BasisesFilter.Insert("BasisKey" , RowFilter.BasisKey);
				BasisesFilter.Insert("RowID"    , RowFilter.RowID);
				BasisesFilter.Insert("RowRef"   , RowFilter.RowRef);
				BasisesFilter.Insert("Basis"    , RowFilter.Basis);
				For Each TableRow In BasisesTable.FindRows(BasisesFilter) Do
					
					// deep level
					DeepLevelRow = NewBasisesTreeRow.GetItems().Add();
					DeepLevelRow.Picture = 0;
					DeepLevelRow.RowPresentation =
					String(TableRow.Item) + ", " + String(TableRow.ItemKey);
					
					DeepLevelRow.DeepLevel = True;
					FillPropertyValues(DeepLevelRow, TableRow);
					
					// price, currency, unit
					BasisesInfoFilter = New Structure("RowID", TableRow.RowID);
					For Each InfoRow In TreeReverseInfo.BasisesInfoTable.FindRows(BasisesInfoFilter) Do
						FillPropertyValues(DeepLevelRow, InfoRow);
					EndDo;
					
					DeepLevelRow.QuantityInBaseUnit = TableRow.Quantity;
					DeepLevelRow.Quantity = Catalogs.Units.Convert(DeepLevelRow.BasisUnit, 
						DeepLevelRow.Unit, DeepLevelRow.QuantityInBaseUnit);
						
						
					ResultsFilter = New Structure();
					ResultsFilter.Insert("RowID"    , DeepLevelRow.RowID);
					ResultsFilter.Insert("BasisKey" , DeepLevelRow.Key);
					ResultsFilter.Insert("Basis"    , DeepLevelRow.Basis);
					If ResultsTable.FindRows(ResultsFilter).Count() Then
						DeepLevelRow.Use = True;
						DeepLevelRow.Linked = True;
					EndIf;
			
				EndDo;
			Else
				For Each ParentRow In ParentRows Do
					ParentRow.LastRow = True;
				EndDo;
				
			EndIf; // ParentRows.Count()
		
		EndDo; // FilterTable
	
			CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, NewBasisesTreeRow.GetItems());
		
	EndDo; // BasisTable
EndFunction

Function CreateBasisesTreeReverse(BasisesTable) Export
	Tree = New ValueTree();
	Tree.Columns.Add("Key");
	Tree.Columns.Add("Basis");
	Tree.Columns.Add("RowRef");
	Tree.Columns.Add("RowID");
	Tree.Columns.Add("BasisKey");
	
	Tree.Columns.Add("Price");
	Tree.Columns.Add("Currency");
	Tree.Columns.Add("Unit");
	
	Tree.Columns.Add("Level");
	Tree.Columns.Add("LastRow");
	
	For Each TableRow In BasisesTable Do
		
		BasisesInfo = GetBasisesInfo(TableRow.Basis, TableRow.BasisKey, TableRow.RowID);
			
		//top level
		Level = 1;
		NewTreeRow = Tree.Rows.Add();
		NewTreeRow.Level = Level;
			
		FillPropertyValues(NewTreeRow, BasisesInfo);
		
		CreateBasisesTreeReverseRecursive(BasisesInfo, NewTreeRow.Rows, Level);
		
		If Not NewTreeRow.Rows.Count() Then
			NewTreeRow.LastRow = True;
		EndIf;
			
	EndDo;
		
	BasisesInfoTable = New ValueTable();
	BasisesInfoTable.Columns.Add("RowID");
	BasisesInfoTable.Columns.Add("Price");
	BasisesInfoTable.Columns.Add("Currency");
	BasisesInfoTable.Columns.Add("Unit");
	
	LastRows =  Tree.Rows.FindRows(New Structure("LastRow", True), True);
	For Each LastRow In LastRows Do
		FillPropertyValues(BasisesInfoTable.Add(), LastRow);
	EndDo;
		
	Return New Structure("Tree, BasisesInfoTable", Tree, BasisesInfoTable);
EndFunction

Procedure CreateBasisesTreeReverseRecursive(BasisesInfo, TreeRows, Level)
	If BasisesInfo.Basis <> BasisesInfo.RowRef.Basis Then
		ParentBasisInfo = GetBasisesInfo(BasisesInfo.ParentBasis, BasisesInfo.BasisKey, BasisesInfo.RowID);
		Level = Level + 1;
		NewTreeRow = TreeRows.Add();
		NewTreeRow.Level = Level;
		
		FillPropertyValues(NewTreeRow, ParentBasisInfo);
		
		CreateBasisesTreeReverseRecursive(ParentBasisInfo, NewTreeRow.Rows, Level);
		
		If Not NewTreeRow.Rows.Count() Then
			NewTreeRow.LastRow = True;
		EndIf;
		
	EndIf;
EndProcedure

Function GetBasisesInfo(Basis, BasisKey, RowID)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef AS RowRef,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	RowIDInfo.RowID AS RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key AS Key,
	|	ItemList.Price AS Price,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Unit AS Unit
	|FROM
	|	Document.SalesOrder.ItemList AS ItemList
	|		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID
	|
	|UNION ALL
	|
	|SELECT
	|	RowIDInfo.Ref,
	|	RowIDInfo.RowRef,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key,
	|	0,
	|	UNDEFINED,
	|	ItemList.Unit
	|FROM
	|	Document.ShipmentConfirmation.ItemList AS ItemList
	|		INNER JOIN Document.ShipmentConfirmation.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID
	|
	|UNION ALL
	|
	|SELECT
	|	RowIDInfo.Ref,
	|	RowIDInfo.RowRef,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.RowID,
	|	RowIDInfo.Basis AS ParentBasis,
	|	ItemList.Key,
	|	ItemList.Price,
	|	ItemList.Ref.Currency,
	|	ItemList.Unit
	|FROM
	|	Document.SalesInvoice.ItemList AS ItemList
	|		INNER JOIN Document.SalesInvoice.RowIDInfo AS RowIDInfo
	|		ON RowIDInfo.Ref = &Basis
	|		AND ItemList.Ref = &Basis
	|		AND RowIDInfo.Key = &BasisKey
	|		AND ItemList.Key = &BasisKey
	|		AND RowIDInfo.Key = ItemList.Key
	|		AND RowIDInfo.Ref = ItemList.Ref
	|		AND RowIDInfo.RowID = &RowID";
	
	Query.SetParameter("Basis"    , Basis);
	Query.SetParameter("BasisKey" , BasisKey);
	Query.SetParameter("RowID"    , RowID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	BasisInfo = New Structure("Key, Basis, RowRef, RowID, ParentBasis, BasisKey, Price, Currency, Unit");
	If QuerySelection.Next() Then
		FillPropertyValues(BasisInfo, QuerySelection);
	EndIf;
	Return BasisInfo;
EndFunction

#EndRegion

