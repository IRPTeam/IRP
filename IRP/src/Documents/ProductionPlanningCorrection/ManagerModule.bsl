#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	InfoReg = Metadata.InformationRegisters;
	AccReg  = Metadata.AccumulationRegisters;
	Tables = New Structure();
	Tables.Insert("BillOfMaterials"      , PostingServer.CreateTable(InfoReg.T7010S_BillOfMaterials));
	Tables.Insert("ProductionPlanning"   , PostingServer.CreateTable(AccReg.R7030T_ProductionPlanning));
	Tables.Insert("MaterialPlanning"     , PostingServer.CreateTable(AccReg.R7020T_MaterialPlanning));
	Tables.Insert("DetailingSupplies"    , PostingServer.CreateTable(AccReg.R7010T_DetailingSupplies));
	
	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status, CurrentUniversalDate());
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
		PutTablesToTempTablesManager(Parameters, Tables.BillOfMaterials, 
                                                 Tables.DetailingSupplies,
                                                 Tables.MaterialPlanning,
                                                 Tables.ProductionPlanning);
		
		Return Tables;
	EndIf;
	
	BillOfMaterialsTable = GetBillOfMaterials(Ref, GetQueryTex_BillOfMaterialsPlanned());
	MaterialPlanningEmptyTable    = Tables.MaterialPlanning.CopyColumns();
	
	MaterialPlanningTable    = GetMaterialPlanning(BillOfMaterialsTable, MaterialPlanningEmptyTable);
	ProductionPlanningTable  = GetProductionPlanning(BillOfMaterialsTable);
	DetailingSuppliesTable   = GetDetailingSupplies(MaterialPlanningTable);
	BillOfMaterialsTable     = GetBillOfMaterials(Ref, GetQueryText_BillOfMaterialsContent());
		
	PutTablesToTempTablesManager(Parameters, BillOfMaterialsTable, 
                                             DetailingSuppliesTable,
                                             MaterialPlanningTable,
                                             ProductionPlanningTable);
		
	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	
	Return Tables;
EndFunction

Procedure PutTablesToTempTablesManager(Parameters, BillOfMaterialsTable, 
                                                   DetailingSuppliesTable,
                                                   MaterialPlanningTable,
                                                   ProductionPlanningTable)
	Query = New Query();
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("ProductionPlanningTable" , ProductionPlanningTable);
	Query.SetParameter("DetailingSuppliesTable"  , DetailingSuppliesTable);
	Query.SetParameter("MaterialPlanningTable"   , MaterialPlanningTable);
	Query.SetParameter("BillOfMaterialsTable"    , BillOfMaterialsTable);
	
	Query.Text = 
	"SELECT
	|	*
	|INTO IncomingStocks
	|FROM
	|	&ProductionPlanningTable AS IncomingStocks
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO DetailingSuppliesTable
	|FROM
	|	&DetailingSuppliesTable AS DetailingSuppliesTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO ProductionPlanningTable
	|FROM
	|	&ProductionPlanningTable AS ProductionPlanningTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO MaterialPlanningTable
	|FROM
	|	&MaterialPlanningTable AS MaterialPlanningTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO BillOfMaterialsTable
	|FROM 
	|	&BillOfMaterialsTable AS BillOfMaterialsTable";
	Query.Execute();
EndProcedure


#Region CreatingTables

