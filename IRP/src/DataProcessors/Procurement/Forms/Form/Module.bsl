
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	RestoreSettings();
	UpdateCreatedDocuments();
	SetVisible();
	ShowPrecision();
EndProcedure

&AtServer
Procedure RestoreSettings()
	Settings = FormDataSettingsStorage.Load("DataProcessor.Procurement", "FormSettings");
	If TypeOf(Settings) = Type("Structure") Then
		RestoreSettingIfPresent(Settings, "Company", Undefined);
		RestoreSettingIfPresent(Settings, "Store", Undefined);
		RestoreSettingIfPresent(Settings, "VisibleResultTables", "All");
		RestoreSettingIfPresent(Settings, "VisibleAnalyisRows", "All");
		RestoreSettingIfPresent(Settings, "VisibleCreatedDocumentTables", "All");
		RestoreSettingIfPresent(Settings, "VisibleSelectionTables", "All");
		RestoreSettingIfPresent(Settings, "ShowPrecision", True);
		RestoreSettingIfPresent(Settings, "Period", Undefined);
		RestoreSettingIfPresent(Settings, "Periodicity", Undefined);
	EndIf;
EndProcedure

&AtServer
Procedure RestoreSettingIfPresent(Settings, SettingName, DefaultValue)
	If Settings.Property(SettingName) Then
		ThisObject[SettingName] = Settings[SettingName];
	Else
		ThisObject[SettingName] = DefaultValue;
	EndIf;
EndProcedure	

&AtServer
Procedure SaveSettings()
	Settings = New Structure();
	Settings.Insert("Company", ThisObject.Company);
	Settings.Insert("Store", ThisObject.Store);
	Settings.Insert("VisibleResultTables", ThisObject.VisibleResultTables);
	Settings.Insert("VisibleAnalyisRows", ThisObject.VisibleAnalyisRows);
	Settings.Insert("VisibleCreatedDocumentTables", ThisObject.VisibleCreatedDocumentTables);
	Settings.Insert("VisibleSelectionTables", ThisObject.VisibleSelectionTables);
	Settings.Insert("ShowPrecision", ThisObject.ShowPrecision);
	Settings.Insert("Period", ThisObject.Period);
	Settings.Insert("Periodicity", ThisObject.Periodicity);
	
	FormDataSettingsStorage.Save("DataProcessor.Procurement", "FormSettings", Settings);
EndProcedure

&AtClient
Procedure Refresh(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	RefreshAtServer();
	SetVisible();
	ShowPrecision();
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	SaveSettings();
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	SaveSettings();
EndProcedure

&AtClient
Procedure PeriodicityOnChange(Item)
	SaveSettings();
EndProcedure

&AtClient
Procedure StoreOnChange(Item)
	SaveSettings();
EndProcedure

&AtClient
Function CheckFillingSilent()
	Return
	ValueIsFilled(ThisObject.Company) And
	ValueIsFilled(ThisObject.Store) And
	ValueIsFilled(ThisObject.Period) And
	ValueIsFilled(ThisObject.Periodicity);
EndFunction

&AtServer
Procedure RefreshAtServer()
	
	DeleteColumns_Analysis();
	DeleteColumns_Details();
	
	ThisObject.TableOfColumns.Clear();
	ThisObject.Analysis.Clear();
	ThisObject.Details.GetItems().Clear();
	
	SecondsInOneDay = 86400;
	SecondInPeriod = SecondsInOneDay * Number(ThisObject.Periodicity);
	tmpDate = BegOfDay(ThisObject.Period.StartDate);
	While BegOfDay(tmpDate) <= BegOfDay(ThisObject.Period.EndDate) Do
		NewRow = ThisObject.TableOfColumns.Add();
		NewRow.StartDate = tmpDate;
		tmpDate = BegOfDay(tmpDate) + SecondInPeriod;
		NewRow.EndDate = 
		?(BegOfDay(tmpDate) > BegOfDay(ThisObject.Period.EndDate), 
		EndOfDay(ThisObject.Period.EndDate), tmpDate - 1);
		
		NewRow.Name = "_" + StrReplace(String(New UUID()), "-" , "_");
		If BegOfDay(NewRow.StartDate) = BegOfDay(NewRow.EndDate) Then
			NewRow.Title = Format(NewRow.StartDate, "DF=d.M.yy;") 
		Else
			NewRow.Title = Format(NewRow.StartDate, "DF=d.M.yy;") 
			+ " - "
			+ Format(NewRow.EndDate, "DF=d.M.yy;");
		EndIf;
	EndDo;
	
	CreateColumns_Analysis();
	CreateColumns_Details();
		
	TableOfSupplyRequests = 
	GetTableOfSupplyRequests(ThisObject.Store, ThisObject.Period.StartDate, ThisObject.Period.EndDate);
	
	TableOfWithoutSupplyRequest = TableOfOrdersWithoutSupplyRequest(ThisObject.Store, Undefined);
	TableOfWithoutSupplyRequest.GroupBy("ItemKey, DeliveryDate", "Quantity");
		
	For Each Row In TableOfSupplyRequests Do
		NewRowAnalysis = ThisObject.Analysis.Add();
		NewRowAnalysis.Picture = 3;
		NewRowAnalysis.Item = Row.Item;
		NewRowAnalysis.ItemKey = Row.ItemKey;
		NewRowAnalysis.Unit = Row.Unit;
		NewRowAnalysis.OpenBalance = Row.OpenBalance;
		NewRowAnalysis.TotalProcurement = Row.QuantityProcurement;
		NewRowAnalysis.Ordered  = Row.QuantityOrdered;
		NewRowAnalysis.Expired  = Row.QuantityExpired;
					
		For Each RowColumnInfo In TableOfColumns Do
			NewRowAnalysis[RowColumnInfo.Name] = 
			GetProcurementByItemKey(ThisObject.Store, Row.ItemKey, RowColumnInfo.StartDate, RowColumnInfo.EndDate);			
		EndDo;
		
		Filter = New Structure();
		Filter.Insert("ItemKey", Row.ItemKey);
		OrderedWithoutSupplyRequest = 0;
		For Each RowOfWithoutSupplyRequest In TableOfWithoutSupplyRequest.FindRows(Filter) Do
			For Each RowColumnInfo In TableOfColumns Do
				If RowOfWithoutSupplyRequest.DeliveryDate >= RowColumnInfo.StartDate 
					And RowOfWithoutSupplyRequest.DeliveryDate <= RowColumnInfo.EndDate Then
					NewRowAnalysis[RowColumnInfo.Name] = NewRowAnalysis[RowColumnInfo.Name] 
					+ RowOfWithoutSupplyRequest.Quantity;
					OrderedWithoutSupplyRequest = OrderedWithoutSupplyRequest + RowOfWithoutSupplyRequest.Quantity;
				EndIf;
			EndDo;
		EndDo;
		NewRowAnalysis.Ordered = NewRowAnalysis.Ordered + OrderedWithoutSupplyRequest;
		
		NewRowAnalysis.Shortage = 
		NewRowAnalysis.TotalProcurement - NewRowAnalysis.Ordered - NewRowAnalysis.OpenBalance;
		
		NewRowAnalysis.Visible  = NewRowAnalysis.Shortage > 0;
	EndDo;	
EndProcedure

&AtClient
Procedure DetailsSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.Details.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "DetailsDocument", CurrentData.Document, StandardProcessing);
EndProcedure

&AtClient
Procedure AnalysisSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.Analysis.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "AnalysisItem", CurrentData.Item, StandardProcessing);
	OpenObjectForm(Field, "AnalysisItemKey", CurrentData.ItemKey, StandardProcessing);
EndProcedure

&AtClient
Procedure OpenObjectForm(Field, FieldName, Ref, StandardProcessing)
	If Upper(Field.Name) = Upper(FieldName) Then
		StandardProcessing = False;
		If Not ValueIsFilled(Ref) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", Ref);
		OpenForm(GetMetadataFullName(Ref) + ".ObjectForm", OpenParameters);
	EndIf;	
