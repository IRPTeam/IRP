
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing) 
	ThisObject.Title = Parameters.Title; 
	ThisObject.IndicatorName = Parameters.IndicatorName;
	
	ThisObject.Options_Icon = Parameters.Options.Icon;
	ThisObject.Options_Color = Parameters.Options.Color;
	ThisObject.Options_DetailsType = Parameters.Options.DetailsType;
	ThisObject.Options_ModalTitle = Parameters.Options.ModalTitle;
	ThisObject.Options_ModalIcon = Parameters.Options.ModalIcon;
	ThisObject.Options_Width = Parameters.Options.Width;
	ThisObject.Options_TimeLineDateFormat = Parameters.Options.TimeLineDateFormat;
	
	ThisObject.ChartOptions_ShowPoint = Parameters.ChartOptions.ShowPoint;
	
	If Parameters.Settings <> Undefined Then
		ThisObject.WidgetType = Parameters.Settings.WidgetType;
		ThisObject.WidgetName = Parameters.Settings.WidgetName;
		ThisObject.WidgetID = Parameters.Settings.WidgetID;
	
		ThisObject.ChartType          = Parameters.Settings.ChartType;
		ThisObject.Period             = Parameters.Settings.Period;
		ThisObject.LastPeriodType     = Parameters.Settings.LastPeriodType;
		ThisObject.LastPeriodCount    = Parameters.Settings.LastPeriodCount;
		ThisObject.Periodicity        = Parameters.Settings.Periodicity;
		ThisObject.ComparePeriodCount = Parameters.Settings.ComparePeriodCount; 
		
		For Each Seria In Parameters.Settings.Series Do
			NewSeria = ThisObject.Series.Add();
			For Each KeyValue In Seria Do
				NewSeria[KeyValue.Key] = KeyValue.Value;
			EndDo;
		EndDo;
		
		ThisObject.Options_Icon        = Parameters.Settings.Options.Icon;
		ThisObject.Options_Color       = Parameters.Settings.Options.Color;
		ThisObject.Options_DetailsType = Parameters.Settings.Options.DetailsType;
		ThisObject.Options_ModalTitle  = Parameters.Settings.Options.ModalTitle;
		ThisObject.Options_ModalIcon   = Parameters.Settings.Options.ModalIcon; 
		ThisObject.Options_Width       = Parameters.Settings.Options.Width;
		ThisObject.Options_TimeLineDateFormat = Parameters.Settings.Options.TimeLineDateFormat;
	
		ThisObject.ChartOptions_ShowPoint = Parameters.Settings.ChartOptions.ShowPoint;
	EndIf;
	
	If Not ValueIsFilled(ThisObject.WidgetID) Then
		ThisObject.WidgetID = String(New UUID());
	EndIf;
	
	For Each ParameterName In Parameters.AvailableParameters Do
		ThisObject.AvailableParameters.Add().ParameterName = ParameterName;
	EndDo;
	
	AllParameters = New Array();
	AllParameters.Add("Company");
	AllParameters.Add("Branch");
	AllParameters.Add("CurrencyMovementType");
	AllParameters.Add("Store");
	
	For Each ParameterName In AllParameters Do
		Filter = New Structure();
		Filter.Insert("ParameterName", ParameterName);
		If ThisObject.AvailableParameters.FindRows(Filter).Count() = 0 Then
			Items["Series" + ParameterName].Visible = False;
		EndIf;
	EndDo;
	
	SetVisible(Object, ThisObject);
EndProcedure

&AtClient
Procedure SettingsOnChange(Item)
	SetVisible(Object, ThisObject);
EndProcedure

&AtClient
Procedure Ok(Command)
	Settings = GetSettingsAtServer();
	Close(Settings);
EndProcedure

&AtClient
Procedure Cancel(Command)
	Close();
EndProcedure