Function GetDetailingSupplies(MaterialPlanningTable)
	Query = New Query();
	Query.Text =
	"SELECT
	|	MaterialPlanningTable.Period,
	|	MaterialPlanningTable.Company,
	|	MaterialPlanningTable.BusinessUnit,
	|	MaterialPlanningTable.PlanningPeriod,
	|	MaterialPlanningTable.Store,
	|	MaterialPlanningTable.ItemKey,
	|	MaterialPlanningTable.Quantity
	|INTO tmp
	|FROM
	|	&MaterialPlanningTable AS MaterialPlanningTable
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.Company,
	|	tmp.BusinessUnit,
	|	tmp.PlanningPeriod,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	SUM(tmp.Quantity) AS CorrectedDemandQuantity
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Period,
	|	tmp.Company,
	|	tmp.BusinessUnit,
	|	tmp.PlanningPeriod,
	|	tmp.Store,
	|	tmp.ItemKey";
	Query.SetParameter("MaterialPlanningTable", MaterialPlanningTable);
	QueryResult = Query.Execute();
	QueryTable =QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetProductionPlanning(BillOfMaterialsTable)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BillOfMaterialsTable.ProductionPlanning,
	|	BillOfMaterialsTable.ProductionPlanningBasis,
	|	BillOfMaterialsTable.BusinessUnit,
	|	BillOfMaterialsTable.PlanningPeriod,
	|	BillOfMaterialsTable.ItemKey,
	|	BillOfMaterialsTable.BillOfMaterials,
	|	BillOfMaterialsTable.BasisQuantity AS Quantity,
	|	BillOfMaterialsTable.Period,
	|	BillOfMaterialsTable.Company,
	|	BillOfMaterialsTable.SurplusStore AS Store,
	|	BillOfMaterialsTable.IsProduct,
	|	BillOfMaterialsTable.IsSemiproduct,
	|	BillOfMaterialsTable.IsMaterial,
	|	BillOfMaterialsTable.IsService
	|INTO tmp
	|FROM
	|	&BillOfMaterialsTable AS BillOfMaterialsTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.BusinessUnit,
	|	tmp.PlanningPeriod,
	|	tmp.BillOfMaterials,
	|	VALUE(Enum.ProductionPlanningTypes.PlanAdjustment) AS PlanningType,
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity,
	|	CASE WHEN tmp.IsProduct = TRUE THEN VALUE(Enum.ProductionTypes.Product)
	|		 WHEN tmp.IsSemiproduct = TRUE THEN VALUE(Enum.ProductionTypes.Semiproduct)
	|	END AS ProductionType,
	|	tmp.ProductionPlanningBasis AS PlanningDocument,
	|	tmp.ProductionPlanningBasis AS Order
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.IsProduct = TRUE OR tmp.IsSemiproduct = TRUE";
	
	Query.SetParameter("BillOfMaterialsTable", BillOfMaterialsTable);
	QueryResult = Query.Execute();
	PlanningTable = QueryResult.Unload();
	Return PlanningTable;
EndFunction

Function GetMaterialPlanning(BillOfMaterialsTable, MaterialPlanningTable)
	TmpManager = New TempTablesManager();
	Query = New Query();
	Query.TempTablesManager = TmpManager;
	Query.Text = 
	"SELECT
	|	BillOfMaterialsTable.ProductionPlanning,
	|   BillOfMaterialsTable.PlanningDocument,
	|	BillOfMaterialsTable.BusinessUnit,
	|	BillOfMaterialsTable.PlanningPeriod,
	|	BillOfMaterialsTable.ItemKey,
	|	BillOfMaterialsTable.BillOfMaterials,
	|	BillOfMaterialsTable.BasisQuantity AS Quantity,
	|	BillOfMaterialsTable.Period,
	|	BillOfMaterialsTable.Company,
	|	BillOfMaterialsTable.WriteoffStore AS Store,
	|	BillOfMaterialsTable.IsProduct,
	|	BillOfMaterialsTable.IsSemiproduct,
	|	BillOfMaterialsTable.IsMaterial,
	|	BillOfMaterialsTable.IsService,
	|	BillOfMaterialsTable.InputID,
	|	BillOfMaterialsTable.OutputID,
	|	BillOfMaterialsTable.UniqueID
	|INTO tmp
	|FROM
	|	&BillOfMaterialsTable AS BillOfMaterialsTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Period,
	|	tmp.BusinessUnit,
	|	tmp.PlanningPeriod,
	|	tmp.PlanningDocument,
	|	tmp.BillOfMaterials,
	|	VALUE(Enum.ProductionPlanningTypes.PlanAdjustment) AS PlanningType,
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.IsSemiproduct,
	|	tmp.ItemKey AS Production,
	|	tmp.OutputID,
	|	tmp.UniqueID
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.IsProduct = TRUE
	|	OR tmp.IsSemiproduct = TRUE";
	
	Query.SetParameter("BillOfMaterialsTable", BillOfMaterialsTable);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		MaterialTable = GetMaterialByProduct(TmpManager, QuerySelection.OutputID, QuerySelection.UniqueID);
		For Each RowMaterial In MaterialTable Do
			NewRow = MaterialPlanningTable.Add();
			FillPropertyValues(NewRow, QuerySelection);
			NewRow.Store    = RowMaterial.Store;
			NewRow.ItemKey  = RowMaterial.ItemKey;
			NewRow.Quantity = RowMaterial.Quantity;
		EndDo;
	EndDo;
	Return MaterialPlanningTable;
EndFunction

