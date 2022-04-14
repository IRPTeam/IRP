&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PurchaseOrderClosingRef = DocPurchaseOrderServer.GetLastPurchaseOrderClosingByPurchaseOrder(CommandParameter);
	If ValueIsFilled(PurchaseOrderClosingRef) Then
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("Key", PurchaseOrderClosingRef), , New UUID());
	Else
		FillingValues = DocPurchaseOrderServer.GetPurchaseOrderForClosing(CommandParameter);
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;
EndProcedure