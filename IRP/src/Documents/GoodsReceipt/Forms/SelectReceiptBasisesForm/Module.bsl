&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SelectReceiptBasisMode = Parameters.SelectReceiptBasisMode;
	If Parameters.Property("FilterValues") Then
		FillDocumentsTree(Parameters.FilterValues, Parameters.ExistingRows, Parameters.Ref);
	Else
		Cancel = True;
	EndIf;
	SetConditionalAppearence();
	SetVisibility();
EndProcedure

&AtServer
Procedure SetVisibility()
	Items.FormSelectAll.Visible = Not SelectReceiptBasisMode;
	Items.FormUnselectAll.Visible = Not SelectReceiptBasisMode;
	Items.DocumentsTreeUse.Visible = Not SelectReceiptBasisMode;
EndProcedure

&AtServer
Procedure SetConditionalAppearence()
	ConditionalAppearance.Items.Clear();
	
	AppearenceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.DocumentsTreeReceiptBasis.Name);
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.DocumentsTreeCurrency.Name);
	
	FilterElement = AppearenceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue = New DataCompositionField("DocumentsTree.ItemKey");
	FilterElement.ComparisonType = DataCompositionComparisonType.Filled;
	
	AppearenceElement.Appearance.SetParameterValue("Text", "");
EndProcedure

