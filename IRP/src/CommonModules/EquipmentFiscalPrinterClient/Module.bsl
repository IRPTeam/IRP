#Region API

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
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
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
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			
		ElsIf ShiftData.ShiftState = 2 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyOpened;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.OpenShift(Settings.ConnectedDriver.ID
																	, Parameters.ParametersXML
																	, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CloseShift(ConsolidatedRetailSales) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then

		ElsIf ShiftData.ShiftState = 3 Then
			
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.CloseShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		FillPropertyValues(Result, ShiftData);
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function PrintXReport(ConsolidatedRetailSales) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.PrintXReport(Settings.ConnectedDriver.ID, Parameters.ParametersXML);
	If ResultInfo Then
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function ProcessCheck(ConsolidatedRetailSales, RetailSalesReceipt) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	XMLOperationSettings = ShiftGetXMLOperationSettings();
	
	Parameters.ParametersXML = ShiftGetXMLOperation(XMLOperationSettings);

	Result = ReceiptResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Parameters = ReceiptSettings();
	XMLOperationSettings = ReceiptGetXMLOperationSettings(RetailSalesReceipt);
	
	Parameters.ParametersXML = ReceiptGetXMLOperation(XMLOperationSettings);

	Result = ReceiptResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.ProcessCheck(Settings.ConnectedDriver.ID
																	, False
																	, Parameters.ParametersXML
																	, Parameters.ResultXML);
	If ResultInfo Then
		ReceiptData = ReceiptResultStructure();
		FillDataFromDeviceResponse(ReceiptData, Parameters.ResultXML);
		FillPropertyValues(Result, ReceiptData);
		Result.Status = "Printed";
		Result.DataPresentation = " " + Result.ShiftNumber + " " + Result.DateTime;
		Result.FiscalResponse = Parameters.ResultXML;
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		Result.Status = "FiscalReturnedError";
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashInCome(ConsolidatedRetailSales, Summ) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.CashInOutcome(Settings.ConnectedDriver.ID
																		, Parameters.ParametersXML
																		, Summ);
	If ResultInfo Then
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

Async Function CashOutCome(ConsolidatedRetailSales, Summ) Export
	
	CRS = CommonFunctionsServer.GetAttributesFromRef(ConsolidatedRetailSales, "FiscalPrinter, Author");
	Settings = Await HardwareClient.FillDriverParametersSettings(CRS.FiscalPrinter);
		
	Parameters = ShiftSettings();
	ShiftGetXMLOperationSettings = ShiftGetXMLOperationSettings();
	ShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = ShiftGetXMLOperation(ShiftGetXMLOperationSettings);
	
	Result = ShiftResultStructure();
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.GetCurrentStatus(Settings.ConnectedDriver.ID
																			, Parameters.ParametersXML
																			, Parameters.ResultXML);
	If ResultInfo Then
		ShiftData = ShiftResultStructure();
		FillDataFromDeviceResponse(ShiftData, Parameters.ResultXML);
		If ShiftData.ShiftState = 1 Then
			Result.ErrorDescription = R().EqFP_ShiftAlreadyClosed;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		ElsIf ShiftData.ShiftState = 2 Then
			
		ElsIf ShiftData.ShiftState = 3 Then
			Result.ErrorDescription = R().EqFP_ShiftIsExpired;
			Result.Status = "FiscalReturnedError";
			CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
			Return Result;
		EndIf;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	ResultInfo = Settings.ConnectedDriver.DriverObject.CashInOutcome(Settings.ConnectedDriver.ID
																		, Parameters.ParametersXML
																		, -Summ);
	If ResultInfo Then
		Result.Success = True;
	Else
		Result.ErrorDescription = Settings.ConnectedDriver.DriverObject.GetLastError();
		CommonFunctionsClientServer.ShowUsersMessage(Result.ErrorDescription);
		Return Result;
	EndIf;
	
	Return Result;
EndFunction

#EndRegion

#Region Private

Function ShiftSettings() Export
	Str = New Structure();
	Str.Insert("ParametersXML", "");
	Str.Insert("ResultXML", "");	
	Return Str;
EndFunction

Function ShiftGetXMLOperationSettings()
	Str = New Structure;
	Str.Insert("CashierName", "");	//Mandatory
	Str.Insert("CashierINN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Return Str;
EndFunction

Function ShiftResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("ErrorDescription", "");
	
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

Function ReceiptResultStructure()
	ReturnValue = New Structure;
	ReturnValue.Insert("Success", False);
	ReturnValue.Insert("ErrorDescription", "");
	ReturnValue.Insert("Status", "");
	ReturnValue.Insert("FiscalResponse", "");
	ReturnValue.Insert("DataPresentation", "");
	
	ReturnValue.Insert("AddressSiteInspections", "");
	ReturnValue.Insert("CheckNumber", 0);
	ReturnValue.Insert("DateTime", Date(1, 1, 1));
	ReturnValue.Insert("FiscalSign", "");
	ReturnValue.Insert("ShiftClosingCheckNumber", 0);
	ReturnValue.Insert("ShiftNumber", 0);
	
	Return ReturnValue;
EndFunction

Function ReceiptSettings() Export
	Str = New Structure();
	Str.Insert("ParametersXML", "");
	Str.Insert("ResultXML", "");	
	Return Str;	
EndFunction

Function ReceiptGetXMLOperationSettings(RSR)
	Return EquipmentFiscalPrinterServer.PrepareReceiptData(RSR);
EndFunction

Function GetCountersOperationType()
	ReturnData = New Structure();
	ReturnData.Insert("CheckCount", 0);
	ReturnData.Insert("TotalChecksAmount", 0);
	ReturnData.Insert("CorrectionCheckCount", 0);
	ReturnData.Insert("TotalCorrectionChecksAmount", 0);	
	Return ReturnData;
EndFunction

Procedure FillDataFromDeviceResponse(Data, DeviceResponse)
	Reader = New XMLReader();
	Reader.SetString(DeviceResponse);
	Result = XDTOFactory.ReadXML(Reader);
	Reader.Close();
	DeviceResponseParameters = Result.Parameters;
		
	For Each DataItem In Data Do
		If Not DeviceResponseParameters.Properties().Get(DataItem.Key) = Undefined Then
			Data.Insert(DataItem.Key, TransformToTypeBySource(DeviceResponseParameters[DataItem.Key], DataItem.Value));
		EndIf;
	EndDo;
EndProcedure

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

Function ShiftGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("InputParameters");
	
	XMLWriter.WriteStartElement("Parameters");
	//@skip-check Undefined function
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), ToXMLString(CommonParameters.CashierName), "Administrator"));
	If Not IsBlankString(CommonParameters.CashierINN) Then
		XMLWriter.WriteAttribute("CashierINN" , ToXMLString(CommonParameters.CashierINN));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleAddress) Then   
		XMLWriter.WriteAttribute("SaleAddress", ToXMLString(CommonParameters.SaleAddress));
	EndIf;
	If Not IsBlankString(CommonParameters.SaleLocation) Then  
		XMLWriter.WriteAttribute("SaleLocation", ToXMLString(CommonParameters.SaleLocation));
	EndIf;
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

