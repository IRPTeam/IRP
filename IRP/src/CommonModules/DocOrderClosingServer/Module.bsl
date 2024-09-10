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

Function GetClosingBySalesOrder(SalesOrder) Export
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

Function GetIsClosedSalesOrderInItemList(ArrayOfOrder) Export
	Table = New ValueTable();
	Table.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Table.Columns.Add("DocOrder", New TypeDescription(("DocumentRef.SalesOrder")));
	
	For Each Row In ArrayOfOrder Do
		NewRow = Table.Add();
		NewRow.Key = Row.Key;
		NewRow.DocOrder = Row.DocOrder;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.Key AS Key,
	|	Table.DocOrder AS DocOrder
	|INTO Table
	|FROM
	|	&Table AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Key,
	|	Table.DocOrder
	|FROM
	|	Table AS Table
	|		INNER JOIN Document.SalesOrderClosing AS DocOrderClosing
	|		ON DocOrderClosing.SalesOrder = Table.DocOrder
	|		AND DocOrderClosing.Posted";
	Query.SetParameter("Table", Table);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Array();
	
	While QuerySelection.Next() Do
		Result.Add(QuerySelection.Key);
	EndDo;
	
	Return Result;
EndFunction

Function GetDataFormSalesOrder(SalesOrder, Object = Undefined) Export
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
	|	CASE
	|		WHEN SalesOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN SalesOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * SalesOrdersInvoiceClosing.QuantityBalance
	|	END AS QuantityInBaseUnit,
	|	ItemList.SalesPerson,
	|	ItemList.IsService
	|FROM
	|	Document.SalesOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R2012B_SalesOrdersInvoiceClosing.Balance(&Boundary, Order = &SalesOrder) AS
	|			SalesOrdersInvoiceClosing
	|		ON ItemList.Key = SalesOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &SalesOrder
	|
	|ORDER BY
	|	ItemList.LineNumber";
	Query.SetParameter("SalesOrder", SalesOrder);
	
	Boundary = Undefined;
	If Object <> Undefined Then
		PointInTime = New PointInTime(Object.Date, Object.Ref);
		Boundary = New Boundary(PointInTime, BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Boundary", Boundary);
		
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

Procedure RefreshSalesOrderClosing(Object) Export
	FillingData = GetDataFormSalesOrder(Object.SalesOrder, Object);
	RefreshClosing(Object, FillingData, "SalesOrderKey", 
		"Agreement, Company, LegalName, Partner, SalesOrder, TransactionType");
EndProcedure

#EndRegion

#Region PurchaseOrderClosing

Function GetClosingByPurchaseOrder(PurchaseOrder) Export
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

Function GetIsClosedPurchaseOrderInItemList(ArrayOfOrder) Export
	Table = New ValueTable();
	Table.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
	Table.Columns.Add("DocOrder", New TypeDescription("DocumentRef.PurchaseOrder"));
	
	For Each Row In ArrayOfOrder Do
		NewRow = Table.Add();
		NewRow.Key = Row.Key;
		NewRow.DocOrder = Row.DocOrder;
	EndDo;
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Table.Key AS Key,
	|	Table.DocOrder AS DocOrder
	|INTO Table
	|FROM
	|	&Table AS Table
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Table.Key,
	|	Table.DocOrder
	|FROM
	|	Table AS Table
	|		INNER JOIN Document.PurchaseOrderClosing AS DocOrderClosing
	|		ON DocOrderClosing.PurchaseOrder = Table.DocOrder
	|		AND DocOrderClosing.Posted";
	Query.SetParameter("Table", Table);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	Result = New Array();
	
	While QuerySelection.Next() Do
		Result.Add(QuerySelection.Key);
	EndDo;
	
	Return Result;
EndFunction

Function GetDataFromPurchaseOrder(PurchaseOrder, Object = Undefined) Export
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
	|	CASE
	|		WHEN PurchaseOrdersInvoiceClosing.QuantityBalance > 0
	|			THEN PurchaseOrdersInvoiceClosing.QuantityBalance
	|		ELSE -1 * PurchaseOrdersInvoiceClosing.QuantityBalance
	|	END AS QuantityInBaseUnit,
	|	ItemList.IsService
	|FROM
	|	Document.PurchaseOrder.ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R1012B_PurchaseOrdersInvoiceClosing.Balance(&Boundary, Order = &PurchaseOrder) AS
	|			PurchaseOrdersInvoiceClosing
	|		ON ItemList.Key = PurchaseOrdersInvoiceClosing.RowKey
	|WHERE
	|	ItemList.Ref = &PurchaseOrder
	|
	|ORDER BY
	|	ItemList.LineNumber";
	Query.SetParameter("PurchaseOrder", PurchaseOrder);
	Boundary = Undefined;
	If Object <> Undefined Then
		PointInTime = New PointInTime(Object.Date, Object.Ref);
		Boundary = New Boundary(PointInTime, BoundaryType.Excluding);
	EndIf;
	Query.SetParameter("Boundary", Boundary);
	
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

Procedure RefreshPurchaseOrderClosing(Object) Export
	FillingData = GetDataFromPurchaseOrder(Object.PurchaseOrder, Object);
	RefreshClosing(Object, FillingData, "PurchaseOrderKey",
		"Agreement, Company, LegalName, Partner, PurchaseOrder, TransactionType");
EndProcedure

#EndRegion

Procedure RefreshClosing(Object, FillingData, BasisRowKeyColumnName, HeaderAttributeNames)
	FillPropertyValues(Object, FillingData, HeaderAttributeNames);
	
	// Add or refresh
	For Each Row In FillingData.ItemList Do
		ClosingRows = Object.ItemList.FindRows(New Structure(BasisRowKeyColumnName, Row[BasisRowKeyColumnName]));
		_Cancel       = Undefined;
		_CancelReason = Undefined;
		If ClosingRows.Count() Then
			ClosingRow    = ClosingRows[0];
			_Cancel       = ClosingRow.Cancel;
			_CancelReason = ClosingRow.CancelReason;
		Else
			ClosingRow     = Object.ItemList.Add();
			ClosingRow.Key = New UUID();
		EndIf;
		FillPropertyValues(ClosingRow, Row);
		If ValueIsFilled(_Cancel) Then
			ClosingRow.Cancel = _Cancel;
		EndIf;
		If ValueIsFilled(_CancelReason) Then
			ClosingRow.CancelReason = _CancelReason;
		EndIf;
	EndDo;
	
	// delete
	ArrayForDelete = New Array();
	For Each Row In Object.ItemList Do
		RowExists = False;
		For Each RowFillingData In FillingData.ItemList Do
			If Row[BasisRowKeyColumnName] = RowFillingData[BasisRowKeyColumnName] Then
				RowExists = True;
				Break;
			EndIf;
		EndDo;
		If Not RowExists Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Item In ArrayForDelete Do
		Object.ItemList.Delete(Item);
	EndDo;
EndProcedure
