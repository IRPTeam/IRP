
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Store = Parameters.Store;
	ThisObject.Company = Parameters.Company;
	ThisObject.Item = Parameters.Item;
	ThisObject.ItemKey = Parameters.ItemKey;
	ThisObject.DateOfRelevance = CurrentSessionDate();
	
	For Each Row In Parameters.ArrayOfSupplyRequest Do
		NewRow = ThisObject.TableOfInternalSupplyRequest.Add();
		NewRow.InternalSupplyRequest = Row.InternalSupplyRequest;
		NewRow.RowKey = Row.RowKey;
		NewRow.Quantity = Row.Quantity;
		NewRow.ProcurementDate = Row.ProcurementDate;
		ThisObject.TotalQuantity = ThisObject.TotalQuantity + Row.Quantity;
	EndDo;
	
	Update_TableOfBalance();
	Update_TableOfPurchase();
EndProcedure

&AtServer
Procedure Update_AllTables()
	Update_TableOfBalance();
	Update_TableOfPurchase();
EndProcedure

&AtClient
Procedure TableOfInternalSupplyRequestSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.TableOfInternalSupplyRequest.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfInternalSupplyRequestInternalSupplyRequest") Then
		If Not ValueIsFilled(CurrentData.InternalSupplyRequest) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.InternalSupplyRequest);
		OpenForm(GetMetadataFullName(CurrentData.InternalSupplyRequest) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtClient
Procedure TableOfBalanceSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.TableOfBalance.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfBalanceStore") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Store) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Store);
		OpenForm(GetMetadataFullName(CurrentData.Store) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtClient
Procedure TableOfPurchaseSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.TableOfPurchase.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("TableOfPurchasePartner") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Partner) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Partner);
		OpenForm(GetMetadataFullName(CurrentData.Partner) + ".ObjectForm", OpenParameters);
	EndIf;
	
	If Upper(Field.Name) = Upper("TableOfPurchaseAgreement") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.Agreement) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Agreement);
		OpenForm(GetMetadataFullName(CurrentData.Agreement) + ".ObjectForm", OpenParameters);
	EndIf;
	
	If Upper(Field.Name) = Upper("TableOfPurchasePriceType") Then
		StandardProcessing = False;
		If Not ValueIsFilled(CurrentData.PriceType) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.PriceType);
		OpenForm(GetMetadataFullName(CurrentData.PriceType) + ".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtServerNoContext
Function GetMetadataFullName(Ref)
	Return Ref.Metadata().FullName();
EndFunction

&AtClient
Procedure TableOfBalanceQuantityOnChange(Item)
	Update_TotalQuantity();
EndProcedure

&AtClient
Procedure TableOfPurchaseQuantityOnChange(Item)
	Update_TotalQuantity();
EndProcedure

&AtClient
Procedure Update_TotalQuantity()
	ThisObject.SelectedQuantity = 0;
	TransferQuantity = 0;
	PurchaseQuantity = 0;
	For Each Row In ThisObject.TableOfBalance Do
		ThisObject.SelectedQuantity = ThisObject.SelectedQuantity + Row.Quantity;
		TransferQuantity = TransferQuantity + Row.Quantity;
	EndDo;
	For Each Row In ThisObject.TableOfPurchase Do
		ThisObject.SelectedQuantity = ThisObject.SelectedQuantity + Row.Quantity;
		PurchaseQuantity = PurchaseQuantity + Row.Quantity;
	EndDo;
	ThisObject.LackQuantity = ThisObject.TotalQuantity - ThisObject.SelectedQuantity;
	
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		Row.Transfer = 0;
		Row.Purchase = 0;
	EndDo;
	
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If TransferQuantity <= 0 Then
			Break;
		EndIf;
		Row.Transfer = Min(TransferQuantity, Row.Quantity);
		TransferQuantity = TransferQuantity - Row.Transfer;
	EndDo;
	
	For Each Row In ThisObject.TableOfInternalSupplyRequest Do
		If PurchaseQuantity <= 0 Then
			Break;
		EndIf;
		Row.Purchase = Min(PurchaseQuantity, Row.Quantity - Row.Transfer);
		PurchaseQuantity = PurchaseQuantity - Row.Purchase;
	EndDo;
EndProcedure

&AtClient
Procedure TableOfBalanceBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfBalanceBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfPurchaseBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure TableOfPurchaseBeforeDeleteRow(Item, Cancel)
	Cancel = True;
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
	Close(CreatedDocuments);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close(Undefined);
EndProcedure

&AtServer
Function CreateDocumentsAtServer()
	CreatedDocuments = New Structure();
	
	DataTable = CollectDataFor_InventoryTransferOrder();
	If DataTable.Count() Then
		ArrayOfTransferOrders = Create_InventoryTransferOrder(DataTable);
		CreatedDocuments.Insert("TransferOrders", ArrayOfTransferOrders);
	Else
		CreatedDocuments.Insert("TransferOrders", New Array());
	EndIf;
	
	DataTable = CollectDataFor_PurchaseOrder();
	If DataTable.Count() Then
		ArrayOfPurchaseOrders = Create_PurchaseOrder(DataTable);
		CreatedDocuments.Insert("PurchaseOrders", ArrayOfPurchaseOrders);
	Else
		CreatedDocuments.Insert("PurchaseOrders", New Array());
	EndIf;
	
	Return CreatedDocuments;
EndFunction

&AtClient
Procedure DateOfRelevanceOnChange(Item)
	Update_AllTables();
EndProcedure

&AtClient
Procedure Refresh(Command)
	Update_AllTables();
EndProcedure

&AtServer
Function CollectDataFor_InventoryTransferOrder()
	DataTable = New ValueTable();
	DataTable.Columns.Add("StoreSender");
	DataTable.Columns.Add("InternalSupplyRequest");
	DataTable.Columns.Add("RowKey");
	DataTable.Columns.Add("Quantity");
	
	SupplyRequests = ThisObject.TableOfInternalSupplyRequest.Unload();
	
	For Each Row In ThisObject.TableOfBalance Do
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
			RowSupplyRequest.Transfer = RowSupplyRequest.Transfer - NewRow.Quantity;
			NeededQuantity =  NeededQuantity - NewRow.Quantity;
		EndDo;
	EndDo;
	
	DataTable.GroupBy("StoreSender, InternalSupplyRequest, RowKey", "Quantity");
	
	For Each Row In ThisObject.TableOfBalance Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		
		ArrayOfRows = DataTable.FindRows(New Structure("StoreSender", Row.Store));
		TotalQ = 0;
		For Each ItemOfRow In ArrayOfRows Do
			TotalQ = TotalQ + ItemOfRow.Quantity;
		EndDo;
		If TotalQ < Row.Quantity Then
			NewRow = DataTable.Add();
			NewRow.StoreSender = Row.Store;
			NewRow.RowKey = New UUID();
			NewRow.Quantity = Row.Quantity - TotalQ;
		EndIf;
	EndDo;
	
	Return DataTable;
EndFunction

&AtServer
Function CollectDataFor_PurchaseOrder()
	DataTable = New ValueTable();
	DataTable.Columns.Add("Partner");
	DataTable.Columns.Add("Agreement");
	DataTable.Columns.Add("PriceType");
	DataTable.Columns.Add("Price");
	DataTable.Columns.Add("DeliveryDate");
	DataTable.Columns.Add("InternalSupplyRequest");
	DataTable.Columns.Add("RowKey");
	DataTable.Columns.Add("Quantity");
	
	SupplyRequests = ThisObject.TableOfInternalSupplyRequest.Unload();
	
	For Each Row In ThisObject.TableOfPurchase Do
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
			NewRow.Quantity = Min(NeededQuantity, RowSupplyRequest.Purchase);
			RowSupplyRequest.Purchase = RowSupplyRequest.Purchase - NewRow.Quantity;
			NeededQuantity =  NeededQuantity - NewRow.Quantity;
		EndDo;
	EndDo;
	
	DataTable.GroupBy("Partner, Agreement, PriceType, Price, DeliveryDate, InternalSupplyRequest, RowKey", "Quantity");
	
	For Each Row In ThisObject.TableOfPurchase Do
		If Not ValueIsFilled(Row.Quantity) Then
			Continue;
		EndIf;
		Filter = New Structure();
		FIlter.Insert("Partner", Row.Partner);
		FIlter.Insert("Agreement", Row.Agreement);
		FIlter.Insert("PriceType", Row.PriceType);
		FIlter.Insert("Price", Row.Price);
		FIlter.Insert("DeliveryDate", Row.DeliveryDate);
		
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
			NewRow.RowKey = New UUID();
			NewRow.Quantity = Row.Quantity - TotalQ;
		EndIf;
	EndDo;
	
	Return DataTable;
EndFunction

&AtServer
Function Create_PurchaseOrder(DataTable)
	
	ArrayOfPurchaseOrders = New Array();
	
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
			NewRow.ItemKey = ThisObject.ItemKey;
			NewRow.Store = ThisObject.Store;
			
			UnitInfo = GetItemInfo.ItemUnitInfo(NewRow.ItemKey);
			NewRow.Unit = UnitInfo.Unit;
			
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

&AtServer
Function Create_InventoryTransferOrder(DataTable)
	
	ArrayOfTransferOrders = New Array();
	
	DataTableFilter = DataTable.Copy();
	DataTableFilter.GroupBy("StoreSender");
	For Each RowFilter In DataTableFilter Do
		
		NewTransferOrder = Documents.InventoryTransferOrder.CreateDocument();
		NewTransferOrder.Date = CurrentSessionDate();
		NewTransferOrder.Company = ThisObject.Company;
		NewTransferOrder.StoreReceiver = ThisObject.Store;
		NewTransferOrder.StoreSender = RowFilter.StoreSender;
		
		Filter = New Structure();
		Filter.Insert("StoreSender", RowFilter.StoreSender);
		ArrayOfRows = DataTable.FindRows(Filter);
		For Each ItemOfRow In ArrayOfRows Do
			NewRow = NewTransferOrder.ItemList.Add();
			NewRow.Key = ItemOfRow.RowKey;
			NewRow.ItemKey = ThisObject.ItemKey;
			
			UnitInfo = GetItemInfo.ItemUnitInfo(NewRow.ItemKey);
			NewRow.Unit = UnitInfo.Unit;
			
			NewRow.Quantity = ItemOfRow.Quantity;
			NewRow.InternalSupplyRequest = ItemOfRow.InternalSupplyRequest;
		EndDo;
		
		NewTransferOrder.Fill(Undefined);
		NewTransferOrder.Write(DocumentWriteMode.Write);	
		ArrayOfTransferOrders.Add(NewTransferOrder.Ref);
	EndDo;
	Return ArrayOfTransferOrders;
EndFunction

&AtServer
Procedure Update_TableOfBalance()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	StockReservationBalance.Store,
	|	StockReservationBalance.QuantityBalance AS Balance
	|FROM
	|	AccumulationRegister.StockReservation.Balance(ENDOFPERIOD(&DateOfRelevance, day), ItemKey = &ItemKey
	|	AND Store <> &Store) AS StockReservationBalance";
	Query.SetParameter("Store", ThisObject.Store);
	Query.SetParameter("DateOfRelevance", ThisObject.DateOfRelevance);
	Query.SetParameter("ItemKey", ThisObject.ItemKey);
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.TableOfBalance.Load(QueryTable);
EndProcedure

&AtServer
Procedure Update_TableOfPurchase()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Agreements.Partner AS Partner,
	|	Agreements.PriceType AS PriceType,
	|	Agreements.Ref AS Agreement,
	|	&ItemKey AS ItemKey
	|INTO tmp
	|FROM
	|	Catalog.Agreements AS Agreements
	|WHERE
	|	(Agreements.StartUsing <= ENDOFPERIOD(&Period, DAY)
	|	AND Agreements.EndOfUse >= ENDOFPERIOD(&Period, DAY)
	|	OR Agreements.EndOfUse = DATETIME(1, 1, 1))
	|	AND Agreements.Partner.Vendor
	|	AND Agreements.Type = VALUE(Enum.AgreementTypes.Vendor)
	|GROUP BY
	|	Agreements.Partner,
	|	Agreements.PriceType,
	|	Agreements.Ref
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.Ref AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	tmp.PriceType AS PriceType,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement
	|INTO t_ItemKeys
	|FROM
	|	tmp AS tmp
	|		INNER JOIN Catalog.ItemKeys AS ItemKeys
	|		ON tmp.ItemKey = ItemKeys.Ref
	|		AND ItemKeys.Specification = VALUE(Catalog.Specifications.EmptyRef)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.PriceType AS PriceType,
	|	ItemKeys.Partner AS Partner,
	|	ItemKeys.Agreement AS Agreement,
	|	PricesByItemKeysSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByItemKeysSliceLast.Price, 0) AS Price
	|INTO t_PricesByItemKeys
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN InformationRegister.PricesByItemKeys.SliceLast(&Period, (PriceType, ItemKey) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.ItemKey
	|			FROM
	|				tmp AS tmp)) AS PricesByItemKeysSliceLast
	|		ON ItemKeys.ItemKey = PricesByItemKeysSliceLast.ItemKey
	|		AND ItemKeys.PriceType = PricesByItemKeysSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Partner AS Partner,
	|	tmp2.Agreement AS Agreement,
	|	tmp2.PriceType AS PriceType
	|INTO tmp2
	|FROM
	|	t_PricesByItemKeys AS tmp2
	|WHERE
	|	tmp2.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceKeys.Ref AS PriceKey,
	|	tmp2.ItemKey AS ItemKey,
	|	tmp2.AffectPricingMD5 AS AffectPricingMD5,
	|	tmp2.Item AS Item,
	|	tmp2.Partner AS Partner,
	|	tmp2.Agreement AS Agreement,
	|	tmp2.PriceType AS PriceType
	|INTO t_PriceKeys
	|FROM
	|	tmp2 AS tmp2
	|		LEFT JOIN Catalog.PriceKeys AS PriceKeys
	|		ON tmp2.AffectPricingMD5 = PriceKeys.AffectPricingMD5
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PriceKeys.ItemKey AS ItemKey,
	|	PriceKeys.Item AS Item,
	|	PriceKeys.Partner AS Partner,
	|	PriceKeys.Agreement AS Agreement,
	|	PriceKeys.PriceType AS PriceType,
	|	PricesByPropertiesSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByPropertiesSliceLast.Price, 0) AS Price
	|INTO t_PricesByProperties
	|FROM
	|	t_PriceKeys AS PriceKeys
	|		LEFT JOIN InformationRegister.PricesByProperties.SliceLast(&Period, (PriceType, PriceKey) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.PriceKey
	|			FROM
	|				t_PriceKeys AS tmp)) AS PricesByPropertiesSliceLast
	|		ON PriceKeys.PriceKey = PricesByPropertiesSliceLast.PriceKey
	|		AND PriceKeys.PriceType = PricesByPropertiesSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Partner AS Partner,
	|	tmp3.Agreement AS Agreement,
	|	tmp3.PriceType AS PriceType
	|INTO tmp3
	|FROM
	|	t_PricesByProperties AS tmp3
	|WHERE
	|	tmp3.Price = 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp3.ItemKey AS ItemKey,
	|	tmp3.Item AS Item,
	|	tmp3.Partner AS Partner,
	|	tmp3.Agreement AS Agreement,
	|	tmp3.PriceType AS PriceType,
	|	PricesByItemsSliceLast.Period AS DateOfRelevance,
	|	ISNULL(PricesByItemsSliceLast.Price, 0) AS Price
	|INTO t_PricesByItems
	|FROM
	|	tmp3 AS tmp3
	|		LEFT JOIN InformationRegister.PricesByItems.SliceLast(&Period, (PriceType, Item) IN
	|			(SELECT
	|				tmp.PriceType,
	|				tmp.Item
	|			FROM
	|				tmp3 AS tmp)) AS PricesByItemsSliceLast
	|		ON tmp3.Item = PricesByItemsSliceLast.Item
	|		AND tmp3.PriceType = PricesByItemsSliceLast.PriceType
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT DISTINCT
	|	ItemKeys.ItemKey AS ItemKey,
	|	ItemKeys.Specification AS Specification,
	|	ItemKeys.AffectPricingMD5 AS AffectPricingMD5,
	|	ItemKeys.Item AS Item,
	|	ItemKeys.Partner AS Partner,
	|	ItemKeys.Agreement AS Agreement,
	|	DATEADD(&Period, DAY, ItemKeys.Agreement.DaysBeforeDelivery) AS DeliveryDate,
	|	ItemKeys.PriceType AS PriceType,
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByItemKeys.DateOfRelevance, DATETIME(1, 1, 1))
	|		WHEN ISNULL(t_PricesByProperties.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByProperties.DateOfRelevance, DATETIME(1, 1, 1))
	|		WHEN ISNULL(t_PricesByItems.DateOfRelevance, DATETIME(1, 1, 1)) <> DATETIME(1, 1, 1)
	|			THEN ISNULL(t_PricesByItems.DateOfRelevance, DATETIME(1, 1, 1))
	|	END AS DateOfRelevance,
	|	ISNULL(t_PricesByItemKeys.Price, 0) AS PriceByItemKeys,
	|	ISNULL(t_PricesByProperties.Price, 0) AS PriceByProperties,
	|	ISNULL(t_PricesByItems.Price, 0) AS PriceByItems,
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItemKeys.Price, 0)
	|		WHEN ISNULL(t_PricesByProperties.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByProperties.Price, 0)
	|		WHEN ISNULL(t_PricesByItems.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItems.Price, 0)
	|	END AS Price
	|FROM
	|	t_ItemKeys AS ItemKeys
	|		LEFT JOIN t_PricesByItemKeys AS t_PricesByItemKeys
	|		ON ItemKeys.ItemKey = t_PricesByItemKeys.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItemKeys.PriceType
	|		LEFT JOIN t_PricesByProperties AS t_PricesByProperties
	|		ON ItemKeys.ItemKey = t_PricesByProperties.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByProperties.PriceType
	|		LEFT JOIN t_PricesByItems AS t_PricesByItems
	|		ON ItemKeys.ItemKey = t_PricesByItems.ItemKey
	|		AND ItemKeys.PriceType = t_PricesByItems.PriceType
	|WHERE
	|	CASE
	|		WHEN ISNULL(t_PricesByItemKeys.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItemKeys.Price, 0)
	|		WHEN ISNULL(t_PricesByProperties.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByProperties.Price, 0)
	|		WHEN ISNULL(t_PricesByItems.Price, 0) <> 0
	|			THEN ISNULL(t_PricesByItems.Price, 0)
	|	END <> 0";
	
	Query.SetParameter("ItemKey", ThisObject.ItemKey);
	Query.SetParameter("Period", EndOfDay(ThisObject.DateOfRelevance));
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	ThisObject.TableOfPurchase.Load(QueryTable);
EndProcedure
