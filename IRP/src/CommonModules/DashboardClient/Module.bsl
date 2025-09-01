
Procedure OpenFormWidgetSettings(Object, Form, IndicatorName, Json = Undefined, SectionName = Undefined) Export
	FormParameters = GetSettingsFomParameters();   
	FormParameters.IndicatorName = IndicatorName;
	
	NotifyParams = New Structure("SectionName", SectionName);
	
	If Json <> Undefined Then
		FormParameters.Settings = CommonFunctionsServer.DeserializeJSONUseXDTO(Json);
	EndIf;
		
	If Upper(IndicatorName) = Upper("Sales_SalesAmount") Then
		FormParameters.Title = R().Dashboard_01;
		FormParameters.Options.Icon = "cart-check";
		FormParameters.Options.Color = "green";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("Currency");

	ElsIf Upper(IndicatorName) = Upper("Sales_AverageBill") Then
		FormParameters.Title = R().Dashboard_02;
		Raise "Not implemented";
	ElsIf Upper(IndicatorName) = Upper("Sales_SalerReturnPercentage") Then
		FormParameters.Title = R().Dashboard_03;
		Raise "Not implemented";
	ElsIf Upper(IndicatorName) = Upper("Money_CashBalance") Then
		FormParameters.Title = R().Dashboard_04;
		
		FormParameters.Options.Icon = "cash-coin";
		FormParameters.Options.Color = "blue";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("Account");
		FormParameters.AvailableParameters.Add("Currency");
		
	ElsIf Upper(IndicatorName) = Upper("Money_PaymentsFromClients") Then
		FormParameters.Title = R().Dashboard_05;
		
		FormParameters.Options.Icon = "calendar-plus";
		FormParameters.Options.Color = "green";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("FinancialMovementType");
		FormParameters.AvailableParameters.Add("Currency");
		
	ElsIf Upper(IndicatorName) = Upper("Money_PaymentsToSuppliers") Then
		FormParameters.Title = R().Dashboard_06;
		
		FormParameters.Options.Icon = "calendar-minus";
		FormParameters.Options.Color = "red";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("FinancialMovementType");
		FormParameters.AvailableParameters.Add("Currency");
		
	ElsIf Upper(IndicatorName) = Upper("Money_ApAr") Then
		FormParameters.Title = R().Dashboard_07;
		
		FormParameters.Options.Icon = "briefcase";
		FormParameters.Options.Color = "orange";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("DebtType");
		FormParameters.AvailableParameters.Add("Currency");
		
	ElsIf Upper(IndicatorName) = Upper("Purchases_StockBalance") Then
		FormParameters.Title = R().Dashboard_08;
		Raise "Not implemented";
	ElsIf Upper(IndicatorName) = Upper("Purchases_VolumeOfPurchases") Then
		FormParameters.Title = R().Dashboard_09;

		FormParameters.Options.Icon = "box-seam";
		FormParameters.Options.Color = "blue";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("Currency");
		
	Else
		Raise StrTemplate("Not implemented [%1]", IndicatorName);
	EndIf;    

	Callback = New CallbackDescription("OnCloseWidgetSettings", Form, NotifyParams);
	OpenForm("DataProcessor.ManagerDashboard.Form.FormWidgetSettings", 
			FormParameters, ThisObject,,,, Callback, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Function GetSettingsFomParameters()
	FormParameters = New Structure();
	FormParameters.Insert("Title", "Widget settings");
	FormParameters.Insert("IndicatorName", "");
	FormParameters.Insert("WidgetName", "");
	FormParameters.Insert("WidgetID", "");
	FormParameters.Insert("AvailableParameters", New Array());
	FormParameters.Insert("Settings", Undefined);
	FormParameters.Insert("Options", New Structure());
	FormParameters.Insert("ChartOptions", New Structure());
	
	FormParameters.Options.Insert("Icon", "");
	FormParameters.Options.Insert("Color", "");
	FormParameters.Options.Insert("DetailsType", "");
	FormParameters.Options.Insert("ModalTitle", "Details");
	FormParameters.Options.Insert("ModalIcon", "info-circle");
	FormParameters.Options.Insert("TimeLineDateFormat", "DF=dd.MM");
	FormParameters.Options.Insert("Width", "col-md-3");
	
	FormParameters.ChartOptions.Insert("ShowPoint", True);
	FormParameters.ChartOptions.Insert("ValueDivider", 1);
	
	Return FormParameters;
EndFunction
