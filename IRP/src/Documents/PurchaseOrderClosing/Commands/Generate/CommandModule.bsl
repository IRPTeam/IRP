&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PurchaseOrderClosingRef = DocOrderClosingServer.GetClosingByPurchaseOrder(CommandParameter);
	If ValueIsFilled(PurchaseOrderClosingRef) Then
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("Key", PurchaseOrderClosingRef), , New UUID());
	Else
		FillingValues = DocOrderClosingServer.GetDataFromPurchaseOrder(CommandParameter);
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;
EndProcedure
