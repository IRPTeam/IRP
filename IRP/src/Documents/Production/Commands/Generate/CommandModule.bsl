
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	OpeningParameters = GetChoiceProductionParameters(CommandParameter);
	Notify = New NotifyDescription("ChoiceProductionContinue", ThisObject);
	OpenForm("Document.Production.Form.ChoiceProductionForm"
	,OpeningParameters, CommandExecuteParameters.Source, New UUID()
	,,,Notify,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ChoiceProductionContinue(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	FillingData = GetProductionFillingData(Result);
	OpenForm("Document.Production.ObjectForm", 
	New Structure("FillingValues", FillingData), , New UUID());
EndProcedure

&AtServer
Function GetProductionFillingData(Parameters)
	FillingData = New Structure();
	FillingData.Insert("BasedOn"            , "ProductionPlanning");
	FillingData.Insert("ProductionPlanning" , Parameters.ProductionPlanning);
	FillingData.Insert("Company"            , Parameters.Company);
	FillingData.Insert("BusinessUnit"       , Parameters.BusinessUnit);
	FillingData.Insert("StoreProduction"    , Parameters.StoreProduction);
	FillingData.Insert("Item"               , Parameters.ItemKey.Item);
	FillingData.Insert("ItemKey"            , Parameters.ItemKey);
	FillingData.Insert("Unit"               , Parameters.Unit);
	FillingData.Insert("Quantity"           , Parameters.Quantity);
	FillingData.Insert("BillOfMaterials"    , Parameters.BillOfMaterials);
	FillingData.Insert("PlanningPeriod"     , Parameters.PlanningPeriod);
	FillingData.Insert("ProductionType"     , Parameters.ProductionType);
		
	FillingData.Insert("Materials" , GetMaterials(Parameters));
			
	Return FillingData;	
EndFunction	

&AtServer
Function GetMaterials(Parameters)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	T7010S_BillOfMaterials.ItemKey.Item AS Item,
	|	T7010S_BillOfMaterials.ItemKey,
	|	T7010S_BillOfMaterials.BasisUnit AS Unit,
	|	T7010S_BillOfMaterials.WriteoffStore,
	|	CASE
	|		WHEN T7010S_BillOfMaterials.IsSemiproduct
	|			THEN VALUE(Enum.MaterialTypes.Semiproduct)
	|		WHEN T7010S_BillOfMaterials.IsService
	|			THEN VALUE(Enum.MaterialTypes.Service)
	|		ELSE VALUE(Enum.MaterialTypes.Material)
	|	END AS MaterialType,
	|	CASE
	|		WHEN &TotalQuantity = 0
	|			THEN 0
	|		ELSE T7010S_BillOfMaterials.BasisQuantity / &TotalQuantity * &Quantity
	|	END AS Quantity
	|FROM
	|	InformationRegister.T7010S_BillOfMaterials.SliceLast(, Company = &Company
	|	AND InputID = &OutputID
	|	AND UniqueID = &UniqueID
	|	AND PlanningPeriod = &PlanningPeriod) AS T7010S_BillOfMaterials";
	
	Query.SetParameter("Company"        , Parameters.Company);
	Query.SetParameter("OutputID"       , Parameters.OutputID);
	Query.SetParameter("UniqueID"       , Parameters.UniqueID);
	Query.SetParameter("PlanningPeriod" , Parameters.PlanningPeriod);
	Query.SetParameter("TotalQuantity"  , Parameters.TotalQuantity);
	Query.SetParameter("Quantity"       , Parameters.Quantity);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ArrayOfMaterials = New Array();
	While QuerySelection.Next() Do
		NewRow = New Structure("Item, ItemKey, Unit, Quantity, Procurement, MaterialType, WriteoffStore");
		FillPropertyValues(NewRow, QuerySelection);
		ArrayOfMaterials.Add(NewRow);
	EndDo;
	Return ArrayOfMaterials;
EndFunction

&AtServer
Function GetChoiceProductionParameters(ProductionPlanningRef)
	Parameters = New Structure();
	Parameters.Insert("Company"              , ProductionPlanningRef.Company);
	Parameters.Insert("PlanningPeriod"       , ProductionPlanningRef.PlanningPeriod);
	Parameters.Insert("ProductionPlanning"   , ProductionPlanningRef);
	Parameters.Insert("ArrayOfBusinessUnits" , New Array());
	For Each Row In ProductionPlanningRef.BillOfMaterials Do
		If Parameters.ArrayOfBusinessUnits.Find(Row.BusinessUnit) = Undefined Then
			Parameters.ArrayOfBusinessUnits.Add(Row.BusinessUnit);
		EndIf;
	EndDo;
	Return Parameters;
EndFunction
