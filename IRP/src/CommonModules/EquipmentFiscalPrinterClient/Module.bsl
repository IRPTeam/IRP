#Region API

Function ShiftSettings() Export
	
	Str = New Structure();;
	Str.Insert("Cashier", PredefinedValue("Catalog.Partners.EmptyRef"));
	Str.Insert("ДокументОснование", Undefined);
	Str.Insert("Организация", PredefinedValue("Catalog.Companies.EmptyRef"));
	Str.Insert("ТорговыйОбъект", PredefinedValue("Catalog.Stores.EmptyRef"));
	
	Str.Insert("НомерСменыККТ" , 0);
	Str.Insert("НомерЧекаККТ"  , 0);
	Str.Insert("СтатусСмены", 0);
	Str.Insert("ДатаВремя", CurrentDate());
	Str.Insert("ParametersXML", "");
	Str.Insert("ResultXML", "");
	Str.Insert("КассоваяСмена", PredefinedValue("Document.ConsolidatedRetailSales.EmptyRef"));
	Str.Insert("ТестовыеЧеки", False);
	Str.Insert("ДополнительныеПараметры", New Structure());
	Str.Insert("Результат", True);
	Str.Insert("ТекстОшибки", "");
	
	Return Str;
	
EndFunction

Function ShiftGetXMLOperationSettings() Export
	Str = New Structure;
	Str.Insert("CashierName", "");	//Mandatory
	Str.Insert("CashierINN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Return Str;
EndFunction

// Open shift.
// 
// Parameters:
//  ConsolidatedRetailSales - DocumentRef.ConsolidatedRetailSales
// 
// Returns:
//  See OpenShiftResult
Async Function OpenShift(ConsolidatedRetailSales) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = EquipmentFiscalPrinterServer.ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	LineLength = 0;
	Result = Settings.ConnectedDriver.DriverObject.GetLineLength(Settings.ConnectedDriver.ID, LineLength);
	
	DataKKT = "";
	DataKKTResult = Settings.ConnectedDriver.DriverObject.GetDataKKT(Settings.ConnectedDriver.ID, DataKKT);
	If Not DataKKTResult Then
		Raise "Can not get data KKT";
	EndIf;
	
	Result = ShiftResult();
	ResultInfo = Settings.ConnectedDriver.DriverObject.OpenShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		Result.Success = True;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftAlreadyOpened);
		Result.Success = True;
	EndIf;
	
	Return Result;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = EquipmentFiscalPrinterServer.ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	LineLength = 0;
	Result = Settings.ConnectedDriver.DriverObject.GetLineLength(Settings.ConnectedDriver.ID, LineLength);
	
	Result = ShiftResult();
	ResultInfo = Settings.ConnectedDriver.DriverObject.CloseShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		Result.Success = True;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftIsNotOpened);
	EndIf;
	
	Return Result;
EndFunction

Function ShiftResult() Export
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	Return ReturnValue;
EndFunction

#EndRegion
	