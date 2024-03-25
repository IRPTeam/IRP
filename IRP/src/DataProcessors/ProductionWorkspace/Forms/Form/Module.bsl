&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	If Not ValueIsFilled(Barcode) Then
		Return;
	EndIf;
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
EndProcedure

&AtClient
Async Procedure InputBarcode(Command)
	Barcode = "";
	Barcode = Await InputStringAsync(Barcode);
	SearchByBarcode(Undefined, Barcode);
EndProcedure

&AtClient
Procedure PlanningRefreshRequestProcessing(Item)
	PlanningRefreshRequestProcessingAtServer();
EndProcedure

&AtServer
Procedure PlanningRefreshRequestProcessingAtServer()
	If ThisObject.ItemKey.IsEmpty() Then
		ThisObject.Planning.Clear(); 
		ThisObject.PlanningPresentation.Clear();
		Return;
	EndIf;
	Query = New Query;
	Query.Text =
	"SELECT
	|	PlanningPeriods.Ref AS PlanningPeriod
	|INTO PlanningPeriods
	|FROM
	|	Catalog.PlanningPeriods AS PlanningPeriods
	|WHERE
	|	PlanningPeriods.IsManufacturing
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
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
	|	AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod IN
	|		(SELECT
	|			PlanningPeriods.PlanningPeriod
	|		FROM
	|			PlanningPeriods)
	|	AND PlanningType = VALUE(Enum.ProductionPlanningTypes.Planned)
	|	AND ItemKey = &ItemKey) AS Planned
	|		FULL JOIN AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod IN
	|			(SELECT
	|				PlanningPeriods.PlanningPeriod
	|			FROM
	|				PlanningPeriods AS PlanningPeriods)
	|		AND PlanningType = VALUE(Enum.ProductionPlanningTypes.PlanAdjustment)
	|		AND ItemKey = &ItemKey) AS Correction
	|		ON Planned.Company = Correction.Company
	|		AND Planned.BusinessUnit = Correction.BusinessUnit
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
	|	AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod IN
	|		(SELECT
	|			PlanningPeriods.PlanningPeriod
	|		FROM
	|			PlanningPeriods AS PlanningPeriods)
	|	AND PlanningType = VALUE(Enum.ProductionPlanningTypes.Produced)
	|	AND ItemKey = &ItemKey) AS Produced
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Closing.Company AS Company,
	|	Closing.BusinessUnit AS BusinessUnit,
	|	Closing.ItemKey AS ItemKey,
	|	Closing.PlanningType AS PlanningType,
	|	Closing.PlanningPeriod AS PlanningPeriod,
	|	Closing.BillOfMaterials AS BillOfMaterials,
	|	Closing.PlanningDocument AS PlanningDocument,
	|	Closing.QuantityTurnover AS Quantity
	|INTO Closing
	|FROM
	|	AccumulationRegister.R7030T_ProductionPlanning.Turnovers(,,, PlanningPeriod IN
	|		(SELECT
	|			PlanningPeriods.PlanningPeriod
	|		FROM
	|			PlanningPeriods AS PlanningPeriods)
	|	AND PlanningType = VALUE(Enum.ProductionPlanningTypes.Closing)
	|	AND ItemKey = &ItemKey) AS Closing
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
	|INTO PlannedProducedTmp
	|FROM
	|	Planned AS Planned
	|		LEFT JOIN Produced AS Produced
	|		ON Planned.Company = Produced.Company
	|		AND Planned.BusinessUnit = Produced.BusinessUnit
	|		AND Planned.ItemKey = Produced.ItemKey
	|		AND Planned.PlanningPeriod = Produced.PlanningPeriod
	|		AND Planned.BillOfMaterials = Produced.BillOfMaterials
	|		AND Planned.PlanningDocument = Produced.PlanningDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PlannedProducedTmp.Company AS Company,
	|	PlannedProducedTmp.BusinessUnit AS BusinessUnit,
	|	PlannedProducedTmp.ItemKey.Item AS Item,
	|	PlannedProducedTmp.ItemKey AS ItemKey,
	|	PlannedProducedTmp.PlanningPeriod AS PlanningPeriod,
	|	PlannedProducedTmp.BillOfMaterials AS BillOfMaterials,
	|	PlannedProducedTmp.PlanningDocument AS PlanningDocument,
	|	PlannedProducedTmp.BasisQuantity + ISNULL(Closing.Quantity, 0) AS BasisQuantity
	|INTO PlannedProduced
	|FROM
	|	PlannedProducedTmp AS PlannedProducedTmp
	|		LEFT JOIN Closing AS Closing
	|		ON PlannedProducedTmp.Company = Closing.Company
	|		AND PlannedProducedTmp.BusinessUnit = Closing.BusinessUnit
	|		AND PlannedProducedTmp.ItemKey = Closing.ItemKey
	|		AND PlannedProducedTmp.PlanningPeriod = Closing.PlanningPeriod
	|		AND PlannedProducedTmp.BillOfMaterials = Closing.BillOfMaterials
	|		AND PlannedProducedTmp.PlanningDocument = Closing.PlanningDocument
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PlannedProduced.PlanningDocument AS PlanningDocument,
	|	PlannedProduced.Company AS Company,
	|	PlannedProduced.BusinessUnit AS BusinessUnit,
	|	T7010S_BillOfMaterials.SurplusStore AS StoreProduction,
	|	PlannedProduced.Item AS Item,
	|	PlannedProduced.ItemKey AS ItemKey,
	|	PlannedProduced.PlanningPeriod AS PlanningPeriod,
	|	PlannedProduced.BasisQuantity AS BasisQuantity,
	|	T7010S_BillOfMaterials.BasisUnit AS BasisUnit,
	|	T7010S_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	T7010S_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	T7010S_BillOfMaterials.OutputID AS OutputID,
	|	T7010S_BillOfMaterials.UniqueID AS UniqueID
	|INTO Production
	|FROM
	|	PlannedProduced AS PlannedProduced
	|		INNER JOIN InformationRegister.T7010S_BillOfMaterials.SliceLast AS T7010S_BillOfMaterials
	|		ON (T7010S_BillOfMaterials.Company = PlannedProduced.Company)
	|		AND (T7010S_BillOfMaterials.BusinessUnit = PlannedProduced.BusinessUnit)
	|		AND (T7010S_BillOfMaterials.ItemKey = PlannedProduced.ItemKey)
	|		AND (T7010S_BillOfMaterials.IsProduct = TRUE)
	|		AND (T7010S_BillOfMaterials.PlanningPeriod = PlannedProduced.PlanningPeriod)
	|		AND (T7010S_BillOfMaterials.BillOfMaterials = PlannedProduced.BillOfMaterials)
	|		AND (T7010S_BillOfMaterials.PlanningDocument = PlannedProduced.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PlannedProduced.PlanningDocument AS PlanningDocument,
	|	PlannedProduced.Company AS Company,
	|	PlannedProduced.BusinessUnit AS BusinessUnit,
	|	T7010S_BillOfMaterials.SurplusStore AS StoreProduction,
	|	PlannedProduced.Item AS Item,
	|	PlannedProduced.ItemKey AS ItemKey,
	|	PlannedProduced.PlanningPeriod AS PlanningPeriod,
	|	PlannedProduced.BasisQuantity AS BasisQuantity,
	|	T7010S_BillOfMaterials.BasisUnit AS BasisUnit,
	|	T7010S_BillOfMaterials.BillOfMaterials AS BillOfMaterials,
	|	T7010S_BillOfMaterials.BasisQuantity AS TotalQuantity,
	|	T7010S_BillOfMaterials.OutputID AS OutputID,
	|	T7010S_BillOfMaterials.UniqueID AS UniqueID
	|INTO Semiproduction
	|FROM
	|	PlannedProduced AS PlannedProduced
	|		INNER JOIN InformationRegister.T7010S_BillOfMaterials.SliceLast AS T7010S_BillOfMaterials
	|		ON (T7010S_BillOfMaterials.Company = PlannedProduced.Company)
	|		AND (T7010S_BillOfMaterials.BusinessUnit = PlannedProduced.BusinessUnit)
	|		AND (T7010S_BillOfMaterials.ItemKey = PlannedProduced.ItemKey)
	|		AND (T7010S_BillOfMaterials.IsSemiproduct = TRUE)
	|		AND (T7010S_BillOfMaterials.PlanningPeriod = PlannedProduced.PlanningPeriod)
	|		AND (T7010S_BillOfMaterials.BillOfMaterials = PlannedProduced.BillOfMaterials)
	|		AND (T7010S_BillOfMaterials.PlanningDocument = PlannedProduced.PlanningDocument)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Production.PlanningDocument AS ProductionPlanning,
	|	VALUE(Enum.ProductionTypes.Product) AS ProductionType,
	|	Production.Company AS Company,
	|	Production.BusinessUnit AS BusinessUnit,
	|	Production.StoreProduction AS StoreProduction,
	|	Production.Item AS Item,
	|	Production.ItemKey AS ItemKey,
	|	Production.PlanningPeriod AS PlanningPeriod,
	|	Production.BasisQuantity AS LeftToProduce,
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
	|	Semiproduction.PlanningDocument,
	|	VALUE(Enum.ProductionTypes.Semiproduct),
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
	
	Query.SetParameter("CurrentDate", BegOfDay(CurrentSessionDate()));
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	ThisObject.Planning.Clear(); 
	
	tmpPlanning = New ValueTable();
	tmpPlanning.Columns.Add("PlanningPeriod");
	tmpPlanning.Columns.Add("LeftToProduce");
	tmpPlanning.Columns.Add("ProductionPlanning");
		
	While QuerySelection.Next() Do
		NewRow = ThisObject.Planning.Add();
		FillPropertyValues(NewRow, QuerySelection);
		
		tmpNewRow = tmpPlanning.Add();
		FillPropertyValues(tmpNewRow, QuerySelection);
	EndDo;
	
	tmpPlanning.GroupBy("PlanningPeriod, LeftToProduce, ProductionPlanning");
	For Each Row In tmpPlanning Do
		NewRow = ThisObject.PlanningPresentation.Add();
		FillPropertyValues(NewRow, Row);
		NewRow.Key = String(New UUID());
		Filter = New Structure("PlanningPeriod, LeftToProduce, ProductionPlanning");
		FillPropertyValues(Filter, Row);
		ArrayOfRows = ThisObject.Planning.FindRows(Filter);
		For Each ItemOfArray In ArrayOfRows Do
			ItemOfArray.Key = NewRow.Key;
		EndDo;
	EndDo;
EndProcedure

&AtServer
Procedure Clear()
	ThisObject.Planning.Clear();
	ThisObject.PlanningPresentation.Clear();
	Item = Undefined;
	ItemKey = Undefined;
	Unit = Undefined;
	Quantity = 0;

	EnableButtons();
EndProcedure

&AtClient
Procedure QuantityOnChange()
	EnableButtons();
EndProcedure

&AtServer
Procedure EnableButtons()
	Items.Productions.Enabled = Quantity;
	Items.InventoryTransfer.Enabled = Quantity;
	Items.ProductionPlusInventoryTransfer.Enabled = Quantity;
EndProcedure

&AtClient
Async Procedure SearchByBarcodeEnd(Result, AdditionalParameters) Export
	If Not Result.FoundedItems.Count()
		And Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Result.Barcodes[0]));
		Return;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form"   , ThisObject);
	NotifyParameters.Insert("Object" , ThisObject);

	For Each Row In Result.FoundedItems Do
		Item = Row.Item;
		ItemKey = Row.ItemKey;
		Unit = Row.Unit;
		
		PlanningRefreshRequestProcessingAtServer();
		
		ThisObject.CurrentItem = Items.Quantity;
