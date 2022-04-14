&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	PurchaseOrderClosingRef = DocPurchaseOrderServer.GetLastPurchaseOrderClosingByPurchaseOrder(CommandParameter);
	If ValueIsFilled(PurchaseOrderClosingRef) Then
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("Key", PurchaseOrderClosingRef), , New UUID());
	Else
		FillingValues = DocPurchaseOrderServer.GetPurchaseOrderForClosing(CommandParameter);
		OpenForm("Document.PurchaseOrderClosing.ObjectForm", New Structure("FillingValues", FillingValues), , New UUID());
	EndIf;

//	Param = New Structure();
//	POC = DocPurchaseOrderServer.GetLastPurchaseOrderClosingByPurchaseOrder(CommandParameter);
//	If Not POC.IsEmpty() Then
//		Param.Insert("Key", POC);
//	Else
//		Param.Insert("FillingValues", New Structure("PurchaseOrder", CommandParameter));
//	EndIf;
//
//	OpenForm("Document.PurchaseOrderClosing.ObjectForm", Param, , New UUID());
EndProcedure