Function GetMaterialByProduct(TmpManager, OutputID, UniqueID)
	Query = New Query();
	Query.TempTablesManager = TmpManager;
	Query.Text =
	"SELECT
	|	tmp.ItemKey,
	|	tmp.Store AS Store,
	|	tmp.Quantity
	|FROM
	|	tmp AS tmp
	|WHERE
	|	tmp.InputID = &OutputID
	|	AND CAST(tmp.UniqueID AS STRING(100)) = CAST(&UniqueID AS STRING(100))
	|	AND (tmp.IsMaterial = TRUE
	|	OR tmp.IsSemiproduct = TRUE)";
	Query.SetParameter("OutputID", OutputID);
	Query.SetParameter("UniqueID", UniqueID);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetQueryTex_BillOfMaterialsPlanned()
	Return
		"SELECT
		|	DocBillOfMaterials.Ref AS ProductionPlanning,
		|	DocBillOfMaterials.Ref.ProductionPlanning AS PlanningDocument,
		|	DocBillOfMaterials.Ref.ProductionPlanning AS ProductionPlanningBasis,
		|	DocBillOfMaterials.Ref.Company AS Company,
		|	DocBillOfMaterials.Ref.ApprovedDate AS Period,
		|	DocBillOfMaterials.BusinessUnit AS BusinessUnit,
		|	DocBillOfMaterials.PlanningPeriod AS PlanningPeriod,
		|	DocBillOfMaterials.ItemKey AS ItemKey,
		|	CASE
		|		WHEN DocBillOfMaterials.IsMaterial
		|			THEN DocBillOfMaterials.MaterialStore
		|		WHEN DocBillOfMaterials.IsSemiproduct
		|			THEN DocBillOfMaterials.SemiproductStore
		|		ELSE VALUE(Catalog.Stores.EmptyRef)
		|	END AS WriteoffStore,
		|	CASE
		|		WHEN DocBillOfMaterials.IsSemiproduct
		|		OR DocBillOfMaterials.IsProduct
		|			THEN DocBillOfMaterials.ReleaseStore
		|		ELSE VALUE(Catalog.Stores.EmptyRef)
		|	END AS SurplusStore,
		|	DocBillOfMaterials.IsProduct AS IsProduct,
		|	DocBillOfMaterials.IsSemiproduct AS IsSemiproduct,
		|	DocBillOfMaterials.IsMaterial AS IsMaterial,
		|	DocBillOfMaterials.IsService AS IsService,
		|	DocBillOfMaterials.InputID AS InputID,
		|	DocBillOfMaterials.OutputID AS OutputID,
		|	DocBillOfMaterials.UniqueID AS UniqueID,
		|	DocBillOfMaterials.BillOfMaterials AS BillOfMaterials,
		|	DocBillOfMaterials.Unit AS Unit,
		|	DocBillOfMaterials.PlannedQuantity AS Quantity,
		|	DocBillOfMaterials.BasisUnit AS BasisUnit,
		|	DocBillOfMaterials.PlannedBasisQuantity AS BasisQuantity
		|FROM
		|	Document.ProductionPlanningCorrection.BillOfMaterialsList AS DocBillOfMaterials
		|WHERE
		|	DocBillOfMaterials.Ref = &Ref
		|	AND DocBillOfMaterials.PlannedQuantity <> 0";
EndFunction

Function GetQueryText_BillOfMaterialsContent()
	Return
		"SELECT
		|	DocBillOfMaterials.Ref AS ProductionPlanning,
		|	DocBillOfMaterials.Ref.ProductionPlanning AS PlanningDocument,
		|	DocBillOfMaterials.Ref.ProductionPlanning AS ProductionPlanningBasis,
		|	DocBillOfMaterials.Ref.Company AS Company,
		|	DocBillOfMaterials.Ref.ApprovedDate AS Period,
		|	DocBillOfMaterials.BusinessUnit AS BusinessUnit,
		|	DocBillOfMaterials.PlanningPeriod AS PlanningPeriod,
		|	DocBillOfMaterials.ItemKey AS ItemKey,
		|	CASE
		|		WHEN DocBillOfMaterials.IsMaterial
		|			THEN DocBillOfMaterials.MaterialStore
		|		WHEN DocBillOfMaterials.IsSemiproduct
		|			THEN DocBillOfMaterials.SemiproductStore
		|		ELSE VALUE(Catalog.Stores.EmptyRef)
		|	END AS WriteoffStore,
		|	CASE
		|		WHEN DocBillOfMaterials.IsSemiproduct
		|		OR DocBillOfMaterials.IsProduct
		|			THEN DocBillOfMaterials.ReleaseStore
		|		ELSE VALUE(Catalog.Stores.EmptyRef)
		|	END AS SurplusStore,
		|	DocBillOfMaterials.IsProduct AS IsProduct,
		|	DocBillOfMaterials.IsSemiproduct AS IsSemiproduct,
		|	DocBillOfMaterials.IsMaterial AS IsMaterial,
		|	DocBillOfMaterials.IsService AS IsService,
		|	DocBillOfMaterials.InputID AS InputID,
		|	DocBillOfMaterials.OutputID AS OutputID,
		|	DocBillOfMaterials.UniqueID AS UniqueID,
		|	DocBillOfMaterials.BillOfMaterials AS BillOfMaterials,
		|	DocBillOfMaterials.Unit AS Unit,
		|	DocBillOfMaterials.Quantity AS Quantity,
		|	DocBillOfMaterials.BasisUnit AS BasisUnit,
		|	DocBillOfMaterials.BasisQuantity AS BasisQuantity
		|FROM
		|	Document.ProductionPlanningCorrection.BillOfMaterialsList AS DocBillOfMaterials
		|WHERE
		|	DocBillOfMaterials.Ref = &Ref
		|	AND DocBillOfMaterials.PlannedQuantity <> 0";
