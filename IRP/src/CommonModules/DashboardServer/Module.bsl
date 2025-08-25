
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

Function CreateLabels(Period, Settings) Export
	Labels = New Array();
	LabelsFormated = New Array(); 
	Intervals = New Array();
	
	Result = New Structure("Labels, LabelsFormated, Intervals", Labels, LabelsFormated, Intervals);

	Periodicity = GetPeriodicity(Settings);
	
	If Not ValueIsFilled(Periodicity) Then  
		For Each Seria In Settings.Series Do
			Result.LabelsFormated.Add(Seria.Title);
		EndDo;
		Return Result;
	EndIf;
	
	StartDate = Period.StartDate;
	Result.Labels.Add(BegOfDay(StartDate));
	
	While StartDate < BegOfDay(Period.EndDate) Do
		StartDate = AddToDate(StartDate, Periodicity);
		
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
		Interval.EndDate = AddToDate(Label, Periodicity)-1;
		Result.Intervals.Add(Interval);
	EndDo;
	
	Return Result;
EndFunction

Function GetPeriodPresentation(Period) Export
	If BegOfDay(Period.StartDate) = BegOfDay(Period.EndDate) Then
		Return Format(Period.StartDate,"DLF=D");
	Else
		Return StrTemplate("%1 - %2", Format(Period.StartDate,"DLF=D"), Format(Period.EndDate, "DLF=D"));
	EndIf;
EndFunction

Function GetValue_Money_ApAr(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.Currency AS Currency,
	|	CASE
	|		WHEN &Filter_DebtType = VALUE(enum.AccountingAnalyticTypes.Debit)
	|			THEN Reg.CustomerTransactionClosingBalance + Reg.VendorAdvanceClosingBalance
	|		WHEN &Filter_DebtType = VALUE(enum.AccountingAnalyticTypes.Credit)
	|			THEN -(Reg.VendorTransactionClosingBalance + Reg.CustomerAdvanceClosingBalance)
	|	END AS Amount
	|FROM
	|	AccumulationRegister.R5020B_PartnersBalance.BalanceAndTurnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate,
	|		DAY), Day,, CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &Filter_Company
	|			THEN Company = &Company
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Branch
	|			THEN Branch = &Branch
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Currency
	|			THEN Currency = &Currency
	|		ELSE TRUE
	|	END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS
	|BY
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
				Value = Value + DetailsSelection.Amount;	
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
		
	Else // single value   
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.Amount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
		
	Details = New Array();
	If Settings.WidgetType = "stats_card" Then
		json = GetJson_StatsCard_Details();
		json.tab_title = R().Dashboard_07;
		json.table_caption = GetPeriodPresentation(Period);
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
		
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);
	ElsIf Settings.WidgetType = "chart" Then
		json = GetJon_Chart_Details();
		json.id = SeriaData.ID;
		json.table_caption = SeriaData.Seria.Title;
		json.category = GetPeriodPresentation(Period);
		json.tab_title = R().Dashboard_07;
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
	
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);			
	EndIf;
	
	Return New Structure("Series, Details", Series, Details);
EndFunction

