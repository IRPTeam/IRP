
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)

EndProcedure

&AtServer
Procedure GetArrayOfFillingValues(Basises)
	//Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax, ManagerSegment
	
	BasisesTable = RowIDInfo.GetBasisesForSalesInvoice(New Structure("Basises", Basises));
EndProcedure