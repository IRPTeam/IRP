

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)   
	RefreshAtServer();
EndProcedure

&AtClient
Procedure Refresh(Command)
	RefreshAtServer();	
EndProcedure

&AtClient
Procedure Configure(Command)
	OpenConfigureForm();
EndProcedure

&AtClient
Procedure htmlOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = False;
	If StrEndsWith(EventData.Href, "dashboard-configure") Then
		OpenConfigureForm();
	ElsIf StrStartsWith(EventData.Href, "widget-settings") Then
		Segments = StrSplit(EventData.Href, ":");                    
		WidgetID = Segments[1];
		Rows = ThisObject.WidgetSettings.FindRows(New Structure("ID", WidgetID));
		If Rows.Count() > 0 Then
			DashboardClient.OpenFormWidgetSettings(Object, ThisObject, Rows[0].IndicatorName, Rows[0].Json, Rows[0].SectionName);
		Else
			Raise StrTemplate("Not foud widget by ID [%1]", WidgetID);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OnCloseWidgetSettings(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf; 
	
	Filter = New Structure();
	Filter.Insert("ID", Result.WidgetID);
	WidgetRows = ThisObject.WidgetSettings.FindRows(Filter);
	If WidgetRows.Count() > 0 Then
		WidgetRow = WidgetRows[0];
	Else
		Raise StrTemplate("Not foud widget by ID [%1]", Result.WidgetID);
	EndIf;
	
	WidgetRow.ID = Result.WidgetID;
	WidgetRow.WidgetName = Result.WidgetName;
	WidgetRow.Type = Result.WidgetType;
	WidgetRow.IndicatorName = Result.IndicatorName;
	WidgetRow.Json = CommonFunctionsServer.SerializeJSONUseXDTO(Result);
	
	WidgetRow.SectionName = Params.SectionName;
	
	SaveAtServer();
	RefreshAtServer();
EndProcedure

&AtServer
Procedure SaveAtServer()
	RecordSet = InformationRegisters.DashboardSettings.CreateRecordSet();
	RecordSet.Filter.User.Set(SessionParameters.CurrentUser);
	Record = RecordSet.Add();
	Record.User = SessionParameters.CurrentUser;
	
	Settings = New Structure();
	Settings.Insert("SalesWidgets"      , CollectSettingsFromTable("SalesWidgets"));
	Settings.Insert("PurchasesWidgets"  , CollectSettingsFromTable("PurchasesWidgets"));
	Settings.Insert("MoneyWidgets"      , CollectSettingsFromTable("MoneyWidgets")); 
	
	Record.Settings = CommonFunctionsServer.SerializeJSONUseXDTO(Settings);
	RecordSet.Write();
EndProcedure

&AtServer
Function CollectSettingsFromTable(SectionName)
	Result = New Array();
	For Each Row In ThisObject.WidgetSettings Do
		If Row.SectionName <> SectionName Then
			Continue;
		EndIf;
		
		Settings = New Structure("Enabled, WidgetName, Type, ID, Json, IndicatorName");
		FillPropertyValues(Settings, Row);
		Result.Add(Settings);
	EndDo;
	Return Result;
EndFunction

&AtClient
Procedure OpenConfigureForm()
	FormParameters = New Structure();
	Callback = New CallbackDescription("OnCloseConfigureForm", ThisObject);
	OpenForm("DataProcessor.ManagerDashboard.Form.FormConfigure", 
			FormParameters, ThisObject,,,, Callback, FormWindowOpeningMode.LockOwnerWindow);	
EndProcedure

&AtServer
Procedure RefreshAtServer()
	// API_ONEC_DAILY_SALES_CHART_SERIES API_ONEC_COMPLETED_TASKS_CHART_SERIES
	
	Template = DataProcessors.ManagerDashboard.GetTemplate("Template"); 
	html_text = Template.GetText();         
	
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DashboardSettings.Settings AS Settings,
	|	1 AS Priority
	|INTO tmp
	|FROM
	|	InformationRegister.DashboardSettings AS DashboardSettings
	|WHERE
	|	DashboardSettings.User = &User
	|
	|UNION ALL
	|
	|SELECT
	|	DashboardSettings.Settings,
	|	2
	|FROM
	|	InformationRegister.DashboardSettings AS DashboardSettings
	|WHERE
	|	DashboardSettings.User = &UserGroup
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Settings AS Settings
	|FROM
	|	tmp AS tmp
	|
	|ORDER BY
	|	tmp.Priority";
	Query.SetParameter("User", SessionParameters.CurrentUser);
	Query.SetParameter("UserGroup", SessionParameters.CurrentUser.UserGroup);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(); 
	
	Root = DashboardServer.GetJson_Root();
	
	ThisObject.WidgetSettings.Clear();
	
	If QuerySelection.Next() Then
		Settings = CommonFunctionsServer.DeserializeJSONUseXDTO(QuerySelection.Settings);
		CreateWidgetsFromArray(Root, Settings.SalesWidgets      , "SalesWidgets");
		CreateWidgetsFromArray(Root, Settings.PurchasesWidgets  , "PurchasesWidgets");
		CreateWidgetsFromArray(Root, Settings.MoneyWidgets      , "MoneyWidgets");
    EndIf;
	
	json_text = CommonFunctionsServer.SerializeJSON(Root);
	
	html_text = StrReplace(html_text, "__API_ONEC_DISABLED__","__API_ONEC_ENABLED__");
	html_text = StrReplace(html_text, """__API_ONEC_DATA__""",json_text);
	
	ThisObject.html = html_text; 
EndProcedure	

&AtClient
Procedure OnCloseConfigureForm(Result, Params) Export
	RefreshAtServer();	
EndProcedure

#Region WIDGETS

Procedure CreateWidgetsFromArray(Root, ArrayOfSettings, SectionName)
	For Each _WidgetSettings In ArrayOfSettings Do
		If Not _WidgetSettings.Enabled Then
			Continue;
		EndIf;  
		NewWidgetSettings = ThisObject.WidgetSettings.Add(); 
		FillPropertyValues(NewWidgetSettings, _WidgetSettings);
		NewWidgetSettings.SectionName = SectionName;
		
	    CreateWidget(Root, _WidgetSettings);
	EndDo;
EndProcedure

Procedure CreateWidget(Root, Settings) 
	_Settings = CommonFunctionsServer.DeserializeJSONUseXDTO(Settings.Json);
	 
	_Period = DashboardServer.CalculatePeriod(CurrentSessionDate(), _Settings.Period, _Settings.LastPeriodType, _Settings.LastPeriodCount);
	
	_PeriodPresentation = DashboardServer.GetPeriodPresentation(_Period);
	
	If Settings.Type = "stats_card" Then
		StatsCard = DashboardServer.GetJson_StatsCard();
		StatsCard.title  = _Settings.WidgetName;
		StatsCard.width  = _Settings.Options.Width;
		
		IndicatorParameters = New Structure();
		If _Settings.Series.Count() > 0 Then
			For Each KeyValue In _Settings.Series[0] Do
				IndicatorParameters.Insert(KeyValue.Key, KeyValue.Value);
			EndDo;
		EndIf;
		
		_value = 0;
		_details = New Array();
		If _Settings.IndicatorName = "Money_ApAr" Then
			_result = DashboardServer.GetValue_Money_ApAr(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Money_CashBalance" Then
			_result = DashboardServer.GetValue_Money_CashBalance(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Money_PaymentsFromClients" Then
			_result = DashboardServer.GetValue_Money_PaymentsFromClients(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Money_PaymentsToSuppliers" Then
			_result = DashboardServer.GetValue_Money_PaymentsToSuppliers(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Purchases_StockBalance" Then
			_result = DashboardServer.GetValue_Purchases_StockBalance(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Purchases_VolumeOfPurchases" Then
			_result = DashboardServer.GetValue_Purchases_VolumeOfPurchases(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Sales_AverageBill" Then
			_result = DashboardServer.GetValue_Sales_AverageBill(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Sales_SalerReturnPercentage" Then
			_result = DashboardServer.GetValue_Sales_SalerReturnPercentage(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		ElsIf _Settings.IndicatorName = "Sales_SalesAmount" Then
			_result = DashboardServer.GetValue_Sales_SalesAmount(_Period, IndicatorParameters, _Settings, Undefined, Undefined);
		EndIf;
		
		_value = _result.Series[0];
		_details = _result.Details;
		
		StatsCard.value  = Format(_value, "NFD=2"); 
		StatsCard.details = _details;
		StatsCard.icon   = _Settings.Options.Icon;
		StatsCard.color  = _Settings.Options.Color;
		StatsCard.period = _PeriodPresentation;
		
		StatsCard.widget_settings_href = StrTemplate("widget-settings:%1", _Settings.WidgetID);
		
		Root.stats_cards.Add(StatsCard);
	ElsIf Settings.Type = "chart" Then
		Chart = DashboardServer.GetJson_Chart();
		Chart.type         = _Settings.ChartType;
		Chart.details_type = _Settings.Options.DetailsType;
		Chart.title        = _Settings.WidgetName;
		Chart.widget_settings_href = StrTemplate("widget-settings:%1", _Settings.WidgetID);
		Chart.category     = _PeriodPresentation; 
		Chart.width        = _Settings.Options.Width;
		Chart.modal_title  = _Settings.Options.ModalTitle;
		Chart.modal_icon   = _Settings.Options.ModalIcon; 
		
		Chart.options.showPoint = _Settings.ChartOptions.ShowPoint;
		
		LabelsData = DashboardServer.CreateLabels(_Period, _Settings);
		
		Chart.data.labels = LabelsData.LabelsFormated;
		
		For Each Seria In _Settings.Series Do
			DetailsButton = DashboardServer.GetJon_Chart_DetailsButtons();
			DetailsButton.id = String(New UUID());
			DetailsButton.text = Seria.Title;
			Chart.details_buttons.Add(DetailsButton);
						
			SeriaData = New Structure("ID, Seria", DetailsButton.id, Seria);
			
			IndicatorParameters = New Structure();
			For Each KeyValue In Seria Do
				IndicatorParameters.Insert(KeyValue.Key, KeyValue.Value);
			EndDo;
			
			If _Settings.IndicatorName = "Money_ApAr" Then
				_result = DashboardServer.GetValue_Money_ApAr(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Money_CashBalance" Then
				_result = DashboardServer.GetValue_Money_CashBalance(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Money_PaymentsFromClients" Then
				_result = DashboardServer.GetValue_Money_PaymentsFromClients(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Money_PaymentsToSuppliers" Then
				_result = DashboardServer.GetValue_Money_PaymentsToSuppliers(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Purchases_StockBalance" Then
				_result = DashboardServer.GetValue_Purchases_StockBalance(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Purchases_VolumeOfPurchases" Then
				_result = DashboardServer.GetValue_Purchases_VolumeOfPurchases(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Sales_AverageBill" Then
				_result = DashboardServer.GetValue_Sales_AverageBill(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Sales_SalerReturnPercentage" Then
				_result = DashboardServer.GetValue_Sales_SalerReturnPercentage(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			ElsIf _Settings.IndicatorName = "Sales_SalesAmount" Then
				_result = DashboardServer.GetValue_Sales_SalesAmount(_Period, IndicatorParameters, _Settings, LabelsData, SeriaData);
			EndIf;
				
			If _result <> Undefined Then
				If _Settings.ChartType = "Pie" Then
					If _result.Series.Count() > 0 Then
						Chart.data.series.Add(_result.Series[0]);
					EndIf;
				Else
					Chart.data.series.Add(_result.Series);
				EndIf;
				For Each DetailItem In _result.Details Do
					Chart.details.Add(DetailItem);
				EndDo;
			EndIf;
		EndDo;
		
		Root.charts.Add(Chart);	
	Else
		Raise StrTemplate("Unsupported widget type [%1]", Settings.Type);
	EndIf;
EndProcedure

#EndRegion