&AtServer
Function GetSettingsAtServer()
	Settings = New Structure();
	Settings.Insert("IndicatorName"      , ThisObject.IndicatorName);
	Settings.Insert("WidgetType"         , ThisObject.WidgetType);
	Settings.Insert("WidgetName"         , ThisObject.WidgetName);
	Settings.Insert("WidgetID"           , ThisObject.WidgetID);
	
	Settings.Insert("ChartType"          , ThisObject.ChartType);
	Settings.Insert("Period"             , ThisObject.Period);
	Settings.Insert("LastPeriodType"     , ThisObject.LastPeriodType);
	Settings.Insert("LastPeriodCount"    , ThisObject.LastPeriodCount);
	Settings.Insert("Periodicity"        , ThisObject.Periodicity);
	Settings.Insert("ComparePeriodCount" , ThisObject.ComparePeriodCount);
	
	Settings.Insert("Options", New Structure());
	Settings.Options.Insert("Icon"         , ThisObject.Options_Icon);
	Settings.Options.Insert("Color"        , ThisObject.Options_Color);
	Settings.Options.Insert("DetailsType"  , ThisObject.Options_DetailsType);
	Settings.Options.Insert("ModalTitle"   , ThisObject.Options_ModalTitle);
	Settings.Options.Insert("ModalIcon"    , ThisObject.Options_ModalIcon);
	Settings.Options.Insert("Width"        , ThisObject.Options_Width);
	Settings.Options.Insert("TimeLineDateFormat", ThisObject.Options_TimeLineDateFormat);
	
	Settings.Insert("ChartOptions", New Structure());
	Settings.ChartOptions.Insert("ShowPoint", ThisObject.ChartOptions_ShowPoint);
	
	Settings.Insert("Series", New Array());
	For Each Seria In ThisObject.Series Do
		NewSeria = New Structure("Title", Seria.Title);
		For Each Row In ThisObject.AvailableParameters Do
			NewSeria.Insert(Row.ParameterName, Seria[Row.ParameterName]);
		EndDo;
		Settings.Series.Add(NewSeria);
	EndDo;   
	Return Settings;
EndFunction