EndFunction

Function GetBillOfMaterials(Ref, QueryText)
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	If Parameters.StatusInfo.Posting Then
		Tables = Parameters.DocumentDataTables;	
		QueryArray = GetQueryTextsMasterTables();
		PostingServer.SetRegisters(Tables, Ref);
		PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
	EndIf;
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
	Tables = PostingGetDocumentDataTables(Ref, Cancel, Undefined, Parameters, AddInfo);
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
	Return Tables;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Parameters.Insert("Unposting", True);
	CheckAfterWrite(Ref, Cancel, Parameters, AddInfo);
EndProcedure

#EndRegion

#Region CheckAfterWrite

Procedure CheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined)
	Unposting = ?(Parameters.Property("Unposting"), Parameters.Unposting, False);
	AccReg = AccumulationRegisters;
		
	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref, "Document.ProductionPlanning.Productions");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters),
	                                                                PostingServer.GetQueryTableByName("R4035B_IncomingStocks_Exists", Parameters),
	                                                                AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
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
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(T7010S_BillOfMaterials());
	QueryArray.Add(R7030T_ProductionPlanning());
	QueryArray.Add(R7020T_MaterialPlanning());
	QueryArray.Add(R7010T_DetailingSupplies());
	Return QueryArray;	
EndFunction	

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		|	*
		|INTO R4035B_IncomingStocks
		|FROM
		|	IncomingStocks AS IncomingStocks
		|WHERE
		|	IncomingStocks.ItemKey.UseIncomingStockReservation";
EndFunction

Function R4035B_IncomingStocks_Exists()
	Return
		"SELECT *
		|	INTO R4035B_IncomingStocks_Exists
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		|WHERE
		|	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

Function T7010S_BillOfMaterials()
	Return
		"SELECT * 
		|INTO T7010S_BillOfMaterials
		|FROM BillOfMaterialsTable AS BillOfMaterialsTable
		|WHERE
		|	TRUE";
EndFunction

Function R7030T_ProductionPlanning()
	Return
		"SELECT * 
		|INTO R7030T_ProductionPlanning
		|FROM ProductionPlanningTable AS ProductionPlanningTable
		|WHERE
		|	TRUE";
EndFunction

Function R7020T_MaterialPlanning()
	Return
		"SELECT * 
		|INTO R7020T_MaterialPlanning
		|FROM MaterialPlanningTable AS MaterialPlanningTable
		|WHERE
		|	TRUE";
EndFunction

Function R7010T_DetailingSupplies()
	Return
		"SELECT * 
		|INTO R7010T_DetailingSupplies
		|FROM DetailingSuppliesTable AS DetailingSuppliesTable
		|WHERE
		|	TRUE";
EndFunction

