#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner    = Object.Partner;
		Form.CurrentAgreement  = Object.Agreement;
		Form.CurrentDate       = Object.Date;
		Form.StoreBeforeChange = Form.Store;

		DocumentsClientServer.FillDefinedData(Object, Form);

		If Not Form.GroupItems.Count() Then
			SetGroupItemsList(Object, Form);
		EndIf;
		DocumentsServer.FillItemList(Object);

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);

		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure OnCreateAtServerMobile(Object, Form, Cancel, StandardProcessing) Export

	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		DocumentsServer.FillItemList(Object);
	EndIf;

EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	DocumentsServer.FillItemList(Object);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	DocumentsServer.FillItemList(Object);

	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function CheckItemList(Object) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	Table.LineNumber As LineNumber,
	|	Table.Store,
	|	Table.ItemKey As ItemKey
	|INTO ItemList
	|FROM
	|	&ItemList AS Table
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Store
	|FROM
	|	ItemList AS ItemList
	|Where
	|	ItemList.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Product)
	|	And
	|	Not ItemList.Store.UseShipmentConfirmation
	|GROUP BY
	|	ItemList.Store";

	Query.SetParameter("ItemList", Object.ItemList.Unload());
	QueryResult = Query.Execute();

	If QueryResult.IsEmpty() Then
		Return "";
	EndIf;

	SelectionDetailRecords = QueryResult.Select();

	Stores = "";
	While SelectionDetailRecords.Next() Do
		If Not Stores = "" Then
			Stores = Stores + ", ";
		EndIf;

		Stores = Stores + String(SelectionDetailRecords.Store);
	EndDo;

	Return StrTemplate(R().Error_064, Stores);
EndFunction

Function GetItemRowType(Item) Export
	Return Item.ItemType.Type;
EndFunction

Procedure StoreOnChange(TempStructure) Export
	For Each Row In TempStructure.Object.ItemList Do
		Row.Store = TempStructure.Store;
	EndDo;
EndProcedure

Function GetStoresArray(Val Object) Export
	ReturnValue = New Array();
	TableOfStore = Object.ItemList.Unload( , "Store");
	TableOfStore.GroupBy("Store");
	ReturnValue = TableOfStore.UnloadColumn("Store");
	Return ReturnValue;
EndFunction

Function GetActualStore(Object) Export
	ReturnValue = Catalogs.Stores.EmptyRef();
	If Object.ItemList.Count() = 1 Then
		ReturnValue = Object.AgreementInfo.Store;
	Else
		RowCount = Object.ItemList.Count();
		PreviousRow = Object.ItemList.Get(RowCount - 2);
		ReturnValue = PreviousRow.Store;
	EndIf;
	Return ReturnValue;
EndFunction

#Region ListFormEvents

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region ChoiceFormEvents

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region SalesOrderClosing

Function GetLastSalesOrderClosingBySalesOrder(SalesOrder) Export

	SalesOrderClosing = Documents.SalesOrderClosing.EmptyRef();

	Query = New Query();
	Query.Text =
	"SELECT
	|	SalesOrderClosing.Ref
	|FROM
	|	Document.SalesOrderClosing AS SalesOrderClosing
	|WHERE
	|	SalesOrderClosing.Posted
	|	AND SalesOrderClosing.SalesOrder = &SalesOrder";

	Query.SetParameter("SalesOrder", SalesOrder);

	QueryResult = Query.Execute();

	If Not QueryResult.IsEmpty() Then
		SelectionDetailRecords = QueryResult.Select();
		SelectionDetailRecords.Next();
		SalesOrderClosing = SelectionDetailRecords.Ref;
	EndIf;

	Return SalesOrderClosing;

EndFunction

