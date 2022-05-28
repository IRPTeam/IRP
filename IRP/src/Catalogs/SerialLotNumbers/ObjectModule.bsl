// @strict-types

Procedure BeforeWrite(Cancel)
	If DataExchange.Load Then
		Return;
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

// Filling.
// 
// Parameters:
//  FillingData - Structure:
//  * SerialLotNumberOwner - Undefined, CatalogRef.ItemKeys, CatalogRef.Items, CatalogRef.ItemTypes - 
//  FillingText - String, Undefined - Filling text
//  StandardProcessing - Boolean - Standard processing
Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		Return;
	EndIf;
	
	If TypeOf(FillingData) = Type("Structure") And FillingData.Property("SerialLotNumberOwner") Then
		ThisObject.StockBalanceDetail = 
			Catalogs.SerialLotNumbers.GetStockBalanceDetailByOwner(FillingData.SerialLotNumberOwner);
	EndIf;
EndProcedure


Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	If IsNew() Then
		RegExpSettings = SerialLotNumbersServer.CheckSerialLotNumberName(ThisObject, Cancel); // See SerialLotNumbersServer.GetRegExpSettings
		If Not RegExpSettings.isMatch Then
			TextError = StrTemplate(R().Error_109, ThisObject.Description, StrConcat(RegExpSettings.Example, Chars.LF));
			CommonFunctionsClientServer.ShowUsersMessage(TextError, "Description");
		EndIf;
	EndIf;
	
	If Not IsNew() And Ref.StockBalanceDetail And Not ThisObject.StockBalanceDetail Then
		If SerialLotNumbersServer.isAnyMovementBySerial(Ref) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_110, "StockBalanceDetail");
		EndIf;
	EndIf;
	
EndProcedure
