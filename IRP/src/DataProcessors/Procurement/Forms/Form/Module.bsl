
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Company = GetUserSetting("Procurement_Company");
	ThisObject.Store = GetUserSetting("Procurement_Store");
EndProcedure

&AtServer
Function GetUserSetting(SettingName)
	UserSettingFilterParameters = New Structure();
	UserSettingFilterParameters.Insert("AttributeName", SettingName);
	UserSettings = UserSettingsServer.GetUserSettings(Undefined, UserSettingFilterParameters);

	UserSettingsValue = Undefined;
	If UserSettings.Count() Then
		UserSettingsValue = UserSettings[0].Value;
	EndIf;
	Return UserSettingsValue;
EndFunction

&AtClient
Procedure Refresh(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;
	RefreshAtServer();
EndProcedure

&AtServer
Procedure RefreshAtServer()
	
	DeleteColumns_Analisys();
	DeleteColumns_Details();
	
	ThisObject.TableOfColumns.Clear();
	ThisObject.Analisys.Clear();
	ThisObject.Details.GetItems().Clear();
	
	SecondInPeriod = 60 * 60 * 24 * Number(ThisObject.Periodicity);
	tmpDate = BegOfDay(ThisObject.Period.StartDate);
	While BegOfDay(tmpDate) <= BegOfDay(ThisObject.Period.EndDate) Do
		NewRow = ThisObject.TableOfColumns.Add();
		NewRow.StartDate = tmpDate;
		tmpDate = BegOfDay(tmpDate) + SecondInPeriod;
		NewRow.EndDate = 
		?(BegOfDay(tmpDate) > BegOfDay(ThisObject.Period.EndDate), 
		EndOfDay(ThisObject.Period.EndDate), tmpDate - 1);
		
		NewRow.Name ="_" + StrReplace(String(New UUID()), "-" , "_");
		NewRow.Title = Format(NewRow.StartDate,"DF=d.M.yy;") 
		+ " - "
		+ Format(NewRow.EndDate,"DF=d.M.yy;");
	EndDo;
	
	CreateColumns_Analisys();
	CreateColumns_Details();
		
	TableOfSupplyRequests = 
	GetTableOfSupplyRequests(ThisObject.Store, ThisObject.Period.StartDate, ThisObject.Period.EndDate);
		
	For Each Row In TableOfSupplyRequests Do
		NewRowAnalisys = ThisObject.Analisys.Add();
		NewRowAnalisys.Picture = 3;
		NewRowAnalisys.Item = Row.Item;
		NewRowAnalisys.ItemKey = Row.ItemKey;
		NewRowAnalisys.TotalProcurement = Row.QuantityProcurement;
		NewRowAnalisys.Ordered  = Row.QuantityOrdered;
		NewRowAnalisys.Shortage = Row.QuantityShortage;
		NewRowAnalisys.Expired  = Row.QuantityExpired;
		
		For Each RowColumnInfo In TableOfColumns Do
			NewRowAnalisys[RowColumnInfo.Name] = 
			GetProcurementByItemKey(ThisObject.Store, Row.ItemKey, RowColumnInfo.StartDate, RowColumnInfo.EndDate);			
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure DetailsSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.Details.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("DetailsDocument") Then
		If Not ValueIsFilled(CurrentData.Document) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Document);
		OpenForm(GetMatadataFullName(CurrentData.Document)+".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtClient
Procedure AnalisysSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.Analisys.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If Upper(Field.Name) = Upper("AnalisysItem") Then
		If Not ValueIsFilled(CurrentData.Item) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.Item);
		OpenForm(GetMatadataFullName(CurrentData.Item)+".ObjectForm", OpenParameters);
	EndIf;
	
	If Upper(Field.Name) = Upper("AnalisysItemKey") Then
		If Not ValueIsFilled(CurrentData.ItemKey) Then
			Return;
		EndIf;
		OpenParameters = New Structure();
		OpenParameters.Insert("Key", CurrentData.ItemKey);
		OpenForm(GetMatadataFullName(CurrentData.ItemKey)+".ObjectForm", OpenParameters);
	EndIf;
EndProcedure

&AtServerNoContext
Function GetMatadataFullName(Ref)
	Return Ref.Metadata().FullName();
EndFunction

