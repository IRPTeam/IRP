
Function GetUniquePlanningPeriodByDate(Date, BusinessUnit) Export
	Query = New Query();
	Query.Text = 
		"SELECT TOP 2
		|	Table.Ref AS Ref
		|FROM
		|	Catalog.PlanningPeriods.BusinessUnits AS TableBusinessUnits
		|		INNER JOIN Catalog.PlanningPeriods AS Table
		|		ON Table.Ref = TableBusinessUnits.Ref
		|		AND &Date BETWEEN Table.StartDate AND Table.EndDate
		|		AND NOT Table.DeletionMark
		|		AND TableBusinessUnits.BusinessUnit = &BusinessUnit";
	Query.SetParameter("Date", Date);
	Query.SetParameter("BusinessUnit", BusinessUnit);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Count() = 1 Then
		QuerySelection.Next();
		Return QuerySelection.Ref;
	EndIf;
	Return Catalogs.PlanningPeriods.EmptyRef();
EndFunction

Function FillBillOfMaterialsTable(Parameters) Export
	Query = New Query();
	//@skip-check bsl-ql-hub
	Query.Text =
	"SELECT
	|	&Key AS Key,
	|	&Company AS Company,
	|	(&BillOfMaterials).BusinessUnit AS BusinessUnit,
	|	&PlanningPeriod AS PlanningPeriod,
	|	&ItemKey AS ItemKey,
	|	&Quantity AS Quantity,
	|	&BillOfMaterials AS BillOfMaterials,
	|	0 AS BasisQuantity,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	&Unit AS Unit,
	|	(&ItemKey).Item.Unit AS ItemUnit,
	|	(&ItemKey).Unit AS ItemKeyUnit,
	|	(&ItemKey).Item AS Item,
	|	(&BillOfMaterials).BusinessUnit.ReleaseStore AS ReleaseStore,
	|	(&BillOfMaterials).BusinessUnit.MaterialStore AS MaterialStore,
	|	(&BillOfMaterials).BusinessUnit.SemiproductStore AS SemiproductStore,
	|	VALUE(Catalog.Stores.EmptyRef) AS Store,
	|	FALSE AS IsProduct,
	|	FALSE AS IsSemiproduct,
	|	FALSE AS IsMaterial,
	|	FALSE AS IsService";

	RequiredParameters = "Key, Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit";
	ArrayOfRequiredParameters = StrSplit(RequiredParameters, ",");
	AllParametersIsFilled = True;
	For Each RequiredParameter In ArrayOfRequiredParameters Do
		If Not ValueIsFilled(Parameters[TrimAll(RequiredParameter)]) Then
			AllParametersIsFilled = False;
			Break;
		EndIf;
	EndDo;
	
	If Not AllParametersIsFilled Then
		Return New Array();
	EndIf;
	
	QueryParameters = "Key, Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit, Quantity";
	ArrayOfQueryParameters = StrSplit(QueryParameters, ",");
	For Each QueryParameter In ArrayOfQueryParameters Do
		Query.SetParameter(TrimAll(QueryParameter), Parameters[TrimAll(QueryParameter)]);
	EndDo;
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	PostingServer.CalculateQuantityByUnit(QueryTable);
	
	QueryTable.Columns.Add("UniqueID" , New TypeDescription("String"));
	QueryTable.Columns.Add("InputID"  , New TypeDescription("String"));
	QueryTable.Columns.Add("OutputID" , New TypeDescription("String"));
	
	ExpandedTable = QueryTable.CopyColumns();
	For Each Row In QueryTable Do
		ItemKey_UUID         = Row.ItemKey.UUID();
		BillOfMaterials_UUID = Row.BillOfMaterials.UUID();
		
		Parameters = New Structure();
		Parameters.Insert("Company"        , Row.Company);
		Parameters.Insert("Key"            , Row.Key);
		Parameters.Insert("PlanningPeriod" , Row.PlanningPeriod);
		Parameters.Insert("UniqueID", "" + ItemKey_UUID + "-" + BillOfMaterials_UUID);
		
		Row.IsProduct = True;
		Row.BusinessUnit  = Row.BusinessUnit;
		Row.OutputID  = GetMD5(String(BillOfMaterials_UUID));
		
		Row.UniqueID  = Parameters.UniqueID;
		ExpandRecursive(ExpandedTable, Row.OutputID, Row.BillOfMaterials, Row.BasisQuantity, Row.BusinessUnit, 
			Row.ReleaseStore, Row.MaterialStore, Row.SemiproductStore, Parameters);
		Row.MaterialStore    = Undefined;
		Row.SemiproductStore = Undefined;
	EndDo;
	For Each Row In ExpandedTable Do
		FillPropertyValues(QueryTable.Add(), Row);
	EndDo;
	ArrayOfColumns = New Array();
	For Each Column In QueryTable.Columns Do
		ArrayOfColumns.Add(TrimAll(Column.Name));
	EndDo;
	Columns = StrConcat(ArrayOfColumns, ",");
	ArrayOfResult = New Array();
	For Each Row In QueryTable Do
		NewRow = New Structure(Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	Return ArrayOfResult;
EndFunction

Function FillBillOfMaterialsTableCorrection(Parameters) Export
	Query = New Query();
	//@skip-check bsl-ql-hub
	Query.Text = 
		"SELECT
		|	&Key AS Key,
		|	&Company AS Company,
		|	(&BillOfMaterials).BusinessUnit AS BusinessUnit,
		|	&PlanningPeriod AS PlanningPeriod,
		|	&ItemKey AS ItemKey,
		|	&Quantity AS Quantity,
		|	&CurrentQuantity AS CurrentQuantity,
		|	&BillOfMaterials AS BillOfMaterials,
		|	0 AS BasisQuantity,
		|	0 AS CurrentBasisQuantity,
		|	0 AS PlannedQuantity,
		|	0 AS PlannedBasisQuantity,
		|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
		|	&Unit AS Unit,
		|	VALUE(Catalog.Stores.EmptyRef) AS ReleaseStore,
		|	VALUE(Catalog.Stores.EmptyRef) AS MaterialStore,
		|	VALUE(Catalog.Stores.EmptyRef) AS SemiproductStore,
		|	FALSE AS IsProduct,
		|	FALSE AS IsSemiproduct,
		|	FALSE AS IsMaterial,
		|	FALSE AS IsService";
		
	RequiredParameters = "Key, Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit";
	ArrayOfRequiredParameters = StrSplit(RequiredParameters, ",");
	AllParametersIsFilled = True;
	For Each RequiredParameter In ArrayOfRequiredParameters Do
		If Not ValueIsFilled(Parameters[TrimAll(RequiredParameter)]) Then
			AllParametersIsFilled = False;
			Break;
		EndIf;
	EndDo;
	
	If Not AllParametersIsFilled Then
		Return New Array();
	EndIf;
	QueryParameters = "Key, Company, BillOfMaterials, PlanningPeriod, ItemKey, Unit, Quantity, CurrentQuantity";
	ArrayOfQueryParameters = StrSplit(QueryParameters, ",");
	For Each QueryParameter In ArrayOfQueryParameters Do
		Query.SetParameter(TrimAll(QueryParameter), Parameters[TrimAll(QueryParameter)]);
	EndDo;

	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	QueryTable.Columns.Add("UniqueID" , New TypeDescription("String"));
	QueryTable.Columns.Add("InputID"  , New TypeDescription("String"));
	QueryTable.Columns.Add("OutputID" , New TypeDescription("String"));

	RegDimensions = Metadata.InformationRegisters.T7010S_BillOfMaterials.Dimensions;
	RegResourses  = Metadata.InformationRegisters.T7010S_BillOfMaterials.Resources;
	TableForStores = New ValueTable();
	TableForStores.Columns.Add("Key"              , New TypeDescription("String"));
	TableForStores.Columns.Add("Company"          , RegDimensions.Company.Type);
	TableForStores.Columns.Add("BillOfMaterials"  , RegResourses.BillOfMaterials.Type);
	TableForStores.Columns.Add("PlanningPeriod"   , RegDimensions.PlanningPeriod.Type);
	TableForStores.Columns.Add("BusinessUnit"     , RegDimensions.BusinessUnit.Type);
	TableForStores.Columns.Add("ItemKey"          , RegDimensions.ItemKey.Type);
	TableForStores.Columns.Add("UniqueID"         , RegDimensions.UniqueID.Type);
	TableForStores.Columns.Add("InputID"          , RegDimensions.InputID.Type);
	TableForStores.Columns.Add("OutputID"         , RegDimensions.OutputID.Type);
	TableForStores.Columns.Add("NeedReleaseStore" , New TypeDescription("Boolean"));
	TableForStores.Columns.Add("NeedSemiproductStore" , New TypeDescription("Boolean"));
	TableForStores.Columns.Add("NeedMaterialStore" , New TypeDescription("Boolean"));
	
	ExpandedTable = QueryTable.CopyColumns();
	For Each Row In QueryTable Do
		ItemKey_UUID         = Row.ItemKey.UUID();
		BillOfMaterials_UUID = Row.BillOfMaterials.UUID();
		
		Parameters = New Structure();
		Parameters.Insert("Company"        , Row.Company);
		Parameters.Insert("Key"            , Row.Key);
		Parameters.Insert("PlanningPeriod" , Row.PlanningPeriod);
		Parameters.Insert("UniqueID", "" + ItemKey_UUID + "-" + BillOfMaterials_UUID);
		
		QuantityConvertation = Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(Row.ItemKey, Row.Unit, Row.Quantity);
		Row.BasisUnit      = QuantityConvertation.BasisUnit;
		Row.BasisQuantity  = QuantityConvertation.QuantityInBaseUnit;
		
		CurrentQuantityConvertation = Catalogs.Units.ConvertQuantityToQuantityInBaseUnit(Row.ItemKey, Row.Unit, Row.CurrentQuantity);
		Row.CurrentBasisQuantity = CurrentQuantityConvertation.QuantityInBaseUnit;
		
		Row.PlannedBasisQuantity = Row.BasisQuantity - CurrentQuantityConvertation.QuantityInBaseUnit;
		Row.PlannedQuantity      = Row.Quantity - Row.CurrentQuantity;
		
		Row.IsProduct = True;
		
		Row.BusinessUnit  = Row.BusinessUnit;
		Row.OutputID  = GetMD5(String(BillOfMaterials_UUID));		
		Row.UniqueID  = Parameters.UniqueID;
		
		NewRowForStores = TableForStores.Add();
		NewRowForStores.Key              = Row.Key;
		NewRowForStores.Company          = Row.Company;
		NewRowForStores.BillOfMaterials  = Row.BillOfMaterials;
		NewRowForStores.PlanningPeriod   = Row.PlanningPeriod;
		NewRowForStores.BusinessUnit     = Row.BusinessUnit;
		NewRowForStores.ItemKey          = Row.ItemKey;
		NewRowForStores.UniqueID         = Parameters.UniqueID;
		NewRowForStores.InputID          = Row.InputID;
		NewRowForStores.OutputID         = Row.OutputID;
		NewRowForStores.NeedReleaseStore = True;
		
		ExpandRecursiveCorrection(TableForStores, ExpandedTable, Row.OutputID, Row.BillOfMaterials, 
					Row.BasisQuantity, Row.CurrentBasisQuantity, Row.BusinessUnit, Parameters);
	EndDo;
	
	For Each Row In ExpandedTable Do
		FillPropertyValues(QueryTable.Add(), Row);
	EndDo;

	StoresFromRegBillOfMaterials(QueryTable, TableForStores);
	
	ArrayOfColumns = New Array();
	For Each Column In QueryTable.Columns Do
		ArrayOfColumns.Add(TrimAll(Column.Name));
	EndDo;
	Columns = StrConcat(ArrayOfColumns, ",");
	ArrayOfResult = New Array();
	For Each Row In QueryTable Do
		NewRow = New Structure(Columns);
		FillPropertyValues(NewRow, Row);
		ArrayOfResult.Add(NewRow);
	EndDo;
	
	Return ArrayOfResult;
EndFunction

Procedure FillMaterialsTable(Parameters) Export
	
	For Each Row In Parameters.Materials Do
		Row.ItemBOM     = Undefined;
		Row.ItemKeyBOM  = Undefined;
		Row.UnitBOM     = Undefined;
		Row.QuantityBOM = Undefined;
	EndDo;

	Query = New Query();
	Query.Text =
	"SELECT
	|	BillOfMaterialsContent.Ref AS BillOfMaterials,
	|	BillOfMaterialsContent.Ref.BusinessUnit.MaterialStore AS Store,
	|	VALUE(Enum.MaterialsCostWriteOff.IncludeToWorkCost) AS CostWriteOff,
	|	VALUE(Enum.ProcurementMethods.Stock) AS ProcurementMethod,
	|	BillOfMaterialsContent.Ref.BusinessUnit AS ProfitLossCenter,
	|	BillOfMaterialsContent.ExpenseType AS ExpenseType,
	|	BillOfMaterialsContent.Item AS ItemBOM,
	|	BillOfMaterialsContent.ItemKey AS ItemKeyBOM,
	|	BillOfMaterialsContent.Unit AS UnitBOM,
	|	BillOfMaterialsContent.Quantity AS QuantityBOM
	|FROM
	|	Catalog.BillOfMaterials.Content AS BillOfMaterialsContent
	|WHERE
	|	BillOfMaterialsContent.Ref = &Ref";
			
	Query.SetParameter("Ref", Parameters.BillOfMaterials);
	QueryResult = Query.Execute();
	
	BillOfMaterials_UUID = String(Parameters.BillOfMaterials.UUID());
	QueryTable = QueryResult.Unload();
	For Each Row In QueryTable Do
		RowUniqueID = String(Row.ItemKeyBOM.UUID()) + "-" + BillOfMaterials_UUID;
		RowsMaterials = New Array();
		For Each ArrayItem In Parameters.Materials Do
			If ArrayItem.ItemKey = Row.ItemKeyBOM Then
				RowsMaterials.Add(ArrayItem);
			EndIf;
		EndDo;
		
		RowMaterials = Undefined;
		If RowsMaterials.Count() Then
			RowMaterials = RowsMaterials[0];
			FillPropertyValues(RowMaterials, Row);
			RowMaterials.UniqueID = RowUniqueID;
		Else
			RowMaterials = New Structure(Parameters.MaterialsColumns);
			FillPropertyValues(RowMaterials, Row);
			RowMaterials.Key      = String(New UUID());
			RowMaterials.UniqueID = RowUniqueID;
			RowMaterials.Item     = Row.ItemBOM;
			RowMaterials.ItemKey  = Row.ItemKeyBOM;
			RowMaterials.Unit     = Row.UnitBOM;
			RowMaterials.Quantity = Row.QuantityBOM;
			Parameters.Materials.Add(RowMaterials);
		EndIf;
	EndDo;

	CalculateMaterialsQuantity(Parameters);
	
	For Each Row In Parameters.Materials Do
		If Not ValueIsFilled(Row.ItemKeyBOM) Then
			Row.UniqueID = "";
		EndIf;
		
		If Row.Property("KeyOwner") Then
			Row.KeyOwner = Parameters.KeyOwner;
		EndIf;
		
		If Row.Property("IsVisible") Then
			Row.IsVisible = True;
		EndIf;
	EndDo;
EndProcedure

Procedure CalculateMaterialsQuantity(Parameters) Export
	// Bill of materials (basis quantity)
	Quantity_BillOfMaterials = GetBasisQuantity(Parameters.BillOfMaterials.ItemKey, 
	                                            Parameters.BillOfMaterials.Unit, 
	                                            Parameters.BillOfMaterials.Quantity);
	
	If Quantity_BillOfMaterials = 0 Then
		Return;
	EndIf;
		
	Quantity_Produce = GetBasisQuantity(Parameters.ItemKey, Parameters.Unit, Parameters.Quantity); 
	
	For Each Row In Parameters.BillOfMaterials.Content Do
		q1 = (GetBasisQuantity(Row.ItemKey, Row.Unit, Row.Quantity) / Quantity_BillOfMaterials) * Quantity_Produce;
		
		ArrayOfRows = New Array();
		For Each ArrayItem In Parameters.Materials Do
			If ArrayItem.ItemKey = Row.ItemKey Then
				ArrayOfRows.Add(ArrayItem);
			EndIf;
		EndDo;
		
		For Each ItemOfRow In ArrayOfRows Do
			q2 = GetBasisQuantity(ItemOfRow.ItemKeyBOM, ItemOfRow.UnitBOM, 1);
			
			If q2 = 0 Then
				ItemOfRow.QuantityBOM = 0;
				If Not ItemOfRow.IsManualChanged Then
					ItemOfRow.Quantity = ItemOfRow.QuantityBOM;
				EndIf;
				Continue;
			EndIf;
			ItemOfRow.QuantityBOM = q1 / q2;
			If Not ItemOfRow.IsManualChanged = True Then
				ItemOfRow.Quantity = ItemOfRow.QuantityBOM;
			EndIf;
		EndDo; 	
	EndDo;
	
	For Each Row In Parameters.Materials Do
		If Row.Property("QuantityInBaseUnit") Then
			If Not ValueIsFilled(Row.ItemKey) Then
				Row.QuantityInBaseUnit = 0;
			Else
				UnitFactor = GetItemInfo.GetUnitFactor(Row.ItemKey, Row.Unit);
				Row.QuantityInBaseUnit = Row.Quantity * UnitFactor;
			EndIf;
		EndIf;
		
		If Row.Property("QuantityInBaseUnitBOM") Then
			If Not ValueIsFilled(Row.ItemKeyBOM) Then
				Row.QuantityInBaseUnitBOM = 0;
			Else
				UnitFactor = GetItemInfo.GetUnitFactor(Row.ItemKeyBOM, Row.UnitBOM);
				Row.QuantityInBaseUnitBOM = Row.QuantityBOM * UnitFactor;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

Function GetProductionFillingData(Parameters) Export
	FillingData = New Structure();
	FillingData.Insert("BasedOn"            , "ProductionPlanning");
	FillingData.Insert("ProductionPlanning" , Parameters.ProductionPlanning);
	FillingData.Insert("Company"            , Parameters.Company);
	FillingData.Insert("BusinessUnit"       , Parameters.BusinessUnit);
	FillingData.Insert("Branch"             , Parameters.ProductionPlanning.Branch);
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

Function GetBasisQuantity(ItemKey, Unit, Quantity)
	If  Not ValueIsFilled(ItemKey)
		Or Not ValueIsFilled(Unit)
		Or Not ValueIsFilled(Quantity) Then
		Return 0;
	EndIf;
	
	Table = New ValueTable();
	Table.Columns.Add("Item");
	Table.Columns.Add("ItemUnit");
	Table.Columns.Add("ItemKey");
	Table.Columns.Add("ItemKeyUnit");
	Table.Columns.Add("Unit");
	Table.Columns.Add("BasisUnit");
	Table.Columns.Add("Quantity");
	Table.Columns.Add("BasisQuantity");
	
	NewRow = Table.Add();
	NewRow.Item          = ItemKey.Item;
	NewRow.ItemUnit      = ItemKey.Item.Unit;
	NewRow.ItemKey       = ItemKey;
	NewRow.ItemKeyUnit   = ItemKey.Unit;
	NewRow.Unit          = Unit;
	NewRow.BasisUnit     = Catalogs.Units.EmptyRef();
	NewRow.Quantity      = Quantity;
	NewRow.BasisQuantity = 0;
	
	PostingServer.CalculateQuantityByUnit(Table);
	Return Table[0].BasisQuantity;	
EndFunction

Procedure StoresFromRegBillOfMaterials(TableBillOfMaterials, TableForStores)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	tmp.Key AS Key,
	|	tmp.Company AS Company,
	|	tmp.BillOfMaterials AS BillOfMaterials,
	|	tmp.PlanningPeriod AS PlanningPeriod,
	|	tmp.BusinessUnit AS BusinessUnit,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.UniqueID AS UniqueID,
	|	tmp.InputID AS InputID,
	|	tmp.OutputID AS OutputID,
	|	tmp.NeedReleaseStore AS NeedReleaseStore,
	|	tmp.NeedSemiproductStore AS NeedSemiproductStore,
	|	tmp.NeedMaterialStore AS NeedMaterialStore
	|INTO tmp
	|FROM
	|	&TableForStores AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Key AS Key,
	|	tmp.BillOfMaterials AS BillOfMaterials,
	|	tmp.PlanningPeriod AS PlanningPeriod,
	|	tmp.BusinessUnit AS BusinessUnit,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.UniqueID AS UniqueID,
	|	tmp.InputID AS InputID,
	|	tmp.OutputID AS OutputID,
	|	tmp.NeedReleaseStore AS NeedReleaseStore,
	|	tmp.NeedSemiproductStore AS NeedSemiproductStore,
	|	tmp.NeedMaterialStore AS NeedMaterialStore,
	|	CASE
	|		WHEN BOM.IsMaterial
	|			THEN BOM.WriteoffStore
	|		ELSE VALUE(Catalog.Stores.EmptyRef)
	|	END AS MaterialStore,
	|	CASE
	|		WHEN BOM.IsProduct
	|				OR BOM.IsSemiproduct
	|			THEN BOM.SurplusStore
	|		ELSE VALUE(Catalog.Stores.EmptyRef)
	|	END AS ReleaseStore,
	|	CASE
	|		WHEN BOM.IsSemiproduct
	|			THEN BOM.WriteoffStore
	|		ELSE VALUE(Catalog.Stores.EmptyRef)
	|	END AS SemiproductStore
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN InformationRegister.T7010S_BillOfMaterials.SliceLast(
	|				,
	|				(Company, BusinessUnit, PlanningPeriod, InputID, OutputID, UniqueID, ItemKey) IN
	|					(SELECT
	|						tmp.Company,
	|						tmp.BusinessUnit,
	|						tmp.PlanningPeriod,
	|						tmp.InputID,
	|						tmp.OutputID,
	|						tmp.UniqueID,
	|						tmp.ItemKey
	|					FROM
	|						tmp AS tmp)) AS BOM
	|		ON (BOM.Company = tmp.Company)
	|			AND (BOM.BusinessUnit = tmp.BusinessUnit)
	|			AND (BOM.PlanningPeriod = tmp.PlanningPeriod)
	|			AND (BOM.InputID = tmp.InputID)
	|			AND (BOM.OutputID = tmp.OutputID)
	|			AND (BOM.UniqueID = tmp.UniqueID)
	|			AND (BOM.ItemKey = tmp.ItemKey)
	|			AND (BOM.BillOfMaterials = tmp.BillOfMaterials)";
	Query.SetParameter("TableForStores" , TableForStores);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	For Each Row In TableBillOfMaterials Do
		Filter = New Structure();
		Filter.Insert("Key"             , Row.Key);
		Filter.Insert("BillOfMaterials" , 
		?(ValueIsFilled(Row.BillOfMaterials), Row.BillOfMaterials, Catalogs.BillOfMaterials.EmptyRef()));
		Filter.Insert("PlanningPeriod"  , Row.PlanningPeriod);
		Filter.Insert("BusinessUnit"    , Row.BusinessUnit);
		Filter.Insert("ItemKey"         , Row.ItemKey);
		Filter.Insert("UniqueID"        , Row.UniqueID);
		Filter.Insert("InputID"         , Row.InputID);
		Filter.Insert("OutputID"        , Row.OutputID);
		
		RowsWithStores = QueryTable.FindRows(Filter);
		
		If RowsWithStores.Count() Then
			Stores = RowsWithStores[0];
		Else
			Raise "RowsWithStores.Count() = 0";
		EndIf;
		
		If Stores.NeedReleaseStore Then	
			If ValueIsFilled(Stores.ReleaseStore) Then
				Row.ReleaseStore = Stores.ReleaseStore;
			Else
				Row.ReleaseStore = Stores.BusinessUnit.ReleaseStore;
			EndIf;
		EndIf;
		
		If Stores.NeedSemiproductStore Then	
			If ValueIsFilled(Stores.SemiproductStore) Then
				Row.SemiproductStore = Stores.SemiproductStore;
			Else
				Row.SemiproductStore = Stores.BusinessUnit.SemiproductStore;
			EndIf;
		EndIf;
		
		If Stores.NeedMaterialStore Then				
			If ValueIsFilled(Stores.MaterialStore) Then
				Row.MaterialStore = Stores.MaterialStore;
			Else
				Row.MaterialStore = Stores.BusinessUnit.MaterialStore;
			EndIf;			
		EndIf;
	EndDo;
EndProcedure

Procedure ExpandRecursiveCorrection(TableForStores, ExpandedTable, InputID, BillOfMaterials, 
										InputBasisQuantity, CurrentInputBasisQuantity, BusinessUnit, Parameters)
	BillOfMaterialsInfo = GetInfoBillOfMaterials(BillOfMaterials);
	UnitFactor = InputBasisQuantity / BillOfMaterialsInfo.BasisQuantity;
	CurrentUnitFactor = CurrentInputBasisQuantity / BillOfMaterialsInfo.BasisQuantity;
	For Each Row In BillOfMaterialsInfo.Materials Do
		If  ValueIsFilled(Row.BillOfMaterials) Then
			// Semiproduct
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey         = Row.ItemKey;
			NewRow.IsSemiproduct   = True;
			NewRow.BillOfMaterials = Row.BillOfMaterials;
			NewRow.InputID         = InputID;
			NewRow.OutputID        = GetMD5(InputID + String(Row.BillOfMaterials.UUID()));
			
			NewRow.Unit            = Row.Unit;
			NewRow.Quantity        = Row.Quantity * UnitFactor;
			NewRow.CurrentQuantity = Row.Quantity * CurrentUnitFactor;
			NewRow.BasisUnit       = Row.BasisUnit;
			NewRow.BasisQuantity   = Row.BasisQuantity * UnitFactor;
			NewRow.CurrentBasisQuantity = Row.BasisQuantity * CurrentUnitFactor;
			
			NewRow.PlannedBasisQuantity = NewRow.BasisQuantity - NewRow.CurrentBasisQuantity;
			NewRow.PlannedQuantity      = NewRow.Quantity - NewRow.CurrentQuantity;
			
			NewRow.UniqueID        = Parameters.UniqueID;
			NewRow.Key             = Parameters.Key;
			NewRow.BusinessUnit    = Row.BillOfMaterials.BusinessUnit;
					
			NewRowForStores = TableForStores.Add();
			NewRowForStores.Key              = Parameters.Key;
			NewRowForStores.Company          = Parameters.Company;
			NewRowForStores.BillOfMaterials  = Row.BillOfMaterials;
			NewRowForStores.PlanningPeriod   = Parameters.PlanningPeriod;
			NewRowForStores.BusinessUnit     = NewRow.BusinessUnit;
			NewRowForStores.ItemKey          = Row.ItemKey;
			NewRowForStores.UniqueID         = Parameters.UniqueID;
			NewRowForStores.InputID          = NewRow.InputID;
			NewRowForStores.OutputID         = NewRow.OutputID;
			NewRowForStores.NeedReleaseStore = True;
			NewRowForStores.NeedSemiproductStore = True;
			
			ExpandRecursiveCorrection(TableForStores, ExpandedTable, NewRow.OutputID, NewRow.BillOfMaterials, 
								NewRow.BasisQuantity, NewRow.CurrentBasisQUantity, NewRow.BusinessUnit, Parameters);
		ElsIf Row.IsService Then
			// Service
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey       = Row.ItemKey;
			NewRow.IsService     = True;
			NewRow.InputID       = InputID;
			NewRow.Unit          = Row.Unit;
			NewRow.Quantity      = Row.Quantity * UnitFactor;
			NewRow.CurrentQuantity = Row.Quantity * CurrentUnitFactor;
			NewRow.BasisUnit     = Row.BasisUnit;
			NewRow.BasisQuantity = Row.BasisQuantity * UnitFactor;
			NewRow.CurrentBasisQuantity = Row.BasisQuantity * CurrentUnitFactor;
			NewRow.UniqueID      = Parameters.UniqueID;
			NewRow.Key           = Parameters.Key;
			NewRow.BusinessUnit  = BusinessUnit;
			
			// Planned quantity
			NewRow.PlannedBasisQuantity = NewRow.BasisQuantity - NewRow.CurrentBasisQuantity;
			NewRow.PlannedQuantity      = NewRow.Quantity - NewRow.CurrentQuantity;
		Else
			// Material
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey       = Row.ItemKey;
			NewRow.IsMaterial    = True;
			NewRow.InputID       = InputID;
			NewRow.Unit          = Row.Unit;
			NewRow.Quantity      = Row.Quantity * UnitFactor;
			NewRow.CurrentQuantity = Row.Quantity * CurrentUnitFactor;
			NewRow.BasisUnit     = Row.BasisUnit;
			NewRow.BasisQuantity = Row.BasisQuantity * UnitFactor;
			NewRow.CurrentBasisQuantity = Row.BasisQuantity * CurrentUnitFactor;
			NewRow.UniqueID      = Parameters.UniqueID;
			NewRow.Key           = Parameters.Key;
			NewRow.BusinessUnit  = BusinessUnit;
			
			NewRow.PlannedBasisQuantity = NewRow.BasisQuantity - NewRow.CurrentBasisQuantity;
			NewRow.PlannedQuantity      = NewRow.Quantity - NewRow.CurrentQuantity;
			
			NewRowForStores = TableForStores.Add();
			NewRowForStores.Key              = Parameters.Key;
			NewRowForStores.Company          = Parameters.Company;
			NewRowForStores.BillOfMaterials  = Row.BillOfMaterials;
			NewRowForStores.PlanningPeriod   = Parameters.PlanningPeriod;
			NewRowForStores.BusinessUnit     = NewRow.BusinessUnit;
			NewRowForStores.ItemKey          = Row.ItemKey;
			NewRowForStores.UniqueID         = Parameters.UniqueID;
			NewRowForStores.InputID          = NewRow.InputID;
			NewRowForStores.OutputID         = NewRow.OutputID;
			NewRowForStores.NeedMaterialStore = True;

		EndIf;
	EndDo;
EndProcedure

Function GetMD5(StringValue)
	DataHashing = New DataHashing(HashFunction.MD5);
	DataHashing.Append(StringValue);
	Return DataHashing.HashSum;
EndFunction

Procedure ExpandRecursive(ExpandedTable, InputID, BillOfMaterials, InputBasisQuantity, BusinessUnit, 
							ReleaseStore, MaterialStore, SemiproductStore, Parameters)
	BillOfMaterialsInfo = GetInfoBillOfMaterials(BillOfMaterials);
	UnitFactor = InputBasisQuantity / BillOfMaterialsInfo.BasisQuantity;
	For Each Row In BillOfMaterialsInfo.Materials Do
		If  ValueIsFilled(Row.BillOfMaterials) Then
			// Semiproduct
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey         = Row.ItemKey;
			NewRow.IsSemiproduct   = True;
			NewRow.BillOfMaterials = Row.BillOfMaterials;
			NewRow.InputID         = InputID;
			NewRow.OutputID        = GetMD5(InputID + String(Row.BillOfMaterials.UUID()));
			
			NewRow.Unit            = Row.Unit;
			NewRow.Quantity        = Row.Quantity * UnitFactor;
			NewRow.BasisUnit       = Row.BasisUnit;
			NewRow.BasisQuantity   = Row.BasisQuantity * UnitFactor;
			
			NewRow.UniqueID        = Parameters.UniqueID;
			NewRow.Key             = Parameters.Key;
			
			_ReleaseStore     = Row.BillOfMaterials.BusinessUnit.ReleaseStore;
			_MaterialStore    = Row.BillOfMaterials.BusinessUnit.MaterialStore;
			_SemiproductStore = Row.BillOfMaterials.BusinessUnit.SemiproductStore;
			
			NewRow.ReleaseStore     = _ReleaseStore;
			NewRow.SemiproductStore = _SemiproductStore;
			NewRow.BusinessUnit    = Row.BillOfMaterials.BusinessUnit;
			
			ExpandRecursive(ExpandedTable, NewRow.OutputID, NewRow.BillOfMaterials, NewRow.BasisQuantity, 
				NewRow.BusinessUnit, _ReleaseStore, _MaterialStore, _SemiproductStore, Parameters);
		ElsIf Row.IsService Then
			// Service
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey       = Row.ItemKey;
			NewRow.IsService     = True;
			NewRow.InputID       = InputID;
			NewRow.Unit          = Row.Unit;
			NewRow.Quantity      = Row.Quantity * UnitFactor;
			NewRow.BasisUnit     = Row.BasisUnit;
			NewRow.BasisQuantity = Row.BasisQuantity * UnitFactor;
			NewRow.UniqueID      = Parameters.UniqueID;
			NewRow.Key           = Parameters.Key;
			NewRow.BusinessUnit  = BusinessUnit;
		Else
			// Material
			NewRow = ExpandedTable.Add();
			FillPropertyValues(NewRow, Parameters);
			NewRow.ItemKey       = Row.ItemKey;
			NewRow.IsMaterial    = True;
			NewRow.InputID       = InputID;
			NewRow.Unit          = Row.Unit;
			NewRow.Quantity      = Row.Quantity * UnitFactor;
			NewRow.BasisUnit     = Row.BasisUnit;
			NewRow.BasisQuantity = Row.BasisQuantity * UnitFactor;
			NewRow.UniqueID      = Parameters.UniqueID;
			NewRow.Key           = Parameters.Key;
			
			NewRow.MaterialStore = MaterialStore;
			NewRow.BusinessUnit  = BusinessUnit;
		EndIf;
	EndDo;
EndProcedure

Function GetInfoBillOfMaterials(BillOfMaterials) 
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BillOfMaterials.ItemKey AS ItemKey,
	|	BillOfMaterials.ItemKey.Item AS Item,
	|	BillOfMaterials.Unit AS Unit,
	|	BillOfMaterials.ItemKey.Unit AS ItemKeyUnit,
	|	BillOfMaterials.ItemKey.Item.Unit AS ItemUnit,
	|	BillOfMaterials.Quantity AS Quantity,
	|	0 AS BasisQuantity,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit
	|FROM
	|	Catalog.BillOfMaterials AS BillOfMaterials
	|WHERE
	|	BillOfMaterials.Ref = &Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	BillOfMaterialsContent.ItemKey,
	|	BillOfMaterialsContent.Quantity,
	|	BillOfMaterialsContent.Unit,
	|	BillOfMaterialsContent.BillOfMaterials,
	|	BillOfMaterialsContent.ItemKey.Item AS Item,
	|	BillOfMaterialsContent.Unit AS Unit,
	|	BillOfMaterialsContent.ItemKey.Unit AS ItemKeyUnit,
	|	BillOfMaterialsContent.ItemKey.Item.Unit AS ItemUnit,
	|	BillOfMaterialsContent.Quantity AS Quantity,
	|	0 AS BasisQuantity,
	|	VALUE(Catalog.Units.EmptyRef) AS BasisUnit,
	|	CASE
	|		WHEN BillOfMaterialsContent.ItemKey.Item.ItemType.Type = Value(enum.ItemTypes.Service)
	|			Then true
	|		ELSE FALSE
	|	END AS IsService
	|FROM
	|	Catalog.BillOfMaterials.Content AS BillOfMaterialsContent
	|WHERE
	|	BillOfMaterialsContent.Ref = &Ref";
	Query.SetParameter("Ref", BillOfMaterials);
	QueryResults = Query.ExecuteBatch();
	
	QuantityTable = QueryResults[0].Unload();
	PostingServer.CalculateQuantityByUnit(QuantityTable);
	
	MaterialsTable = QueryResults[1].Unload();
	PostingServer.CalculateQuantityByUnit(MaterialsTable);
	Result = New Structure();
	Result.Insert("BasisQuantity" , QuantityTable[0].BasisQuantity);
	Result.Insert("Materials", MaterialsTable);
	Return Result;
EndFunction

Function GetDurationOfProductionByBillOfMaterials(BillOfMaterials, ItemKey, Unit, Quantity, CurrentDurationOfProduction) Export
	If Not ValueIsFilled(BillOfMaterials) Then
		Return CurrentDurationOfProduction;
	EndIf;
			
	If Not ValueIsFilled(BillOfMaterials.Quantity) Then
		Return CurrentDurationOfProduction;
	EndIf;
	
	UnitFactor = GetItemInfo.GetUnitFactor(BillOfMaterials.ItemKey, BillOfMaterials.Unit);
	QuantityInBaseUnit = BillOfMaterials.Quantity * UnitFactor;
	If Not ValueIsFilled(QuantityInBaseUnit) Then
		Return CurrentDurationOfProduction;
	EndIf;
	DurationInBasisUnit = (BillOfMaterials.Quantity / QuantityInBaseUnit) * BillOfMaterials.DurationOfProduction;
	
	UnitFactor = GetItemInfo.GetUnitFactor(ItemKey, Unit);
	QuantityInBaseUnit = Quantity * UnitFactor;
	
	Return QuantityInBaseUnit * DurationInBasisUnit;
EndFunction

