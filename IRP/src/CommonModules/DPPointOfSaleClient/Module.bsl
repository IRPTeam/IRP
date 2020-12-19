
&AtClient
Procedure ExternalEvent(Object, Form, Source, Event, Data) Export
	If Data <> Undefined Then
		NotifyParameters = New Structure;
		NotifyParameters.Insert("Form", Form);
		NotifyParameters.Insert("Object", Object);
		NotifyParameters.Insert("ClientModule", ThisObject);
		BarcodeClient.InputBarcodeEnd(Data, NotifyParameters);
	EndIf;
EndProcedure

&AtClient
Procedure BeforePayment(Object, Cancel, AddInfo = Undefined) Export
	Return;
EndProcedure

&AtClient
Procedure PrintLastReceipt(Object, Cancel, AddInfo = Undefined) Export
	LastRetailSalesReceipt = DPPointOfSaleServer.GetLastRetailSalesReceiptDoc();
	If LastRetailSalesReceipt.isEmpty() Then
		Return;
	EndIf;
	
	PrintResult = DPPointOfSaleServer.GetRetailSalesReceiptPrint(Object.Workstation, LastRetailSalesReceipt);
	If PrintResult = Undefined Then
		Return;
	EndIf;
	
	PrintFormParameters = New Structure;
	PrintFormParameters.Insert("Result", PrintResult);
	PrintForm = GetForm("CommonForm.PrintForm", PrintFormParameters, Object);
	PrintForm.Open();
	
EndProcedure