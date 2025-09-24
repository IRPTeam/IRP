
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.List.Parameters.SetParameterValue("Company", Parameters.Company);
	ThisObject.List.Parameters.SetParameterValue("Partner", Parameters.Partner);
	ThisObject.List.Parameters.SetParameterValue("LegalName", Parameters.LegalName);
	ThisObject.List.Parameters.SetParameterValue("Agreement", Parameters.Agreement);
	IsOrder = False;
	If Parameters.Property("IsOrder") Then
		IsOrder = Parameters.IsOrder;
	EndIf;
	ThisObject.List.Parameters.SetParameterValue("IsOrder", IsOrder);
	
	SalesReportFromTradeAgent = False;
	CashTransferOrder = False;
	DebitNote = False;
	CreditNote = False;
	SalesInvoice = False;
	SalesOrder = False;
	SalesReturn = False;
	PurchaseInvoice = False;
	PurchaseOrder = False;
	PurchaseReturn = False;
	RetailReturnReceipt = False;
	RetailSalesReceipt = False;
	EmployeeCashAdvance = False;
	OpeningEntry = False;
	WithholdingTaxInvoice = False; 
	SalesReportToConsignor = False;

	If TypeOf(Parameters.Ref) = Type("DocumentRef.ChequeBondTransaction") Then
		CashTransferOrder = True;
		PurchaseInvoice = True;
		DebitNote = True;
		CreditNote = True;
		PurchaseReturn = True;
		OpeningEntry = True;
		SalesReturn = True;
		SalesInvoice = True;
		PurchaseOrder = True;
		SalesOrder = True;
	ElsIf TypeOf(Parameters.Ref) = Type("DocumentRef.DebitNote") Then
		PurchaseInvoice = True;
		PurchaseReturn = True;
		OpeningEntry = True;
		SalesReturn = True;
		SalesInvoice = True;
	ElsIf TypeOf(Parameters.Ref) = Type("DocumentRef.CreditNote") Then
		PurchaseInvoice = True;
		PurchaseReturn = True;
		OpeningEntry = True;
		SalesReturn = True;
		SalesInvoice = True;
	ElsIf TypeOf(Parameters.Ref) = Type("DocumentRef.DebitCreditNote") Then
		If IsOrder Then
			SalesOrder = True;
			PurchaseOrder = True;
		Else
			SalesReportFromTradeAgent = True; 
			CashTransferOrder = True;
			PurchaseInvoice = True;
			DebitNote = True;
			CreditNote = True;
			PurchaseReturn = True;
			EmployeeCashAdvance = True;
			OpeningEntry = True; 
			RetailReturnReceipt = True; 
			SalesReturn = True;
			WithholdingTaxInvoice = True; 
			RetailSalesReceipt = True;
			SalesReportToConsignor = True;
			SalesInvoice = True;
		EndIf;
	Else
		If IsOrder Then
			SalesOrder = True;
			PurchaseOrder = True;
		EndIf;
	EndIf;
	
	ThisObject.List.Parameters.SetParameterValue("SalesReportFromTradeAgent" , SalesReportFromTradeAgent); 
	ThisObject.List.Parameters.SetParameterValue("CashTransferOrder" , CashTransferOrder);
	ThisObject.List.Parameters.SetParameterValue("DebitNote" , DebitNote);
	ThisObject.List.Parameters.SetParameterValue("CreditNote" , CreditNote);
	ThisObject.List.Parameters.SetParameterValue("SalesInvoice" , SalesInvoice);
	ThisObject.List.Parameters.SetParameterValue("SalesOrder" , SalesOrder);
	ThisObject.List.Parameters.SetParameterValue("SalesReturn" , SalesReturn);
	ThisObject.List.Parameters.SetParameterValue("PurchaseInvoice" , PurchaseInvoice);
	ThisObject.List.Parameters.SetParameterValue("PurchaseOrder" , PurchaseOrder);
	ThisObject.List.Parameters.SetParameterValue("PurchaseReturn" , PurchaseReturn);
	ThisObject.List.Parameters.SetParameterValue("RetailReturnReceipt" , RetailReturnReceipt);  
	ThisObject.List.Parameters.SetParameterValue("RetailSalesReceipt" , RetailSalesReceipt);
	ThisObject.List.Parameters.SetParameterValue("EmployeeCashAdvance" , EmployeeCashAdvance);
	ThisObject.List.Parameters.SetParameterValue("OpeningEntry" , OpeningEntry);
	ThisObject.List.Parameters.SetParameterValue("WithholdingTaxInvoice" , WithholdingTaxInvoice); 
	ThisObject.List.Parameters.SetParameterValue("SalesReportToConsignor" , SalesReportToConsignor);
	
	Items.List.CurrentRow = Parameters.Document;
EndProcedure

&AtClient
Procedure ListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.List.CurrentData;
	If CurrentData <> Undefined Then
		Close(New Structure("BasisDocument", CurrentData.Document));
	EndIf;
EndProcedure
