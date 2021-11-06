#Region FormEvents

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
	RowIDInfoServer.AfterWriteAtServer(Object, Form, CurrentObject, WriteParameters);
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	//
	ViewServer_V2.OnCreateAtServer(Object, Form);
	//
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
	EndIf;
	Form.Taxes_CreateFormControls();
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
	RowIDInfoServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
EndProcedure

Procedure CalculateTableAtServer(Form, Object) Export
	If Form.Parameters.FillingValues.Property("BasedOn") Then

		If ValueIsFilled(Object.Agreement) Then

			CalculationSettings = CalculationStringsClientServer.GetCalculationSettings();
			PriceDate = CalculationStringsClientServer.GetSliceLastDateByRefAndDate(Object.Ref, Object.Date);
			CalculationSettings.Insert("UpdatePrice", New Structure("Period, PriceType", PriceDate,
				Object.Agreement.PriceType));

			CalculateRows = New Array();

			For Each Row In Object.ItemList Do
				ArrayOfShipmentConfirmations = Object.ShipmentConfirmations.FindRows(New Structure("Key", Row.Key));
				If ArrayOfShipmentConfirmations.Count() And Not ValueIsFilled(Row.SalesOrder) Then
					CalculateRows.Add(Row);
				EndIf;
			EndDo;

			SavedData = TaxesClientServer.GetTaxesCache(Form);
			If SavedData.Property("ArrayOfTaxInfo") Then
				ArrayOfTaxInfo = SavedData.ArrayOfTaxInfo;
			EndIf;
			CalculationStringsClientServer.CalculateItemsRows(Object, Form, CalculateRows, CalculationSettings, ArrayOfTaxInfo);

		EndIf;
	EndIf;
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
	AttributesArray.Add("LegalNameContract");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title), Form.Items[Atr].Title,
			Object.Ref.Metadata().Attributes[Atr].Synonym + ":" + Chars.NBSp));
	EndDo;
EndProcedure

#EndRegion

Function GetManagerSegmentByPartner(Partner) Export
	Return Partner.ManagerSegment;
EndFunction

Procedure StoreOnChange(TempStructure) Export
	For Each Row In TempStructure.Object.ItemList Do
		Row.Store = TempStructure.Store;
	EndDo;
EndProcedure

Function GetStoresArray(Val Object) Export
	ReturnValue = New Array();
	TableOfStore = Object.ItemList.Unload( , "Store");
	TableOfStore.GroupBy("Store");
	ReturnValue = TableOfStore.UnloadColumn("Store");
	Return ReturnValue;
EndFunction

Function GetActualStore(Object) Export
	ReturnValue = Catalogs.Stores.EmptyRef();
	If Object.ItemList.Count() = 0 Then
		Return ReturnValue;
	ElsIf Object.ItemList.Count() = 1 Then
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