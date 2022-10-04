&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure SearchByBarcode(Command, Barcode = "")
	AddInfo = New Structure("ClientModule", ThisObject);
	DocumentsClient.SearchByBarcode(Barcode, ThisObject, ThisObject, ThisObject, , AddInfo);
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
		
	If ItemKey.IsEmpty() Then
		Planning.Clear();
		Return;
	EndIf;
	
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	MF_ProductionPlanningTurnovers.Company AS Company,
		|	MF_ProductionPlanningTurnovers.BusinessUnit AS BusinessUnit,
		|	MF_ProductionPlanningTurnovers.PlanningPeriod AS PlanningPeriod,
		|	SUM(CASE
		|		WHEN MF_ProductionPlanningTurnovers.PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.Produced)
		|			THEN -MF_ProductionPlanningTurnovers.QuantityTurnover
		|		ELSE MF_ProductionPlanningTurnovers.QuantityTurnover
		|	END) AS QuantityTurnover
		|INTO BalanceTable
		|FROM
		|	AccumulationRegister.MF_ProductionPlanning.Turnovers(,,, ItemKey = &ItemKey) AS MF_ProductionPlanningTurnovers
		|GROUP BY
		|	MF_ProductionPlanningTurnovers.Company,
		|	MF_ProductionPlanningTurnovers.PlanningPeriod,
		|	MF_ProductionPlanningTurnovers.BusinessUnit
		|HAVING
		|	(SUM(CASE
		|		WHEN MF_ProductionPlanningTurnovers.PlanningType = VALUE(Enum.MF_ProductionPlanningTypes.Produced)
		|			THEN -MF_ProductionPlanningTurnovers.QuantityTurnover
		|		ELSE MF_ProductionPlanningTurnovers.QuantityTurnover
		|	END) > 0
		|	OR MF_ProductionPlanningTurnovers.PlanningPeriod.StartDate < &CurrentDate
		|	AND MF_ProductionPlanningTurnovers.PlanningPeriod.EndDate > &CurrentDate)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	BalanceTable.PlanningPeriod AS PlanningPeriod,
		|	BalanceTable.QuantityTurnover AS LeftToProduce,
		|	MF_ProductionPlanning.Ref AS ProductionPlanning
		|FROM
		|	BalanceTable AS BalanceTable
		|		LEFT JOIN Document.MF_ProductionPlanning AS MF_ProductionPlanning
		|		ON (BalanceTable.Company = MF_ProductionPlanning.Company)
		|		AND (BalanceTable.BusinessUnit = MF_ProductionPlanning.BusinessUnit)
		|		AND (BalanceTable.PlanningPeriod = MF_ProductionPlanning.PlanningPeriod)
		|		AND (MF_ProductionPlanning.Posted)";
	
	Query.SetParameter("CurrentDate", CurrentSessionDate());
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute().Unload();
	Planning.Load(QueryResult);
EndProcedure

&AtServer
Procedure Clear()
	Planning.Clear();
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

	If Not AdditionalParameters.FoundedItems.Count()
		And AdditionalParameters.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, AdditionalParameters.Barcodes[0]));
		Return;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", ThisObject);

	For Each Row In AdditionalParameters.FoundedItems Do
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
Procedure InventoryTransfer(Command)	
	If Items.Planning.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;
	CreateDocuments(Items.Planning.CurrentData.ProductionPlanning, False, True);	
EndProcedure


&AtClient
Procedure ProductionPlusInventoryTransfer(Command)
	If Items.Planning.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;
	CreateDocuments(Items.Planning.CurrentData.ProductionPlanning, True, True);
EndProcedure

&AtClient
Procedure Productions(Command)
	If Items.Planning.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().MF_Error_010);
		Return;
	EndIf;
	CreateDocuments(Items.Planning.CurrentData.ProductionPlanning, True, False);
EndProcedure

&AtServer
Procedure CreateDocuments(Val ProductionPlanning, CreateProduction, CreateInventoryTransfer)

	BeginTransaction();
	CreationDate = CurrentSessionDate();
	If CreateProduction Then
		NewProduction = Documents.MF_Production.CreateDocument();

		FillPropertyValues(NewProduction, ProductionPlanning,
			"Company, BusinessUnit, StoreMaterial, StoreProduction, PlanningPeriod");

		FindBill = ProductionPlanning.Productions.FindRows(New Structure("ItemKey", ItemKey));
		BillOfMaterials = FindBill[0].BillOfMaterials;
		NewProduction.Date = CreationDate;
		NewProduction.Item = Item;
		NewProduction.ItemKey = ItemKey;
		NewProduction.Unit = Unit;
		NewProduction.Quantity = Quantity;
		NewProduction.BillOfMaterials = BillOfMaterials;
		NewProduction.ProductionPlanning = ProductionPlanning;
		NewProduction.ProductionType = Enums.MF_ProductionTypes.Product;
		NewProduction.Finished = True;
		NewProduction.Author = SessionParameters.CurrentUser;
		MF_DocProductionServer.BillOfMaterialsOnChangeAtServer(NewProduction);
		NewProduction.Write(DocumentWriteMode.Posting);
	EndIf;

	If CreateInventoryTransfer Then
		
		Doc = BuilderAPI.Initialize("InventoryTransfer", , , "ItemList");
		
		BuilderAPI.SetProperty(Doc, "Branch", ProductionPlanning.BusinessUnit);
		BuilderAPI.SetProperty(Doc, "Date", CreationDate + 1);
		BuilderAPI.SetProperty(Doc, "Author", SessionParameters.CurrentUser);
		BuilderAPI.SetProperty(Doc, "Company", ProductionPlanning.Company);
//		BuilderAPI.SetProperty(Doc, "StoreSender", ProductionPlanning.BusinessUnit.MF_StoreProduction);
		Filter = New Structure();
		Filter.Insert("MetadataObject", Doc.Object.Ref.Metadata());
		Filter.Insert("AttributeName", "StoreReceiver");
		StoreReceiver = UserSettingsServer.GetUserSettings(Undefined, Filter);
		If StoreReceiver.Count() Then
			BuilderAPI.SetProperty(Doc, "StoreReceiver", StoreReceiver[0].Value);
		EndIf;
		
		BuilderAPI.SetProperty(Doc, "UseGoodsReceipt", Doc.Object.StoreReceiver.UseGoodsReceipt);
		BuilderAPI.SetProperty(Doc, "UseShipmentConfirmation", Doc.Object.StoreSender.UseShipmentConfirmation);
		
		NewRow = BuilderAPI.AddRow(Doc);
		BuilderAPI.SetRowProperty(Doc, NewRow, "Item", Item);
		BuilderAPI.SetRowProperty(Doc, NewRow, "ItemKey", ItemKey);
		BuilderAPI.SetRowProperty(Doc, NewRow, "Unit", Unit);
		BuilderAPI.SetRowProperty(Doc, NewRow, "Quantity", Quantity);
		
		NewRow.MF_ProductionPlanning = ProductionPlanning;
		BuilderAPI.Write(Doc, DocumentWriteMode.Posting);
	EndIf;
	CommitTransaction();

	Clear();
	
	If CreateProduction Then
		DocProduction = NewProduction.Ref;
	EndIf;
	
	If CreateInventoryTransfer Then
		DocInventoryTransfer = Doc.Object.Ref;
	EndIf;
	Items.ButtonPages.CurrentPage = Items.GroupDocuments;
EndProcedure



