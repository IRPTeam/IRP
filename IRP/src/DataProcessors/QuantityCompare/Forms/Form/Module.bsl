
#Region Commands

&AtClient
Procedure SearchByBarcode(Command)
	DocumentsClient.SearchByBarcode(Command, Object, ThisObject, DocumentsClient);
EndProcedure

&AtClient
Procedure OpenPickupItems(Command)
	DocSalesOrderClient.OpenPickupItems(Object, ThisObject, Command);
EndProcedure

#EndRegion