
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each _row In ThisObject Do
		If ValueIsFilled(_row.AdvancesClosing) Then
			Continue;
		EndIf;
		TotalAmount = _row.CustomerTransaction			 
			  + _row.CustomerAdvance
			  + _row.VendorTransaction
			  + _row.VendorAdvance
			  + _row.OtherTransaction;
		
		If _row.Amount <> TotalAmount Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_PartnerBalanceCheckfailed);	
		EndIf;			  
	EndDo;	
EndProcedure
