Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	If IsNew() Then
	
		RegExpSettings = SerialLotNumbersServer.CheckSerialLotNumberName(ThisObject, Cancel); // See SerialLotNumbersServer.GetRegExpSettings
		If Not RegExpSettings.isMatch Then
			TextError = StrTemplate(R().Error_109, ThisObject.Description, StrConcat(RegExpSettings.Example, Chars.LF));
			CommonFunctionsClientServer.ShowUsersMessage(TextError, "Description");
		EndIf;
	
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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		Return;
	EndIf;
	
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("SerialLotNumberOwner") Then
		ThisObject.StockBalanceDetail = 
			Catalogs.SerialLotNumbers.GetStockBalanceDetailByOwner(FillingData.SerialLotNumberOwner);
	EndIf;
EndProcedure
