#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);	
	Return New Structure();
EndFunction

//Function GetMainProduction(Ref)
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	MF_Procurements.InputID,
//	|	MF_Procurements.OutputID
//	|FROM
//	|	InformationRegister.MF_Procurements AS MF_Procurements
//	|WHERE
//	|	MF_Procurements.Document = &Ref";
//	Query.SetParameter("Ref", Ref);
//	QueryResult = Query.Execute();
//	If QueryResult.IsEmpty() Then
//		Return Ref;
//	EndIf;
//	QuerySelection = QueryResult.Select();
//	MainProductionRef = Documents.MF_Production.EmptyRef();
//	While QuerySelection.Next() Do
//		If Not ValueIsFilled(QuerySelection.InputID) Then
//			Return Ref;
//		EndIf;
//		GetMainProductionRecursive(MainProductionRef, QuerySelection.InputID);
//	EndDo;
//	Return MainProductionRef;
//EndFunction

//Procedure GetMainProductionRecursive(MainProductionRef, InputID)
//	If ValueIsFilled(MainProductionRef) Then
//		Return;
//	EndIf;
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	MF_Procurements.Document,
//	|	MF_Procurements.InputID,
//	|	MF_Procurements.OutputID
//	|FROM
//	|	InformationRegister.MF_Procurements AS MF_Procurements
//	|WHERE
//	|	MF_Procurements.OutputID = &InputID";
//	Query.SetParameter("InputID", InputID);
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select();
//	While QuerySelection.Next() Do
//		If ValueIsFilled(QuerySelection.InputID) Then
//			GetMainProductionRecursive(MainProductionRef, 
//				QuerySelection.InputID);
//		Else
//			MainProductionRef = QuerySelection.Document;
//		EndIf;
//	EndDo;
//EndProcedure

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;	
	
	//IncomingStocksServer.ClosureIncomingStocks(Parameters);
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	QueryArray = GetQueryTextsMasterTables();
//	IncomingStocksServer.ClosureIncomingStocks_Unposting(Parameters);
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo);
EndProcedure

Procedure CheckAfterWrite_R4010B_R4011B(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	If Not (Parameters.Property("Unposting") And Parameters.Unposting) Then
		// is posting
		FreeStocksTable   =  PostingServer.GetQueryTableByName("R4011B_FreeStocks", Parameters, True);
		ActualStocksTable =  PostingServer.GetQueryTableByName("R4010B_ActualStocks", Parameters, True);
		Exists_FreeStocksTable   =  PostingServer.GetQueryTableByName("Exists_R4011B_FreeStocks", Parameters, True);
		Exists_ActualStocksTable =  PostingServer.GetQueryTableByName("Exists_R4010B_ActualStocks", Parameters, True);
		
		Filter = New Structure("RecordType", AccumulationRecordType.Expense);
		
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Production.Materials", AddInfo);
		
		
		Filter = New Structure("RecordType", AccumulationRecordType.Receipt);

		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4011B_FreeStocks"          , FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "R4010B_ActualStocks"        , ActualStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4011B_FreeStocks"   , Exists_FreeStocksTable.Copy(Filter));
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "Exists_R4010B_ActualStocks" , Exists_ActualStocksTable.Copy(Filter));
		
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
		Parameters.Insert("RecordType", Filter.RecordType);
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Production.Materials", AddInfo);
	Else
		// is unposting
		CommonFunctionsClientServer.PutToAddInfo(AddInfo, "ErrorQuantityField", "Object.Quantity");
		PostingServer.CheckBalance_AfterWrite(Ref, Cancel, Parameters, "Document.Production.Materials", AddInfo);
	EndIf;
EndProcedure

#EndRegion

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)	
	StrParams = New Structure();	
	
	//MainProduction = Ref;//GetMainProduction(Ref);
	MainProductionIsFinished   = True;
	IsMainProduction           = True;
	MainProductionFinishedDate = Ref.Date;//Date(1,1,1);
	
