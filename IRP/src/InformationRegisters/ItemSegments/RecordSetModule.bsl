
Procedure BeforeWrite(Cancel, Replacing)
	
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each RecordRow In ThisObject Do
		If RecordRow.Item.IsEmpty() And Not RecordRow.ItemKey.IsEmpty() Then
			RecordRow.Item = CommonFunctionsServer.GetRefAttribute(RecordRow.ItemKey, "Item");
			ThisObject.Filter.Item.Use = False;
		EndIf;
	EndDo;

EndProcedure
