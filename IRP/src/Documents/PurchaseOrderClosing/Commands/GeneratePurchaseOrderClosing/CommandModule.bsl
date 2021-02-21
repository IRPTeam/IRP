
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	Param = New Structure();
	POC = DocPurchaseOrderServer.GetLastPurchaseOrderClosingByPurchaseOrder(CommandParameter);
	If Not POC.IsEmpty() Then
		Param.Insert("Key", POC);
	Else
		Param.Insert("FillingValues", New Structure("PurchaseOrder", CommandParameter));
	EndIf;
	
	OpenForm("Document.PurchaseOrderClosing.ObjectForm", Param, , New UUID())
EndProcedure
