#Region API

Function OpenShiftSettings() Export
	
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

Function OpenShiftGetXMLOperationSettings() Export
	Str = New Structure;
	Str.Insert("CashierName", "");
	Str.Insert("CashierINN", "");
	Str.Insert("SaleAddress", "");
	Str.Insert("SaleLocation", "");
	Return Str;
EndFunction

Функция OpenShiftGetXMLOperation(ОбщиеПараметры)
	
	ЗаписьXML = Новый ЗаписьXML();
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьОбъявлениеXML();
	ЗаписьXML.ЗаписатьНачалоЭлемента("InputParameters");
	ЗаписьXML.ЗаписатьНачалоЭлемента("Parameters");
	
	ЗаписьXML.ЗаписатьАтрибут("CashierName", ?(Not IsBlankString(ОбщиеПараметры.CashierName), XMLСтрока(ОбщиеПараметры.CashierName), "Администратор"));
	ЗаписьXML.ЗаписатьАтрибут("CashierINN" , ?(Not IsBlankString(ОбщиеПараметры.CashierINN), XMLСтрока(ОбщиеПараметры.CashierINN), ""));
	Если Not IsBlankString(ОбщиеПараметры.SaleAddress) Тогда   
		ЗаписьXML.ЗаписатьАтрибут("SaleAddress", XMLСтрока(ОбщиеПараметры.АдресРасчетов));
	КонецЕсли;
	Если Not IsBlankString(ОбщиеПараметры.SaleLocation) Тогда  
		ЗаписьXML.ЗаписатьАтрибут("SaleLocation", XMLСтрока(ОбщиеПараметры.МестоРасчетов));
	КонецЕсли;
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Возврат ЗаписьXML.Закрыть();
	
КонецФункции  


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
		
	Parameters = OpenShiftSettings();
	OpenShiftGetXMLOperationSettings = OpenShiftGetXMLOperationSettings();
	OpenShiftGetXMLOperationSettings.CashierName = String(CRS.Author);
	
	Parameters.ParametersXML = OpenShiftGetXMLOperation(OpenShiftGetXMLOperationSettings);
	
	LineLength = 0;
	Result = Settings.ConnectedDriver.DriverObject.GetLineLength(Settings.ConnectedDriver.ID, LineLength);
	
	DataKKT = "";
	DataKKTResult = Settings.ConnectedDriver.DriverObject.GetDataKKT(Settings.ConnectedDriver.ID, DataKKT);
	If Not DataKKTResult Then
		Raise "Can not get data KKT";
	EndIf;
	
	Result = OpenShiftResult();
	ResultInfo = Settings.ConnectedDriver.DriverObject.OpenShift(Settings.ConnectedDriver.ID, Parameters.ParametersXML, Parameters.ResultXML);
	If ResultInfo Then
		Result.Success = True;
	Else
		CommonFunctionsClientServer.ShowUsersMessage(R().EqFP_ShiftAlreadyOpened);
	EndIf;
	
	Return Result;
EndFunction

Function OpenShiftResult() Export
	Str = New Structure;
	Str.Insert("Success", False);
	Return Str;
EndFunction

#EndRegion
	