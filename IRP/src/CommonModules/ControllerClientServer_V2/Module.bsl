
// CONTROLLER
// 
// ОБЩИЙ МОДУЛЬ ДЛЯ SalesInvoice и всех кто с него скопирован - уровень Данные (линковка бизнес логики со структурой документа)
// никаких запросов к БД и расчетов тут делать нельзя, модифицировать форму задавать вопросы пользователю и т.д нельзя 
// только чтение из объекта и запись в объект

#Region PARTNER

// Client Event handler, вызывается из модуля ViewClient_V2
Procedure PartnerOnChange(Parameters) Export
	ModelClientServer_V2.PartnerEntryPoint(Parameters, ThisObject);
EndProcedure

Procedure PartnerEventChain(Parameters, Chain) Export
	// При изменении партнера нужно изменить LegalName
	Chain.LegalName.NeedChange = True;
	// эти данные (параметры) нужны для получения LegalName
	LegalNameParameters = ModelClientServer_V2.LegalNameParameters();
	LegalNameParameters.Partner   = GetProperty(Parameters.Cache, Parameters.Object, "Partner");
	LegalNameParameters.LegalName = GetProperty(Parameters.Cache, Parameters.Object, "LegalName");;
	Chain.LegalName.Parameters.Add(LegalNameParameters);
	
	// При изменении партнера нужно изменить Agreement
	Chain.Agreement.NeedChange = True;
	// эти данные (параметры) нужны для получения Agreement
	AgreementParameters = ModelClientServer_V2.AgreementParameters();
	AgreementParameters.Partner       = GetProperty(Parameters.Cache, Parameters.Object, "Partner");
	AgreementParameters.Agreement     = GetProperty(Parameters.Cache, Parameters.Object, "Agreement");
	AgreementParameters.Date          = GetProperty(Parameters.Cache, Parameters.Object, "Date");
	AgreementParameters.AgreementType = PredefinedValue("Enum.AgreementTypes.Customer");
	Chain.Agreement.Parameters.Add(AgreementParameters);
EndProcedure

//Function SetPartner(Object, Value) Export
//	#IF Client THEN
//		// можно задавать вопросы пользователю, управлять видимостью доступностью элемнтов формы
//		// нужна переадресация в клиентский модуль
//	#ENDIF
//	Return False;
//EndFunction

#EndRegion

#Region LEGAL_NAME

// Client Event handler вызывается из модуля ViewClient_V2
Procedure LegalNameOnChange(Parameters) Export
	ModelClientServer_V2.LegalNameEntryPoint(Parameters, ThisObject);
EndProcedure

Procedure LegalNameEventChain(Parameters, Chain) Export
	// При изменении LegalName никакие другие реквизиты не меняются, цепочки нет
	Return;
EndProcedure

// Setter
Procedure SetLegalName(Parameters, Results) Export
	// LegalName находится в шапке поэтому используем DataPath = LegalName
	IsChanged = False;
	For Each Result In Results Do
		If SetProperty(Parameters, Result, "LegalName") Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
		#IF Client THEN
			If Parameters.ViewModule <> Undefined Then
				// переадресация в клиентский модуль, вызов был с клиента, на форме что то надо обновить
				 Parameters.ViewModule.OnSetLegalName(Parameters);
			EndIf;
		#ENDIF
		ModelClientServer_V2.LegalNameEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region AGREEMENT

// Client Event handler вызывается из модуля ViewClient_V2
Procedure AgreementOnChange(Parameters) Export
	ModelClientServer_V2.AgreementEntryPoint(Parameters, ThisObject);
EndProcedure

Procedure AgreementEventChain(Parameters, Chain) Export
	// При изменении Agreement нужно изменить Company
	Chain.Company.NeedChange = True;
	// Эти данные (параметры) нужны для получения Company
	CompanyParameters = ModelClientServer_V2.CompanyParameters();
	CompanyParameters.Agreement = GetProperty(Parameters.Cache, Parameters.Object, "Agreement");
	Chain.Company.Parameters.Add(CompanyParameters);
	
	// При изменении Agreement нужно изменить PriceType
	Chain.PriceType.NeedChange = True;
	// Эти данные (параметры) нужны для получения PriceType
	// PriceType находится в табличной части ItemList, така как это уровень данных то беремиз этой табличной части
	For Each Row In Parameters.Object.ItemList Do
		PriceTypeParameters = ModelClientServer_V2.PriceTypeParameters();
		PriceTypeParameters.Agreement = GetProperty(Parameters.Cache, Parameters.Object, "Agreement");
		// ключ нужен что бы потом, когда вернутся результаты из модуля Model идентифицировать строку,
		// для реквизитов в шапке ключ можно не заполнять, шапка только одна
		PriceTypeParameters.Key = Row.Key;
		Chain.PriceType.Parameters.Add(PriceTypeParameters);
	EndDo;
