
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя только чтение

Function GetParameters(Object, Form, Rows = Undefined, PropertyDataPath = Undefined)
	Parameters = New Structure();
	// параметры для Client 
	Parameters.Insert("Object"         , Object);
	Parameters.Insert("Form"           , Form);
	// кэш для реквизитов формы
	Parameters.Insert("FormCache"      , New Structure());
	Parameters.Insert("ViewNotify"     , New Array());
	Parameters.Insert("ViewModuleName" , "ViewClient_V2");
	Parameters.Insert("ObjectPropertyBeforeChange" , Undefined);
	
	// параметры для Client Server
	// кэш для реквизитов объекта
	Parameters.Insert("Cache", New Structure());
	Parameters.Insert("ControllerModuleName" , "ControllerClientServer_V2");
	
	//PropertyDataPath - имя реквизита для которого надо получить значение до изменения
	If PropertyDataPath <> Undefined Then
		CacheBeforeChange = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.CacheBeforeChange);
		
		If Not CacheBeforeChange.CacheObject.Property(PropertyDataPath) Then
			Raise StrTemplate("Property by DataPath [%1] not found in CacheBeforeChange", PropertyDataPath);
		EndIf;
		// значение которое было в реквизите до того как он был изменен
		ObjectValueBeforeChange = CacheBeforeChange.CacheObject[PropertyDataPath];
		ObjectPropertyBeforeChange = New Structure();
		ObjectPropertyBeforeChange.Insert("DataPath"          , PropertyDataPath);
		ObjectPropertyBeforeChange.Insert("ValueBeforeChange" , ObjectValueBeforeChange);
		Parameters.ObjectPropertyBeforeChange = ObjectPropertyBeforeChange;
	EndIf;
	
	// это используется только для ItemList
	If Rows = Undefined Then
		Rows = Object.ItemList;
	EndIf;
		
	// налоги
	ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	Parameters.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
	
	ArrayOfRows = New Array();
	// это имена колонок из ItemList
	ItemListColumns = "Key, ItemKey, PriceType, Price, NetAmount, OffersAmount, TaxAmount, TotalAmount";
	For Each Row In Rows Do
		NewRow = New Structure(ItemListColumns);
		FillPropertyValues(NewRow, Row);
			
		// налоги
		ArrayOfRowsTaxList = New Array();
		TaxListColumns = "Key, Tax, Analytics, TaxRate, Amount, IncludeToTotalAmount, ManualAmount";
		For Each TaxRow In Object.TaxList.FindRows(New Structure("Key", Row.Key)) Do
			NewRowTaxList = New Structure(TaxListColumns);
			FillPropertyValues(NewRowTaxList, TaxRow);
			ArrayOfRowsTaxList.Add(NewRowTaxList);
		EndDo;
			
		TaxRates = New Structure();
		For Each ItemOfTaxInfo In ArrayOfTaxInfo Do
			TaxRates.Insert(ItemOfTaxInfo.Name, Row[ItemOfTaxInfo.Name]);
		EndDo;
		NewRow.Insert("TaxRates", TaxRates);
		NewRow.Insert("TaxList" , ArrayOfRowsTaxList);
			
		ArrayOfRows.Add(NewRow);
	EndDo;
	If ArrayOfRows.Count() Then
		Parameters.Insert("Rows", ArrayOfRows);
	EndIf;
	Return Parameters;
EndFunction

Function GetRowsByCurrentData(Form, TableName, CurrentData)
	Rows = New Array();
	If CurrentData = Undefined Then
		CurrentData = Form.Items[TableName].CurrentData;
	EndIf;
	If CurrentData <> Undefined Then
		Rows.Add(CurrentData);
	EndIf;
	Return Rows;
EndFunction

// хранит значения реквизитов до изменения
Procedure UpdateCacheBeforeChange(Object, Form)
	// реквизиты Object которые нужно кэшировать, для табличных частей не реализовано
	ObjectProperties = "Partner";
	CacheObject = New Structure(ObjectProperties);
	FillPropertyValues(CacheObject, Object);
	
	// реквизиты Form которые нужно кэшировать
	FormProperties = "Store";
	CacheForm = New Structure(FormProperties);
	
	CacheBeforeChange = New Structure("CacheObject, CacheForm", CacheObject, CacheForm);
	Form.CacheBeforeChange = CommonFunctionsServer.SerializeXMLUseXDTO(CacheBeforeChange);
EndProcedure

Procedure OnChainComplete(Parameters) Export
	// вся цепочка действий закончена, можно задавать вопросы пользователю, 
	// выводить сообщения и т.п но не моифицировать object
	
	// тестовый вопрос
	ShowQueryBox(New NotifyDescription("TestQuestionContinue", ThisObject, Parameters),
		"Commit changes ?", QuestionDialogMode.YesNo);
EndProcedure

Procedure TestQuestionContinue(Result, Parameters) Export
	If Result = DialogReturnCode.Yes Then
		// если ответят положительно или спрашивать не надо, то переносим данные из кэш в объект
		ControllerClientServer_V2.CommitChainChanges(Parameters);
		UpdateCacheBeforeChange(Parameters.Object, Parameters.Form);
	EndIf;
EndProcedure

Procedure OnOpen(Object, Form) Export
	UpdateCacheBeforeChange(Object, Form);
EndProcedure

#Region STORE

Procedure StoreOnChange(Object, Form) Export
	Return; // недописано, это реквизит формы
EndProcedure

#EndRegion

#Region PARTNER

Procedure PartnerOnChange(Object, Form) Export
	ControllerClientServer_V2.PartnerOnChange(GetParameters(Object, Form, , "Partner"));
EndProcedure

#EndRegion

#Region LEGAL_NAME

Procedure LegalNameOnChange(Object, Form) Export
	ControllerClientServer_V2.LegalNameOnChange(GetParameters(Object, Form));
EndProcedure

Procedure OnSetLegalNameNotify(Parameters) Export
	// действия с формой при изменении LegalName
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

#EndRegion

#Region PRICE_INCLUDE_TAX

Procedure PriceIncludeTaxOnChange(Object, Form) Export
	ControllerClientServer_V2.PriceIncludeTaxOnChange(GetParameters(Object, Form));
EndProcedure

#EndRegion

#Region ITEM_LIST

Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(GetParameters(Object, Form, Rows));
EndProcedure

Procedure ItemListPriceOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceOnChange(GetParameters(Object, Form, Rows));
EndProcedure

Procedure ItemListTotalAmountOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListTotalAmountOnChange(GetParameters(Object, Form, Rows));
EndProcedure

#Region ITEM_LIST_QUANTITY

Procedure ItemListQuantityOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListQuantityOnChange(GetParameters(Object, Form, Rows));
EndProcedure

Procedure OnSetItemListQuantityNotify(Parameters) Export
	Object = Parameters.Object;
	Form   = Parameters.Form;
	// для Sales Invoice
	SerialLotNumberClient.UpdateSerialLotNumbersTree(Object, Form);
	DocumentsClient.UpdateTradeDocumentsTree(Object, Form, 
	"ShipmentConfirmations", "ShipmentConfirmationsTree", "QuantityInShipmentConfirmation");
EndProcedure

#EndRegion

#EndRegion
