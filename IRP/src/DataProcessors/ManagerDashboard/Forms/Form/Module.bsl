

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
	
	//file = new TextReader("C:\Users\andre\Documents\index.html");
	//html_text = file.Read();
	
	//Obj = FormAttributeToValue("Object");
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
	
	If BegOfDay(_Period.StartDate) = BegOfDay(_Period.EndDate) Then
		_PeriodPresentation = Format(_Period.StartDate,"DLF=D");
	Else
		_PeriodPresentation = StrTemplate("%1 - %2", Format(_Period.StartDate,"DLF=D"), Format(_Period.EndDate, "DLF=D"));
	EndIf;
	
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
		If _Settings.IndicatorName = "SalesAmount" Then
			_value = GetValue_SalesAmount(_Period, IndicatorParameters, _Settings, Undefined).Series[0];	
		EndIf;
		
		StatsCard.value  = Format(_value, "NFD=2"); 
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
		
		LabelsData = CreateLabels(_Period, _Settings);
		
		Chart.data.labels = LabelsData.LabelsFormated;
		
		For Each Seria In _Settings.Series Do
			DetailsButton = DashboardServer.GetJon_Chart_DetailsButtons();
			DetailsButton.id = "";
			DetailsButton.text = Seria.Title;
			Chart.details_buttons.Add(DetailsButton);
						
			IndicatorParameters = New Structure();
			For Each KeyValue In Seria Do
				IndicatorParameters.Insert(KeyValue.Key, KeyValue.Value);
			EndDo;
			
			If _Settings.IndicatorName = "SalesAmount" Then	
				SeriesData = GetValue_SalesAmount(_Period, IndicatorParameters, _Settings, LabelsData);
				
				If _Settings.ChartType = "Pie" Then
					If SeriesData.Series.Count() > 0 Then
						Chart.data.series.Add(SeriesData.Series[0]);
					EndIf;
				Else
					Chart.data.series.Add(SeriesData.Series);
				EndIf;
				
			EndIf;
		EndDo;
		
		Root.charts.Add(Chart);	
	Else
		Raise StrTemplate("Unsupported widget type [%1]", Settings.Type);
	EndIf;
EndProcedure

Function CreateLabels(Period, Settings)
	Labels = New Array();
	LabelsFormated = New Array(); 
	Intervals = New Array();
	
	Result = New Structure("Labels, LabelsFormated, Intervals", Labels, LabelsFormated, Intervals);

	Periodicity = DashboardServer.GetPeriodicity(Settings);
	
	If Not ValueIsFilled(Periodicity) Then  
		For Each Seria In Settings.Series Do
			Result.LabelsFormated.Add(Seria.Title);
		EndDo;
		Return Result;
	EndIf;
	
	StartDate = Period.StartDate;
	Result.Labels.Add(BegOfDay(StartDate));
	
	While StartDate < BegOfDay(Period.EndDate) Do
		StartDate = DashboardServer.AddToDate(StartDate, Periodicity);
		
		If StartDate < Period.EndDate Then
			Result.Labels.Add(BegOfDay(StartDate));
		EndIf;
	EndDo;
	
	DateFormat = "DF=dd.MM";
	If ValueIsFilled(Settings.Options.TimeLineDateFormat) Then
		DateFormat = Settings.Options.TimeLineDateFormat;
	EndIf;

	For Each Label In Labels Do
		Result.LabelsFormated.Add(Format(Label, DateFormat));
		Interval = New Structure("StartDate, EndDate");
		Interval.StartDate = Label; 
		Interval.EndDate = DashboardServer.AddToDate(Label, Periodicity)-1;
		Result.Intervals.Add(Interval);
	EndDo;
	
	Return Result;
EndFunction

