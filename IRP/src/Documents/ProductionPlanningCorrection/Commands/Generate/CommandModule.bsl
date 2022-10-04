
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	FillingData = GetFillingData(CommandParameter);
	OpenForm("Document.MF_ProductionPlanningCorrection.ObjectForm", 
	New Structure("FillingValues", FillingData), , New UUID());
EndProcedure

&AtServer
Function GetFillingData(ProductionPlanningRef)	
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
	|				AND PlanningDocument = &ProductionPlanning) AS Planned
	|		FULL JOIN AccumulationRegister.MF_ProductionPlanning.Turnovers(
	|				,
	|				,
	|				,
	|				PlanningPeriod = &PlanningPeriod
	|					AND PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.PlanAdjustment)
	|					AND Company = &Company
	|					AND PlanningDocument = &ProductionPlanning) AS Correction
	|		ON Planned.Company = Correction.Company
	|			AND Planned.BusinessUnit = Correction.BusinessUnit
	|			AND Planned.PlanningDocument = Correction.PlanningDocument
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
	|	MF_BillOfMaterials.BasisUnit AS BasisUnit,
	|	MF_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	MF_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	MF_BillOfMaterials.OutputID AS OutputID,
	|	MF_BillOfMaterials.UniqueID AS UniqueID
	|INTO Production
	|FROM
	|	Planned AS Planned
	|		INNER JOIN InformationRegister.MF_BillOfMaterials.SliceLast AS MF_BillOfMaterials
	|		ON (MF_BillOfMaterials.Company = Planned.Company)
	|			AND (MF_BillOfMaterials.BusinessUnit = Planned.BusinessUnit)
	|			AND (MF_BillOfMaterials.ItemKey = Planned.ItemKey)
	|			AND (MF_BillOfMaterials.IsProduct = TRUE)
	|			AND (MF_BillOfMaterials.PlanningPeriod = Planned.PlanningPeriod)
	|			AND (MF_BillOfMaterials.BillOfMaterials = Planned.BillOfMaterials)
	|			AND (MF_BillOfMaterials.PlanningDocument = Planned.PlanningDocument)
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
		
	Query.SetParameter("Company"            , ProductionPlanningRef.Company);
	Query.SetParameter("ProductionPlanning" , ProductionPlanningRef);
	Query.SetParameter("PlanningPeriod"     , ProductionPlanningRef.PlanningPeriod);
	
	FillingData = New Structure();
	FillingData.Insert("BasedOn"           ,"MF_ProductionPlanning");
	FillingData.Insert("ProductionPlanning", ProductionPlanningRef);
	FillingData.Insert("PlanningPeriod"    , ProductionPlanningRef.PlanningPeriod);
	FillingData.Insert("Company"           , ProductionPlanningRef.Company);
	FillingData.Insert("BusinessUnit"      , ProductionPlanningRef.BusinessUnit);
	FillingData.Insert("Productions"       , New Array());
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();		
	While QuerySelection.Next() Do
		NewRow = New Structure();
		NewRow.Insert("Item"            , QuerySelection.Item);
		NewRow.Insert("ItemKey"         , QuerySelection.ItemKey);
		NewRow.Insert("Unit"            , QuerySelection.BasisUnit);
		NewRow.Insert("CurrentQuantity" , QuerySelection.BasisQuantity);
		NewRow.Insert("BillOfMaterials" , QuerySelection.BillOfMaterials);
		FillingData.Productions.Add(NewRow);
	EndDo;
	Return FillingData;
EndFunction