//	If ValueIsFilled(MainProduction) Then
//		MainProductionIsFinished = (MainProduction.Finished And MainProduction.Posted);
//		IsMainProduction = (MainProduction = Ref);
//		If MainProduction.Stages.Count() Then
//			MainProductionFinishedDate = MainProduction.Stages[MainProduction.Stages.Count()-1].Date;
//		Else
//			MainProductionFinishedDate = MainProduction.Date;
//		EndIf;
//	EndIf;
	
	StrParams.Insert("MainProductionIsFinished"   , MainProductionIsFinished);
	StrParams.Insert("IsMainProduction"           , IsMainProduction);
	StrParams.Insert("MainProductionFinishedDate" , MainProductionFinishedDate);
	
	StrParams.Insert("ArrayOfWriteoffStores" , New Array());
	For Each Row In Ref.Materials Do
		StrParams.ArrayOfWriteoffStores.Add(Row.WriteoffStore);
	EndDo;
	
	StrParams.Insert("Company"         , Ref.Company);
	StrParams.Insert("BusinessUnit"    , Ref.BusinessUnit);
	StrParams.Insert("PlanningPeriod"  , Ref.PlanningPeriod);
	If Not Ref.isEmpty() Then
		StrParams.Insert("EndOfPeriod" , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	EndIf;
	
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(Materials());
	QueryArray.Add(Header());
//	QueryArray.Add(IncomingStocksReal());
	QueryArray.Add(PostingServer.Exists_R4011B_FreeStocks());
	QueryArray.Add(PostingServer.Exists_R4010B_ActualStocks());
//	QueryArray.Add(R4035B_IncomingStocks_Exists());	
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4011B_FreeStocks());
	QueryArray.Add(R4010B_ActualStocks());
//	QueryArray.Add(R4035B_IncomingStocks());
//	QueryArray.Add(R4036B_IncomingStocksRequested());
//	QueryArray.Add(R4012B_StockReservation());
	QueryArray.Add(R7030T_ProductionPlanning());
	QueryArray.Add(R7020T_MaterialPlanning());
	QueryArray.Add(R7010T_DetailingSupplies());
	QueryArray.Add(R7040T_ManualMaterialsCorretionInProduction());
	QueryArray.Add(T6010S_BatchesInfo());
	QueryArray.Add(T6020S_BatchKeysInfo());
	QueryArray.Add(R4050B_StockInventory());
	Return QueryArray;
EndFunction

Function Materials()
	Return
	"SELECT
	|	ProductionMaterials.Ref.Date AS Period,
	|	ProductionMaterials.Ref.Company AS Company,
	|	ProductionMaterials.Ref.BillOfMaterials AS BillOfMaterials,
	|	ProductionMaterials.Ref.ProductionPlanning AS ProductionPlanning,
//	|	ProductionMaterials.Ref.Company.MF_ManufacturingPriceType AS PriceType,
	|	ProductionMaterials.Ref.BusinessUnit AS BusinessUnit,
	|	ProductionMaterials.WriteoffStore AS Store,
	|	ProductionMaterials.Ref.StoreProduction AS StoreProduction,
	|	ProductionMaterials.ItemKey AS ItemKey,
	|	ProductionMaterials.ItemKeyBOM AS ItemKeyBOM,
	|	ProductionMaterials.Ref.ItemKey AS Production,
	|	ProductionMaterials.Ref.ProductionPlanning.PlanningPeriod AS PlanningPeriod,
	|	ProductionMaterials.Quantity AS Quantity,
	|	ProductionMaterials.QuantityBOM AS QuantityBOM,
	|	ProductionMaterials.ItemKey.Item.ItemType.Type = VALUE(enum.ItemTypes.Service) AS IsService,
//	|	ProductionMaterials.Procurement = VALUE(Enum.MF_ProcurementTypes.FromStore) AS IsProcurement_FromStore,
//	|	ProductionMaterials.Procurement = VALUE(Enum.MF_ProcurementTypes.SupplyRequest) AS IsProcurement_SupplyRequest,
//	|	ProductionMaterials.Procurement = VALUE(Enum.MF_ProcurementTypes.Produce) AS IsProcurement_Produce,
	|	&MainProductionIsFinished AS MainProductionIsFinished,
	|	&IsMainProduction AS IsMainProduction,
	|	&MainProductionFinishedDate AS MainProductionFinishedDate
	|INTO Materials
	|FROM
	|	Document.Production.Materials AS ProductionMaterials
	|WHERE
	|	ProductionMaterials.Ref = &Ref";
EndFunction

