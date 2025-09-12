
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.QueryText = LocalizationEvents.ReplaceDescriptionLocalizationPrefix(ThisObject.List.QueryText);
	ChartsOfCharacteristicTypesServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure OpenForm_CheckBalance(UniqueID)
	FillingData = New Structure();
	FillingData.Insert("UniqueID", UniqueID);
	FillingData.Insert("IsCommon", True);
	FillingData.Insert("ValueType", New TypeDescription("Boolean"));
	OpenForm("ChartOfCharacteristicTypes.CustomUserSettings.ObjectForm", New Structure("FillingValues", FillingData), , New UUID());	
EndProcedure

&AtClient
Procedure Template_R4050B_StockInventory(Command)
	OpenForm_CheckBalance("CheckBalance_R4050B_StockInventory");
EndProcedure

&AtClient
Procedure Template_R6080T_OtherPeriodsRevenues(Command)
	OpenForm_CheckBalance("CheckBalance_R6080T_OtherPeriodsRevenues");
EndProcedure

&AtClient
Procedure Template_R6070T_OtherPeriodsExpenses(Command)
	OpenForm_CheckBalance("CheckBalance_R6070T_OtherPeriodsExpenses");
EndProcedure

&AtClient
Procedure Template_R4037B_PlannedReceiptReservationRequests(Command)
	OpenForm_CheckBalance("CheckBalance_R4037B_PlannedReceiptReservationRequests");
EndProcedure

&AtClient
Procedure Template_R4036B_IncomingStocksRequested(Command)
	OpenForm_CheckBalance("CheckBalance_R4036B_IncomingStocksRequested");
EndProcedure

&AtClient
Procedure Template_R4035B_IncomingStocks(Command)
	OpenForm_CheckBalance("CheckBalance_R4035B_IncomingStocks");
EndProcedure

&AtClient
Procedure Template_R4014B_SerialLotNumber(Command)
	OpenForm_CheckBalance("CheckBalance_R4014B_SerialLotNumber");
EndProcedure

&AtClient
Procedure Template_R4011B_FreeStocks(Command)
	OpenForm_CheckBalance("CheckBalance_R4011B_FreeStocks");
EndProcedure

&AtClient
Procedure Template_R4010B_ActualStocks(Command)
	OpenForm_CheckBalance("CheckBalance_R4010B_ActualStocks");
EndProcedure

&AtClient
Procedure Template_R3010B_CashOnHand(Command)
	OpenForm_CheckBalance("CheckBalance_R3010B_CashOnHand");
EndProcedure
