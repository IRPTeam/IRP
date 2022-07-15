#Region FROM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
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
	|	""SalesOrder"" AS BasedOn,
	|	TRUE AS CloseOrder,
	|	SalesOrder.Ref AS SalesOrder,
	|	SalesOrder.Agreement AS Agreement,
	|	SalesOrder.Company AS Company,
	|	SalesOrder.Currency AS Currency,
	|	SalesOrder.DateOfShipment AS DateOfShipment,
	|	SalesOrder.LegalName AS LegalName,
	|	SalesOrder.ManagerSegment AS ManagerSegment,
	|	SalesOrder.Partner AS Partner,
	|	SalesOrder.PriceIncludeTax AS PriceIncludeTax,
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
	|	ItemList.Item AS Item,
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
	|	ItemList.OffersAmount AS OffersAmount,
	|	ItemList.SalesPerson
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
	|FROM
	|	Document.SalesOrder.TaxList AS SalesOrderTaxList
	|WHERE
	|	FALSE";
	Query.SetParameter("SalesOrder", SalesOrder);
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
								  |SalesOrder,
								  |Agreement, 
								  |Company, 
								  |Currency, 
								  |DateOfShipment, 
								  |LegalName, 
								  |ManagerSegment, 
								  |Partner, 
								  |PriceIncludeTax, 
								  |Status, 
								  |UseItemsShipmentScheduling, 
								  |Author, 
								  |Branch, 
								  |Description");
	
	FillingValues.Insert("ItemList"      , New Array());
	FillingValues.Insert("TaxList"       , New Array());
	FillingValues.Insert("SpecialOffers" , New Array());
	FillPropertyValues(FillingValues, Header);
	
	For Each Row In Table_ItemList Do
		ItemRowInSO = SalesOrder.ItemList.FindRows(New Structure("Key", Row.Key))[0];
		QuantityPart = Row.QuantityInBaseUnit / ItemRowInSO.QuantityInBaseUnit;

		TaxRowInSO = SalesOrder.TaxList.FindRows(New Structure("Key", Row.Key));
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
		
		SpecialOffersRowInSO = SalesOrder.SpecialOffers.FindRows(New Structure("Key", Row.Key));
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