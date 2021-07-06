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
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
EndProcedure

Procedure BeforeWrite(Object, Form, Cancel, WriteMode, PostingMode) Export
	Return;
EndProcedure

Procedure OnCreateAtServer(Object, Form, Cancel, StandardProcessing) Export
	DocumentsServer.OnCreateAtServer(Object, Form, Cancel, StandardProcessing);
	If Form.Parameters.Key.IsEmpty() Then
		Form.CurrentPartner    = Object.Partner;
		Form.CurrentAgreement  = Object.Agreement;
		Form.CurrentDate       = Object.Date;
		Form.StoreBeforeChange = Form.Store;
		
		DocumentsClientServer.FillDefinedData(Object, Form);
		
		ObjectData = DocumentsClientServer.GetStructureFillStores();
		FillPropertyValues(ObjectData, Object);
		DocumentsClientServer.FillStores(ObjectData, Form);
		
		DocumentsServer.FillItemList(Object);
		If Form.Items.Find("GroupTitleDecorations") <> Undefined Then
			SetGroupItemsList(Object, Form);
			DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
		EndIf;
	EndIf;
	Form.Taxes_CreateFormControls();
	DocumentsServer.ShowUserMessageOnCreateAtServer(Form);
EndProcedure

Procedure CalculateTableAtServer(Form, Object) Export
	If Form.Parameters.FillingValues.Property("BasedOn")Then
		
		If ValueIsFilled(Object.Agreement) Then
			
			CalculationSettings = CalculationStringsClientServer.GetCalculationSettings();
			PriceDate = CalculationStringsClientServer.GetPriceDateByRefAndDate(Object.Ref, Object.Date);
			CalculationSettings.Insert("UpdatePrice", 
							New Structure("Period, PriceType", PriceDate, Object.Agreement.PriceType));
			
			CalculateRows = New Array();
			
			For Each Row In Object.ItemList Do
				If ValueIsFilled(Row.ShipmentConfirmation) And Not ValueIsFilled(Row.SalesOrder) Then
					CalculateRows.Add(Row);
				EndIf;
			EndDo;
			
			SavedData = TaxesClientServer.GetSavedData(Form, TaxesServer.GetAttributeNames().CacheName);
			If SavedData.Property("ArrayOfColumnsInfo") Then
				TaxInfo = SavedData.ArrayOfColumnsInfo;
			EndIf;	
			CalculationStringsClientServer.CalculateItemsRows(Object, Form, CalculateRows, CalculationSettings, TaxInfo);
		
		EndIf;
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
	CurrenciesServer.UpdateRatePresentation(Object);
	CurrenciesServer.SetVisibleCurrenciesRow(Object, Undefined, True);
	Form.Taxes_CreateFormControls();
EndProcedure

#EndRegion

#Region GroupTitle

Procedure SetGroupItemsList(Object, Form)
	AttributesArray = New Array;
	AttributesArray.Add("Company");
	AttributesArray.Add("Partner");
	AttributesArray.Add("LegalName");
	AttributesArray.Add("Agreement");
	DocumentsServer.DeleteUnavailableTitleItemNames(AttributesArray);
	For Each Atr In AttributesArray Do
		Form.GroupItems.Add(Atr, ?(ValueIsFilled(Form.Items[Atr].Title),
				Form.Items[Atr].Title,
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
	ReturnValue = New Array;
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