
Procedure BeforeWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	
	For Each _row In ThisObject Do
		_row.Amount = 
			  _row.CustomerTransaction 
			  + _row.CustomerAdvance
			  + _row.VendorTransaction
			  + _row.VendorAdvance
			  + _row.OtherTransaction;
	EndDo;	
EndProcedure
