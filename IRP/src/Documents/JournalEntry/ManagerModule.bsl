
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Basis");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = Data.Basis;
EndProcedure

Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	Return QueryArray;
EndFunction

