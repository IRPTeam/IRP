#Region FORM

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
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
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	
	If Object.TransactionType = Enums.SalesTransactionTypes.RetailSales Then
		AttributesArray.Add("RetailCustomer");
	EndIf;
	
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");	
	
	AttributesArray.Add("Status");
	
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

Function CheckItemList(Object) Export

	Query = New Query();
	//@skip-check bsl-ql-hub
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
	|	AND	NOT ItemList.Store.UseShipmentConfirmation
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
