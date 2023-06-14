#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	AccReg  = Metadata.AccumulationRegisters;
	Tables = New Structure;

	BillOfMaterialsTable       = GetBillOfMaterials(Ref);
	MaterialPlanningEmptyTable = PostingServer.CreateTable(AccReg.R7020T_MaterialPlanning);
	MaterialPlanningEmptyTable.Columns.Add("IsProduct", New TypeDescription("Boolean"));
	MaterialPlanningEmptyTable.Columns.Add("IsSemiproduct", New TypeDescription("Boolean"));
	MaterialPlanningEmptyTable.Columns.Add("IsMaterial", New TypeDescription("Boolean"));
	MaterialPlanningEmptyTable.Columns.Add("IsService", New TypeDescription("Boolean"));

	MaterialPlanningTable      = GetMaterialPlanning(BillOfMaterialsTable, MaterialPlanningEmptyTable);
	ProductionPlanningTable    = GetProductionPlanning(BillOfMaterialsTable);
	DetailingSuppliesTable     = GetDetailingSupplies(MaterialPlanningTable);

	Query = New Query;
	Query.TempTablesManager = Parameters.TempTablesManager;
	Query.SetParameter("ProductionPlanningTable", ProductionPlanningTable);
	Query.SetParameter("BillOfMaterialsTable", BillOfMaterialsTable);
	Query.SetParameter("ProductionPlanningTable", ProductionPlanningTable);
	Query.SetParameter("MaterialPlanningTable", MaterialPlanningTable);
	Query.SetParameter("DetailingSuppliesTable", DetailingSuppliesTable);
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
	|INTO BillOfMaterials
	|FROM
	|	&BillOfMaterialsTable AS BillOfMaterialsTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO ProductionPlanning
	|FROM
	|	&ProductionPlanningTable AS ProductionPlanning
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO MaterialPlanning
	|FROM
	|	&MaterialPlanningTable AS MaterialPlanning
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO DetailingSupplies
	|FROM
	|	&DetailingSuppliesTable AS DetailingSupplies";
	Query.Execute();

	QueryArray = GetQueryTextsSecondaryTables();
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);

	Return Tables;
EndFunction

#Region CreatingTables

Function GetDetailingSupplies(MaterialPlanningTable)
	Query = New Query;
	Query.Text =
	"SELECT
	|	MaterialPlanningTable.Period,
	|	MaterialPlanningTable.Company,
	|	MaterialPlanningTable.BusinessUnit,
	|	MaterialPlanningTable.PlanningPeriod,
	|	MaterialPlanningTable.Store,
	|	MaterialPlanningTable.ItemKey,
	|	MaterialPlanningTable.Quantity,
	|	MaterialPlanningTable.IsProduct,
	|	MaterialPlanningTable.IsSemiproduct,
	|	MaterialPlanningTable.IsMaterial,
	|	MaterialPlanningTable.IsService
	|INTO tmp_material
	|FROM
	|	&MaterialPlanningTable AS MaterialPlanningTable
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_material.Period,
	|	tmp_material.Company,
	|	tmp_material.BusinessUnit,
	|	tmp_material.PlanningPeriod,
	|	tmp_material.Store,
	|	tmp_material.ItemKey,
	|	SUM(tmp_material.Quantity) AS EntryDemandQuantity,
	|	SUM(CASE
	|		WHEN tmp_material.IsSemiproduct = TRUE
	|			THEN tmp_material.Quantity
	|		ELSE 0
	|	END) AS NeededProduceQuantity
	|FROM
	|	tmp_material AS tmp_material
	|GROUP BY
	|	tmp_material.Period,
	|	tmp_material.Company,
	|	tmp_material.BusinessUnit,
	|	tmp_material.PlanningPeriod,
	|	tmp_material.Store,
	|	tmp_material.ItemKey";

	Query.SetParameter("MaterialPlanningTable", MaterialPlanningTable);

	QueryResult = Query.Execute();
	QueryTable =QueryResult.Unload();
	Return QueryTable;
EndFunction

Function GetProductionPlanning(BillOfMaterialsTable)
	Query = New Query;
	Query.Text =
	"SELECT
	|	BillOfMaterialsTable.ProductionPlanning,
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
	|	VALUE(Enum.ProductionPlanningTypes.Planned) AS PlanningType,
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey,
	|	tmp.Quantity,
	|	CASE WHEN tmp.IsProduct = TRUE THEN VALUE(Enum.ProductionTypes.Product)
	|		 WHEN tmp.IsSemiproduct = TRUE THEN VALUE(Enum.ProductionTypes.Semiproduct)
	|	END AS ProductionType,
	|	tmp.ProductionPlanning AS PlanningDocument
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
	TmpManager = New TempTablesManager;
	Query = New Query;
	Query.TempTablesManager = TmpManager;
	Query.Text =
	"SELECT
	|	BillOfMaterialsTable.ProductionPlanning,
	|	BillOfMaterialsTable.BusinessUnit,
	|	BillOfMaterialsTable.PlanningPeriod,
	|	BillOfMaterialsTable.ItemKey,
	|	BillOfMaterialsTable.BillOfMaterials,
	|	BillOfMaterialsTable.BasisQuantity AS Quantity,
	|	BillOfMaterialsTable.Period,
	|	BillOfMaterialsTable.Company,
	|	BillOfMaterialsTable.WriteOffStore AS Store,
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
	|	tmp.ProductionPlanning AS PlanningDocument,
	|	tmp.BillOfMaterials,
	|	VALUE(Enum.ProductionPlanningTypes.Planned) AS PlanningType,
	|	tmp.Company,
	|	tmp.Store,
	|	tmp.ItemKey AS Production,
	|	tmp.IsProduct,
	|	tmp.IsSemiproduct,
	|	tmp.IsMaterial,
	|	tmp.IsService,
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
			NewRow.Store         = RowMaterial.Store;
			NewRow.ItemKey       = RowMaterial.ItemKey;
			NewRow.Quantity      = RowMaterial.Quantity;
			NewRow.IsProduct     = RowMaterial.IsProduct;
			NewRow.IsSemiproduct = RowMaterial.IsSemiproduct;
			NewRow.IsMaterial    = RowMaterial.IsMaterial;
			NewRow.IsService     = RowMaterial.IsService;
		EndDo;
	EndDo;
	Return MaterialPlanningTable;
