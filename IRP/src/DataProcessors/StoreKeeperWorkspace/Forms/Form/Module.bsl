&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "NewBarcode" And IsInputAvailable() Then
		SearchByBarcode(Undefined, Parameter);
	EndIf;
EndProcedure

&AtClient
Procedure GoodsInTransitIncomingRefreshRequestProcessing(Item)
	GoodsInTransitIncomingRefreshRequestProcessingAtServer();
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

&AtServer
Procedure GoodsInTransitIncomingRefreshRequestProcessingAtServer()
		
	If ItemKey.IsEmpty() Then
		GoodsInTransitIncoming.Clear();
		Return;
	EndIf;
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	R4031B_GoodsInTransitIncomingBalance.Basis AS Basis,
		|	R4031B_GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
		|	TM1010B_RowIDMovementsBalance.RowID AS RowID,
		|	TM1010B_RowIDMovementsBalance.Step AS CurrentStep,
		|	TM1010B_RowIDMovementsBalance.RowRef AS RowRef
		|FROM
		|	AccumulationRegister.R4031B_GoodsInTransitIncoming.Balance(, ItemKey = &ItemKey
		|	AND CASE
		|		WHEN &EmptyStore
		|			THEN TRUE
		|		ELSE Store = &Store
		|	END) AS R4031B_GoodsInTransitIncomingBalance
		|		LEFT JOIN AccumulationRegister.TM1010B_RowIDMovements.Balance AS TM1010B_RowIDMovementsBalance
		|		ON (R4031B_GoodsInTransitIncomingBalance.Basis = TM1010B_RowIDMovementsBalance.Basis
		|		AND R4031B_GoodsInTransitIncomingBalance.ItemKey = TM1010B_RowIDMovementsBalance.RowRef.ItemKey
		|		AND R4031B_GoodsInTransitIncomingBalance.Store = TM1010B_RowIDMovementsBalance.RowRef.StoreReceiver
		|		AND TM1010B_RowIDMovementsBalance.Step = VALUE(Catalog.MovementRules.GR))
		|WHERE
		|	R4031B_GoodsInTransitIncomingBalance.QuantityBalance > 0";
	
	Query.SetParameter("Store", Store);
	Query.SetParameter("EmptyStore", Store.IsEmpty());
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute().Unload();
	GoodsInTransitIncoming.Load(QueryResult);
	
	Items.PagesSettings.CurrentPage = Items.GroupGoodsReceipt;
EndProcedure

&AtServer
Procedure Clear()
	GoodsInTransitIncoming.Clear();
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
	Items.ButtonGoodsReceipt.Enabled = Quantity;
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
		
		GoodsInTransitIncomingRefreshRequestProcessingAtServer();
		
		ThisObject.CurrentItem = Items.Quantity;
#If MobileClient Then
		BeginEditingItem();
#EndIf
	EndDo;

EndProcedure

&AtClient
Procedure ItemKeyOnChange(Item)
	GoodsInTransitIncomingRefreshRequestProcessingAtServer();
EndProcedure

&AtClient
Procedure CreateDocumentGoodsReceipt(Command)
	If Items.GoodsInTransitIncoming.CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_101);
		Return;
	EndIf;
	
	StructureRow = New Structure("Basis, RowID, CurrentStep, RowRef");
	FillPropertyValues(StructureRow, Items.GoodsInTransitIncoming.CurrentData);
	CreateDocuments(StructureRow, True, False);
EndProcedure

&AtServer
Procedure CreateDocuments(Val StructureRow, CreateGoodsReceipt, CreateInventoryTransfer)

	BeginTransaction();
	CreationDate = CurrentSessionDate();
	If CreateGoodsReceipt Then
		
		GoodsReceipt = Documents.GoodsReceipt.CreateDocument();
		GoodsReceipt.Branch = StructureRow.Basis.Branch;
		GoodsReceipt.Date = CreationDate + 1;
		GoodsReceipt.Author = SessionParameters.CurrentUser;
		GoodsReceipt.Company = StructureRow.Basis.Company;
		GoodsReceipt.TransactionType = Enums.GoodsReceiptTransactionTypes.InventoryTransfer;
		
		NewRow = GoodsReceipt.ItemList.Add();
		FillPropertyValues(NewRow, ThisObject);
		Actions = New Structure("CalculateQuantityInBaseUnit");
		CalculationStringsClientServer.CalculateItemsRow(Object, NewRow, Actions);
		NewRow.InventoryTransfer = StructureRow.Basis;
		NewRow.Store = StructureRow.Basis.StoreReceiver;
		NewRow.Key = New UUID;
		NewRow.ReceiptBasis = StructureRow.Basis;
		
		NewID = GoodsReceipt.RowIDInfo.Add();
		NewID.Key = NewRow.Key;
		NewID.RowID = StructureRow.RowID;
		NewID.Quantity = NewRow.Quantity;
		NewID.Basis = StructureRow.Basis;
		NewID.CurrentStep = StructureRow.CurrentStep;
		NewID.RowRef = StructureRow.RowRef;
		NewID.BasisKey = StructureRow.RowID;

		GoodsReceipt.Write(DocumentWriteMode.Posting);
		
	EndIf;
	CommitTransaction();

	Clear();

	If CreateGoodsReceipt Then
		DocGoodsReceipt = GoodsReceipt.Ref;
	EndIf;
	Items.PagesSettings.CurrentPage = Items.PageSettings;
EndProcedure

