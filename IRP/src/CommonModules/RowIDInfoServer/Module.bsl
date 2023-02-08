
// Event subscriptions: BeforeWrite_RowID
Procedure BeforeWrite_RowID(Source, Cancel, WriteMode, PostingMode) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;

	If Cancel Then
		Return;
	EndIf;

	BeginTransaction();
	Is = Is(Source);
	If Is.SO Then
		FillRowID_SO(Source, Cancel);
	ElsIf Is.SI Then
		FillRowID_SI(Source, Cancel);
	ElsIf Is.SC Then
		FillRowID_SC(Source, Cancel);
	ElsIf Is.PO Then
		FillRowID_PO(Source, Cancel);
	ElsIf Is.PI Then
		FillRowID_PI(Source, Cancel);
	ElsIf Is.GR Then
		FillRowID_GR(Source, Cancel);
	ElsIf Is.ITO Then
		FillRowID_ITO(Source, Cancel);
	ElsIf Is.IT Then
		FillRowID_IT(Source, Cancel);
	ElsIf Is.ISR Then
		FillRowID_ISR(Source, Cancel);
	ElsIf Is.PhysicalInventory Then
		FillRowID_PhysicalInventory(Source, Cancel);
	ElsIf Is.StockAdjustmentAsSurplus Then
		FillRowID_StockAdjustmentAsSurplus(Source, Cancel);
	ElsIf Is.StockAdjustmentAsWriteOff Then
		FillRowID_StockAdjustmentAsWriteOff(Source, Cancel);
	ElsIf Is.PR Then
		FillRowID_PR(Source, Cancel);
	ElsIf Is.PRO Then
		FillRowID_PRO(Source, Cancel);
	ElsIf Is.SR Then
		FillRowID_SR(Source, Cancel);
	ElsIf Is.SRO Then
		FillRowID_SRO(Source, Cancel);
	ElsIf Is.RSR Then
		FillRowID_RSR(Source, Cancel);
	ElsIf Is.RRR Then
		FillRowID_RRR(Source, Cancel);
	ElsIf Is.PRR Then
		FillRowID_PRR(Source, Cancel);
	ElsIf Is.WO Then
		FillRowID_WO(Source, Cancel);
	ElsIf Is.WS Then
		FillRowID_WS(Source, Cancel);
	EndIf;
	If Cancel = True Then
		RollbackTransaction();
	Else
		CommitTransaction();
	EndIf;
EndProcedure

// Event subscriptions: OnWrite_RowID
Procedure OnWrite_RowID(Source, Cancel) Export
	If Source.DataExchange.Load Then
		Return;
	EndIf;

	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.RowRef AS RowRef
	|INTO RowIDInfo
	|FROM
	|	&RowIDInfo AS RowIDInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TM1010B_RowIDMovements.Recorder,
	|	RowIDInfo.RowRef
	|INTO tmpRecorders
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements AS TM1010B_RowIDMovements
	|		INNER JOIN RowIDInfo
	|		ON TM1010B_RowIDMovements.RowRef = RowIDInfo.RowRef
	|		AND TM1010B_RowIDMovements.RecordType = VALUE(AccumulationRecordType.Expense)
	|
	|UNION ALL
	|
	|SELECT
	|	TM1010T_RowIDMovements.Recorder,
	|	RowIDInfo.RowRef
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements AS TM1010T_RowIDMovements
	|		INNER JOIN RowIDInfo
	|		ON TM1010T_RowIDMovements.RowRef = RowIDInfo.RowRef
	|		AND TM1010T_RowIDMovements.Quantity < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpRecorders.Recorder,
	|	tmpRecorders.RowRef
	|FROM
	|	tmpRecorders AS tmpRecorders";
	Query.SetParameter("RowIDInfo", Source.RowIDInfo.Unload());
	QueryResult = Query.Execute();
	RecordersByRowRef = QueryResult.Unload();
	
	TableOfDifferenceFields = New ValueTable();
	TableOfDifferenceFields.Columns.Add("FieldName");
	TableOfDifferenceFields.Columns.Add("DataPath");
	TableOfDifferenceFields.Columns.Add("LineNumber");
	TableOfDifferenceFields.Columns.Add("ValueBefore");
	TableOfDifferenceFields.Columns.Add("ValueAfter");
	
	For Each Row In Source.RowIDInfo Do
		RowItemList = Source.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		RowRefObject = Row.RowRef.GetObject();
		If Not ValueIsFilled(Row.RowRef.Basis) Then
			RowRefObject.Basis = Source.Ref;
		EndIf;
		ArrayOfDifferenceFields = UpdateRowIDCatalog(Source, Row, RowItemList, RowRefObject, Cancel, RecordersByRowRef);
		For Each ItemOfDifferenceFields In ArrayOfDifferenceFields Do
			NewRow = TableOfDifferenceFields.Add();
			FillPropertyValues(NewRow, ItemOfDifferenceFields);
			If Find(ItemOfDifferenceFields.DataPath, "ItemList") = 0 Then
				NewRow.LineNumber = 0;
			EndIf;
		EndDo;
	EndDo;
	TableOfDifferenceFields.GroupBy("FieldName, DataPath, LineNumber, ValueBefore, ValueAfter");
	For Each Difference In TableOfDifferenceFields Do
		If ValueIsFilled(Difference.DataPath) Then
			If Find(Difference.DataPath, "ItemList") <> 0 Then
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_098, 
					Difference.LineNumber, Difference.FieldName, Difference.ValueBefore, Difference.ValueAfter),
					"ItemList[" + Format((Difference.LineNumber - 1), "NZ=0; NG=0;") + "]." 
					+ StrReplace(Difference.DataPath, "ItemList.", ""), Source);
			Else
				CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_099,
					Difference.FieldName, Difference.ValueBefore, Difference.ValueAfter),
					Difference.DataPath, Source);
			EndIf;
		Else
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_100,
				Difference.ValueBefore, Difference.ValueAfter));
		EndIf;
	EndDo;
EndProcedure

// Event subscriptions: Posting_RowID
Procedure Posting_RowID(Source, Cancel, PostingMode) Export
	If Is(Source).SOC Then
		Posting_TM1010B_RowIDMovements_SOC(Source, Cancel, PostingMode);
	EndIf;
	
	If Is(Source).POC Then
		Posting_TM1010B_RowIDMovements_POC(Source, Cancel, PostingMode);
	EndIf;
	
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	ItemList_InDocument = GetRowIDWithLineNumbers(Source);	
	Records_InDocument = GetRecordsInDocument(Source).TM1010B_RowIDMovements;
	Records_Exists = AccumulationRegisters.TM1010B_RowIDMovements.GetExistsRecords(Source.Ref);
	
	If Source.Metadata().Attributes.Find("Status") <> Undefined Then
		StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Source.Ref);
		If Not StatusInfo.Posting Then
			Unposting = True;
			Source.RegisterRecords.TM1010B_RowIDMovements.Clear();
			Source.RegisterRecords.TM1010B_RowIDMovements.Write();
			CheckAfterWrite(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, Unposting);
			Return;
		EndIf;
	EndIf;
	
	Unposting = False;
	Source.RegisterRecords.TM1010B_RowIDMovements.Load(Records_InDocument);
	Source.RegisterRecords.TM1010B_RowIDMovements.Write();
	
	CheckAfterWrite(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, Unposting);	

	If Not Cancel Then
		Is = Is(Source);
		If Is.SI Or Is.PI Or Is.RSR Then
			Posting_TM1010T_RowIDMovements_Invoice(Source, Cancel, PostingMode);
			
			If Is.RSR Then
				Records_InDocument = GetRecordsInDocument_TM1010T_RSR(Source);
				Records_Exists = GetRecordsExists_TM1010T(Source, AccumulationRecordType.Receipt);
				CheckAfterWrite_TM1010T(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, AccumulationRecordType.Receipt, Unposting);
			EndIf;
		EndIf;

		If Is.SR Or Is.SRO Or Is.PR Or Is.PRO Or Is.RRR Then
			Posting_TM1010T_RowIDMovements_Return(Source, Cancel, PostingMode);
			If Is.RRR Then
				Records_InDocument = GetRecordsInDocument_TM1010T_RRR(Source);
				ItemList_InDocument = GetItemListInDocument_RRR(Source);
				Records_Exists = GetRecordsExists_TM1010T(Source, AccumulationRecordType.Expense);
				CheckAfterWrite_TM1010T(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, AccumulationRecordType.Expense, Unposting);
			EndIf;
		EndIf;
	EndIf;
EndProcedure

// Event subscriptions: UndoPosting_RowID
Procedure UndoPosting_RowIDUndoPosting(Source, Cancel) Export
	If Source.Metadata().TabularSections.Find("RowIDInfo") = Undefined Then
		Return;
	EndIf;
	
	Records_Exists = AccumulationRegisters.TM1010B_RowIDMovements.GetExistsRecords(Source.Ref);
	Records_InDocument  = GetRecordsInDocument(Source).TM1010B_RowIDMovements;
	ItemList_InDocument = GetRowIDWithLineNumbers(Source);
	
	Unposting = True;
	Source.RegisterRecords.TM1010B_RowIDMovements.Clear();
	Source.RegisterRecords.TM1010B_RowIDMovements.Write();
	
	CheckAfterWrite(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, Unposting);
	
	Is = Is(Source);
	If Not Cancel And (Is.RSR Or Is.RRR Or Is.SI Or Is.SR) Then
		Source.RegisterRecords.TM1010T_RowIDMovements.Clear();
		Source.RegisterRecords.TM1010T_RowIDMovements.Write();
	
		If Is.RSR Then
			Records_InDocument = GetRecordsInDocument_TM1010T_RSR(Source);
			Records_Exists = GetRecordsExists_TM1010T(Source, AccumulationRecordType.Receipt);
			CheckAfterWrite_TM1010T(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, AccumulationRecordType.Receipt, Unposting);
		EndIf;

		If Is.RRR Then
			Records_InDocument = GetRecordsInDocument_TM1010T_RRR(Source);
			ItemList_InDocument = GetItemListInDocument_RRR(Source);
			Records_Exists = GetRecordsExists_TM1010T(Source, AccumulationRecordType.Expense);
			CheckAfterWrite_TM1010T(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, AccumulationRecordType.Expense, Unposting);
		EndIf;		
	EndIf;
EndProcedure

Procedure Posting_TM1010B_RowIDMovements_SOC(Source, Cancel, PostingMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SalesOrderItemList.Ref.Date AS Period,
	|	SalesOrderItemList.Ref.SalesOrder AS Order,
	|	SalesOrderItemList.Key AS RowKey,
	|	SalesOrderItemList.Cancel AS IsCanceled
	|INTO ItemList
	|FROM
	|	Document.SalesOrderClosing.ItemList AS SalesOrderItemList
	|WHERE
	|	SalesOrderItemList.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.RowID,
	|	RowIDInfo.Key AS BasisKey,
	|	RowIDInfo.NextStep AS Step,
	|	ItemList.Order AS Basis,
	|	RowIDInfo.RowRef
	|INTO RowIDInfo
	|FROM
	|	Document.SalesOrder.RowIDInfo AS RowIDInfo
	|		INNER JOIN ItemList
	|		ON RowIDInfo.Ref = ItemList.Order
	|		AND RowIDInfo.Key = ItemList.RowKey
	|		AND ItemList.IsCanceled
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	&Period AS Period,
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	-TM1010B_RowIDMovementsBalance.QuantityBalance AS Quantity,
	|	*
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&BalancePeriod, (RowID, Step, Basis, BasisKey, RowRef) IN
	|		(SELECT
	|			RowIDInfo.RowID,
	|			RowIDInfo.Step,
	|			RowIDInfo.Basis,
	|			RowIDInfo.BasisKey,
	|			RowIDInfo.RowRef
	|		FROM
	|			RowIDInfo AS RowIDInfo)) AS TM1010B_RowIDMovementsBalance";
	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("Period", Source.Ref.Date);
	Query.SetParameter("BalancePeriod", New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding));
	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.TM1010B_RowIDMovements.Load(QueryResult);
EndProcedure

Procedure Posting_TM1010B_RowIDMovements_POC(Source, Cancel, PostingMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	PurchaseOrderItems.Ref.Date AS Period,
	|	PurchaseOrderItems.Ref.PurchaseOrder AS Order,
	|	PurchaseOrderItems.Key AS RowKey,
	|	PurchaseOrderItems.Cancel AS IsCanceled
	|INTO ItemList
	|FROM
	|	Document.PurchaseOrderClosing.ItemList AS PurchaseOrderItems
	|WHERE
	|	PurchaseOrderItems.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.RowID,
	|	RowIDInfo.NextStep AS Step,
	|	RowIDInfo.Key AS BasisKey,
	|	ItemList.Order AS Basis,
	|	RowIDInfo.RowRef
	|INTO RowIDInfo
	|FROM
	|	Document.PurchaseOrder.RowIDInfo AS RowIDInfo
	|		INNER JOIN ItemList
	|		ON RowIDInfo.Ref = ItemList.Order
	|		AND RowIDInfo.Key = ItemList.RowKey
	|		AND ItemList.IsCanceled
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	&Period AS Period,
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	-TM1010B_RowIDMovementsBalance.QuantityBalance AS Quantity,
	|	*
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&BalancePeriod, (RowID, Step, Basis, BasisKey, RowRef) IN
	|		(SELECT
	|			RowIDInfo.RowID,
	|			RowIDInfo.Step,
	|			RowIDInfo.Basis,
	|			RowIDInfo.BasisKey,
	|			RowIDInfo.RowRef
	|		FROM
	|			RowIDInfo AS RowIDInfo)) AS TM1010B_RowIDMovementsBalance";
	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("Period", Source.Ref.Date);
	Query.SetParameter("BalancePeriod", New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding));
	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.TM1010B_RowIDMovements.Load(QueryResult);
EndProcedure

Procedure Posting_TM1010T_RowIDMovements_Return(Source, Cancel, PostingMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.Ref.Date AS Period,
	|	RowIDInfo.Ref AS Recorder,
	|	RowIDInfo.RowID,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.CurrentStep AS Step,
	|	- RowIDInfo.Quantity AS Quantity,
	|	RowIDInfo.Basis AS Basis,
	|	RowIDInfo.RowRef
	|FROM
	|	Document." + Source.Metadata().Name + ".RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|	AND RowIDInfo.CurrentStep = &CurrentStep
	|GROUP BY
	|	RowIDInfo.Ref.Date,
	|	RowIDInfo.Ref,
	|	RowIDInfo.RowID,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.CurrentStep,
	|	RowIDInfo.Quantity,
	|	RowIDInfo.Basis,
	|	RowIDInfo.RowRef";
	Query.SetParameter("Ref", Source.Ref);

	CurrentStep = Undefined;
	Is = Is(Source);
	If Is.SR Or Is.SRO Then
		CurrentStep = Catalogs.MovementRules.SRO_SR;
	ElsIf Is.PR Or Is.PRO Then
		CurrentStep = Catalogs.MovementRules.PRO_PR;
	ElsIf Is.RRR Then
		CurrentStep = Catalogs.MovementRules.RRR;
	EndIf;

	Query.SetParameter("CurrentStep", CurrentStep);

	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.TM1010T_RowIDMovements.Load(QueryResult);
	Source.RegisterRecords.TM1010T_RowIDMovements.Write();
EndProcedure

Procedure Posting_TM1010T_RowIDMovements_Invoice(Source, Cancel, PostingMode)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.Ref.Date AS Period,
	|	RowIDInfo.Ref AS Recorder,
	|	RowIDInfo.RowID,
	|	RowIDInfo.Key AS BasisKey,
	|	&NextStep AS Step,
	|	RowIDInfo.Quantity,
	|	RowIDInfo.Ref AS Basis,
	|	RowIDInfo.RowRef
	|FROM
	|	Document." + Source.Metadata().Name + ".RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|GROUP BY
	|	RowIDInfo.Ref.Date,
	|	RowIDInfo.Ref,
	|	RowIDInfo.RowID,
	|	RowIDInfo.Key,
	|	RowIDInfo.Quantity,
	|	RowIDInfo.RowRef";
	Query.SetParameter("Ref", Source.Ref);

	NextStep = Undefined;
	Is = Is(Source);
	If Is.SI Then
		NextStep = Catalogs.MovementRules.SRO_SR;
	ElsIf Is.PI Then
		NextStep = Catalogs.MovementRules.PRO_PR;
	ElsIf Is.RSR Then
		NextStep = Catalogs.MovementRules.RRR;
	EndIf;

	Query.SetParameter("NextStep", NextStep);

	QueryResult = Query.Execute().Unload();
	Source.RegisterRecords.TM1010T_RowIDMovements.Load(QueryResult);
	Source.RegisterRecords.TM1010T_RowIDMovements.Write();
EndProcedure

Procedure CheckAfterWrite(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, Unposting)
	If Not LinkedRowsIntegrityIsEnable() Then
		Return;
	EndIf;
	
	Filter = New Structure("RecordType", AccumulationRecordType.Expense);
	If Not Cancel And Not AccumulationRegisters.TM1010B_RowIDMovements.CheckBalance(Source.Ref, ItemList_InDocument, 
			Records_InDocument.Copy(Filter), 
			Records_Exists.Copy(Filter), 
			Filter.RecordType, Unposting) Then
		Cancel = True;
	EndIf;
	
	Filter = New Structure("RecordType", AccumulationRecordType.Receipt);
	If Not Cancel And Not AccumulationRegisters.TM1010B_RowIDMovements.CheckBalance(Source.Ref, ItemList_InDocument, 
			Records_InDocument.Copy(Filter), 
			Records_Exists.Copy(Filter), 
			Filter.RecordType, Unposting) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure CheckAfterWrite_TM1010T(Source, Cancel, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting)
	If Not LinkedRowsIntegrityIsEnable() Then
		Return;
	EndIf;
	
	If Not Cancel And Not AccumulationRegisters.TM1010T_RowIDMovements.CheckBalance(Source.Ref, ItemList_InDocument,
		Records_InDocument, Records_Exists, RecordType, Unposting) Then											
		Cancel = True;
	EndIf;
EndProcedure

Function GetRecordsExists_TM1010T(Source, RecordType)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CASE
	|		WHEN TM1010T_RowIDMovements.Quantity < 0
	|			THEN -TM1010T_RowIDMovements.Quantity
	|		ELSE TM1010T_RowIDMovements.Quantity
	|	END AS Quantity,
	|	*
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements AS TM1010T_RowIDMovements
	|WHERE
	|	TM1010T_RowIDMovements.Recorder = &Ref
	|	AND CASE
	|		WHEN &IsExpense
	|			THEN TM1010T_RowIDMovements.Quantity < 0
	|		ELSE TM1010T_RowIDMovements.Quantity > 0
	|	END";
	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("IsExpense", RecordType = AccumulationRecordType.Expense);
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction

Function GetRecordsInDocument_TM1010T_RRR(Source)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.CurrentStep AS Step,
	|	*
	|FROM
	|	Document.%1.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref
	|	AND NOT RowIDInfo.Basis.Ref IS NULL";
	Query.Text = StrTemplate(Query.Text, Source.Metadata().Name);
	Query.SetParameter("Ref", Source.Ref);
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction

Function GetRecordsInDocument_TM1010T_RSR(Source)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	VALUE(Catalog.MovementRules.RRR) AS Step,
	|	RowIDInfo.Key AS BasisKey,
	|	RowIDInfo.Ref AS Basis,
	|	*
	|FROM
	|	Document.%1.RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.Ref = &Ref";
	Query.Text = StrTemplate(Query.Text, Source.Metadata().Name);
	Query.SetParameter("Ref", Source.Ref);
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction

Function GetItemListInDocument_RRR(Source)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ItemList.Key AS Key,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.ItemKey AS ItemKey
	|FROM
	|	Document.%1.ItemList AS ItemList
	|		INNER JOIN Document.%1.RowIDInfo AS RowIDInfo
	|		ON ItemList.Key = RowIDInfo.Key
	|		AND ItemList.Ref = &Ref
	|		AND RowIDInfo.Ref = &Ref
	|		AND NOT RowIDInfo.Basis.Ref IS NULL
	|WHERE
	|	ItemList.Ref = &Ref
	|	AND RowIDInfo.Ref = &Ref";
	Query.Text = StrTemplate(Query.Text, Source.Metadata().Name);
	Query.SetParameter("Ref", Source.Ref);
	QueryTable = Query.Execute().Unload();
	Return QueryTable;
EndFunction	

Function GetRowIDWithLineNumbers(Source)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	RowIDInfo.RowID AS RowID,
	|	MIN(ItemList.LineNumber) AS LineNumber,
	|	MIN(ItemList.ItemKey) AS ItemKey
	|FROM
	|	Document." + Source.Metadata().Name + ".RowIDInfo AS RowIDInfo
	|		INNER JOIN Document." + Source.Metadata().Name + ".ItemList AS ItemList
	|		ON RowIDInfo.Ref = &Ref
	|		AND ItemList.Ref = &Ref
	|		AND RowIDInfo.Key = ItemList.Key
	|GROUP BY
	|	RowIDInfo.RowID";
	Query.SetParameter("Ref", Source.Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetRecordsInDocument(Source)
	Query = New Query();
	Query.Text = 
		"SELECT
		|	Table.Ref AS Recorder,
		|	Table.Ref.Date AS Period, 
		|	Table.RowID,
		|	Table.BasisKey,
		|	Table.CurrentStep,
		| 	Table.Basis,
		|	Table.RowRef,
		|	SUM(Table.Quantity) AS Quantity
		|INTO RowIDMovements
		|FROM
		|	Document." + Source.Metadata().Name + ".RowIDInfo AS Table
		|WHERE
		|	Table.Ref = &Ref
		|GROUP BY
		|	Table.Ref,
		|	Table.Ref.Date, 
		|	Table.RowID,
		|	Table.BasisKey,
		|	Table.CurrentStep,
		| 	Table.Basis,
		|	Table.RowRef
		|;
		|//////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	Table.Ref AS Recorder,
		|	Table.Ref.Date AS Period, 
		|	Table.RowID,
		|	Table.Key,
		|	Table.NextStep,
		| 	Table.Basis,
		|	Table.RowRef,
		|	Table.Quantity
		|INTO RowIDMovementsFull
		|FROM
		|	Document." + Source.Metadata().Name + ".RowIDInfo AS Table
		|WHERE
		|	Table.Ref = &Ref
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	Table.Recorder,
		|	Table.Period,
		|	Table.RowID,
		|	Table.BasisKey,
		|	Table.CurrentStep AS Step,
		|	CASE
		|		WHEN Table.Basis.Ref IS NULL
		|			THEN &Ref
		|		ELSE Table.Basis
		|	END AS Basis,
		|	Table.RowRef,
		|	CASE
		|		WHEN ISNULL(TM1010B_RowIDMovements.QuantityBalance, 0) < Table.Quantity
		|			THEN ISNULL(TM1010B_RowIDMovements.QuantityBalance, 0)
		|		ELSE Table.Quantity
		|	END AS Quantity
		|FROM
		|	RowIDMovements AS Table
		|		INNER JOIN AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, (RowID, BasisKey, Step, Basis, RowRef) IN
		|			(SELECT
		|				Table.RowID,
		|				Table.BasisKey,
		|				Table.CurrentStep,
		|				Table.Basis,
		|				Table.RowRef
		|			FROM
		|				RowIDMovements AS Table
		|			WHERE
		|				NOT Table.CurrentStep = VALUE(Catalog.MovementRules.EmptyRef))) AS TM1010B_RowIDMovements
		|		ON TM1010B_RowIDMovements.RowID = Table.RowID
		|		AND TM1010B_RowIDMovements.BasisKey = Table.BasisKey
		|		AND TM1010B_RowIDMovements.Step = Table.CurrentStep
		|		AND TM1010B_RowIDMovements.Basis = Table.Basis
		|		AND TM1010B_RowIDMovements.RowRef = Table.RowRef
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
		|	Table.Key,
		|	Table.NextStep AS Step,
		|	&Ref,
		|	Table.RowRef,
		|	Table.Quantity
		|FROM
		|	RowIDMovementsFull AS Table
		|WHERE
		|	NOT Table.NextStep = VALUE(Catalog.MovementRules.EmptyRef)";

	Query.SetParameter("Ref", Source.Ref);
	Query.SetParameter("Period", New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding));
	Return New Structure("TM1010B_RowIDMovements", Query.Execute().Unload());
EndFunction

#Region RowID

#Region FillRowID

