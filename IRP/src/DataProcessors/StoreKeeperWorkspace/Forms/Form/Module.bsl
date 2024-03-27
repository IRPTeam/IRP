
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	EnableButtons();
EndProcedure

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
	DocumentsClient.SearchByBarcode(Barcode, Object, ThisObject, ThisObject);
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
	
	Query = New Query();
	Query.Text = 
	"SELECT DISTINCT
	|	Incoming.Basis.Company AS Company,
	|	Incoming.Basis.Branch AS Branch,
	|	ISNULL(Incoming.Basis.Partner, VALUE(Catalog.Partners.EmptyRef)) AS Partner,
	|	ISNULL(Incoming.Basis.LegalName, VALUE(Catalog.Companies.EmptyRef)) AS LegalName
	|FROM
	|	AccumulationRegister.R4031B_GoodsInTransitIncoming.Balance(, ItemKey = &ItemKey
	|	AND CASE
	|		WHEN &Filter_Store
	|			THEN Store = &Store
	|		ELSE TRUE
	|	END) AS Incoming
	|WHERE
	|	Incoming.QuantityBalance > 0";
	
	Query.SetParameter("ItemKey", ThisObject.ItemKey);
	Query.SetParameter("Filter_Store", ValueIsFilled(ThisObject.Store));
	Query.SetParameter("Store", ThisObject.Store);
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	GR_EmptyRef = Documents.GoodsReceipt.EmptyRef();
	
	ThisObject.GoodsInTransitIncoming.Clear();
	BasisTableTotal = ThisObject.GoodsInTransitIncoming.Unload().CopyColumns();
	
	While QuerySelection.Next() Do
		BasisDocData = New Structure();
		BasisDocData.Insert("Company"   , QuerySelection.Company);
		BasisDocData.Insert("Branch"    , QuerySelection.Branch);
		BasisDocData.Insert("Partner"   , QuerySelection.Partner);
		BasisDocData.Insert("LegalName" , QuerySelection.LegalName);
		BasisDocData.Insert("Ref"       , GR_EmptyRef);
		BasisDocData.Insert("TransactionType" , Enums.GoodsReceiptTransactionTypes.InventoryTransfer);

		Filter = RowIDInfoClientServer.GetLinkedDocumentsFilter_GR(BasisDocData);
		
		Filter.Insert("ItemKey", ThisObject.ItemKey);
		If ValueIsFilled(ThisObject.Store) Then
			Filter.Insert("Store", ThisObject.Store);
		EndIf;
		
		BasisesTable = RowIDInfoPrivileged.GetBasises(GR_EmptyRef, Filter);
		For Each Row In BasisesTable Do
			NewRow = BasisTableTotal.Add();
			FillPropertyValues(NewRow, Row);
			BasisesInfo = RowIDInfoServer.GetBasisesInfo(Row.Basis, Row.BasisKey, Row.RowID);
			NewRow.Unit = BasisesInfo.Unit;
			NewRow.Quantity = Catalogs.Units.Convert(NewRow.BasisUnit, NewRow.Unit, NewRow.QuantityInBaseUnit);
		EndDo;		
	EndDo;	
	
	ArrayOfColumns = New Array();
	For Each Column In BasisTableTotal.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	BasisTableTotal.GroupBy(StrConcat(ArrayOfColumns, ","));
	ThisObject.GoodsInTransitIncoming.Load(BasisTableTotal);
	
	Items.PagesSettings.CurrentPage = Items.GroupGoodsReceipt;
	
	EnableButtons();
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

	If Not Result.FoundedItems.Count()
		And Result.Barcodes.Count() Then
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().S_019, Result.Barcodes[0]));
		Return;
	EndIf;

	NotifyParameters = New Structure();
	NotifyParameters.Insert("Form", ThisObject);
	NotifyParameters.Insert("Object", ThisObject);

	For Each Row In Result.FoundedItems Do
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
	CurrentData = Items.GoodsInTransitIncoming.CurrentData;
	If CurrentData = Undefined Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_101);
		Return;
	EndIf;
	
	ColumnNames = "
	|Basis,
	|BasisKey,
	|BasisUnit,
	|CurrentStep,	
	|Item,
	|ItemKey,
	|Key,
	|ParentBasis,
	|Quantity,
	|QuantityInBaseUnit,
	|RowID,
	|RowRef,
	|Store,
	|Unit";
	StructureRow = New Structure(ColumnNames);
	FillPropertyValues(StructureRow, CurrentData);
	
	CreateDocuments(StructureRow, True, False);
EndProcedure

&AtServer
Procedure CreateDocuments(Val StructureRow, CreateGoodsReceipt, CreateInventoryTransfer)

	BeginTransaction();
	Try
		CreationDate = CommonFunctionsServer.GetCurrentSessionDate();
		If CreateGoodsReceipt Then
			
			If ValueIsFilled(ThisObject.Unit) Then
				StructureRow.Unit = ThisObject.Unit;
				StructureRow.QuantityInBaseUnit =
				Catalogs.Units.Convert(StructureRow.Unit, StructureRow.BasisUnit, ThisObject.Quantity);
			Else
				StructureRow.QuantityInBaseUnit = ThisObject.Quantity;
			EndIf; 
			
			ResultTable = ThisObject.GoodsInTransitIncoming.Unload().CopyColumns();
			FillPropertyValues(ResultTable.Add(), StructureRow);
			
			GoodsReceipt = Documents.GoodsReceipt.CreateDocument();
			GoodsReceipt.Date = CreationDate + 1;
			
			Data = RowIDInfoPrivileged.ExtractData(ResultTable, GoodsReceipt.Ref);
			FillingValues = RowIDInfoPrivileged.ConvertDataToFillingValues(GoodsReceipt.Ref.Metadata(), Data);
			If Not FillingValues.Count() Then
				Raise "Converting Data to Filling values failed";
			EndIf;
			GoodsReceipt.Fill(FillingValues[0]);
			GoodsReceipt.Write(DocumentWriteMode.Posting);		
		EndIf;
		CommitTransaction();
	Except
		RollbackTransaction();
		CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
	EndTry;
	Clear();

	If CreateGoodsReceipt Then
		ThisObject.DocGoodsReceipt = GoodsReceipt.Ref;
	EndIf;
	Items.PagesSettings.CurrentPage = Items.PageSettings;
EndProcedure

