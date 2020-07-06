#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);	
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		
		Form.StoreBeforeChange 		= Form.Store;
		
		DocumentsClientServer.FillDefinedData(Object, Form);

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsServer.FillItemList(Object);
		
		SetGroupItemsList(Object, Form);
		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
	EndIf;
EndProcedure

Procedure OnCreateAtServerMobile(Object, Form, Cancel, StandardProcessing) Export
	
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner = Object.Partner;
		Form.CurrentAgreement = Object.Agreement;
		Form.CurrentDate = Object.Date;
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		DocumentsServer.FillItemList(Object);
	EndIf;
	
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate = CurrentObject.Date;
		
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsServer.FillItemList(Object);
	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner = CurrentObject.Partner;
	
	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);
	
	DocumentsServer.FillItemList(Object);
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	AttributesArray.Add("Status");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
				Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function GetItemRowType(Item) Export
	Return Item.ItemType.Type;
EndFunction

Procedure StoreOnChange(TempStructure) Export
	For Each Row In TempStructure.Object.ItemList Do
		Row.Store = TempStructure.Store;
	EndDo;
EndProcedure

Function GetStoresArray(Val Object) Export
	ReturnValue = New Array;
	TableOfStore = Object.ItemList.Unload( , "Store");
	TableOfStore.GroupBy("Store");
	ReturnValue = TableOfStore.UnloadColumn("Store");
	Return ReturnValue;
EndFunction

Function GetActualStore(Object) Export
	ReturnValue = Catalogs.Stores.EmptyRef();
	If Object.ItemList.Count() = 1 Then
		ReturnValue = Object.AgreementInfo.Store;
	Else
		RowCount = Object.ItemList.Count();
		PreviousRow = Object.ItemList.Get(RowCount - 2);
		ReturnValue = PreviousRow.Store;
	EndIf;
	Return ReturnValue;
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