Function Header()
	Return
	"SELECT
	|	Production.Date AS Period,
	|	Production.ProductionType AS ProductionType,
	|	Production.Company,
	|	Production.BusinessUnit,
	|	Production.BillOfMaterials,
//	|	Production.Company.MF_ManufacturingPriceType AS PriceType,
	|	Production.ProductionPlanning.PlanningPeriod AS PlanningPeriod,
	|	Production.StoreProduction,
	|	Production.ItemKey,
	|	Production.Quantity,
	|	Production.ItemKey.Item.ItemType.Type = VALUE(Enum.ItemTypes.Service) AS IsService,
	|	&MainProductionIsFinished AS MainProductionIsFinished,
	|	&IsMainProduction AS IsMainProduction,
	|	&MainProductionFinishedDate AS MainProductionFinishedDate,
	|	Production.Ref AS ProductionRef,
	|	Production.ProductionPlanning AS ProductionPlanning
	|INTO Header
	|FROM
	|	Document.Production AS Production
	|WHERE
	|	Production.Ref = &Ref";	
EndFunction

//Function IncomingStocksReal()
//	Return 
//	"SELECT
//	|	Header.MainProductionFinishedDate AS Period,
//	|	Header.StoreProduction AS Store,
//	|	Header.ItemKey AS ItemKey,
//	|	Header.ProductionPlanning AS Order,
//	|	SUM(Header.Quantity) AS Quantity
//	|INTO IncomingStocksReal
//	|FROM
//	|	Header AS Header
//	|WHERE
//	|	NOT Header.IsService
//	|	AND Header.MainProductionIsFinished
//	|GROUP BY
//	|	Header.ItemKey,
//	|	Header.MainProductionFinishedDate,
//	|	Header.ProductionPlanning,
//	|	Header.StoreProduction";
//EndFunction

Function R7030T_ProductionPlanning()
	Return
	"SELECT
	|	Header.MainProductionFinishedDate AS Period,
	|	Header.ProductionPlanning AS PlanningDocument,
	|	Header.ProductionType,
	|	Header.Company,
	|	Header.BillOfMaterials,
	|	Header.BusinessUnit,
	|	Header.StoreProduction AS Store,
	|	Header.ItemKey,
	|	VALUE(Enum.ProductionPlanningTypes.Produced) AS PlanningType,
	|	Header.PlanningPeriod,
	|	Header.Quantity
	|INTO R7030T_ProductionPlanning
	|FROM
	|	Header AS Header
	|WHERE
	|	Header.MainProductionIsFinished
	|	AND NOT Header.PlanningPeriod IS NULL"
EndFunction

Function R7020T_MaterialPlanning()
	Return
	"SELECT
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Company,
	|	Materials.ProductionPlanning AS PlanningDocument,
	|	Materials.BillOfMaterials,
	|	Materials.BusinessUnit,
	|	Materials.Store,
	|	Materials.Production,
	|	Materials.ItemKey,
	|	VALUE(Enum.ProductionPlanningTypes.Produced) AS PlanningType,
	|	Materials.PlanningPeriod,
	|	Materials.Quantity
	|INTO R7020T_MaterialPlanning
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND NOT Materials.PlanningPeriod IS NULL
	|	AND NOT Materials.ItemKey.Ref IS NULL";
EndFunction

Function R7010T_DetailingSupplies()
	Return
	"SELECT
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Company,
	|	Materials.BusinessUnit,
	|	Materials.Store,
	|	Materials.PlanningPeriod,
	|	Materials.ItemKey,
	|	Materials.Quantity AS WrittenOffProduceQuantity,
	|	0 AS ProducedProduceQuantity
	|INTO R7010T_DetailingSupplies
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND Materials.MainProductionIsFinished
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	Header.MainProductionFinishedDate AS Period,
	|	Header.Company,
	|	Header.BusinessUnit,
	|	Header.StoreProduction,
	|	Header.PlanningPeriod,
	|	Header.ItemKey,
	|	0,
	|	Header.Quantity
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished
	|	AND Header.ProductionType = VALUE(Enum.ProductionTypes.Semiproduct)";
EndFunction

