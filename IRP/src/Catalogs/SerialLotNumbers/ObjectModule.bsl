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

Procedure Filling(FillingData, FillingText, StandardProcessing)
	If FillingData = Undefined Then
		Return;
	EndIf;
	
	If TypeOf(FillingData) = Type("Structure") 
		And FillingData.Property("SerialLotNumberOwner") 
		And ValueIsFilled(FillingData.SerialLotNumberOwner) Then
		
		_StockBalanceDetail = Undefined;
		If TypeOf(FillingData.SerialLotNumberOwner) = Type("CatalogRef.ItemKeys") Then
			_StockBalanceDetail = FillingData.SerialLotNumberOwner.Item.ItemType.StockBalanceDetail;
		ElsIf TypeOf(FillingData.SerialLotNumberOwner) = Type("CatalogRef.Items") Then
			_StockBalanceDetail = FillingData.SerialLotNumberOwner.ItemType.StockBalanceDetail;
		ElsIf TypeOf(FillingData.SerialLotNumberOwner) = Type("CatalogRef.ItemTypes") Then
			_StockBalanceDetail = FillingData.SerialLotNumberOwner.StockBalanceDetail;
		EndIf;
		ThisObject.StockBalanceDetail = _StockBalanceDetail = Enums.StockBalanceDetail.BySerialLotNumber;
	EndIf;
EndProcedure
