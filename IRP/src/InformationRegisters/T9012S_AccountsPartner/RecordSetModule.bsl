
Procedure OnWrite(Cancel, Replacing)
	If DataExchange.Load Then
		Return;
	EndIf;
	RefreshReusableValues();
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	
	For Each Record In ThisObject Do
		
		If Record.Vendor Then
			CheckedAttributes.Add("AccountAdvancesVendor");
			CheckedAttributes.Add("AccountTransactionsVendor");
		EndIf;
		
		If Record.Customer Then
			CheckedAttributes.Add("AccountAdvancesCustomer");
			CheckedAttributes.Add("AccountTransactionsCustomer");
		EndIf;
		
		If Record.Other Then
			CheckedAttributes.Add("AccountTransactionsOther");
		EndIf;
		
		CheckAccountNotUseForRecords("AccountAdvancesVendor"       , Record, Cancel);
		CheckAccountNotUseForRecords("AccountTransactionsVendor"   , Record, Cancel);
		CheckAccountNotUseForRecords("AccountAdvancesCustomer"     , Record, Cancel);
		CheckAccountNotUseForRecords("AccountTransactionsCustomer" , Record, Cancel);
		CheckAccountNotUseForRecords("AccountTransactionsOther"    , Record, Cancel);
				
	EndDo;
EndProcedure

Procedure CheckAccountNotUseForRecords(ResourceName, Record, Cancel)
	If ValueIsFilled(Record[ResourceName]) And Record[ResourceName].NotUsedForRecords Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().AccountingError_01, Record[ResourceName].Code), 
			ResourceName, ThisObject);
	EndIf;
EndProcedure