Function R4010B_ActualStocks()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Expense) AS RecordType,
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Store,
	|	Materials.ItemKey,
	|	Materials.Quantity
	|INTO R4010B_ActualStocks
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND Materials.MainProductionIsFinished
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt),
	|	Header.MainProductionFinishedDate,
	|	Header.StoreProduction,
	|	Header.ItemKey,
	|	Header.Quantity
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished";
EndFunction

Function R4011B_FreeStocks()
	Return
	"SELECT
	|	Materials.Period,
	|	Materials.Store,
	|	Materials.ItemKey,
	|	Materials.Quantity
	|INTO tmp
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|
	|UNION ALL
	|
	|SELECT
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Store,
	|	Materials.ItemKey,
	|	Materials.Quantity
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
//	|	AND Materials.IsProcurement_Produce
	|	AND Materials.MainProductionIsFinished
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	SUM(tmp.Quantity) AS Quantity
	|INTO tmpFreeStocks
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Period,
	|	tmp.Store,
	|	tmp.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	 R7010T_DetailingSuppliesTurnovers.Store,
	|	 R7010T_DetailingSuppliesTurnovers.ItemKey,
	|	SUM( R7010T_DetailingSuppliesTurnovers.ReservedProduceQuantityTurnover -
	|		 R7010T_DetailingSuppliesTurnovers.WrittenOffProduceQuantityTurnover) AS ReservedQuantity
	|INTO DetailingSupplies
	|FROM
	|	AccumulationRegister.R7010T_DetailingSupplies.Turnovers(, &EndOfPeriod, Recorder, Company = &Company
	|	AND BusinessUnit = &BusinessUnit
	|	AND Store IN (&ArrayOfWriteoffStores)
	|	AND PlanningPeriod = &PlanningPeriod) AS R7010T_DetailingSuppliesTurnovers
	|GROUP BY
	|	R7010T_DetailingSuppliesTurnovers.Store,
	|	R7010T_DetailingSuppliesTurnovers.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpFreeStocks.Period,
	|	tmpFreeStocks.Store,
	|	tmpFreeStocks.ItemKey,
	|	SUM(CASE
	|		WHEN ISNULL(DetailingSupplies.ReservedQuantity, 0) < 0
	|			THEN tmpFreeStocks.Quantity
	|		ELSE CASE
	|			WHEN ISNULL(DetailingSupplies.ReservedQuantity, 0) = 0
	|				THEN tmpFreeStocks.Quantity
	|			ELSE CASE
	|				WHEN ISNULL(DetailingSupplies.ReservedQuantity, 0) >= tmpFreeStocks.Quantity
	|					THEN 0
	|				ELSE tmpFreeStocks.Quantity - ISNULL(DetailingSupplies.ReservedQuantity, 0)
	|			END
	|		END
	|	END) AS Quantity
	|INTO tmpDetailingSupplies
	|FROM
	|	tmpFreeStocks AS tmpFreeStocks
	|		LEFT JOIN DetailingSupplies AS DetailingSupplies
	|		ON tmpFreeStocks.Store = DetailingSupplies.Store
	|		AND tmpFreeStocks.ItemKey = DetailingSupplies.ItemKey
	|GROUP BY
	|	tmpFreeStocks.Store,
	|	tmpFreeStocks.ItemKey,
	|	tmpFreeStocks.Period
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	Header.MainProductionFinishedDate AS Period,
	|	Header.StoreProduction AS Store,
	|	Header.ItemKey,
	|	Header.Quantity
	|INTO R4011B_FreeStocks
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	tmpDetailingSupplies.Period,
	|	tmpDetailingSupplies.Store,
	|	tmpDetailingSupplies.ItemKey,
	|	tmpDetailingSupplies.Quantity
	|FROM
	|	tmpDetailingSupplies AS tmpDetailingSupplies
	|WHERE
	|	tmpDetailingSupplies.Quantity <> 0";
//	|
//	|UNION ALL
//	|
//	|SELECT
//	|	VALUE(AccumulationRecordType.Expense),
//	|	FreeStocks.Period,
//	|	FreeStocks.Store,
//	|	FreeStocks.ItemKey,
//	|	FreeStocks.Quantity
//	|FROM
//	|	FreeStocks AS FreeStocks
//	|WHERE
//	|	TRUE";
EndFunction