&AtServer
Procedure FillDocumentsTree(FilterValues, ExistingRows, Ref)
	ThisObject.DocumentsTree.GetItems().Clear();
	
	QueryTableOrders = New Query(
			"SELECT ALLOWED
			|	Table.Ref AS ReceiptBasis
			|into tmp
			|FROM
			|	Document.PurchaseOrder AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|	AND Table.GoodsReceiptBeforePurchaseInvoice
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.PurchaseInvoice AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.SalesReturn AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Boxing AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Unboxing AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Bundling AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.Unbundling AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.InventoryTransfer AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND &Partner = UNDEFINED
			|	AND &LegalName = UNDEFINED
			|;
			|
			|////////////////////////////////////////////////////////////////////////////////
			|SELECT ALLOWED
			|	Table.Store AS Store,
			|	Table.ReceiptBasis AS ReceiptBasis,
			|	Table.Currency AS Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	SUM(Table.Quantity) AS Quantity,
			|	Table.RowKey
			|FROM
			|	(SELECT
			|		GoodsInTransitIncomingBalance.Store AS Store,
			|		GoodsInTransitIncomingBalance.ReceiptBasis AS ReceiptBasis,
			|		GoodsInTransitIncomingBalance.ReceiptBasis.Currency AS Currency,
			|		GoodsInTransitIncomingBalance.ItemKey,
			|		CASE
			|			WHEN GoodsInTransitIncomingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|				THEN GoodsInTransitIncomingBalance.ItemKey.Unit
			|			ELSE GoodsInTransitIncomingBalance.ItemKey.Item.Unit
			|		END AS Unit,
			|		GoodsInTransitIncomingBalance.QuantityBalance AS Quantity,
			|		GoodsInTransitIncomingBalance.RowKey
			|	FROM
			|		AccumulationRegister.GoodsInTransitIncoming.Balance(, ReceiptBasis IN
			|			(select
			|				ReceiptBasis
			|			from
			|				tmp) AND CASE
			|							WHEN &FilterByItemKey
			|								THEN ItemKey = &ItemKey
			|							ELSE TRUE
			|						END) AS GoodsInTransitIncomingBalance
			|
			|	UNION ALL
			|
			|	SELECT
			|		DocumentRecords.Store AS Store,
			|		DocumentRecords.ReceiptBasis AS ReceiptBasis,
			|		DocumentRecords.ReceiptBasis.Currency AS Currency,
			|		DocumentRecords.ItemKey,
			|		CASE
			|			WHEN DocumentRecords.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|				THEN DocumentRecords.ItemKey.Unit
			|			ELSE DocumentRecords.ItemKey.Item.Unit
			|		END AS Unit,
			|		CASE
			|			WHEN DocumentRecords.RecordType = VALUE(AccumulationRecordType.Receipt)
			|				THEN -DocumentRecords.Quantity
			|			ELSE DocumentRecords.Quantity
			|		END AS Quantity,
			|		DocumentRecords.RowKey
			|	FROM
			|		AccumulationRegister.GoodsInTransitIncoming AS DocumentRecords
			|			INNER JOIN tmp AS tmp
			|			ON tmp.ReceiptBasis = DocumentRecords.ReceiptBasis
			|			AND DocumentRecords.Recorder = &Ref
			|			AND (CASE
			|					WHEN &FilterByItemKey
			|						THEN DocumentRecords.ItemKey = &ItemKey
			|					ELSE TRUE
			|				END)) AS Table
			|
			|GROUP BY
			|	Table.Store,
			|	Table.ReceiptBasis,
			|	Table.Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	Table.RowKey");
	QueryTableOrders.SetParameter("Company", FilterValues.Company);
	QueryTableOrders.SetParameter("Partner", ?(ValueIsFilled(FilterValues.Partner), FilterValues.Partner, Undefined));
	QueryTableOrders.SetParameter("LegalName", ?(ValueIsFilled(FilterValues.LegalName), FilterValues.LegalName, Undefined));
	QueryTableOrders.SetParameter("Ref", Ref);
	
	ItemKey = Undefined;
	QueryTableOrders.SetParameter("FilterByItemKey", FilterValues.Property("ItemKey", ItemKey));
	QueryTableOrders.SetParameter("ItemKey", ItemKey);
	
	
	QueryTable = QueryTableOrders.Execute().Unload();
	
	Query = New Query();
	Query.TempTablesManager = DocGoodsReceiptServer.PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ReceiptBasis AS ReceiptBasis,
		|	tmpQueryTable.Currency AS Currency,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|
		|	MAX(CASE
		|		WHEN NOT DocPurchaseInvoice.SalesOrder IS NULL
		|			THEN DocPurchaseInvoice.SalesOrder
		|		WHEN NOT DocPurchaseOrder.PurchaseBasis IS NULL
		|			THEN CAST(DocPurchaseOrder.PurchaseBasis AS Document.SalesOrder)
		|		ELSE VALUE(Document.SalesOrder.EmptyRef)
		|	END) AS SalesOrder,
		|
		|	MAX(CASE
		|		WHEN NOT DocPurchaseInvoice.Unit IS NULL
		|			THEN DocPurchaseInvoice.Unit
		|		WHEN NOT DocPurchaseOrder.Unit IS NULL
		|			THEN DocPurchaseOrder.Unit
		|		WHEN NOT DocBoxing.Unit IS NULL
		|			THEN DocBoxing.Unit
		|		WHEN NOT DocBundling.Unit IS NULL
		|			THEN DocBundling.Unit
		|		WHEN NOT DocUnboxing.Unit IS NULL
		|			THEN DocUnboxing.Unit
		|		WHEN NOT DocUnbundling.Unit IS NULL
		|			THEN DocUnbundling.Unit
		|		WHEN NOT DocInventoryTransfer.Unit IS NULL
		|			THEN DocInventoryTransfer.Unit
		|		WHEN NOT DocSalesReturn.Unit IS NULL
		|			THEN DocSalesReturn.Unit
		|		ELSE tmpQueryTable.Unit
		|	END) AS Unit
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|
		|		LEFT JOIN Document.PurchaseInvoice.ItemList AS DocPurchaseInvoice
		|		ON tmpQueryTable.Key = DocPurchaseInvoice.Key
		|		AND tmpQueryTable.ReceiptBasis = DocPurchaseInvoice.Ref
		|
		|		LEFT JOIN Document.PurchaseOrder.ItemList AS DocPurchaseOrder
		|		ON tmpQueryTable.Key = DocPurchaseOrder.Key
		|		AND tmpQueryTable.ReceiptBasis = DocPurchaseOrder.Ref
		|
		|		LEFT JOIN Document.Boxing.ItemList AS DocBoxing
		|		ON tmpQueryTable.Key = DocBoxing.Key
		|		AND tmpQueryTable.ReceiptBasis = DocBoxing.Ref
		|
		|		LEFT JOIN Document.Bundling.ItemList AS DocBundling
		|		ON tmpQueryTable.Key = DocBundling.Key
		|		AND tmpQueryTable.ReceiptBasis = DocBundling.Ref
		|
		|		LEFT JOIN Document.Unboxing.ItemList AS DocUnboxing
		|		ON tmpQueryTable.Key = DocUnboxing.Key
		|		AND tmpQueryTable.ReceiptBasis = DocUnboxing.Ref
		|
		|		LEFT JOIN Document.Unbundling.ItemList AS DocUnbundling
		|		ON tmpQueryTable.Key = DocUnbundling.Key
		|		AND tmpQueryTable.ReceiptBasis = DocUnbundling.Ref
		|
		|		LEFT JOIN Document.InventoryTransfer.ItemList AS DocInventoryTransfer
		|		ON tmpQueryTable.Key = DocInventoryTransfer.Key
		|		AND tmpQueryTable.ReceiptBasis = DocInventoryTransfer.Ref
		|
		|		LEFT JOIN Document.SalesReturn.ItemList AS DocSalesReturn
		|		ON tmpQueryTable.Key = DocSalesReturn.Key
		|		AND tmpQueryTable.ReceiptBasis = DocSalesReturn.Ref
		|
		|GROUP BY
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ReceiptBasis,
		|	tmpQueryTable.Currency,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item,
		|	tmpQueryTable.Unit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey
		|";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable, "Unit");
	
	FilterTable = QueryTable.Copy( , "ReceiptBasis, Currency");
	FilterTable.GroupBy("ReceiptBasis, Currency");
	
	CurrencyTable = FilterTable.Copy( , "Currency");
	CurrencyTable.GroupBy("Currency");
	
	For Each Row_Currency In CurrencyTable Do
		
		NewRow_Currency = ThisObject.DocumentsTree.GetItems().Add();
		NewRow_Currency.Currency = Row_Currency.Currency;
		
		For Each Row_Basis In FilterTable.FindRows(New Structure("Currency", Row_Currency.Currency)) Do
			
			NewRow_Basis = NewRow_Currency.GetItems().Add();
			NewRow_Basis.ReceiptBasis = Row_Basis.ReceiptBasis;
			
			BasisItemsArray = QueryTable.FindRows(New Structure("ReceiptBasis", Row_Basis.ReceiptBasis));
			For Each Row_Item In BasisItemsArray Do
				
				// exclude quantity from existing rows
				ExistingQuantity = 0;
				For i = 0 To ExistingRows.UBound() Do
					If i > ExistingRows.UBound() Then
						Break;
					EndIf;
					
					ExistingRow = ExistingRows[i];
					If ExistingRow.Key = Row_Item.Key Then
						UnitFactor = Catalogs.Units.GetUnitFactor(ExistingRow.Unit, Row_Item.Unit);
						ExistingQuantity = Min(ExistingQuantity + ExistingRow.Quantity / UnitFactor, Row_Item.Quantity);
						ExistingRows.Delete(i);
						i = i - 1;
					EndIf;
				EndDo;
				
				If ExistingQuantity < Row_Item.Quantity Then
					NewRow_Item = NewRow_Basis.GetItems().Add();
					FillPropertyValues(NewRow_Item, Row_Item);
					NewRow_Item.Quantity = NewRow_Item.Quantity - ExistingQuantity;
				EndIf;
			EndDo;
			If Not NewRow_Basis.GetItems().Count() Then
				NewRow_Currency.GetItems().Delete(NewRow_Basis);
			EndIf;
		EndDo;
		If Not NewRow_Currency.GetItems().Count() Then
			DocumentsTree.GetItems().Delete(NewRow_Currency);
		EndIf;
	EndDo;
	
EndProcedure

&AtClient
Procedure DocumentsTreeUseOnChange(Item)
	CurrentRow = DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	For Each Row In CurrentRow.GetItems() Do
		Row.Use = CurrentRow.Use;
		For Each Row_ In Row.GetItems() Do
			Row_.Use = CurrentRow.Use;
		EndDo;
	EndDo;
EndProcedure

&AtClient
Procedure DocumentsTreeBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure DocumentsTreeBeforeDeleteRow(Item, Cancel)
	Cancel = True;
EndProcedure

&AtClient
Procedure Command_Ok(Command)
	If SelectReceiptBasisMode Then
		If Items.DocumentsTree.CurrentRow = Undefined Then
			If Not DocumentsTree.GetItems().Count() Then
				Close(Undefined);
			EndIf;
			Return;
		EndIf;
		Row_Item = DocumentsTree.FindByID(Items.DocumentsTree.CurrentRow);
		If Row_Item = Undefined Then
			Close(Undefined);
			Return;
		EndIf;
		If Not ValueIsFilled(Row_Item.ReceiptBasis) Then
			Return;
		EndIf;
		
		Result = New Array();
		RowStructure = New Structure("SalesOrder, ReceiptBasis, Store, Item, ItemKey, Key, Unit, Quantity");
		FillPropertyValues(RowStructure, Row_Item);
		Result.Add(RowStructure);
		Close(Result);
	Else
		Close(GetSelectedData());
	EndIf;
EndProcedure

&AtClient
Procedure DocumentsTreeSelection(Item, RowSelected, Field, StandardProcessing)
	Command_Ok(Undefined);
EndProcedure


&AtServer
Function GetSelectedData()
	Result = New Array();
	
	For Each Row_Currency In ThisObject.DocumentsTree.GetItems() Do
		For Each Row_Order In Row_Currency.GetItems() Do
			For Each Row_Item In Row_Order.GetItems() Do
				If Row_Item.Use Then
					RowStructure = New Structure("SalesOrder, ReceiptBasis, Store, Item, ItemKey, Key, Unit, Quantity");
					FillPropertyValues(RowStructure, Row_Item);
					Result.Add(RowStructure);
				EndIf;
			EndDo;
		EndDo;
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtClient
Procedure SelectAll(Command)
	SetUseValue(True);
EndProcedure

&AtClient
Procedure UnselectAll(Command)
	SetUseValue(False);
EndProcedure

&AtClient
Procedure SetUseValue(UseValue)
	For Each Row_Currency In DocumentsTree.GetItems() Do
		Row_Currency.Use = UseValue;
		For Each Row_Basis In Row_Currency.GetItems() Do
			Row_Basis.Use = UseValue;
			For Each Row_Item In Row_Basis.GetItems() Do
				Row_Item.Use = UseValue;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

