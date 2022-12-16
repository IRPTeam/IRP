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
	Result = Settings.ConnectedDriver.DriverObject.GetLineLength(Settings.ConnectedDriver.ID
																	, LineLength);
	
	DataKKT = "";
	DataKKTResult = Settings.ConnectedDriver.DriverObject.GetDataKKT(Settings.ConnectedDriver.ID
																		, DataKKT);
	If Not DataKKTResult Then
		Raise "Can not get data KKT";
	EndIf;

	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = GetShiftData(Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			
		ElsIf ShiftData.ShiftState = 2 Then
			CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftAlreadyOpened);
			Return Result;
		ElsIf ShiftData.ShiftState = 3 Then
			CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftIsExpired);
			Return Result;
		EndIf;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(Settings.ConnectedDriver.DriverObject.GetLastError());
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.OpenShift(Settings.ConnectedDriver.ID
																	, Parameters.ParametersXML
																	, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = GetShiftData(Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(Settings.ConnectedDriver.DriverObject.GetLastError());
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
	
	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = GetShiftData(Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftAlreadyClosed);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then

		ElsIf ShiftData.ShiftState = 3 Then
			
		EndIf;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(Settings.ConnectedDriver.DriverObject.GetLastError());
		Return Result;
	EndIf;
	
	Result = ShiftResultStructure();
	ResultInfo = Settings.ConnectedDriver.DriverObject.CloseShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = GetShiftData(Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(Settings.ConnectedDriver.DriverObject.GetLastError());
	EndIf;
	
	Return Result;
EndFunction

#EndRegion

#Region Private

Function ShiftResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("BacklogDocumentFirstDateTime", Date(1, 1, 1));
	ReturnValue.Insert("BacklogDocumentFirstNumber", 0);
	ReturnValue.Insert("BacklogDocumentsCounter", 0);
	ReturnValue.Insert("CashBalance", 0);
	ReturnValue.Insert("CheckNumber", 0);
	ReturnValue.Insert("CountersOperationType1", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType2", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType3", GetCountersOperationType());
	ReturnValue.Insert("CountersOperationType4", GetCountersOperationType());
	ReturnValue.Insert("DateTime", Date(1, 1, 1));
	ReturnValue.Insert("FNError", False);
	ReturnValue.Insert("FNFail", False);
	ReturnValue.Insert("FNOverflow", False);
	ReturnValue.Insert("ShiftClosingCheckNumber", 0);
	ReturnValue.Insert("ShiftNumber", 0);
	ReturnValue.Insert("ShiftState", 0);	//1 closed, 2 opened, 3 expired
	Return ReturnValue;
EndFunction

Function GetCountersOperationType()
	ReturnData = New Structure();
	ReturnData.Insert("CheckCount", 0);
	ReturnData.Insert("TotalChecksAmount", 0);
	ReturnData.Insert("CorrectionCheckCount", 0);
	ReturnData.Insert("TotalCorrectionChecksAmount", 0);	
	Return ReturnData;
EndFunction

Function GetShiftData(Value)
	Reader = New XMLReader();
	Reader.SetString(Value);
	Result = XDTOFactory.ReadXML(Reader);
	Reader.Close();
	ShiftDataParameters = Result.Parameters;
	
	ReturnData = ShiftResultStructure();
	
	For Each ReturnDataItem In ReturnData Do
		If Not ShiftDataParameters.Properties().Get(ReturnDataItem.Key) = Undefined Then
			ReturnData.Insert(ReturnDataItem.Key, TransformToTypeBySource(ShiftDataParameters[ReturnDataItem.Key], ReturnDataItem.Value));
		EndIf;
	EndDo;
	
	Return ReturnData;
EndFunction

Function TransformToTypeBySource(Data, Source)
	If Data = "" Then
		Return Data;
	EndIf;
	If TypeOf(Source) = Type("Boolean") Then
		Return Boolean(Data);
	ElsIf TypeOf(Source) = Type("Number") Then
		Return Number(Data);
	ElsIf TypeOf(Source) = Type("Date") Then
		Return ReadJSONDate(Data, JSONDateFormat.ISO);
	ElsIf TypeOf(Source) = Type("Structure") Then
		Structure = New Structure();
		For Each Item In Data.Parameters.Properties() Do 
			Structure.Insert(Item.Name, Data.Parameters[Item.Name]);
		EndDo;
		Return Structure;
	Else
		Return Data;
	EndIf;
EndFunction

#EndRegion
	