Function GetCurrentQuantity(Company, ProductionPlanning, PlanningPeriod, BillOfMaterials, ItemKey) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	ISNULL(Planned.Company, Correction.Company) AS Company,
	|	ISNULL(Planned.BusinessUnit, Correction.BusinessUnit) AS BusinessUnit,
	|	ISNULL(Planned.ItemKey, Correction.ItemKey) AS ItemKey,
	|	ISNULL(Planned.PlanningType, Correction.PlanningType) AS PlanningType,
	|	ISNULL(Planned.PlanningPeriod, Correction.PlanningPeriod) AS PlanningPeriod,
	|	ISNULL(Planned.BillOfMaterials, Correction.BillOfMaterials) AS BillOfMaterials,
	|	ISNULL(Planned.PlanningDocument, Correction.PlanningDocument) AS PlanningDocument,
	|	MAX(ISNULL(Planned.QuantityTurnover, 0) + ISNULL(Correction.QuantityTurnover, 0)) AS Quantity
	|INTO Planned
	|FROM
	|	AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod = &PlanningPeriod
	|	AND PlanningType = VALUE(Enum.ProductionPlanningTypes.Planned)
	|	AND Company = &Company
	|	AND PlanningDocument = &ProductionPlanning
	|	AND ItemKey = &ItemKey
	|	AND BillOfMaterials = &BillOfMaterials) AS Planned
	|		FULL JOIN AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod = &PlanningPeriod
	|		AND PlanningType = VALUE(Enum.ProductionPlanningTypes.PlanAdjustment)
	|		AND Company = &Company
	|		AND PlanningDocument = &ProductionPlanning
	|		AND ItemKey = &ItemKey
	|		AND BillOfMaterials = &BillOfMaterials) AS Correction
	|		ON Planned.Company = Correction.Company
	|		AND Planned.BusinessUnit = Correction.BusinessUnit
	|		AND Planned.PlanningDocument = Correction.PlanningDocument
	|		AND Planned.ItemKey = Correction.ItemKey
	|		AND Planned.PlanningPeriod = Correction.PlanningPeriod
	|		AND Planned.ProductionType = Correction.ProductionType
	|		AND Planned.BillOfMaterials = Correction.BillOfMaterials
	|GROUP BY
	|	ISNULL(Planned.Company, Correction.Company),
	|	ISNULL(Planned.BusinessUnit, Correction.BusinessUnit),
	|	ISNULL(Planned.ItemKey, Correction.ItemKey),
	|	ISNULL(Planned.PlanningType, Correction.PlanningType),
	|	ISNULL(Planned.PlanningPeriod, Correction.PlanningPeriod),
	|	ISNULL(Planned.PlanningDocument, Correction.PlanningDocument),
	|	ISNULL(Planned.BillOfMaterials, Correction.BillOfMaterials)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Planned.Company AS Company,
	|	Planned.BusinessUnit AS BusinessUnit,
	|	Planned.ItemKey.Item AS Item,
	|	Planned.ItemKey AS ItemKey,
	|	Planned.PlanningPeriod AS PlanningPeriod,
	|	Planned.Quantity AS BasisQuantity,
	|	T7010S_BillOfMaterials.BasisUnit AS BasisUnit,
	|	T7010S_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	T7010S_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	T7010S_BillOfMaterials.OutputID AS OutputID,
	|	T7010S_BillOfMaterials.UniqueID AS UniqueID
	|INTO Production
	|FROM
	|	Planned AS Planned
	|		INNER JOIN InformationRegister.T7010S_BillOfMaterials.SliceLast AS T7010S_BillOfMaterials
	|		ON (T7010S_BillOfMaterials.Company = Planned.Company)
	|		AND (T7010S_BillOfMaterials.BusinessUnit = Planned.BusinessUnit)
	|		AND (T7010S_BillOfMaterials.ItemKey = Planned.ItemKey)
	|		AND (T7010S_BillOfMaterials.IsProduct = TRUE)
	|		AND (T7010S_BillOfMaterials.PlanningPeriod = Planned.PlanningPeriod)
	|		AND (T7010S_BillOfMaterials.BillOfMaterials = &BillOfMaterials)
	|		AND (T7010S_BillOfMaterials.BillOfMaterials = Planned.BillOfMaterials)
	|		AND (T7010S_BillOfMaterials.PlanningDocument = Planned.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Production.Item AS Item,
	|	Production.ItemKey AS ItemKey,
	|	Production.BasisQuantity AS BasisQuantity,
	|	Production.BasisUnit AS BasisUnit,
	|	Production.BillOfMaterials AS BillOfMaterials
	|FROM
	|	Production AS Production
	|WHERE
	|	Production.BasisQuantity > 0";
		
	Query.SetParameter("Company"            , Company);
	Query.SetParameter("ProductionPlanning" , ProductionPlanning);
	Query.SetParameter("PlanningPeriod"     , PlanningPeriod);
	Query.SetParameter("ItemKey"            , ItemKey);
	Query.SetParameter("BillOfMaterials"    , BillOfMaterials);
	
	Result = New Structure("BasisUnit, BasisQuantity", Catalogs.Units.EmptyRef(), 0);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();	
	If QuerySelection.Next() Then
		Result.BasisUnit = QuerySelection.BasisUnit;
		Result.BasisQuantity = QuerySelection.BasisQuantity;
	EndIf;
	Return Result;
EndFunction