&AtClient
Procedure AnalyzeOrders(Command)
	CurrentData = Items.Analisys.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("Item", CurrentData.Item);
	AdditionalParameters.Insert("ItemKey", CurrentData.ItemKey);
	AdditionalParameters.Insert("Store", ThisObject.Store);
	AdditionalParameters.Insert("Company", ThisObject.Company);
	
	OpenParameters = New Structure();
	OpenParameters.Insert("ArrayOfSupplyRequest", GetArrayOfSupplyRequest());
	
	Notify = New NotifyDescription("SelectInternalSupplyRequestEnd", ThisObject, AdditionalParameters);
	OpenForm("DataProcessor.Procurement.Form.FormSelectInternalSupplyRequest",
	OpenParameters, ThisObject,,,,Notify,FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient 
Procedure SelectInternalSupplyRequestEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	OpenParameters = New Structure();
	OpenParameters.Insert("Store", AdditionalParameters.Store);
	OpenParameters.Insert("Company", AdditionalParameters.Company);
	OpenParameters.Insert("Item", AdditionalParameters.Item);
	OpenParameters.Insert("ItemKey", AdditionalParameters.ItemKey);
	OpenParameters.Insert("ArrayOfSupplyRequest", Result);
	
	Notify = New NotifyDescription("CreateOrdersEnd", ThisObject);
	OpenForm("DataProcessor.Procurement.Form.FormCreateOrders",
	OpenParameters, ThisObject,,,,Notify,FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtClient 
Procedure CreateOrdersEnd(Result, AdditionalParameters) Export
	If Result = Undefined Then
		Return;
	EndIf;
	For Each Doc In Result.PurchaseOrders Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_020, Doc));
	EndDo;
	
	For Each Doc In Result.TransferOrders Do
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_020, Doc));
	EndDo;
EndProcedure

&AtServer
Function GetArrayOfSupplyRequest()
	ArrayOfSupplyRequest = New Array();
	For Each Row In ThisObject.Details.GetItems() Do
		If Not ValueIsFilled(Row.TotalQuantity) Then
			Continue;
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("InternalSupplyRequest", Row.Document);
		NewRow.Insert("RowKey", Row.RowKey);
		NewRow.Insert("Quantity", Row.TotalQuantity);
		NewRow.Insert("ProcurementDate", ?(ValueIsFilled(Row.Document.ProcurementDate)
		,Row.Document.ProcurementDate, Row.Document.Date));
		ArrayOfSupplyRequest.Add(NewRow);
	EndDo;
	Return ArrayOfSupplyRequest;
EndFunction

&AtClient
Procedure AnalisysOnActivateRow(Item)
	CurrentData = Items.Analisys.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Fill_Details(CurrentData.ItemKey);
EndProcedure
	
&AtServer
Procedure DeleteColumns_Analisys()
	ArrayOfColumns = New Array();
	
	For Each Row In ThisObject.TableOfColumns Do
		ArrayOfColumns.Add("Analisys." + Row.Name);
		Items.Delete(Items["Analisys"+Row.Name]);
	EndDo;
	
	If ArrayOfColumns.Count() Then
		ChangeAttributes(,ArrayOfColumns);
	EndIf;
EndProcedure

&AtServer
Procedure CreateColumns_Analisys()
	TypeQuantity = Metadata.DefinedTypes.typeQuantity.Type;
	ArrayOfColumns = New Array();
	For Each Row In ThisObject.TableOfColumns Do		
		ArrayOfColumns.Add(New FormAttribute(Row.Name, TypeQuantity ,"Analisys" ,Row.Title));
	EndDo;
	
	ChangeAttributes(ArrayOfColumns);
	
	For Each Row In ThisObject.TableOfColumns Do
		NewItem_Analisys = Items.Add("Analisys"+Row.Name, Type("FormField"), Items.Analisys);       
		NewItem_Analisys.Type = FormFieldType.InputField;
		NewItem_Analisys.DataPath = "Analisys." + Row.Name;
		NewItem_Analisys.ReadOnly = True;
	EndDo;
EndProcedure

&AtServer
Procedure CreateColumns_Details()
	TypeQuantity = Metadata.DefinedTypes.typeQuantity.Type;
	ArrayOfColumns = New Array();
	For Each Row In ThisObject.TableOfColumns Do		
		ArrayOfColumns.Add(New FormAttribute(Row.Name, TypeQuantity ,"Details" ,Row.Title));
	EndDo;
	
	ChangeAttributes(ArrayOfColumns);
	
	For Each Row In ThisObject.TableOfColumns Do
		NewItem_Details = Items.Add("Details"+Row.Name, Type("FormField"), Items.Details);       
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
		Items.Delete(Items["Details"+Row.Name]);
	EndDo;
	
	If ArrayOfColumns.Count() Then
		ChangeAttributes(,ArrayOfColumns);
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
				NewRowDetails.RowKey = New UUID(ProcurementRecorderSelection.RowKey);
				
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
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmpOrderBalance.Store AS Store,
	|	tmpOrderBalance.ItemKey AS ItemKey,
	|	tmpOrderBalance.Item AS Item,
	|	tmpOrderBalance.QuantityProcurement AS QuantityProcurement,
	|	tmpOrderBalance.QuantityOrdered AS QuantityOrdered,
	|	tmpOrderBalance.QuantityProcurement - tmpOrderBalance.QuantityOrdered -
	|		ISNULL(StockReservationBalance.QuantityBalance, 0) AS QuantityShortage,
	|	OrderBalanceBalance.QuantityBalance AS QuantityExpired
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
	|		AND tmpOrderBalance.ItemKey = OrderBalanceBalance.ItemKey";
	Query.SetParameter("Store", Store);
	Query.SetParameter("StartDate", StartDate);
	Query.SetParameter("EndDate", EndDate);	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	Return QueryTable;
Endfunction

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