EndProcedure

&AtClient
Procedure ResultsItemListSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.ResultsItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "ResultsItemListItem", CurrentData.Item, StandardProcessing);
	OpenObjectForm(Field, "ResultsItemListItemKey", CurrentData.ItemKey, StandardProcessing);	
EndProcedure

&AtClient
Procedure ResultsTableOfBalanceSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.ResultsTableOfBalance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "ResultsTableOfBalanceStore", CurrentData.Store, StandardProcessing);
EndProcedure

&AtClient
Procedure ResultsTableOfPurchaseSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.ResultsTableOfPurchase.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "ResultsTableOfPurchasePartner", CurrentData.Partner, StandardProcessing);
	OpenObjectForm(Field, "ResultsTableOfPurchaseAgreement", CurrentData.Agreement, StandardProcessing);
	OpenObjectForm(Field, "ResultsTableOfPurchasePriceType", CurrentData.PriceType, StandardProcessing);
EndProcedure

&AtClient
Procedure ResultsTableOfInternalSupplyRequestSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.ResultsTableOfInternalSupplyRequest.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "ResultsTableOfInternalSupplyRequestInternalSupplyRequest", CurrentData.InternalSupplyRequest, 
		StandardProcessing);
EndProcedure

&AtClient
Procedure CreatedInventoryTransferOrdersSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.CreatedInventoryTransferOrders.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "CreatedInventoryTransferOrdersDocument", CurrentData.Document, StandardProcessing);
EndProcedure

&AtClient
Procedure RefreshCreatedDocuments(Command)
	UpdateCreatedDocuments();	
EndProcedure

&AtClient
Procedure CreatedPurchaseOrdersSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.CreatedPurchaseOrders.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OpenObjectForm(Field, "CreatedPurchaseOrdersDocument", CurrentData.Document, StandardProcessing);
EndProcedure

&AtServerNoContext
Function GetMetadataFullName(Ref)
	Return Ref.Metadata().FullName();
EndFunction

&AtClient
Procedure AnalyzeOrders(Command)
	CurrentData = Items.Analysis.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	AdditionalParameters = CollectParametersForCreateOrdersForm(CurrentData.Item, CurrentData.ItemKey, CurrentData.Unit);
	
	OpenParameters = New Structure();
	OpenParameters.Insert("ArrayOfSupplyRequest", GetArrayOfSupplyRequestFromDetails());
	OpenParameters.Insert("ShowPrecision", ThisObject.ShowPrecision);
		
	Notify = New NotifyDescription("SelectInternalSupplyRequestEnd", ThisObject, AdditionalParameters);
	OpenForm("DataProcessor.Procurement.Form.FormSelectInternalSupplyRequest",
	OpenParameters, ThisObject, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure ChangeResults(Command)
	CurrentData = Items.ResultsItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	OpenParameters = CollectParametersForCreateOrdersForm(CurrentData.Item, CurrentData.ItemKey, CurrentData.Unit);
	ArrayOfSupplyRequest = GetArrayOfSupplyRequestFromResultsTable(CurrentData.ItemKey);
	OpenCreateOrdersForm(OpenParameters, ArrayOfSupplyRequest);	
EndProcedure

&AtClient
Procedure DeleteResults(Command)
	CurrentData = Items.ResultsItemList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ClearResultsTable(CurrentData.ItemKey);
	SetVisibleInResultTables();
EndProcedure

&AtClient
Function CollectParametersForCreateOrdersForm(Item, ItemKey, Unit)
	FormParameters = New Structure();
	FormParameters.Insert("Item", Item);
	FormParameters.Insert("ItemKey", ItemKey);
	FormParameters.Insert("Unit", Unit);
	FormParameters.Insert("Store", ThisObject.Store);
	FormParameters.Insert("Company", ThisObject.Company);
	FormParameters.Insert("VisibleSelectionTables", ThisObject.VisibleSelectionTables);	
	FormParameters.Insert("ShowPrecision", ThisObject.ShowPrecision);	
		
	FormParameters.Insert("TableOfBalance", New Array());
	FormParameters.Insert("TableOfPurchase", New Array());
	FormParameters.Insert("TableOfInternalSupplyRequest", New Array());
	
	Filter = New Structure();
	Filter.Insert("ItemKey", ItemKey);
	For Each Row In ThisObject.ResultsTableOfBalance.FindRows(Filter) Do
		NewRow = New Structure();
		NewRow.Insert("Store", Row.Store);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("QuantityIncomming", Row.QuantityIncomming);
		NewRow.Insert("PurchaseOrder", Row.PurchaseOrder);
		FormParameters.TableOfBalance.Add(NewRow);
	EndDo;
	
	For Each Row In ThisObject.ResultsTableOfPurchase.FindRows(Filter) Do
		NewRow = New Structure();
		NewRow.Insert("Partner", Row.Partner);
		NewRow.Insert("PriceType", Row.PriceType);
		NewRow.Insert("Price", Row.Price);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("DateOfRelevance", Row.DateOfRelevance);
		NewRow.Insert("Agreement", Row.Agreement);
		NewRow.Insert("DeliveryDate", Row.DeliveryDate);
		NewRow.Insert("Unit", Row.Unit);
		NewRow.Insert("Store", Row.Store);
		FormParameters.TableOfPurchase.Add(NewRow);
	EndDo;
	
	For Each Row In ThisObject.ResultsTableOfInternalSupplyRequest.FindRows(Filter) Do
		NewRow = New Structure();
		NewRow.Insert("InternalSupplyRequest", Row.InternalSupplyRequest);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("Transfer", Row.Transfer);
		NewRow.Insert("Purchase", Row.Purchase);
		NewRow.Insert("ProcurementDate", Row.ProcurementDate);
		NewRow.Insert("RowKey", Row.RowKey);
		FormParameters.TableOfInternalSupplyRequest.Add(NewRow);
	EndDo;	
	Return FormParameters;
EndFunction

&AtClient
Procedure OpenCreateOrdersForm(OpenParameters, ArrayOfSupplyRequest)
	OpenParameters.Insert("ArrayOfSupplyRequest", ArrayOfSupplyRequest);
	
	Notify = New NotifyDescription("CreateOrdersEnd", ThisObject);
	OpenForm("DataProcessor.Procurement.Form.FormCreateOrders",
	OpenParameters, ThisObject, , , , Notify, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure	

&AtClient 
Procedure SelectInternalSupplyRequestEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	OpenCreateOrdersForm(AdditionalParameters, Result);	
EndProcedure

&AtClient
Procedure ClearResultsTable(ItemKey)
	Filter = New Structure();
	Filter.Insert("ItemKey", ItemKey);
	
	ArrayOfResultsItemList = ThisObject.ResultsItemList.FindRows(Filter);
	For Each ItemOfArray In ArrayOfResultsItemList Do
		ThisObject.ResultsItemList.Delete(ItemOfArray);
	EndDo;	
	
	ArrayOfResultsTableOfBalance = ThisObject.ResultsTableOfBalance.FindRows(Filter);
	For Each ItemOfArray In ArrayOfResultsTableOfBalance Do
		ThisObject.ResultsTableOfBalance.Delete(ItemOfArray);
	EndDo;	
	
	ArrayOfResultsTableOfPurchase = ThisObject.ResultsTableOfPurchase.FindRows(Filter);
	For Each ItemOfArray In ArrayOfResultsTableOfPurchase Do
		ThisObject.ResultsTableOfPurchase.Delete(ItemOfArray);
	EndDo;	
	
	ArrayOfResultsTableOfInternalSupplyRequest = ThisObject.ResultsTableOfInternalSupplyRequest.FindRows(Filter);
	For Each ItemOfArray In ArrayOfResultsTableOfInternalSupplyRequest Do
		ThisObject.ResultsTableOfInternalSupplyRequest.Delete(ItemOfArray);
	EndDo;
EndProcedure

&AtClient 
Procedure CreateOrdersEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;		
	
	SaveSettings();
	ThisObject.VisibleSelectionTables = Result.VisibleSelectionTables;
	
	If Not Result.IsOkPressed Then
		Return;
	EndIf;
	
	ClearResultsTable(Result.ItemKey);
	
	NewRow = ThisObject.ResultsItemList.Add();
	NewRow.Picture = 3;
	NewRow.Item = Result.Item;
	NewRow.ItemKey = Result.ItemKey;
	NewRow.Unit = Result.Unit;
	
	For Each Row In Result.TableOfBalance Do
		FillPropertyValues(ThisObject.ResultsTableOfBalance.Add(), Row);
	EndDo;
	
	For Each Row In Result.TableOfPurchase Do
		FillPropertyValues(ThisObject.ResultsTableOfPurchase.Add(), Row);
	EndDo;
		
	For Each Row In Result.TableOfInternalSupplyRequest Do
		FillPropertyValues(ThisObject.ResultsTableOfInternalSupplyRequest.Add(), Row);
	EndDo;
	SetVisibleInResultTables();	
EndProcedure

&AtClient
Procedure SetVisibleInResultTables()
	CurrentData = Items.ResultsItemList.CurrentData;
	For Each Row In ThisObject.ResultsTableOfBalance Do
		Row.Visible = CurrentData <> Undefined And CurrentData.ItemKey = Row.ItemKey;
	EndDo;
	Items.ResultsTableOfBalance.RowFilter = New FixedStructure("Visible", True);
	
	For Each Row In ThisObject.ResultsTableOfPurchase Do
		Row.Visible = CurrentData <> Undefined And CurrentData.ItemKey = Row.ItemKey;
	EndDo;
	Items.ResultsTableOfPurchase.RowFilter = New FixedStructure("Visible", True);
	
	For Each Row In ThisObject.ResultsTableOfInternalSupplyRequest Do
		Row.Visible = CurrentData <> Undefined And CurrentData.ItemKey = Row.ItemKey;
	EndDo;
	Items.ResultsTableOfInternalSupplyRequest.RowFilter = New FixedStructure("Visible", True);
EndProcedure

&AtClient
Procedure CreateDocuments(Command)
	CreatedDocuments = CreateDocumentsAtServer();
	For Each Doc In CreatedDocuments.PurchaseOrders Do
		DocForm = GetForm("Document.PurchaseOrder.ObjectForm", New Structure("Key", Doc));
		DocPurchaseOrderClient.CompanyOnChange(DocForm.Object, DocForm, DocForm.Items.Company);
		DocForm.Write();	
	EndDo;
	
	For Each Doc In CreatedDocuments.TransferOrders Do
		DocForm = GetForm("Document.InventoryTransferOrder.ObjectForm", New Structure("Key", Doc));
		DocInventoryTransferOrderClient.CompanyOnChange(DocForm.Object, DocForm, DocForm.Items.Company);
		DocForm.Write();	
	EndDo;
	
	For Each Doc In CreatedDocuments.PurchaseOrders Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_020, Doc));
	EndDo;
	
	For Each Doc In CreatedDocuments.TransferOrders Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_020, Doc));
	EndDo;
	
	If CreatedDocuments.PurchaseOrders.Count() Or CreatedDocuments.TransferOrders.Count() Then
		Items.GroupMainPages.CurrentPage = Items.GroupDocuments;
	EndIf;
