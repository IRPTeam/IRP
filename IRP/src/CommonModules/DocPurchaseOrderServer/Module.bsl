#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
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
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
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
	|	""PurchaseOrder"" AS BasedOn,
	|	TRUE AS CloseOrder,
	|	PurchaseOrder.Ref AS PurchaseOrder,
	|	PurchaseOrder.Agreement AS Agreement,
	|	PurchaseOrder.Company AS Company,
	|	PurchaseOrder.Currency AS Currency,
	|	PurchaseOrder.LegalName AS LegalName,
	|	PurchaseOrder.Partner AS Partner,
	|	PurchaseOrder.PriceIncludeTax AS PriceIncludeTax,
	|	PurchaseOrder.Status AS Status,
	|	PurchaseOrder.Author AS Author,
	|	PurchaseOrder.Branch AS Branch,
	|	PurchaseOrder.TransactionType AS TransactionType,
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
	|	ItemList.Item AS Item,
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
	|FROM
	|	Document.PurchaseOrder.TaxList AS PurchaseOrderTaxList
	|WHERE
	|	FALSE";
	Query.SetParameter("PurchaseOrder", PurchaseOrder);
	QueryResults = Query.ExecuteBatch();

	Header              = QueryResults[0].Unload()[0];
	Table_ItemList      = QueryResults[1].Unload();
	Table_SpecialOffers = QueryResults[2].Unload();
	Table_TaxList       = QueryResults[3].Unload();
	
	// ItemList
	ArrayOfColumns = New Array();
	For Each Column In Table_ItemList.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	Columns_ItemList = StrConcat(ArrayOfColumns, ",");
	
	// SpecialOffers
	ArrayOfColumns.Clear();
	For Each Column In Table_SpecialOffers.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	Columns_SpecialOffers = StrConcat(ArrayOfColumns, ",");
	
	// TaxList
	ArrayOfColumns.Clear();
	For Each Column In Table_TaxList.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	Columns_TaxList = StrConcat(ArrayOfColumns, ",");
		
	FillingValues = New Structure("BasedOn,
								  |CloseOrder,
								  |PurchaseOrder,
								  |Agreement, 
								  |Company, 
								  |Currency, 
								  |LegalName, 
								  |Partner, 
								  |PriceIncludeTax, 
								  |Status,
								  |Author, 
								  |Branch, 
								  |Description,
								  |TransactionType");
	
	FillingValues.Insert("ItemList"      , New Array());
	FillingValues.Insert("TaxList"       , New Array());
	FillingValues.Insert("SpecialOffers" , New Array());
	FillPropertyValues(FillingValues, Header);

	For Each Row In Table_ItemList Do
		ItemRowInSO = PurchaseOrder.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		QuantityPart = Row.QuantityInBaseUnit / ItemRowInSO.QuantityInBaseUnit;

		TaxRowInSO = PurchaseOrder.TaxList.FindRows(New Structure("Key", Row.Key));
		TaxAmount = 0;
		For Each TaxRow In TaxRowInSO Do
			NewRow_TaxList = New Structure(Columns_TaxList);
			FillPropertyValues(NewRow_TaxList, TaxRow);
			NewRow_TaxList.Amount = TaxRow.Amount * QuantityPart;
			NewRow_TaxList.ManualAmount = TaxRow.ManualAmount * QuantityPart;
			TaxAmount = TaxAmount + NewRow_TaxList.ManualAmount;
			FillingValues.TaxList.Add(NewRow_TaxList);
		EndDo;
		Row.TaxAmount = TaxAmount;
		
		SpecialOffersRowInSO = PurchaseOrder.SpecialOffers.FindRows(New Structure("Key", Row.Key));
		SpecialOffersAmount = 0;
		For Each SpecialOffersRow In SpecialOffersRowInSO Do
			NewRow_SpecialOffers = New Structure(Columns_SpecialOffers);
			FillPropertyValues(NewRow_SpecialOffers, SpecialOffersRow);
			NewRow_SpecialOffers.Amount = SpecialOffersRow.Amount * QuantityPart;
			SpecialOffersAmount = SpecialOffersAmount + NewRow_SpecialOffers.Amount;
			FillingValues.SpecialOffers.Add(NewRow_SpecialOffers);
		EndDo;
		Row.OffersAmount = SpecialOffersAmount;
		
		NewRow_ItemList = New Structure(Columns_ItemList);
		FillPropertyValues(NewRow_ItemList, Row);
		FillingValues.ItemList.Add(NewRow_ItemList);
	EndDo;

	Return FillingValues;
EndFunction

#EndRegion
