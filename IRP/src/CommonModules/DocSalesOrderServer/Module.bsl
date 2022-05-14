#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	ViewServer_V2.OnCreateAtServer(Object, Form, "ItemList");
EndProcedure

// @deprecated
//Procedure OnCreateAtServerMobile(Object, Form, Cancel, StandardProcessing) Export
//	If Form.Parameters.Key.IsEmpty() Then
//		Form.CurrentPartner = Object.Partner;
//		Form.CurrentAgreement = Object.Agreement;
//		Form.CurrentDate = Object.Date;
//
//		ObjectData = DocumentsClientServer.GetStructureFillStores();
//		FillPropertyValues(ObjectData, Object);
//		DocumentsClientServer.FillStores(ObjectData, Form);
//		DocumentsServer.FillItemList(Object);
//	EndIf;
//EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	DocumentsServer.FillItemList(Object);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	DocumentsServer.FillItemList(Object);

	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");	
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function CheckItemList(Object) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	Table.LineNumber As LineNumber,
	|	Table.Store,
	|	Table.ItemKey As ItemKey
	|INTO ItemList
	|FROM
	|	&ItemList AS Table
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ItemList.Store
	|FROM
	|	ItemList AS ItemList
	|Where
	|	ItemList.ItemKey.Item.ItemType.Type = Value(Enum.ItemTypes.Product)
	|	And
	|	Not ItemList.Store.UseShipmentConfirmation
	|GROUP BY
	|	ItemList.Store";

	Query.SetParameter("ItemList", Object.ItemList.Unload());
	QueryResult = Query.Execute();

	If QueryResult.IsEmpty() Then
		Return "";
	EndIf;

	SelectionDetailRecords = QueryResult.Select();

	Stores = "";
	While SelectionDetailRecords.Next() Do
		If Not Stores = "" Then
			Stores = Stores + ", ";
		EndIf;

		Stores = Stores + String(SelectionDetailRecords.Store);
	EndDo;

	Return StrTemplate(R().Error_064, Stores);
EndFunction

// @deprecated
//Function GetItemRowType(Item) Export
//	Return Item.ItemType.Type;
//EndFunction

// @deprecated
//Procedure StoreOnChange(TempStructure) Export
//	For Each Row In TempStructure.Object.ItemList Do
//		Row.Store = TempStructure.Store;
//	EndDo;
//EndProcedure

// @deprecated
//Function GetStoresArray(Val Object) Export
//	ReturnValue = New Array();
//	TableOfStore = Object.ItemList.Unload( , "Store");
//	TableOfStore.GroupBy("Store");
//	ReturnValue = TableOfStore.UnloadColumn("Store");
//	Return ReturnValue;
//EndFunction

// @deprecated
//Function GetActualStore(Object) Export
//	ReturnValue = Catalogs.Stores.EmptyRef();
//	If Object.ItemList.Count() = 1 Then
//		ReturnValue = Object.AgreementInfo.Store;
//	Else
//		RowCount = Object.ItemList.Count();
//		PreviousRow = Object.ItemList.Get(RowCount - 2);
//		ReturnValue = PreviousRow.Store;
//	EndIf;
//	Return ReturnValue;
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
