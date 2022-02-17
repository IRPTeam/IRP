#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		DocumentsServer.FillItemList(Object, Form);

		//ObjectData = DocumentsClientServer.GetStructureFillStores();
		//FillPropertyValues(ObjectData, Object);
		//DocumentsClientServer.FillStores(ObjectData, Form);

		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	FillTransactionTypeChoiceList(Form);
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object, Form);

	//ObjectData = DocumentsClientServer.GetStructureFillStores();
	//FillPropertyValues(ObjectData, CurrentObject);
	//DocumentsClientServer.FillStores(ObjectData, Form);

	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object, Form);

	//ObjectData = DocumentsClientServer.GetStructureFillStores();
	//FillPropertyValues(ObjectData, CurrentObject);
	//DocumentsClientServer.FillStores(ObjectData, Form);

	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
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

//Function PutQueryTableToTempTable(QueryTable) Export
//	QueryTable.Columns.Add("Key", New TypeDescription(Metadata.DefinedTypes.typeRowID.Type));
//	For Each Row In QueryTable Do
//		Row.Key = Row.RowKey;
//	EndDo;
//	tempManager = New TempTablesManager();
//	Query = New Query();
//	Query.TempTablesManager = tempManager;
//	Query.Text =
//	"SELECT
//	|	QueryTable.Store,
//	|	QueryTable.ShipmentBasis,
//	|	QueryTable.Currency,
//	|   QueryTable.ItemKey,
//	|   QueryTable.Unit,
//	|	QueryTable.Quantity,
//	|   QueryTable.Key,
//	|   QueryTable.RowKey
//	|INTO tmpQueryTable
//	|FROM
//	|	&QueryTable AS QueryTable";
//
//	Query.SetParameter("QueryTable", QueryTable);
//	Query.Execute();
//	Return tempManager;
//EndFunction

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
	EnumValues   = Enums.ShipmentConfirmationTransactionTypes;
	EnumMetadata = Metadata.Enums.ShipmentConfirmationTransactionTypes.EnumValues;
	
	Form.Items.TransactionType.ChoiceList.Add(EnumValues.Sales             , EnumMetadata.Sales.Synonym);
	Form.Items.TransactionType.ChoiceList.Add(EnumValues.ReturnToVendor    , EnumMetadata.ReturnToVendor.Synonym);
	Form.Items.TransactionType.ChoiceList.Add(EnumValues.InventoryTransfer , EnumMetadata.InventoryTransfer.Synonym);
EndProcedure
