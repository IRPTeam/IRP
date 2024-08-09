#Region FORM

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
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	SerialLotNumbersServer.UpdateSerialLotNumbersPresentation(Object);
EndProcedure

#EndRegion

#Region TITLE_DECORATIONS

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("StoreSender");
	AttributesArray.Add("StoreReceiver");
	AttributesArray.Add("StoreTransit");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

#Region LIST_FORM

Procedure OnCreateAtServerListForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerListForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region CHOICE_FORM

Procedure OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServerChoiceForm(Form, Cancel, StandardProcessing);
EndProcedure

#EndRegion

#Region Public

// Fill by PI.
// 
// Parameters:
//  BasisArray - Array Of DocumentRef.PurchaseInvoice -
Function GetDataFromPI(BasisArray) Export
	
	FillingData = New Structure;
	FillingData.Insert("BasedOn", "PurchaiceInvoice");
	FillingData.Insert("ItemList", New Array);
	FillingData.Insert("SerialLotNumbers", New Array);

	ColumnsForItemList = New Array;	
	For Each Column In Documents.InventoryTransfer.EmptyRef().ItemList.Unload().Columns Do
		ColumnsForItemList.Add(Column.Name);
	EndDo;
	ColumnForItemList = StrConcat(ColumnsForItemList, ",");
	
	ColumnsForSN = New Array;	
	For Each Column In Documents.InventoryTransfer.EmptyRef().SerialLotNumbers.Unload().Columns Do
		ColumnsForSN.Add(Column.Name);
	EndDo;
	ColumnForSN = StrConcat(ColumnsForSN, ",");
	
	Query = New Query;
	Query.SetParameter("BasisArray", BasisArray);
	Query.Text = 
	"SELECT
	|	R4032B_GoodsInTransitOutgoingBalance.Store AS Store,
	|	R4032B_GoodsInTransitOutgoingBalance.Basis AS Basis,
	|	R4032B_GoodsInTransitOutgoingBalance.ItemKey AS ItemKey,
	|	R4032B_GoodsInTransitOutgoingBalance.SerialLotNumber,
	|	R4032B_GoodsInTransitOutgoingBalance.QuantityBalance AS QuantityBalance
	|FROM
	|	AccumulationRegister.R4032B_GoodsInTransitOutgoing.Balance(, Basis IN (&BasisArray)) AS
	|		R4032B_GoodsInTransitOutgoingBalance
	|WHERE
	|	R4032B_GoodsInTransitOutgoingBalance.QuantityBalance > 0";
	
	TableRest = Query.Execute().Unload();
	
	Query = New Query;
	Query.SetParameter("BasisArray", BasisArray);
	Query.Text = 
	"SELECT
	|	PurchaseInvoiceItemList.Item AS Item,
	|	PurchaseInvoiceItemList.ItemKey AS ItemKey,
	|	PurchaseInvoiceItemList.Unit AS Unit,
	|	ISNULL(PurchaseInvoiceSerialLotNumbers.Quantity, PurchaseInvoiceItemList.Quantity) AS Quantity,
	|	ISNULL(PurchaseInvoiceSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber,
	|	PurchaseInvoiceItemList.Key AS Key
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|		LEFT JOIN Document.PurchaseInvoice.SerialLotNumbers AS PurchaseInvoiceSerialLotNumbers
	|		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceSerialLotNumbers.Key
	|		AND PurchaseInvoiceSerialLotNumbers.Ref IN (&BasisArray)
	|WHERE
	|	PurchaseInvoiceItemList.Ref IN (&BasisArray)
	|TOTALS
	|	MAX(Item) AS Item,
	|	MAX(Unit) AS Unit,
	|	MAX(ItemKey) AS ItemKey
	|BY
	|	Key
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(PurchaseInvoiceItemList.Ref.Company) AS Company,
	|	MAX(PurchaseInvoiceItemList.Store) AS StoreSender,
	|	MAX(PurchaseInvoiceItemList.Ref.Branch) AS Branch,
	|	MAX(PurchaseInvoiceItemList.Ref.Ref) AS DistributedPurchaseInvoice,
	|	MAX(PurchaseInvoiceItemList.Store.UseShipmentConfirmation) AS UseShipmentConfirmation,
	|	MAX(PurchaseInvoiceItemList.Ref.StoreDistributedPurchase) AS StoreDistributedPurchase
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|WHERE
	|	PurchaseInvoiceItemList.Ref IN (&BasisArray)";
	
	ResultsArray = Query.ExecuteBatch();
	
	SelectionHeader = ResultsArray[1].Select();
	While SelectionHeader.Next() Do
		FillingData.Insert("Company", SelectionHeader.Company);
		FillingData.Insert("StoreSender", SelectionHeader.StoreSender);
		FillingData.Insert("StoreReceiver", Catalogs.Stores.EmptyRef());
		FillingData.Insert("Branch", SelectionHeader.Branch);
		FillingData.Insert("UseShipmentConfirmation", SelectionHeader.UseShipmentConfirmation);
		If SelectionHeader.StoreDistributedPurchase Then
			FillingData.Insert("DistributedPurchaseInvoice", SelectionHeader.DistributedPurchaseInvoice);
		Else
			FillingData.Insert("DistributedPurchaseInvoice", Undefined);		
		EndIf;
	EndDo;
	
	SelectionKey = ResultsArray[0].Select(QueryResultIteration.ByGroups, "Key");
	While SelectionKey.Next() Do
		Selection = SelectionKey.Select();
		CreateRow = False;
		ArrayOfSerialLotNumbers = New Array;
		While Selection.Next() Do
			
			CurrentQuantity = Selection.Quantity;
			SearchStructure = New Structure("ItemKey, SerialLotNumber", Selection.ItemKey,  Selection.SerialLotNumber);
			SearchArray = TableRest.FindRows(SearchStructure);
			
			For Each Row In SearchArray Do
				CreateRow = True;
				If CurrentQuantity >= Row.QuantityBalance Then
					QuantityForDoc = Row.QuantityBalance;
				Else
					QuantityForDoc = CurrentQuantity;
				EndIf;
				Row.QuantityBalance = Row.QuantityBalance - QuantityForDoc;
				
				StructureFoArray = New Structure;
				StructureFoArray.Insert("SerialLotNumber", Selection.SerialLotNumber);
				StructureFoArray.Insert("Quantity", QuantityForDoc);
				
				ArrayOfSerialLotNumbers.Add(StructureFoArray);
			EndDo;			
		EndDo;
		If CreateRow Then
			NewRowItemList = New Structure(ColumnForItemList);
			NewRowItemList.Key = New UUID();
			FillPropertyValues(NewRowItemList, SelectionKey, "Item, ItemKey, Unit, Key");
			NewRowItemList.PurchaseInvoice = SelectionHeader.DistributedPurchaseInvoice;
			If ArrayOfSerialLotNumbers.Count() > 0 Then
				TotalQuantity = 0;
				For Each SerialLotNumberStructure In ArrayOfSerialLotNumbers Do
					If ValueIsFilled(SerialLotNumberStructure.SerialLotNumber) Then
						NewRowSerialLotNumbers = New Structure(ColumnForSN);
						NewRowSerialLotNumbers.Key = NewRowItemList.Key;
						NewRowSerialLotNumbers.SerialLotNumber = SerialLotNumberStructure.SerialLotNumber;
						NewRowSerialLotNumbers.Quantity = SerialLotNumberStructure.Quantity;
									
						NewRowItemList.UseSerialLotNumber = True;
						
						TotalQuantity = TotalQuantity + NewRowSerialLotNumbers.Quantity;
						FillingData.SerialLotNumbers.Add(NewRowSerialLotNumbers);
					Else
						TotalQuantity = TotalQuantity + SerialLotNumberStructure.Quantity;
					EndIf;					
				EndDo;
				NewRowItemList.Quantity = TotalQuantity;
				UnitFactor = GetItemInfo.GetUnitFactor(NewRowItemList.ItemKey, NewRowItemList.Unit);
				NewRowItemList.QuantityInBaseUnit = NewRowItemList.Quantity  * UnitFactor;				
			EndIf;	
			FillingData.ItemList.Add(NewRowItemList);
		EndIf;	
	EndDo;

	Result = New Structure();
	Result.Insert("FillingValues", New Array);
	Result.FillingValues.Add(FillingData);
	Return Result;
EndFunction

#EndRegion
