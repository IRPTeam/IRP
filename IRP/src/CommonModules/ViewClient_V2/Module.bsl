
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя

Function GetParameters(Object, Form, Rows = Undefined)
	Parameters = New Structure();
	Parameters.Insert("Object"           , Object);
	Parameters.Insert("Form"             , Form);
	Parameters.Insert("ViewModule"       , ViewClient_V2);
	Parameters.Insert("ControllerModule" , ControllerClientServer_V2);
	If Rows <> Undefined And Rows.Count() Then
		Parameters.Insert("Rows", Rows);
	EndIf;
	Return Parameters;
EndFunction

Function GetRowsByCurrentData(Form, TableName, CurrentData)
	Rows = New Array();
	If CurrentData = Undefined Then
		CurrentData = Form[TableName].CurrentData;
	EndIf;
	If CurrentData <> Undefined Then
		Rows.Add(CurrentData);
	EndIf;
	Return Rows;
EndFunction

Procedure PartnerOnChange(Object, Form) Export
	ControllerClientServer_V2.PartnerOnChange(GetParameters(Object, Form));
EndProcedure

Procedure ItemListPriceTypeOnChange(Object, Form, CurrentData = Undefined) Export
	Rows = GetRowsByCurrentData(Form, "ItemList", CurrentData);
	ControllerClientServer_V2.ItemListPriceTypeOnChange(GetParameters(Object, Form, Rows));
EndProcedure

Procedure OnSetLegalName(Parameters) Export
	// действия с формой при изменении LegalName
	DocumentsClientServer.ChangeTitleGroupTitle(Parameters.Object, Parameters.Form);
EndProcedure

Procedure OnChainComplete(Parameters) Export
	// вся цепочка действий закончена, можно задавать вопросы пользователю, 
	// выводить сообщения и т.п но не моифицировать object
	
	// если ответят положительно или спрашивать не надо, то переносим данные из кэш в объект
	ControllerClientServer_V2.CommitChainChanges(Parameters);
EndProcedure