//Function R4035B_IncomingStocks()
//	Return
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	*
//		|INTO R4035B_IncomingStocks
//		|FROM
//		|	IncomingStocks AS IncomingStocks
//		|WHERE
//		|	TRUE";
//EndFunction

//Function R4035B_IncomingStocks_Exists()
//	Return
//		"SELECT *
//		|	INTO R4035B_IncomingStocks_Exists
//		|FROM
//		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
//		|WHERE
//		|	R4035B_IncomingStocks.Recorder = &Ref";
//EndFunction

//Function R4036B_IncomingStocksRequested()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
//		|	*
//		|INTO R4036B_IncomingStocksRequested
//		|FROM
//		|	IncomingStocksRequested AS IncomingStocksRequested
//		|WHERE
//		|	TRUE";
//EndFunction

//Function R4012B_StockReservation()
//	Return 
//		"SELECT
//		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
//		|	IncomingStocksRequested.Period,
//		|	IncomingStocksRequested.IncomingStore AS Store,
//		|	IncomingStocksRequested.ItemKey,
//		|	IncomingStocksRequested.Order AS Order,
//		|	IncomingStocksRequested.Quantity
//		|INTO R4012B_StockReservation
//		|FROM
//		|	IncomingStocksRequested
//		|WHERE
//		|	TRUE";
//EndFunction

Function R7040T_ManualMaterialsCorretionInProduction()
	Return
		"SELECT *
		|	INTO R7040T_ManualMaterialsCorretionInProduction
		|FROM
		|	Materials AS Materials
		|WHERE
		|	TRUE";
EndFunction

Function T6010S_BatchesInfo()
	Return
	"SELECT
	|	Header.Period,
	|	Header.ProductionRef AS Document,
	|	Header.Company
	|INTO T6010S_BatchesInfo
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished";
EndFunction

Function T6020S_BatchKeysInfo()
	Return
	"SELECT
	|	VALUE(Enum.BatchDirection.Receipt) AS Direction,
	|	Header.MainProductionFinishedDate AS Period,
	|	Header.Company,
	|	Header.StoreProduction AS Store,
	|	Header.ItemKey,
	|	SUM(Header.Quantity) AS Quantity
	|INTO T6020S_BatchKeysInfo
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished
	|GROUP BY
	|	VALUE(Enum.BatchDirection.Receipt),
	|	Header.MainProductionFinishedDate,
	|	Header.Company,
	|	Header.StoreProduction,
	|	Header.ItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(Enum.BatchDirection.Expense),
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Company,
	|	Materials.Store,
	|	Materials.ItemKey,
	|	SUM(Materials.Quantity) AS Quantity
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND Materials.MainProductionIsFinished
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|GROUP BY
	|	VALUE(Enum.BatchDirection.Expense),
	|	Materials.MainProductionFinishedDate,
	|	Materials.Company,
	|	Materials.Store,
	|	Materials.ItemKey";
EndFunction	

Function R4050B_StockInventory()
	Return
	"SELECT
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	Header.MainProductionFinishedDate AS Period,
	|	Header.Company,
	|	Header.StoreProduction AS Store,
	|	Header.ItemKey,
	|	SUM(Header.Quantity) AS Quantity
	|INTO R4050B_StockInventory
	|FROM
	|	Header AS Header
	|WHERE
	|	NOT Header.IsService
	|	AND Header.MainProductionIsFinished
	|GROUP BY
	|	VALUE(AccumulationRecordType.Receipt),
	|	Header.MainProductionFinishedDate,
	|	Header.Company,
	|	Header.StoreProduction,
	|	Header.ItemKey
	|
	|UNION ALL
	|
	|SELECT
	|	VALUE(AccumulationRecordType.Expense),
	|	Materials.MainProductionFinishedDate AS Period,
	|	Materials.Company,
	|	Materials.Store,
	|	Materials.ItemKey,
	|	SUM(Materials.Quantity) AS Quantity
	|FROM
	|	Materials AS Materials
	|WHERE
	|	NOT Materials.IsService
	|	AND Materials.MainProductionIsFinished
	|	AND NOT Materials.ItemKey.Ref IS NULL
	|GROUP BY
	|	VALUE(AccumulationRecordType.Expense),
	|	Materials.MainProductionFinishedDate,
	|	Materials.Company,
	|	Materials.Store,
	|	Materials.ItemKey";
EndFunction