Procedure FillRowID_SO(Source, Cancel)
	ArrayForDelete = New Array();
	For Each Row In Source.RowIDInfo Do
		If Row.NextStep = Catalogs.MovementRules.PRR Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;

	For Each ItemForDelete In ArrayForDelete Do
		Source.RowIDInfo.Delete(ItemForDelete);
	EndDo;

	For Each RowItemList In Source.ItemList Do

		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		If RowItemList.Cancel Then
			Source.RowIDInfo.Delete(Row);
			Continue;
		EndIf;

		FillRowID(Row, RowItemList);
		Row.NextStep = GetNextStep_SO(Source, RowItemList, Row);

		If RowItemList.ProcurementMethod = Enums.ProcurementMethods.IncomingReserve Then
			NewRow = Source.RowIDInfo.Add();
			FillPropertyValues(NewRow, Row);
			NewRow.CurrentStep = Undefined;
			NewRow.NextStep = Catalogs.MovementRules.PRR;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SI(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_SI(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SC(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
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

Procedure FillRowID_PO(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If RowItemList.Cancel Then
			For Each Row In IDInfoRows Do
				Source.RowIDInfo.Delete(Row);
			EndDo;
			Continue;
		EndIf;
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_PO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PI(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_PI(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;

	NewRows = New Map();

	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.CurrentStep) Then
			Continue;
		EndIf;
		For Each RowItemList In Source.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			If ValueIsFilled(RowItemList.SalesOrder) And Not RowItemList.UseGoodsReceipt Then
				NewRows.Insert(Row, RowItemList.QuantityInBaseUnit);
			EndIf;
		EndDo;
	EndDo;

	For Each Row In NewRows Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SI_SC;
		NewRow.Quantity    = Row.Value;
	EndDo;
EndProcedure

Procedure FillRowID_GR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_GR(Source, RowItemList, Row);
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
				NewRow.NextStep = GetNextStep_GR(Source, RowItemList, NewRow);
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
					NewRow.NextStep = Catalogs.MovementRules.PI;
					NewRow.Quantity = RowItemList.QuantityInBaseUnit - TotalQuantity;
				EndDo;
			EndIf;
		EndIf;
	EndDo;

	NewRows = New Map();

	For Each Row In Source.RowIDInfo Do
		If Not ValueIsFilled(Row.CurrentStep) Then
			Continue;
		EndIf;
		For Each RowItemList In Source.ItemList.FindRows(New Structure("Key", Row.Key)) Do
			If ValueIsFilled(RowItemList.SalesOrder) Then
				NewRows.Insert(Row, RowItemList.QuantityInBaseUnit);
			EndIf;
		EndDo;
	EndDo;

	For Each Row In NewRows Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SI_SC;
		NewRow.Quantity    = Row.Value;
	EndDo;
EndProcedure

Procedure FillRowID_ITO(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_ITO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_IT(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		For Each Row In IDInfoRows Do
			If Not ValueIsFilled(Row.CurrentStep) Then
				Source.RowIDInfo.Delete(Row);
			EndIf;
		EndDo;
	EndDo;

	NewRowsSC = New Map();
	NewRowsGR = New Map();
	RowsForDelete = New Array();

	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_IT(Source, RowItemList, Row);
		Else
			Row = IDInfoRows[0];
			Row.NextStep = GetNextStep_IT(Source, RowItemList, Row);
		EndIf;

		If Source.UseGoodsReceipt Then
			NewRowsGR.Insert(Row, RowItemList.QuantityInBaseUnit);
		EndIf;

		If Source.UseShipmentConfirmation Then
			NewRowsSC.Insert(Row, RowItemList.QuantityInBaseUnit);
		EndIf;
		If Not ValueIsFilled(Row.CurrentStep) Then
			RowsForDelete.Add(Row);
		EndIf;
	EndDo;

	For Each Row In NewRowsSC Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.SC;
		NewRow.Quantity    = Row.Value;
	EndDo;

	For Each Row In NewRowsGR Do
		NewRow = Source.RowIDInfo.Add();
		FillPropertyValues(NewRow, Row.Key);
		NewRow.CurrentStep = Undefined;
		NewRow.NextStep    = Catalogs.MovementRules.GR;
		NewRow.Quantity    = Row.Value;
	EndDo;

	For Each RowForDelete In RowsForDelete Do
		Source.RowIDInfo.Delete(RowForDelete);
	EndDo;
EndProcedure

Procedure FillRowID_ISR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Row, RowItemList);
		Row.NextStep = GetNextStep_ISR(Source, RowItemList, Row);
	EndDo;
EndProcedure

Procedure FillRowID_PhysicalInventory(Source, Cancel)
	ArrayForDelete = New Array();
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
		ElsIf IDInfoRows.Count() = 1 Then
			Row = IDInfoRows[0];
		EndIf;

		FillRowID(Row, RowItemList);
		Row.NextStep = GetNextStep_PhysicalInventory(Source, RowItemList, Row);
		If Not ValueIsFilled(Row.Quantity) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Source.RowIDInfo.Delete(ItemForDelete);
	EndDo;
EndProcedure

Procedure FillRowID_StockAdjustmentAsSurplus(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_StockAdjustmentAsWriteOff(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_PR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PRO(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_PRO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_SR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_SRO(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_SRO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_RSR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_RSR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_RSR(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_RSR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_RRR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_RRR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_RRR(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_RRR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_PRR(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_PRR(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_PRR(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_PRR(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_WO(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_WO(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_WO(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_WO(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Procedure FillRowID_WS(Source, Cancel)
	For Each RowItemList In Source.ItemList Do
		Row = Undefined;
		IDInfoRows = Source.RowIDInfo.FindRows(New Structure("Key", RowItemList.Key));
		If IDInfoRows.Count() = 0 Then
			Row = Source.RowIDInfo.Add();
			FillRowID(Row, RowItemList);
			Row.NextStep = GetNextStep_WS(Source, RowItemList, Row);
		Else
			For Each Row In IDInfoRows Do
				If ValueIsFilled(Row.RowRef) And Row.RowRef.Basis <> Source.Ref Then
					Row.NextStep = GetNextStep_WS(Source, RowItemList, Row);
					Continue;
				EndIf;
				FillRowID(Row, RowItemList);
				Row.NextStep = GetNextStep_WS(Source, RowItemList, Row);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region GetNextStep

Function GetNextStep_SO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	
	If Source.TransactionType = Enums.SalesTransactionTypes.RetailSales Then
		NextStep = Catalogs.MovementRules.RSR;
	Else
		If RowItemList.ProcurementMethod = Enums.ProcurementMethods.Purchase Then
			NextStep = Catalogs.MovementRules.PO_PI;
		Else
			If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
				NextStep = Catalogs.MovementRules.SI_WO_WS;
			Else
				NextStep = Catalogs.MovementRules.SI_SC;
			EndIf;
		EndIf;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_SI(Source, RowItemList, Row)
	ItemType_Type = RowItemList.ItemKey.Item.ItemType.Type;
	
	If RowItemList.UseShipmentConfirmation 
		And ItemType_Type = Enums.ItemTypes.Product
		And Not Source.ShipmentConfirmations.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
		Return Catalogs.MovementRules.SC;
	EndIf;
	
	If RowItemList.UseWorkSheet
		And ItemType_Type = Enums.ItemTypes.Service
		And Not Source.WorkSheets.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
		Return Catalogs.MovementRules.WS;
	EndIf;
	
	Return Catalogs.MovementRules.EmptyRef();
EndFunction

Function GetNextStep_SC(Source, ItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If (Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales
			Or Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent)
		And Not ValueIsFilled(ItemList.SalesInvoice) Then
		NextStep = Catalogs.MovementRules.SI;
	ElsIf (Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor
			Or Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor)
	 	And Not ValueIsFilled(ItemList.PurchaseReturn) Then
		NextStep = Catalogs.MovementRules.PR;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_PO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service Then
		NextStep = Catalogs.MovementRules.PI;
	Else
		NextStep = Catalogs.MovementRules.PI_GR;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_PI(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseGoodsReceipt And Not RowItemList.ItemKey.Item.ItemType.Type = Enums.ItemTypes.Service
		And Not Source.GoodsReceipts.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
		NextStep = Catalogs.MovementRules.GR;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_GR(Source, ItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If (Source.TransactionType = Enums.GoodsReceiptTransactionTypes.Purchase
			Or Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReceiptFromConsignor) 
		And Not ValueIsFilled(ItemList.PurchaseInvoice) Then
		NextStep = Catalogs.MovementRules.PI;
	ElsIf (Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer
	 		Or Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent)
		And Not ValueIsFilled(ItemList.SalesReturn) Then
		NextStep = Catalogs.MovementRules.SR;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_ITO(Source, RowItemList, Row)
	Return Catalogs.MovementRules.IT;
EndFunction

Function GetNextStep_IT(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_ISR(Source, RowItemList, Row)
	Return Catalogs.MovementRules.ITO_PO_PI;
EndFunction

Function GetNextStep_PhysicalInventory(Source, RowItemList, Row)
	If RowItemList.Difference > 0 Then
		Return Catalogs.MovementRules.StockAdjustmentAsSurplus;
	EndIf;

	If RowItemList.Difference < 0 Then
		Return Catalogs.MovementRules.StockAdjustmentAsWriteOff;
	EndIf;
	Return Undefined;
EndFunction

Function GetNextStep_StockAdjustmentAsSurplus(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_StockAdjustmentAsWriteOff(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_PR(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseShipmentConfirmation And Not Source.ShipmentConfirmations.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
		NextStep = Catalogs.MovementRules.SC;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_PRO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.PR;
	Return NextStep;
EndFunction

Function GetNextStep_SR(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.EmptyRef();
	If RowItemList.UseGoodsReceipt And Not Source.GoodsReceipts.FindRows(New Structure("Key", RowItemList.Key)).Count() Then
		NextStep = Catalogs.MovementRules.GR;
	EndIf;
	Return NextStep;
EndFunction

Function GetNextStep_SRO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.SR;
	Return NextStep;
EndFunction

Function GetNextStep_RSR(Source, RowItemList, Row)
	NextStep = Undefined;
	Return NextStep;
EndFunction

Function GetNextStep_RRR(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_PRR(Source, RowItemList, Row)
	Return Undefined;
EndFunction

Function GetNextStep_WO(Source, RowItemList, Row)
	NextStep = Catalogs.MovementRules.SI_WS;
	Return NextStep;
EndFunction

Function GetNextStep_WS(Source, RowItemList, Row)
	If ValueIsFilled(RowItemList.SalesInvoice) Then
		Return Catalogs.MovementRules.EmptyRef();
	EndIf;
	Return Catalogs.MovementRules.SI;
EndFunction

#EndRegion

Procedure FillRowID(RowRowIDInfo, RowItemList)
	RowRowIDInfo.Key      = RowItemList.Key;
	RowRowIDInfo.RowID    = RowItemList.Key;
	If CommonFunctionsClientServer.ObjectHasProperty(RowItemList, "Difference") Then
		RowRowIDInfo.Quantity = ?(RowItemList.Difference < 0, -RowItemList.Difference, RowItemList.Difference);
	Else
		RowRowIDInfo.Quantity = RowItemList.QuantityInBaseUnit;
	EndIf;
	RowRowIDInfo.RowRef = FindOrCreateRowIDRef(RowRowIDInfo.RowID);
EndProcedure

Function FindOrCreateRowIDRef(RowID)
	Query = New Query();
	Query.Text =
	"SELECT
	|	RowIDs.RowID,
	|	RowIDs.Ref
	|FROM
	|	Catalog.RowIDs AS RowIDs
	|WHERE
	|	RowIDs.RowID = &RowID";

	Query.SetParameter("RowID", RowID);
	QueryResult = Query.Execute().Select();

	If QueryResult.Next() Then 
		If QueryResult.RowID = RowID Then
			Return QueryResult.Ref;
		EndIf;
		RowRefObject = QueryResult.Ref.GetObject();
	Else
		RowRefObject = Catalogs.RowIDs.CreateItem();
	EndIf;
	
	RowRefObject.RowID       = RowID;
	RowRefObject.Description = RowID;
	WriteRowIDCatalog(RowRefObject);
	
	Return RowRefObject.Ref;
EndFunction

Function GetMD5RowIDs(RowID)
	AllAttributes = New Structure;
	For Each Attr In Metadata.Catalogs.RowIDs.Attributes Do
		If Not StrCompare(Attr.Name, "Hash") Then
			Continue;
		EndIf;
		CurrentValue = RowID[Attr.Name];
		AllAttributes.Insert(Attr.Name, CurrentValue);
	EndDo;
	Return CommonFunctionsServer.GetMD5(AllAttributes);
EndFunction

// Write row IDCatalog.
// 
// Parameters:
//  Obj - CatalogObject.RowIDs - Obj
Procedure WriteRowIDCatalog(Obj)
	If Obj.Ref.isEmpty() Then
		// first write
		Obj.Hash = GetMD5RowIDs(Obj);
		Obj.Write();
		Return;
	EndIf;
	
	Hash = GetMD5RowIDs(Obj);
	
	If Not Obj.Hash = Hash Then
		Obj.Hash = Hash;
		Obj.Write();
	EndIf;
EndProcedure

Function UpdateRowIDCatalog(Source, Row, RowItemList, RowRefObject, Cancel, RecordersByRowRef)
	FieldsForCheckRowRef = Undefined;
	CachedObjectBefore   = Undefined;
	CachedObjectAfter    = Undefined;
	If Not Source.Ref.isEmpty() Then
		FieldsForCheckRowRef = GetFieldsForCheckRowRef(Source, RowRefObject, RecordersByRowRef);
		CachedObjectBefore   = GetRowRefCache(RowRefObject, FieldsForCheckRowRef);
	EndIf;
	
	Is = Is(Source);
	If Is.SC And Is(RowRefObject.Basis).ISR Then
		FillPropertyValues(RowRefObject, RowItemList, , "Store");
	ElsIf Is.RRR Or Is.SR Then
		FillPropertyValues(RowRefObject, RowItemList, , "Store");
		RowRefObject.StoreReturn = RowItemList.Store;
	Else
		FillPropertyValues(RowRefObject, RowItemList);
	EndIf;
	
	If Is.RRR Or Is.SR Then
		FillPropertyValues(RowRefObject, Source, , "Company, Branch");
	Else
		FillPropertyValues(RowRefObject, Source);
	EndIf;
	
	RowRefObject.RowID       = Row.RowID;
	RowRefObject.Description = Row.RowID;
	
	If Is.RRR Or Is.SR Then
		RowRefObject.CompanyReturn = Source.Company;
		RowRefObject.BranchReturn = Source.Branch;
	EndIf;
	
	If Is.ITO Or Is.IT Then
		RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.InventoryTransfer;
		RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.InventoryTransfer;
	ElsIf Is.SO Or Is.SI Then
		RowRefObject.TransactionTypeSales = Source.TransactionType;
		
		If Source.TransactionType = Enums.SalesTransactionTypes.Sales Then
			
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.Sales;
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer;
			RowRefObject.TransactionTypeSR = Enums.SalesReturnTransactionTypes.ReturnFromCustomer;
		
		ElsIf Source.TransactionType = Enums.SalesTransactionTypes.ShipmentToTradeAgent Then
			
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent;
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent;
			RowRefObject.TransactionTypeSR = Enums.SalesReturnTransactionTypes.ReturnFromTradeAgent;
			
		EndIf;
		
		RowRefObject.Requester = Source.Ref;
	ElsIf Is.PO Or Is.PI Then
		RowRefObject.TransactionTypePurchases = Source.TransactionType;
		
		If Source.TransactionType = Enums.PurchaseTransactionTypes.Purchase Then
			
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.Purchase;
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor;
			RowRefObject.TransactionTypePR = Enums.PurchaseReturnTransactionTypes.ReturnToVendor;
			
		ElsIf Source.TransactionType = Enums.PurchaseTransactionTypes.ReceiptFromConsignor Then
			
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.ReceiptFromConsignor;
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor;
			RowRefObject.TransactionTypePR = Enums.PurchaseReturnTransactionTypes.ReturnToConsignor;
			
		EndIf;
		
	ElsIf Is.SC Then
		RowRefObject.TransactionTypeSC = Source.TransactionType;
	ElsIf Is.GR Then
		RowRefObject.TransactionTypeGR = Source.TransactionType;
	ElsIf Is.PR Or Is.PRO Then
		RowRefObject.TransactionTypePR = Source.TransactionType;
		
		If Source.TransactionType = Enums.PurchaseReturnTransactionTypes.ReturnToVendor Then
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor;
		ElsIf Source.TransactionType = Enums.PurchaseReturnTransactionTypes.ReturnToConsignor Then
			RowRefObject.TransactionTypeSC = Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor;
		EndIf;
	ElsIf Is.SR Or Is.SRO Then
		RowRefObject.TransactionTypeSR = Source.TransactionType;
		
		If Source.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromCustomer Then
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer;
		ElsIf Source.TransactionType = Enums.SalesReturnTransactionTypes.ReturnFromTradeAgent Then
			RowRefObject.TransactionTypeGR = Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent;
		EndIf;
	ElsIf Is.WO Or Is.WS Then
		
		RowRefObject.TransactionTypeSales = Enums.SalesTransactionTypes.Sales;
		
	ElsIf Is.ITO Or Is.IT Then
		RowRefObject.StoreSender = Source.StoreSender;
		RowRefObject.StoreReceiver = Source.StoreReceiver;
	EndIf;
	
	If Is.SI Or Is.SRO Or Is.SR Or Is.RSR Or Is.RRR Or Is.WO Then
		RowRefObject.PartnerSales         = Source.Partner;
		RowRefObject.LegalNameSales       = Source.LegalName;
		RowRefObject.AgreementSales       = Source.Agreement;
		RowRefObject.CurrencySales        = Source.Currency;
		RowRefObject.PriceIncludeTaxSales = Source.PriceIncludeTax;
	ElsIf Is.SO Then
		If Source.TransactionType = Enums.SalesTransactionTypes.RetailSales Then
			RowRefObject.RetailCustomer = Source.RetailCustomer;
		Else
			RowRefObject.PartnerSales   = Source.Partner;
			RowRefObject.LegalNameSales = Source.LegalName;
			RowRefObject.AgreementSales = Source.Agreement;		
		EndIf;
		RowRefObject.CurrencySales        = Source.Currency;
		RowRefObject.PriceIncludeTaxSales = Source.PriceIncludeTax;
	ElsIf Is.PO Or Is.PI Or Is.PRO Or Is.PR Then
		RowRefObject.PartnerPurchases         = Source.Partner;
		RowRefObject.LegalNamePurchases       = Source.LegalName;
		RowRefObject.AgreementPurchases       = Source.Agreement;
		RowRefObject.CurrencyPurchases        = Source.Currency;
		RowRefObject.PriceIncludeTaxPurchases = Source.PriceIncludeTax;
	ElsIf Is.SC Then
		If Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.Sales 
			Or Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent Then
			RowRefObject.PartnerSales   = Source.Partner;
			RowRefObject.LegalNameSales = Source.LegalName;
		ElsIf Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToVendor
			Or Source.TransactionType = Enums.ShipmentConfirmationTransactionTypes.ReturnToConsignor Then 
			RowRefObject.PartnerPurchases   = Source.Partner;
			RowRefObject.LegalNamePurchases = Source.LegalName;
		EndIf;
	ElsIf Is.GR Then
		If Source.TransactionType = Enums.GoodsReceiptTransactionTypes.Purchase
			Or Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReceiptFromConsignor Then
			RowRefObject.PartnerPurchases         = Source.Partner;
			RowRefObject.LegalNamePurchases       = Source.LegalName;
		ElsIf Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer
			Or Source.TransactionType = Enums.GoodsReceiptTransactionTypes.ReturnFromTradeAgent Then
			RowRefObject.PartnerSales   = Source.Partner;
			RowRefObject.LegalNameSales = Source.LegalName;
		EndIf;

	ElsIf Is.WS Then
		RowRefObject.PartnerSales    = Source.Partner;
		RowRefObject.LegalNameSales  = Source.LegalName;
	EndIf;
	
	ArrayOfDifferenceFields = New Array();
	If LinkedRowsIntegrityIsEnable() Then
		If ValueIsFilled(Source.Ref) Then
			CachedObjectAfter = GetRowRefCache(RowRefObject, FieldsForCheckRowRef);
			IsDifference = IsDifferenceInCachedObjects(CachedObjectBefore, CachedObjectAfter, FieldsForCheckRowRef);
			If IsDifference.Difference Then
				Cancel = True;
				For Each Difference In IsDifference.Fields Do
					ItemOfDifferenceFields = New Structure();
					ItemOfDifferenceFields.Insert("FieldName"   , Difference.FieldName);
					ItemOfDifferenceFields.Insert("DataPath"    , Difference.DataPath);
					ItemOfDifferenceFields.Insert("LineNumber"  , RowItemList.LineNumber);
					ItemOfDifferenceFields.Insert("ValueBefore" , Difference.ValueBefore);
					ItemOfDifferenceFields.Insert("ValueAfter"  , Difference.ValueAfter);
					ArrayOfDifferenceFields.Add(ItemOfDifferenceFields);
				EndDo;
			EndIf;
		EndIf;
	EndIf;
	
	If Not Cancel Then
		WriteRowIDCatalog(RowRefObject);
	EndIf;
	Return ArrayOfDifferenceFields;
EndFunction

Function GetFieldsForCheckRowRef(Source, RowRefObject, RecordersByRowRef)
	
	RecordersTable = RecordersByRowRef.Copy(New Structure("RowRef", RowRefObject.Ref));
	RecordersTable.GroupBy("Recorder");

		
	ExternalLinkedDocsTable = New ValueTable();
	ExternalLinkedDocsTable.Columns.Add("Doc");
	
	DocAliases = DocAliases();
	
	For Each Row In RecordersTable Do
		For Each KeyValue In Is(Row.Recorder) Do
			If KeyValue.Value Then
				ExternalLinkedDocsTable.Add().Doc = DocAliases[KeyValue.Key];
				Break;
			EndIf;
		EndDo;
	EndDo;
	ExternalLinkedDocsTable.GroupBy("Doc");
	
	FieldsToLock_ExternalLinkedDocs =
	GetFieldsToLock_ExternalLinkedDocs(Source.Ref, ExternalLinkedDocsTable.UnloadColumn("Doc"));
	
	AllFields = New ValueTable();
	AllFields.Columns.Add("FieldName");
	AllFields.Columns.Add("DataPath");
	IsFieldName = True;
	For Each Row In FieldsToLock_ExternalLinkedDocs.RowRefFilter Do
		If IsFieldName Then
			NewRow = AllFields.Add();
			NewRow.FieldName = Row.FieldName;
			IsFieldName = False;
		Else
			NewRow.DataPath = Row.FieldName;
			IsFieldName = True;
		EndIf;
	EndDo;
	If AllFields.Count() Then
		AllFields.Add().FieldName = "RowID";
		AllFields.Add().FieldName = "Basis";
	EndIf;
	
	AllFields.GroupBy("FieldName, DataPath");
	Return AllFields;
EndFunction

Function GetRowRefCache(RowRefObject, FieldsForCheckRowRef)
	CachedObject = New Structure();
	For Each Row In FieldsForCheckRowRef Do
		CachedObject.Insert(TrimAll(Row.FieldName), RowRefObject[TrimAll(Row.FieldName)]);
	EndDo;
	Return CachedObject;
EndFunction

Function IsDifferenceInCachedObjects(CachedObjectBefore, CachedObjectAfter, FieldsForCheck)
	Result = New Structure("Difference, Fields");
	Fields = New Array();
	For Each Row In FieldsForCheck Do
		ValueBefore = CachedObjectBefore[Row.FieldName];
		ValueAfter  = CachedObjectAfter[Row.FieldName];
		
		If Not ValueIsFilled(ValueBefore) Then
			If ValueIsFilled(ValueAfter) Then
				Fields.Add(New Structure("FieldName, DataPath, ValueBefore, ValueAfter", 
					Row.FieldName, Row.DataPath, ValueBefore, ValueAfter));
			EndIf;
		Else // is filled
			If ValueBefore <> ValueAfter Then
				Fields.Add(New Structure("FieldName, DataPath, ValueBefore, ValueAfter", 
					Row.FieldName, Row.DataPath, ValueBefore, ValueAfter));
			EndIf;
		EndIf;
	EndDo;
	Result.Difference = Fields.Count() > 0;
	Result.Fields     = Fields;
	Return Result;
EndFunction

Function GetBalanceQuantity(Source, Row)
	Query = New Query();
	Query.Text =
	"SELECT
	|	TM1010B_RowIDMovements.QuantityBalance
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, RowID = &RowID
	|	AND Step = &Step
	|	AND Basis = &Basis
	|	AND RowRef = &RowRef) AS TM1010B_RowIDMovements";
	Period = Undefined;
	If ValueIsFilled(Source.Ref) Then
		Period = New Boundary(Source.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Period", Period);
	Query.SetParameter("RowID", Row.RowID);
	Query.SetParameter("Step", Row.CurrentStep);
	Query.SetParameter("Basis", Row.Basis);
	Query.SetParameter("RowRef", Row.RowRef);
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

Function ExtractData(BasisesTable, DataReceiver, AddInfo = Undefined) Export

	Tables = CreateTablesForExtractData(BasisesTable.CopyColumns());

	For Each Row In BasisesTable Do
		Is = Is(Row.Basis);
		If Is.SO Then
			FillTablesFrom_SO(Tables, DataReceiver, Row);
		ElsIf Is.SI Then
			FillTablesFrom_SI(Tables, DataReceiver, Row);
		ElsIf Is.SC Then
			FillTablesFrom_SC(Tables, DataReceiver, Row);
		ElsIf Is.PO Then
			FillTablesFrom_PO(Tables, DataReceiver, Row);
		ElsIf Is.PI Then
			FillTablesFrom_PI(Tables, DataReceiver, Row);
		ElsIf Is.GR Then
			FillTablesFrom_GR(Tables, DataReceiver, Row);
		ElsIf Is.ITO Then
			FillTablesFrom_ITO(Tables, DataReceiver, Row);
		ElsIf Is.IT Then
			FillTablesFrom_IT(Tables, DataReceiver, Row);
		ElsIf Is.ISR Then
			FillTablesFrom_ISR(Tables, DataReceiver, Row);
		ElsIf Is.PhysicalInventory Then
			FillTablesFrom_PhysicalInventory(Tables, DataReceiver, Row);
		ElsIf Is.PR Then
			FillTablesFrom_PR(Tables, DataReceiver, Row);
		ElsIf Is.PRO Then
			FillTablesFrom_PRO(Tables, DataReceiver, Row);
		ElsIf Is.SR Then
			FillTablesFrom_SR(Tables, DataReceiver, Row);
		ElsIf Is.SRO Then
			FillTablesFrom_SRO(Tables, DataReceiver, Row);
		ElsIf Is.RSR Then
			FillTablesFrom_RSR(Tables, DataReceiver, Row);
		ElsIf Is.WO Then
			FillTablesFrom_WO(Tables, DataReceiver, Row);
		ElsIf Is.WS Then
			FillTablesFrom_WS(Tables, DataReceiver, Row);
		EndIf;
	EndDo;

	Return ExtractDataByTables(Tables, DataReceiver, AddInfo);
EndFunction

Function CreateTablesForExtractData(EmptyTable)
	Tables = New Structure();
	Tables.Insert("FromSO", EmptyTable.Copy());
	Tables.Insert("FromSI", EmptyTable.Copy());
	Tables.Insert("FromSC", EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromSO", EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromSI", EmptyTable.Copy());
	Tables.Insert("FromSC_ThenFromPIGR_ThenFromSO", EmptyTable.Copy());
	Tables.Insert("FromPO", EmptyTable.Copy());
	Tables.Insert("FromPI", EmptyTable.Copy());
	Tables.Insert("FromGR", EmptyTable.Copy());
	Tables.Insert("FromGR_ThenFromPO", EmptyTable.Copy());
	Tables.Insert("FromGR_ThenFromPI", EmptyTable.Copy());
	Tables.Insert("FromPIGR_ThenFromSO", EmptyTable.Copy());
	Tables.Insert("FromISR", EmptyTable.Copy());
	Tables.Insert("FromITO", EmptyTable.Copy());
	Tables.Insert("FromIT", EmptyTable.Copy());
	Tables.Insert("FromPhysicalInventory", EmptyTable.Copy());
	Tables.Insert("FromPR", EmptyTable.Copy());
	Tables.Insert("FromPRO", EmptyTable.Copy());
	Tables.Insert("FromSR", EmptyTable.Copy());
	Tables.Insert("FromSRO", EmptyTable.Copy());
	Tables.Insert("FromRSR", EmptyTable.Copy());
	Tables.Insert("FromWO", EmptyTable.Copy());
	Tables.Insert("FromWS", EmptyTable.Copy());
	Tables.Insert("FromWS_ThenFromWO", EmptyTable.Copy());
	Tables.Insert("FromWS_ThenFromSO", EmptyTable.Copy());
	Tables.Insert("FromWS_ThenFromWO_ThenFromSO", EmptyTable.Copy());
	
	Return Tables;
EndFunction

Function ExtractDataByTables(Tables, DataReceiver, AddInfo = Undefined)
	ExtractedData = New Array();

	If Tables.FromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSO(Tables.FromSO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSI.Count() Then
		ExtractedData.Add(ExtractData_FromSI(Tables.FromSI, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSC.Count() Then
		ExtractedData.Add(ExtractData_FromSC(Tables.FromSC, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSC_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromSO(Tables.FromSC_ThenFromSO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPIGR_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromPIGR_ThenFromSO(Tables.FromPIGR_ThenFromSO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSC_ThenFromPIGR_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromPIGR_ThenFromSO(Tables.FromSC_ThenFromPIGR_ThenFromSO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSC_ThenFromSI.Count() Then
		ExtractedData.Add(ExtractData_FromSC_ThenFromSI(Tables.FromSC_ThenFromSI, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPO.Count() Then
		ExtractedData.Add(ExtractData_FromPO(Tables.FromPO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPI.Count() Then
		ExtractedData.Add(ExtractData_FromPI(Tables.FromPI, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromGR.Count() Then
		ExtractedData.Add(ExtractData_FromGR(Tables.FromGR, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromGR_ThenFromPO.Count() Then
		ExtractedData.Add(ExtractData_FromGR_ThenFromPO(Tables.FromGR_ThenFromPO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromGR_ThenFromPI.Count() Then
		ExtractedData.Add(ExtractData_FromGR_ThenFromPI(Tables.FromGR_ThenFromPI, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromITO.Count() Then
		ExtractedData.Add(ExtractData_FromITO(Tables.FromITO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromIT.Count() Then
		ExtractedData.Add(ExtractData_FromIT(Tables.FromIT, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromISR.Count() Then
		ExtractedData.Add(ExtractData_FromISR(Tables.FromISR, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPhysicalInventory.Count() Then
		ExtractedData.Add(ExtractData_FromPhysicalInventory(Tables.FromPhysicalInventory, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPR.Count() Then
		ExtractedData.Add(ExtractData_FromPR(Tables.FromPR, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromPRO.Count() Then
		ExtractedData.Add(ExtractData_FromPRO(Tables.FromPRO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSR.Count() Then
		ExtractedData.Add(ExtractData_FromSR(Tables.FromSR, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromSRO.Count() Then
		ExtractedData.Add(ExtractData_FromSRO(Tables.FromSRO, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromRSR.Count() Then
		ExtractedData.Add(ExtractData_FromRSR(Tables.FromRSR, DataReceiver, AddInfo));
	EndIf;

	If Tables.FromWO.Count() Then
		ExtractedData.Add(ExtractData_FromWO(Tables.FromWO, DataReceiver, AddInfo));
	EndIf;
	
	If Tables.FromWS.Count() Then
		ExtractedData.Add(ExtractData_FromWS(Tables.FromWS, DataReceiver, AddInfo));
	EndIf;
	
	If Tables.FromWS_ThenFromWO.Count() Then
		ExtractedData.Add(ExtractData_FromWS_ThenFromWO(Tables.FromWS_ThenFromWO, DataReceiver, AddInfo));
	EndIf;
	
	If Tables.FromWS_ThenFromSO.Count() Then
		ExtractedData.Add(ExtractData_FromWS_ThenFromSO(Tables.FromWS_ThenFromSO, DataReceiver, AddInfo));
	EndIf;
	
	Return ExtractedData;
EndFunction

#Region FillTablesFrom

Procedure FillTablesFrom_SO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SI(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSI.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SC(Tables, DataReceiver, RowBasisesTable)
	BasisesInfo = GetBasisesInfo(RowBasisesTable.Basis, RowBasisesTable.BasisKey, RowBasisesTable.RowID);
	If Is(BasisesInfo.ParentBasis).SO Then

		NewRow = Tables.FromSC_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;

	ElsIf Is(BasisesInfo.ParentBasis).SI Then

		NewRow = Tables.FromSC_ThenFromSI.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;

	ElsIf Is(BasisesInfo.RowRef.Basis).SO And (Is(BasisesInfo.ParentBasis).GR Or Is(BasisesInfo.ParentBasis).PI) Then

		NewRow = Tables.FromSC_ThenFromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;

	Else
		FillPropertyValues(Tables.FromSC.Add(), RowBasisesTable);
	EndIf;
EndProcedure

Procedure FillTablesFrom_PO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PI(Tables, DataReceiver, RowBasisesTable)
	If Is(RowBasisesTable.RowRef.Basis).SO And (Is(DataReceiver).SI Or Is(DataReceiver).SC) Then

		NewRow = Tables.FromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = RowBasisesTable.RowRef.Basis;

	Else
		FillPropertyValues(Tables.FromPI.Add(), RowBasisesTable);
	EndIf;
EndProcedure

Procedure FillTablesFrom_GR(Tables, DataReceiver, RowBasisesTable)
	If Is(RowBasisesTable.RowRef.Basis).SO And (Is(DataReceiver).SI Or Is(DataReceiver).SC) Then

		NewRow = Tables.FromPIGR_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = RowBasisesTable.RowRef.Basis;

	Else
		BasisesInfo = GetBasisesInfo(RowBasisesTable.Basis, RowBasisesTable.BasisKey, RowBasisesTable.RowID);
		If Is(BasisesInfo.ParentBasis).PO Then

			NewRow = Tables.FromGR_ThenFromPO.Add();
			FillPropertyValues(NewRow, RowBasisesTable);
			NewRow.ParentBasis = BasisesInfo.ParentBasis;

		ElsIf Is(BasisesInfo.ParentBasis).PI Then

			NewRow = Tables.FromGR_ThenFromPI.Add();
			FillPropertyValues(NewRow, RowBasisesTable);
			NewRow.ParentBasis = BasisesInfo.ParentBasis;

		Else
			FillPropertyValues(Tables.FromGR.Add(), RowBasisesTable);
		EndIf;
	EndIf;
EndProcedure

Procedure FillTablesFrom_ITO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromITO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_IT(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromIT.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_ISR(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromISR.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PhysicalInventory(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPhysicalInventory.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PR(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPR.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_PRO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromPRO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SR(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSR.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_SRO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromSRO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_RSR(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromRSR.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_WO(Tables, DataReceiver, RowBasisesTable)
	FillPropertyValues(Tables.FromWO.Add(), RowBasisesTable);
EndProcedure

Procedure FillTablesFrom_WS(Tables, DataReceiver, RowBasisesTable)
	BasisesInfo = GetBasisesInfo(RowBasisesTable.Basis, RowBasisesTable.BasisKey, RowBasisesTable.RowID);

	If Is(BasisesInfo.ParentBasis).WO Then
		
		NewRow = Tables.FromWS_ThenFromWO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
	
	ElsIf Is(BasisesInfo.ParentBasis).SO Then
		
		NewRow = Tables.FromWS_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
			
	ElsIf Is(BasisesInfo.RowRef.Basis).SO And Is(BasisesInfo.ParentBasis).WO Then
		
		NewRow = Tables.FromWS_ThenFromWO_ThenFromSO.Add();
		FillPropertyValues(NewRow, RowBasisesTable);
		NewRow.ParentBasis = BasisesInfo.ParentBasis;
		
	Else
		FillPropertyValues(Tables.FromWS.Add(), RowBasisesTable);
	EndIf;
EndProcedure

#EndRegion

#Region ExtractDataFrom

Function GetQueryText_BasisesTable()
	Return 
	"SELECT
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	BasisesTable.Basis,
	|	BasisesTable.ParentBasis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|INTO BasisesTable
	|FROM
	|	&BasisesTable AS BasisesTable
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
	|	BasisesTable.QuantityInBaseUnit AS Quantity
	|FROM
	|	BasisesTable AS BasisesTable
	|;
	|";
EndFunction

Function ExtractData_FromSO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""SalesOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS SalesOrder,
	|	ItemList.Ref AS ShipmentBasis,
	|	ItemList.Ref AS PurchaseBasis,
	|	ItemList.Ref AS Requester,
	|	ItemList.Ref.RetailCustomer AS RetailCustomer,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	Value(Enum.InventoryOrigingTypes.OwnStocks) AS InventoryOrigin,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.Detail AS Detail,
	|	ItemList.Store.UseShipmentConfirmation
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseShipmentConfirmation,
	|	ItemList.Store.UseGoodsReceipt
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.Sales)
	|		then value(Enum.ShipmentConfirmationTransactionTypes.Sales)
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.ShipmentToTradeAgent)
	|		then value(Enum.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent)
	|	end as TransactionType,
	|
	|	ItemList.Ref.TransactionType as TransactionTypeSales,
	|	VALUE(Enum.PurchaseTransactionTypes.Purchase) AS TransactionTypePurchases,
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
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit,
	|	ItemList.SalesPerson
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.SalesOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	LineNumber
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

	QueryPaymentsAmount = New Query();
	QueryPaymentsAmount.Text = 
	"SELECT
	|	SUM(R3026B_SalesOrdersCustomerAdvance.Amount) AS Amount,
	|	VALUE(Catalog.PaymentTypes.EmptyRef) AS PaymentType
	|FROM
	|	AccumulationRegister.R3026B_SalesOrdersCustomerAdvance AS R3026B_SalesOrdersCustomerAdvance
	|WHERE
	|	R3026B_SalesOrdersCustomerAdvance.Order IN (&Orders)
	|	AND (R3026B_SalesOrdersCustomerAdvance.Recorder REFS Document.CashReceipt
	|	OR R3026B_SalesOrdersCustomerAdvance.Recorder REFS Document.BankReceipt)
	|GROUP BY
	|	VALUE(Catalog.PaymentTypes.EmptyRef)
	|HAVING
	|	SUM(R3026B_SalesOrdersCustomerAdvance.Amount) > 0";
	
	QueryPaymentsAmount.SetParameter("Orders", BasisesTable.UnloadColumn("Basis"));
	
	QueryPaymentsType = New Query();
	QueryPaymentsType.Text = 
	"SELECT
	|	MAX(PaymentTypes.Ref) AS PaymentType
	|FROM
	|	Catalog.PaymentTypes AS PaymentTypes
	|WHERE
	|	NOT PaymentTypes.DeletionMark
	|	AND PaymentTypes.Type = VALUE(Enum.PaymentTypes.Advance)";
	PaymentsTypeSelection = QueryPaymentsType.Execute().Select();
	PaymentType = Catalogs.PaymentTypes.EmptyRef();
	If PaymentsTypeSelection.Next() Then
		PaymentType = PaymentsTypeSelection.PaymentType;
	EndIf;
	
	TablePayments = QueryPaymentsAmount.Execute().Unload();
	TablePayments.FillValues(PaymentType, "PaymentType");
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();
	//TablePayments      = QueryResults[5].Unload();

	Tables = New Structure();
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);
	Tables.Insert("Payments"      , TablePayments);

	AddTables(Tables);

	RecalculateAmounts(Tables);
	Result = ReduceExtractedDataInfo_SO(Tables, DataReceiver);
	Return Result;
EndFunction

Function ExtractData_FromSI(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""SalesInvoice"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS SalesInvoice,
	|	ItemList.Ref AS ShipmentBasis,
	|	ItemList.SalesOrder AS SalesOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.LegalNameContract AS LegalNameContract,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Detail AS Detail,
	|	ItemList.Store.UseShipmentConfirmation
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseShipmentConfirmation,
	|	ItemList.Store.UseGoodsReceipt
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.Sales)
	|		then value(Enum.ShipmentConfirmationTransactionTypes.Sales)
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.ShipmentToTradeAgent)
	|		then value(Enum.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent)
	|	end as TransactionType,
	|
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.Sales)
	|		then value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer)
	|		when ItemList.Ref.TransactionType = value(Enum.SalesTransactionTypes.ShipmentToTradeAgent)
	|		then value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent)
	|	end as TransactionTypeSR,
	|
	|	ItemList.Ref.TransactionType as TransactionTypeSales,
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS SalesInvoiceItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit,
	|	ItemList.SalesPerson
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.SalesInvoice.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.SalesInvoice.TaxList AS TaxList
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
	|	Document.SalesInvoice.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.SalesInvoice.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key
	|;
	|
	|///////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.SourceOfOrigin,
	|	SourceOfOrigins.Quantity
	|FROM
	|	Document.SalesInvoice.SourceOfOrigins AS SourceOfOrigins
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SourceOfOrigins.Ref
	|		AND BasisesTable.BasisKey = SourceOfOrigins.Key";


	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo        = QueryResults[1].Unload();
	TableItemList         = QueryResults[2].Unload();
	TableTaxList          = QueryResults[3].Unload();
	TableSpecialOffers    = QueryResults[4].Unload();
	TableSerialLotNumbers = QueryResults[5].Unload();
	TableSourceOfOrigins  = QueryResults[6].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	Tables.Insert("SourceOfOrigins" , TableSourceOfOrigins);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromSC(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""ShipmentConfirmation"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	TRUE AS UseShipmentConfirmation,
	|	case when ItemList.Ref.TransactionType = value(Enum.ShipmentConfirmationTransactionTypes.Sales)
	|			then value(Enum.SalesTransactionTypes.Sales)
	|		when ItemList.Ref.TransactionType = value(Enum.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent)
	|			then value(Enum.SalesTransactionTypes.ShipmentToTradeAgent)
	|	end as TransactionTypeSales,
	|	
	|	case when ItemList.Ref.TransactionType = value(Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor)
	|			then value(Enum.PurchaseReturnTransactionTypes.ReturnToVendor)
	|		when ItemList.Ref.TransactionType = value(Enum.ShipmentConfirmationTransactionTypes.ReturnToConsignor)
	|			then value(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor)
	|	end as TransactionTypePR,
	|
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
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
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS ShipmentConfirmation,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.ShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo             = QueryResults[1].Unload();
	TableItemList              = QueryResults[2].Unload();
	TableShipmentConfirmations = QueryResults[3].Unload();
	TableSerialLotNumbers      = QueryResults[4].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList"              , TableItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	Tables.Insert("SerialLotNumbers"      , TableSerialLotNumbers);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Store, Unit", AddInfo);
EndFunction

Function ExtractData_FromSC_ThenFromSO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.SalesOrder.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
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
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS ShipmentConfirmation,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.ShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesSO = ExtractData_FromSO(QueryResults[2].Unload(), DataReceiver);
	TablesSO.ItemList.FillValues(True, "UseShipmentConfirmation");

	TableRowIDInfo             = QueryResults[1].Unload();
	TableShipmentConfirmations = QueryResults[3].Unload();
	TableSerialLotNumbers      = QueryResults[4].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"              , TablesSO.ItemList);
	Tables.Insert("RowIDInfo"             , TableRowIDInfo);
	Tables.Insert("TaxList"               , TablesSO.TaxList);
	Tables.Insert("SpecialOffers"         , TablesSO.SpecialOffers);
	Tables.Insert("ShipmentConfirmations" , TableShipmentConfirmations);
	Tables.Insert("SerialLotNumbers"      , TableSerialLotNumbers);

	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey", AddInfo);
EndFunction

Function ExtractData_FromSC_ThenFromSI(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.SalesInvoice.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
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
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS ShipmentConfirmation,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.ShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesSI = ExtractData_FromSI(QueryResults[2].Unload(), DataReceiver);
	TablesSI.ItemList.FillValues(True, "UseShipmentConfirmation");

	TableRowIDInfo             = QueryResults[1].Unload();
	TableShipmentConfirmations = QueryResults[3].Unload();
	TableSerialLotNumbers      = QueryResults[4].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList", TablesSI.ItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TablesSI.TaxList);
	Tables.Insert("SpecialOffers", TablesSI.SpecialOffers);
	Tables.Insert("ShipmentConfirmations", TableShipmentConfirmations);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "SalesInvoiceItemListKey", AddInfo);
EndFunction

Function ExtractData_FromSC_ThenFromPIGR_ThenFromSO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	BasisesTable.RowRef.Basis AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
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
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS ShipmentConfirmation,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInShipmentConfirmation
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.ShipmentConfirmation.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.ShipmentConfirmation.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesPIGRSO = ExtractData_FromPIGR_ThenFromSO(QueryResults[2].Unload(), DataReceiver);
	TablesPIGRSO.ItemList.FillValues(True, "UseShipmentConfirmation");

	TableRowIDInfo             = QueryResults[1].Unload();
	TableShipmentConfirmations = QueryResults[3].Unload();
	TableSerialLotNumbers      = QueryResults[4].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList", TablesPIGRSO.ItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TablesPIGRSO.TaxList);
	Tables.Insert("SpecialOffers", TablesPIGRSO.SpecialOffers);
	Tables.Insert("ShipmentConfirmations", TableShipmentConfirmations);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey", AddInfo);
EndFunction

Function ExtractData_FromPIGR_ThenFromSO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	BasisesTable.RowID AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.SalesOrder.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesSO = ExtractData_FromSO(QueryResults[2].Unload(), DataReceiver);

	TableRowIDInfo = QueryResults[1].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TablesSO.ItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TablesSO.TaxList);
	Tables.Insert("SpecialOffers", TablesSO.SpecialOffers);

	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey", AddInfo);
EndFunction

Function ExtractData_FromPO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""PurchaseOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS PurchaseOrder,
	|	ItemList.Ref AS ReceiptBasis,
	|	ItemList.SalesOrder AS SalesOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.ExpenseType AS ExpenseType,
	|	ItemList.Detail AS Detail,
	|	ItemList.Store.UseGoodsReceipt
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
	|
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.Purchase)
	|		then value(Enum.GoodsReceiptTransactionTypes.Purchase)
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|		then value(Enum.GoodsReceiptTransactionTypes.ReceiptFromConsignor)
	|	end as TransactionType,
	|	
	|	ItemList.Ref.TransactionType AS TransactionTypePurchases,
	|
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS PurchaseOrderItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.PurchaseOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	LineNumber
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
	|	Document.PurchaseOrder.TaxList AS TaxList
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
	|	Document.PurchaseOrder.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromPI(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""PurchaseInvoice"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS ReceiptBasis,
	|	ItemList.Ref AS PurchaseInvoice,
	|	ItemList.PurchaseOrder AS PurchaseOrder,
	|	ItemList.SalesOrder AS SalesOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.LegalNameContract AS LegalNameContract,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.ExpenseType AS ExpenseType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Detail AS Detail,
	|	ItemList.Store.UseShipmentConfirmation
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseShipmentConfirmation,
	|	ItemList.Store.UseGoodsReceipt
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
	|
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.Purchase)
	|		then value(Enum.GoodsReceiptTransactionTypes.Purchase)
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|		then value(Enum.GoodsReceiptTransactionTypes.ReceiptFromConsignor)
	|	end as TransactionType,
	|
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.Purchase)
	|		then value(Enum.PurchaseReturnTransactionTypes.ReturnToVendor)
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|		then value(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor)
	|	end as TransactionTypePR,
	|
	|	ItemList.Ref.TransactionType as TransactionTypePurchases,
	|
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS PurchaseInvoiceItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.PurchaseInvoice.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.PurchaseInvoice.TaxList AS TaxList
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
	|	Document.PurchaseInvoice.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.PurchaseInvoice.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.SourceOfOrigin,
	|	SourceOfOrigins.Quantity
	|FROM
	|	Document.PurchaseInvoice.SourceOfOrigins AS SourceOfOrigins
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SourceOfOrigins.Ref
	|		AND BasisesTable.BasisKey = SourceOfOrigins.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo        = QueryResults[1].Unload();
	TableItemList         = QueryResults[2].Unload();
	TableTaxList          = QueryResults[3].Unload();
	TableSpecialOffers    = QueryResults[4].Unload();
	TableSerialLotNumbers = QueryResults[5].Unload();
	TableSourceOfOrigins  = QueryResults[6].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	Tables.Insert("SourceOfOrigins" , TableSourceOfOrigins);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromGR(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""GoodsReceipt"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	TRUE AS UseGoodsReceipt,
	|	case when ItemList.Ref.TransactionType = value(Enum.GoodsReceiptTransactionTypes.Purchase)
	|			then value(Enum.PurchaseTransactionTypes.Purchase)
	|		when ItemList.Ref.TransactionType = value(Enum.GoodsReceiptTransactionTypes.ReceiptFromConsignor)
	|			then value(Enum.PurchaseTransactionTypes.ReceiptFromConsignor)
	|	end as TransactionTypePurchases,
	|	
	|	case when ItemList.Ref.TransactionType = value(Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer)
	|			then value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer)
	|		when ItemList.Ref.TransactionType = value(Enum.GoodsReceiptTransactionTypes.ReturnFromTradeAgent)
	|			then value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent)
	|	end as TransactionTypeSR,
	|
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|ORDER BY
	|	ItemList.LineNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS GoodsReceipt,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.GoodsReceipt.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableGoodsReceipts = QueryResults[3].Unload();
	TableSerialLotNumbers = QueryResults[4].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("GoodsReceipts", TableGoodsReceipts);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Store, Unit", AddInfo);
EndFunction

Function ExtractData_FromGR_ThenFromPO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.PurchaseOrder.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON BasisesTable.Basis = RowIDInfo.Ref
	|		AND BasisesTable.BasisKey = RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS GoodsReceipt,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.GoodsReceipt.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";
							  

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesPO = ExtractData_FromPO(QueryResults[2].Unload(), DataReceiver);
	TablesPO.ItemList.FillValues(True, "UseGoodsReceipt");

	TableRowIDInfo     = QueryResults[1].Unload();
	TableGoodsReceipts = QueryResults[3].Unload();
	TableSerialLotNumbers = QueryResults[4].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList", TablesPO.ItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TablesPO.TaxList);
	Tables.Insert("SpecialOffers", TablesPO.SpecialOffers);
	Tables.Insert("GoodsReceipts", TableGoodsReceipts);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);

	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "PurchaseOrderItemListKey", AddInfo);
EndFunction

Function ExtractData_FromGR_ThenFromPI(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.PurchaseInvoice.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
	|		ON BasisesTable.Basis = RowIDInfo.Ref
	|		AND BasisesTable.BasisKey = RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS GoodsReceipt,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInGoodsReceipt
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.GoodsReceipt.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.GoodsReceipt.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";
							  

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesPI = ExtractData_FromPI(QueryResults[2].Unload(), DataReceiver);
	TablesPI.ItemList.FillValues(True, "UseGoodsReceipt");

	TableRowIDInfo     = QueryResults[1].Unload();
	TableGoodsReceipts = QueryResults[3].Unload();
	TableSerialLotNumbers = QueryResults[4].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList", TablesPI.ItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TablesPI.TaxList);
	Tables.Insert("SpecialOffers", TablesPI.SpecialOffers);
	Tables.Insert("GoodsReceipts", TableGoodsReceipts);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "PurchaseInvoiceItemListKey", AddInfo);
EndFunction

Function ExtractData_FromITO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""InventoryTransferOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS InventoryTransferOrder,
	|	ItemList.InternalSupplyRequest AS InternalSupplyRequest,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.StoreSender AS StoreSender,
	|	ItemList.Ref.StoreReceiver AS StoreReceiver,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	Value(Enum.InventoryOrigingTypes.OwnStocks) AS InventoryOrigin,
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.InventoryTransferOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber";
							  
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo = QueryResults[1].Unload();
	TableItemList  = QueryResults[2].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	
	AddTables(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromIT(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""InventoryTransfer"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS InventoryTransfer,
	|	ItemList.InventoryTransferOrder AS InventoryTransferOrder,
	|	ItemList.ProductionPlanning AS ProductionPlanning,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref AS ShipmentBasis,
	|	ItemList.Ref AS ReceiptBasis,
	|	ItemList.Ref.%1 AS Store,
	|	%2 AS TransactionType,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.InventoryTransfer.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|ORDER BY
	|	ItemList.LineNumber
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.InventoryTransfer.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key";

	StoreName = "UNDEFINED";
	TransactionType = "UNDEFINED";
	If Is(DataReceiver).SC Then
		StoreName = "StoreSender";
		TransactionType = "VALUE(Enum.ShipmentConfirmationTransactionTypes.InventoryTransfer)";
	ElsIf Is(DataReceiver).GR Then
		StoreName = "StoreReceiver";
		TransactionType = "VALUE(Enum.GoodsReceiptTransactionTypes.InventoryTransfer)";
	EndIf;
	Query.Text = StrTemplate(Query.Text, StoreName, TransactionType);

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo  = QueryResults[1].Unload();
	TableItemList   = QueryResults[2].Unload();
	TableSerialLotNumbers = QueryResults[3].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);
	
	AddTables(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromISR(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""InternalSupplyRequest"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS InternalSupplyRequest,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.Store AS Store,
	|	ItemList.Ref.Store AS StoreReceiver,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	VALUE(Enum.PurchaseTransactionTypes.Purchase) AS TransactionTypePurchases,
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.InternalSupplyRequest.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();

	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);

	AddTables(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromPhysicalInventory(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""PhysicalInventory"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS PhysicalInventory,
	|	ItemList.Ref AS BasisDocument,
	|	ItemList.Ref.Store AS Store,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.PhysicalInventory.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	ItemList.SerialLotNumber,
	|	case when ItemList.Difference < 0 Then -ItemList.Difference 
	|	else ItemList.Difference end AS Quantity
	|FROM
	|	Document.PhysicalInventory.ItemList AS ItemList
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|WHERE
	|	NOT ItemList.SerialLotNumber.Ref IS NULL";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo        = QueryResults[1].Unload();
	TableItemList         = QueryResults[2].Unload();
	TableSerialLotNumbers = QueryResults[3].Unload();

	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList"        , TableItemList);
	Tables.Insert("RowIDInfo"       , TableRowIDInfo);
	Tables.Insert("SerialLotNumbers", TableSerialLotNumbers);

	AddTables(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromPR(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""PurchaseReturn"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS PurchaseReturn,
	|	ItemList.Ref AS ShipmentBasis,
	|	ItemList.PurchaseInvoice AS PurchaseInvoice,
	|	ItemList.PurchaseReturnOrder AS PurchaseReturnOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.ExpenseType AS ExpenseType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.ReturnReason AS ReturnReason,
	|	ItemList.Store.UseShipmentConfirmation
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseShipmentConfirmation,
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseReturnTransactionTypes.ReturnToVendor)
	|			then value(Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor)
	|		when ItemList.Ref.TransactionType = value(Enum.PurchaseReturnTransactionTypes.ReturnToConsignor)
	|			then value(Enum.ShipmentConfirmationTransactionTypes.ReturnToConsignor)
	|	end as TransactionType,
	|
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS PurchaseReturnItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.PurchaseReturn.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.PurchaseReturn.TaxList AS TaxList
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
	|	0 AS Percent
	|FROM
	|	Document.PurchaseReturn.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromPRO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""PurchaseReturnOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS PurchaseReturnOrder,
	|	ItemList.PurchaseInvoice AS PurchaseInvoice,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.ExpenseType AS ExpenseType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Ref.TransactionType AS TransactionTypePR,
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS PurchaseReturnOrderItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.PurchaseReturnOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.PurchaseReturnOrder.TaxList AS TaxList
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
	|	0 AS Percent
	|FROM
	|	Document.PurchaseReturnOrder.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromSR(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""SalesReturn"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS SalesReturn,
	|	ItemList.Ref AS ReceiptBasis,
	|	ItemList.SalesInvoice AS SalesInvoice,
	|	ItemList.SalesReturnOrder AS SalesReturnOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Store.UseGoodsReceipt
	|	AND NOT ItemList.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS UseGoodsReceipt,
	|	case 
	|		when ItemList.Ref.TransactionType = value(Enum.SalesReturnTransactionTypes.ReturnFromCustomer)
	|			then value(Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer)
	|		when ItemList.Ref.TransactionType = value(Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent)
	|			then value(Enum.GoodsReceiptTransactionTypes.ReturnFromTradeAgent)
	|	end as TransactionType,
	|
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS SalesReturntemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit,
	|	ItemList.SalesPerson
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.SalesReturn.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.SalesReturn.TaxList AS TaxList
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
	|	0 AS Percent
	|FROM
	|	Document.SalesReturn.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromSRO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""SalesReturnOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS SalesReturnOrder,
	|	ItemList.SalesInvoice AS SalesInvoice,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Ref.TransactionType AS TransactionTypeSR,
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS SalesReturnOrderItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit,
	|	ItemList.SalesPerson
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.SalesReturnOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.SalesReturnOrder.TaxList AS TaxList
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
	|	0 AS Percent
	|FROM
	|	Document.SalesReturnOrder.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo     = QueryResults[1].Unload();
	TableItemList      = QueryResults[2].Unload();
	TableTaxList       = QueryResults[3].Unload();
	TableSpecialOffers = QueryResults[4].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList", TableItemList);
	Tables.Insert("RowIDInfo", TableRowIDInfo);
	Tables.Insert("TaxList", TableTaxList);
	Tables.Insert("SpecialOffers", TableSpecialOffers);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromRSR(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""SalesInvoice"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS RetailSalesReceipt,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.LegalNameContract AS LegalNameContract,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.ManagerSegment AS ManagerSegment,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.Store AS Store,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.AdditionalAnalytic AS AdditionalAnalytic,
	|	ItemList.Detail AS Detail,
	|	ItemList.Ref.RetailCustomer AS RetailCustomer,
	|	ItemList.Ref.UsePartnerTransactions AS UsePartnerTransactions,
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS RetailSalesReceiptItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit,
	|	ItemList.SalesPerson
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.RetailSalesReceipt.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.RetailSalesReceipt.TaxList AS TaxList
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
	|	Document.RetailSalesReceipt.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SerialLotNumbers.SerialLotNumber,
	|	SerialLotNumbers.Quantity
	|FROM
	|	Document.RetailSalesReceipt.SerialLotNumbers AS SerialLotNumbers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SerialLotNumbers.Ref
	|		AND BasisesTable.BasisKey = SerialLotNumbers.Key
	|;
	|///////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	Payments.PaymentType,
	|	Payments.PaymentTerminal,
	|	Payments.Account,
	|	Payments.Amount,
	|	Payments.Percent,
	|	Payments.Commission,
	|	Payments.BankTerm,
	|	Payments.Key,
	|	CAST("""" AS String(30)) AS RRNCode,
	|	CAST("""" AS String(1024)) AS PaymentInfo
	|FROM
	|	Document.RetailSalesReceipt.Payments AS Payments
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = Payments.Ref
	|GROUP BY
	|	Payments.Key,
	|	Payments.Account,
	|	Payments.Amount,
	|	Payments.BankTerm,
	|	Payments.Commission,
	|	Payments.PaymentTerminal,
	|	Payments.PaymentType,
	|	Payments.Percent
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	SourceOfOrigins.SerialLotNumber,
	|	SourceOfOrigins.SourceOfOrigin,
	|	SourceOfOrigins.Quantity
	|FROM
	|	Document.RetailSalesReceipt.SourceOfOrigins AS SourceOfOrigins
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SourceOfOrigins.Ref
	|		AND BasisesTable.BasisKey = SourceOfOrigins.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo        = QueryResults[1].Unload();
	TableItemList         = QueryResults[2].Unload();
	TableTaxList          = QueryResults[3].Unload();
	TableSpecialOffers    = QueryResults[4].Unload();
	TableSerialLotNumbers = QueryResults[5].Unload();
	TablePayments         = QueryResults[6].Unload();
	TableSourceOfOrigins  = QueryResults[7].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList"         , TableItemList);
	Tables.Insert("RowIDInfo"        , TableRowIDInfo);
	Tables.Insert("TaxList"          , TableTaxList);
	Tables.Insert("SpecialOffers"    , TableSpecialOffers);
	Tables.Insert("SerialLotNumbers" , TableSerialLotNumbers);
	Tables.Insert("Payments"         , TablePayments);
	Tables.Insert("SourceOfOrigins"  , TableSourceOfOrigins);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromWO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""WorkOrder"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref AS WorkOrder,
	|	ItemList.SalesOrder AS SalesOrder,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.Ref.PriceIncludeTax AS PriceIncludeTax,
	|	ItemList.Ref.Agreement AS Agreement,
	|	ItemList.Ref.Currency AS Currency,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.BillOfMaterials,
	|	VALUE(Enum.SalesTransactionTypes.Sales) AS TransactionTypeSales,
	|	0 AS Quantity,
	|	ISNULL(ItemList.QuantityInBaseUnit, 0) AS OriginalQuantity,
	|	ISNULL(ItemList.Price, 0) AS Price,
	|	ISNULL(ItemList.TaxAmount, 0) AS TaxAmount,
	|	ISNULL(ItemList.TotalAmount, 0) AS TotalAmount,
	|	ISNULL(ItemList.NetAmount, 0) AS NetAmount,
	|	ISNULL(ItemList.OffersAmount, 0) AS OffersAmount,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS WorkOrderItemListKey,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkOrder.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|
	|ORDER BY
	|	ItemList.LineNumber
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
	|	Document.WorkOrder.TaxList AS TaxList
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
	|	Document.WorkOrder.SpecialOffers AS SpecialOffers
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = SpecialOffers.Ref
	|		AND BasisesTable.BasisKey = SpecialOffers.Key
	|;
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	BasisesTable.Key,
	|	Materials.UniqueID,
	|	Materials.BillOfMaterials,
	|	Materials.Item,
	|	Materials.ItemKey,
	|	Materials.Unit,
	|	Materials.Item AS ItemBOM,
	|	Materials.ItemKey AS ItemKeyBOM,
	|	Materials.Unit AS UnitBOM,
	|	Materials.Store,
	|	Materials.Quantity,
	|	Materials.Quantity AS QuantityBOM,
	|	Materials.CostWriteOff
	|FROM
	|	Document.WorkOrder.Materials AS Materials
	|		INNER JOIN BasisesTable AS BasisesTable
	|		ON BasisesTable.Basis = Materials.Ref
	|		AND BasisesTable.BasisKey = Materials.KeyOwner
	|";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo        = QueryResults[1].Unload();
	TableItemList         = QueryResults[2].Unload();
	TableTaxList          = QueryResults[3].Unload();
	TableSpecialOffers    = QueryResults[4].Unload();
	Materials             = QueryResults[5].Unload();

	Tables = New Structure();
	Tables.Insert("ItemList"      , TableItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TableTaxList);
	Tables.Insert("SpecialOffers" , TableSpecialOffers);
	Tables.Insert("Materials"     , Materials);

	AddTables(Tables);

	RecalculateAmounts(Tables);

	Return Tables;
EndFunction

Function ExtractData_FromWS(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT ALLOWED
	|	""WorkSheet"" AS BasedOn,
	|	UNDEFINED AS Ref,
	|	ItemList.Ref.Company AS Company,
	|	ItemList.Ref.Branch AS Branch,
	|	ItemList.Ref.Partner AS Partner,
	|	ItemList.Ref.LegalName AS LegalName,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	TRUE AS UseWorkSheet,
	|	VALUE(Enum.SalesTransactionTypes.Sales) AS TransactionTypeSales,
	|	0 AS Quantity,
	|	BasisesTable.Key,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.BasisUnit AS BasisUnit,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key
	|ORDER BY
	|	ItemList.LineNumber
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS WorkSheet,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInWorkSheet
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TableRowIDInfo             = QueryResults[1].Unload();
	TableItemList              = QueryResults[2].Unload();
	TableWorkSheets            = QueryResults[3].Unload();
	
	For Each RowItemList In TableItemList Do
		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit, RowItemList.QuantityInBaseUnit);
	EndDo;

	Tables = New Structure();
	Tables.Insert("ItemList"   , TableItemList);
	Tables.Insert("RowIDInfo"  , TableRowIDInfo);
	Tables.Insert("WorkSheets" , TableWorkSheets);
	
	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "Item, ItemKey, Unit", AddInfo);
EndFunction

Function ExtractData_FromWS_ThenFromWO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.WorkOrder.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.RowIDInfo AS RowIDInfo
	|		ON BasisesTable.Basis = RowIDInfo.Ref
	|		AND BasisesTable.BasisKey = RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS WorkSheet,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInWorkSheet
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key";
	
	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesWO = ExtractData_FromWO(QueryResults[2].Unload(), DataReceiver);

	TableRowIDInfo   = QueryResults[1].Unload();
	TableWorkSheets  = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , TablesWO.ItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TablesWO.TaxList);
	Tables.Insert("SpecialOffers" , TablesWO.SpecialOffers);
	Tables.Insert("WorkSheets"    , TableWorkSheets);

	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "WorkOrderItemListKey", AddInfo);
EndFunction

Function ExtractData_FromWS_ThenFromSO(BasisesTable, DataReceiver, AddInfo = Undefined)
	Query = New Query(GetQueryText_BasisesTable());
	Query.Text = Query.Text + 
	//------------------------------------------------------------
	"SELECT DISTINCT ALLOWED
	|	BasisesTable.Key,
	|	RowIDInfo.BasisKey AS BasisKey,
	|	BasisesTable.RowID,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.RowRef,
	|	VALUE(Document.SalesOrder.EmptyRef) AS ParentBasis,
	|	BasisesTable.ParentBasis AS Basis,
	|	BasisesTable.Unit,
	|	BasisesTable.BasisUnit,
	|	BasisesTable.QuantityInBaseUnit
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.RowIDInfo AS RowIDInfo
	|		ON BasisesTable.Basis = RowIDInfo.Ref
	|		AND BasisesTable.BasisKey = RowIDInfo.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	UNDEFINED AS Ref,
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	BasisesTable.Unit AS Unit,
	|	BasisesTable.Key,
	|	BasisesTable.BasisKey,
	|	BasisesTable.Basis AS WorkSheet,
	|	BasisesTable.QuantityInBaseUnit AS Quantity,
	|	BasisesTable.QuantityInBaseUnit AS QuantityInWorkSheet
	|FROM
	|	BasisesTable AS BasisesTable
	|		LEFT JOIN Document.WorkSheet.ItemList AS ItemList
	|		ON BasisesTable.Basis = ItemList.Ref
	|		AND BasisesTable.BasisKey = ItemList.Key";

	Query.SetParameter("BasisesTable", BasisesTable);
	QueryResults = Query.ExecuteBatch();

	TablesSO = ExtractData_FromSO(QueryResults[2].Unload(), DataReceiver);

	TableRowIDInfo   = QueryResults[1].Unload();
	TableWorkSheets  = QueryResults[3].Unload();
	
	Tables = New Structure();
	Tables.Insert("ItemList"      , TablesSO.ItemList);
	Tables.Insert("RowIDInfo"     , TableRowIDInfo);
	Tables.Insert("TaxList"       , TablesSO.TaxList);
	Tables.Insert("SpecialOffers" , TablesSO.SpecialOffers);
	Tables.Insert("WorkSheets"    , TableWorkSheets);

	AddTables(Tables);

	Return CollapseRepeatingItemListRows(Tables, "SalesOrderItemListKey", AddInfo);
EndFunction

#EndRegion

Procedure AddTables(Tables)
	If Tables.Property("ItemList") Then
		Tables.ItemList = AddColumnsToItemList(Tables.ItemList);
	Else
		Tables.Insert("ItemList", GetEmptyTable_ItemList());
	EndIf;

	If Not Tables.Property("TaxList") Then
		Tables.Insert("TaxList", GetEmptyTable_TaxList());
	EndIf;

	If Not Tables.Property("SpecialOffers") Then
		Tables.Insert("SpecialOffers", GetEmptyTable_SpecialOffers());
	EndIf;

	If Not Tables.Property("ShipmentConfirmations") Then
		Tables.Insert("ShipmentConfirmations", GetEmptyTable_ShipmentConfirmations());
	EndIf;

	If Not Tables.Property("GoodsReceipts") Then
		Tables.Insert("GoodsReceipts", GetEmptyTable_GoodsReceipts());
	EndIf;
	
	If Not Tables.Property("WorkSheets") Then
		Tables.Insert("WorkSheets", GetEmptyTable_WorkSheets());
	EndIf;
	
	If Not Tables.Property("SerialLotNumbers") Then
		Tables.Insert("SerialLotNumbers", GetEmptyTable_SerialLotNumbers());
	EndIf;

	If Not Tables.Property("Payments") Then
		Tables.Insert("Payments", GetEmptyTable_Payments());
	EndIf;
	
	If Not Tables.Property("SourceOfOrigins") Then
		Tables.Insert("SourceOfOrigins", GetEmptyTable_SourceOfOrigins());
	EndIf;
EndProcedure

Function AddColumnsToItemList(TableItemList)
	EmptyTableItemList = GetEmptyTable_ItemList();
	For Each Column In EmptyTableItemList.Columns Do
		If TableItemList.Columns.Find(Column.Name) = Undefined Then
			TableItemList.Columns.Add(Column.Name);
		EndIf;
	EndDo;
	Return TableItemList;
EndFunction

Procedure RecalculateAmounts(Tables)
	For Each RowItemList In Tables.ItemList Do

		RowItemList.Quantity = Catalogs.Units.Convert(RowItemList.BasisUnit, RowItemList.Unit,
			RowItemList.QuantityInBaseUnit);
		
		// ItemList
		If RowItemList.OriginalQuantity = 0 Then
			RowItemList.TaxAmount    = 0;
			RowItemList.NetAmount    = 0;
			RowItemList.TotalAmount  = 0;
			RowItemList.OffersAmount = 0;
		ElsIf RowItemList.OriginalQuantity <> RowItemList.QuantityInBaseUnit Then
			RowItemList.TaxAmount    = RowItemList.TaxAmount / RowItemList.OriginalQuantity
				* RowItemList.QuantityInBaseUnit;
			RowItemList.NetAmount    = RowItemList.NetAmount / RowItemList.OriginalQuantity
				* RowItemList.QuantityInBaseUnit;
			RowItemList.TotalAmount  = RowItemList.TotalAmount / RowItemList.OriginalQuantity
				* RowItemList.QuantityInBaseUnit;
			RowItemList.OffersAmount = RowItemList.OffersAmount / RowItemList.OriginalQuantity
				* RowItemList.QuantityInBaseUnit;
		EndIf;

		Filter = New Structure("Ref, Key", RowItemList.Ref, RowItemList.Key);
		
		// TaxList
		If Tables.Property("TaxList") Then
			For Each RowTaxList In Tables.TaxList.FindRows(Filter) Do
				If RowItemList.OriginalQuantity = 0 Then
					RowTaxList.Amount       = 0;
					RowTaxList.ManualAmount = 0;
				Else
					RowTaxList.Amount       = RowTaxList.Amount / RowItemList.OriginalQuantity
						* RowItemList.QuantityInBaseUnit;
					RowTaxList.ManualAmount = RowTaxList.ManualAmount / RowItemList.OriginalQuantity
						* RowItemList.QuantityInBaseUnit;
				EndIf;
			EndDo;
		EndIf;
		
		// SpecialOffers
		If Tables.Property("SpecialOffers") Then
			For Each RowSpecialOffers In Tables.SpecialOffers.FindRows(Filter) Do
				If RowItemList.OriginalQuantity = 0 Then
					RowSpecialOffers.Amount = 0;
				Else
					RowSpecialOffers.Amount = RowSpecialOffers.Amount / RowItemList.OriginalQuantity
						* RowItemList.QuantityInBaseUnit;
				EndIf;
			EndDo;
		EndIf;
	EndDo;
EndProcedure

Function CollapseRepeatingItemListRows(Tables, UniqueColumnNames, AddInfo = Undefined)
	IsLinkRows = CommonFunctionsClientServer.GetFromAddInfo(AddInfo, "IsLinkRows");
	If IsLinkRows <> Undefined And IsLinkRows Then
		UniqueColumnNames = UniqueColumnNames + ", Key";
	EndIf;
	ColumnNamesSum_ItemList = GetColumnNamesSum_ItemList();
	ItemListGrouped = Tables.ItemList.Copy();
	ItemListGrouped.GroupBy(UniqueColumnNames, ColumnNamesSum_ItemList);
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
				NewRow = ItemListResult.Add();
				FillPropertyValues(NewRow, ArrayOfItemListRows[0]);
				FillPropertyValues(NewRow, RowGrouped, ColumnNamesSum_ItemList);
				Continue;
			EndIf;
		EndIf;

		NewKey = String(New UUID());

		For Each ItemOfArray In ArrayOfItemListRows Do
			Filter = New Structure("Key", ItemOfArray.Key);

			For Each Row In Tables.RowIDInfo.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;

			For Each Row In Tables.TaxList.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;

			For Each Row In Tables.SpecialOffers.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;

			For Each Row In Tables.ShipmentConfirmations.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;

			For Each Row In Tables.GoodsReceipts.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
			
			For Each Row In Tables.WorkSheets.FindRows(Filter) Do
				Row.Key = NewKey;
			EndDo;
		EndDo;

		NewRow = ItemListResult.Add();
		FillPropertyValues(NewRow, ArrayOfItemListRows[0]);
		FillPropertyValues(NewRow, RowGrouped, ColumnNamesSum_ItemList);
		NewRow.Key = NewKey;
	EndDo;

	Tables.TaxList.GroupBy(GetColumnNames_TaxList()                             , GetColumnNamesSum_TaxList());
	Tables.SpecialOffers.GroupBy(GetColumnNames_SpecialOffers()                 , GetColumnNamesSum_SpecialOffers());
	Tables.ShipmentConfirmations.GroupBy(GetColumnNames_ShipmentConfirmations() , GetColumnNamesSum_ShipmentConfirmations());
	Tables.GoodsReceipts.GroupBy(GetColumnNames_GoodsReceipts()                 , GetColumnNamesSum_GoodsReceipts());
	Tables.WorkSheets.GroupBy(GetColumnNames_WorkSheets()                       , GetColumnNamesSum_WorkSheets());

	Tables.ItemList = ItemListResult;
	Return Tables;
EndFunction

Function ReduceExtractedDataInfo(Tables, ReduceInfo)
	If Not ReduceInfo.Reduce Then
		Return Tables;
	EndIf;

	For Each KeyValue In Tables Do
		TableName = KeyValue.Key;

		If Upper(TableName) = Upper("RowIDInfo") Then
			Continue;
		EndIf;

		If Not ReduceInfo.Tables.Property(TableName) Then
			Tables[TableName].Clear();
		Else
			ColumnNames = New Array();
			For Each ColumnName In StrSplit(ReduceInfo.Tables[TableName], ",") Do
				ColumnNames.Add(TrimAll(ColumnName));
			EndDo;

			For Each Column In Tables[TableName].Columns Do
				If ColumnNames.Find(Column.Name) = Undefined Then
					Tables[TableName].FillValues(Undefined, Column.Name);
				EndIf;
			EndDo;
		EndIf;

	EndDo;
	Return Tables;
EndFunction

Function ReduceExtractedDataInfo_SO(Tables, DataReceiver)
	ReduceInfo = New Structure("Reduce, Tables", False, New Structure());
	
	Is = Is(DataReceiver);
	// only when procurecement method Pyrchase
	If Is.PO Or Is.PI Then
		ReduceInfo.Tables.Insert("ItemList", "Key, BasedOn, Company, TransactionTypePurchases, Store, UseGoodsReceipt, PurchaseBasis, SalesOrder, 
											 |Item, ItemKey, Unit, BasisUnit, Quantity, QuantityInBaseUnit");
	
	EndIf;

	Return ReduceExtractedDataInfo(Tables, ReduceInfo);
EndFunction

#EndRegion

#Region GetBasises

Function GetBasises(Ref, FilterValues) Export
	Is = Is(Ref);
	If Is.SI Then
		Return GetBasisesFor_SI(FilterValues);
	ElsIf Is.SC Then
		Return GetBasisesFor_SC(FilterValues);
	ElsIf Is.PO Then
		Return GetBasisesFor_PO(FilterValues);
	ElsIf Is.PI Then
		Return GetBasisesFor_PI(FilterValues);
	ElsIf Is.GR Then
		Return GetBasisesFor_GR(FilterValues);
	ElsIf Is.IT Then
		Return GetBasisesFor_IT(FilterValues);
	ElsIf Is.ITO Then
		Return GetBasisesFor_ITO(FilterValues);
	ElsIf Is.StockAdjustmentAsSurplus Then
		Return GetBasisesFor_StockAdjustmentAsSurplus(FilterValues);
	ElsIf Is.StockAdjustmentAsWriteOff Then
		Return GetBasisesFor_StockAdjustmentAsWriteOff(FilterValues);
	ElsIf Is.PR Then
		Return GetBasisesFor_PR(FilterValues);
	ElsIf Is.PRO Then
		Return GetBasisesFor_PRO(FilterValues);
	ElsIf Is.SR Then
		Return GetBasisesFor_SR(FilterValues);
	ElsIf Is.SRO Then
		Return GetBasisesFor_SRO(FilterValues);
	ElsIf Is.RRR Then
		Return GetBasisesFor_RRR(FilterValues);
	ElsIf Is.RSR Then
		Return GetBasisesFor_RSR(FilterValues);
	ElsIf Is.PRR Then
		Return GetBasisesFor_PRR(FilterValues);
	ElsIf Is.WO Then
		Return GetBasisesFor_WO(FilterValues);
	ElsIf Is.WS Then
		Return GetBasisesFor_WS(FilterValues);
	EndIf;
EndFunction

#Region GetBasisesFor

Function GetBasisesFor_SI(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SI);
	StepArray.Add(Catalogs.MovementRules.SI_SC);
	StepArray.Add(Catalogs.MovementRules.SI_WO_WS);
	StepArray.Add(Catalogs.MovementRules.SI_WS);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForSI = True;
	FilterSets.SC_ForSI = True;

	FilterSets.GR_ForSI_ForSC = True;
	FilterSets.PI_ForSI_ForSC = True;
	
	FilterSets.WO_ForSI = True;
	FilterSets.WS_ForSI = True;
	
	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_SC(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SC);
	StepArray.Add(Catalogs.MovementRules.SI_SC);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForSC = True;
	FilterSets.SI_ForSC = True;

	FilterSets.GR_ForSI_ForSC = True;
	FilterSets.PI_ForSI_ForSC = True;

	FilterSets.IT_ForSC = True;
	FilterSets.PR_ForSC = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PO(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.PO_PI);
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForPO_ForPI = True;
	FilterSets.ISR_ForITO_ForPO_ForPI = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PI(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.PI);
	StepArray.Add(Catalogs.MovementRules.PI_GR);
	StepArray.Add(Catalogs.MovementRules.PO_PI);
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);

	FilterSets = GetAvailableFilterSets();
	FilterSets.PO_ForPI = True;
	FilterSets.GR_ForPI = True;
	FilterSets.SO_ForPO_ForPI = True;
	FilterSets.ISR_ForITO_ForPO_ForPI = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_GR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.GR);
	StepArray.Add(Catalogs.MovementRules.PI_GR);

	FilterSets = GetAvailableFilterSets();
	FilterSets.PO_ForGR = True;
	FilterSets.PI_ForGR = True;

	FilterSets.IT_ForGR = True;
	FilterSets.SR_ForGR = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_IT(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.IT);

	FilterSets = GetAvailableFilterSets();
	FilterSets.ITO_ForIT = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_ITO(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.ITO_PO_PI);

	FilterSets = GetAvailableFilterSets();
	FilterSets.ISR_ForITO_ForPO_ForPI = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_StockAdjustmentAsSurplus(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.StockAdjustmentAsSurplus);

	FilterSets = GetAvailableFilterSets();
	FilterSets.PhysicalInventory_ForSurplus_ForWriteOff = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_StockAdjustmentAsWriteOff(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.StockAdjustmentAsWriteOff);

	FilterSets = GetAvailableFilterSets();
	FilterSets.PhysicalInventory_ForSurplus_ForWriteOff = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.PR);
	StepArray.Add(Catalogs.MovementRules.PRO_PR);
	FilterSets = GetAvailableFilterSets();
	FilterSets.SC_ForPR = True;
	FilterSets.PRO_ForPR = True;
	FilterSets.PI_ForPR_ForPRO = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PRO(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.PRO);
	StepArray.Add(Catalogs.MovementRules.PRO_PR);
	FilterSets = GetAvailableFilterSets();
	FilterSets.PI_ForPR_ForPRO = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_SR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SR);
	StepArray.Add(Catalogs.MovementRules.SRO_SR);

	FilterSets = GetAvailableFilterSets();
	FilterSets.GR_ForSR = True;
	FilterSets.SRO_ForSR = True;
	FilterSets.SI_ForSR_ForSRO = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_SRO(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SRO);
	StepArray.Add(Catalogs.MovementRules.SRO_SR);
	FilterSets = GetAvailableFilterSets();
	FilterSets.SI_ForSR_ForSRO = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_RRR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.RRR);

	FilterSets = GetAvailableFilterSets();
	FilterSets.RSR_ForRRR = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_RSR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.RSR);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForRSR = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_PRR(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.PRR);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForPRR = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_WO(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SI_WO_WS);

	FilterSets = GetAvailableFilterSets();
	FilterSets.SO_ForWO = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

Function GetBasisesFor_WS(FilterValues)
	StepArray = New Array();
	StepArray.Add(Catalogs.MovementRules.SI_WO_WS);
	StepArray.Add(Catalogs.MovementRules.SI_WS);
	StepArray.Add(Catalogs.MovementRules.WS);

	FilterSets = GetAvailableFilterSets();
	FilterSets.WO_ForWS = True;
	FilterSets.SO_ForWS = True;
	FilterSets.SI_ForWS = True;

	Return GetBasisesTable(StepArray, FilterValues, FilterSets);
EndFunction

#EndRegion

#Region FilterSets

Function GetAvailableFilterSets()
	Result = New Structure();
	Result.Insert("SO_ForSI", False);
	Result.Insert("SO_ForSC", False);
	Result.Insert("SO_ForPO_ForPI", False);
	Result.Insert("SO_ForPRR", False);
	Result.Insert("SO_ForRSR", False);

	Result.Insert("SC_ForSI", False);
	Result.Insert("SI_ForSC", False);

	Result.Insert("PO_ForPI", False);
	Result.Insert("PO_ForGR", False);

	Result.Insert("GR_ForPI", False);
	Result.Insert("PI_ForGR", False);

	Result.Insert("GR_ForSI_ForSC", False);
	Result.Insert("PI_ForSI_ForSC", False);

	Result.Insert("ITO_ForIT", False);
	Result.Insert("IT_ForSC", False);
	Result.Insert("IT_ForGR", False);

	Result.Insert("ISR_ForITO_ForPO_ForPI", False);

	Result.Insert("PhysicalInventory_ForSurplus_ForWriteOff", False);

	Result.Insert("SC_ForPR", False);
	Result.Insert("GR_ForSR", False);
	Result.Insert("PR_ForSC", False);
	Result.Insert("SR_ForGR", False);
	Result.Insert("PRO_ForPR", False);
	Result.Insert("SRO_ForSR", False);
	Result.Insert("SI_ForSR_ForSRO", False);
	Result.Insert("PI_ForPR_ForPRO", False);

	Result.Insert("RSR_ForRRR", False);

	Result.Insert("SO_ForWO", False);
	Result.Insert("SO_ForWS", False);
	Result.Insert("WO_ForWS", False);
	Result.Insert("WO_ForSI", False);
	Result.Insert("WS_ForSI", False);
	Result.Insert("SI_ForWS", False);
	
	Return Result;
EndFunction

Procedure EnableRequiredFilterSets(FilterSets, Query, QueryArray)

	If FilterSets.SO_ForSI Then
		ApplyFilterSet_SO_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForSI());
	EndIf;

	If FilterSets.SO_ForSC Then
		ApplyFilterSet_SO_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForSC());
	EndIf;

	If FilterSets.SO_ForPO_ForPI Then
		ApplyFilterSet_SO_ForPO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForPO_ForPI());
	EndIf;

	If FilterSets.SO_ForPRR Then
		ApplyFilterSet_SO_ForPRR(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForPRR());
	EndIf;

	If FilterSets.SO_ForWO Then
		ApplyFilterSet_SO_ForWO(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForWO());
	EndIf;
	
	If FilterSets.SO_ForWS Then
		ApplyFilterSet_SO_ForWS(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForWS());
	EndIf;
	
	If FilterSets.SO_ForRSR Then
		ApplyFilterSet_SO_ForRSR(Query);
		QueryArray.Add(GetDataByFilterSet_SO_ForRSR());
	EndIf;
	
	If FilterSets.SI_ForSC Then
		ApplyFilterSet_SI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_SI_ForSC());
	EndIf;
	
	If FilterSets.SI_ForWS Then
		ApplyFilterSet_SI_ForWS(Query);
		QueryArray.Add(GetDataByFilterSet_SI_ForWS());
	EndIf;
	
	If FilterSets.SC_ForSI Then
		ApplyFilterSet_SC_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_SC_ForSI());
	EndIf;

	If FilterSets.PO_ForPI Then
		ApplyFilterSet_PO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_PO_ForPI());
	EndIf;

	If FilterSets.PO_ForGR Then
		ApplyFilterSet_PO_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_PO_ForGR());
	EndIf;

	If FilterSets.GR_ForPI Then
		ApplyFilterSet_GR_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForPI());
	EndIf;

	If FilterSets.PI_ForGR Then
		ApplyFilterSet_PI_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_PI_ForGR());
	EndIf;

	If FilterSets.PI_ForSI_ForSC Then
		ApplyFilterSet_PI_ForSI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_PI_ForSI_ForSC());
	EndIf;

	If FilterSets.GR_ForSI_ForSC Then
		ApplyFilterSet_GR_ForSI_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForSI_ForSC());
	EndIf;

	If FilterSets.ITO_ForIT Then
		ApplyFilterSet_ITO_ForIT(Query);
		QueryArray.Add(GetDataByFilterSet_ITO_ForIT());
	EndIf;

	If FilterSets.IT_ForSC Then
		ApplyFilterSet_IT_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_IT_ForSC());
	EndIf;

	If FilterSets.IT_ForGR Then
		ApplyFilterSet_IT_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_IT_ForGR());
	EndIf;

	If FilterSets.ISR_ForITO_ForPO_ForPI Then
		ApplyFilterSet_ISR_ForITO_ForPO_ForPI(Query);
		QueryArray.Add(GetDataByFilterSet_ISR_ForITO_ForPO_ForPI());
	EndIf;

	If FilterSets.PhysicalInventory_ForSurplus_ForWriteOff Then
		ApplyFilterSet_PhysicalInventory_ForSurplus_ForWriteOff(Query);
		QueryArray.Add(GetDataByFilterSet_PhysicalInventory_ForSurplus_ForWriteOff());
	EndIf;

	If FilterSets.SC_ForPR Then
		ApplyFilterSet_SC_ForPR(Query);
		QueryArray.Add(GetDataByFilterSet_SC_ForPR());
	EndIf;

	If FilterSets.GR_ForSR Then
		ApplyFilterSet_GR_ForSR(Query);
		QueryArray.Add(GetDataByFilterSet_GR_ForSR());
	EndIf;

	If FilterSets.PR_ForSC Then
		ApplyFilterSet_PR_ForSC(Query);
		QueryArray.Add(GetDataByFilterSet_PR_ForSC());
	EndIf;

	If FilterSets.SR_ForGR Then
		ApplyFilterSet_SR_ForGR(Query);
		QueryArray.Add(GetDataByFilterSet_SR_ForGR());
	EndIf;

	If FilterSets.PRO_ForPR Then
		ApplyFilterSet_PRO_ForPR(Query);
		QueryArray.Add(GetDataByFilterSet_PRO_ForPR());
	EndIf;

	If FilterSets.SRO_ForSR Then
		ApplyFilterSet_SRO_ForSR(Query);
		QueryArray.Add(GetDataByFilterSet_SRO_ForSR());
	EndIf;

	If FilterSets.SI_ForSR_ForSRO Then
		ApplyFilterSet_SI_ForSR_ForSRO(Query);
		QueryArray.Add(GetDataByFilterSet_SI_ForSR_ForSRO());
	EndIf;

	If FilterSets.PI_ForPR_ForPRO Then
		ApplyFilterSet_PI_ForPR_ForPRO(Query);
		QueryArray.Add(GetDataByFilterSet_PI_ForPR_ForPRO());
	EndIf;

	If FilterSets.RSR_ForRRR Then
		ApplyFilterSet_RSR_ForRRR(Query);
		QueryArray.Add(GetDataByFilterSet_RSR_ForRRR());
	EndIf;
	
	If FilterSets.WO_ForWS Then
		ApplyFilterSet_WO_ForWS(Query);
		QueryArray.Add(GetDataByFilterSet_WO_ForWS());
	EndIf;
	
	If FilterSets.WO_ForSI Then
		ApplyFilterSet_WO_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_WO_ForSI());
	EndIf;
	
	If FilterSets.WS_ForSI Then
		ApplyFilterSet_WS_ForSI(Query);
		QueryArray.Add(GetDataByFilterSet_WS_ForSI());
	EndIf;	
EndProcedure

Function GetFieldsToLock_ExternalLink(DocAliase, ExternalDocAliase)
	Aliases = DocAliases();
	If DocAliase = Aliases.SO Then
		Return GetFieldsToLock_ExternalLink_SO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SI Then
		Return GetFieldsToLock_ExternalLink_SI(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SC Then
		Return GetFieldsToLock_ExternalLink_SC(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PO Then
		Return GetFieldsToLock_ExternalLink_PO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PI Then
		Return GetFieldsToLock_ExternalLink_PI(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.GR Then
		Return GetFieldsToLock_ExternalLink_GR(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.ITO Then
		Return GetFieldsToLock_ExternalLink_ITO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.IT Then
		Return GetFieldsToLock_ExternalLink_IT(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.ISR Then
		Return GetFieldsToLock_ExternalLink_ISR(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PhysicalInventory Then
		Return GetFieldsToLock_ExternalLink_PhysicalInventory(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PR Then
		Return GetFieldsToLock_ExternalLink_PR(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PRO Then
		Return GetFieldsToLock_ExternalLink_PRO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SR Then
		Return GetFieldsToLock_ExternalLink_SR(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SRO Then
		Return GetFieldsToLock_ExternalLink_SRO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.RSR Then
		Return GetFieldsToLock_ExternalLink_RSR(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.WO Then
		Return GetFieldsToLock_ExternalLink_WO(ExternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.WS Then
		Return GetFieldsToLock_ExternalLink_WS(ExternalDocAliase, Aliases);		
	Else
		Raise StrTemplate("Not supported External link for [%1]", DocAliase);
	EndIf;
	Return Undefined;
EndFunction

Function GetFieldsToLock_InternalLink(DocAliase, InternalDocAliase)
	Aliases = DocAliases();
	If DocAliase = Aliases.SI Then
		Return GetFieldsToLock_InternalLink_SI(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SC Then
		Return GetFieldsToLock_InternalLink_SC(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PO Then
		Return GetFieldsToLock_InternalLink_PO(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PI Then
		Return GetFieldsToLock_InternalLink_PI(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.GR Then
		Return GetFieldsToLock_InternalLink_GR(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.ITO Then
		Return GetFieldsToLock_InternalLink_ITO(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.IT Then
		Return GetFieldsToLock_InternalLink_IT(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.StockAdjustmentAsSurplus Then
		Return GetFieldsToLock_InternalLink_StockAdjustmentAsSurplus(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.StockAdjustmentAsWriteOff Then
		Return GetFieldsToLock_InternalLink_StockAdjustmentAsWriteOff(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PR Then
		Return GetFieldsToLock_InternalLink_PR(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.PRO Then
		Return GetFieldsToLock_InternalLink_PRO(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SR Then
		Return GetFieldsToLock_InternalLink_SR(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.SRO Then
		Return GetFieldsToLock_InternalLink_SRO(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.RRR Then
		Return GetFieldsToLock_InternalLink_RRR(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.RSR Then
		Return GetFieldsToLock_InternalLink_RSR(InternalDocAliase, Aliases);	
	ElsIf DocAliase = Aliases.PRR Then
		Return GetFieldsToLock_InternalLink_PRR(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.WO Then
		Return GetFieldsToLock_InternalLink_WO(InternalDocAliase, Aliases);
	ElsIf DocAliase = Aliases.WS Then
		Return GetFieldsToLock_InternalLink_WS(InternalDocAliase, Aliases);
	Else
		Raise StrTemplate("Not supported Internal link for [%1]", DocAliase);
	EndIf;
	Return Undefined;
EndFunction

#Region Document_SO

Function GetFieldsToLock_ExternalLink_SO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status,
			|ItemListSetProcurementMethods, TransactionType";
				
		Result.ItemList = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |AgreementSales       , Agreement,
							  |CurrencySales        , Currency,
							  |TransactionTypeSales , TransactionType,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ProcurementMethod    , ItemList.ProcurementMethod,
							  |ItemKey              , ItemList.ItemKey,
							  |Store                , ItemList.Store";
	
	ElsIf ExternalDocAliase = Aliases.RSR Then
		Result.Header   = "Company, Branch, Store, RetailCustomer, Currency, PriceIncludeTax, Status,
			|ItemListSetProcurementMethods, TransactionType";
				
		Result.ItemList = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |RetailCustomer       , RetailCustomer,
							  |CurrencySales        , Currency,
							  |TransactionTypeSales , TransactionType,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ProcurementMethod    , ItemList.ProcurementMethod,
							  |ItemKey              , ItemList.ItemKey,
							  |Store                , ItemList.Store";
		
	ElsIf ExternalDocAliase = Aliases.PRR Then
		Result.Header   = "Company, Branch, Store, Status, ItemListSetProcurementMethods";
		Result.ItemList = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |ProcurementMethod , ItemList.ProcurementMethod,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
		
	ElsIf ExternalDocAliase = Aliases.SC Then
		Result.Header       = "Company, Branch, Store, Partner, LegalName, Status, ItemListSetProcurementMethods, TransactionType";
		
		Result.ItemList     = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |PartnerSales      , Partner,
							  |LegalNameSales    , LegalName,
							  |TransactionTypeSC , TransactionType,
							  |ProcurementMethod , ItemList.ProcurementMethod,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
		
	ElsIf ExternalDocAliase = Aliases.PO Or ExternalDocAliase = Aliases.PI Then
		Result.Header   = "Company, Branch, Store, Status, ItemListSetProcurementMethods";
		Result.ItemList = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |ProcurementMethod , ItemList.ProcurementMethod,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
	
	ElsIf ExternalDocAliase = Aliases.WO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status,
			|ItemListSetProcurementMethods, TransactionType";
			
		Result.ItemList = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |AgreementSales       , Agreement,
							  |CurrencySales        , Currency,
							  |TransactionTypeSales , TransactionType,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ProcurementMethod    , ItemList.ProcurementMethod,
							  |ItemKey              , ItemList.ItemKey,
							  |Store                , ItemList.Store";
							  
	ElsIf ExternalDocAliase = Aliases.WS Then
		Result.Header       = "Company, Branch, Store, Partner, LegalName, Status, ItemListSetProcurementMethods, TransactionType";
		
		Result.ItemList     = "Item, ItemKey, Store, ProcurementMethod, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company            , Company,
							  |Branch             , Branch,
							  |PartnerSales       , Partner,
							  |LegalNameSales     , LegalName,
							  |TransactionTypeSales, TransactionType,
							  |ProcurementMethod  , ItemList.ProcurementMethod,
							  |Store              , ItemList.Store,
							  |ItemKey            , ItemList.ItemKey";
	
	Else
		Raise StrTemplate("Not supported External link for [SO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_SO_ForSI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForSI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SO_ForPRR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForPRR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Requester
	|					THEN RowRef.Requester = &Requester
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SO_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SO_ForPO_ForPI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForPO_ForPI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SO_ForWO(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForWO
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SO_ForWS(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForWS
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_SO_ForRSR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SO_ForRSR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_RetailCustomer
	|					THEN RowRef.RetailCustomer = &RetailCustomer
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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

Function GetDataByFilterSet_SO_ForSI()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForSI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SO_ForPRR()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForPRR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SO_ForSC()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref";
EndFunction

Function GetDataByFilterSet_SO_ForPO_ForPI()
	Return "SELECT
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
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForPO_ForPI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SO_ForWO()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForWO AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SO_ForWS()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForWS AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SO_ForRSR()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.SalesOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SO_ForRSR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_SI

Function GetFieldsToLock_InternalLink_SI(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, SalesOrder, WorkOrder";
	ElsIf InternalDocAliase = Aliases.SC Or InternalDocAliase = Aliases.WS Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, UseShipmentConfirmation, UseWorkSheet, SalesOrder, WorkOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [SI] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_SI(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SC Or ExternalDocAliase = Aliases.WS Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, UseShipmentConfirmation, UseWorkSheet, SalesOrder, WorkOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |PartnerSales      , Partner,
							  |LegalNameSales    , LegalName,
							  |TransactionTypeSC , TransactionType,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
	
	ElsIf ExternalDocAliase = Aliases.SRO Or ExternalDocAliase = Aliases.SR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, SalesOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |AgreementSales       , Agreement,
							  |CurrencySales        , Currency,
							  |TransactionTypeSR    , TransactionType,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ItemKey              , ItemList.ItemKey,
							  |Store                , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [SI] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_SI_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SI_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SI_ForSR_ForSRO(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityTurnover AS Quantity
	|INTO RowIDMovements_SI_ForSR_ForSRO
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements.Turnovers(, &Period, , Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSR
	|					THEN RowRef.TransactionTypeSR = &TransactionTypeSR
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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
	|			END))) AS RowIDMovements
	|WHERE
	|	RowIDMovements.QuantityTurnover > 0";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_SI_ForWS(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SI_ForWS
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_SI_ForSC()
	Return "SELECT
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
		   |		INNER JOIN RowIDMovements_SI_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SI_ForSR_ForSRO()
	Return "SELECT 
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
		   |	END AS BasisUnit,
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
		   |		INNER JOIN RowIDMovements_SI_ForSR_ForSRO AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SI_ForWS()
	Return 
		"SELECT
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
		|		INNER JOIN RowIDMovements_SI_ForWS AS RowIDMovements
		|		ON RowIDMovements.RowID = RowIDInfo.RowID
		|		AND RowIDMovements.Basis = RowIDInfo.Ref
		|		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_SC

Function GetFieldsToLock_InternalLink_SC(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SO 
		Or InternalDocAliase = Aliases.SI 
		Or InternalDocAliase = Aliases.PR
		Or InternalDocAliase = Aliases.PRO
		Or InternalDocAliase = Aliases.IT
		Or InternalDocAliase = Aliases.ITO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ShipmentBasis, SalesOrder, SalesInvoice, InventoryTransferOrder,
			|InventoryTransfer, PurchaseReturnOrder, PurchaseReturn";
	Else
		Raise StrTemplate("Not supported Internal link for [SC] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_SC(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SI Then 
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ShipmentBasis, SalesOrder, SalesInvoice, InventoryTransferOrder,
			|InventoryTransfer, PurchaseReturnOrder, PurchaseReturn";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |PartnerSales      , Partner,
							  |LegalNameSales    , LegalName,
							  |TransactionTypeSC , TransactionType,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
	ElsIf ExternalDocAliase = Aliases.PR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ShipmentBasis, SalesOrder, SalesInvoice, InventoryTransferOrder,
			|InventoryTransfer, PurchaseReturnOrder, PurchaseReturn";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company            , Company,
							  |Branch             , Branch,
							  |PartnerPurchases   , Partner,
							  |LegalNamePurchases , LegalName,
							  |TransactionTypeSC  , TransactionType,
							  |ItemKey            , ItemList.ItemKey,
							  |Store              , ItemList.Store";
	
	Else
		Raise StrTemplate("Not supported External link for [SC] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_SC_ForSI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC_ForSI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
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

Procedure ApplyFilterSet_SC_ForPR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SC_ForPR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
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

Function GetDataByFilterSet_SC_ForSI()
	Return "SELECT
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
		   |		INNER JOIN RowIDMovements_SC_ForSI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_SC_ForPR()
	Return "SELECT
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
		   |		INNER JOIN RowIDMovements_SC_ForPR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_SRO

Function GetFieldsToLock_InternalLink_SRO(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, SalesInvoice";
	Else
		Raise StrTemplate("Not supported Internal link for [SRO] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_SRO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, Cancel, CancelReason";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |AgreementSales       , Agreement,
							  |CurrencySales        , Currency,
							  |TransactionTypeSR    , TransactionType,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ItemKey              , ItemList.ItemKey,
							  |Store                , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [SRO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_SRO_ForSR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SRO_ForSR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company OR &Filter_CompanyReturn
	|					THEN RowRef.Company = &Company OR RowRef.Company = &CompanyReturn
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch OR &Filter_BranchReturn
	|					THEN RowRef.Branch = &Branch OR RowRef.Branch = &BranchReturn
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSR
	|					THEN RowRef.TransactionTypeSR = &TransactionTypeSR
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store OR &Filter_StoreReturn
	|					THEN RowRef.Store = &Store OR RowRef.Store = &StoreReturn
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_SRO_ForSR()
	Return "SELECT
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
		   |	Document.SalesReturnOrder.ItemList AS Doc
		   |		INNER JOIN Document.SalesReturnOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SRO_ForSR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_PO

Function GetFieldsToLock_InternalLink_PO(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.ISR Then
		Result.Header   = "Company, Branch, Store";
		Result.ItemList = "Item, ItemKey, Store, PurchaseBasis, SalesOrder, InternalSupplyRequest";
	ElsIf InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Store";
		Result.ItemList = "Item, ItemKey, Store, PurchaseBasis, SalesOrder, InternalSupplyRequest";
	Else
		Raise StrTemplate("Not supported Internal link for [PO] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_PO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.PI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, Cancel, CancelReason, PurchaseBasis, SalesOrder, InternalSupplyRequest";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company                  , Company,
							  |Branch                   , Branch,
							  |PartnerPurchases         , Partner,
							  |LegalNamePurchases       , LegalName,
							  |AgreementPurchases       , Agreement,
							  |CurrencyPurchases        , Currency,
							  |TransactionTypePurchases , TransactionType,
							  |PriceIncludeTaxPurchases , PriceIncludeTax,
							  |ItemKey                  , ItemList.ItemKey,
							  |Store                    , ItemList.Store";
	
	ElsIf ExternalDocAliase = Aliases.GR Then
		Result.Header       = "Company, Branch, Store, Partner, LegalName, Status, TransactionType";
		Result.ItemList     = "Item, ItemKey, Store, Cancel, CancelReason, PurchaseBasis, SalesOrder, InternalSupplyRequest";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company            , Company,
							  |Branch             , Branch,
							  |PartnerPurchases   , Partner,
							  |LegalNamePurchases , LegalName,
							  |TransactionTypeGR  , TransactionType,
							  |ItemKey            , ItemList.ItemKey,
							  |Store              , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [PO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_PO_ForPI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PO_ForPI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementPurchases
	|					THEN RowRef.AgreementPurchases = &AgreementPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencyPurchases
	|					THEN RowRef.CurrencyPurchases = &CurrencyPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypePurchases
	|					THEN RowRef.TransactionTypePurchases = &TransactionTypePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxPurchases
	|					THEN RowRef.PriceIncludeTaxPurchases = &PriceIncludeTaxPurchases
	|				ELSE FALSE
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

Procedure ApplyFilterSet_PO_ForGR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PO_ForGR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
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

Function GetDataByFilterSet_PO_ForPI()
	Return "SELECT
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
		   |	Document.PurchaseOrder.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PO_ForPI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_PO_ForGR()
	Return "SELECT
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
		   |	Document.PurchaseOrder.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PO_ForGR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_GR

Function GetFieldsToLock_InternalLink_GR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PO 
		Or InternalDocAliase = Aliases.PI 
		Or InternalDocAliase = Aliases.SR
		Or InternalDocAliase = Aliases.SRO
		Or InternalDocAliase = Aliases.IT
		Or InternalDocAliase = Aliases.ITO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ReceiptBasis, SalesOrder, PurchaseOrder, PurchaseInvoice, 
			|InternalSupplyRequest, InventoryTransferOrder, SalesReturn, SalesReturnOrder,
			|InventoryTransfer, SalesInvoice";
	Else
		Raise StrTemplate("Not supported Internal link for [GR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_GR(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.PI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ReceiptBasis, SalesOrder, PurchaseInvoice, 
			|PurchaseOrder, InternalSupplyRequest, InventoryTransferOrder, SalesReturn, SalesReturnOrder,
			|InventoryTransfer, SalesInvoice";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company        , Company,
						  |Branch             , Branch,
						  |PartnerPurchases   , Partner,
						  |LegalNamePurchases , LegalName,
						  |TransactionTypeGR  , TransactionType,
						  |ItemKey            , ItemList.ItemKey,
						  |Store              , ItemList.Store";
	ElsIf ExternalDocAliase = Aliases.SR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, ReceiptBasis, SalesOrder, PurchaseInvoice, 
			|PurchaseOrder, InternalSupplyRequest, InventoryTransferOrder, SalesReturn, SalesReturnOrder,
			|InventoryTransfer, SalesInvoice";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company       , Company,
						  |Branch            , Branch,
						  |PartnerSales      , Partner,
						  |LegalNameSales    , LegalName,
						  |TransactionTypeGR , TransactionType,
						  |ItemKey           , ItemList.ItemKey,
						  |Store             , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [GR] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_GR_ForSI_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForSI_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
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

Procedure ApplyFilterSet_GR_ForPI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForPI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
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

Procedure ApplyFilterSet_GR_ForSR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_GR_ForSR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company OR &Filter_CompanyReturn
	|					THEN RowRef.Company = &Company OR RowRef.Company = &CompanyReturn
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch OR &Filter_BranchReturn
	|					THEN RowRef.Branch = &Branch OR RowRef.Branch = &BranchReturn
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store OR &Filter_StoreReturn
	|					THEN RowRef.Store = &Store OR RowRef.Store = &StoreReturn
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_GR_ForSI_ForSC()
	Return "SELECT
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
		   |	Document.GoodsReceipt.ItemList AS Doc
		   |		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_GR_ForSI_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_GR_ForPI()
	Return "SELECT
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
		   |	Document.GoodsReceipt.ItemList AS Doc
		   |		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_GR_ForPI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_GR_ForSR()
	Return "SELECT
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
		   |	Document.GoodsReceipt.ItemList AS Doc
		   |		INNER JOIN Document.GoodsReceipt.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_GR_ForSR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_PI

Function GetFieldsToLock_InternalLink_PI(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PO Then
		Result.Header   = "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Store, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseOrder, SalesOrder, InternalSupplyRequest";
	ElsIf InternalDocAliase = Aliases.GR Then
		Result.Header   = "Company, Branch, Partner, LegalName, Store, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseOrder, SalesOrder, InternalSupplyRequest";
	ElsIf InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Store";
		Result.ItemList = "Item, ItemKey, Store, PurchaseOrder, SalesOrder, InternalSupplyRequest";
	ElsIf InternalDocAliase = Aliases.ISR Then
		Result.Header   = "Company, Branch, Store";
		Result.ItemList = "Item, ItemKey, Store, PurchaseOrder, SalesOrder, InternalSupplyRequest";
	Else
		Raise StrTemplate("Not supported Internal link for [PI] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_PI(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.GR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, UseGoodsReceipt, PurchaseOrder, SalesOrder, InternalSupplyRequest";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company            , Company,
							  |Branch             , Branch,
							  |PartnerPurchases   , Partner,
							  |LegalNamePurchases , LegalName,
							  |TransactionTypeGR  , TransactionType,
							  |ItemKey            , ItemList.ItemKey,
							  |Store              , ItemList.Store";
	
	ElsIf ExternalDocAliase = Aliases.PRO Or ExternalDocAliase = Aliases.PR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseOrder, SalesOrder, InternalSupplyRequest";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company                  , Company,
							  |Branch                   , Branch,
							  |PartnerPurchases         , Partner,
							  |LegalNamePurchases       , LegalName,
							  |AgreementPurchases       , Agreement,
							  |CurrencyPurchases        , Currency,
							  |TransactionTypePR        , TransactionType,
							  |PriceIncludeTaxPurchases , PriceIncludeTax,
							  |ItemKey                  , ItemList.ItemKey,
							  |Store                    , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [PI] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_PI_ForGR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PI_ForGR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
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

Procedure ApplyFilterSet_PI_ForPR_ForPRO(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityTurnover AS Quantity
	|INTO RowIDMovements_PI_ForPR_ForPRO
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements.Turnovers(, &Period, , Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementPurchases
	|					THEN RowRef.AgreementPurchases = &AgreementPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencyPurchases
	|					THEN RowRef.CurrencyPurchases = &CurrencyPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypePR
	|					THEN RowRef.TransactionTypePR = &TransactionTypePR
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxPurchases
	|					THEN RowRef.PriceIncludeTaxPurchases = &PriceIncludeTaxPurchases
	|				ELSE FALSE
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
	|			END))) AS RowIDMovements
	|WHERE
	|	RowIDMovements.QuantityTurnover > 0";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_PI_ForSI_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PI_ForSI_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_ProcurementMethod
	|					THEN RowRef.ProcurementMethod = &ProcurementMethod
	|				ELSE FALSE
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

Function GetDataByFilterSet_PI_ForGR()
	Return "SELECT
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
		   |	Document.PurchaseInvoice.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PI_ForGR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_PI_ForPR_ForPRO()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.PurchaseInvoice.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PI_ForPR_ForPRO AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_PI_ForSI_ForSC()
	Return "SELECT
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
		   |	Document.PurchaseInvoice.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseInvoice.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PI_ForSI_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_ITO

Function GetFieldsToLock_InternalLink_ITO(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.ISR Then
		Result.Header   = "Company, Branch, StoreReceiver";
		Result.ItemList = "Item, ItemKey, InternalSupplyRequest, PurchaseOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [ITO] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_ITO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.IT Then
		Result.Header   = "Company, Branch, StoreReceiver, StoreSender, Status";
		Result.ItemList = "Item, ItemKey, InternalSupplyRequest, PurchaseOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company          , Company,
							  |Branch           , Branch,
							  |StoreSender      , StoreSender,
							  |StoreReceiver    , StoreReceiver,
							  |ItemKey          , ItemList.ItemKey";
	Else
		Raise StrTemplate("Not supported External link for [ITO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_ITO_ForIT(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_ITO_ForIT
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Basises
	|					THEN Basis IN (&Basises)
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_StoreSender
	|					THEN RowRef.StoreSender = &StoreSender
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_StoreReceiver
	|					THEN RowRef.StoreReceiver = &StoreReceiver
	|				ELSE TRUE
	|			END)) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_ITO_ForIT()
	Return "SELECT
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	VALUE(Catalog.Stores.EmptyRef),
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
		   |	Document.InventoryTransferOrder.ItemList AS Doc
		   |		INNER JOIN Document.InventoryTransferOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_ITO_ForIT AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_IT

Function GetFieldsToLock_InternalLink_IT(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.ITO Then
		Result.Header   = "Company, Branch, StoreSender, StoreReceiver";
		Result.ItemList = "Item, ItemKey, InventoryTransferOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [IT] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_IT(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SC Then
		Result.Header   = "Company, Branch, StoreSender, UseShipmentConfirmation";
		Result.ItemList = "Item, ItemKey, InventoryTransferOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |StoreSender       , StoreSender,
							  |TransactionTypeSC , ,
							  |ItemKey           , ItemList.ItemKey";
	ElsIf ExternalDocAliase = Aliases.GR Then
		Result.Header   = "Company, Branch, StoreReceiver, UseGoodsReceipt";
		Result.ItemList = "Item, ItemKey, InventoryTransferOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |StoreReceiver     , StoreReceiver,
							  |TransactionTypeGR , ,
							  |ItemKey           , ItemList.ItemKey";
	
	Else
		Raise StrTemplate("Not supported External link for [IT] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_IT_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_IT_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.StoreSender = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_IT_ForGR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_IT_ForGR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.StoreReceiver = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_IT_ForSC()
	Return "SELECT
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	Doc.Ref.StoreSender,
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
		   |	Document.InventoryTransfer.ItemList AS Doc
		   |		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_IT_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_IT_ForGR()
	Return "SELECT
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	Doc.Ref.StoreReceiver,
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
		   |	Document.InventoryTransfer.ItemList AS Doc
		   |		INNER JOIN Document.InventoryTransfer.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_IT_ForGR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_ISR

Function GetFieldsToLock_ExternalLink_ISR(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.ITO Or ExternalDocAliase = Aliases.PI Or ExternalDocAliase = Aliases.PO Then
		Result.Header   = "Company, Branch, Store";
		Result.ItemList = "Item, ItemKey";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |Store             , Store,
							  |ItemKey           , ItemList.ItemKey";
	Else
		Raise StrTemplate("Not supported External link for [ISR] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_ISR_ForITO_ForPO_ForPI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_ISR_ForITO_ForPO_ForPI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
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

Function GetDataByFilterSet_ISR_ForITO_ForPO_ForPI()
	Return "SELECT 
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	Doc.Ref.Store,
		   |	Doc.Ref,
		   |	Doc.Key,
		   |	Doc.Key,
		   |	CASE
		   |		WHEN Doc.ItemKey.Unit.Ref IS NULL
		   |			THEN Doc.ItemKey.Item.Unit
		   |		ELSE Doc.ItemKey.Unit
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.InternalSupplyRequest.ItemList AS Doc
		   |		INNER JOIN Document.InternalSupplyRequest.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_ISR_ForITO_ForPO_ForPI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_PR

Function GetFieldsToLock_InternalLink_PR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Store, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseInvoice, PurchaseReturnOrder";
	ElsIf InternalDocAliase = Aliases.PRO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Store, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseInvoice, PurchaseReturnOrder";
	ElsIf InternalDocAliase = Aliases.SC Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, UseShipmentConfirmation, PurchaseReturnOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [PR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_PR(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SC Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName";
		Result.ItemList = "Item, ItemKey, Store, UseShipmentConfirmation, PurchaseReturnOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company            , Company,
							  |Branch             , Branch,
							  |PartnerPurchases   , Partner,
							  |LegalNamePurchases , LegalName,
							  |TransactionTypeSC  , TransactionType,
							  |ItemKey            , ItemList.ItemKey,
							  |Store              , ItemList.Store";
	
	Else
		Raise StrTemplate("Not supported External link for [PR] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_PR_ForSC(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PR_ForSC
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeSC = &TransactionType
	|				ELSE FALSE
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

Function GetDataByFilterSet_PR_ForSC()
	Return "SELECT
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
		   |	Document.PurchaseReturn.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseReturn.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PR_ForSC AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_SR

Function GetFieldsToLock_InternalLink_SR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, SalesInvoice, SalesReturnOrder";
	ElsIf InternalDocAliase = Aliases.SRO Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, SalesInvoice, SalesReturnOrder";
	ElsIf InternalDocAliase = Aliases.GR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, UseGoodsReceipt, SalesReturnOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [SR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_SR(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.GR Then
		Result.Header       = "Company, Branch, Store, Partner, LegalName";
		Result.ItemList     = "Item, ItemKey, Store, UseGoodsReceipt, SalesReturnOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |PartnerSales      , Partner,
							  |LegalNameSales    , LegalName,
							  |TransactionTypeGR , TransactionType,
							  |ItemKey           , ItemList.ItemKey,
							  |Store             , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [SR] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_SR_ForGR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_SR_ForGR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company OR RowRef.CompanyReturn = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch OR RowRef.BranchReturn = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionType
	|					THEN RowRef.TransactionTypeGR = &TransactionType
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store OR RowRef.StoreReturn = &Store
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_SR_ForGR()
	Return "SELECT
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
		   |	Document.SalesReturn.ItemList AS Doc
		   |		INNER JOIN Document.SalesReturn.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_SR_ForGR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_PRO

Function GetFieldsToLock_InternalLink_PRO(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PI Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Store, TransactionType";
		Result.ItemList = "Item, ItemKey, Store, PurchaseInvoice";
	Else
		Raise StrTemplate("Not supported Internal link for [PRO] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_PRO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.PR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status";
		Result.ItemList = "Item, ItemKey, Store, Cancel, PurchaseInvoice";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company                  , Company,
							  |Branch                   , Branch,
							  |PartnerPurchases         , Partner,
							  |LegalNamePurchases       , LegalName,
							  |AgreementPurchases       , Agreement,
							  |CurrencyPurchases        , Currency,
							  |TransactionTypePR        , TransactionType,
							  |PriceIncludeTaxPurchases , PriceIncludeTax,
							  |ItemKey                  , ItemList.ItemKey,
							  |Store                    , ItemList.Store";
	
	Else
		Raise StrTemplate("Not supported External link for [PRO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_PRO_ForPR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PRO_ForPR
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerPurchases
	|					THEN RowRef.PartnerPurchases = &PartnerPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNamePurchases
	|					THEN RowRef.LegalNamePurchases = &LegalNamePurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementPurchases
	|					THEN RowRef.AgreementPurchases = &AgreementPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencyPurchases
	|					THEN RowRef.CurrencyPurchases = &CurrencyPurchases
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypePR
	|					THEN RowRef.TransactionTypePR = &TransactionTypePR
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxPurchases
	|					THEN RowRef.PriceIncludeTaxPurchases = &PriceIncludeTaxPurchases
	|				ELSE FALSE
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

Function GetDataByFilterSet_PRO_ForPR()
	Return "SELECT
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
		   |	Document.PurchaseReturnOrder.ItemList AS Doc
		   |		INNER JOIN Document.PurchaseReturnOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PRO_ForPR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_RSR

Function GetFieldsToLock_ExternalLink_RSR(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.RRR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, RetailCustomer, Currency, 
			|PriceIncludeTax, UsePartnerTransactions";
		Result.ItemList = "Item, ItemKey, Store";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company          , Company,
							  |Branch           , Branch,
							  |PartnerSales     , Partner,
							  |LegalNameSales   , LegalName,
							  |ItemKey          , ItemList.ItemKey,
							  |Store            , ItemList.Store";
	Else
		Raise StrTemplate("Not supported External link for [RSR] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_RSR_ForRRR(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityTurnover AS Quantity
	|INTO RowIDMovements_RSR_ForRRR
	|FROM
	|	AccumulationRegister.TM1010T_RowIDMovements.Turnovers(, &Period, , Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE TRUE
	|
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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
	|			END))) AS RowIDMovements
	|WHERE
	|	RowIDMovements.QuantityTurnover > 0";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_RSR_ForRRR()
	Return "SELECT 
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
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.RetailSalesReceipt.ItemList AS Doc
		   |		INNER JOIN Document.RetailSalesReceipt.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_RSR_ForRRR AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_PRR

Function GetFieldsToLock_InternalLink_PRR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Requester";
		Result.ItemList = "Item, ItemKey, Store";
	Else
		Raise StrTemplate("Not supported Internal link for [PRR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Document_RRR

Function GetFieldsToLock_InternalLink_RRR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.RSR Then
		Result.Header   = "Company, Branch, Store, Partner, LegalName, Agreement, RetailCustomer, Currency, 
			|PriceIncludeTax, UsePartnerTransactions";
		Result.ItemList = "Item, ItemKey, Store, RetailSalesReceipt";
	Else
		Raise StrTemplate("Not supported Internal link for [RRR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Document_RSR

Function GetFieldsToLock_InternalLink_RSR(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Store, RetailCustomer, Partner, LegalName, Agreement, Currency, 
			|PriceIncludeTax, UsePartnerTransactions";
		Result.ItemList = "Item, ItemKey, Store, SalesOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [RSR] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Document_StockAdjustmentAsSurplus

Function GetFieldsToLock_InternalLink_StockAdjustmentAsSurplus(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PhysicalInventory Then
		Result.Header   = "Store";
		Result.ItemList = "Item, ItemKey, BasisDocument, PhysicalInventory";
	Else
		Raise StrTemplate("Not supported Internal link for [StockAdjustmentAsSurplus] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Document_StockAdjustmentAsWriteOff

Function GetFieldsToLock_InternalLink_StockAdjustmentAsWriteOff(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.PhysicalInventory Then
		Result.Header   = "Store";
		Result.ItemList = "Item, ItemKey, BasisDocument, PhysicalInventory";
	Else
		Raise StrTemplate("Not supported Internal link for [StockAdjustmentAsWriteOff] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

#EndRegion

#Region Document_PhysicalInventory

Function GetFieldsToLock_ExternalLink_PhysicalInventory(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.StockAdjustmentAsSurplus 
		Or ExternalDocAliase = Aliases.StockAdjustmentAsWriteOff Then
		Result.Header   = "Store, Status, FillExpCount, UpdatePhysCount";
		Result.ItemList = "Item, ItemKey";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Store   , Store,
							  |ItemKey , ItemList.ItemKey";
	Else
		Raise StrTemplate("Not supported External link for [PhysicalInventory] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_PhysicalInventory_ForSurplus_ForWriteOff(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_PhysicalInventory_ForSurplus_ForWriteOff
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END
	|			AND CASE
	|				WHEN &Filter_Store
	|					THEN RowRef.Store = &Store
	|				ELSE FALSE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Function GetDataByFilterSet_PhysicalInventory_ForSurplus_ForWriteOff()
	Return "SELECT 
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	Doc.Ref.Store,
		   |	Doc.Ref,
		   |	Doc.Key,
		   |	Doc.Key,
		   |	CASE
		   |		WHEN Doc.ItemKey.Unit.Ref IS NULL
		   |			THEN Doc.ItemKey.Item.Unit
		   |		ELSE Doc.ItemKey.Unit
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.PhysicalInventory.ItemList AS Doc
		   |		INNER JOIN Document.PhysicalInventory.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_PhysicalInventory_ForSurplus_ForWriteOff AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_WO

Function GetFieldsToLock_InternalLink_WO(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.SO Then
		Result.Header   = "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax";
		Result.ItemList = "Item, ItemKey, SalesOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [WO] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_WO(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.WS Then
		Result.Header   = "Company, Branch, Partner, LegalName, Status";

		Result.ItemList = "Item, ItemKey";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |TransactionTypeSales ,,
							  |ItemKey              , ItemList.ItemKey";
	
	ElsIf ExternalDocAliase = Aliases.SI Then
		Result.Header   = "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax, Status";
		Result.ItemList = "Item, ItemKey";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company              , Company,
							  |Branch               , Branch,
							  |PartnerSales         , Partner,
							  |LegalNameSales       , LegalName,
							  |AgreementSales       , Agreement,
							  |CurrencySales        , Currency,
							  |TransactionTypeSales ,,
							  |PriceIncludeTaxSales , PriceIncludeTax,
							  |ItemKey              , ItemList.ItemKey";
	
	Else
		Raise StrTemplate("Not supported External link for [WO] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_WO_ForWS(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_WO_ForWS
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_ItemKey
	|					THEN RowRef.ItemKey = &ItemKey
	|				ELSE TRUE
	|			END))) AS RowIDMovements";
	Query.Execute();
EndProcedure

Procedure ApplyFilterSet_WO_ForSI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_WO_ForSI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_AgreementSales
	|					THEN RowRef.AgreementSales = &AgreementSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_CurrencySales
	|					THEN RowRef.CurrencySales = &CurrencySales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PriceIncludeTaxSales
	|					THEN RowRef.PriceIncludeTaxSales = &PriceIncludeTaxSales
	|				ELSE FALSE
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

Function GetDataByFilterSet_WO_ForWS()
	Return "SELECT
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	UNDEFINED AS Store,
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
		   |	Document.WorkOrder.ItemList AS Doc
		   |		INNER JOIN Document.WorkOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_WO_ForWS AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

Function GetDataByFilterSet_WO_ForSI()
	Return "SELECT 
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	UNDEFINED AS Store,
		   |	Doc.Ref,
		   |	Doc.Key,
		   |	Doc.Key,
		   |	CASE
		   |		WHEN Doc.ItemKey.Unit.Ref IS NULL
		   |			THEN Doc.ItemKey.Item.Unit
		   |		ELSE Doc.ItemKey.Unit
		   |	END AS BasisUnit,
		   |	RowIDMovements.Quantity,
		   |	RowIDMovements.RowRef,
		   |	RowIDMovements.RowID,
		   |	RowIDMovements.Step,
		   |	Doc.LineNumber
		   |FROM
		   |	Document.WorkOrder.ItemList AS Doc
		   |		INNER JOIN Document.WorkOrder.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_WO_ForSI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#Region Document_WS

Function GetFieldsToLock_InternalLink_WS(InternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList");
	If InternalDocAliase = Aliases.WO Or InternalDocAliase = Aliases.SI Then
		Result.Header   = "Company, Branch, Partner, LegalName";
		Result.ItemList = "Item, ItemKey, SalesOrder, SalesInvoice, WorkOrder";
	Else
		Raise StrTemplate("Not supported Internal link for [WS] to [%1]", InternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Function GetFieldsToLock_ExternalLink_WS(ExternalDocAliase, Aliases)
	Result = New Structure("Header, ItemList, RowRefFilter");
	If ExternalDocAliase = Aliases.SI Then 
		Result.Header   = "Company, Branch, Partner, LegalName";
		Result.ItemList = "Item, ItemKey, SalesOrder, WorkOrder";
		// Attribute name, Data path (use for show user message)
		Result.RowRefFilter = "Company           , Company,
							  |Branch            , Branch,
							  |PartnerSales      , Partner,
							  |LegalNameSales    , LegalName,
							  |TransactionTypeSales, ,
							  |ItemKey           , ItemList.ItemKey";
	Else
		Raise StrTemplate("Not supported External link for [SC] to [%1]", ExternalDocAliase);
	EndIf;
	Return Result;
EndFunction

Procedure ApplyFilterSet_WS_ForSI(Query)
	Query.Text =
	"SELECT
	|	RowIDMovements.RowID,
	|	RowIDMovements.Step,
	|	RowIDMovements.Basis,
	|	RowIDMovements.BasisKey,
	|	RowIDMovements.RowRef,
	|	RowIDMovements.QuantityBalance AS Quantity
	|INTO RowIDMovements_WS_ForSI
	|FROM
	|	AccumulationRegister.TM1010B_RowIDMovements.Balance(&Period, Step IN (&StepArray)
	|	AND (Basis IN (&Basises)
	|	OR RowRef.Basis IN (&Basises)
	|	OR RowRef IN
	|		(SELECT
	|			RowRef.Ref AS Ref
	|		FROM
	|			Catalog.RowIDs AS RowRef
	|		WHERE
	|			CASE
	|				WHEN &Filter_Company
	|					THEN RowRef.Company = &Company
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_Branch
	|					THEN RowRef.Branch = &Branch
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_PartnerSales
	|					THEN RowRef.PartnerSales = &PartnerSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_LegalNameSales
	|					THEN RowRef.LegalNameSales = &LegalNameSales
	|				ELSE FALSE
	|			END
	|			AND CASE
	|				WHEN &Filter_TransactionTypeSales
	|					THEN RowRef.TransactionTypeSales = &TransactionTypeSales
	|				ELSE FALSE
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

Function GetDataByFilterSet_WS_ForSI()
	Return "SELECT
		   |	Doc.ItemKey,
		   |	Doc.ItemKey.Item,
		   |	UNDEFINED AS Store,
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
		   |	Document.WorkSheet.ItemList AS Doc
		   |		INNER JOIN Document.WorkSheet.RowIDInfo AS RowIDInfo
		   |		ON Doc.Ref = RowIDInfo.Ref
		   |		AND Doc.Key = RowIDInfo.Key
		   |		INNER JOIN RowIDMovements_WS_ForSI AS RowIDMovements
		   |		ON RowIDMovements.RowID = RowIDInfo.RowID
		   |		AND RowIDMovements.Basis = RowIDInfo.Ref
		   |		AND RowIDMovements.BasisKey = RowIDInfo.Key";
EndFunction

#EndRegion

#EndRegion

Function GetBasisesTable(StepArray, FilterValues, FilterSets)
	Query = New Query();
	FillQueryParameters(Query, FilterValues);

	Query.SetParameter("StepArray", StepArray);

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
	If FilterValues.Property("Ref") And ValueIsFilled(FilterValues.Ref) Then
		Ref = FilterValues.Ref;
		Period = New Boundary(FilterValues.Ref.PointInTime(), BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Ref", Ref);
	Query.SetParameter("Period", Period);

	Query.TempTablesManager = New TempTablesManager();

	QueryArray = New Array();
	QueryArray.Add(
	"SELECT ALLOWED
	|UNDEFINED AS ItemKey,
	|UNDEFINED AS Item,
	|UNDEFINED AS Store,
	|UNDEFINED AS Basis,
	|UNDEFINED AS Key,
	|UNDEFINED AS BasisKey,
	|UNDEFINED AS BasisUnit,
	|UNDEFINED AS QuantityInBaseUnit,
	|UNDEFINED AS RowRef,
	|UNDEFINED AS RowID,
	|UNDEFINED AS CurrentStep,
	|UNDEFINED AS LineNumber
	|INTO AllData
	|WHERE FALSE ");

	EnableRequiredFilterSets(FilterSets, Query, QueryArray);

	Query.Text = StrConcat(QueryArray, " UNION ALL ");

	Query.Text = Query.Text + 
	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	AllData.ItemKey,
	|	AllData.Item,
	|	AllData.Store,
	|	AllData.Basis AS Basis,
	|	UNDEFINED AS ParentBasis,
	|	AllData.Key,
	|	AllData.BasisKey,
	|	AllData.BasisUnit,
	|	AllData.QuantityInBaseUnit,
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
		Value = Undefined;
		Use = False;
		If FilterValues.Property(Attribute.Name) Then
			If TrimAll(Upper(Attribute.Name)) = TrimAll(Upper("Branch"))
				Or TrimAll(Upper(Attribute.Name)) = TrimAll(Upper("BranchReturn")) Then
				If ValueIsFilled(FilterValues[Attribute.Name]) Then
					Value = FilterValues[Attribute.Name];
					Use = True;
				Else
					Value = Catalogs.BusinessUnits.EmptyRef();
					Use = True;
				EndIf;
			Else
				If ValueIsFilled(FilterValues[Attribute.Name]) Then
					Value = FilterValues[Attribute.Name];
					Use = True;
				EndIf;
			EndIf;
		EndIf;
		Query.SetParameter("Filter_" + Attribute.Name, Use);
		Query.SetParameter(Attribute.Name, Value);
	EndDo;
EndProcedure

#EndRegion

#Region AddLinkUnlinkDocumentRow

Function AddLinkedDocumentRows(Object, FillingValues) Export
	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		Return "";
	EndIf;

	TableNames_Refreshable = GetTableNames_Refreshable();

	For Each Row_ItemList In FillingValue.ItemList Do
		NewKey = String(New UUID());

		For Each TableName In TableNames_Refreshable Do
			If Not FillingValue.Property(TableName) Then
				Continue;
			EndIf;
			For Each Row In FillingValue[TableName] Do
				If CommonFunctionsClientServer.ObjectHasProperty(Row, "KeyOwner") 
					And Row.KeyOwner = Row_ItemList.Key Then
					
					Row.KeyOwner = NewKey;
				ElsIf CommonFunctionsClientServer.ObjectHasProperty(Row, "Key") 
					And Row.Key = Row_ItemList.Key Then
					
					Row.Key = NewKey;
				EndIf;
			EndDo;
		EndDo;
		Row_ItemList.Key = NewKey;
	EndDo;

	TableNames_Refreshable.Add("ItemList");
	
	UpdatedProperties = New Array();
	ArrayOfNewRows = New Array();
	For Each TableName In TableNames_Refreshable Do
		If FillingValue.Property(TableName) And CommonFunctionsClientServer.ObjectHasProperty(Object, TableName) Then
			For Each Row In FillingValue[TableName] Do
				NewRow = Object[TableName].Add();
				FillPropertyValues(NewRow, Row);
				
				If Upper(TableName) = Upper("ItemList") Then
					ArrayOfNewRows.Add(NewRow);
					For Each KeyValue In Row Do
						PropertyName = TrimAll(KeyValue.Key);
						PutToUpdatedProperties(PropertyName, TableName, NewRow, UpdatedProperties);
					EndDo;
				EndIf;
				
				If Upper(TableName) = Upper("Materials") Then
					For Each KeyValue In Row Do
						PropertyName = TrimAll(KeyValue.Key);
						PutToUpdatedProperties(PropertyName, TableName, NewRow, UpdatedProperties);
					EndDo;
				EndIf;
				
			EndDo;
		EndIf;
	EndDo;
	Return New Structure("UpdatedProperties, Rows", 
		StrConcat(UpdatedProperties, ","), ArrayOfNewRows);
EndFunction

Procedure PutToUpdatedProperties(PropertyName, TableName, Row, UpdatedProperties, IsUnlink = False)
	If CommonFunctionsClientServer.ObjectHasProperty(Row, PropertyName) Then
		// empty properties processed only for unlink
		If Not IsUnlink And Not ValueIsFilled(Row[PropertyName]) Then
			Return;
		EndIf;
		
		DataPath = TrimAll(TableName) + "." + PropertyName;
		If UpdatedProperties.Find(DataPath) = Undefined Then
			UpdatedProperties.Add(DataPath);
		EndIf;
	EndIf;
EndProcedure

Function LinkUnlinkDocumentRows(Object, FillingValues) Export
	
	// Tables with linked documents, will be cleaning on unlink
	TableNames_LinkedDocuments = GetTableNames_LinkedDocuments();
	
	// ItemList attributes with refs to linked documents
	AttributeNames_LinkedDocuments = GetAttributeNames_LinkedDocuments();
	
	// Refreshable tables on unlink documents
	TableNames_Refreshable = GetTableNames_Refreshable();

	UpdatedProperties = New Array();
	UpdatedRows = New Array();

	FillingValue = GetFillingValue(FillingValues);
	If FillingValue = Undefined Then
		UnlinkRows = New Array();
		For Each OldRow In Object.RowIDInfo Do
			UnlinkRows.Add(OldRow);
		EndDo;
		Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments, UpdatedProperties, UpdatedRows);
		Object.RowIDInfo.Clear();
		
	Else
	
		// Unlink
		UnlinkRows = GetUnlinkRows(Object, FillingValue);
		Unlink(Object, UnlinkRows, TableNames_LinkedDocuments, AttributeNames_LinkedDocuments, UpdatedProperties, UpdatedRows);
		
		// Link
		LinkRows = GetLinkRows(Object, FillingValue);
		Link(Object, FillingValue, LinkRows, TableNames_Refreshable, UpdatedProperties, UpdatedRows);

		Object.RowIDInfo.Clear();
		For Each Row In FillingValue.RowIDInfo Do
			FillPropertyValues(Object.RowIDInfo.Add(), Row);
		EndDo;
	
	EndIf;
	
	Return New Structure("UpdatedProperties, Rows", StrConcat(UpdatedProperties, ","), UpdatedRows);
EndFunction

Function GetFillingValue(FillingValues)
	If TypeOf(FillingValues) = Type("Structure") Then
		Return FillingValues;
	ElsIf TypeOf(FillingValues) = Type("Array") And FillingValues.Count() = 1 Then
		Return FillingValues[0];
	EndIf;
	Return Undefined;
EndFunction

#Region Unlink

Procedure Unlink(Object, UnlinkRows, TableNames, AttributeNames, UpdatedProperties, UpdatedRows)
	For Each UnlinkRow In UnlinkRows Do
		UnlinkTables(Object, UnlinkRow, TableNames);
		
		// Clear attributes in ItemList
		LinkedRows = Object.ItemList.FindRows(New Structure("Key", UnlinkRow.Key));
		For Each LinkedRow In LinkedRows Do
			If Not IsCanUnlinkAttributes(Object, UnlinkRow, TableNames) Then
				Continue;
			EndIf;
			UnlinkAttributes(LinkedRow, AttributeNames, UpdatedProperties);
			UpdatedRows.Add(LinkedRow);
		EndDo;
	EndDo;
EndProcedure

Function GetUnlinkRows(Object, FillingValue)
	UnlinkRows = New Array();
	For Each OldRow In Object.RowIDInfo Do
		IsUnlink = True;
		For Each NewRow In FillingValue.RowIDInfo Do
			If OldRow.Key = NewRow.Key And OldRow.BasisKey = NewRow.BasisKey And OldRow.Basis = NewRow.Basis Then
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

		If ValueIsFilled(UnlinkRow.BasisKey) Then
			Filter = New Structure("Key, BasisKey", UnlinkRow.Key, UnlinkRow.BasisKey);
		Else
			Filter = New Structure("Key", UnlinkRow.Key);
		EndIf;

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

Procedure UnlinkAttributes(LinkedRow, AttributeNames, UpdatedProperties)
	For Each AttributeName In AttributeNames Do
		If LinkedRow.Property(AttributeName) Then
			LinkedRow[AttributeName] = Undefined;
			PutToUpdatedProperties(AttributeName, "ItemList", LinkedRow, UpdatedProperties, True);
		EndIf;
	EndDo;
EndProcedure

#EndRegion

#Region Link

Procedure Link(Object, FillingValue, LinkRows, TableNames, UpdatedProperties, UpdatedRows)
	For Each LinkRow In LinkRows Do
		ArrayOfExcludingKeys = New Array();
		// Update ItemList row
		LinkAttributes(Object, FillingValue, LinkRow, ArrayOfExcludingKeys, UpdatedProperties, UpdatedRows);
		
		// Update tables
		LinkTables(Object, FillingValue, LinkRow, TableNames, ArrayOfExcludingKeys);
	EndDo;
EndProcedure

Function GetLinkRows(Object, FillingValue)
	LinkRows = New Array();
	For Each NewRow In FillingValue.RowIDInfo Do
		IsLink = True;
		For Each OldRow In Object.RowIDInfo Do
			If NewRow.Key = OldRow.Key And NewRow.BasisKey = OldRow.BasisKey And NewRow.Basis = OldRow.Basis Then
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

Procedure LinkTables(Object, FillingValue, LinkRow, TableNames, ArrayOfExcludingKeys)
	For Each TableName In TableNames Do
		If Upper(TableName) = Upper("RowIDInfo") Then
			Continue;
		EndIf;
		If Object.Property(TableName) Then
			If Object[TableName].Count() And CommonFunctionsClientServer.ObjectHasProperty(Object[TableName][0], "Key") Then
				For Each DeletionRow In Object[TableName].FindRows(New Structure("Key", LinkRow.Key)) Do
					If Upper(TableName) = Upper("SpecialOffers") Or Upper(TableName) = Upper("TaxList") Then
						If ArrayOfExcludingKeys.Find(LinkRow.Key) = Undefined Then
							Object[TableName].Delete(DeletionRow);
						EndIf;
					ElsIf Upper(TableName) = Upper("SerialLotNumbers") Then
						If FillingValue.Property(TableName) And FillingValue[TableName].Count() Then
							Object[TableName].Delete(DeletionRow);
						EndIf;
					Else
						Object[TableName].Delete(DeletionRow);
					EndIf;
				EndDo;
			EndIf;
		Else
			Continue;
		EndIf;

		If Not FillingValue.Property(TableName) Then
			Continue;
		EndIf;

		For Each Row In FillingValue[TableName] Do
			If Not CommonFunctionsClientServer.ObjectHasProperty(Row, "Key") Then
				Continue;
			EndIf;
			If Row.Key <> LinkRow.Key Then
				Continue;
			EndIf;
			If Upper(TableName) = Upper("SpecialOffers") Or Upper(TableName) = Upper("TaxList") Then
				If ArrayOfExcludingKeys.Find(LinkRow.Key) = Undefined Then
					FillPropertyValues(Object[TableName].Add(), Row);
				EndIf;
			Else
				FillPropertyValues(Object[TableName].Add(), Row);
			EndIf;
		EndDo;
	EndDo;
EndProcedure

Procedure LinkAttributes(Object, FillingValue, LinkRow, ArrayOfExcludingKeys, UpdatedProperties, UpdatedRows)
	ArrayOfRefillColumns = New Array();
	ArrayOfRefillColumns.Add(Upper("TotalAmount"));
	ArrayOfRefillColumns.Add(Upper("NetAmount"));
	ArrayOfRefillColumns.Add(Upper("OffersAmount"));
	ArrayOfRefillColumns.Add(Upper("TaxAmount"));
	ArrayOfRefillColumns.Add(Upper("PriceType"));

	ArrayOfNotRefilingColumns = GetNotRefilingColumns(TypeOf(Object.Ref));

	For Each Row_ItemList In FillingValue.ItemList Do
		If LinkRow.Key <> Row_ItemList.Key Then
			Continue;
		EndIf;
		For Each Row In Object.ItemList.FindRows(New Structure("Key", LinkRow.Key)) Do
			IsLinked = False;
			NeedRefillColumns = True;

			For Each KeyValue In Row_ItemList Do
				PropertyName = TrimAll(KeyValue.Key);
				PropertyValue = KeyValue.Value;
				If Upper(PropertyName) = Upper("Price") And Row.Property("Price") And ValueIsFilled(Row.Price)
					And Row.Property("PriceType") And Row.PriceType = Catalogs.PriceTypes.ManualPriceType Then
					NeedRefillColumns = False;
					ArrayOfExcludingKeys.Add(Row_ItemList.Key);
					Continue;
				EndIf;

				If ArrayOfRefillColumns.Find(Upper(PropertyName)) = Undefined And Row.Property(PropertyName) Then
					If ArrayOfNotRefilingColumns <> Undefined 
						And ArrayOfNotRefilingColumns.Find(Upper("ItemList." + PropertyName)) <> Undefined Then
						PutToUpdatedProperties(PropertyName, "ItemList", Row, UpdatedProperties);
						Continue;
					EndIf;
					Row[PropertyName] = PropertyValue;
					
					PutToUpdatedProperties(PropertyName, "ItemList", Row, UpdatedProperties);
					IsLinked = True;
				EndIf;
			EndDo;

			If NeedRefillColumns Then
				For Each RefillColumn In ArrayOfRefillColumns Do
					If Row.Property(RefillColumn) And Row_ItemList.Property(RefillColumn) Then
						Row[RefillColumn] = Row_ItemList[RefillColumn]; // ???
						PropertyName = TrimAll(RefillColumn);
						PutToUpdatedProperties(PropertyName, "ItemList", Row, UpdatedProperties);
						IsLinked = True;
					EndIf;
				EndDo;
			EndIf;
			
			If IsLinked Then
				UpdatedRows.Add(Row);
			EndIf;
		EndDo;

	EndDo;
EndProcedure

Function GetNotRefilingColumns(ObjectType)
	Map = New Map();
	ArrayOfColumns = New Array();
	ArrayOfColumns.Add(Upper("ItemList.ProfitLossCenter"));
	ArrayOfColumns.Add(Upper("ItemList.RevenueType"));
	Map.Insert(Type("DocumentRef.StockAdjustmentAsSurplus"), ArrayOfColumns);

	ArrayOfColumns = New Array();
	ArrayOfColumns.Add(Upper("ItemList.ProfitLossCenter"));
	ArrayOfColumns.Add(Upper("ItemList.ExpenseType"));
	Map.Insert(Type("DocumentRef.StockAdjustmentAsWriteOff"), ArrayOfColumns);
	
	ArrayOfColumns = New Array();
	ArrayOfColumns.Add(Upper("ItemList.Store"));
	Map.Insert(Type("DocumentRef.RetailReturnReceipt"), ArrayOfColumns);
	
	ArrayOfColumns = New Array();
	ArrayOfColumns.Add(Upper("ItemList.Store"));
	Map.Insert(Type("DocumentRef.SalesReturn"), ArrayOfColumns);
	
	Return Map.Get(ObjectType);
EndFunction

#EndRegion

#EndRegion

#Region DataToFillingValues

Function GetSeparatorColumns(DocReceiverMetadata, NameAsAlias = False) Export
	If DocReceiverMetadata = Metadata.Documents.SalesInvoice Then
		Return "Company, Branch, Partner, Currency, Agreement, PriceIncludeTax, ManagerSegment, LegalName" 
				+ ?(NameAsAlias, ", TransactionTypeSales", ", TransactionType");
	
	ElsIf DocReceiverMetadata = Metadata.Documents.RetailSalesReceipt Then
		Return "Company, Branch, RetailCustomer, Partner, LegalName, Agreement, Currency, PriceIncludeTax";
				
	ElsIf DocReceiverMetadata = Metadata.Documents.ShipmentConfirmation Then
		Return "Company, Branch, Partner, LegalName, TransactionType";
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseOrder Then
		Return "Company, Branch"
		       + ?(NameAsAlias, ", TransactionTypePurchases", ", TransactionType");

	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseInvoice Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax"
				+ ?(NameAsAlias, ", TransactionTypePurchases", ", TransactionType");
				
	ElsIf DocReceiverMetadata = Metadata.Documents.GoodsReceipt Then
		Return "Company, Branch, Partner, LegalName, TransactionType";
	ElsIf DocReceiverMetadata = Metadata.Documents.InventoryTransfer Then
		Return "Company, Branch, StoreSender, StoreReceiver";
	ElsIf DocReceiverMetadata = Metadata.Documents.InventoryTransferOrder Then
		Return "Company, Branch, StoreReceiver";
	ElsIf DocReceiverMetadata = Metadata.Documents.StockAdjustmentAsSurplus Then
		Return "Company, Branch, Store";
	ElsIf DocReceiverMetadata = Metadata.Documents.StockAdjustmentAsWriteOff Then
		Return "Company, Branch, Store";
	ElsIf DocReceiverMetadata = Metadata.Documents.SalesReturn Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax"
				+ ?(NameAsAlias, ", TransactionTypeSR", ", TransactionType");
	
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseReturn Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax"
				+ ?(NameAsAlias, ", TransactionTypePR", ", TransactionType");
				
	ElsIf DocReceiverMetadata = Metadata.Documents.SalesReturnOrder Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax"
				+ ?(NameAsAlias, ", TransactionTypeSR", ", TransactionType");
	
	ElsIf DocReceiverMetadata = Metadata.Documents.PurchaseReturnOrder Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax"
				+ ?(NameAsAlias, ", TransactionTypePR", ", TransactionType");
				
	ElsIf DocReceiverMetadata = Metadata.Documents.RetailReturnReceipt Then
		Return "Company, Branch, Partner, LegalName, Agreement, Currency, PriceIncludeTax, RetailCustomer, UsePartnerTransactions, Workstation";
	ElsIf DocReceiverMetadata = Metadata.Documents.PlannedReceiptReservation Then
		Return "Company, Branch, Requester";
	ElsIf DocReceiverMetadata = Metadata.Documents.WorkOrder Then
		Return "Company, Branch, Partner, Currency, Agreement, PriceIncludeTax, LegalName, Currency";
	ElsIf DocReceiverMetadata = Metadata.Documents.WorkSheet Then
		Return "Company, Branch, Partner, LegalName, Currency";
	EndIf;
EndFunction

Function ConvertDataToFillingValues(DocReceiverMetadata, ExtractedData) Export

	Tables = JoinAllExtractedData(ExtractedData);

	TableNames_Refreshable = GetTableNames_Refreshable();

	SeparatorColumns = GetSeparatorColumns(DocReceiverMetadata, True);

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
		
		tmpTable_ShipmentConfirmations = GetEmptyTable_ShipmentConfirmations();
		tmpTable_GoodsReceipts         = GetEmptyTable_GoodsReceipts();
		tmpTable_WorkSheets            = GetEmptyTable_WorkSheets();
		tmpTable_RowIDInfo             = GetEmptyTable_RowIDInfo();
		tmpTable_Materials             = GetEmptyTable_Materials();
		
		For Each TableFilter In TablesFilters Do
			For Each TableName_Refreshable In TableNames_Refreshable Do
				If Not CommonFunctionsClientServer.ObjectHasProperty(Tables, TableName_Refreshable) Then
					Continue;
				EndIf;

				If Tables[TableName_Refreshable].Columns.Find("Key") = Undefined Then
					Continue;
				Else
					DepTable = Tables[TableName_Refreshable].Copy(TableFilter);
				EndIf;

				For Each Row_DepTable In DepTable Do
					If Upper(TableName_Refreshable) = Upper("ShipmentConfirmations") Then
						FillPropertyValues(tmpTable_ShipmentConfirmations.Add(), Row_DepTable);
					ElsIf Upper(TableName_Refreshable) = Upper("GoodsReceipts") Then
						FillPropertyValues(tmpTable_GoodsReceipts.Add(), Row_DepTable);
					ElsIf Upper(TableName_Refreshable) = Upper("RowIDInfo") Then
						FillPropertyValues(tmpTable_RowIDInfo.Add(), Row_DepTable);
					ElsIf Upper(TableName_Refreshable) = Upper("Materials") Then
						FillPropertyValues(tmpTable_Materials.Add(), Row_DepTable);
					ElsIf Upper(TableName_Refreshable) = Upper("WorkSheets") Then
						FillPropertyValues(tmpTable_WorkSheets.Add(), Row_DepTable);
					Else
						FillingValues[TableName_Refreshable].Add(ValueTableRowToStructure(Tables[TableName_Refreshable].Columns, Row_DepTable));
					EndIf;
				EndDo;
			EndDo;
		EndDo;
			
		tmpTable_ShipmentConfirmations.GroupBy((GetColumnNames_ShipmentConfirmations() + ", " + GetColumnNamesSum_ShipmentConfirmations()));
		For Each Row_DepTable In tmpTable_ShipmentConfirmations Do
			FillingValues.ShipmentConfirmations.Add(ValueTableRowToStructure(Tables.ShipmentConfirmations.Columns, Row_DepTable));
		EndDo;
	
		tmpTable_GoodsReceipts.GroupBy((GetColumnNames_GoodsReceipts() + ", " + GetColumnNamesSum_GoodsReceipts()));
		For Each Row_DepTable In tmpTable_GoodsReceipts Do
			FillingValues.GoodsReceipts.Add(ValueTableRowToStructure(Tables.GoodsReceipts.Columns, Row_DepTable));
		EndDo;
		
		tmpTable_WorkSheets.GroupBy((GetColumnNames_WorkSheets() + ", " + GetColumnNamesSum_WorkSheets()));
		For Each Row_DepTable In tmpTable_WorkSheets Do
			FillingValues.WorkSheets.Add(ValueTableRowToStructure(Tables.WorkSheets.Columns, Row_DepTable));
		EndDo;
		
		tmpTable_RowIDInfo.GroupBy((GetColumnNames_RowIDInfo() + ", " + GetColumnNamesSum_RowIDInfo()));
		For Each Row_DepTable In tmpTable_RowIDInfo Do
			FillingValues.RowIDInfo.Add(ValueTableRowToStructure(Tables.RowIDInfo.Columns, Row_DepTable));
		EndDo;
		
		tmpTable_Materials.GroupBy((GetColumnNames_Materials() + ", " + GetColumnNamesSum_Materials()));
		For Each Row_DepTable In tmpTable_Materials Do
			MaterialsRow = ValueTableRowToStructure(Tables.Materials.Columns, Row_DepTable);
			MaterialsRow.KeyOwner = MaterialsRow.Key;
			MaterialsRow.Key = String(New UUID()); 
			FillingValues.Materials.Add(MaterialsRow);
		EndDo;
		
		For Each TableName_Refreshable In TableNames_Refreshable Do
			If Not CommonFunctionsClientServer.ObjectHasProperty(Tables, TableName_Refreshable) Then
				Continue;
			EndIf;

			If Tables[TableName_Refreshable].Columns.Find("Key") = Undefined Then
				DepTable = Tables[TableName_Refreshable].Copy();
			Else
				Continue;
			EndIf;

			For Each Row_DepTable In DepTable Do
				FillingValues[TableName_Refreshable].Add(ValueTableRowToStructure(Tables[TableName_Refreshable].Columns, Row_DepTable));
			EndDo;
		EndDo;
		
		For Each Payment In Tables.Payments Do
			FillingValues.Payments.Add(ValueTableRowToStructure(Tables.Payments.Columns, Payment));
		EndDo;
		
		FillingValues.Insert("BasedOn", True);
		
		ReplaceAliasToAttributeName(FillingValues, "TransactionTypeSales"     , "TransactionType");
		ReplaceAliasToAttributeName(FillingValues, "TransactionTypeSR"        , "TransactionType");
		ReplaceAliasToAttributeName(FillingValues, "TransactionTypePurchases" , "TransactionType");
		ReplaceAliasToAttributeName(FillingValues, "TransactionTypePR"        , "TransactionType");
		
		ArrayOfFillingValues.Add(FillingValues);
	EndDo;
	Return ArrayOfFillingValues;
EndFunction

Procedure ReplaceAliasToAttributeName(FillingValues, Alias, AttributeName)
	If FillingValues.Property(Alias) Then
		PropertyValue = FillingValues[Alias];
		FillingValues.Delete(Alias);
		FillingValues.Insert(AttributeName, PropertyValue);
	EndIf;
EndProcedure

Function JoinAllExtractedData(ArrayOfData)
	Tables = New Structure();
	Tables.Insert("ItemList"              , GetEmptyTable_ItemList());
	Tables.Insert("RowIDInfo"             , GetEmptyTable_RowIDInfo());
	Tables.Insert("TaxList"               , GetEmptyTable_TaxList());
	Tables.Insert("SpecialOffers"         , GetEmptyTable_SpecialOffers());
	Tables.Insert("ShipmentConfirmations" , GetEmptyTable_ShipmentConfirmations());
	Tables.Insert("GoodsReceipts"         , GetEmptyTable_GoodsReceipts());
	Tables.Insert("WorkSheets"            , GetEmptyTable_WorkSheets());
	Tables.Insert("SerialLotNumbers"      , GetEmptyTable_SerialLotNumbers());
	Tables.Insert("Payments"              , GetEmptyTable_Payments());
	Tables.Insert("Materials"             , GetEmptyTable_Materials());
	Tables.Insert("SourceOfOrigins"       , GetEmptyTable_SourceOfOrigins());
	
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
	NamesArray = New Array();
	NamesArray.Add("RowIDInfo");
	NamesArray.Add("TaxList");
	NamesArray.Add("SpecialOffers");
	NamesArray.Add("ShipmentConfirmations");
	NamesArray.Add("GoodsReceipts");
	NamesArray.Add("WorkSheets");
	NamesArray.Add("SerialLotNumbers");
	NamesArray.Add("Payments");
	NamesArray.Add("Materials");
	NamesArray.Add("SourceOfOrigins");
	Return NamesArray;
EndFunction

Function GetTableNames_LinkedDocuments()
	NamesArray = New Array();
	NamesArray.Add("ShipmentConfirmations");
	NamesArray.Add("GoodsReceipts");
	NamesArray.Add("WorkSheets");
	Return NamesArray;
EndFunction

Function GetAttributeNames_LinkedDocuments()
	NamesArray = New Array();
	NamesArray.Add("SalesOrder");
	NamesArray.Add("ShipmentBasis");
	NamesArray.Add("PurchaseBasis");
	NamesArray.Add("SalesInvoice");
	NamesArray.Add("PurchaseOrder");
	NamesArray.Add("ReceiptBasis");
	NamesArray.Add("PurchaseInvoice");
	NamesArray.Add("InternalSupplyRequest");
	NamesArray.Add("InventoryTransferOrder");
	NamesArray.Add("InventoryTransfer");
	NamesArray.Add("PhysicalInventory");
	NamesArray.Add("BasisDocument");
	NamesArray.Add("PurchaseReturn");
	NamesArray.Add("PurchaseReturnOrder");
	NamesArray.Add("SalesReturn");
	NamesArray.Add("SalesReturnOrder");
	NamesArray.Add("RetailSalesReceipt");
	NamesArray.Add("WorkOrder");
	NamesArray.Add("ProductionPlanning");
	Return NamesArray;
EndFunction

Procedure CopyTable(Receiver, Source)
	For Each Row In Source Do
		FillPropertyValues(Receiver.Add(), Row);
	EndDo;
EndProcedure

Function ValueTableRowToStructure(Columns, Row)
	Result = New Structure();
	For Each Column In Columns Do
		Result.Insert(Column.Name, Row[Column.Name]);
	EndDo;
	Return Result;
EndFunction

#Region EmptyTables

Function GetEmptyTable(Columns)
	Table = New ValueTable();
	For Each Column In StrSplit(Columns, ",") Do
		Table.Columns.Add(TrimAll(Column));
	EndDo;
	Return Table;
EndFunction

#Region EmptyTables_ItemList

Function GetColumnNames_ItemList()
	Return "Ref,
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
		   |PurchaseBasis,
		   |ShipmentBasis,
		   |SalesInvoice,
		   |PurchaseOrder,
		   |ReceiptBasis,
		   |PurchaseInvoice,
		   |Requester,
		   |Unit,
		   |PriceType,
		   |Price,
		   |DeliveryDate,
		   |DontCalculateRow,
		   |Branch,
		   |ProfitLossCenter,
		   |RevenueType,
		   |ExpenseType,
		   |Detail,
		   |UseShipmentConfirmation,
		   |UseGoodsReceipt,
		   |TransactionType,
		   |InternalSupplyRequest,
		   |InventoryTransferOrder,
		   |InventoryTransfer,
		   |StoreSender,
		   |StoreReceiver,
		   |PhysicalInventory,
		   |BasisDocument,
		   |PurchaseReturn,
		   |PurchaseReturnOrder,
		   |SalesReturn,
		   |SalesReturnOrder,
		   |RetailSalesReceipt,
		   |AdditionalAnalytic,
		   |RetailCustomer,
		   |UsePartnerTransactions,
		   |LegalNameContract,
		   |SalesPerson,
		   |Workstation,
		   |WorkOrder,
		   |WorkSheet,
		   |BillOfMaterials,
		   |UseWorkSheet,
		   |ProductionPlanning,
		   |TransactionTypeSales,
		   |TransactionTypeSR,
		   |TransactionTypePurchases,
		   |TransactionTypePR,
		   |InventoryOrigin";
EndFunction

Function GetEmptyTable_ItemList()
	Return GetEmptyTable(GetColumnNames_ItemList() + ", " + GetColumnNamesSum_ItemList());
EndFunction

Function GetColumnNamesSum_ItemList()
	Return "Quantity, QuantityInBaseUnit, TaxAmount, TotalAmount, NetAmount, OffersAmount";
EndFunction

#EndRegion

#Region EmptyTables_RowIDInfo

Function GetColumnNames_RowIDInfo()
	Return "Ref, Key, RowID, BasisKey, Basis, CurrentStep, NextStep, RowRef";
EndFunction

Function GetColumnNamesSum_RowIDInfo()
	Return "Quantity";
EndFunction

Function GetEmptyTable_RowIDInfo()
	Return GetEmptyTable(GetColumnNames_RowIDInfo() + ", " + GetColumnNamesSum_RowIDInfo());
EndFunction

#EndRegion

#Region EmptyTables_TaxList

Function GetColumnNames_TaxList()
	Return "Ref, Key, Tax, Analytics, TaxRate, IncludeToTotalAmount";
EndFunction

Function GetColumnNamesSum_TaxList()
	Return "Amount, ManualAmount";
EndFunction

Function GetEmptyTable_TaxList()
	Return GetEmptyTable(GetColumnNames_TaxList() + ", " + GetColumnNamesSum_TaxList());
EndFunction

#EndRegion

#Region EmptyTables_SpecialOffers

Function GetColumnNames_SpecialOffers()
	Return "Ref, Key, Offer, Percent";
EndFunction

Function GetColumnNamesSum_SpecialOffers()
	Return "Amount";
EndFunction

Function GetEmptyTable_SpecialOffers()
	Return GetEmptyTable(GetColumnNames_SpecialOffers() + ", " + GetColumnNamesSum_SpecialOffers());
EndFunction

#EndRegion

#Region EmptyTables_ShipmentConfirmations

Function GetColumnNames_ShipmentConfirmations()
	Return "Ref, Key, BasisKey, ShipmentConfirmation";
EndFunction

Function GetColumnNamesSum_ShipmentConfirmations()
	Return "Quantity, QuantityInShipmentConfirmation";
EndFunction

Function GetEmptyTable_ShipmentConfirmations()
	Return GetEmptyTable(GetColumnNames_ShipmentConfirmations() + ", " + GetColumnNamesSum_ShipmentConfirmations());
EndFunction

#EndRegion

#Region EmptyTables_GoodsReceipts

Function GetColumnNames_GoodsReceipts()
	Return "Ref, Key, BasisKey, GoodsReceipt";
EndFunction

Function GetColumnNamesSum_GoodsReceipts()
	Return "Quantity, QuantityInGoodsReceipt";
EndFunction

Function GetEmptyTable_GoodsReceipts()
	Return GetEmptyTable(GetColumnNames_GoodsReceipts() + ", " + GetColumnNamesSum_GoodsReceipts());
EndFunction

#EndRegion

#Region EmptyTables_WorkSheets

Function GetColumnNames_WorkSheets()
	Return "Ref, Key, BasisKey, WorkSheet";
EndFunction

Function GetColumnNamesSum_WorkSheets()
	Return "Quantity, QuantityInWorkSheet";
EndFunction

Function GetEmptyTable_WorkSheets()
	Return GetEmptyTable(GetColumnNames_WorkSheets() + ", " + GetColumnNamesSum_WorkSheets());
EndFunction

#EndRegion

#Region EmptyTables_SerialLotNumbers

Function GetColumnNames_SerialLotNumbers()
	Return "Ref, Key, SerialLotNumber";
EndFunction

Function GetColumnNamesSum_SerialLotNumbers()
	Return "Quantity";
EndFunction

Function GetEmptyTable_SerialLotNumbers()
	Return GetEmptyTable(GetColumnNames_SerialLotNumbers() + ", " + GetColumnNamesSum_SerialLotNumbers());
EndFunction

#EndRegion

#Region EmptyTables_Payments

Function GetColumnNames_Payments()
	Return "Key, Ref, PaymentType, PaymentTerminal, Account, Percent, BankTerm, RRNCode, PaymentInfo";
EndFunction

Function GetColumnNamesSum_Payments()
	Return "Amount, Commission";
EndFunction

Function GetEmptyTable_Payments()
	Return GetEmptyTable(GetColumnNames_Payments() + ", " + GetColumnNamesSum_Payments());
EndFunction

#EndRegion

#Region EmptyTables_Materials

Function GetColumnNames_Materials()
	Return 
		"Key,
		|Ref,
		|KeyOwner,
		|Item,
		|ItemKey,
		|Store,
		|Unit,
		|ItemBOM,
		|ItemKeyBOM,
		|UnitBOM,
		|CostWriteOff,
		|BillOfMaterials,
		|UniqueID";
EndFunction

Function GetColumnNamesSum_Materials()
	Return "Quantity, QuantityBOM";
EndFunction

Function GetEmptyTable_Materials()
	Return GetEmptyTable(GetColumnNames_Materials() + ", " + GetColumnNamesSum_Materials());
EndFunction

#EndRegion

#Region EmptyTables_SourceOfOrigins

Function GetColumnNames_SourceOfOrigins()
	Return "Key, Ref, SerialLotNumber, SourceOfOrigin";
EndFunction

Function GetColumnNamesSum_SourceOfOrigins()
	Return "Quantity";
EndFunction

Function GetEmptyTable_SourceOfOrigins()
	Return GetEmptyTable(GetColumnNames_SourceOfOrigins() + ", " + GetColumnNamesSum_SourceOfOrigins());
EndFunction

#EndRegion


#EndRegion

#EndRegion

#Region BasisesTree

Procedure CreateBasisesTree(TreeReverseInfo, BasisesTable, ResultsTable, BasisesTreeRows) Export
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
		Return;
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
		
		If NewBasisesTreeRow.Property("DocRef") Then
			NewBasisesTreeRow.DocRef = RowBasis.Basis;
		EndIf;
		
		FillPropertyValues(NewBasisesTreeRow, RowBasis);

		For Each RowFilter In FilterTable.FindRows(New Structure("Basis", RowBasis.Basis)) Do

			ParentFilter = New Structure("Level, BasisKey, RowID, RowRef");
			FillPropertyValues(ParentFilter, RowFilter);
			ParentRows = TreeReverse.Rows.FindRows(ParentFilter, True);

			If Not ParentRows.Count() Then
				BasisesFilter = New Structure();
				BasisesFilter.Insert("BasisKey", RowFilter.BasisKey);
				BasisesFilter.Insert("RowID", RowFilter.RowID);
				BasisesFilter.Insert("RowRef", RowFilter.RowRef);
				BasisesFilter.Insert("Basis", RowFilter.Basis);
				For Each TableRow In BasisesTable.FindRows(BasisesFilter) Do
					
					// deep level
					NewBasisesTreeRow.Picture = 2;
					NewBasisesTreeRow.IsMainDocument = True;
					DeepLevelRow = NewBasisesTreeRow.GetItems().Add();
					DeepLevelRow.Picture = 0;
					DeepLevelRow.RowPresentation = String(TableRow.Item) + " (" + String(TableRow.ItemKey) + ")";

					DeepLevelRow.DeepLevel = True;
					FillPropertyValues(DeepLevelRow, TableRow);
					
					// price, currency, unit
					BasisesInfoFilter = New Structure("RowID", TableRow.RowID);
					For Each InfoRow In TreeReverseInfo.BasisesInfoTable.FindRows(BasisesInfoFilter) Do
						FillPropertyValues(DeepLevelRow, InfoRow);
					EndDo;

					DeepLevelRow.Quantity = Catalogs.Units.Convert(DeepLevelRow.BasisUnit, DeepLevelRow.Unit,
						DeepLevelRow.QuantityInBaseUnit);
					ResultsFilter = New Structure();
					ResultsFilter.Insert("RowID", DeepLevelRow.RowID);
					ResultsFilter.Insert("BasisKey", DeepLevelRow.Key);
					ResultsFilter.Insert("Basis", DeepLevelRow.Basis);
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
EndProcedure

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

Function GetBasisesInfo(Basis, BasisKey, RowID) Export
	Query = New Query();
	Query.Text = 
		"SELECT
		|	RowIDInfo.Recorder AS Basis,
		|	RowIDInfo.RowRef AS RowRef,
		|	RowIDInfo.BasisKey AS BasisKey,
		|	RowIDInfo.RowID AS RowID,
		|	RowIDInfo.Basis AS ParentBasis,
		|	RowIDInfo.Key AS Key,
		|	RowIDInfo.Price AS Price,
		|	RowIDInfo.Currency AS Currency,
		|	RowIDInfo.Unit AS Unit
		|FROM
		|	InformationRegister.T3010S_RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Recorder = &Basis
		|	AND RowIDInfo.Key = &BasisKey
		|	AND RowIDInfo.RowID = &RowID";
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

Procedure CreateChildrenTree(Basis, BasisKey, RowID, ChildrenTreeRows) Export
	ArrayOfChildrenInfo = GetChildrenInfo(Basis, BasisKey, RowID);
	For Each ChildrenInfo In ArrayOfChildrenInfo Do
		NewChildrenTreeRow = ChildrenTreeRows.Add();
		NewChildrenTreeRow.Picture = 1;
		NewChildrenTreeRow.RowPresentation = String(ChildrenInfo.Children);
		If NewChildrenTreeRow.Property("DocRef") Then
			NewChildrenTreeRow.DocRef = ChildrenInfo.Children;
		EndIf;
		CreateChildrenTree(ChildrenInfo.Children, ChildrenInfo.BasisKey, ChildrenInfo.RowID, 
			NewChildrenTreeRow.GetItems());
	EndDo;
EndProcedure

Function GetChildrenInfo(Basis, BasisKey, RowID) Export
	Query = New Query();
	Query.Text = 
		"SELECT
		|	RowIDInfo.Recorder AS Children,
		|	RowIDInfo.RowRef AS RowRef,
		|	RowIDInfo.RowID AS RowID,
		|	RowIDInfo.Key AS BasisKey
		|FROM 
		|	InformationRegister.T3010S_RowIDInfo AS RowIDInfo
		|WHERE
		|	RowIDInfo.Basis = &Basis
		|	AND RowIDInfo.BasisKey = &BasisKey
		|	AND RowIDInfo.RowID = &RowID";
	Query.SetParameter("Basis"    , Basis);
	Query.SetParameter("BasisKey" , BasisKey);
	Query.SetParameter("RowID"    , RowID);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfChildrenInfo = New Array();
	While QuerySelection.Next() Do
		ChildrenInfo = New Structure("Children, RowRef, RowID, BasisKey");
		FillPropertyValues(ChildrenInfo, QuerySelection);
		ArrayOfChildrenInfo.Add(ChildrenInfo);
	EndDo;
	Return ArrayOfChildrenInfo;
EndFunction

#EndRegion

#Region Service

Function DocAliases()
	Result = New Structure();
	Result.Insert("SO"  , "SalesOrder");
	Result.Insert("SI"  , "SalesInvoice");
	Result.Insert("SC"  , "ShipmentConfirmation");
	Result.Insert("PO"  , "PurchaseOrder");
	Result.Insert("PI"  , "PurchaseInvoice");
	Result.Insert("GR"  , "GoodsReceipt");
	Result.Insert("ITO" , "InventoryTransferOrder");
	Result.Insert("IT"  , "InventoryTransfer");
	Result.Insert("ISR" , "InternalSupplyRequest");
	Result.Insert("PR"  , "PurchaseReturn");
	Result.Insert("PRO" , "PurchaseReturnOrder");
	Result.Insert("SR"  , "SalesReturn");
	Result.Insert("SRO" , "SalesReturnOrder");
	Result.Insert("RSR" , "RetailSalesReceipt");
	Result.Insert("RRR" , "RetailReturnReceipt");
	Result.Insert("PRR" , "PlannedReceiptReservation");
	Result.Insert("PhysicalInventory"         , "PhysicalInventory");
	Result.Insert("StockAdjustmentAsSurplus"  , "StockAdjustmentAsSurplus");
	Result.Insert("StockAdjustmentAsWriteOff" , "StockAdjustmentAsWriteOff");
	Result.Insert("WO", "WorkOrder");
	Result.Insert("WS", "WorkSheet");
	
	Return Result;
EndFunction

Function Is(Source)
	TypeOf = TypeOf(Source);
	Result = New Structure();
	Result.Insert("SO",
		TypeOf = Type("DocumentObject.SalesOrder")
		Or TypeOf = Type("DocumentRef.SalesOrder"));
	Result.Insert("SI",
		TypeOf = Type("DocumentObject.SalesInvoice")
		Or TypeOf = Type("DocumentRef.SalesInvoice"));
	Result.Insert("SC",
		TypeOf = Type("DocumentObject.ShipmentConfirmation")
		Or TypeOf = Type("DocumentRef.ShipmentConfirmation"));
	Result.Insert("PO",
		TypeOf = Type("DocumentObject.PurchaseOrder")
		Or TypeOf = Type("DocumentRef.PurchaseOrder"));
	Result.Insert("PI",
		TypeOf = Type("DocumentObject.PurchaseInvoice")
		Or TypeOf = Type("DocumentRef.PurchaseInvoice"));
	Result.Insert("GR",
		TypeOf = Type("DocumentObject.GoodsReceipt")
		Or TypeOf = Type("DocumentRef.GoodsReceipt"));
	Result.Insert("ITO",
		TypeOf = Type("DocumentObject.InventoryTransferOrder")
		Or TypeOf = Type("DocumentRef.InventoryTransferOrder"));
	Result.Insert("IT",
		TypeOf = Type("DocumentObject.InventoryTransfer")
		Or TypeOf = Type("DocumentRef.InventoryTransfer"));
	Result.Insert("ISR",
		TypeOf = Type("DocumentObject.InternalSupplyRequest")
		Or TypeOf = Type("DocumentRef.InternalSupplyRequest"));
	Result.Insert("PhysicalInventory",
		TypeOf = Type("DocumentObject.PhysicalInventory")
		Or TypeOf = Type("DocumentRef.PhysicalInventory"));
	Result.Insert("StockAdjustmentAsSurplus",
		TypeOf = Type("DocumentObject.StockAdjustmentAsSurplus")
		Or TypeOf = Type("DocumentRef.StockAdjustmentAsSurplus"));
	Result.Insert("StockAdjustmentAsWriteOff",
		TypeOf = Type("DocumentObject.StockAdjustmentAsWriteOff")
		Or TypeOf = Type("DocumentRef.StockAdjustmentAsWriteOff"));
	Result.Insert("PR",
		TypeOf = Type("DocumentObject.PurchaseReturn")
		Or TypeOf = Type("DocumentRef.PurchaseReturn"));
	Result.Insert("PRO",
		TypeOf = Type("DocumentObject.PurchaseReturnOrder")
		Or TypeOf = Type("DocumentRef.PurchaseReturnOrder"));
	Result.Insert("SR",
		TypeOf = Type("DocumentObject.SalesReturn")
		Or TypeOf = Type("DocumentRef.SalesReturn"));
	Result.Insert("SRO",
		TypeOf = Type("DocumentObject.SalesReturnOrder")
		Or TypeOf = Type("DocumentRef.SalesReturnOrder"));
	Result.Insert("RSR",
		TypeOf = Type("DocumentObject.RetailSalesReceipt")
		Or TypeOf = Type("DocumentRef.RetailSalesReceipt"));
	Result.Insert("RRR",
		TypeOf = Type("DocumentObject.RetailReturnReceipt")
		Or TypeOf = Type("DocumentRef.RetailReturnReceipt"));
	Result.Insert("PRR",
		TypeOf = Type("DocumentObject.PlannedReceiptReservation")
		Or TypeOf = Type("DocumentRef.PlannedReceiptReservation"));
	Result.Insert("SOC",
		TypeOf = Type("DocumentObject.SalesOrderClosing")
		Or TypeOf = Type("DocumentRef.SalesOrderClosing"));
	Result.Insert("POC",
		TypeOf = Type("DocumentObject.PurchaseOrderClosing")
		Or TypeOf = Type("DocumentRef.PurchaseOrderClosing"));
	Result.Insert("WO",
		TypeOf = Type("DocumentObject.WorkOrder")
		Or TypeOf = Type("DocumentRef.WorkOrder"));	
	Result.Insert("WS",
		TypeOf = Type("DocumentObject.WorkSheet")
		Or TypeOf = Type("DocumentRef.WorkSheet"));	
		
	Return Result;
EndFunction

Function ConvertQuantityToQuantityInBaseUnit(ItemKey, Unit, Quantity) Export
	Return Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(ItemKey, Unit, Quantity);
EndFunction

#EndRegion

#Region LockLinkedRows

Function LinkedRowsIntegrityIsEnable() Export
	Return RowIDInfoServerReuse.LinkedRowsIntegrityIsEnable();
EndFunction

#Region EventHandlers

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	If Form.Parameters.Key.IsEmpty() Then
		LockLinkedRows(Object, Form);
	EndIf;
	SetAppearance(Object, Form);	
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	LockLinkedRows(Object, Form);		
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	LockLinkedRows(Object, Form);
EndProcedure

Procedure FillCheckProcessing(Object, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable) Export
	If Not LinkedRowsIntegrityIsEnable() Then
		Return;
	EndIf;
	// check internal links
	Query = New Query();
	Query.TempTablesManager = New TempTablesManager();
	Query.Text =
	"SELECT
	|	BasisesTable.RowID,
	|	BasisesTable.RowRef,
	|	BasisesTable.Basis,
	|	BasisesTable.BasisKey,
	|	BasisesTable.CurrentStep,
	|	BasisesTable.ItemKey,
	|	BasisesTable.Store
	|INTO BasisesTable
	|FROM
	|	&BasisesTable AS BasisesTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfo.Key,
	|	RowIDInfo.RowID,
	|	RowIDInfo.RowRef,
	|	RowIDInfo.Basis,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.CurrentStep
	|INTO RowIDInfo
	|FROM
	|	&RowIDInfo AS RowIDInfo
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Key,
	|	ItemList.LineNumber,
	|	ItemList.ItemKey,
	|	ItemList.Store
	|INTO ItemList
	|FROM
	|	&ItemList AS ItemList
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MIN(RowIDInfo.Key) AS Key,
	|	RowIDInfo.RowID,
	|	RowIDInfo.RowRef,
	|	RowIDInfo.Basis,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.CurrentStep
	|INTO RowIDInfoGrouped
	|FROM
	|	RowIDInfo AS RowIDInfo
	|WHERE
	|	RowIDInfo.CurrentStep <> VALUE(Catalog.MovementRules.EmptyRef)
	|GROUP BY
	|	RowIDInfo.Basis,
	|	RowIDInfo.BasisKey,
	|	RowIDInfo.CurrentStep,
	|	RowIDInfo.RowID,
	|	RowIDInfo.RowRef
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfoGrouped.Key,
	|	RowIDInfoGrouped.RowID,
	|	RowIDInfoGrouped.RowRef,
	|	RowIDInfoGrouped.Basis,
	|	RowIDInfoGrouped.BasisKey,
	|	RowIDInfoGrouped.CurrentStep,
	|	ItemList.ItemKey,
	|	ItemList.Store
	|INTO RowIDInfoFull
	|FROM
	|	RowIDInfoGrouped AS RowIDInfoGrouped
	|		LEFT JOIN ItemList AS ItemList
	|		ON RowIDInfoGrouped.Key = ItemList.Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RowIDInfoFull.Key
	|INTO WrongLinkedRows
	|FROM
	|	RowIDInfoFull AS RowIDInfoFull
	|		LEFT JOIN BasisesTable AS BasisesTable
	|		ON RowIDInfoFull.RowID = BasisesTable.RowID
	|		AND RowIDInfoFull.RowRef = BasisesTable.RowRef
	|		AND RowIDInfoFull.Basis = BasisesTable.Basis
	|		AND RowIDInfoFull.BasisKey = BasisesTable.BasisKey
	|		AND RowIDInfoFull.CurrentStep = BasisesTable.CurrentStep
	|		AND RowIDInfoFull.ItemKey = BasisesTable.ItemKey
	|		AND CASE
	|			WHEN &Filter_Store then
	|				case 
	|					when RowIDInfoFull.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Product) then 
	|						RowIDInfoFull.Store = BasisesTable.Store
	|					else True 
	|				end
	|			ELSE TRUE
	|		END
	|WHERE
	|	BasisesTable.RowID IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.ItemKey,
	|	ItemList.LineNumber
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN WrongLinkedRows AS WrongLinkedRows
	|		ON ItemList.Key = WrongLinkedRows.Key"; 

	BasisesTable = GetBasises(Object.Ref, LinkedFilter);
	Query.SetParameter("BasisesTable", BasisesTable);
	Query.SetParameter("RowIDInfo", RowIDInfoTable);
	Query.SetParameter("ItemList", ItemListTable);

	Is = Is(Object);
	If Is.RRR Or Is.SR Then
		Query.SetParameter("Filter_Store", False);
	Else
		Query.SetParameter("Filter_Store", True);
	EndIf;
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	For Each Row In QueryTable Do
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_097, 
			Row.LineNumber, Row.ItemKey.Item, Row.ItemKey),
				"ItemList[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].IsInternalLinked", Object);
	EndDo;
EndProcedure

#EndRegion

Procedure LockLinkedRows(Object, Form) Export
	If Not LinkedRowsIntegrityIsEnable() Then
		Return;
	EndIf;
	
	LockInternalLinkedRows(Object, Form);
	If ValueIsFilled(Object.Ref) Then
		LockExternalLinkedRows(Object, Form);
	EndIf;
EndProcedure

Procedure UnlockLinkedRows(Object, Form) Export
	ClearAppearance_Header(Object, Form);
	ClearAppearance_ItemList(Object, Form);
EndProcedure

Procedure LockInternalLinkedRows(Object, Form)
	RowIDInfoTable = Object.RowIDInfo.Unload(, "Key, RowID, Basis, BasisKey, RowRef");
	RowIDInfoTable.GroupBy("Key, RowID, Basis, BasisKey, RowRef");
	
	ArrayForDelete = New Array();
	For Each Row In RowIDInfoTable Do
		If Not ValueIsFilled(Row.Basis) Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		RowIDInfoTable.Delete(ItemForDelete);
	EndDo;
	
	InternalLinkedData = GetInternalLinkedKeys(RowIDInfoTable, Object.Ref);
	Form.InternalLinkedDocs.LoadValues(InternalLinkedData.InternalLinkedDocs);
	
	For Each Row In Object.ItemList Do
		Data = InternalLinkedData.Keys.FindRows(New Structure("Key", Row.Key));
		If Data.Count() Then
			Row.IsInternalLinked = True;
			Row.InternalLinks = Data[0].InternalLinks;
		Else
			Row.IsInternalLinked = False;
			Row.InternalLinks = "";			
		EndIf;
	EndDo;
EndProcedure

Procedure LockExternalLinkedRows(Object, Form)
	RowIDInfoTable = Object.RowIDInfo.Unload(, "Key, RowID");
	RowIDInfoTable.GroupBy("Key, RowID");
	For Each Row In Object.ItemList Do
		If Not RowIDInfoTable.FindRows(New Structure("Key", Row.Key)).Count() Then
			NewRow = RowIDInfoTable.Add();
			NewRow.Key = Row.Key;
			NewRow.RowID = Row.Key;
		EndIf;
	EndDo;
	ArrayOfTypes = New Array();
	ArrayOfTypes.Add(TypeOf(Object.Ref));
	RowIDInfoTable.Columns.Add("Basis", New TypeDescription(ArrayOfTypes));
	RowIDInfoTable.Columns.Add("BasisKey", Metadata.DefinedTypes.typeRowID.Type);
	For Each Row In RowIDInfoTable Do
		Row.Basis = Object.Ref;
		Row.BasisKey = Row.Key;
	EndDo;
	
	ExternalLinkedData = GetExternalLinkedKeys(RowIDInfoTable, Object.Ref);
	Form.ExternalLinkedDocs.LoadValues(ExternalLinkedData.ExternalLinkedDocs);
	
	For Each Row In Object.ItemList Do
		Data = ExternalLinkedData.Keys.FindRows(New Structure("Key", Row.Key));
		If Data.Count() Then
			Row.IsExternalLinked = True;
			Row.ExternalLinks = Data[0].ExternalLinks;
		Else
			Row.IsExternalLinked = False;
			Row.ExternalLinks = "";			
		EndIf;
	EndDo;	
EndProcedure

Function GetInternalLinkedKeys(RowIDInfoTable, Ref)
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Key");
	ResultTable.Columns.Add("Recorder");
	
	For Each Row In RowIDInfoTable Do
		If Row.Basis <> Row.RowRef.Basis Then
			GetBasisInfoRecursive(Row.Basis, Row.BasisKey, Row.RowID, ResultTable, Row.Key);
		Else
			NewRow = ResultTable.Add();
			NewRow.Key = Row.Key;
			NewRow.Recorder = Row.Basis;
		EndIf;
	EndDo;
	
	KeysTable = ResultTable.Copy();
	KeysTable.GroupBy("Key");
	KeysTable.Columns.Add("InternalLinks");
	KeysTable.FillValues("", "InternalLinks");
	
	InternalLinkedDocsTable = New ValueTable();
	InternalLinkedDocsTable.Columns.Add("Doc");
	
	DocAliases = DocAliases();
	
	For Each Row In ResultTable Do
		For Each KeyValue In Is(Row.Recorder) Do
			If KeyValue.Value Then
				InternalLinkedDocsTable.Add().Doc = DocAliases[KeyValue.Key];
				KeysTableRow = KeysTable.FindRows(New Structure("Key", Row.Key))[0];
				KeysTableRow.InternalLinks = KeysTableRow.InternalLinks + " " + DocAliases[KeyValue.Key];
				Break;
			EndIf;
		EndDo;
	EndDo;
	InternalLinkedDocsTable.GroupBy("Doc");
	Return New Structure("Keys, InternalLinkedDocs", KeysTable, InternalLinkedDocsTable.UnloadColumn("Doc"));
EndFunction

Procedure GetBasisInfoRecursive(Basis, BasisKey, RowID, ResultTable, Key)
	BasisInfo = GetBasisesInfo(Basis, BasisKey, RowID);
	If BasisInfo.Basis = Undefined Then
		Return;
	EndIf;
	
	If ResultTable.FindRows(New Structure("Recorder", BasisInfo.Basis)).Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_122, RowID) + StrConcat(ResultTable.UnloadColumn("Recorder"), Chars.LF));
	EndIf;
	
	NewRow = ResultTable.Add();
	NewRow.Key = Key;
	NewRow.Recorder = BasisInfo.Basis;
	
	If BasisInfo.Basis <> BasisInfo.RowRef.Basis Then
		NewRow = ResultTable.Add();
		NewRow.Key = Key;
		NewRow.Recorder = BasisInfo.ParentBasis;
		GetBasisInfoRecursive(BasisInfo.Basis, BasisInfo.BasisKey, RowID, ResultTable, Key)
	EndIf;
EndProcedure

Function GetExternalLinkedKeys(RowIDInfoTable, Ref)
	ResultTable = New ValueTable();
	ResultTable.Columns.Add("Key");
	ResultTable.Columns.Add("Recorder");
	
	For Each Row In RowIDInfoTable Do
		GetChildrenInfoRecursive(Row.Basis, Row.BasisKey, Row.RowID, ResultTable, Row.Key);
	EndDo;
	
	KeysTable = ResultTable.Copy();
	KeysTable.GroupBy("Key");
	KeysTable.Columns.Add("ExternalLinks");
	KeysTable.FillValues("", "ExternalLinks");
	
	ExternalLinkedDocsTable = New ValueTable();
	ExternalLinkedDocsTable.Columns.Add("Doc");
	
	DocAliases = DocAliases();
	
	For Each Row In ResultTable Do
		For Each KeyValue In Is(Row.Recorder) Do
			If KeyValue.Value Then
				ExternalLinkedDocsTable.Add().Doc = DocAliases[KeyValue.Key];
				KeysTableRow = KeysTable.FindRows(New Structure("Key", Row.Key))[0];
				KeysTableRow.ExternalLinks = KeysTableRow.ExternalLinks + " " + DocAliases[KeyValue.Key];
				Break;
			EndIf;
		EndDo;
	EndDo;
	ExternalLinkedDocsTable.GroupBy("Doc");
	Return New Structure("Keys, ExternalLinkedDocs", KeysTable, ExternalLinkedDocsTable.UnloadColumn("Doc"));
EndFunction

Procedure GetChildrenInfoRecursive(Basis, BasisKey, RowID, ResultTable, Key)
	ArrayOfChildrenInfo = GetChildrenInfo(Basis, BasisKey, RowID);
	For Each ChildrenInfo In ArrayOfChildrenInfo Do
		NewRow = ResultTable.Add();
		NewRow.Key = Key;
		NewRow.Recorder = ChildrenInfo.Children;
	
		GetChildrenInfoRecursive(ChildrenInfo.Children, ChildrenInfo.BasisKey, RowID, ResultTable, Key);
	EndDo;
EndProcedure

#Region ConditionalAppearance

Procedure SetAppearance(Object, Form) Export
	ClearAppearance_Header(Object, Form);
	ClearAppearance_ItemList(Object, Form);
	FieldsToLock = GetFieldsToLock(Object, Form);
	AddAppearance_Header(Object, Form, FieldsToLock.All);
	AddAppearance_ItemList(Object, Form, FieldsToLock.Internal, "InternalLinks");
	AddAppearance_ItemList(Object, Form, FieldsToLock.External, "ExternalLinks");	
EndProcedure

Procedure ClearAppearance_ItemList(Object, Form) Export
	ArrayForDelete = New Array();
	For Each Row In Form.ConditionalAppearance.Items Do
		If Row.Presentation = "FieldsToLock" Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	For Each ItemForDelete In ArrayForDelete Do
		Form.ConditionalAppearance.Items.Delete(ItemForDelete);
	EndDo;	
EndProcedure

Procedure ClearAppearance_Header(Object, Form) Export
	// Reset ReadOnly
	For Each FieldName In Form.LockedFields Do
		FormElement = Form.Items.Find(FieldName);
		If FormElement <> Undefined Then
			If TypeOf(FormElement) = Type("FormButton") Then
				FormElement.Enabled = True;
			Else
				FormElement.ReadOnly = False;
			EndIf;
		Else
			Raise StrTemplate("Not found form element: %1", FieldName);
		EndIf;
	EndDo;
	Form.LockedFields.Clear();
EndProcedure

Procedure AddAppearance_Header(Object, Form, FieldsToLock)
	// Header
	Element = Form.ConditionalAppearance.Items.Add();
	Element.Presentation = "FieldsToLock";
	
	// Set ReadOnly
	For Each FieldName In FieldsToLock.Header Do
		Element.Fields.Items.Add().Field = New DataCompositionField(FieldName);
		FormElement = Form.Items.Find(FieldName);
		If FormElement <> Undefined Then
			If TypeOf(FormElement) = Type("FormButton") Then
				If FormElement.Enabled Then
					FormElement.Enabled = False;
				EndIf;
			Else 
				If Not FormElement.ReadOnly Then
					FormElement.ReadOnly = True;
				EndIf;
			EndIf;
			Form.LockedFields.Add(FieldName);
		Else
			Raise StrTemplate("Not found form element: %1", FieldName);
		EndIf;
	EndDo;
		
	Element.Appearance.SetParameterValue("TextColor", WebColors.Gray);
EndProcedure

Procedure AddAppearance_ItemList(Object, Form, FieldsToLock, Condition)
	// Item list
	For Each Row In FieldsToLock.ItemList Do
		FieldName = "ItemList" + Row.FieldName;
		FormElement = Form.Items.Find(FieldName);
		If FormElement = Undefined Then
			Raise StrTemplate("Not found form element: %1", FieldName);
		EndIf;
		
		Element = Form.ConditionalAppearance.Items.Add();
		Element.Presentation = "FieldsToLock";
		Element.Fields.Items.Add().Field = New DataCompositionField(FieldName);
	
		Filter = Element.Filter.Items.Add(Type("DataCompositionFilterItem"));
		Filter.LeftValue = New DataCompositionField("Object.ItemList." + Condition);
		Filter.ComparisonType = DataCompositionComparisonType.Contains;
		Filter.RightValue = Row.LinkedDoc;
	
		Element.Appearance.SetParameterValue("BackColor", WebColors.AliceBlue);
		Element.Appearance.SetParameterValue("ReadOnly", True);
	EndDo;
EndProcedure

#EndRegion

#Region FieldsToLock

Function GetFieldsToLock(Object, Form)
	FieldsToLock_ExternalLinkedDocs = New Structure("Header, ItemList", New Array(), New Array());
	FieldsToLock_InternalLinkedDocs = New Structure("Header, ItemList", New Array(), New Array());
	FieldsToLock_All                = New Structure("Header, ItemList", New Array(), New Array());
	
	If ValueIsFilled(Object.Ref) Then
		FieldsToLock_ExternalLinkedDocs = GetFieldsToLock_ExternalLinkedDocs(Object.Ref, Form.ExternalLinkedDocs.UnloadValues());
	EndIf;
		
	FieldsToLock_InternalLinkedDocs = GetFieldsToLock_InternalLinkedDocs(Object.Ref, Form.InternalLinkedDocs.UnloadValues());
	
	AllFields_Header = New ValueTable();
	AllFields_Header.Columns.Add("FieldName");
	For Each Row In FieldsToLock_ExternalLinkedDocs.Header Do
		AllFields_Header.Add().FieldName = Row.FieldName;
	EndDo;
	For Each Row In FieldsToLock_InternalLinkedDocs.Header Do
		AllFields_Header.Add().FieldName = Row.FieldName;
	EndDo;
	AllFields_Header.GroupBy("FieldName");
	FieldsToLock_All.Header = AllFields_Header.UnloadColumn("FieldName");
	
	Return New Structure("External, Internal, All", 
		FieldsToLock_ExternalLinkedDocs, FieldsToLock_InternalLinkedDocs, FieldsToLock_All);
EndFunction

Function GetFieldsToLock_ExternalLinkedDocs(Ref, ArrayOfExternalLinkedDocs)
	Table_ItemList = New ValueTable();
	Table_ItemList.Columns.Add("FieldName");
	Table_ItemList.Columns.Add("LinkedDoc");
	
	Table_Header = New ValueTable();
	Table_Header.Columns.Add("FieldName");
	Table_Header.Columns.Add("LinkedDoc");
	
	Table_RowRefFilter = New ValueTable();
	Table_RowRefFilter.Columns.Add("FieldName");
	Table_RowRefFilter.Columns.Add("LinkedDoc");
	
	Tables = New Structure("Header, ItemList, RowRefFilter", Table_Header, Table_ItemList, Table_RowRefFilter);
	
	Is = Is(Ref);
	DocAliases = DocAliases();
	
	If Is.SO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.PRR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.PI);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.PO);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.SI);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.SC);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.WO);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.WS);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SO, DocAliases.RSR);
	EndIf;
	
	If Is.SI Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SI, DocAliases.SR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SI, DocAliases.SRO);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SI, DocAliases.SC);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SI, DocAliases.WS);		
	EndIf;
	
	If Is.SC Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SC, DocAliases.PR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SC, DocAliases.SI);
	EndIf;
	
	If Is.PO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PO, DocAliases.GR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PO, DocAliases.PI);
	EndIf;
	
	If Is.PI Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PI, DocAliases.GR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PI, DocAliases.PR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PI, DocAliases.PRO);
	EndIf;
	
	If Is.GR Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.GR, DocAliases.PI);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.GR, DocAliases.SR);
	EndIf;
	
	If Is.ITO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.ITO, DocAliases.IT);
	EndIf;
	
	If Is.IT Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.IT, DocAliases.GR);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.IT, DocAliases.SC);
	EndIf;
	
	If Is.ISR Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.ISR, DocAliases.ITO);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.ISR, DocAliases.PI);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.ISR, DocAliases.PO);
	EndIf;
	
	If Is.PhysicalInventory Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PhysicalInventory, DocAliases.StockAdjustmentAsSurplus);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PhysicalInventory, DocAliases.StockAdjustmentAsWriteOff);
	EndIf;
	
	If Is.PR Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PR, DocAliases.SC);
	EndIf;
	
	If Is.PRO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.PRO, DocAliases.PR);
	EndIf;
	
	If Is.SR Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SR, DocAliases.GR);
	EndIf;
	
	If Is.SRO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.SRO, DocAliases.SR);
	EndIf;
	
	If Is.RSR Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.RSR, DocAliases.RRR);
	EndIf;
	
	If Is.WO Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.WO, DocAliases.WS);
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.WO, DocAliases.SI);
	EndIf;
	
	If Is.WS Then
		FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliases.WS, DocAliases.SI);
	EndIf;
	
	Return Tables;
EndFunction

Function GetFieldsToLock_InternalLinkedDocs(Ref, ArrayOfInternalLinkedDocs)
	Table_ItemList = New ValueTable();
	Table_ItemList.Columns.Add("FieldName");
	Table_ItemList.Columns.Add("LinkedDoc");
	
	Table_Header = New ValueTable();
	Table_Header.Columns.Add("FieldName");
	Table_Header.Columns.Add("LinkedDoc");
	
	Tables = New Structure("Header, ItemList", Table_Header, Table_ItemList);
	
	Is = Is(Ref);
	DocAliases = DocAliases();
	If Is.SI Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SI, DocAliases.SO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SI, DocAliases.SC);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SI, DocAliases.WS);
	EndIf;
	
	If Is.SC Then 
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SC, DocAliases.IT);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SC, DocAliases.PR);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SC, DocAliases.SI);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SC, DocAliases.SO);
	EndIf;
	
	If Is.PO Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PO, DocAliases.ISR);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PO, DocAliases.SO);
	EndIf;
	
	If Is.PI Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PI, DocAliases.GR);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PI, DocAliases.ISR);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PI, DocAliases.PO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PI, DocAliases.SO);
	EndIf;
	
	If Is.GR Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.GR, DocAliases.IT);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.GR, DocAliases.PI);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.GR, DocAliases.PO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.GR, DocAliases.SR);
	EndIf;
	
	If Is.ITO Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.ITO, DocAliases.ISR);
	EndIf;
	
	If Is.IT Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.IT, DocAliases.ITO);
	EndIf;
	
	If Is.StockAdjustmentAsSurplus Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.StockAdjustmentAsSurplus, DocAliases.PhysicalInventory);
	EndIf;
	
	If Is.StockAdjustmentAsWriteOff Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.StockAdjustmentAsWriteOff, DocAliases.PhysicalInventory);
	EndIf;
	
	If Is.PR Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PR, DocAliases.PI);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PR, DocAliases.PRO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PR, DocAliases.SC);
	EndIf;
	
	If Is.PRO Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PRO, DocAliases.PI);
	EndIf;
	
	If Is.SR Then 
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SR, DocAliases.SRO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SR, DocAliases.SI);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SR, DocAliases.GR);
	EndIf;
	
	If Is.SRO Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.SRO, DocAliases.SI);
	EndIf;
	
	If Is.RSR Then 
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.RSR, DocAliases.SO);
	EndIf;
	
	If Is.RRR Then 
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.RRR, DocAliases.RSR);
	EndIf;
	
	If Is.PRR Then 
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.PRR, DocAliases.SO);
	EndIf;
	
	If Is.WO Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.WO, DocAliases.SO);
	EndIf;
	
	If Is.WS Then
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.WS, DocAliases.WO);
		FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliases.WS, DocAliases.SI);
	EndIf;
	
	Return Tables;
EndFunction

Procedure FillTables_ExternalLink(Tables, ArrayOfExternalLinkedDocs, DocAliase, ExternalDocAliase)
	If AliasIsPresent(ArrayOfExternalLinkedDocs, ExternalDocAliase) Then
		Fields = GetFieldsToLock_ExternalLink(DocAliase, ExternalDocAliase);
		AddArrayToFieldsTable(Tables.Header       , Fields.Header       , ExternalDocAliase);
		AddArrayToFieldsTable(Tables.ItemList     , Fields.ItemList     , ExternalDocAliase);
		AddArrayToFieldsTable(Tables.RowRefFilter , Fields.RowRefFilter , ExternalDocAliase);
	EndIf;
EndProcedure

Procedure FillTables_InternalLink(Tables, ArrayOfInternalLinkedDocs, DocAliase, InternalDocAliase)
	If AliasIsPresent(ArrayOfInternalLinkedDocs, InternalDocAliase) Then
		Fields = GetFieldsToLock_InternalLink(DocAliase, InternalDocAliase);
		AddArrayToFieldsTable(Tables.Header   , Fields.Header   , InternalDocAliase);
		AddArrayToFieldsTable(Tables.ItemList , Fields.ItemList , InternalDocAliase);
	EndIf;
EndProcedure

Function AliasIsPresent(ArrayOfLinkedDocs, Alias)
	Return ArrayOfLinkedDocs.Find(Alias) <> Undefined;
EndFunction

Procedure AddArrayToFieldsTable(TableOfFields, FieldNames, LinkedDoc)
	If FieldNames = Undefined Then
		Return;
	EndIf;
	ArrayOfFields = StrSplit(FieldNames, ",");
	For Each FieldName In ArrayOfFields Do
		NewRow = TableOfFields.Add();
		NewRow.FieldName = TrimAll(FieldName);
		NewRow.LinkedDoc = LinkedDoc;
	EndDo;
EndProcedure

#EndRegion

#EndRegion