Function GetValue_Money_CashBalance(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.Account AS Account,
	|	Reg.Currency AS Currency,
	|	Reg.AmountClosingBalance AS Amount
	|FROM
	|	AccumulationRegister.R3010B_CashOnHand.BalanceAndTurnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate,
	|		DAY), Day,, CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &Filter_Company
	|			THEN Company = &Company
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Branch
	|			THEN Branch = &Branch
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Account
	|			THEN Account = &Account
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Currency
	|			THEN Currency = &Currency
	|		ELSE TRUE
	|	END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS
	|BY
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
				Value = Value + DetailsSelection.Amount;	
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
		
	Else // single value   
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.Amount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
	
	Details = New Array();
	If Settings.WidgetType = "stats_card" Then
		json = GetJson_StatsCard_Details();
		json.tab_title = R().Dashboard_04;
		json.table_caption = GetPeriodPresentation(Period);
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-40"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-20"));
		json.columns.Add(Create_Details_Column("Account"  , "Account"  , "w-20"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
		
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Account"   , String(DetailsSelection.Account));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);
	ElsIf Settings.WidgetType = "chart" Then
		json = GetJon_Chart_Details();
		json.id = SeriaData.ID;
		json.table_caption = SeriaData.Seria.Title;
		json.category = GetPeriodPresentation(Period);
		json.tab_title = R().Dashboard_04;
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-40"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-20"));
		json.columns.Add(Create_Details_Column("Account"  , "Account"  , "w-20"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
	
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Account"   , String(DetailsSelection.Account));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);			
	EndIf;
	
	Return New Structure("Series, Details", Series, Details);
EndFunction

Function GetValue_Money_PaymentsFromClients(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Return GetValue_Money_Payments(Period, IndicatorParameters, Settings, LabelsData, SeriaData, "Dashboard_05");
EndFunction

Function GetValue_Money_PaymentsToSuppliers(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Return GetValue_Money_Payments(Period, IndicatorParameters, Settings, LabelsData, SeriaData, "Dashboard_06");
EndFunction

Function GetValue_Purchases_StockBalance(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export

EndFunction

Function GetValue_Purchases_VolumeOfPurchases(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.Currency AS Currency,
	|	Reg.AmountTurnover AS Amount
	|FROM
	|	AccumulationRegister.R1001T_Purchases.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY), Day,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &Filter_Company
	|			THEN Company = &Company
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Branch
	|			THEN Branch = &Branch
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Currency
	|			THEN Currency = &Currency
	|		ELSE TRUE
	|	END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS
	|BY
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
				Value = Value + DetailsSelection.Amount;	
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
		
	Else // single value   
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.Amount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
	
	Details = New Array();
	If Settings.WidgetType = "stats_card" Then
		json = GetJson_StatsCard_Details();
		json.tab_title = R().Dashboard_09;
		json.table_caption = GetPeriodPresentation(Period);
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
		
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);
	ElsIf Settings.WidgetType = "chart" Then
		json = GetJon_Chart_Details();
		json.id = SeriaData.ID;
		json.table_caption = SeriaData.Seria.Title;
		json.category = GetPeriodPresentation(Period);
		json.tab_title = R().Dashboard_09;
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
	
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);			
	EndIf;
	
	Return New Structure("Series, Details", Series, Details);
EndFunction

Function GetValue_Sales_AverageBill(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export

EndFunction

Function GetValue_Sales_SalerReturnPercentage(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export

EndFunction

Function GetValue_Sales_SalesAmount(Period, IndicatorParameters, Settings, LabelsData, SeriaData) Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.Currency AS Currency,
	|	Reg.AmountTurnover AS Amount
	|FROM
	|	AccumulationRegister.R2001T_Sales.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY), Day,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &Filter_Company
	|			THEN Company = &Company
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Branch
	|			THEN Branch = &Branch
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Currency
	|			THEN Currency = &Currency
	|		ELSE TRUE
	|	END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS
	|BY
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
				Value = Value + DetailsSelection.Amount;	
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
		
	Else // single value   
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.Amount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
	
	Details = New Array();
	If Settings.WidgetType = "stats_card" Then
		json = GetJson_StatsCard_Details();
		json.tab_title = R().Dashboard_01;
		json.table_caption = GetPeriodPresentation(Period);
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
		
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);
	ElsIf Settings.WidgetType = "chart" Then
		json = GetJon_Chart_Details();
		json.id = SeriaData.ID;
		json.table_caption = SeriaData.Seria.Title;
		json.category = GetPeriodPresentation(Period);
		json.tab_title = R().Dashboard_01;
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
	
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);			
	EndIf;
	
	Return New Structure("Series, Details", Series, Details);
EndFunction			

Function GetValue_Money_Payments(Period, IndicatorParameters, Settings, LabelsData, SeriaData, Title)
	Query = New Query();
	Query.Text = 
	"SELECT
	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.Currency AS Currency,
	|	Reg.AmountTurnover AS Amount
	|FROM
	|	AccumulationRegister.R3011T_CashFlow.Turnovers(BEGINOFPERIOD(&StartDate, DAY), ENDOFPERIOD(&EndDate, DAY), Day,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|	AND CASE
	|		WHEN &Filter_Company
	|			THEN Company = &Company
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Branch
	|			THEN Branch = &Branch
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_Currency
	|			THEN Currency = &Currency
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_FinancialMovementType
	|			THEN FinancialMovementType = &FinancialMovementType
	|		ELSE TRUE
	|	END) AS Reg
	|
	|ORDER BY
	|	Period
	|TOTALS
	|BY
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
				Value = Value + DetailsSelection.Amount;	
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
		
	Else // single value   
		Value = 0;
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				Value = Value + DetailsSelection.Amount;	
			EndDo;
		EndDo;
		Series.Add(Value);
	EndIf;
	
	Details = New Array();
	If Settings.WidgetType = "stats_card" Then
		json = GetJson_StatsCard_Details();
		json.tab_title = R()[Title];
		json.table_caption = GetPeriodPresentation(Period);
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
		
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);
	ElsIf Settings.WidgetType = "chart" Then
		json = GetJon_Chart_Details();
		json.id = SeriaData.ID;
		json.table_caption = SeriaData.Seria.Title;
		json.category = GetPeriodPresentation(Period);
		json.tab_title = R()[Title];
		json.columns.Add(Create_Details_Column("Period"   , "Period"   , "w-5"));
		json.columns.Add(Create_Details_Column("Company"  , "Company"  , "w-50"));
		json.columns.Add(Create_Details_Column("Branch"   , "Branch"   , "w-30"));
		json.columns.Add(Create_Details_Column("Currency" , "Currency" , "w-5"));
		json.columns.Add(Create_Details_Column("Amount"   , "Amount"   , "w-10"));
	
		QuerySelection.Reset();
		While QuerySelection.Next() Do
			DetailsSelection = QuerySelection.Select();
			While DetailsSelection.Next() Do
				NewRow = New Structure();
				NewRow.Insert("Period"    , Format(DetailsSelection.Period, "DLF=D"));
				NewRow.Insert("Company"   , String(DetailsSelection.Company));
				NewRow.Insert("Branch"    , String(DetailsSelection.Branch));
				NewRow.Insert("Currency"  , String(DetailsSelection.Currency));
				NewRow.Insert("Amount"    , Format(DetailsSelection.Amount, "NFD=2"));
				json.data.Add(NewRow);
			EndDo;
		EndDo;		
		Details.Add(json);			
	EndIf;
	
	Return New Structure("Series, Details", Series, Details);
EndFunction

//Function GetValue_Sales_SalesAmount(Period, IndicatorParameters, Settings, LabelsData) Export
//	Query = New Query();
//	Query.Text = 
//	"SELECT
//	|	BEGINOFPERIOD(Reg.Period, DAY) AS Period,
//	|	REFPRESENTATION(Reg.Invoice) AS Invoice,
//	|	Reg.Currency AS Currency,
//	|	Reg.AmountTurnover AS TotalAmount,
//	|	Reg.NetAmountTurnover AS NetAmount,
//	|	Reg.OffersAmountTurnover AS OfferAmount,
//	|	Reg.AmountTurnover - Reg.NetAmountTurnover AS TaxAmount
//	|FROM
//	|	AccumulationRegister.R2001T_Sales.Turnovers(
//	|			BEGINOFPERIOD(&StartDate, DAY),
//	|			ENDOFPERIOD(&EndDate, DAY),
//	|			Hour,
//	|			CASE
//	|					WHEN &Filter_Company
//	|						THEN Company = &Company
//	|					ELSE TRUE
//	|				END
//	|				AND CASE
//	|					WHEN &Filter_CurrencyMovementType
//	|						THEN CurrencyMovementType = &CurrencyMovementType
//	|					ELSE TRUE
//	|				END
//	|				AND CASE
//	|					WHEN &Filter_Branch
//	|						THEN Branch = &Branch
//	|					ELSE TRUE
//	|				END) AS Reg
//	|
//	|ORDER BY
//	|	Period
//	|TOTALS BY
//	|	Period";
//	
//	Query.SetParameter("StartDate" , Period.StartDate);
//	Query.SetParameter("EndDate"   , Period.EndDate);
//	
//	For Each KeyValue In IndicatorParameters Do
//		Query.SetParameter("Filter_" + KeyValue.Key, ValueIsFilled(KeyValue.Value));
//		Query.SetParameter(KeyValue.Key, KeyValue.Value);
//	EndDo;
//	
//	QueryResult = Query.Execute();
//	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
//	
//	SeriesTable = New ValueTable();
//	SeriesTable.Columns.Add("Date");
//	SeriesTable.Columns.Add("Value");
//	
//	Series = New Array();
//	
//	If ValueIsFilled(Settings.Periodicity) Then // Time line
//		While QuerySelection.Next() Do
//			DetailsSelection = QuerySelection.Select();
//			Value = 0;
//			While DetailsSelection.Next() Do
//				Value = Value + DetailsSelection.TotalAmount;	
//			EndDo;
//			NewSeriesRow = SeriesTable.Add();
//			NewSeriesRow.Date = BegOfDay(QuerySelection.Period);
//			NewSeriesRow.Value = Value;
//		EndDo;
//		
//		SeriesTable.GroupBy("Date", "Value");
//		
//		For Each Interval In LabelsData.Intervals Do
//			For Each Row In SeriesTable Do
//				If Row.Date >= Interval.StartDate And Row.Date <= Interval.EndDate Then
//					Row.Date = Interval.StartDate;
//				EndIf;
//			EndDo;
//		EndDo;
//		
//		SeriesTable.GroupBy("Date", "Value");
//		
//		For Each Label In LabelsData.Labels Do
//			If SeriesTable.FindRows(New Structure("Date", Label)).Count() = 0 Then
//				NewSeriesRow = SeriesTable.Add();
//				NewSeriesRow.Date = BegOfDay(Label);
//				NewSeriesRow.Value = 0;
//			EndIf;
//		EndDo;
//		
//		SeriesTable.Sort("Date");
//		Series = SeriesTable.UnloadColumn("Value");
//		
//	Else // single value   
//		Value = 0;
//		While QuerySelection.Next() Do
//			DetailsSelection = QuerySelection.Select();
//			While DetailsSelection.Next() Do
//				Value = Value + DetailsSelection.TotalAmount;	
//			EndDo;
//		EndDo;
//		Series.Add(Value);
//	EndIf;
//	
//	Return New Structure("Series", Series);
//	
//	//
//	//Details = GetJson_StatsCard_Details();
//	//Details.tab_title = "Wholesale sales";
//	//Details.table_caption = StrTemplate("%1 - %2", Format(StartDate,"DLF=D"), Format(EndDate, "DLF=D"));
//	//
//	//Details.columns.Add(Create_Details_Column("invoice"      , "Invoice" , "w-50"));
//	//Details.columns.Add(Create_Details_Column("offer_amount" , "Offer"   , "w-10"));
//	//Details.columns.Add(Create_Details_Column("net_amount"   , "Net"     , "w-10"));
//	//Details.columns.Add(Create_Details_Column("tax_amount"   , "Tax"     , "w-10"));
//	//Details.columns.Add(Create_Details_Column("total_amount" , "Total"   , "w-10"));
//	//
//	//TotalAmount = 0;
//	//While QuerySelection.Next() Do                                         
//	//	NewRow = New Structure();
//	//	NewRow.Insert("invoice"      , QuerySelection.Invoice);
//	//	NewRow.Insert("offer_amount" , Format(QuerySelection.OfferAmount, "NFD=2"));
//	//	NewRow.Insert("net_amount"   , Format(QuerySelection.NetAmount, "NFD=2"));
//	//	NewRow.Insert("tax_amount"   , Format(QuerySelection.TaxAmount, "NFD=2"));
//	//	NewRow.Insert("total_amount" , Format(QuerySelection.TotalAmount, "NFD=2"));
//	//	
//	//	TotalAmount = TotalAmount + QuerySelection.TotalAmount;
//	//	
//	//	Details.data.Add(NewRow);	
//	//EndDo;
//	//
//	//StatsCard = GetJson_StatsCard();
//	//StatsCard.title = "Wholesale sales";
//	//StatsCard.value = StrTemplate("%1 USD", Format(TotalAmount, "NFD=2")); 
//	//StatsCard.icon  = "truck";
//	//StatsCard.color = "green";
//	//StatsCard.period = StrTemplate("%1 - %2", Format(StartDate,"DLF=D"), Format(EndDate, "DLF=D"));
//	//
//	//StatsCard.details.Add(Details);
//	//
//	//Return StatsCard;	
//EndFunction


























