
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Company           = Parameters.Company;
	ThisObject.PlanningPeriod     = Parameters.PlanningPeriod;
	ThisObject.ProductionPlanning = Parameters.ProductionPlanning;
	For Each BusinesUnit In Parameters.ArrayOfBusinessUnits Do
		ThisObject.BusinessUnits.Add(BusinesUnit);
	EndDo;
	
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
	|	AccumulationRegister.MF_ProductionPlanning.Turnovers(
	|			,
	|			,
	|			,
	|			PlanningPeriod = &PlanningPeriod
	|				AND PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.Planned)
	|				AND Company = &Company
	|				AND BusinessUnit IN (&BusinessUnits)
	|				AND PlanningDocument = &PlanningDocument) AS Planned
	|		FULL JOIN AccumulationRegister.MF_ProductionPlanning.Turnovers(
	|				,
	|				,
	|				,
	|				PlanningPeriod = &PlanningPeriod
	|					AND PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.PlanAdjustment)
	|					AND Company = &Company
	|					AND BusinessUnit IN (&BusinessUnits)
	|					AND PlanningDocument = &PlanningDocument) AS Correction
	|		ON Planned.Company = Correction.Company
	|			AND Planned.BusinessUnit = Correction.BusinessUnit
	|			AND Planned.ItemKey = Correction.ItemKey
	|			AND Planned.PlanningPeriod = Correction.PlanningPeriod
	|			AND Planned.ProductionType = Correction.ProductionType
	|			AND Planned.BillOfMaterials = Correction.BillOfMaterials
	|
	|GROUP BY
	|	ISNULL(Planned.Company, Correction.Company),
	|	ISNULL(Planned.BusinessUnit, Correction.BusinessUnit),
	|	ISNULL(Planned.ItemKey, Correction.ItemKey),
	|	ISNULL(Planned.PlanningType, Correction.PlanningType),
	|	ISNULL(Planned.PlanningPeriod, Correction.PlanningPeriod),
	|	ISNULL(Planned.BillOfMaterials, Correction.BillOfMaterials),
	|	ISNULL(Planned.PlanningDocument, Correction.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Produced.Company AS Company,
	|	Produced.BusinessUnit AS BusinessUnit,
	|	Produced.ItemKey AS ItemKey,
	|	Produced.PlanningType AS PlanningType,
	|	Produced.PlanningPeriod AS PlanningPeriod,
	|	Produced.BillOfMaterials AS BillOfMaterials,
	|	Produced.PlanningDocument AS PlanningDocument,
	|	Produced.QuantityTurnover AS Quantity
	|INTO Produced
	|FROM
	|	AccumulationRegister.MF_ProductionPlanning.Turnovers(
	|			,
	|			,
	|			,
	|			PlanningPeriod = &PlanningPeriod
	|				AND PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.Produced)
	|				AND Company = &Company
	|				AND BusinessUnit IN (&BusinessUnits)
	|				AND PlanningDocument = &PlanningDocument) AS Produced
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Planned.Company AS Company,
	|	Planned.BusinessUnit AS BusinessUnit,
	|	Planned.ItemKey.Item AS Item,
	|	Planned.ItemKey AS ItemKey,
	|	Planned.PlanningPeriod AS PlanningPeriod,
	|	Planned.BillOfMaterials AS BillOfMaterials,
	|	Planned.PlanningDocument AS PlanningDocument,
	|	Planned.Quantity - ISNULL(Produced.Quantity, 0) AS BasisQuantity
	|INTO PlannedProduced
	|FROM
	|	Planned AS Planned
	|		LEFT JOIN Produced AS Produced
	|		ON Planned.Company = Produced.Company
	|			AND Planned.BusinessUnit = Produced.BusinessUnit
	|			AND Planned.ItemKey = Produced.ItemKey
	|			AND Planned.PlanningPeriod = Produced.PlanningPeriod
	|			AND Planned.BillOfMaterials = Produced.BillOfMaterials
	|			AND Planned.PlanningDocument = Produced.PlanningDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PlannedProduced.Company AS Company,
	|	PlannedProduced.BusinessUnit AS BusinessUnit,
	|	MF_BillOfMaterials.SurplusStore AS StoreProduction,
	|	PlannedProduced.Item AS Item,
	|	PlannedProduced.ItemKey AS ItemKey,
	|	PlannedProduced.PlanningPeriod AS PlanningPeriod,
	|	PlannedProduced.BasisQuantity AS BasisQuantity,
	|	MF_BillOfMaterials.BasisUnit AS BasisUnit,
	|	MF_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	MF_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	MF_BillOfMaterials.OutputID AS OutputID,
	|	MF_BillOfMaterials.UniqueID AS UniqueID
	|INTO Production
	|FROM
	|	PlannedProduced AS PlannedProduced
	|		INNER JOIN InformationRegister.MF_BillOfMaterials.SliceLast AS MF_BillOfMaterials
	|		ON (MF_BillOfMaterials.Company = PlannedProduced.Company)
	|			AND (MF_BillOfMaterials.BusinessUnit = PlannedProduced.BusinessUnit)
	|			AND (MF_BillOfMaterials.ItemKey = PlannedProduced.ItemKey)
	|			AND (MF_BillOfMaterials.IsProduct = TRUE)
	|			AND (MF_BillOfMaterials.PlanningPeriod = PlannedProduced.PlanningPeriod)
	|			AND (MF_BillOfMaterials.BillOfMaterials = PlannedProduced.BillOfMaterials)
	|			AND (MF_BillOfMaterials.PlanningDocument = PlannedProduced.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PlannedProduced.Company AS Company,
	|	PlannedProduced.BusinessUnit AS BusinessUnit,
	|	MF_BillOfMaterials.SurplusStore AS StoreProduction,
	|	PlannedProduced.Item AS Item,
	|	PlannedProduced.ItemKey AS ItemKey,
	|	PlannedProduced.PlanningPeriod AS PlanningPeriod,
	|	PlannedProduced.BasisQuantity AS BasisQuantity,
	|	MF_BillOfMaterials.BasisUnit AS BasisUnit,
	|	MF_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	MF_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	MF_BillOfMaterials.OutputID AS OutputID,
	|	MF_BillOfMaterials.UniqueID AS UniqueID
	|INTO Semiproduction
	|FROM
	|	PlannedProduced AS PlannedProduced
	|		INNER JOIN InformationRegister.MF_BillOfMaterials.SliceLast AS MF_BillOfMaterials
	|		ON (MF_BillOfMaterials.Company = PlannedProduced.Company)
	|			AND (MF_BillOfMaterials.BusinessUnit = PlannedProduced.BusinessUnit)
	|			AND (MF_BillOfMaterials.ItemKey = PlannedProduced.ItemKey)
	|			AND (MF_BillOfMaterials.IsSemiproduct = TRUE)
	|			AND (MF_BillOfMaterials.PlanningPeriod = PlannedProduced.PlanningPeriod)
	|			AND (MF_BillOfMaterials.BillOfMaterials = PlannedProduced.BillOfMaterials)
	|			AND (MF_BillOfMaterials.PlanningDocument = PlannedProduced.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	0 AS ItemPicture,
	|	VALUE(Enum.MF_ProductionTypes.Product) AS ProductionType,
	|	Production.Company AS Company,
	|	Production.BusinessUnit AS BusinessUnit,
	|	Production.StoreProduction AS StoreProduction,
	|	Production.Item AS Item,
	|	Production.ItemKey AS ItemKey,
	|	Production.PlanningPeriod AS PlanningPeriod,
	|	Production.BasisQuantity AS Quantity,
	|	Production.BasisUnit AS BasisUnit,
	|	Production.BillOfMaterials AS BillOfMaterials,
	|	Production.TotalQuantity AS TotalQuantity,
	|	Production.OutputID AS OutputID,
	|	Production.UniqueID AS UniqueID
	|FROM
	|	Production AS Production
	|WHERE
	|	Production.BasisQuantity > 0
	|
	|UNION ALL
	|
	|SELECT
	|	2,
	|	VALUE(Enum.MF_ProductionTypes.Semiproduct),
	|	Semiproduction.Company,
	|	Semiproduction.BusinessUnit,
	|	Semiproduction.StoreProduction,
	|	Semiproduction.Item,
	|	Semiproduction.ItemKey,
	|	Semiproduction.PlanningPeriod,
	|	Semiproduction.BasisQuantity,
	|	Semiproduction.BasisUnit,
	|	Semiproduction.BillOfMaterials,
	|	Semiproduction.TotalQuantity,
	|	Semiproduction.OutputID,
	|	Semiproduction.UniqueID
	|FROM
	|	Semiproduction AS Semiproduction
	|WHERE
	|	Semiproduction.BasisQuantity > 0";
	
	Query.SetParameter("Company"         , ThisObject.Company);
	Query.SetParameter("PlanningPeriod"  , ThisObject.PlanningPeriod);
	Query.SetParameter("BusinessUnits"   , ThisObject.BusinessUnits);
	Query.SetParameter("PlanningDocument", ThisObject.ProductionPlanning);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.ProductionTable.Load(QueryTable);
EndProcedure

&AtClient
Procedure ProductionTableSelectedOnChange(Item)
	CurrentData = Items.ProductionTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	RowID = CurrentData.GetID();
	For Each Row In ThisObject.ProductionTable Do
		If Row.GetID() = RowID Then
			Continue;
		EndIf;
		Row.Selected = False;
	EndDo;
EndProcedure

&AtClient
Procedure Ok(Command)
	Result = New Structure();
	Result.Insert("Company"           , ThisObject.Company);
	Result.Insert("PlanningPeriod"     , ThisObject.PlanningPeriod);
	Result.Insert("ProductionPlanning" , ThisObject.ProductionPlanning);
	ProductSelected = False;
	For Each Row In ThisObject.ProductionTable Do
		If Row.Selected Then
			ProductSelected = True;
			Result.Insert("ItemKey"         , Row.ItemKey);
			Result.Insert("Unit"            , Row.BasisUnit);
			Result.Insert("Quantity"        , Row.Quantity);
			Result.Insert("BillOfMaterials" , Row.BillOfMaterials);
			Result.Insert("TotalQuantity"   , Row.TotalQuantity);			
			Result.Insert("OutputID"        , Row.OutputID);
			Result.Insert("UniqueID"        , Row.UniqueID);
			Result.Insert("ProductionType"  , Row.ProductionType);
			Result.Insert("BusinessUnit"    , Row.BusinessUnit);
			Result.Insert("StoreProduction" , Row.StoreProduction);
			Break;
		EndIf;
	EndDo;
	If ProductSelected Then
		Close(Result);
	Else
		Close(Undefined);
	EndIf;
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure
