#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocSalesOrderServer.OnCreateAtServerListForm(ThisObject, Cancel, StandardProcessing);
EndProcedure

#EndRegion