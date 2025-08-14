
Procedure OpenFormWidgetSettings(Object, Form, IndicatorName, Json = Undefined, SectionName = Undefined) Export
	FormParameters = GetSettingsFomParameters();   
	FormParameters.IndicatorName = IndicatorName;
	
	NotifyParams = New Structure("SectionName", SectionName);
	
	If Json <> Undefined Then
		FormParameters.Settings = CommonFunctionsServer.DeserializeJSONUseXDTO(Json);
	EndIf;
		
	If Upper(IndicatorName) = Upper("SalesAmount") Then
		FormParameters.Title = "Sales amount";
		FormParameters.Options.Icon = "cart-check";
		FormParameters.Options.Color = "green";
		FormParameters.Options.DetailsType = "modal";
		
		FormParameters.AvailableParameters.Add("Company");
		FormParameters.AvailableParameters.Add("Branch");
		FormParameters.AvailableParameters.Add("CurrencyMovementType");
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
	
	Return FormParameters;
EndFunction
