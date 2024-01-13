#Region FormEvents

Procedure ExternalEvent(Object, Form, Source, Event, Data) Export
	If Data <> Undefined Then
		NotifyParameters = New Structure();
		NotifyParameters.Insert("Form", Form);
		NotifyParameters.Insert("Object", Object);
		NotifyParameters.Insert("ClientModule", ThisObject);
		BarcodeClient.InputBarcodeEnd(Data, NotifyParameters);
	EndIf;
EndProcedure

#EndRegion

#Region Public

Procedure BeforePayment(Object, Cancel, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure PrintLastReceipt(Object, Cancel, AddInfo = Undefined) Export
	LastRetailSalesReceipt = DPPointOfSaleServer.GetLastRetailSalesReceiptDoc();
	If LastRetailSalesReceipt.isEmpty() Then
		Return;
	EndIf;

	PrintResult = DPPointOfSaleServer.GetRetailSalesReceiptPrint(Object.Workstation, LastRetailSalesReceipt);
	If PrintResult = Undefined Then
		Return;
	EndIf;

	Param = UniversalPrintServer.InitPrintParam(LastRetailSalesReceipt);
	Param.NameTemplate = "";
	Param.BuilderLayout = False;
	Param.SpreadsheetDoc = PrintResult;

	OpenForm("CommonForm.PrintForm", , , "UniqueOpeningOfTheCommonPrintingPlate");
	Notify("AddTemplatePrintForm", Param);
EndProcedure

Procedure BeforeStartNewTransaction(Object, Form, DocRef) Export
	Return;
EndProcedure

Procedure SearchCustomer(Object, Form) Export
	Notify = New NotifyDescription("SetRetailCustomer", Form);
	Settings = New Structure;
	Settings.Insert("RetailCustomer", Object.RetailCustomer);
	Settings.Insert("Company", Object.Company);
	OpenForm("Catalog.RetailCustomers.Form.QuickSearch", Settings, Form, , ,
		, Notify, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Procedure AfterWriteTransaction(DocRefsArray, Form) Export
	Return;
EndProcedure

#EndRegion