EndProcedure

&AtServer
Function CreateDocumentsAtServer()
	CreatedDocuments = New Structure();
	CreatedDocuments.Insert("TransferOrders", New Array());
	CreatedDocuments.Insert("PurchaseOrders", New Array());
	
	TransferDataTable = New ValueTable();
	TransferDataTable.Columns.Add("StoreSender");
	TransferDataTable.Columns.Add("InternalSupplyRequest");
	TransferDataTable.Columns.Add("PurchaseOrder");
	TransferDataTable.Columns.Add("RowKey", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	TransferDataTable.Columns.Add("ItemKey");
	TransferDataTable.Columns.Add("Quantity");

	For Each Row In ThisObject.ResultsItemList Do
		DataTable = CollectDataFor_InventoryTransferOrder(Row.ItemKey);
		For Each RowData In DataTable Do
			FillPropertyValues(TransferDataTable.Add(), RowData);
		EndDo;
	EndDo;
	
	If TransferDataTable.Count() Then
		CreatedDocuments.TransferOrders = Create_InventoryTransferOrder(TransferDataTable);
	EndIf;
	
	PurchaseDataTable = New ValueTable();
	PurchaseDataTable.Columns.Add("Partner");
	PurchaseDataTable.Columns.Add("Agreement");
	PurchaseDataTable.Columns.Add("PriceType");
	PurchaseDataTable.Columns.Add("Price");
	PurchaseDataTable.Columns.Add("DeliveryDate");
	PurchaseDataTable.Columns.Add("InternalSupplyRequest");
	PurchaseDataTable.Columns.Add("RowKey", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	PurchaseDataTable.Columns.Add("ItemKey");
	PurchaseDataTable.Columns.Add("Store");
	PurchaseDataTable.Columns.Add("Unit");
	PurchaseDataTable.Columns.Add("Quantity");
	
	For Each Row In ThisObject.ResultsItemList Do	
		DataTable = CollectDataFor_PurchaseOrder(Row.ItemKey);
		For Each RowData In DataTable Do
			FillPropertyValues(PurchaseDataTable.Add(), RowData);
		EndDo;
	EndDo;
	
	If PurchaseDataTable.Count() Then
		CreatedDocuments.PurchaseOrders = Create_PurchaseOrder(PurchaseDataTable);
	EndIf;
	
	For Each Doc In CreatedDocuments.PurchaseOrders Do
		RecordManager = InformationRegisters.CreatedProcurementOrders.CreateRecordManager();
		RecordManager.Order = Doc;
		RecordManager.Write();
	EndDo;
	
	For Each Doc In CreatedDocuments.TransferOrders Do
		RecordManager = InformationRegisters.CreatedProcurementOrders.CreateRecordManager();
		RecordManager.Order = Doc;
		RecordManager.Write();
	EndDo;
		
	ThisObject.ResultsItemList.Clear();
	ThisObject.ResultsTableOfBalance.Clear();
	ThisObject.ResultsTableOfPurchase.Clear();
	ThisObject.ResultsTableOfInternalSupplyRequest.Clear();
	
	UpdateCreatedDocuments();
	
	Return CreatedDocuments;
EndFunction
	
&AtServer
Procedure UpdateCreatedDocuments()	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	CreatedProcurementOrders.Order AS Document,
	|	CASE
	|		WHEN CAST(CreatedProcurementOrders.Order AS Document.InventoryTransferOrder).DeletionMark
	|			THEN 1
	|		WHEN CAST(CreatedProcurementOrders.Order AS Document.InventoryTransferOrder).Posted
	|			THEN 0
	|		ELSE 2
	|	END AS Picture,
	|	CAST(CreatedProcurementOrders.Order AS Document.InventoryTransferOrder).Status AS Status,
	|	CAST(CreatedProcurementOrders.Order AS Document.InventoryTransferOrder).StoreSender AS StoreSender
	|FROM
	|	InformationRegister.CreatedProcurementOrders AS CreatedProcurementOrders
	|WHERE
	|	CreatedProcurementOrders.Order REFS Document.InventoryTransferOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	CreatedProcurementOrders.Order AS Document,
	|	CASE
	|		WHEN CAST(CreatedProcurementOrders.Order AS Document.PurchaseOrder).DeletionMark
	|			THEN 1
	|		WHEN CAST(CreatedProcurementOrders.Order AS Document.PurchaseOrder).Posted
	|			THEN 0
	|		ELSE 2
	|	END AS Picture,
	|	CAST(CreatedProcurementOrders.Order AS Document.PurchaseOrder).Status AS Status,
	|	CAST(CreatedProcurementOrders.Order AS Document.PurchaseOrder).Partner AS Partner
	|FROM
	|	InformationRegister.CreatedProcurementOrders AS CreatedProcurementOrders
	|WHERE
	|	CreatedProcurementOrders.Order REFS Document.PurchaseOrder";
	QueryResults = Query.ExecuteBatch();
	ThisObject.CreatedInventoryTransferOrders.Load(QueryResults[0].Unload());
	ThisObject.CreatedPurchaseOrders.Load(QueryResults[1].Unload());
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If Upper(EventName) = Upper("WriteProcurementOrder") Then
		UpdateCreatedDocuments();
		If CheckFillingSilent() Then
			RefreshAtServer();
		EndIf;
	EndIf;
EndProcedure

&AtServer
Function CollectDataFor_InventoryTransferOrder(ItemKey)
	DataTable = New ValueTable();
	DataTable.Columns.Add("StoreSender");
	DataTable.Columns.Add("InternalSupplyRequest");
	DataTable.Columns.Add("PurchaseOrder");
	DataTable.Columns.Add("RowKey", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	DataTable.Columns.Add("ItemKey");
	DataTable.Columns.Add("Quantity");
	
	Filter = New Structure("ItemKey", ItemKey);
	
	SupplyRequests = ThisObject.ResultsTableOfInternalSupplyRequest.Unload(Filter);
	TableOfBalance = ThisObject.ResultsTableOfBalance.Unload(Filter); 
	
	For Each Row In TableOfBalance Do
		// by Internal supply request
		NeededQuantity = Row.Quantity;
		For Each RowSupplyRequest In SupplyRequests Do
			If Not ValueIsFilled(NeededQuantity) Or Not ValueIsFilled(RowSupplyRequest.Transfer) Then
				Continue;
			EndIf;
			NewRow = DataTable.Add();
			NewRow.StoreSender = Row.Store;
			NewRow.InternalSupplyRequest = RowSupplyRequest.InternalSupplyRequest;
			NewRow.RowKey = RowSupplyRequest.RowKey;
			NewRow.Quantity = Min(NeededQuantity, RowSupplyRequest.Transfer);
			NewRow.ItemKey = ItemKey;
			RowSupplyRequest.Transfer = RowSupplyRequest.Transfer - NewRow.Quantity;
			NeededQuantity =  NeededQuantity - NewRow.Quantity;
		EndDo;
		
		// by Internal supply request and Purchase orders
		NeededQuantity = Row.QuantityIncomming;
		For Each RowSupplyRequest In SupplyRequests Do
			If Not ValueIsFilled(NeededQuantity) Or Not ValueIsFilled(RowSupplyRequest.Transfer) Then
				Continue;
			EndIf;
			NewRow = DataTable.Add();
			NewRow.StoreSender = Row.Store;
			NewRow.InternalSupplyRequest = RowSupplyRequest.InternalSupplyRequest;
			NewRow.PurchaseOrder = Row.PurchaseOrder;
			NewRow.RowKey = RowSupplyRequest.RowKey;
			NewRow.Quantity = Min(NeededQuantity, RowSupplyRequest.Transfer);
			NewRow.ItemKey = ItemKey;
			RowSupplyRequest.Transfer = RowSupplyRequest.Transfer - NewRow.Quantity;
			NeededQuantity =  NeededQuantity - NewRow.Quantity;
		EndDo;
	EndDo;
	
	DataTable.GroupBy("StoreSender, InternalSupplyRequest, PurchaseOrder, RowKey, ItemKey", "Quantity");
	
	// without Internal supply request
	For Each Row In TableOfBalance Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		
		ArrayOfRows = DataTable.FindRows(New Structure("StoreSender", Row.Store));
		TotalByStore = 0;
		For Each ItemOfRow In ArrayOfRows Do
			TotalByStore = TotalByStore + ItemOfRow.Quantity;
		EndDo;
		If TotalByStore < Row.Quantity Then
			NewRow = DataTable.Add();
			NewRow.StoreSender = Row.Store;
			NewRow.RowKey = New UUID();
			NewRow.ItemKey = ItemKey;
			NewRow.Quantity = Row.Quantity - TotalByStore;
		EndIf;
	EndDo;
	
	Return DataTable;
EndFunction

&AtServer
Function Create_InventoryTransferOrder(DataTable)
	ArrayOfTransferOrders = New Array();
	
	DataTableFilter = DataTable.Copy();
	DataTableFilter.GroupBy("StoreSender, RowKey");
	For Each RowFilter In DataTableFilter Do
		
		NewTransferOrder = Documents.InventoryTransferOrder.CreateDocument();
		NewTransferOrder.Date = CurrentSessionDate();
		NewTransferOrder.Company = ThisObject.Company;
		NewTransferOrder.StoreReceiver = ThisObject.Store;
		NewTransferOrder.StoreSender = RowFilter.StoreSender;
		
		Filter = New Structure();
		Filter.Insert("StoreSender", RowFilter.StoreSender);
		Filter.Insert("RowKey", RowFilter.RowKey);
		ArrayOfRows = DataTable.FindRows(Filter);
		For Each ItemOfRow In ArrayOfRows Do
			NewRow = NewTransferOrder.ItemList.Add();
			NewRow.Key = ItemOfRow.RowKey;
			NewRow.ItemKey = ItemOfRow.ItemKey;
			
			UnitInfo = GetItemInfo.ItemUnitInfo(NewRow.ItemKey);
			NewRow.Unit = UnitInfo.Unit;
			
			NewRow.Quantity = ItemOfRow.Quantity;
			NewRow.InternalSupplyRequest = ItemOfRow.InternalSupplyRequest;
			NewRow.PurchaseOrder = ItemOfRow.PurchaseOrder;
		EndDo;
		
		NewTransferOrder.Fill(Undefined);
		NewTransferOrder.Write(DocumentWriteMode.Write);	
		ArrayOfTransferOrders.Add(NewTransferOrder.Ref);
	EndDo;
	Return ArrayOfTransferOrders;
EndFunction

&AtServer
Function CollectDataFor_PurchaseOrder(ItemKey)
	DataTable = New ValueTable();
	DataTable.Columns.Add("Partner");
	DataTable.Columns.Add("Agreement");
	DataTable.Columns.Add("PriceType");
	DataTable.Columns.Add("Price");
	DataTable.Columns.Add("DeliveryDate");
	DataTable.Columns.Add("InternalSupplyRequest");
	DataTable.Columns.Add("RowKey", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
	DataTable.Columns.Add("ItemKey");
	DataTable.Columns.Add("Unit");
	DataTable.Columns.Add("Store");
	DataTable.Columns.Add("Quantity");
	
	Filter = New Structure("ItemKey", ItemKey);
	
	SupplyRequests = ThisObject.ResultsTableOfInternalSupplyRequest.Unload(Filter);
	TableOfPurchase = ThisObject.ResultsTableOfPurchase.Unload(Filter);
	
	For Each Row In TableOfPurchase Do
		
		// recalculate SupplyRequests quantity by Unit factor
		
		NeededQuantity = Row.Quantity;
		For Each RowSupplyRequest In SupplyRequests Do
			If Not ValueIsFilled(NeededQuantity) Or Not ValueIsFilled(RowSupplyRequest.Purchase) Then
				Continue;
			EndIf;
			NewRow = DataTable.Add();
			NewRow.Partner = Row.Partner;
			NewRow.Agreement = Row.Agreement;
			NewRow.PriceType = Row.PriceType;
			NewRow.Price = Row.Price;
			NewRow.DeliveryDate = Row.DeliveryDate;
			NewRow.InternalSupplyRequest = RowSupplyRequest.InternalSupplyRequest;
			NewRow.RowKey = RowSupplyRequest.RowKey;
			NewRow.ItemKey = ItemKey;
			NewRow.Unit = Row.Unit;
			NewRow.Store = Row.Store;
			NewRow.Quantity = Min(NeededQuantity, RowSupplyRequest.Purchase);
			RowSupplyRequest.Purchase = RowSupplyRequest.Purchase - NewRow.Quantity;
			NeededQuantity =  NeededQuantity - NewRow.Quantity;
		EndDo;
	EndDo;
	
	DataTable.GroupBy("Partner, Agreement, PriceType, Price, DeliveryDate, InternalSupplyRequest, RowKey, ItemKey, Unit, Store", 
			"Quantity");
	
	For Each Row In TableOfPurchase Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		Filter = New Structure();
		FIlter.Insert("Partner", Row.Partner);
		FIlter.Insert("Agreement", Row.Agreement);
		FIlter.Insert("PriceType", Row.PriceType);
		FIlter.Insert("Price", Row.Price);
		FIlter.Insert("DeliveryDate", Row.DeliveryDate);
		FIlter.Insert("Unit", Row.Unit);
		FIlter.Insert("Store", Row.Store);
		
		ArrayOfRows = DataTable.FindRows(Filter);
		TotalQ = 0;
		For Each ItemOfRow In ArrayOfRows Do
			TotalQ = TotalQ + ItemOfRow.Quantity;
		EndDo;
		If TotalQ < Row.Quantity Then
			NewRow = DataTable.Add();
			NewRow.Partner = Row.Partner;
			NewRow.Agreement = Row.Agreement;
			NewRow.PriceType = Row.PriceType;
			NewRow.Price = Row.Price;
			NewRow.DeliveryDate = Row.DeliveryDate;
			NewRow.Unit = Row.Unit;
			NewRow.Store = Row.Store;
			//NewRow.RowKey = New UUID();
			NewRow.ItemKey = ItemKey;
			NewRow.Quantity = Row.Quantity - TotalQ;
		EndIf;
	EndDo;
	Return DataTable;
EndFunction

&AtServer
Function Create_PurchaseOrder(DataTable)	
	ArrayOfPurchaseOrders = New Array();
	
	// create Invetntory transfer orders if store in purchase not much store in ThisObject
	ArrayOfTransferOrders = New Array();
	
	DataTableFilter = DataTable.Copy();
	DataTableFilter.GroupBy("Partner, Agreement");
	For Each RowFilter In DataTableFilter Do
		AgreementInfo = CatAgreementsServer.GetAgreementInfo(RowFilter.Agreement);
		
		NewPurchaseOrder = Documents.PurchaseOrder.CreateDocument();
		NewPurchaseOrder.Date = CurrentSessionDate();
		NewPurchaseOrder.Company = ThisObject.Company;
		NewPurchaseOrder.Agreement = RowFilter.Agreement;		
		NewPurchaseOrder.Currency = AgreementInfo.Currency;
		NewPurchaseOrder.Partner = RowFilter.Partner;
		NewPurchaseOrder.PriceIncludeTax = AgreementInfo.PriceIncludeTax;
		NewPurchaseOrder.LegalName = DocumentsServer.GetLegalNameByPartner(NewPurchaseOrder.Partner, 
		                                                                   NewPurchaseOrder.LegalName);
		
		Filter = New Structure();
		Filter.Insert("Partner", RowFilter.Partner);
		Filter.Insert("Agreement", RowFilter.Agreement);
		ArrayOfRows = DataTable.FindRows(Filter);
		For Each ItemOfRow In ArrayOfRows Do
			NewRow = NewPurchaseOrder.ItemList.Add();
			NewRow.Key = ItemOfRow.RowKey;
			NewRow.ItemKey = ItemOfRow.ItemKey;
			NewRow.Unit = ItemOfRow.Unit;
			NewRow.Store = ?(ValueIsFilled(ItemOfRow.Store), ItemOfRow.Store, ThisObject.Store);
			
			If Not ValueIsFilled(NewRow.Unit) Then
				UnitInfo = GetItemInfo.ItemUnitInfo(NewRow.ItemKey);
				NewRow.Unit = UnitInfo.Unit;
			EndIf;
			
			NewRow.Quantity = ItemOfRow.Quantity;
			NewRow.PurchaseBasis = ItemOfRow.InternalSupplyRequest;
			NewRow.Price = ItemOfRow.Price;
			NewRow.PriceType = ItemOfRow.PriceType;
			NewRow.DeliveryDate = ItemOfRow.DeliveryDate;
		EndDo;
		
		NewPurchaseOrder.Fill(Undefined);
		NewPurchaseOrder.Write(DocumentWriteMode.Write);	
		ArrayOfPurchaseOrders.Add(NewPurchaseOrder.Ref);
	EndDo;
	Return ArrayOfPurchaseOrders;
EndFunction

&AtClient
Procedure ResultsItemListOnActivateRow(Item)
	SetVisibleInResultTables();
EndProcedure

&AtServer
Function GetArrayOfSupplyRequestFromDetails()
	ArrayOfSupplyRequest = New Array();
	For Each Row In ThisObject.Details.GetItems() Do
		If Not ValueIsFilled(Row.TotalQuantity)
			Or TypeOf(Row.Document) <> Type("DocumentRef.InternalSupplyRequest") Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("InternalSupplyRequest", Row.Document);
		NewRow.Insert("RowKey", Row.RowKey);
		NewRow.Insert("Quantity", Row.TotalQuantity);
		NewRow.Insert("ProcurementDate", ?(ValueIsFilled(Row.Document.ProcurementDate), 
		Row.Document.ProcurementDate, Row.Document.Date));
		ArrayOfSupplyRequest.Add(NewRow);
	EndDo;
	Return ArrayOfSupplyRequest;
EndFunction

&AtServer
Function GetArrayOfSupplyRequestFromResultsTable(ItemKey)
	ArrayOfSupplyRequest = New Array();
	Filter = New Structure("ItemKey", ItemKey);
	For Each Row In ThisObject.ResultsTableOfInternalSupplyRequest.FindRows(Filter) Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("InternalSupplyRequest", Row.InternalSupplyRequest);
		NewRow.Insert("RowKey", Row.RowKey);
		NewRow.Insert("Quantity", Row.Quantity);
		NewRow.Insert("ProcurementDate", ?(ValueIsFilled(Row.InternalSupplyRequest.ProcurementDate), 
		Row.InternalSupplyRequest.ProcurementDate, Row.InternalSupplyRequest.Date));
		ArrayOfSupplyRequest.Add(NewRow);
	EndDo;
	Return ArrayOfSupplyRequest;
EndFunction

&AtClient
Procedure AnalysisOnActivateRow(Item)
	CurrentData = Items.Analysis.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Fill_Details(CurrentData.ItemKey);
EndProcedure
	
&AtServer
Procedure DeleteColumns_Analysis()
	ArrayOfColumns = New Array();
	
	For Each Row In ThisObject.TableOfColumns Do
		ArrayOfColumns.Add("Analysis." + Row.Name);
		Items.Delete(Items["Analysis" + Row.Name]);
	EndDo;
	
	If ArrayOfColumns.Count() Then
		ChangeAttributes(, ArrayOfColumns);
	EndIf;
EndProcedure

&AtServer
Procedure CreateColumns_Analysis()
	TypeQuantity = Metadata.DefinedTypes.typeQuantity.Type;
	ArrayOfColumns = New Array();
	For Each Row In ThisObject.TableOfColumns Do		
		ArrayOfColumns.Add(New FormAttribute(Row.Name, TypeQuantity, "Analysis", Row.Title));
	EndDo;
	
	ChangeAttributes(ArrayOfColumns);
	
	For Each Row In ThisObject.TableOfColumns Do
		NewItem_Analysis = Items.Add("Analysis" + Row.Name, Type("FormField"), Items.Analysis);       
		NewItem_Analysis.Type = FormFieldType.InputField;
		NewItem_Analysis.DataPath = "Analysis." + Row.Name;
		NewItem_Analysis.ReadOnly = True;
	EndDo;
EndProcedure

&AtServer
Procedure CreateColumns_Details()
	TypeQuantity = Metadata.DefinedTypes.typeQuantity.Type;
	ArrayOfColumns = New Array();
	For Each Row In ThisObject.TableOfColumns Do		
		ArrayOfColumns.Add(New FormAttribute(Row.Name, TypeQuantity, "Details", Row.Title));
	EndDo;
	
	ChangeAttributes(ArrayOfColumns);
	
	For Each Row In ThisObject.TableOfColumns Do
		NewItem_Details = Items.Add("Details" + Row.Name, Type("FormField"), Items.Details);       
		NewItem_Details.Type = FormFieldType.InputField;
		NewItem_Details.DataPath = "Details." + Row.Name;
		NewItem_Details.ReadOnly = True;		
	EndDo;
EndProcedure

&AtServer
Procedure DeleteColumns_Details()
	ArrayOfColumns = New Array();
	
	For Each Row In ThisObject.TableOfColumns Do
		ArrayOfColumns.Add("Details." + Row.Name);
		Items.Delete(Items["Details" + Row.Name]);
	EndDo;
	
	If ArrayOfColumns.Count() Then
		ChangeAttributes(, ArrayOfColumns);
	EndIf;
EndProcedure

&AtServer
Procedure Fill_Details(ItemKey)
	ThisObject.Details.GetItems().Clear();
	
	ProcurementDocumentsSelection = 
	GetTreeOfProcurementDocuments(ThisObject.Store, 
	                              ItemKey, 
	                              ThisObject.Period.StartDate, 
	                              ThisObject.Period.EndDate);
		
	While ProcurementDocumentsSelection.Next() Do
		If Not ValueIsFilled(ProcurementDocumentsSelection.Order) Then
			Continue;
		EndIf;
		NewRowDetails = ThisObject.Details.GetItems().Add();
		NewRowDetails.Document = ProcurementDocumentsSelection.Order;
			
		NewRowDetails.TotalQuantity = 0;
		For Each RowColumnInfo In TableOfColumns Do
			NewRowDetails[RowColumnInfo.Name] = 
			GetProcurementReceiptByItemKeyAndOrder(ThisObject.Store, 
				                                ItemKey, 
				                                ProcurementDocumentsSelection.Order, 
				                                RowColumnInfo.StartDate, 
				                                RowColumnInfo.EndDate);
			NewRowDetails.TotalQuantity = NewRowDetails.TotalQuantity + NewRowDetails[RowColumnInfo.Name];			
		EndDo;
			
		ProcurementRecorderSelection = ProcurementDocumentsSelection.Select();
		While ProcurementRecorderSelection.Next() Do
			NewRowDetails.RowKey = ProcurementRecorderSelection.RowKey;
				
			If ValueIsFilled(ProcurementRecorderSelection.Recorder) Then
				NewRowDetailsRecorder = NewRowDetails.GetItems().Add();
				NewRowDetailsRecorder.Document = ProcurementRecorderSelection.Recorder;
				For Each RowColumnInfo In TableOfColumns Do
					NewRowDetailsRecorder[RowColumnInfo.Name] =
						- GetProcurementExpenseByItemKeyAndOrder(ThisObject.Store,
					                                       ItemKey, 
					                                       ProcurementDocumentsSelection.Order, 
					                                       ProcurementRecorderSelection.Recorder, 
					                                       RowColumnInfo.StartDate, 
					                                       RowColumnInfo.EndDate);
					NewRowDetails.TotalQuantity = NewRowDetails.TotalQuantity + NewRowDetailsRecorder[RowColumnInfo.Name];
				EndDo;
			EndIf;
		EndDo;
	EndDo;
	
	TableOfOrdersWithoutSupplyRequest = TableOfOrdersWithoutSupplyRequest(ThisObject.Store, ItemKey);
	TableOfOrdersWithoutSupplyRequestByPeriods = New ValueTable();
	TableOfOrdersWithoutSupplyRequestByPeriods.Columns.Add("Document");
	TableOfOrdersWithoutSupplyRequestByPeriods.Columns.Add("TableByDates");
	
	For Each Row In TableOfOrdersWithoutSupplyRequest Do
		TableByDates = New ValueTable();
		TableByDates.Columns.Add("Name");
		TableByDates.Columns.Add("Quantity");
		For Each RowColumnInfo In TableOfColumns Do
			If Row.DeliveryDate >= RowColumnInfo.StartDate And Row.DeliveryDate <= RowColumnInfo.EndDate Then
				Filter = New Structure();
				Filter.Insert("Name", RowColumnInfo.Name);
				FindRows = TableByDates.FindRows(Filter);
				If Not FindRows.Count() Then
					NewRowByDate = TableByDates.Add();
					NewRowByDate.Name = RowColumnInfo.Name;
					NewRowByDate.Quantity = Row.Quantity;
				Else
					NewRowByDate[0].Name = RowColumnInfo.Name;
					NewRowByDate[0].Quantity = NewRowByDate[0].Quantity + Row.Quantity;
				EndIf;
			EndIf;
		EndDo;
		If TableByDates.Count() Then
			NewRowOrdersWithoutSupplyRequestByPeriod = TableOfOrdersWithoutSupplyRequestByPeriods.Add();
			NewRowOrdersWithoutSupplyRequestByPeriod.Document = Row.Order;
			NewRowOrdersWithoutSupplyRequestByPeriod.TableByDates = TableByDates;
		EndIf;
	EndDo;
	
	If TableOfOrdersWithoutSupplyRequestByPeriods.Count() Then
		NewRowDetails = ThisObject.Details.GetItems().Add();
		NewRowDetails.Document = R().I_6;
		NewRowDetails.Picture = 4;
		For Each Row In TableOfOrdersWithoutSupplyRequestByPeriods Do
			NewRowDetailsRecorder = NewRowDetails.GetItems().Add();
			NewRowDetailsRecorder.Document = Row.Document;
			For Each RowByDate In Row.TableByDates Do
				NewRowDetailsRecorder[RowByDate.Name] = RowByDate.Quantity;
			EndDo;
		EndDo;
	EndIf;
	
EndProcedure

&AtClient
Procedure VisibleResultTablesOnChange(Item)
	SetVisible();
	SaveSettings();
EndProcedure

&AtClient
Procedure VisibleAnalyisRowsOnChange(Item)
	SetVisible();
	SaveSettings();
EndProcedure

&AtClient
Procedure VisibleCreatedDocumentTablesOnChange(Item)
	SetVisible();	
	SaveSettings();
EndProcedure

&AtServer
Procedure SetVisible()
	If Upper(ThisObject.VisibleResultTables) = Upper("All") Then
		Items.ResultsTableOfBalance.Visible = True;
		Items.ResultsTableOfPurchase.Visible = True;
	ElsIf Upper(ThisObject.VisibleResultTables) = Upper("Transfer") Then
		Items.ResultsTableOfBalance.Visible = True;
		Items.ResultsTableOfPurchase.Visible = False;
	ElsIf Upper(ThisObject.VisibleResultTables) = Upper("Purchase") Then
		Items.ResultsTableOfBalance.Visible = False;
		Items.ResultsTableOfPurchase.Visible = True;
	EndIf;	

	If Upper(ThisObject.VisibleCreatedDocumentTables) = Upper("All") Then
		Items.CreatedInventoryTransferOrders.Visible = True;
		Items.CreatedPurchaseOrders.Visible = True;
	ElsIf Upper(ThisObject.VisibleCreatedDocumentTables) = Upper("Transfer") Then
		Items.CreatedInventoryTransferOrders.Visible = True;
		Items.CreatedPurchaseOrders.Visible = False;
	ElsIf Upper(ThisObject.VisibleCreatedDocumentTables) = Upper("Purchase") Then
		Items.CreatedInventoryTransferOrders.Visible = False;
		Items.CreatedPurchaseOrders.Visible = True;
	EndIf;	
	 
	If Upper(ThisObject.VisibleAnalyisRows) = Upper("All") Then
		Items.Analysis.RowFilter = Undefined;
	ElsIf Upper(ThisObject.VisibleAnalyisRows) = Upper("OnlyWithShortage") Then
		Items.Analysis.RowFilter = New FixedStructure("Visible", True);
	EndIf;
EndProcedure

&AtClient
Procedure ShowPrecisionOnChange(Item)
	ShowPrecision();
	SaveSettings();
EndProcedure

Procedure ShowPrecision()
	FieldFormat = ?(ThisObject.ShowPrecision, "", "NFD=0");
	For Each Row In ThisObject.TableOfColumns Do
		Items["Analysis" + Row.Name].Format = FieldFormat;
		Items["Details" + Row.Name].Format = FieldFormat;
	EndDo;
	Items.DetailsTotalQuantity.Format = FieldFormat;
	Items.AnalysisOpenBalance.Format = FieldFormat;
	Items.AnalysisTotalProcurement.Format = FieldFormat;
	Items.AnalysisOrdered.Format = FieldFormat;
	Items.AnalysisShortage.Format = FieldFormat;
	Items.AnalysisExpired.Format = FieldFormat;
	Items.ResultsTableOfBalanceQuantity.Format = FieldFormat;
	Items.ResultsTableOfPurchaseQuantity.Format = FieldFormat;
	Items.ResultsTableOfInternalSupplyRequestQuantity.Format = FieldFormat;
	Items.ResultsTableOfInternalSupplyRequestTransfer.Format = FieldFormat;
	Items.ResultsTableOfInternalSupplyRequestPurchase.Format = FieldFormat;
EndProcedure

&AtServer
Function  GetTableOfSupplyRequests(Store, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	OrderBalanceTurnovers.Store AS Store,
	|	OrderBalanceTurnovers.ItemKey AS ItemKey,
	|	OrderBalanceTurnovers.ItemKey.Item AS Item,
	|	SUM(OrderBalanceTurnovers.QuantityReceipt) AS QuantityProcurement,
	|	SUM(OrderBalanceTurnovers.QuantityExpense) AS QuantityOrdered
	|INTO tmpOrderBalance
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND CASE
	|		WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|			THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|		ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|	END BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND BEGINOFPERIOD(&EndDate, DAY)) AS OrderBalanceTurnovers
	|GROUP BY
	|	OrderBalanceTurnovers.Store,
	|	OrderBalanceTurnovers.ItemKey,
	|	OrderBalanceTurnovers.ItemKey.Item
	|;
	|
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpOrderBalance.Store AS Store,
	|	tmpOrderBalance.ItemKey AS ItemKey,
	|	tmpOrderBalance.Item AS Item,
	|	CASE
	|		WHEN tmpOrderBalance.ItemKey.Unit = VALUE(Catalog.Units.EmptyRef)
	|			THEN tmpOrderBalance.Item.Unit
	|		ELSE tmpOrderBalance.ItemKey.Unit
	|	END AS Unit,
	|	tmpOrderBalance.QuantityProcurement AS QuantityProcurement,
	|	tmpOrderBalance.QuantityOrdered AS QuantityOrdered,
//	|	tmpOrderBalance.QuantityProcurement - tmpOrderBalance.QuantityOrdered -
//	|		ISNULL(StockReservationBalance.QuantityBalance, 0) AS QuantityShortage,
	|	OrderBalanceBalance.QuantityBalance AS QuantityExpired,
	|	ISNULL(StockReservationBalance.QuantityBalance, 0) AS OpenBalance
	|FROM
	|	tmpOrderBalance AS tmpOrderBalance
	|		LEFT JOIN AccumulationRegister.StockReservation.Balance(BEGINOFPERIOD(&StartDate, DAY), (Store, ItemKey) IN
	|			(SELECT
	|				tmp.Store,
	|				tmp.ItemKey
	|			FROM
	|				tmpOrderBalance AS tmp)) AS StockReservationBalance
	|		ON tmpOrderBalance.Store = StockReservationBalance.Store
	|		AND tmpOrderBalance.ItemKey = StockReservationBalance.ItemKey
	|		LEFT JOIN AccumulationRegister.OrderBalance.Balance(, (Store, ItemKey) IN
	|			(SELECT
	|				tmp.Store,
	|				tmp.ItemKey
	|			FROM
	|				tmpOrderBalance AS tmp)
	|		AND Order REFS Document.InternalSupplyRequest
	|		AND CASE
	|			WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|				THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|			ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|		END < BEGINOFPERIOD(&StartDate, DAY)) AS OrderBalanceBalance
	|		ON tmpOrderBalance.Store = OrderBalanceBalance.Store
	|		AND tmpOrderBalance.ItemKey = OrderBalanceBalance.ItemKey
	|ORDER BY
	|	tmpOrderBalance.Item.Code";
	Query.SetParameter("Store", Store);
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
EndFunction


&AtServer
Function GetProcurementByItemKey(Store, ItemKey, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SUM(OrderBalanceTurnovers.QuantityReceipt) AS Quantity
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND CASE
	|		WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|			THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|		ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|	END BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND ItemKey = &ItemKey) AS OrderBalanceTurnovers";
	Query.SetParameter("Store", Store);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Quantity;
	Else
		Return 0;
	EndIf;
EndFunction

&AtServer
Function GetTreeOfProcurementDocuments(Store, ItemKey, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	InternalSupplyRequest.Order AS Order,
	|	CloserOrders.Recorder AS Recorder,
	|	InternalSupplyRequest.QuantityReceipt AS Quantity,
	|	CloserOrders.QuantityExpense AS QuantityExpense,
	|	InternalSupplyRequest.RowKey
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND CASE
	|		WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|			THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|		ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|	END BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND ItemKey = &ItemKey) AS InternalSupplyRequest
	|		LEFT JOIN AccumulationRegister.OrderBalance.Turnovers(,, Recorder, Order REFS Document.InternalSupplyRequest
	|		AND Store = &Store
	|		AND ItemKey = &ItemKey) AS CloserOrders
	|		ON CAST(InternalSupplyRequest.Order AS Document.InternalSupplyRequest) = CAST(CloserOrders.Order AS
	|			Document.InternalSupplyRequest)
	|		AND InternalSupplyRequest.Order REFS Document.InternalSupplyRequest
	|		AND CloserOrders.Order REFS Document.InternalSupplyRequest
	|		AND InternalSupplyRequest.Order <> CloserOrders.Recorder
	|		AND InternalSupplyRequest.ItemKey = CloserOrders.ItemKey
	|TOTALS
	|	MAX(Quantity)
	|BY
	|	Order";
	Query.SetParameter("Store", Store);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	Return QuerySelection;
EndFunction

&AtServer
Function GetProcurementReceiptByItemKeyAndOrder(Store, ItemKey, Order, StartDate, EndDate)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	SUM(OrderBalanceTurnovers.QuantityReceipt) AS Quantity
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND CASE
	|		WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|			THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|		ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|	END BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND ItemKey = &ItemKey
	|	AND CAST(Order AS Document.InternalSupplyRequest) = &Order) AS OrderBalanceTurnovers";
	Query.SetParameter("Store", Store);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("Order", Order);
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Quantity;
	Else
		Return 0;
	EndIf;
EndFunction

&AtServer
Function GetProcurementExpenseByItemKeyAndOrder(Store, ItemKey, Order, Recorder, StartDate, EndDate)
	Query = New Query();
	If TypeOf(Recorder) = Type("DocumentRef.InventoryTransferOrder") Then
		Query.Text = GetExpenseQueryText_InventoryTransferOrder();
	Else
		Query.Text = GetExpenseQueryText_PurchaseOrder();
	EndIf;
	Query.SetParameter("Store", Store);
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("Order", Order);
	Query.SetParameter("Recorder", Recorder);
	
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		If ValueIsFilled(QuerySelection.Quantity) Then
			Return QuerySelection.Quantity;
		EndIf;
	EndIf;
	Return 0;
EndFunction

&AtServer
Function GetExpenseQueryText_InventoryTransferOrder()
	Return
	"SELECT
	|	SUM(OrderBalanceTurnovers.QuantityExpense) AS Quantity
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,, Recorder, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND CASE
	|		WHEN CAST(Order AS Document.InternalSupplyRequest).ProcurementDate = DATETIME(1, 1, 1)
	|			THEN CAST(Order AS Document.InternalSupplyRequest).Date
	|		ELSE CAST(Order AS Document.InternalSupplyRequest).ProcurementDate
	|	END BETWEEN BEGINOFPERIOD(&StartDate, DAY) AND ENDOFPERIOD(&EndDate, DAY)
	|	AND ItemKey = &ItemKey
	|	AND CAST(Order AS Document.InternalSupplyRequest) = &Order) AS OrderBalanceTurnovers
	|WHERE
	|	OrderBalanceTurnovers.Recorder = &Recorder";	
EndFunction

&AtServer
Function GetExpenseQueryText_PurchaseOrder()
	Return
	"SELECT
	|	SUM(OrderBalanceTurnovers.QuantityExpense) AS Quantity,
	|	OrderBalanceTurnovers.Store AS Store,
	|	OrderBalanceTurnovers.Order AS Order,
	|	CAST(&Recorder AS Document.PurchaseOrder) AS Recorder,
	|	OrderBalanceTurnovers.ItemKey AS ItemKey,
	|	OrderBalanceTurnovers.RowKey
	|INTO tmpPurchaseOrders
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,, Recorder, Order REFS Document.InternalSupplyRequest
	|	AND Store = &Store
	|	AND ItemKey = &ItemKey
	|	AND CAST(Order AS Document.InternalSupplyRequest) = &Order) AS OrderBalanceTurnovers
	|WHERE
	|	OrderBalanceTurnovers.Recorder = &Recorder
	|GROUP BY
	|	OrderBalanceTurnovers.Store,
	|	OrderBalanceTurnovers.Order,
	|	OrderBalanceTurnovers.ItemKey,
	|	OrderBalanceTurnovers.RowKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SUM(tmpPurchaseOrders.Quantity) AS Quantity
	|FROM
	|	tmpPurchaseOrders AS tmpPurchaseOrders
	|		LEFT JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
	|		ON tmpPurchaseOrders.Recorder = GoodsReceiptSchedule.Recorder
	|		AND GoodsReceiptSchedule.Recorder = &Recorder
	|		AND GoodsReceiptSchedule.RecordType = VALUE(AccumulationRecordType.Receipt)
	|		AND tmpPurchaseOrders.Store = GoodsReceiptSchedule.Store
	|		AND tmpPurchaseOrders.ItemKey = GoodsReceiptSchedule.ItemKey
	|		AND tmpPurchaseOrders.RowKey = GoodsReceiptSchedule.RowKey
	|WHERE
	|	ISNULL(GoodsReceiptSchedule.DeliveryDate, tmpPurchaseOrders.Recorder.Date) BETWEEN BEGINOFPERIOD(&StartDate,
	|		DAY) AND ENDOFPERIOD(&EndDate, DAY)";
EndFunction

&AtServer
Function TableOfOrdersWithoutSupplyRequest(Store, ItemKey = Undefined)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	OrderBalanceTurnovers.Store AS Store,
	|	OrderBalanceTurnovers.ItemKey AS ItemKey,
	|	OrderBalanceTurnovers.RowKey AS RowKey
	|INTO tmp
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, CASE
	|		WHEN &Filter_ItemKey
	|			THEN ItemKey = &ItemKey
	|		ELSE TRUE
	|	END
	|	AND Store = &Store
	|	AND Order REFS Document.InternalSupplyRequest) AS OrderBalanceTurnovers
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	OrderBalanceTurnovers.Store AS Store,
	|	OrderBalanceTurnovers.Order AS Order,
	|	OrderBalanceTurnovers.ItemKey AS ItemKey,
	|	OrderBalanceTurnovers.RowKey AS RowKey,
	|	OrderBalanceTurnovers.QuantityReceipt AS QuantityReceipt,
	|	MAX(BEGINOFPERIOD(GoodsReceiptSchedule.DeliveryDate, DAY)) AS DeliveryDate
	|INTO tmpPurchaseOrders
	|FROM
	|	AccumulationRegister.OrderBalance.Turnovers(,,, Store = &Store
	|	AND CASE
	|		WHEN &Filter_ItemKey
	|			THEN ItemKey = &ItemKey
	|		ELSE TRUE
	|	END
	|	AND Order REFS Document.PurchaseOrder) AS OrderBalanceTurnovers
	|		LEFT JOIN tmp AS tmp
	|		ON tmp.Store = OrderBalanceTurnovers.Store
	|		AND tmp.ItemKey = OrderBalanceTurnovers.ItemKey
	|		AND tmp.RowKey = OrderBalanceTurnovers.RowKey
	|		LEFT JOIN AccumulationRegister.GoodsReceiptSchedule AS GoodsReceiptSchedule
	|		ON CAST(OrderBalanceTurnovers.Order AS Document.PurchaseOrder) = CAST(GoodsReceiptSchedule.Order AS
	|			Document.PurchaseOrder)
	|		AND OrderBalanceTurnovers.Store = GoodsReceiptSchedule.Store
	|		AND OrderBalanceTurnovers.ItemKey = GoodsReceiptSchedule.ItemKey
	|		AND OrderBalanceTurnovers.RowKey = GoodsReceiptSchedule.RowKey
	|WHERE
	|	tmp.ItemKey IS NULL
	|GROUP BY
	|	OrderBalanceTurnovers.Store,
	|	OrderBalanceTurnovers.Order,
	|	OrderBalanceTurnovers.ItemKey,
	|	OrderBalanceTurnovers.RowKey,
	|	OrderBalanceTurnovers.QuantityReceipt
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TransferOrderBalanceTurnovers.StoreReceiver AS Store,
	|	TransferOrderBalanceTurnovers.Order AS Order,
	|	TransferOrderBalanceTurnovers.ItemKey AS ItemKey,
	|	TransferOrderBalanceTurnovers.RowKey AS RowKey,
	|	TransferOrderBalanceTurnovers.QuantityReceipt AS QuantityReceipt,
	|	BEGINOFPERIOD(CAST(TransferOrderBalanceTurnovers.Order AS Document.InventoryTransferOrder).Date, DAY) AS DeliveryDate
	|INTO tmpInventoryTransferOrders
	|FROM
	|	AccumulationRegister.TransferOrderBalance.Turnovers(,,, StoreReceiver = &Store
	|	AND CASE
	|		WHEN &Filter_ItemKey
	|			THEN ItemKey = &ItemKey
	|		ELSE TRUE
	|	END
	|	AND Order REFS Document.InventoryTransferOrder) AS TransferOrderBalanceTurnovers
	|		LEFT JOIN tmp AS tmp
	|		ON TransferOrderBalanceTurnovers.StoreReceiver = tmp.Store
	|		AND TransferOrderBalanceTurnovers.ItemKey = tmp.ItemKey
	|		AND TransferOrderBalanceTurnovers.RowKey = tmp.RowKey
	|WHERE
	|	tmp.ItemKey IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpPurchaseOrders.Store AS Store,
	|	tmpPurchaseOrders.Order AS Order,
	|	tmpPurchaseOrders.ItemKey AS ItemKey,
	|	tmpPurchaseOrders.RowKey AS RowKey,
	|	tmpPurchaseOrders.QuantityReceipt AS Quantity,
	|	tmpPurchaseOrders.DeliveryDate AS DeliveryDate
	|FROM
	|	tmpPurchaseOrders AS tmpPurchaseOrders
	|
	|UNION ALL
	|
	|SELECT
	|	tmpInventoryTransferOrders.Store,
	|	tmpInventoryTransferOrders.Order,
	|	tmpInventoryTransferOrders.ItemKey,
	|	tmpInventoryTransferOrders.RowKey,
	|	tmpInventoryTransferOrders.QuantityReceipt,
	|	tmpInventoryTransferOrders.DeliveryDate
	|FROM
	|	tmpInventoryTransferOrders AS tmpInventoryTransferOrders";
	Query.SetParameter("ItemKey", ItemKey);
	Query.SetParameter("Store", Store);
	Query.SetParameter("Filter_ItemKey", ValueIsFilled(ItemKey));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable; 
EndFunction

