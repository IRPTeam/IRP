
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
	LegalNameParameters.Partner   = GetPropertyValue(Parameters.Cache, Parameters.Object, "Partner");
	LegalNameParameters.LegalName = GetPropertyValue(Parameters.Cache, Parameters.Object, "LegalName");;
	Chain.LegalName.Parameters.Add(LegalNameParameters);
	
	// При изменении партнера нужно изменить Agreement
	Chain.Agreement.NeedChange = True;
	// эти данные (параметры) нужны для получения Agreement
	AgreementParameters = ModelClientServer_V2.AgreementParameters();
	AgreementParameters.Partner       = GetPropertyValue(Parameters.Cache, Parameters.Object, "Partner");
	AgreementParameters.Agreement     = GetPropertyValue(Parameters.Cache, Parameters.Object, "Agreement");
	AgreementParameters.Date          = GetPropertyValue(Parameters.Cache, Parameters.Object, "Date");
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
Procedure SetLegalName(Parameters, Value) Export
	// LegalName находится в шапке поэтому используем 
	If SetPropertyValue(Parameters, Value, "LegalName") Then
		// Обработаем изменение LegalName
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
	CompanyParameters.Agreement = GetPropertyValue(Parameters.Cache, Parameters.Object, "Agreement");
	Chain.Company.Parameters.Add(CompanyParameters);
	
	// При изменении Agreement нужно изменить PriceType
	Chain.PriceType.NeedChange = True;
	// Эти данные (параметры) нужны для получения PriceType
	// PriceType находится в табличной части ItemList, така как это уровень данных то беремиз этой табличной части
	For Each Row In Parameters.Object.ItemList Do
		CompanyParameters = ModelClientServer_V2.CompanyParameters();
		CompanyParameters.Agreement = GetPropertyValue(Parameters.Cache, Parameters.Object, "Agreement");
		// ключ нужен что бы потом, когда вернутся результаты из модуля Model идентифицировать строку,
		// для реквизитов в шапке ключ можно не заполнять, шапка только одна
		CompanyParameters.Key = Row.Key;
		Chain.Company.Parameters.Add(CompanyParameters);
	EndDo;
EndProcedure

Procedure SetAgreement(Parameters, Value) Export
	// Agreement находится в шапке поэтому используем 
	If SetPropertyValue(Parameters, Value, "Agreement") Then
		// Обработаем изменение Agreement
		ModelClientServer_V2.AgreementEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region COMPANY

Procedure SetCompany(Parameters, Value) Export
	// Comapny находится в шапке поэтому используем 
	If SetPropertyValue(Parameters, Value, "Company") Then
		// Обработаем изменение Agreement
		//ModelClientServer_V2.CompanyEntryPoint(Parameters, ThisObject);
	EndIf;
EndProcedure

#EndRegion

#Region PRICE_TYPE

Procedure SetPriceType(Parameters, Value) Export
	// PriceType находится в строке, строку нужно найти использую Parameters.Key
	// дляя все как обычно, устанавливаем значение, переходим на PriceTypeEntryPoint
EndProcedure

#EndRegion

// Вызывается когда вся цепочка связанных действий будет заверщена
Procedure OnChainComplete(Parameters) Export
	#IF Client THEN
		// на клиенте возможно нужно задать вопрос пользователю, поэтому сразу из кэша в объект не переносим
		If Parameters.ClientModule <> Undefined Then
			Parameters.ClientModule.OnChainComplete(Parameters);
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
		Parameters.Object[Property.Key] = Property.Value;
	EndDo;
EndProcedure

Function GetPropertyValue(Cache, Object, PropertyName)
	If Cache.Property(PropertyName) Then
		Return Cache[PropertyName];
	Else
		Return Object[PropertyName];
	EndIf;
EndFunction

// Устанавливает свойства в Object, напрмер Object.Partner или Object.Agreement
// возвращает True если свойство было изменено
Function SetPropertyValue(Parameters, PropertyName, Value)
	If GetPropertyValue(Parameters.Cache, Parameters.Object, PropertyName) = Value Then
		Return False; // Свойство не изменилось
	EndIf;
	// измененные свойства сохраняются в кэш
	Parameters.Cache.Insert(PropertyName, Value);
	
	#IF Client THEN
		If Parameters.ClientModule <> Undefined Then
			// переадресация в клиентский модуль, вызов был с клиента, на форме что то надо обновить
			// в клиентском модуле будет обновлено отображение на форме
			// как пример вызов DocumentsClientServer.ChangeTitleGroupTitle(Object, Form);
			// вопросы пользователю там задавать нельзя
			Parameters.ClientModule.OnSetLegalName(Parameters);
		EndIf;
	#ENDIF
	Return True;
EndFunction