Function GetSalesOrderForClosing(SalesOrder, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	SalesOrder.Agreement AS Agreement,
	|	SalesOrder.Company AS Company,
	|	SalesOrder.Currency AS Currency,
	|	SalesOrder.DateOfShipment AS DateOfShipment,
	|	SalesOrder.LegalName AS LegalName,
	|	SalesOrder.ManagerSegment AS ManagerSegment,
	|	SalesOrder.Partner AS Partner,
	|	SalesOrder.PriceIncludeTax AS PriceIncludeTax,
	|	SalesOrder.ShipmentConfirmationsBeforeSalesInvoice AS ShipmentConfirmationsBeforeSalesInvoice,
	|	SalesOrder.Status AS Status,
	|	SalesOrder.UseItemsShipmentScheduling AS UseItemsShipmentScheduling,
	|	SalesOrder.Author AS Author,
	|	SalesOrder.Branch AS Branch,
	|	SalesOrder.Description AS Description
	|FROM
	|	Document.SalesOrder AS SalesOrder
	|WHERE
	|	SalesOrder.Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Ref AS Ref,
	|	ItemList.LineNumber AS LineNumber,
	|	ItemList.Key AS Key,
	|	ItemList.Cancel AS Cancel1,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.Price AS Price,
	|	ItemList.PriceType AS PriceType,
	|	ItemList.ItemKey.Item.Unit AS Unit,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.ProcurementMethod AS ProcurementMethod,
	|	ItemList.Detail AS Detail,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.RevenueType AS RevenueType,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.CancelReason AS CancelReason,
	|	SalesOrdersInvoiceClosing.QuantityBalance > 0 AS Cancel,
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN SalesOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.QuantityBalance
	|	END AS QuantityInBaseUnit,
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN SalesOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.QuantityBalance
	|	END AS Quantity,
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.AmountBalance > 0
	|			THEN SalesOrdersInvoiceClosing.AmountBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.AmountBalance
	|	END AS TotalAmount,
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.NetAmountBalance > 0
	|			THEN SalesOrdersInvoiceClosing.NetAmountBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.NetAmountBalance
	|	END AS NetAmount,
	|	ItemList.TaxAmount AS TaxAmount,
	|	ItemList.OffersAmount AS OffersAmount
	|INTO ItemList
	|FROM
	|	Document.SalesOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(, Order = &SalesOrder) AS
	|			SalesOrdersInvoiceClosing
	|		ON ItemList.Key = SalesOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesOrderSpecialOffers.Ref AS Ref,
	|	SalesOrderSpecialOffers.LineNumber AS LineNumber,
	|	SalesOrderSpecialOffers.Key AS Key,
	|	SalesOrderSpecialOffers.Offer AS Offer,
	|	SalesOrderSpecialOffers.Amount AS Amount,
	|	SalesOrderSpecialOffers.Percent AS Percent
	|INTO SpecialOffers
	|FROM
	|	Document.SalesOrder.SpecialOffers AS SalesOrderSpecialOffers
	|WHERE
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	SalesOrderTaxList.Ref AS Ref,
	|	SalesOrderTaxList.LineNumber AS LineNumber,
	|	SalesOrderTaxList.Key AS Key,
	|	SalesOrderTaxList.Tax AS Tax,
	|	SalesOrderTaxList.Analytics AS Analytics,
	|	SalesOrderTaxList.TaxRate AS TaxRate,
	|	SalesOrderTaxList.Amount AS Amount,
	|	SalesOrderTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
	|	SalesOrderTaxList.ManualAmount AS ManualAmount
	|INTO TaxList
	|FROM
	|	Document.SalesOrder.TaxList AS SalesOrderTaxList
	|WHERE
	|	FALSE";
	Query.SetParameter("SalesOrder", SalesOrder);
	Query.TempTablesManager = New TempTablesManager();
	QueryResult = Query.Execute();
	SalesOrderInfo = QueryResult.Select();
	SalesOrderInfo.Next();

	Str = New Structure();
	Str.Insert("SalesOrderInfo", SalesOrderInfo);
	StrTables = New Structure();
	For Each Table In Query.TempTablesManager.Tables Do
		StrTables.Insert(Table.FullName, Table.GetData().Unload());
	EndDo;

	For Each Row In StrTables.ItemList Do
		ItemRowInSO = SalesOrder.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		QuantityPart = Row.QuantityInBaseUnit / ItemRowInSO.QuantityInBaseUnit;

		TaxRowInSO = SalesOrder.TaxList.FindRows(New Structure("Key", Row.Key));
		TaxAmount = 0;
		For Each TaxRow In TaxRowInSO Do
			NewTaxRow = StrTables.TaxList.Add();
			FillPropertyValues(NewTaxRow, TaxRow);
			NewTaxRow.Amount = TaxRow.Amount * QuantityPart;
			NewTaxRow.ManualAmount = TaxRow.ManualAmount * QuantityPart;
			TaxAmount = TaxAmount + NewTaxRow.ManualAmount;
		EndDo;
		Row.TaxAmount = TaxAmount;
		SpecialOffersRowInSO = SalesOrder.SpecialOffers.FindRows(New Structure("Key", Row.Key));
		SpecialOffersAmount = 0;
		For Each SpecialOffersRow In SpecialOffersRowInSO Do
			NewSpecialOffers = StrTables.SpecialOffers.Add();
			FillPropertyValues(NewSpecialOffers, SpecialOffersRow);
			NewSpecialOffers.Amount = SpecialOffersRow.Amount * QuantityPart;
			SpecialOffersAmount = SpecialOffersAmount + NewSpecialOffers.Amount;
		EndDo;
		Row.OffersAmount = SpecialOffersAmount;
	EndDo;

	Str.Insert("Tables", StrTables);
	Return Str;

EndFunction

Function GetSalesOrderInfo(SalesOrder, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	SalesOrder.Agreement,
	|	SalesOrder.Company,
	|	SalesOrder.Currency,
	|	SalesOrder.DateOfShipment,
	|	SalesOrder.LegalName,
	|	SalesOrder.ManagerSegment,
	|	SalesOrder.Partner,
	|	SalesOrder.PriceIncludeTax,
	|	SalesOrder.ShipmentConfirmationsBeforeSalesInvoice,
	|	SalesOrder.Status,
	|	SalesOrder.UseItemsShipmentScheduling,
	|	SalesOrder.Author,
	|	SalesOrder.Branch,
	|	SalesOrder.Description,
	|	SalesOrder.DocumentAmount
	|FROM
	|	Document.SalesOrder AS SalesOrder
	|WHERE
	|	SalesOrder.Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT *
	|INTO ItemList
	|FROM
	|	Document.SalesOrder.ItemList
	|WHERE
	|	Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT *
	|INTO SpecialOffers
	|FROM
	|	Document.SalesOrder.SpecialOffers
	|WHERE
	|	Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT *
	|INTO TaxList
	|FROM
	|	Document.SalesOrder.TaxList
	|WHERE
	|	Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT *
	|INTO Currencies
	|FROM
	|	Document.SalesOrder.Currencies
	|WHERE
	|	Ref = &SalesOrder";
	Query.SetParameter("SalesOrder", SalesOrder);
	Query.TempTablesManager = New TempTablesManager();
	QueryResult = Query.Execute();
	SalesOrderInfo = QueryResult.Select();
	SalesOrderInfo.Next();

	Str = New Structure();
	Str.Insert("SalesOrderInfo", SalesOrderInfo);
	StrTables = New Structure();
	For Each Table In Query.TempTablesManager.Tables Do
		StrTables.Insert(Table.FullName, Table.GetData().Unload());
	EndDo;
	Str.Insert("Tables", StrTables);
	Return Str;

EndFunction

#EndRegion