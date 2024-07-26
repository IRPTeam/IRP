Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;	
	ThisObject.AdditionalProperties.Insert("OriginalDocumentDate", PostingServer.GetOriginalDocumentDate(ThisObject));
	ThisObject.AdditionalProperties.Insert("IsPostingNewDocument" , WriteMode = DocumentWriteMode.Posting And Not Ref.Posted);
	RowIDInfoPrivileged.BeforeWrite_RowID(ThisObject, Cancel, WriteMode, PostingMode);
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	RowIDInfoPrivileged.OnWrite_RowID(ThisObject, Cancel);
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.Posting_RowID(ThisObject, Cancel, PostingMode);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
	RowIDInfoPrivileged.UndoPosting_RowIDUndoPosting(ThisObject, Cancel);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If TypeOf(FillingData) = Type("Structure") Then
		If FillingData.Property("BasedOn") Then
			If FillingData.BasedOn = "ProductionPlanning" Then
				ControllerClientServer_V2.SetReadOnlyProperties(ThisObject, FillingData);
				FillPropertyValues(ThisObject, FillingData);
				For Each Row In FillingData.ItemList Do
					NewRow = ThisObject.ItemList.Add();
					NewRow.Key = String(New UUID());
					FillPropertyValues(NewRow, Row);
				EndDo;
			Else
				PropertiesHeader = RowIDInfoServer.GetSeparatorColumns(ThisObject.Metadata());
				FillPropertyValues(ThisObject, FillingData, PropertiesHeader);
				LinkedResult = RowIDInfoServer.AddLinkedDocumentRows(ThisObject, FillingData);
				ControllerClientServer_V2.SetReadOnlyProperties_RowID(ThisObject, PropertiesHeader, LinkedResult.UpdatedProperties);
			EndIf;
		EndIf;
	ElsIf TypeOf(FillingData) = Type("Array") Then
		ObjectRef = FillingData[0];
		If TypeOf(ObjectRef) = Type("DocumentRef.PurchaseInvoice") Then
			FillByPI(FillingData);
		EndIf;
	EndIf;
EndProcedure

Procedure FillByPI(ArrayOfPI)
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
			NewRowItemList = ItemList.Add();
			NewRowItemList.Key = New UUID();
			FillPropertyValues(NewRowItemList, SelectionItemKey, "Item, ItemKey, Unit");
			If ArrayOfSerialLotNumbers.Count() > 0 Then
				TotalQuantity = 0;
				For Each SerialLotNumberStructure In ArrayOfSerialLotNumbers Do
					If ValueIsFilled(SerialLotNumberStructure.SerialLotNumber) Then
						NewRowSerialLotNumbers = SerialLotNumbers.Add();
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
		Company						= SelectionHeader.Company;
		StoreSender					= SelectionHeader.StoreSender;
		UseShipmentConfirmation		= SelectionHeader.UseShipmentConfirmation;
		If SelectionHeader.StoreDistributedPurchase Then
			DistributedPurchaseInvıoice = SelectionHeader.DistributedPurchaseInvıoice;
		EndIf;
	EndDo;
	
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If ThisObject.UseShipmentConfirmation And Not ThisObject.UseGoodsReceipt Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_094, "UseGoodsReceipt");
		Cancel = True;
	EndIf;
	
	If Not SerialLotNumbersServer.CheckFilling(ThisObject) Then
		Cancel = True;
	EndIf;
	
	If Not Cancel = True Then
		LinkedFilter = RowIDInfoClientServer.GetLinkedDocumentsFilter_IT(ThisObject);
		RowIDInfoTable = ThisObject.RowIDInfo.Unload();
		ItemListTable = ThisObject.ItemList.Unload(, "Key, LineNumber, ItemKey");
		ItemListTable.Columns.Add("Store", New TypeDescription("CatalogRef.Stores"));
		RowIDInfoServer.FillCheckProcessing(ThisObject, Cancel, LinkedFilter, RowIDInfoTable, ItemListTable);
	EndIf;
	
	If Not ThisObject.Company.IsEmpty() Then
		If Not ThisObject.StoreReceiver.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreReceiver, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreReceiver,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreReceiver", 
					"Object");
			EndIf;
		EndIf;
		If Not ThisObject.StoreSender.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreSender, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreSender,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreSender", 
					"Object");
			EndIf;
		EndIf;
		If Not ThisObject.StoreTransit.IsEmpty() Then
			StoreCompany = CommonFunctionsServer.GetRefAttribute(ThisObject.StoreTransit, "Company");
			If ValueIsFilled(StoreCompany) And Not StoreCompany = ThisObject.Company Then
				Cancel = True;
				MessageText = StrTemplate(
					R().Error_Store_Company,
					ThisObject.StoreTransit,
					ThisObject.Company);
				CommonFunctionsClientServer.ShowUsersMessage(
					MessageText, 
					"Object.StoreTransit", 
					"Object");
			EndIf;
		EndIf;
	EndIf;
EndProcedure