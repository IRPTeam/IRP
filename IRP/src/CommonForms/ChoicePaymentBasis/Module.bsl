
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.Parameters.SetParameterValue("Company", Parameters.Company);
	ThisObject.List.Parameters.SetParameterValue("Branch", Parameters.Branch);
	ThisObject.List.Parameters.SetParameterValue("Partner", Parameters.Partner);
	ThisObject.List.Parameters.SetParameterValue("Agreement", Parameters.Agreement);
	ThisObject.List.Parameters.SetParameterValue("LegalName", Parameters.LegalName);
	
	If ValueIsFilled(Parameters.Ref) Then
		Period = New Boundary(Parameters.Ref.PointInTime(), BoundaryType.Excluding);
	Else
		Period = EndOfDay(Parameters.Date);
	EndIf;
	ThisObject.List.Parameters.SetParameterValue("Period", Period);
	
	ListParameters = New Structure();	
	ListParameters.Insert("SalesReportFromTradeAgent", False);
	ListParameters.Insert("CashTransferOrder", False);
	ListParameters.Insert("DebitNote", False);
	ListParameters.Insert("CreditNote", False);
	ListParameters.Insert("SalesInvoice", False);
	ListParameters.Insert("SalesReturn", False);
	ListParameters.Insert("PurchaseInvoice", False);
	ListParameters.Insert("PurchaseReturn", False);
	ListParameters.Insert("RetailReturnReceipt", False);
	ListParameters.Insert("RetailSalesReceipt", False);
	ListParameters.Insert("WithholdingTaxInvoice", False); 
	ListParameters.Insert("SalesReportToConsignor", False);
	ListParameters.Insert("OpeningEntry_TradeAgent", False);
	ListParameters.Insert("OpeningEntry_Consignor", False);
	ListParameters.Insert("OpeningEntry_AccountPayable", False);
	ListParameters.Insert("OpeningEntry_AccountReceivable", False);
	
	ListParameters.SalesReportFromTradeAgent = True;
	ListParameters.CashTransferOrder = True;
	ListParameters.DebitNote = True;
	ListParameters.CreditNote = True;
	ListParameters.SalesInvoice = True;
	ListParameters.SalesReturn = True;
	ListParameters.PurchaseInvoice = True;
	ListParameters.PurchaseReturn = True;
	ListParameters.RetailReturnReceipt = True;
	ListParameters.RetailSalesReceipt = True;
	ListParameters.WithholdingTaxInvoice = True; 
	ListParameters.SalesReportToConsignor = True;
	ListParameters.OpeningEntry_TradeAgent = True;
	ListParameters.OpeningEntry_Consignor = True;
	ListParameters.OpeningEntry_AccountPayable = True;
	ListParameters.OpeningEntry_AccountReceivable = True;
	
	For Each KeyValue In ListParameters Do
		ThisObject.List.Parameters.SetParameterValue(KeyValue.Key , KeyValue.Value);
	EndDo;
	
	Items.List.CurrentRow = Parameters.Document;
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.List.CurrentData;
	If CurrentData <> Undefined Then
		Close(New Structure("BasisDocument, Amount", 
			CurrentData.Document, CurrentData.Amount));
	EndIf;
EndProcedure
