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
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	If FOServer.IsUseCommissionTrading() Then
		AttributesArray.Add("TransactionType");
	EndIf;
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

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

Function GetSalesOrderForClosing(SalesOrder) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	""SalesOrder"" AS BasedOn,
	|	SalesOrder.Ref AS SalesOrder,
	|	SalesOrder.Agreement AS Agreement,
	|	SalesOrder.Company AS Company,
	|	SalesOrder.LegalName AS LegalName,
	|	SalesOrder.Partner AS Partner,
	|	SalesOrder.Branch AS Branch,
	|	SalesOrder.TransactionType AS TransactionType
	|FROM
	|	Document.SalesOrder AS SalesOrder
	|WHERE
	|	SalesOrder.Ref = &SalesOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Ref AS Ref,
	|	ItemList.Key AS SalesOrderKey,
	|	ItemList.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item.Unit AS Unit,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.ProcurementMethod AS ProcurementMethod,
	|	ItemList.CancelReason AS CancelReason,
	|	SalesOrdersInvoiceClosing.QuantityBalance > 0 AS Cancel,
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN SalesOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.QuantityBalance
	|	END AS Quantity,
	|	ItemList.SalesPerson,
	|	ItemList.IsService
	|FROM
	|	Document.SalesOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(, Order = &SalesOrder) AS
	|			SalesOrdersInvoiceClosing
	|		ON ItemList.Key = SalesOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &SalesOrder";
	Query.SetParameter("SalesOrder", SalesOrder);
	QueryResults = Query.ExecuteBatch();
	
	Header              = QueryResults[0].Unload()[0];
	Table_ItemList      = QueryResults[1].Unload();
	
	// ItemList
	ArrayOfColumns = New Array();
	For Each Column In Table_ItemList.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	Columns_ItemList = StrConcat(ArrayOfColumns, ",");
		
	FillingValues = New Structure("BasedOn,
								  |SalesOrder,
								  |Agreement, 
								  |Company, 
								  |LegalName, 
								  |Partner, 
								  |Branch, 
								  |TransactionType");

	FillingValues.Insert("ItemList", New Array());
	FillPropertyValues(FillingValues, Header);
	
	For Each Row In Table_ItemList Do
		NewRow_ItemList = New Structure(Columns_ItemList);
		FillPropertyValues(NewRow_ItemList, Row);
		FillingValues.ItemList.Add(NewRow_ItemList);
	EndDo;
	
	Return FillingValues;
EndFunction

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

Function GetPurchaseOrderForClosing(PurchaseOrder) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	""PurchaseOrder"" AS BasedOn,
	|	PurchaseOrder.Ref AS PurchaseOrder,
	|	PurchaseOrder.Agreement AS Agreement,
	|	PurchaseOrder.Company AS Company,
	|	PurchaseOrder.LegalName AS LegalName,
	|	PurchaseOrder.Partner AS Partner,
	|	PurchaseOrder.Branch AS Branch,
	|	PurchaseOrder.TransactionType AS TransactionType
	|FROM
	|	Document.PurchaseOrder AS PurchaseOrder
	|WHERE
	|	PurchaseOrder.Ref = &PurchaseOrder
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Ref AS Ref,
	|	ItemList.Key AS PurchaseOrderKey,
	|	ItemList.Item AS Item,
	|	ItemList.ItemKey AS ItemKey,
	|	ItemList.Store AS Store,
	|	ItemList.ItemKey.Item.Unit AS Unit,
	|	ItemList.DeliveryDate AS DeliveryDate,
	|	ItemList.CancelReason AS CancelReason,
	|	PurchaseOrdersInvoiceClosing.QuantityBalance > 0 AS Cancel,
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.QuantityBalance
	|	END AS Quantity,
	|	ItemList.IsService
	|FROM
	|	Document.PurchaseOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing.Balance(, Order = &PurchaseOrder) AS
	|			PurchaseOrdersInvoiceClosing
	|		ON ItemList.Key = PurchaseOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &PurchaseOrder";
	
	Query.SetParameter("PurchaseOrder", PurchaseOrder);
	
	QueryResults = Query.ExecuteBatch();
	
	Header              = QueryResults[0].Unload()[0];
	Table_ItemList      = QueryResults[1].Unload();
	
	// ItemList
	ArrayOfColumns = New Array();
	For Each Column In Table_ItemList.Columns Do
		ArrayOfColumns.Add(Column.Name);
	EndDo;
	Columns_ItemList = StrConcat(ArrayOfColumns, ",");
		
	FillingValues = New Structure("BasedOn,
								  |PurchaseOrder,
								  |Agreement, 
								  |Company, 
								  |LegalName, 
								  |Partner, 
								  |Branch, 
								  |TransactionType");

	FillingValues.Insert("ItemList", New Array());
	FillPropertyValues(FillingValues, Header);
	
	For Each Row In Table_ItemList Do
		NewRow_ItemList = New Structure(Columns_ItemList);
		FillPropertyValues(NewRow_ItemList, Row);
		FillingValues.ItemList.Add(NewRow_ItemList);
	EndDo;
	
	Return FillingValues;
EndFunction

#EndRegion
