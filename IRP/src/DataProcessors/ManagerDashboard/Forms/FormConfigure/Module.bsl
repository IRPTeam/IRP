	 
&AtClient
Var _CloseForm;

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.User = SessionParameters.CurrentUser; 
	RestoreSettings();
EndProcedure

&AtClient
Procedure UserOnChange(Item)
	RestoreSettings();	
EndProcedure

&AtClient
Procedure WidgetsBeforeAddRow(Item, Cancel, Clone, Parent, Folder, Parameter)
	Cancel = True;
EndProcedure

&AtClient
Procedure WidgetsSelection(Item, SelectedRow, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Item.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	DashboardClient.OpenFormWidgetSettings(Object, ThisObject, CurrentData.IndicatorName, CurrentData.Json);
EndProcedure

&AtClient
Procedure Cancel(Command)
	_CloseForm = True;
	Close();
EndProcedure

&AtClient
Procedure BeforeClose(Cancel, Exit, MessageText, StandardProcessing)
	If Exit Or _CloseForm Then
		Return;
	EndIf;
	If ThisObject.Modified Then 
		Cancel = True;
		Calback = New CallbackDescription("AfterSaveQueryClose", ThisObject);
		ShowQueryBox(Calback, "Save settings?", QuestionDialogMode.YesNoCancel);
	EndIf;	
EndProcedure

&AtClient
Procedure Save(Command)
	SaveAtServer();
	ThisObject.Modified = False;
	_CloseForm = True;
	Close();
EndProcedure

&AtClient
Procedure AfterSaveQueryClose(Result, Parameters) Export
    If Result = DialogReturnCode.Yes Then
        SaveAtServer();
		_CloseForm = True;
		Close();
	ElsIf Result = DialogReturnCode.No Then
		_CloseForm = True;
		Close();
    EndIf;
EndProcedure

&AtServer
Procedure SaveAtServer()
	RecordSet = InformationRegisters.DashboardSettings.CreateRecordSet();
	RecordSet.Filter.User.Set(ThisObject.User);
	Record = RecordSet.Add();
	Record.User = ThisObject.User;
	
	Settings = New Structure();
	Settings.Insert("SalesWidgets"      , CollectSettingsFromTable("SalesWidgets"));
	Settings.Insert("PurchasesWidgets"  , CollectSettingsFromTable("PurchasesWidgets"));
	Settings.Insert("MoneyWidgets"      , CollectSettingsFromTable("MoneyWidgets")); 
	
	Record.Settings = CommonFunctionsServer.SerializeJSONUseXDTO(Settings);
	RecordSet.Write();
EndProcedure

&AtServer
Function CollectSettingsFromTable(TableName)
	Result = New Array();
	For Each Row In ThisObject[TableName] Do
		Settings = New Structure("Enabled, WidgetName, Type, ID, Json, IndicatorName");
		FillPropertyValues(Settings, Row);
		Result.Add(Settings);
	EndDo;
	Return Result;
EndFunction

&AtServer
Procedure RestoreSettings()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	DashboardSettings.Settings AS Settings
	|FROM
	|	InformationRegister.DashboardSettings AS DashboardSettings
	|WHERE
	|	DashboardSettings.User = &User";
	Query.SetParameter("User", ThisObject.User);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.SalesWidgets.Clear();
	ThisObject.PurchasesWidgets.Clear();
	ThisObject.MoneyWidgets.Clear();
	
	If QuerySelection.Next() Then     
		Settings = CommonFunctionsServer.DeserializeJSONUseXDTO(QuerySelection.Settings);
		
		LoadSettingsToTable("SalesWidgets"     , Settings.SalesWidgets);
		LoadSettingsToTable("PurchasesWidgets" , Settings.PurchasesWidgets);
		LoadSettingsToTable("MoneyWidgets"     , Settings.MoneyWidgets);
	EndIf;
EndProcedure

&AtServer
Procedure LoadSettingsToTable(TableName, Settings)
	For Each Row In Settings Do
		FillPropertyValues(ThisObject[TableName].Add(), Row);
	EndDo;
EndProcedure

&AtClient
Procedure CreateNewWidget(Command)
	DashboardClient.OpenFormWidgetSettings(Object, ThisObject, Command.Name);
EndProcedure

&AtClient
Procedure OnCloseWidgetSettings(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf; 
	
	ThisObject.Modified = True;
	
	IndicatorMap = New Map();
	IndicatorMap.Insert("SalesAmount", "SalesWidgets");
	
	IndicatorMap.Insert("Money_ApAr", "MoneyWidgets");
	IndicatorMap.Insert("Money_CashBalance", "MoneyWidgets");
	IndicatorMap.Insert("Money_PaymentsFromClients", "MoneyWidgets");
	IndicatorMap.Insert("Money_PaymentsToSuppliers", "MoneyWidgets");
	IndicatorMap.Insert("Purchases_StockBalance", "PurchasesWidgets");
	IndicatorMap.Insert("Purchases_VolumeOfPurchases", "PurchasesWidgets");
	IndicatorMap.Insert("Sales_AverageBill", "SalesWidgets");
	IndicatorMap.Insert("Sales_SalerReturnPercentage", "SalesWidgets");
	IndicatorMap.Insert("Sales_SalesAmount", "SalesWidgets");
	
	Filter = New Structure();
	Filter.Insert("ID", Result.WidgetID);
	WidgetRows = ThisObject[IndicatorMap.Get(Result.IndicatorName)].FindRows(Filter);
	If WidgetRows.Count() > 0 Then
		WidgetRow = WidgetRows[0];
	Else
		WidgetRow = ThisObject[IndicatorMap.Get(Result.IndicatorName)].Add();	
	EndIf;
	
	WidgetRow.ID = Result.WidgetID;
	WidgetRow.WidgetName = Result.WidgetName;
	WidgetRow.Type = Result.WidgetType;
	WidgetRow.IndicatorName = Result.IndicatorName;
	WidgetRow.Json = CommonFunctionsServer.SerializeJSONUseXDTO(Result);
EndProcedure

_CloseForm = False;

























