
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