Function ReceiptGetXMLOperation(CommonParameters) Export
	
	XMLWriter = New XMLWriter();
	XMLWriter.SetString("UTF-8");
	XMLWriter.WriteXMLDeclaration();
	XMLWriter.WriteStartElement("CheckPackage");
	
	XMLWriter.WriteStartElement("Parameters");
	XMLWriter.WriteAttribute("CashierName", ?(Not IsBlankString(CommonParameters.CashierName), ToXMLString(CommonParameters.CashierName), "Administrator"));
	XMLWriter.WriteAttribute("OperationType" , ToXMLString(CommonParameters.OperationType));
	XMLWriter.WriteAttribute("TaxationSystem" , ToXMLString(CommonParameters.TaxationSystem));
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteStartElement("Positions");
	For Each Item In CommonParameters.FiscalStrings Do
		XMLWriter.WriteStartElement("FiscalString");
		XMLWriter.WriteAttribute("AmountWithDiscount", ToXMLString(Item.AmountWithDiscount));
		XMLWriter.WriteAttribute("DiscountAmount", ToXMLString(Item.DiscountAmount));
		If Item.Property("MarkingCode") Then
			XMLWriter.WriteAttribute("MarkingCode", ToXMLString(Item.MarkingCode));
		EndIf;
		XMLWriter.WriteAttribute("MeasureOfQuantity", ToXMLString(Item.MeasureOfQuantity));
		XMLWriter.WriteAttribute("Name", ToXMLString(Item.Name));
		XMLWriter.WriteAttribute("Quantity", ToXMLString(Item.Quantity));
		XMLWriter.WriteAttribute("PaymentMethod", ToXMLString(Item.PaymentMethod));
		XMLWriter.WriteAttribute("PriceWithDiscount", ToXMLString(Item.PriceWithDiscount));
		XMLWriter.WriteAttribute("VATRate", ToXMLString(Item.VATRate));
		XMLWriter.WriteAttribute("VATAmount", ToXMLString(Item.VATAmount));
		XMLWriter.WriteEndElement();
	EndDo;
	For Each Item In CommonParameters.TextStrings Do
		XMLWriter.WriteStartElement("TextString");
		XMLWriter.WriteAttribute("Text", ToXMLString(Item.Text));
		XMLWriter.WriteEndElement();
	EndDo;
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteStartElement("Payments");
	XMLWriter.WriteAttribute("Cash", ToXMLString(CommonParameters.Cash));
	XMLWriter.WriteAttribute("ElectronicPayment", ToXMLString(CommonParameters.ElectronicPayment));
	XMLWriter.WriteAttribute("PrePayment", ToXMLString(CommonParameters.PrePayment));
	XMLWriter.WriteAttribute("PostPayment", ToXMLString(CommonParameters.PostPayment));
	XMLWriter.WriteAttribute("Barter", ToXMLString(CommonParameters.Barter));
	XMLWriter.WriteEndElement();
	
	XMLWriter.WriteEndElement();
	
	Return XMLWriter.Close();
	
EndFunction

Function ToXMLString(Data)
	Return XMLString(Data);
EndFunction

#EndRegion
	