&AtClientAtServerNoContext
Procedure SetVisible(Object, Form)  
	
	_Available_Periodicity = False;
	_Available_ChartType = False;  
	_Available_Color = False;
	_Available_LastPeriod  = False;
	_Availale_ComparePeriodCount = False;
	
	// Widget type
	WidgetType_List = New ValueList();
	WidgetType_List.Add("chart", "Chart");
	WidgetType_List.Add("stats_card", "Stats Card");
	
	Form.Items.WidgetType.ChoiceList.Clear();
	For Each ListItem In WidgetType_List Do
		Form.Items.WidgetType.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo;
	If Not ValueIsFilled(Form.WidgetType) And Form.Items.WidgetType.ChoiceList.Count() Then
		Form.WidgetType = Form.Items.WidgetType.ChoiceList[0].Value;
	EndIf;

	_Available_ChartType = (Form.WidgetType = "chart");
	_Available_Color = (Form.WidgetType = "stats_card");
	
	Form.Items.SeriesTitle.Visible = (Form.WidgetType = "chart");
	
	// Details type
	DetailsType_List = New ValueList();
	If Form.WidgetType = "chart" Then
		DetailsType_List.Add("modal"  , "Modal");
		DetailsType_List.Add("inline" , "Inline");
	ElsIf Form.WidgetType = "stats_card" Then
		DetailsType_List.Add("modal" , "Modal");
	EndIf;
	
	Form.Items.Options_DetailsType.ChoiceList.Clear();
	For Each ListItem In DetailsType_List Do
		Form.Items.Options_DetailsType.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo;  
	
	If Form.Items.Options_DetailsType.ChoiceList.FindByValue(Form.Options_DetailsType) = Undefined Then
		Form.Options_DetailsType = "";
	EndIf;
	If Not ValueIsFilled(Form.Options_DetailsType) And Form.Items.Options_DetailsType.ChoiceList.Count() Then
		Form.Options_DetailsType = Form.Items.Options_DetailsType.ChoiceList[0].Value;
	EndIf; 
	
	// Color
	Color_List = New ValueList();
	If _Available_Color Then
		Color_List.Add("blue"   , "Blue");
		Color_List.Add("indigo" , "Indigo");
		Color_List.Add("purple" , "Purple");
		Color_List.Add("ping"   , "Pink");
		Color_List.Add("red"    , "Red");
		Color_List.Add("orange" , "Orange");
		Color_List.Add("yellow" , "Yellow");
		Color_List.Add("green"  , "Green");
		Color_List.Add("teal"   , "Teal");
		Color_List.Add("cyan"   , "Cyan");
	EndIf;

	Form.Items.Options_Color.ChoiceList.Clear();
	For Each ListItem In Color_List Do
		Form.Items.Options_Color.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo;  
	
	If Form.Items.Options_Color.ChoiceList.FindByValue(Form.Options_Color) = Undefined Then
		Form.Options_Color = "";
	EndIf;
	If Not ValueIsFilled(Form.Options_Color) And Form.Items.Options_Color.ChoiceList.Count() Then
		Form.Options_Color = Form.Items.Options_Color.ChoiceList[0].Value;
	EndIf;
	Form.Items.Options_Color.Enabled = _Available_Color; 
	
	// Width
	Width_List = New ValueList();
	Width_List.Add("col-md-1", "1");
	Width_List.Add("col-md-2", "2");
	Width_List.Add("col-md-3", "3");
	Width_List.Add("col-md-4", "4");
	Width_List.Add("col-md-5", "5");
	Width_List.Add("col-md-6", "6");
	Width_List.Add("col-md-7", "7");
	Width_List.Add("col-md-8", "8");
	Width_List.Add("col-md-9", "9");
	Width_List.Add("col-md-10", "10");
	Width_List.Add("col-md-11", "11");
	Width_List.Add("col-md-12", "12");
	
	Form.Items.Options_Width.ChoiceList.Clear();
	For Each ListItem In Width_List Do
		Form.Items.Options_Width.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo;  
	
	// Chart type
	ChartType_List = New ValueList();
	If _Available_ChartType Then
		ChartType_List.Add("Line", "Line");
		ChartType_List.Add("Bar", "Bar");
		ChartType_List.Add("Pie", "Pie");
	EndIf;
	
	Form.Items.ChartType.ChoiceList.Clear();
	For Each ListItem In ChartType_List Do
		Form.Items.ChartType.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo;  
	
	If Form.Items.ChartType.ChoiceList.FindByValue(Form.ChartType) = Undefined Then
		Form.ChartType = "";
	EndIf;
	If Not ValueIsFilled(Form.ChartType) And Form.Items.ChartType.ChoiceList.Count() Then
		Form.ChartType = Form.Items.ChartType.ChoiceList[0].Value;
	EndIf;

	Form.Items.ChartType.Enabled = _Available_ChartType; 
	_Available_Periodicity = (Form.ChartType = "Line" Or Form.ChartType = "Bar");  
	_Availale_ComparePeriodCount = (Form.ChartType = "Bar");
	
	// Period
	Period_List = New ValueList();
	Period_List.Add("today"        , "Today");
	Period_List.Add("this_week"    , "This week");
	Period_List.Add("this_month"   , "This month");
	Period_List.Add("this_quarter" , "This quarter");
	Period_List.Add("this_year"    , "This year");
	Period_List.Add("last"         , "Last");
	
	Form.Items.Period.ChoiceList.Clear();
	For Each ListItem In Period_List Do
		Form.Items.Period.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo; 
	If Not ValueIsFilled(Form.Period) And Form.Items.Period.ChoiceList.Count() Then
		Form.Period = Form.Items.Period.ChoiceList[0].Value;
	EndIf;
	
	_Available_LastPeriod = (Form.Period = "last");
	
	// Last period type
	LastPeriodType_List = New ValueList();
	If _Available_LastPeriod Then
		LastPeriodType_List.Add("last_day"     , "Day");
		LastPeriodType_List.Add("last_week"    , "Week");
		LastPeriodType_List.Add("last_month"   , "Month");
		LastPeriodType_List.Add("last_quarter" , "Quarter");
		LastPeriodType_List.Add("last_year"    , "Year");
	EndIf;
	
	Form.Items.LastPeriodType.ChoiceList.Clear();
	For Each ListItem In LastPeriodType_List Do
		Form.Items.LastPeriodType.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo; 
	If Form.Items.LastPeriodType.ChoiceList.FindByValue(Form.LastPeriodType) = Undefined Then
		Form.LastPeriodType = "";
	EndIf;
	If Not ValueIsFilled(Form.LastPeriodType) And Form.Items.LastPeriodType.ChoiceList.Count() Then
		Form.LastPeriodType = Form.Items.LastPeriodType.ChoiceList[0].Value;
	EndIf;
	Form.Items.LastPeriodCount.Enabled = _Available_LastPeriod;
	Form.Items.LastPeriodType.Enabled = _Available_LastPeriod;
	If Not _Available_LastPeriod Then
		Form.LastPeriodCount = 0;
	EndIf;
	
	// Periodicity   
	Periodicity_List = New ValueList();
	//_Periodicity_ByHour    = "by Hour";
	_Periodicity_ByDay     = "by Day";
	_Periodicity_ByWeek    = "by Week";
	_Periodicity_ByMonth   = "by Month";
	_Periodicity_ByQuarter = "by Quarter";
	
	If _Available_Periodicity Then
		//If Form.Period = "today" Then
			//Periodicity_List.Add("by_hour", _Periodicity_ByHour);
		If Form.Period = "this_week" Then
			Periodicity_List.Add("by_day", _Periodicity_ByDay);	
		ElsIf Form.Period = "this_month" Then
			Periodicity_List.Add("by_day", _Periodicity_ByDay);
			Periodicity_List.Add("by_week", _Periodicity_ByWeek);
		ElsIf Form.Period = "this_quarter" Then
			Periodicity_List.Add("by_week", _Periodicity_ByWeek);
			Periodicity_List.Add("by_month", _Periodicity_ByMonth);
		ElsIf Form.Period = "this_year" Then
			Periodicity_List.Add("by_week", _Periodicity_ByWeek);
			Periodicity_List.Add("by_month", _Periodicity_ByMonth);
			Periodicity_List.Add("by_quarter", _Periodicity_ByQuarter);
		ElsIf Form.Period = "last" Then
			If Form.LastPeriodType = "last_day" Then
				Periodicity_List.Add("by_day", _Periodicity_ByDay);	
			ElsIf Form.LastPeriodType = "last_week" Then
				Periodicity_List.Add("by_day", _Periodicity_ByDay);
			ElsIf Form.LastPeriodType = "last_month" Then
				Periodicity_List.Add("by_day", _Periodicity_ByDay);
				Periodicity_List.Add("by_week", _Periodicity_ByWeek);
			ElsIf Form.LastPeriodType = "last_year" Then
				Periodicity_List.Add("by_week", _Periodicity_ByWeek);
				Periodicity_List.Add("by_month", _Periodicity_ByMonth);
				Periodicity_List.Add("by_quarter", _Periodicity_ByQuarter);
			EndIf;		
		EndIf;
	EndIf;
	
	Form.Items.Periodicity.ChoiceList.Clear();
	For Each ListItem In Periodicity_List Do
		Form.Items.Periodicity.ChoiceList.Add(ListItem.Value, ListItem.Presentation);
	EndDo; 
	If Form.Items.Periodicity.ChoiceList.FindByValue(Form.Periodicity) = Undefined Then
		Form.Periodicity = "";
	EndIf; 
	If Not ValueIsFilled(Form.Periodicity) And Form.Items.Periodicity.ChoiceList.Count() Then
		Form.Periodicity = Form.Items.Periodicity.ChoiceList[0].Value;
	EndIf;
	Form.Items.Periodicity.Enabled = _Available_Periodicity;
	If Not _Available_Periodicity Then
		Form.Periodicity = "";
	EndIf;
	
	// Compare period count
	Form.Items.ComparePeriodCount.Enabled = _Availale_ComparePeriodCount;
	Form.Items.Decoration1.Enabled = _Availale_ComparePeriodCount;
	If Not _Availale_ComparePeriodCount Then
		Form.ComparePeriodCount = 0;
	EndIf;
	
	// Period preentation 
	_Period = DashboardServer.CalculatePeriod(Undefined, Form.Period, Form.LastPeriodType, Form.LastPeriodCount);
	Form.PeriodPresentation = String(_Period.StartDate) + " - " + String(_Period.EndDate);
EndProcedure

