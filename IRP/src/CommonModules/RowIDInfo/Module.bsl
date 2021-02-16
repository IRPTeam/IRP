
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

#Region FillBaseOnDocuments

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

Function ExtractData_SalesOrder(BasisesTable) Export
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
		|	BasisesTable.BasisUnit AS BasisUnit,
		|	ItemList.Store AS Store,
		|	ItemList.PriceType AS PriceType,
		|	ItemList.DeliveryDate AS DeliveryDate,
		|	ItemList.DontCalculateRow AS DontCalculateRow,
		|	BasisesTable.Quantity AS QuantityInBaseUnit,
		|	0 AS Quantity,
		|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
		|	ISNULL(ItemList.Price, 0) AS Price,
		|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
		|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
		|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
		|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.Key = ItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BasisesTable.Key,
		|	ItemList.Ref,
		|	BasisesTable.RowID,
		|	BasisesTable.CurrentStep,
		|	BasisesTable.RowRef,
		|	BasisesTable.Basis,
		|	BasisesTable.BasisUnit,
		|	BasisesTable.Quantity
		|FROM
		|	BasisesTable AS BasisesTable
		|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
		|		ON BasisesTable.Basis = ItemList.Ref
		|		AND BasisesTable.Key = ItemList.Key
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
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
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Key = TaxList.Key
		|		AND BasisesTable.Basis = TaxList.Ref
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	SpecialOffers.Ref,
		|	SpecialOffers.Key,
		|	SpecialOffers.Offer,
		|	SpecialOffers.Amount,
		|	SpecialOffers.Percent
		|FROM
		|	Document.SalesOrder.SpecialOffers AS SpecialOffers
		|		INNER JOIN BasisesTable AS BasisesTable
		|		ON BasisesTable.Basis = SpecialOffers.Ref
		|		AND BasisesTable.Key = SpecialOffers.Key";

	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();
	
	Table_ItemList      = QueryResults[1].Unload();
	Table_RowIDInfo     = QueryResults[2].Unload(); 
	Table_TaxList       = QueryResults[3].Unload();
	Table_SpecialOffers = QueryResults[4].Unload();
	
	For Each Row_ItemList In Table_ItemList Do
		NewKey = String(New UUID());
		
		If Row_ItemList.Unit <> Row_ItemList.BasisUnit Then
			UnitFactor = Catalogs.Units.GetUnitFactor(Row_ItemList.BasisUnit, Row_ItemList.Unit);		
			Row_ItemList.Quantity = Row_ItemList.QuantityInBaseUnit * UnitFactor;
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
		
		// RowIDInfo
		For Each Row_RowIDInfo In Table_RowIDInfo.FindRows(New Structure("Key", Row_ItemList.Key)) Do
			Row_RowIDInfo.Key = NewKey;
		EndDo;
		
		// TaxList
		For Each Row_TaxList In Table_TaxList.FindRows(New Structure("Key", Row_ItemList.Key)) Do
			If Row_ItemList.OriginalQuantity = 0 Then
				Row_TaxList.Amount       = 0;
				Row_TaxList.ManualAmount = 0;
			Else
				Row_TaxList.Amount       = Row_TaxList.Amount       / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
				Row_TaxList.ManualAmount = Row_TaxList.ManualAmount / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;								
			EndIf;
			Row_TaxList.Key = NewKey;
		EndDo;
		
		// SpecialOffers
		For Each Row_SpecialOffers In Table_SpecialOffers.FindRows(New Structure("Key", Row_ItemList.Key)) Do
			If Row_ItemList.OriginalQuantity = 0 Then
				Row_SpecialOffers.Amount = 0;
			Else
				Row_SpecialOffers.Amount = Row_SpecialOffers.Amount / Row_ItemList.OriginalQuantity * Row_ItemList.QuantityInBaseUnit;
			EndIf;
			Row_SpecialOffers.Key = NewKey
		EndDo;		
		
		Row_ItemList.Key = NewKey;
	EndDo;
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , Table_ItemList);
	Tables.Insert("RowIDInfo"     , Table_RowIDInfo);
	Tables.Insert("TaxList"       , Table_TaxList);
	Tables.Insert("SpecialOffers" , Table_SpecialOffers);
	
	Return Tables;
EndFunction

#Region SalesInvoice

Procedure FillSalesInvoice(ArrayOfLinkedDocuments, Object) Export
	Object.RowIDInfo.Clear();
	For Each ItemOfArray In ArrayOfLinkedDocuments Do
		FillPropertyValues(Object.RowIDInfo.Add(), ItemOfArray);
	EndDo;
EndProcedure


Function GetBasisesFor_SalesInvoice(FilterValues) Export
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
		
	Ref = Documents.SalesInvoice.EmptyRef();
	Period =Undefined;
	If FilterValues.Property("Ref")	And ValueIsFilled(FilterValues.Ref) Then
		Ref = FilterValues.Ref;
		Period = New Boundary(FilterValues.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Period);
	
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

#Region ShipmentConfirmation

Function GetBasisesFor_ShipmentConfirmation(FilterValues) Export	

	Return Undefined;	
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

#Region DocumntGeneration

Function ConvertDataToFillingValues(DocReceiverMetadata, ExtractedData)	 Export

	Tables = JoinAllExtractedData(ExtractedData);
	
	DepTables = New Array();
	DepTables.Add("RowIDInfo");
	DepTables.Add("TaxList");
	DepTables.Add("SpecialOffers");
	DepTables.Add("ShipmentConfirmation");
	
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
	Tables.Insert("ItemList"             , GetEmptyTable_ItemList());
	Tables.Insert("RowIDInfo"            , GetEmptyTable_RowIDInfo());
	Tables.Insert("TaxList"              , GetEmptyTable_TaxList());
	Tables.Insert("SpecialOffers"        , GetEmptyTable_SpecialOffers());
	Tables.Insert("ShipmentConfirmation" , GetEmptyTable_ShipmentConfirmation());
	
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
	
#EndRegion

#EndRegion

