&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	SelectShipmentBasisMode = Parameters.SelectShipmentBasisMode;
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
	Items.FormSelectAll.Visible = Not SelectShipmentBasisMode;
	Items.FormUnselectAll.Visible = Not SelectShipmentBasisMode;
	Items.DocumentsTreeUse.Visible = Not SelectShipmentBasisMode;
EndProcedure

&AtServer
Procedure SetConditionalAppearence()
	ConditionalAppearance.Items.Clear();
	
	AppearenceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearenceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.DocumentsTreeShipmentBasis.Name);
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
			|	Table.Ref AS ShipmentBasis
			|into tmp
			|FROM
			|	Document.SalesOrder AS Table
			|WHERE
			|	Table.Company = &Company
			|	AND Table.Partner = &Partner
			|	AND Table.LegalName = &LegalName
			|	AND Table.ShipmentConfirmationsBeforeSalesInvoice
			|
			|UNION ALL
			|
			|SELECT
			|	Table.Ref
			|FROM
			|	Document.SalesInvoice AS Table
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
			|	Document.PurchaseReturn AS Table
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
			|	Table.ShipmentBasis AS ShipmentBasis,
			|	Table.Currency AS Currency,
			|	Table.ItemKey,
			|	Table.Unit,
			|	SUM(Table.Quantity) AS Quantity,
			|	Table.RowKey
			|FROM
			|	(SELECT
			|		GoodsInTransitOutgoingBalance.Store AS Store,
			|		GoodsInTransitOutgoingBalance.ShipmentBasis AS ShipmentBasis,
			|		GoodsInTransitOutgoingBalance.ShipmentBasis.Currency AS Currency,
			|		GoodsInTransitOutgoingBalance.ItemKey,
			|		CASE
			|			WHEN GoodsInTransitOutgoingBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
			|				THEN GoodsInTransitOutgoingBalance.ItemKey.Unit
			|			ELSE GoodsInTransitOutgoingBalance.ItemKey.Item.Unit
			|		END AS Unit,
			|		GoodsInTransitOutgoingBalance.QuantityBalance AS Quantity,
			|		GoodsInTransitOutgoingBalance.RowKey
			|	FROM
			|		AccumulationRegister.GoodsInTransitOutgoing.Balance(, ShipmentBasis IN
			|			(select
			|				ShipmentBasis
			|			from
			|				tmp) AND CASE
			|							WHEN &FilterByItemKey
			|								THEN ItemKey = &ItemKey
			|							ELSE TRUE
			|						END) AS GoodsInTransitOutgoingBalance
			|
			|	UNION ALL
			|
			|	SELECT
			|		DocumentRecords.Store AS Store,
			|		DocumentRecords.ShipmentBasis AS ShipmentBasis,
			|		DocumentRecords.ShipmentBasis.Currency AS Currency,
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
			|		AccumulationRegister.GoodsInTransitOutgoing AS DocumentRecords
			|			INNER JOIN tmp AS tmp
			|			ON tmp.ShipmentBasis = DocumentRecords.ShipmentBasis
			|			AND DocumentRecords.Recorder = &Ref
			|			AND (CASE
			|					WHEN &FilterByItemKey
			|						THEN DocumentRecords.ItemKey = &ItemKey
			|					ELSE TRUE
			|				END)) AS Table
			|
			|GROUP BY
			|	Table.Store,
			|	Table.ShipmentBasis,
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
	Query.TempTablesManager = DocShipmentConfirmationServer.PutQueryTableToTempTable(QueryTable);
	Query.Text =
		"SELECT ALLOWED
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ShipmentBasis AS ShipmentBasis,
		|	tmpQueryTable.Currency AS Currency,
		|	tmpQueryTable.ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.RowKey,
		|
		|	MAX(CASE
		|		WHEN NOT DocSalesInvoice.Unit IS NULL
		|			THEN DocSalesInvoice.Unit
		|		WHEN NOT DocSalesOrder.Unit IS NULL
		|			THEN DocSalesOrder.Unit
		|		WHEN NOT DocBundling.Unit IS NULL
		|			THEN DocBundling.Unit
		|		WHEN NOT DocUnbundling.Unit IS NULL
		|			THEN DocUnbundling.Unit
		|		WHEN NOT DocInventoryTransfer.Unit IS NULL
		|			THEN DocInventoryTransfer.Unit
		|		WHEN NOT DocPurchaseReturn.Unit IS NULL
		|			THEN DocPurchaseReturn.Unit
		|		ELSE tmpQueryTable.Unit
		|	END) AS Unit
		|FROM
		|	tmpQueryTable AS tmpQueryTable
		|
		|		LEFT JOIN Document.SalesInvoice.ItemList AS DocSalesInvoice
		|		ON tmpQueryTable.Key = DocSalesInvoice.Key
		|		AND tmpQueryTable.ShipmentBasis = DocSalesInvoice.Ref
		|
		|		LEFT JOIN Document.SalesOrder.ItemList AS DocSalesOrder
		|		ON tmpQueryTable.Key = DocSalesOrder.Key
		|		AND tmpQueryTable.ShipmentBasis = DocSalesOrder.Ref
		|
		|		LEFT JOIN Document.Bundling.ItemList AS DocBundling
		|		ON tmpQueryTable.Key = DocBundling.Key
		|		AND tmpQueryTable.ShipmentBasis = DocBundling.Ref
		|
		|		LEFT JOIN Document.Unbundling.ItemList AS DocUnbundling
		|		ON tmpQueryTable.Key = DocUnbundling.Key
		|		AND tmpQueryTable.ShipmentBasis = DocUnbundling.Ref
		|
		|		LEFT JOIN Document.InventoryTransfer.ItemList AS DocInventoryTransfer
		|		ON tmpQueryTable.Key = DocInventoryTransfer.Key
		|		AND tmpQueryTable.ShipmentBasis = DocInventoryTransfer.Ref
		|
		|		LEFT JOIN Document.PurchaseReturn.ItemList AS DocPurchaseReturn
		|		ON tmpQueryTable.Key = DocPurchaseReturn.Key
		|		AND tmpQueryTable.ShipmentBasis = DocPurchaseReturn.Ref
		|
		|GROUP BY
		|	tmpQueryTable.Store,
		|	tmpQueryTable.ShipmentBasis,
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
	
	FilterTable = QueryTable.Copy( , "ShipmentBasis");
	FilterTable.GroupBy("ShipmentBasis");
	
	For Each Row_Basis In FilterTable Do
		
		NewRow_Basis = ThisObject.DocumentsTree.GetItems().Add();
		NewRow_Basis.ShipmentBasis = Row_Basis.ShipmentBasis;
		
		BasisItemsArray = QueryTable.FindRows(New Structure("ShipmentBasis", Row_Basis.ShipmentBasis));
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
			DocumentsTree.GetItems().Delete(NewRow_Basis);
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
	If SelectShipmentBasisMode Then
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
		If Not ValueIsFilled(Row_Item.ShipmentBasis) Then
			Return;
		EndIf;
		
		Result = New Array();
		RowStructure = New Structure("ShipmentBasis, Store, Item, ItemKey, Key, Unit, Quantity");
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
					RowStructure = New Structure("ShipmentBasis, Store, Item, ItemKey, Key, Unit, Quantity");
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