EndProcedure

Procedure SetAgreement(Parameters, Results) Export
	// Agreement находится в шапке поэтому используем DataPath = Agreement 
	IsChanged = False;
	For Each Result In Results Do
		If SetProperty(Parameters, Result, "Agreement") Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
		ModelClientServer_V2.AgreementEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region COMPANY

Procedure SetCompany(Parameters, Results) Export
	// Comapny находится в шапке поэтому используем DataPath = Company
	IsChanged = False;
	For Each Result In Results Do
		If SetProperty(Parameters, Result, "Company") Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
		//ModelClientServer_V2.CompanyEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region ITEM_LIST_PRICE_TYPE

// Устанавливает PriceType в табличную часть ItemList
Procedure SetPriceType(Parameters, Results) Export
	IsChanged = False;
	For Each Result In Results Do
		If SetProperty(Parameters, Result, "ItemList.PriceType") Then
			IsChanged = True;
		EndIf;
	EndDo;
	If IsChanged Then
	//ModelClientServer_V2.PriceTypeEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

// Вызывается когда вся цепочка связанных действий будет заверщена
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// на клиенте возможно нужно задать вопрос пользователю, поэтому сразу из кэша в объект не переносим
		If Parameters.ViewModule <> Undefined Then
			Parameters.ViewModule.OnChainComplete(Parameters);
		EndIf;
	#ENDIF
	
	#IF Server THEN
		// на сервере спрашивать некого, сразу переносим из кэша в объект
		CommitChainChanges(Parameters);
	#ENDIF
EndProcedure

// Переносит изменения из Cache в Object
Procedure CommitChainChanges(Parameters) Export
	For Each Property In Parameters.Cache Do
		If TypeOf(Property.Value) = Type("Array") Then // это табличная часть
			For Each Row In Property.Value Do
				FillPropertyValues(Parameters.Object[Property.Key].FindRows(New Structure("Key", Row.Key))[0], Row);
			EndDo;
		Else
			Parameters.Object[Property.Key] = Property.Value; // это реквизит шапки
		EndIf;
	EndDo;
EndProcedure

// параметр Key используется когда DataPath указывает на реквизит табличной части, например ItemList.PriceType
Function GetProperty(Cache, Object, DataPath, Key = Undefined)
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		If Cache.Property(DataPath) Then
			Return Cache[DataPath];
		Else
			Return Object[DataPath];
		EndIf;
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		
		RowByKey = Undefined;
		If Cache.Property(TableName) Then
			For Each Row In Cache[TableName] Do
				If Row.Key = Key Then
					RowByKey = Row;
				EndIf;
			EndDo;
		EndIf;
		If RowByKey = Undefined Then
			RowByKey = Object[TableName].FindRows(New Structure("Key", Key))[0];
		EndIf;
		Return RowByKey[ColumnName];
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;
EndFunction

// Устанавливает свойства по переданному DataPath, например ItemList.PriceType или Company
// возвращает True если хотябы одно свойство было изменено
Function SetProperty(Parameters, Result, DataPath)
	// что бы получить значение из коллекции нужно искать его по ключу
	_Key   = Result.Parameters.Key;
	_Value = Result.Value;
	If GetProperty(Parameters.Cache, Parameters.Object, DataPath, _Key) = _Value Then
		Return False; // Свойство не изменилось
	EndIf;
	// измененные свойства сохраняются в кэш
	Segments = StrSplit(DataPath, ".");
	If Segments.Count() = 1 Then // это реквизит шапки, он указывается без точки, например Company
		Parameters.Cache.Insert(DataPath, _Value);
	ElsIf Segments.Count() = 2 Then // это реквизит табличной части, состоит из двух частей разделенных точкой ItemList.PriceType
		TableName = Segments[0];
		ColumnName = Segments[1];
		If Not Parameters.Cache.Property(TableName) Then
			Parameters.Cache.Insert(TableName, New Array());
		EndIf;
		NewRow = New Structure();
		NewRow.Insert("Key"      , _Key);
		NewRow.Insert(ColumnName , _Value);
		Parameters.Cache[TableName].Add(NewRow);
	Else
		// реквизитов с таким путем не бывает
		Raise StrTemplate("Wrong data path [%1]", DataPath);
	EndIf;	
	Return True;
EndFunction


