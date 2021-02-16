
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	ArrayFillingValues = GetArrayOfFillingValues(CommandParameter);
EndProcedure

&AtServer
Function GetArrayOfFillingValues(Basises)
	//Company, Partner, LegalName, Agreement, Currency, PriceIncludeTax, ManagerSegment
	
	BasisesTable = RowIDInfo.GetBasisesFor_SalesInvoice(New Structure("Basises", Basises));
EndFunction