#If MobileClient Then
		BeginEditingItem();
#EndIf
	EndDo;

EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	PlanningRefreshRequestProcessingAtServer();
EndProcedure

&AtClient
Procedure Productions(Command)
	If Items.PlanningPresentation.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;
	Parameters_Production = GetParametersForDocProduction(Items.PlanningPresentation.CurrentData.Key);
	CreateDocuments(Parameters_Production);
EndProcedure

&AtClient
Procedure InventoryTransfer(Command)	
	If Items.PlanningPresentation.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;
	Parameters_InventoryTransfer = GetParametersForDocInventoryTransfer(Items.PlanningPresentation.CurrentData.Key);
	CreateDocuments(Undefined, Parameters_InventoryTransfer);
EndProcedure

&AtClient
Procedure ProductionPlusInventoryTransfer(Command)
	If Items.PlanningPresentation.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;                                   
	Parameters_Production = GetParametersForDocProduction(Items.PlanningPresentation.CurrentData.Key);
	Parameters_InventoryTransfer = GetParametersForDocInventoryTransfer(Items.PlanningPresentation.CurrentData.Key);
	CreateDocuments(Parameters_Production,Parameters_InventoryTransfer);
EndProcedure

&AtClient
Function GetParametersForDocProduction(RowKey)
	ArrayOfResults = New Array();
	
	Filter = New Structure("Key", RowKey);
	ArrayOfRows = ThisObject.Planning.FindRows(Filter);
	
	TotalQuantity = 0;
	LeftToProduce = 0;
	For Each Row In ArrayOfRows Do
		TotalQuantity = TotalQuantity + Row.TotalQuantity;
		LeftToProduce = Row.LeftToProduce;
	EndDo;	            	
	AlredyProduce = TotalQuantity - LeftToProduce;
	NeedProduce = ThisObject.Quantity;
	
	For Each ItemOfArray In ArrayOfRows Do
		If NeedProduce <= 0 Then
			Continue;
		EndIf;
		TotalQuantityByRow = ItemOfArray.TotalQuantity;                                  
		AlredyProduceByRow = Min(TotalQuantityByRow, AlredyProduce);   
		TotalQuantityByRow = TotalQuantityByRow - AlredyProduceByRow;
		AlredyProduce = AlredyProduce - AlredyProduceByRow;
		
		If TotalQuantityByRow = 0 Then
			Continue;
		EndIf;
		
		CanProduce = Min(NeedProduce, TotalQuantityByRow);
		NeedProduce = NeedProduce - CanProduce;

		Result = New Structure();   
		Result.Insert("Quantity"           , CanProduce);

		Result.Insert("Company"            , ItemOfArray.Company);
		Result.Insert("PlanningPeriod"     , ItemOfArray.PlanningPeriod);
		Result.Insert("ProductionPlanning" , ItemOfArray.ProductionPlanning);
		Result.Insert("ItemKey"            , ThisObject.ItemKey);
		Result.Insert("Unit"               , ThisObject.Unit);		
		Result.Insert("BillOfMaterials"    , ItemOfArray.BillOfMaterials);
		Result.Insert("TotalQuantity"      , ItemOfArray.TotalQuantity);
		Result.Insert("OutputID"           , ItemOfArray.OutputID);
		Result.Insert("UniqueID"           , ItemOfArray.UniqueID);
		Result.Insert("ProductionType"     , ItemOfArray.ProductionType);
		Result.Insert("BusinessUnit"       , ItemOfArray.BusinessUnit);	
		Result.Insert("StoreProduction"    , ItemOfArray.StoreProduction);
		ArrayOfResults.Add(Result);
	EndDo;
	
	Return ArrayOfResults;