EndFunction

Function GetMaterialByProduct(TmpManager, OutputID, UniqueID)
	Query = New Query;
	Query.TempTablesManager = TmpManager;
	Query.Text =
	"SELECT
	|	tmp.ItemKey,
	|	tmp.Quantity,
	|	tmp.Store,
	|	tmp.IsProduct,
	|	tmp.IsSemiproduct,
	|	tmp.IsMaterial,
	|	tmp.IsService
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

Function GetBillOfMaterials(Ref)
	Query = New Query;
	Query.Text =
	"SELECT
	|	DocBillOfMaterials.Ref AS ProductionPlanning,
	|	DocBillOfMaterials.Ref AS PlanningDocument,
	|	DocBillOfMaterials.Ref.Company AS Company,
	|	DocBillOfMaterials.Ref.Date AS Period,
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
	|	Document.ProductionPlanning.BillOfMaterialsList AS DocBillOfMaterials
	|WHERE
	|	DocBillOfMaterials.Ref = &Ref";

	Query.SetParameter("Ref", Ref);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Return QueryTable;
EndFunction

#EndRegion

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map;
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map;
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

	LineNumberAndItemKeyFromItemList = PostingServer.GetLineNumberAndItemKeyFromItemList(Ref,
		"Document.ProductionPlanning.Productions");
	If Not Cancel And Not AccReg.R4035B_IncomingStocks.CheckBalance(Ref, LineNumberAndItemKeyFromItemList,
		PostingServer.GetQueryTableByName("R4035B_IncomingStocks", Parameters), PostingServer.GetQueryTableByName(
		"R4035B_IncomingStocks_Exists", Parameters), AccumulationRecordType.Receipt, Unposting, AddInfo) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure;
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_SourceTable

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks_Exists());
	Return QueryArray;
EndFunction

Function R4035B_IncomingStocks_Exists()
	Return "SELECT *
		   |	INTO R4035B_IncomingStocks_Exists
		   |FROM
		   |	AccumulationRegister.R4035B_IncomingStocks AS R4035B_IncomingStocks
		   |WHERE
		   |	R4035B_IncomingStocks.Recorder = &Ref";
EndFunction

#EndRegion

#Region Posting_MainTables

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R4035B_IncomingStocks());
	QueryArray.Add(R7010T_DetailingSupplies());
	QueryArray.Add(R7020T_MaterialPlanning());
	QueryArray.Add(R7030T_ProductionPlanning());
	QueryArray.Add(T7010S_BillOfMaterials());
	Return QueryArray;
EndFunction

Function R4035B_IncomingStocks()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Receipt) AS RecordType,
		   |	*
		   |INTO R4035B_IncomingStocks
		   |FROM
		   |	IncomingStocks AS IncomingStocks
		   |WHERE
		   |	IncomingStocks.ItemKey.UseIncomingStockReservation";
EndFunction

Function T7010S_BillOfMaterials()
	Return "SELECT *
		   |	INTO T7010S_BillOfMaterials
		   |FROM BillOfMaterials AS BillOfMaterialsTable
		   |WHERE
		   |	TRUE";
EndFunction

Function R7030T_ProductionPlanning()
	Return "SELECT *
		   |	INTO R7030T_ProductionPlanning
		   |FROM ProductionPlanning AS ProductionPlanning
		   |WHERE
		   |	TRUE";
EndFunction

Function R7020T_MaterialPlanning()
	Return "SELECT *
		   |	INTO R7020T_MaterialPlanning
		   |FROM MaterialPlanning AS MaterialPlanning
		   |WHERE
		   |	TRUE";
EndFunction

Function R7010T_DetailingSupplies()
	Return "SELECT *
		   |	INTO R7010T_DetailingSupplies
		   |FROM DetailingSupplies AS DetailingSupplies
		   |WHERE
		   |	TRUE";
EndFunction

#EndRegion

#Region AccessObject

// Get access key.
// 
// Parameters:
//  Obj - DocumentObjectDocumentName -
// 
// Returns:
//  Map
Function GetAccessKey(Obj) Export
	AccessKeyMap = New Map;
	AccessKeyMap.Insert("Company", Obj.Company);
	AccessKeyMap.Insert("Branch", Obj.Branch);
	Return AccessKeyMap;
EndFunction

#EndRegion