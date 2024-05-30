// @strict-types

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	If Not ThisObject.EachSerialLotNumberIsUnique Then
		ThisObject.SourceOfOrigin = Catalogs.SourceOfOrigins.EmptyRef();	
	EndIf;	
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If IsNew() Then
		RegExpSettings = SerialLotNumbersServer.CheckSerialLotNumberName(ThisObject, Cancel); // See SerialLotNumbersServer.GetRegExpSettings
		If Not RegExpSettings.isMatch Then
			TextError = StrTemplate(R().Error_109, ThisObject.Description, StrConcat(RegExpSettings.Example, Chars.LF));
			CommonFunctionsClientServer.ShowUsersMessage(TextError, "Description");
		EndIf;
		
		Duplicates = SerialLotNumbersServer.CheckSerialLotNumberUnique(ThisObject, Cancel);
		If Duplicates.Count() Then
			TextError = StrTemplate(R().Error_136, StrConcat(Duplicates.UnloadColumn("Code")));
			CommonFunctionsClientServer.ShowUsersMessage(TextError, "Description");
		EndIf;
	EndIf;
	
	CheckDataPrivileged.FillCheckProcessing_Catalog_SerialLotNumbers(Cancel, ThisObject);
EndProcedure