EndFunction

&AtClient
Function GetParametersForDocInventoryTransfer(RowKey)  
	ArrayOfResults = New Array();
	
	Filter = New Structure("Key", RowKey);
	ArrayOfRows = ThisObject.Planning.FindRows(Filter);
	
	For Each ItemOfArray In ArrayOfRows Do
		Result = New Structure("BasedOn", "ProductionPlanning");
		Result.Insert("Company"            , ItemOfArray.Company);
		Result.Insert("StoreSender"        , ItemOfArray.StoreProduction);
		Result.Insert("Branch"             , 
			CommonFunctionsServer.GetRefAttribute(ItemOfArray.ProductionPlanning, "BusinessUnit"));
	
		Result.Insert("ItemList", New Array());
		Result.ItemList.Add(New Structure("Item, ItemKey, Unit, Quantity, ProductionPlanning, InventoryOrigin", 
			ThisObject.Item, 
			ThisObject.ItemKey, 
			ThisObject.Unit, 
			ThisObject.Quantity, 
			ItemOfArray.ProductionPlanning,
			PredefinedValue("Enum.InventoryOriginTypes.OwnStocks"))); 
		
	    ArrayOfResults.Add(Result);
		Break;
	EndDo;
	
	Return ArrayOfResults;
EndFunction

