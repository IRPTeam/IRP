
// VIEW
// 
// В ЭТОМ МОДУЛЕ ТОЛЬКО МОДИФИКАЦИЯ ФОРМЫ, ВПРОСЫ ПОЛЬЗОВАТЕЛЮ и прочие клиентские вещи
// ДЕЛАТЬ ИЗМЕНЕНИЯ объекта нельзя

Procedure PartnerOnChange(Object, Form) Export
	Parameters = New Structure();
	Parameters.Insert("Object"       , Object);
	Parameters.Insert("Form"         , Form);
	Parameters.Insert("ClientModule" , ThisObject);
	ControllerClientServer_V2.PartnerOnChange(Parameters);
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