#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Return Tables;	
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = Parameters.DocumentDataTables;
	
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref, True);
	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters, True);
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
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
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
	Return;
EndProcedure

#EndRegion

#Region PostingInfo

#Region Posting_Info

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure;
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref"                , Ref);
	StrParams.Insert("Company"            , Ref.Company);
	StrParams.Insert("BusinessUnit"       , Ref.BusinessUnit);
	StrParams.Insert("PlanningPeriod"     , Ref.ProductionPlanning.PlanningPeriod);
	StrParams.Insert("ProductionPlanning" , Ref.ProductionPlanning);
	StrParams.Insert("Period"             , Ref.Date);
	If Not Ref.isEmpty() Then
		StrParams.Insert("BalancePeriod"      , New Boundary(Ref.PointInTime(), BoundaryType.Excluding));
	EndIf;
	Return StrParams;
EndFunction

#EndRegion

#Region Posting_MainTables

#EndRegion

#Region Posting_SourceTable


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



Function GetQueryTextsSecondaryTables()
	QueryArray = New Array;
	Return QueryArray;	
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array;
	QueryArray.Add(R7030T_ProductionPlanning());
	QueryArray.Add(R7020T_MaterialPlanning());
	QueryArray.Add(R4035B_IncomingStocks());
	Return QueryArray;	
EndFunction	

Function R7030T_ProductionPlanning()
	Return
		"SELECT
		|	&Period AS Period,
		|	ProductionPlanning.Company AS Company,
		|	ProductionPlanning.BusinessUnit AS BusinessUnit,
		|	ProductionPlanning.Store AS Store,
		|	ProductionPlanning.ItemKey AS ItemKey,
		|	VALUE(Enum.ProductionPlanningTypes.Closing) AS PlanningType,
		|	ProductionPlanning.PlanningPeriod AS PlanningPeriod,
		|	ProductionPlanning.ProductionType AS ProductionType,
		|	ProductionPlanning.BillOfMaterials AS BillOfMaterials,
		|	ProductionPlanning.PlanningDocument AS PlanningDocument,
		|	-SUM(CASE
		|		WHEN ProductionPlanning.PlanningType = VALUE(Enum.ProductionPlanningTypes.Produced)
		|			THEN -ProductionPlanning.QuantityTurnover
		|		ELSE ProductionPlanning.QuantityTurnover
		|	END) AS Quantity
		|INTO R7030T_ProductionPlanning
		|FROM
		|	AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, Company = &Company
		|	AND PlanningDocument = &ProductionPlanning
		|	AND PlanningPeriod = &PlanningPeriod
		|	AND PlanningType <> VALUE(Enum.ProductionPlanningTypes.Closing)) AS ProductionPlanning
		|GROUP BY
		|	ProductionPlanning.Company,
		|	ProductionPlanning.BusinessUnit,
		|	ProductionPlanning.Store,
		|	ProductionPlanning.ItemKey,
		|	ProductionPlanning.PlanningPeriod,
		|	ProductionPlanning.PlanningDocument,
		|	ProductionPlanning.ProductionType,
		|	ProductionPlanning.BillOfMaterials,
		|	VALUE(Enum.ProductionPlanningTypes.Closing)";
EndFunction

Function R7020T_MaterialPlanning()
	Return
		"SELECT
		|	&Period AS Period,
		|	MaterialPlanning.Company AS Company,
		|	MaterialPlanning.BusinessUnit AS BusinessUnit,
		|	MaterialPlanning.Store AS Store,
		|	MaterialPlanning.Production AS Production,
		|	MaterialPlanning.ItemKey AS ItemKey,
		|	VALUE(Enum.ProductionPlanningTypes.Closing) AS PlanningType,
		|	MaterialPlanning.PlanningPeriod AS PlanningPeriod,
		|	MaterialPlanning.BillOfMaterials AS BillOfMaterials,
		|	MaterialPlanning.PlanningDocument AS PlanningDocument,
		|	-SUM(CASE
		|		WHEN MaterialPlanning.PlanningType = VALUE(Enum.ProductionPlanningTypes.Produced)
		|			THEN -MaterialPlanning.QuantityTurnover
		|		ELSE MaterialPlanning.QuantityTurnover
		|	END) AS Quantity
		|INTO R7020T_MaterialPlanning
		|FROM
		|	AccumulationRegister.R7020T_MaterialPlanning.Turnovers(,,, Company = &Company
		|	AND PlanningDocument = &ProductionPlanning
		|	AND PlanningPeriod = &PlanningPeriod
		|	AND PlanningType <> VALUE(Enum.ProductionPlanningTypes.Closing)) AS MaterialPlanning
		|GROUP BY
		|	MaterialPlanning.Company,
		|	MaterialPlanning.BusinessUnit,
		|	MaterialPlanning.Store,
		|	MaterialPlanning.Production,
		|	MaterialPlanning.PlanningDocument,
		|	MaterialPlanning.ItemKey,
		|	MaterialPlanning.PlanningPeriod,
		|	MaterialPlanning.BillOfMaterials,
		|	VALUE(Enum.ProductionPlanningTypes.Closing)"
EndFunction

Function R4035B_IncomingStocks()
	Return
		"SELECT
		|	VALUE(AccumulationRecordType.Expense) AS RecordType,
		|	&Period AS Period,
		|	IncomingStocks.Store AS Store,
		|	IncomingStocks.ItemKey AS ItemKey,
		|	IncomingStocks.Order AS Order,
		|	IncomingStocks.QuantityBalance AS Quantity
		|INTO R4035B_IncomingStocks
		|FROM
		|	AccumulationRegister.R4035B_IncomingStocks.Balance(&BalancePeriod, Order = &ProductionPlanning) AS IncomingStocks"
EndFunction

#EndRegion