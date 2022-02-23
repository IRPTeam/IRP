#Region FormEvents

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner    = Object.Partner;
		Form.CurrentAgreement  = Object.Agreement;
		Form.CurrentDate       = Object.Date;
		Form.StoreBeforeChange = Form.Store;

		DocumentsClientServer.FillDefinedData(Object, Form);

		SetGroupItemsList(Object, Form);
		DocumentsServer.FillItemList(Object);

		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);

		DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		DocumentsServer.FillSpecialOffersCache(Object, Form, "PurchaseInvoice");
	EndIf;
	Form.Taxes_CreateFormControls();
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;

	DocumentsServer.FillItemList(Object);

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	DocumentsServer.FillSpecialOffersCache(Object, Form, "PurchaseInvoice");
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure OnReadAtServer(Object, Form, CurrentObject) Export
	Form.CurrentPartner   = CurrentObject.Partner;
	Form.CurrentAgreement = CurrentObject.Agreement;
	Form.CurrentDate      = CurrentObject.Date;

	DocumentsServer.FillItemList(Object);

	ObjectData = DocumentsClientServer.GetStructureFillStores();
	FillPropertyValues(ObjectData, CurrentObject);
	DocumentsClientServer.FillStores(ObjectData, Form);

	If Not Form.GroupItems.Count() Then
		SetGroupItemsList(Object, Form);
	EndIf;
	DocumentsClientServer.ChangeTitleGroupTitle(CurrentObject, Form);
	Form.Taxes_CreateFormControls();
	DocumentsServer.FillSpecialOffersCache(Object, Form, "PurchaseInvoice");
	RowIDInfoServer.OnReadAtServer(Object, Form, CurrentObject);
EndProcedure

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

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array();
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Attr In AttributesArray Do
		Form.GroupItems.Add(Attr, ?(ValueIsFilled(Form.Items[Attr].Title), Form.Items[Attr].Title,
			Object.Ref.Metadata().Attributes[Attr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion