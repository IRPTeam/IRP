
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя только чтение

Function GetParameters(Object, Form, Rows = Undefined, ObjectPropertyDataPath = Undefined, FormPropertyDataPath = Undefined)
	Parameters = New Structure();
	// параметры для Client 
	Parameters.Insert("Object"         , Object);
	Parameters.Insert("Form"           , Form);
	Parameters.Insert("CacheForm"      , New Structure()); // кэш для реквизитов формы
	Parameters.Insert("ViewNotify"     , New Array());
	Parameters.Insert("ViewModuleName" , "ViewClient_V2");
	
	Parameters.Insert("ObjectPropertyNamesBeforeChange" , GetObjectPropertyNamesBegoreChange());
	Parameters.Insert("ObjectPropertyBeforeChange"      , Undefined);
	
	Parameters.Insert("FormPropertyNamesBeforeChange"   , GetFormPropertyNamesBegoreChange());
	Parameters.Insert("FormPropertyBeforeChange"        , Undefined);
	
	// параметры для Server + Client
	// кэш для реквизитов объекта
	Parameters.Insert("Cache", New Structure());
	Parameters.Insert("ControllerModuleName" , "ControllerClientServer_V2");
	
	//PropertyDataPath - имя реквизита для которого надо получить значение до изменения
	If ObjectPropertyDataPath <> Undefined Or FormPropertyDataPath <> Undefined Then
		CacheBeforeChange = CommonFunctionsServer.DeserializeXMLUseXDTO(Form.CacheBeforeChange);
		If ObjectPropertyDataPath <> Undefined Then
			Parameters.ObjectPropertyBeforeChange = GetCacheBeforeChange(CacheBeforeChange.CacheObject, ObjectPropertyDataPath);
		EndIf;
		If FormPropertyDataPath <> Undefined Then
			Parameters.FormPropertyBeforeChange = GetCacheBeforeChange(CacheBeforeChange.CacheForm, FormPropertyDataPath);
		EndIf;
	EndIf;
	
	// налоги
	ArrayOfTaxInfo = TaxesClient.GetArrayOfTaxInfo(Form);
	Parameters.Insert("ArrayOfTaxInfo", ArrayOfTaxInfo);
	
	ArrayOfRows = New Array();
	// это имена колонок из ItemList
	ColumnNames    = ViewServer_V2.GetColumnsOfTable(Object, "ItemList, TaxList");
	TableColumns   = ColumnNames[0];
	TaxListColumns = ColumnNames[1];
	
	// если не переданы конкретные строки то используем все что естьв таблице, реализовано только для ItemList
	Rows = ?(Rows = Undefined, Object.ItemList, Rows);
	
	// строку таблицы нельзя передать на сервер, поэтому помещаем данные в массив структур
	For Each Row In Rows Do
		NewRow = New Structure(TableColumns);
		FillPropertyValues(NewRow, Row);
		ArrayOfRows.Add(NewRow);
		
		// налоги
		ArrayOfRowsTaxList = New Array();
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

Function GetCacheBeforeChange(Cache, DataPath)
	If Not Cache.Property(DataPath) Then
		Raise StrTemplate("Property by DataPath [%1] not found in CacheBeforeChange", DataPath);
	EndIf;
	// значение которое было в реквизите до того как он был изменен
	ValueBeforeChange = Cache[DataPath];
	Return New Structure("DataPath, ValueBeforeChange", DataPath, ValueBeforeChange);
EndFunction

// возвращает список реквизитов объекта для которых нужно получить значение до изменения
Function GetObjectPropertyNamesBegoreChange()
	Return "Partner";
EndFunction

// возвращает список реквизитов формы для которых нужно получить значение до изменения
Function GetFormPropertyNamesBegoreChange()
	Return "Store";
EndFunction

// хранит значения реквизитов до изменения
Procedure UpdateCacheBeforeChange(Object, Form)
	// реквизиты Object которые нужно кэшировать, для табличных частей не реализовано
	CacheObject = New Structure(GetObjectPropertyNamesBegoreChange());
	FillPropertyValues(CacheObject, Object);
	
	// реквизиты Form которые нужно кэшировать
	CacheForm = New Structure(GetFormPropertyNamesBegoreChange());
	FillPropertyValues(CacheForm, Form);
	
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

#Region FORM

Procedure OnOpen(Object, Form) Export
	UpdateCacheBeforeChange(Object, Form);
EndProcedure

#EndRegion

#Region STORE

Procedure StoreOnChange(Object, Form) Export
	ControllerClientServer_V2.StoreOnChange(GetParameters(Object, Form, , , "Store"));
EndProcedure

Procedure OnSetStoreNotify(Parameters) Export
	StoreArray = New Array();
	For Each Row In Parameters.Object.ItemList Do
		If ValueIsFilled(Row.Store) And StoreArray.Find(Row.Store) = Undefined Then
			StoreArray.Add(Row.Store);
		EndIf;
	EndDo;
	If StoreArray.Count() > 1 Then
		Parameters.Form.Items.Store.InputHint = StrConcat(StoreArray, "; ");
	EndIf;
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

Procedure ItemListStoreOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListStoreOnChange(GetParameters(Object, Form, Rows));
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
