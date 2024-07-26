#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
	FillVendorPrice(Object);
EndProcedure

Procedure FillVendorPrice(Object)
	GetItemInfo.FillVendorPricesInObject(Object);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	AccountingServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
	FillVendorPrice(Object);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
	LockDataModificationPrivileged.LockFormIfObjectIsLocked(Form, CurrentObject);
	SerialLotNumbersServer.UpdateSerialLotNumbersPresentation(Object);
	AccountingServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region _TITLE

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("LegalNameContract");
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

Procedure FillByPI(ArrayOfPI, DocObject) Export
	Query = New Query;
	Query.SetParameter("BasisArray", ArrayOfPI);
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
	Query.SetParameter("BasisArray", ArrayOfPI);
	Query.Text = 
	"SELECT
	|	PurchaseInvoiceItemList.Item AS Item,
	|	PurchaseInvoiceItemList.ItemKey AS ItemKey,
	|	PurchaseInvoiceItemList.Unit AS Unit,
	|	ISNULL(PurchaseInvoiceSerialLotNumbers.Quantity, PurchaseInvoiceItemList.Quantity) AS Quantity,
	|	ISNULL(PurchaseInvoiceSerialLotNumbers.SerialLotNumber, VALUE(Catalog.SerialLotNumbers.EmptyRef)) AS SerialLotNumber
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|		LEFT JOIN Document.PurchaseInvoice.SerialLotNumbers AS PurchaseInvoiceSerialLotNumbers
	|		ON PurchaseInvoiceItemList.Key = PurchaseInvoiceSerialLotNumbers.Key
	|		AND PurchaseInvoiceSerialLotNumbers.Ref IN (&BasisArray)
	|WHERE
	|	PurchaseInvoiceItemList.Ref IN (&BasisArray)
	|TOTALS
	|	MAX(Item) AS Item,
	|	MAX(Unit) AS Unit
	|BY
	|	ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(PurchaseInvoiceItemList.Ref.Company) AS Company,
	|	MAX(PurchaseInvoiceItemList.Store) AS StoreSender,
	|	MAX(PurchaseInvoiceItemList.Ref.Ref) AS DistributedPurchaseInvıoice,
	|	MAX(PurchaseInvoiceItemList.Store.UseShipmentConfirmation) AS UseShipmentConfirmation,
	|	MAX(PurchaseInvoiceItemList.Ref.StoreDistributedPurchase) AS StoreDistributedPurchase
	|FROM
	|	Document.PurchaseInvoice.ItemList AS PurchaseInvoiceItemList
	|WHERE
	|	PurchaseInvoiceItemList.Ref IN (&BasisArray)";
	
	ResultsArray = Query.ExecuteBatch();
	SelectionItemKey = ResultsArray[0].Select(QueryResultIteration.ByGroups, "ItemKey");
	While SelectionItemKey.Next() Do
		Selection = SelectionItemKey.Select();
		CreateRow = False;
		ArrayOfSerialLotNumbers = New Array;
		While Selection.Next() Do
			
			CurrentQuantity = Selection.Quantity;
			SearchStructure = New Structure("ItemKey, SerialLotNumber", Selection.ItemKey,  Selection.SerialLotNumber);
			SearchArray = TableRest.FindRows(SearchStructure);
			
			For Each Row In SearchArray Do
				CreateRow = True;
				If CurrentQuantity>=Row.QuantityBalance Then
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
			NewRowItemList = DocObject.ItemList.Add();
			NewRowItemList.Key = New UUID();
			FillPropertyValues(NewRowItemList, SelectionItemKey, "Item, ItemKey, Unit");
			If ArrayOfSerialLotNumbers.Count() > 0 Then
				TotalQuantity = 0;
				For Each SerialLotNumberStructure In ArrayOfSerialLotNumbers Do
					If ValueIsFilled(SerialLotNumberStructure.SerialLotNumber) Then
						NewRowSerialLotNumbers = DocObject.SerialLotNumbers.Add();
						NewRowSerialLotNumbers.Key = NewRowItemList.Key;
						NewRowSerialLotNumbers.SerialLotNumber = SerialLotNumberStructure.SerialLotNumber;
						NewRowSerialLotNumbers.Quantity = SerialLotNumberStructure.Quantity;
									
						NewRowItemList.UseSerialLotNumber = True;
						
						TotalQuantity = TotalQuantity + NewRowSerialLotNumbers.Quantity;
					Else
						TotalQuantity = TotalQuantity + SerialLotNumberStructure.Quantity;
					EndIf;					
				EndDo;
				NewRowItemList.Quantity = TotalQuantity;
				UnitFactor = GetItemInfo.GetUnitFactor(NewRowItemList.ItemKey, NewRowItemList.Unit);
				NewRowItemList.QuantityInBaseUnit = NewRowItemList.Quantity  * UnitFactor;				
			EndIf;	
		EndIf;	
	EndDo;
	
	SelectionHeader = ResultsArray[1].Select();
	While SelectionHeader.Next() Do
		DocObject.Company						= SelectionHeader.Company;
		DocObject.StoreSender					= SelectionHeader.StoreSender;
		DocObject.UseShipmentConfirmation		= SelectionHeader.UseShipmentConfirmation;
		If SelectionHeader.StoreDistributedPurchase Then
			DocObject.DistributedPurchaseInvıoice = SelectionHeader.DistributedPurchaseInvıoice;
		EndIf;
	EndDo;
	
EndProcedure

#EndRegion
