&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Property("FilterValues") Then
		FillDocumentsTree(Parameters.FilterValues, Parameters.ExistingRows, Parameters.Ref);
	Else
		Cancel = True;
	EndIf;
	SetConditionalAppearance();
EndProcedure

&AtServer
Procedure SetConditionalAppearance()
	ConditionalAppearance.Items.Clear();
	
	AppearanceElement = ConditionalAppearance.Items.Add();
	
	FieldElement = AppearanceElement.Fields.Items.Add();
	FieldElement.Field = New DataCompositionField(Items.DocumentsTreePurchaseOrder.Name);
	
	FilterElement = AppearanceElement.Filter.Items.Add(Type("DataCompositionFilterItem"));
	FilterElement.LeftValue = New DataCompositionField("DocumentsTree.ItemKey");
	FilterElement.ComparisonType = DataCompositionComparisonType.Filled;
	
	AppearanceElement.Appearance.SetParameterValue("Text", "");
EndProcedure

&AtServer
Procedure FillDocumentsTree(FilterValues, ExistingRows, Ref)
	ThisObject.DocumentsTree.GetItems().Clear();
	
	Query = New Query();
	Query.Text =
		"SELECT ALLOWED
		|	Table.Ref AS PurchaseOrder
		|into tmp
		|FROM
		|	Document.PurchaseOrder AS Table
		|WHERE
		|	Table.Company = &Company
		|	AND Table.Partner = &Partner
		|	AND Table.LegalName = &LegalName
		|	AND Table.Agreement = &Agreement
		|	AND Table.Currency = &Currency
		|	AND Table.PriceIncludeTax = &PriceIncludeTax
		|	AND
		|	NOT Table.GoodsReceiptBeforePurchaseInvoice
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	Table.Store,
		|	Table.PurchaseOrder,
		|	Table.GoodsReceipt,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	Table.Unit,
		|	SUM(Table.Quantity) AS Quantity
		|FROM
		|	(SELECT
		|		OrderBalanceBalance.Store AS Store,
		|		OrderBalanceBalance.Order AS PurchaseOrder,
		|		VALUE(Document.GoodsReceipt.EmptyRef) AS GoodsReceipt,
		|		OrderBalanceBalance.ItemKey,
		|		OrderBalanceBalance.RowKey,
		|		CASE
		|			WHEN OrderBalanceBalance.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|				THEN OrderBalanceBalance.ItemKey.Unit
		|			ELSE OrderBalanceBalance.ItemKey.Item.Unit
		|		END AS Unit,
		|		OrderBalanceBalance.QuantityBalance AS Quantity
		|	FROM
		|		AccumulationRegister.OrderBalance.Balance(, order in
		|			(select
		|				PurchaseOrder
		|			from
		|				tmp)
		|		AND ItemKey.Item.ItemType.Type <> VALUE(enum.ItemTypes.Service)) AS OrderBalanceBalance
		|
		|	UNION ALL
		|
		|	SELECT
		|		DocumentRecords.Store AS Store,
		|		DocumentRecords.Order AS PurchaseOrder,
		|		VALUE(Document.GoodsReceipt.EmptyRef) AS GoodsReceipt,
		|		DocumentRecords.ItemKey,
		|		DocumentRecords.RowKey,
		|		CASE
		|			WHEN DocumentRecords.ItemKey.Unit <> VALUE(Catalog.Units.EmptyRef)
		|				THEN DocumentRecords.ItemKey.Unit
		|			ELSE DocumentRecords.ItemKey.Item.Unit
		|		END AS Unit,
		|		CASE
		|			WHEN DocumentRecords.RecordType = VALUE(AccumulationRecordType.Receipt)
		|				THEN -DocumentRecords.Quantity
		|			ELSE DocumentRecords.Quantity
		|		END AS Quantity
		|	FROM
		|		AccumulationRegister.OrderBalance AS DocumentRecords
		|			INNER JOIN tmp AS tmp
		|			ON tmp.PurchaseOrder = DocumentRecords.Order
		|			AND DocumentRecords.Recorder = &Ref) AS Table
		|GROUP BY
		|	Table.Store,
		|	Table.PurchaseOrder,
		|	Table.GoodsReceipt,
		|	Table.ItemKey,
		|	Table.RowKey,
		|	Table.Unit";
	Query.SetParameter("Company", FilterValues.Company);
	Query.SetParameter("Partner", FilterValues.Partner);
	Query.SetParameter("LegalName", FilterValues.LegalName);
	Query.SetParameter("Agreement", FilterValues.Agreement);
	Query.SetParameter("Currency", FilterValues.Currency);
	Query.SetParameter("PriceIncludeTax", FilterValues.PriceIncludeTax);
	Query.SetParameter("Ref", Ref);
	
	QueryTableOrders = Query.Execute().Unload();
	QueryTableOrders.Columns.Add("Key", New TypeDescription("UUID"));
	For Each Row In QueryTableOrders Do
		Row.Key = New UUID(Row.RowKey);
	EndDo;
	
	Query = New Query();
	Query.Text =
		"SELECT
		|	QueryTable.Store,
		|	QueryTable.PurchaseOrder,
		|	QueryTable.GoodsReceipt,
		|	QueryTable.ItemKey,
		|	QueryTable.Key,
		|	QueryTable.Unit,
		|	QueryTable.Quantity
		|INTO tmpQueryTable
		|FROM
		|	&QueryTable AS QueryTable
		|;
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT ALLOWED
		|	tmpQueryTable.ItemKey AS ItemKey,
		|	tmpQueryTable.ItemKey.Item AS Item,
		|	tmpQueryTable.Store AS Store,
		|	tmpQueryTable.PurchaseOrder AS PurchaseOrder,
		|	tmpQueryTable.Key,
		|	tmpQueryTable.Unit AS QuantityUnit,
		|	tmpQueryTable.Quantity AS Quantity,
		|	CAST(Doc.PurchaseBasis AS Document.SalesOrder) AS SalesOrder,
		|	ISNULL(Doc.Price, 0) AS Price,
		|	ISNULL(Doc.PriceType, Value(Catalog.PriceTypes.EmptyRef)) AS PriceType,
		|	ISNULL(Doc.Unit, VALUE(Catalog.Units.EmptyRef)) AS Unit,
		|	ISNULL(Doc.DeliveryDate, DATETIME(1, 1, 1)) AS DeliveryDate,
		|	tmpQueryTable.GoodsReceipt AS GoodsReceipt
		|FROM
		|	Document.PurchaseOrder.ItemList AS Doc
		|		INNER JOIN tmpQueryTable AS tmpQueryTable
		|		ON tmpQueryTable.Key = Doc.Key
		|		AND tmpQueryTable.PurchaseOrder = Doc.Ref";
	
	Query.SetParameter("QueryTable", QueryTableOrders);
	QueryTable = Query.Execute().Unload();
	DocumentsServer.RecalculateQuantityInTable(QueryTable);
	
	OrdersTable = QueryTable.Copy( , "PurchaseOrder");
	OrdersTable.GroupBy("PurchaseOrder");
	
	For Each Row_Order In OrdersTable Do
		
		NewRow_Order = ThisObject.DocumentsTree.GetItems().Add();
		NewRow_Order.PurchaseOrder = Row_Order.PurchaseOrder;
		
		OrdersItemsArray = QueryTable.FindRows(New Structure("PurchaseOrder", Row_Order.PurchaseOrder));
		For Each Row_Item In OrdersItemsArray Do
			
			// exclude quantity from existing rows
			ExistingQuantity = 0;
			For i = 0 To ExistingRows.UBound() Do
				If i > ExistingRows.UBound() Then
					Break;
				EndIf;
				
				ExistingRow = ExistingRows[i];
				If ExistingRow.Key = Row_Item.Key Then
					UnitFactorFrom = Catalogs.Units.GetUnitFactor(ExistingRow.Unit, Row_Item.QuantityUnit);
					UnitFactorTo = Catalogs.Units.GetUnitFactor(Row_Item.Unit, Row_Item.QuantityUnit);
					PreviousExistingQuantity = ExistingQuantity;
					ExistingQuantity = Min(ExistingQuantity + ?(UnitFactorTo = 0, 
																0, 
																ExistingRow.Quantity * UnitFactorFrom / UnitFactorTo),
										   Row_Item.Quantity);
					ExistingRow.Quantity = ExistingRow.Quantity 
								- ?(UnitFactorFrom = 0, 
									0, 
									(PreviousExistingQuantity - ExistingQuantity) / UnitFactorFrom * UnitFactorTo);
					If ExistingRow.Quantity <= 0 Then
						ExistingRows.Delete(i);
						i = i - 1;
					EndIf;
				EndIf;
			EndDo;
			
			If ExistingQuantity < Row_Item.Quantity Then
				NewRow_Item = NewRow_Order.GetItems().Add();
				FillPropertyValues(NewRow_Item, Row_Item);
				NewRow_Item.Quantity = NewRow_Item.Quantity - ExistingQuantity;
			EndIf;
		EndDo;
		
		If Not NewRow_Order.GetItems().Count() Then
			DocumentsTree.GetItems().Delete(NewRow_Order);
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
Procedure Ok(Command)
	Close(GetSelectedData());
EndProcedure

&AtServer
Function GetSelectedData()
	Result = New Array();
	For Each Row_Order In ThisObject.DocumentsTree.GetItems() Do
		For Each Row_Item In Row_Order.GetItems() Do
			If Row_Item.Use Then
				RowStructure = New Structure("PurchaseOrder, 
						|SalesOrder, 
						|GoodsReceipt, 
						|Item, 
						|ItemKey, 
						|Key, 
						|Unit, 
						|Quantity, 
						|Price,
						|PriceType,
						|Store, 
						|DeliveryDate");
				FillPropertyValues(RowStructure, Row_Item);
				Result.Add(RowStructure);
			EndIf;
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
	For Each Row_Order In DocumentsTree.GetItems() Do
		Row_Order.Use = UseValue;
		For Each Row_Item In Row_Order.GetItems() Do
			Row_Item.Use = UseValue;
		EndDo;
	EndDo;
EndProcedure