&AtServer
Procedure CreateDocuments(Parameters_Production = Undefined, Parameters_InventoryTransfer = Undefined)
	ArrayOf_NewProduction = New Array();	
	ArrayOf_NewInventoryTransfer = New Array();
	
	//@skip-check begin-transaction
	BeginTransaction();
	CreationDate = CommonFunctionsServer.GetCurrentSessionDate();
	
	If Parameters_Production <> Undefined Then
		For Each ItemOfArray In Parameters_Production Do
			NewProduction = Documents.Production.CreateDocument();
			NewProduction.Date = CreationDate;
			FillingData = ManufacturingServer.GetProductionFillingData(ItemOfArray);
			NewProduction.Fill(FillingData);		
			NewProduction.Write(DocumentWriteMode.Posting);
			ArrayOf_NewProduction.Add(NewProduction.Ref);
		EndDo;
	EndIf;

	If Parameters_InventoryTransfer <> Undefined Then  
		For Each ItemOfArray In Parameters_InventoryTransfer Do
			NewInventoryTransfer = Documents.InventoryTransfer.CreateDocument();
			NewInventoryTransfer.Date = CreationDate +1;
			NewInventoryTransfer.Fill(ItemOfArray);
			SourceOfOriginClientServer.UpdateSourceOfOriginsQuantity(NewInventoryTransfer);
			NewInventoryTransfer.Write(DocumentWriteMode.Posting);
			ArrayOf_NewInventoryTransfer.Add(NewInventoryTransfer.Ref);
		EndDo;
	EndIf;    
	
	//@skip-check commit-transaction
	CommitTransaction();

	Clear();
	
	NewAttributes = New Array();
	AttributeValues = New Structure();
	
	For Each NewDoc In ArrayOf_NewProduction Do
		AttrName = "_" + StrReplace(String(New UUID()),"-","");
		NewAttr = New FormAttribute(AttrName, New TypeDescription("DocumentRef.Production"));
		NewAttributes.Add(NewAttr);
		
		AttributeValues.Insert(AttrName, NewDoc);
	EndDo;
	
	For Each NewDoc In ArrayOf_NewInventoryTransfer Do
		AttrName = "_" + StrReplace(String(New UUID()),"-","");
		NewAttr = New FormAttribute(AttrName, New TypeDescription("DocumentRef.InventoryTransfer"));
		NewAttributes.Add(NewAttr);
		
		AttributeValues.Insert(AttrName, NewDoc);
	EndDo;
	
	// change attributes
	ThisObject.ChangeAttributes(NewAttributes, ThisObject.CreatedAttributes.UnloadValues());
	
	ThisObject.CreatedAttributes.Clear();  
	For Each AttrName In NewAttributes Do
		ThisObject.CreatedAttributes.Add(AttrName.Name);
	EndDo;
	
	// fill attributes
	For Each KeyValue In AttributeValues Do 
		ThisObject[KeyValue.Key] = KeyValue.Value;
	EndDo;
	
	For Each AttrName In ThisObject.CreatedAttributes Do
		NewItem = ThisObject.Items.Add(AttrName, Type("FormField"), ThisObject.Items.GroupDocuments);
		NewItem.Type = FormFieldType.LabelField;
		NewItem.Hyperlink = True;     
		NewItem.TitleLocation = FormItemTitleLocation.None;
		NewItem.DataPath = AttrName;   
	EndDo;

	Items.ButtonPages.CurrentPage = Items.GroupDocuments;
EndProcedure
