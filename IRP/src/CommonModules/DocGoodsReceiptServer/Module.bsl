#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);

		FillItemList(Object, Form);
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;

	FillTransactionTypeChoiceList(Form);
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	FillItemList(Object, Form);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	FillItemList(Object, Form);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;

	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

Function GetUnitFactor(FromUnit, ToUnit) Export
	Return Catalogs.Units.GetUnitFactor(FromUnit, ToUnit);
EndFunction

Procedure FillItemList(Object, Form)
	DocumentsServer.FillItemList(Object, Form);

	For Each Row In Object.ItemList Do
		Row.ReceiptBasisCurrency = ServiceSystemServer.GetCompositeObjectAttribute(Row.ReceiptBasis, "Currency");
	EndDo;
EndProcedure

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)

	If SessionParameters.isMobile Then
		Return;
	EndIf;

	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
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

Procedure FillTransactionTypeChoiceList(Form)

	Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.Purchase,
		Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.Purchase.Synonym);
	Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.ReturnFromCustomer,
		Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.ReturnFromCustomer.Synonym);
	Form.Items.TransactionType.ChoiceList.Add(Enums.GoodsReceiptTransactionTypes.InventoryTransfer,
		Metadata.Enums.GoodsReceiptTransactionTypes.EnumValues.InventoryTransfer.Synonym);

EndProcedure
