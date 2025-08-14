
Function CalculatePeriod(CurrentDate, PeriodType, LastPeriodType, LastPeriodCount) Export
	If Not ValueIsFilled(CurrentDate) Then
		CurrentDate = CurrentSessionDate();
	EndIf;
	
	Period = New Structure("StartDate, EndDate");
	
	If PeriodType = "last" Then
		Query = New Query("SELECT DATEADD(&Date, %1, &Count) AS StartDate");
		If LastPeriodType = "last_day" Then
			Query.Text = StrTemplate(Query.Text, "DAY");
		ElsIf LastPeriodType = "last_week" Then
			Query.Text = StrTemplate(Query.Text, "WEEK");
		ElsIf LastPeriodType = "last_month" Then
			Query.Text = StrTemplate(Query.Text, "MONTH");
		ElsIf LastPeriodType = "last_quarter" Then
			Query.Text = StrTemplate(Query.Text, "QUARTER");
		ElsIf LastPeriodType = "last_year" Then
			Query.Text = StrTemplate(Query.Text, "YEAR");
		Else
			Return Period;
		EndIf;
		
		Query.SetParameter("Date", CurrentDate);
		Query.SetParameter("Count", -LastPeriodCount);
		QuerySelection = Query.Execute().Select();
		QuerySelection.Next();
		
		Period.StartDate = BegOfDay(QuerySelection.StartDate);
		Period.EndDate = EndOfDay(CurrentDate);
		
	Else
		If PeriodType = "today" Then
			Period.StartDate = BegOfDay(CurrentDate);
			Period.EndDate = EndOfDay(CurrentDate);  
		ElsIf PeriodType = "this_week" Then
			Period.StartDate = BegOfWeek(CurrentDate);
			Period.EndDate = EndOfWeek(CurrentDate);  
		ElsIf PeriodType = "this_month" Then
			Period.StartDate = BegOfMonth(CurrentDate);
			Period.EndDate = EndOfMonth(CurrentDate);  
		ElsIf PeriodType = "this_quarter" Then
			Period.StartDate = BegOfQuarter(CurrentDate);
			Period.EndDate = EndOfQuarter(CurrentDate);  
		ElsIf PeriodType = "this_year" Then
			Period.StartDate = BegOfYear(CurrentDate);
			Period.EndDate = EndOfYear(CurrentDate); 
		EndIf;
	EndIf;

	Return Period;	
EndFunction

Function GetPeriodicity(Settings) Export
	PeriodicityMap = New Map();
	PeriodicityMap.Insert("by_hour"    , "HOUR");
	PeriodicityMap.Insert("by_day"     , "DAY");
	PeriodicityMap.Insert("by_week"    , "WEEK");
	PeriodicityMap.Insert("by_month"   , "MONTH");
	PeriodicityMap.Insert("by_querter" , "QUARTER");
	
	Return PeriodicityMap.Get(Settings.Periodicity);
EndFunction

Function AddToDate(Date, Periodicity) Export
	Query = New Query();
	Query.Text = "SELECT DATEADD(&Date, DAY, 1) AS NextDate";
	Query.Text = StrReplace(Query.Text, "DAY", Periodicity);
	Query.SetParameter("Date", Date);
	QuerySelection = Query.Execute().Select();
	QuerySelection.Next();
	Return QuerySelection.NextDate;
EndFunction	

#Region JSON_TEMPLATES

Function GetJson_Root() Export
	Return New Structure("stats_cards, charts", New Array(), New Array());
EndFunction

Function GetJson_StatsCard() Export
	json = New Structure(); 
	json.Insert("width", "col-md-3"); // total columns is 12
	json.Insert("title", "");
    json.Insert("value", "");
    json.Insert("icon", "clipboard-data"); // all icons names here https://icons.getbootstrap.com/ 
    json.Insert("color", "orange");
    json.Insert("period", "");
    json.Insert("component_name", "StatsCardDetails");
	json.Insert("widget_settings_href", "");
    json.Insert("details", New Array());
	Return json;
EndFunction

Function GetJson_StatsCard_Details() Export
	json = New Structure();
	json.Insert("tab_title", "");
	json.Insert("table_caption", "");
	json.Insert("columns", New Array());
	json.Insert("data", New Array());
	Return json;
EndFunction

Function GetJson_Chart() Export
	json = New Structure();
	json.Insert("type", ""); // Pie Bar Line
	json.Insert("width", "col-md-3"); // total columns is 12
	json.Insert("title", "");
	json.Insert("category", "");   
	json.Insert("widget_settings_href", "");
	
	json.Insert("details_type", ""); // modal inline
	
	// only for modal details type
	json.Insert("modal_title", "Details");
	json.Insert("modal_icon", "info-circle");
	json.Insert("component_name", "StatsCardDetails");
	
	// only for inline details type
	json.Insert("details_buttons", New Array());
	
	json.Insert("data", New Structure("labels, series", New Array(), New Array()));
	json.Insert("options", New Structure());
	json.options.Insert("showPoint", True); 

	json.Insert("details", New Array());
	
	Return json;
EndFunction

Function GetJon_Chart_DetailsButtons() Export
	Return New Structure("id, text", "", "");
EndFunction

Function GetJon_Chart_Details() Export
	json = New Structure();
	json.Insert("id", ""); // only for inline details
	json.Insert("table_caption", "");
	json.Insert("category", "");
	json.Insert("tab_title", ""); // only for modal details
	json.Insert("columns", New Array());
	json.Insert("data", New Array());
	
	Return json;
EndFunction

Function GetJson_Details_Column() Export
	json = New Structure();
	json.Insert("key", "");
	json.Insert("label", "");
	json.Insert("class", ""); // w-10 (column width 10%) w-40 (column width 40%)
	Return json;
EndFunction

Function Create_Details_Column(_Key, Label, Class) Export
	data = GetJson_Details_Column();
	data.key = _Key;
	data.label = Label;
	data.class = Class;
	Return data;
EndFunction

#EndRegion