Function GetValue_SalesAmount(Period, IndicatorParameters, Settings, LabelsData)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	REFPRESENTATION(Reg.Invoice) AS Invoice,
	|	Reg.Currency AS Currency,
	|	Reg.AmountTurnover AS TotalAmount,
	|	Reg.NetAmountTurnover AS NetAmount,
	|	Reg.OffersAmountTurnover AS OfferAmount,
	|	Reg.AmountTurnover - Reg.NetAmountTurnover AS TaxAmount
	|FROM
	|	AccumulationRegister.R2001T_Sales.Turnovers(
	|			BEGINOFPERIOD(&StartDate, DAY),
	|			ENDOFPERIOD(&EndDate, DAY),
	|			Hour,
	|			CASE
	|					WHEN &Filter_Company
	|						THEN Company = &Company
	|					ELSE TRUE
	|				END
	|				AND CASE
	|					WHEN &Filter_CurrencyMovementType
	|						THEN CurrencyMovementType = &CurrencyMovementType
	|					ELSE TRUE
	|				END
	|				AND CASE
	|					WHEN &Filter_Branch
	|						THEN Branch = &Branch
	|					ELSE TRUE
	|				END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS BY
	|	Period";
	
	Query.SetParameter("StartDate" , Period.StartDate);
	Query.SetParameter("EndDate"   , Period.EndDate);
	
	For Each KeyValue In IndicatorParameters Do
		Query.SetParameter("Filter_" + KeyValue.Key, ValueIsFilled(KeyValue.Value));
		Query.SetParameter(KeyValue.Key, KeyValue.Value);
	EndDo;
	
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	
	SeriesTable = New ValueTable();
	SeriesTable.Columns.Add("Date");
	SeriesTable.Columns.Add("Value");
	
	Series = New Array();
	
	If ValueIsFilled(Settings.Periodicity) Then // Time line
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			Value = 0;
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.TotalAmount;	
			EndDo;
			NewSeriesRow = SeriesTable.Add();
			NewSeriesRow.Date = BegOfDay(QuerySelection.Period);
			NewSeriesRow.Value = Value;
		EndDo;
		
		SeriesTable.GroupBy("Date", "Value");
		
		For Each Interval In LabelsData.Intervals Do
			For Each Row In SeriesTable Do
				If Row.Date >= Interval.StartDate And Row.Date <= Interval.EndDate Then
					Row.Date = Interval.StartDate;
				EndIf;
			EndDo;
		EndDo;
		
		SeriesTable.GroupBy("Date", "Value");
		
		For Each Label In LabelsData.Labels Do
			If SeriesTable.FindRows(New Structure("Date", Label)).Count() = 0 Then
				NewSeriesRow = SeriesTable.Add();
				NewSeriesRow.Date = BegOfDay(Label);
				NewSeriesRow.Value = 0;
			EndIf;
		EndDo;
		
		SeriesTable.Sort("Date");
		Series = SeriesTable.UnloadColumn("Value");
		
	Else    
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.TotalAmount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
	
	Return New Structure("Series", Series);
	
	//
	//Details = GetJson_StatsCard_Details();
	//Details.tab_title = "Wholesale sales";
	//Details.table_caption = StrTemplate("%1 - %2", Format(StartDate,"DLF=D"), Format(EndDate, "DLF=D"));
	//
	//Details.columns.Add(Create_Details_Column("invoice"      , "Invoice" , "w-50"));
	//Details.columns.Add(Create_Details_Column("offer_amount" , "Offer"   , "w-10"));
	//Details.columns.Add(Create_Details_Column("net_amount"   , "Net"     , "w-10"));
	//Details.columns.Add(Create_Details_Column("tax_amount"   , "Tax"     , "w-10"));
	//Details.columns.Add(Create_Details_Column("total_amount" , "Total"   , "w-10"));
	//
	//TotalAmount = 0;
	//While QuerySelection.Next() Do                                         
	//	NewRow = New Structure();
	//	NewRow.Insert("invoice"      , QuerySelection.Invoice);
	//	NewRow.Insert("offer_amount" , Format(QuerySelection.OfferAmount, "NFD=2"));
	//	NewRow.Insert("net_amount"   , Format(QuerySelection.NetAmount, "NFD=2"));
	//	NewRow.Insert("tax_amount"   , Format(QuerySelection.TaxAmount, "NFD=2"));
	//	NewRow.Insert("total_amount" , Format(QuerySelection.TotalAmount, "NFD=2"));
	//	
	//	TotalAmount = TotalAmount + QuerySelection.TotalAmount;
	//	
	//	Details.data.Add(NewRow);	
	//EndDo;
	//
	//StatsCard = GetJson_StatsCard();
	//StatsCard.title = "Wholesale sales";
	//StatsCard.value = StrTemplate("%1 USD", Format(TotalAmount, "NFD=2")); 
	//StatsCard.icon  = "truck";
	//StatsCard.color = "green";
	//StatsCard.period = StrTemplate("%1 - %2", Format(StartDate,"DLF=D"), Format(EndDate, "DLF=D"));
	//
	//StatsCard.details.Add(Details);
	//
	//Return StatsCard;	
EndFunction

//Function CreateWidget_SalesReturns() 
//	
//	StartDate = BegOfMonth(CurrentSessionDate());
//	EndDate = EndOfMonth(CurrentSessionDate());
//	
//	Chart = DashboardServer.GetJson_Chart();
//	Chart.type = "Line";
//	Chart.details_type = "modal";
//	Chart.title = "Percent of sales returns"; 
//	Chart.category = StrTemplate("%1 - %2", Format(StartDate,"DLF=D"), Format(EndDate, "DLF=D"));
//	
//	Chart.data.labels.Add("Retail");
//	Chart.data.labels.Add("Wholesale");
//	
//	Retails_Series = New Array();
//	Wholesale_Series = New Array();
//	
//	Chart.data.series.Add(Retails_Series);
//	Chart.data.series.Add(Wholesale_Series);
//	
//	Return Chart;
//EndFunction

#EndRegion
