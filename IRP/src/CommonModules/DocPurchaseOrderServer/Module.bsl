#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner    = Object.Partner;
		Form.CurrentAgreement  = Object.Agreement;
		Form.CurrentDate       = Object.Date;
		Form.StoreBeforeChange = Form.Store;

		DocumentsClientServer.FillDefinedData(Object, Form);

		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);

		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;

	DocumentsServer.FillItemList(Object);

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;

	DocumentsServer.FillItemList(Object);

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

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

#Region PurchaseOrderClosing

Function GetLastPurchaseOrderClosingByPurchaseOrder(PurchaseOrder) Export

	PurchaseOrderClosing = Documents.PurchaseOrderClosing.EmptyRef();

	Query = New Query();
	Query.Text =
	"SELECT
	|	PurchaseOrderClosing.Ref
	|FROM
	|	Document.PurchaseOrderClosing AS PurchaseOrderClosing
	|WHERE
	|	PurchaseOrderClosing.Posted
	|	AND PurchaseOrderClosing.PurchaseOrder = &PurchaseOrder";

	Query.SetParameter("PurchaseOrder", PurchaseOrder);

	QueryResult = Query.Execute();

	If Not QueryResult.IsEmpty() Then
		SelectionDetailRecords = QueryResult.Select();
		SelectionDetailRecords.Next();
		PurchaseOrderClosing = SelectionDetailRecords.Ref;
	EndIf;

	Return PurchaseOrderClosing;

EndFunction

Function GetPurchaseOrderForClosing(PurchaseOrder, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	PurchaseOrder.Agreement AS Agreement,
	|	PurchaseOrder.Company AS Company,
	|	PurchaseOrder.Currency AS Currency,
	|	PurchaseOrder.LegalName AS LegalName,
	|	PurchaseOrder.Partner AS Partner,
	|	PurchaseOrder.PriceIncludeTax AS PriceIncludeTax,
	|	PurchaseOrder.Status AS Status,
	|	PurchaseOrder.Author AS Author,
	|	PurchaseOrder.Branch AS Branch,
	|	PurchaseOrder.Description AS Description
	|FROM
	|	Document.PurchaseOrder AS PurchaseOrder
	|WHERE
	|	PurchaseOrder.Ref = &PurchaseOrder
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
	|	ItemList.Detail AS Detail,
	|	ItemList.ProfitLossCenter AS ProfitLossCenter,
	|	ItemList.DontCalculateRow AS DontCalculateRow,
	|	ItemList.CancelReason AS CancelReason,
	|	PurchaseOrdersInvoiceClosing.QuantityBalance > 0 AS Cancel,
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.QuantityBalance
	|	END AS QuantityInBaseUnit,
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.QuantityBalance
	|	END AS Quantity,
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.AmountBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.AmountBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.AmountBalance
	|	END AS TotalAmount,
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.NetAmountBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.NetAmountBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.NetAmountBalance
	|	END AS NetAmount,
	|	ItemList.TaxAmount AS TaxAmount,
	|	ItemList.OffersAmount AS OffersAmount,
	|	ItemList.ExpenseType,
	|	ItemList.SalesOrder,
	|	ItemList.InternalSupplyRequest
	|INTO ItemList
	|FROM
	|	Document.PurchaseOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing.Balance(, Order = &PurchaseOrder) AS
	|			PurchaseOrdersInvoiceClosing
	|		ON ItemList.Key = PurchaseOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &PurchaseOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PurchaseOrderSpecialOffers.Ref AS Ref,
	|	PurchaseOrderSpecialOffers.LineNumber AS LineNumber,
	|	PurchaseOrderSpecialOffers.Key AS Key,
	|	PurchaseOrderSpecialOffers.Offer AS Offer,
	|	PurchaseOrderSpecialOffers.Amount AS Amount,
	|	PurchaseOrderSpecialOffers.Percent AS Percent
	|INTO SpecialOffers
	|FROM
	|	Document.PurchaseOrder.SpecialOffers AS PurchaseOrderSpecialOffers
	|WHERE
	|	FALSE
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	PurchaseOrderTaxList.Ref AS Ref,
	|	PurchaseOrderTaxList.LineNumber AS LineNumber,
	|	PurchaseOrderTaxList.Key AS Key,
	|	PurchaseOrderTaxList.Tax AS Tax,
	|	PurchaseOrderTaxList.Analytics AS Analytics,
	|	PurchaseOrderTaxList.TaxRate AS TaxRate,
	|	PurchaseOrderTaxList.Amount AS Amount,
	|	PurchaseOrderTaxList.IncludeToTotalAmount AS IncludeToTotalAmount,
	|	PurchaseOrderTaxList.ManualAmount AS ManualAmount
	|INTO TaxList
	|FROM
	|	Document.PurchaseOrder.TaxList AS PurchaseOrderTaxList
	|WHERE
	|	FALSE";
	Query.SetParameter("PurchaseOrder", PurchaseOrder);
	Query.TempTablesManager = New TempTablesManager();
	QueryResult = Query.Execute();
	PurchaseOrderInfo = QueryResult.Select();
	PurchaseOrderInfo.Next();

	Str = New Structure();
	Str.Insert("PurchaseOrderInfo", PurchaseOrderInfo);
	StrTables = New Structure();
	For Each Table In Query.TempTablesManager.Tables Do
		StrTables.Insert(Table.FullName, Table.GetData().Unload());
	EndDo;

	For Each Row In StrTables.ItemList Do
		ItemRowInSO = PurchaseOrder.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		QuantityPart = Row.QuantityInBaseUnit / ItemRowInSO.QuantityInBaseUnit;

		TaxRowInSO = PurchaseOrder.TaxList.FindRows(New Structure("Key", Row.Key));
		TaxAmount = 0;
		For Each TaxRow In TaxRowInSO Do
			NewTaxRow = StrTables.TaxList.Add();
			FillPropertyValues(NewTaxRow, TaxRow);
			NewTaxRow.Amount = TaxRow.Amount * QuantityPart;
			NewTaxRow.ManualAmount = TaxRow.ManualAmount * QuantityPart;
			TaxAmount = TaxAmount + NewTaxRow.ManualAmount;
		EndDo;
		Row.TaxAmount = TaxAmount;
		SpecialOffersRowInSO = PurchaseOrder.SpecialOffers.FindRows(New Structure("Key", Row.Key));
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

#EndRegion