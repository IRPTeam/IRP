
#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.IsDetailProcessing = Parameters.IsDetailProcessing;
	ReportFullName = ReportName(ThisObject);
	ExternalCommandsServer.CreateCommands(ThisObject, ReportFullName, Enums.FormTypes.ObjectForm);
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	If ThisObject.IsDetailProcessing Then
		ThisObject.VariantModified = False;
		ComposeResult();
	EndIf;

	CustomParametersSwitch();
	EditReportSwitch();
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure CustomParameters(Command)
	Items.FormCustomParameters.Check = Not Items.FormCustomParameters.Check;
	CustomParametersSwitch();
EndProcedure

&AtClient
Procedure EditReport(Command)
	Items.FormEditReport.Check = Not Items.FormEditReport.Check;
	EditReportSwitch();
EndProcedure

#EndRegion

#Region Commands

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Report, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Report, ThisObject, CommandName);
EndProcedure

#EndRegion

#Region Private

&AtClientAtServerNoContext
Function ReportName(Form)
	SplittedFormName = StrSplit(Form.FormName, ".");
	SplittedFormName.Delete(SplittedFormName.UBound());
	Return StrConcat(SplittedFormName, ".");
EndFunction

&AtClient
Procedure CustomParametersSwitch()
	Items.GroupCustomParameters.Visible = Items.FormCustomParameters.Check;
EndProcedure

&AtClient
Procedure EditReportSwitch()
	Items.GroupResultCommandBar.Visible = Items.FormEditReport.Check;
	Items.Result.Edit = Items.FormEditReport.Check;
EndProcedure

#EndRegion

&AtClient
Procedure ResultDetailProcessing(Item, Details, StandardProcessing, AdditionalParameters)
	_ReportName = StrSplit(ThisObject.FormName, ".")[1];
	ReportsWithDetailProcessing = GetReportsWithDetailProcesing();
	If ReportsWithDetailProcessing.Find(_ReportName) = Undefined Then
		Return; // report not support detail processing
	EndIf;
	
	DetailsInfo = ExtractDetailsInfo(_ReportName, Details);
	
	If Not DetailsInfo.AdditionalDetailsActions.MenuList.Count() Then
		Return; // additional menu list is empty
	EndIf;
	
	StandardProcessing = False;
	
	SourceOfSettings = New DataCompositionAvailableSettingsSource(ThisObject.Report);
	DetailsProcess = New DataCompositionDetailsProcess(ThisObject.DetailsData, SourceOfSettings);
	
	StandardActions = New Array();
	StandardActions.Add(DataCompositionDetailsProcessingAction.ApplyAppearance);
	StandardActions.Add(DataCompositionDetailsProcessingAction.DrillDown);
	StandardActions.Add(DataCompositionDetailsProcessingAction.Filter);
	StandardActions.Add(DataCompositionDetailsProcessingAction.Group);
	StandardActions.Add(DataCompositionDetailsProcessingAction.OpenValue);
	StandardActions.Add(DataCompositionDetailsProcessingAction.Order);
	StandardActions.Add(DataCompositionDetailsProcessingAction.None);
	
	NotifyParameters = New Structure("Details, DetailsInfo, ReportName", Details, DetailsInfo, _ReportName);
	
	Notify = New NotifyDescription("DoDetailProcess", ThisObject, NotifyParameters);
	DetailsProcess.ShowActionChoice(Notify, Details, StandardActions, DetailsInfo.AdditionalDetailsActions.MenuList);
EndProcedure

&AtClient
Procedure DoDetailProcess(SelectedAction, ApplyingSettings, NotifyParams) Экспорт

	If SelectedAction = DataCompositionDetailsProcessingAction.None Then
	Return;
	ElsIf SelectedAction = DataCompositionDetailsProcessingAction.DrillDown 
		Or SelectedAction = DataCompositionDetailsProcessingAction.ApplyAppearance
		Or SelectedAction = DataCompositionDetailsProcessingAction.Filter
		Or SelectedAction = DataCompositionDetailsProcessingAction.Group
		Or SelectedAction = DataCompositionDetailsProcessingAction.Order Then
		
		DetailsProcessDescription = New DataCompositionDetailsProcessDescription(ThisObject.DetailsData, NotifyParams.Details, ApplyingSettings);
		
		ReportParameters = New Structure();
		ReportParameters.Insert("GenerateOnOpen", True);
		ReportParameters.Insert("Details"       , DetailsProcessDescription);
		
		OpenForm(ThisObject.FormName, ReportParameters, , New UUID());
		
	ElsIf SelectedAction = DataCompositionDetailsProcessingAction.OpenValue Then
		ShowValue(,ApplyingSettings);
	Else
		
		OtherReportFormName = NotifyParams.DetailsInfo.AdditionalDetailsActions.OtherReportMapping[SelectedAction];
		//@skip-check use-non-recommended-method
		OtherReportForm = GetForm(OtherReportFormName, New Structure("IsDetailProcessing", True), ThisObject, New UUID());
		
		SettingsComposer1 = ThisObject.Report.SettingsComposer;
		SettingsComposer2 = OtherReportForm.Report.SettingsComposer;
		
		ApplyingFilters = GetApplyingFilters(NotifyParams.ReportName, SelectedAction, NotifyParams.DetailsInfo.DetailValuesMap);
		
		If ApplyingFilters.Property("DataParameters") Then
			For Each DataParameter In ApplyingFilters.DataParameters Do
				SourceParameter = GetSettingsComposerParameter(SettingsComposer1, DataParameter.Key);
				SetSettingsComposerParameter(SettingsComposer2, DataParameter.Value, SourceParameter.Value, SourceParameter.Use);
			EndDo;
		EndIf;
		
		If ApplyingFilters.Property("UserFilters") Then
			For Each UserFilter In ApplyingFilters.UserFilters Do
				SourceFilter = GetSettingsComposerFilter(SettingsComposer1, UserFilter.Key);
				If SourceFilter <> Undefined And SourceFilter.Use Then
					_Name = UserFilter.Value;
					_Value = SourceFilter.Value;
					_ComparisonType = SourceFilter.ComparisonType;
					SetSettingsComposerFilter(SettingsComposer2, _Name, _Value, _ComparisonType);
				EndIf;
			EndDo;
		EndIf;
		
		If ApplyingFilters.Property("DetailsFilters") Then
			For Each DetailFilter In ApplyingFilters.DetailsFilters Do
				_Name = DetailFilter.Value.FieldName;
				_Value = DetailFilter.Key;
				_ComparisonType = DetailFilter.Value.ComparisonType;
				SetSettingsComposerFilter(SettingsComposer2, _Name, _Value, _ComparisonType);
			EndDo;
		EndIf;
		
		If ApplyingFilters.Property("DetailsFiltersGroupOR") Then
			For Each GroupItem In ApplyingFilters.DetailsFiltersGroupOR Do
				GroupOr = CreateSettingsComposerFilterGroup(SettingsComposer2, "OR");
				For Each FilterItem In GroupItem Do
					For Each DetailFilter In FilterItem Do
						_Name = DetailFilter.Value.FieldName;
						_Value = DetailFilter.Key;
						_ComparisonType = DetailFilter.Value.ComparisonType;
						AddSettingsComposerFilterToGroup(SettingsComposer2, GroupOr, _Name, _Value, _ComparisonType);
					EndDo;
				EndDo;
			EndDo;
		EndIf;
		
		OtherReportForm.Open();
	EndIf;
EndProcedure

&AtServer
Function ExtractDetailsInfo(_ReportName, Details)
	DetailsDataPaths = Reports[_ReportName].GetDetailsDataPaths();
	ArrayOfDetailsDataPaths = StrSplit(DetailsDataPaths, ",");
	For i=0 To ArrayOfDetailsDataPaths.Count() -1 Do
		ArrayOfDetailsDataPaths[i] = TrimAll(ArrayOfDetailsDataPaths[i]);
	EndDo;
	
	Data = GetFromTempStorage(ThisObject.DetailsData);
	DetailValuesMap = Новый Map();
	FillMapByDataPaths(Data.Items[Details], DetailValuesMap, ArrayOfDetailsDataPaths);
	
	AdditionalDetailsActions = Reports[_ReportName].GetAdditionalDetailsActions(DetailValuesMap);
	
	Return New Structure("DetailValuesMap, AdditionalDetailsActions", DetailValuesMap, AdditionalDetailsActions);
EndFunction

&AtServer
Procedure FillMapByDataPaths(FieldOrGroup, DetailValuesMap, ArrayOfDetailsDataPaths)
	ArrayOfParents = FieldOrGroup.GetParents();
	For Each Parent In ArrayOfParents Do
		If TypeOf(Parent) = Type("DataCompositionGroupDetailsItem") Then
			FillMapByDataPaths(Parent, DetailValuesMap, ArrayOfDetailsDataPaths);	
		ElsIf TypeOf(Parent) = Type("DataCompositionFieldDetailsItem") Then
			ArrayOfFields = Parent.GetFields();
			For Each FieldInfo In ArrayOfFields Do
				If ArrayOfDetailsDataPaths.Find(FieldInfo.Field) <> Undefined 
					And Not ValueIsFilled(DetailValuesMap[FieldInfo.Field]) Then
					DetailValuesMap[FieldInfo.Field] = FieldInfo.Value;
				EndIf;
				FillMapByDataPaths(Parent, DetailValuesMap, ArrayOfDetailsDataPaths);
			EndDo;
		EndIf;
	EndDo;
EndProcedure

&AtServer
Function GetApplyingFilters(_ReportName, SelectedAction, DetailValuesMap)
	Return Reports[_ReportName].GetApplyingFilters(SelectedAction, DetailValuesMap);
EndFunction

&AtClient
Function GetSettingsComposerFilter(SettingsComposer, Name)
	FindField = New DataCompositionField(Name);
	For Each Item In SettingsComposer.Settings.Filter.Items Do
		If Item.LeftValue = FindField Then
			//@skip-check unknown-method-property
			UserFilterItem = SettingsComposer.UserSettings.Items.Find(Item.UserSettingID);
			Filter = New Structure();
			Filter.Insert("Value", UserFilterItem.RightValue);
			Filter.Insert("Use", UserFilterItem.Use);
			Filter.Insert("ComparisonType", UserFilterItem.ComparisonType);
			Return Filter;
 		EndIf;
	EndDo;;
	Return Undefined;
EndFunction

&AtClient
Function GetSettingsComposerParameter(SettingsComposer, Name)
	Id = SettingsComposer.Settings.DataParameters.Items.Find(Name).UserSettingID;
	Parameter = SettingsComposer.UserSettings.Items.Find(Id); 
	Return New Structure("Value, Use", Parameter.Value, Parameter.Use);
EndFunction

&AtClient
Procedure SetSettingsComposerParameter(SettingsComposer, Name, Value, Use)
	Id = SettingsComposer.Settings.DataParameters.Items.Find(Name).UserSettingID;
	Parameter = SettingsComposer.UserSettings.Items.Find(Id);
	Parameter.Value = Value;
	Parameter.Use = Use;
EndProcedure

&AtClient
Procedure SetSettingsComposerFilter(SettingsComposer, Name, Value, ComparisonType)   
	Field = New DataCompositionField(Name);
	
	FilterItem = Undefined;
	For Each Item In SettingsComposer.Settings.Filter.Items Do
		If Item.LeftValue = Field Then
			FilterItem = Item;
			Break;
		EndIf;
	EndDo; 
	
	If FilterItem <> Undefined Then
		UserFilterItem = SettingsComposer.UserSettings.Items.Find(FilterItem.UserSettingID);      
		UserFilterItem.ComparisonType = ComparisonType;
		UserFilterItem.Use = True;
		UserFilterItem.RightValue = Value;
		Return;
	EndIf;  
	
	Found = False;
	For Each Item In SettingsComposer.UserSettings.Items Do
		If TypeOf(Item) = Type("DataCompositionFilter") Then
			UserFilterItem = Item.Items.Add(Type("DataCompositionFilterItem"));
			UserFilterItem.LeftValue = Field;
			UserFilterItem.ComparisonType = ComparisonType;
			UserFilterItem.Use = True;
			UserFilterItem.RightValue = Value;
			Found = True;
		EndIf;
	EndDo;
	
	If Not Found Then
		If SettingsComposer.Settings.Filter.FilterAvailableFields.Items.Find(Name) <> Undefined Then
			UserFilterItem = SettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItem"));
			UserFilterItem.LeftValue = Field;
			UserFilterItem.ComparisonType = ComparisonType;
			UserFilterItem.Use = True;
			UserFilterItem.RightValue = Value;
			UserFilterItem.UserSettingID = New UUID();
		EndIf;
	EndIf;
EndProcedure

&AtClient
Function CreateSettingsComposerFilterGroup(SettingsComposer, GroupType)
	FilterGroup = SettingsComposer.Settings.Filter.Items.Add(Type("DataCompositionFilterItemGroup"));
	If Upper(GroupType) = "OR" Then
		FilterGroup.GroupType = DataCompositionFilterItemsGroupType.OrGroup;
	ElsIf Upper(GroupType) = "NOT" Then
		FilterGroup.GroupType = DataCompositionFilterItemsGroupType.NotGroup;
	ElsIf Upper(GroupType) = "AND" Then
		FilterGroup.GroupType = DataCompositionFilterItemsGroupType.AndGroup;
	EndIf;
	Return FilterGroup;
EndFunction

&AtClient
Procedure AddSettingsComposerFilterToGroup(SettingsComposer, FilterGroup, Name, Value, ComparisonType)
	If SettingsComposer.Settings.Filter.FilterAvailableFields.Items.Find(Name) <> Undefined Then
		UserFilterItem = FilterGroup.Items.Add(Type("DataCompositionFilterItem"));
		UserFilterItem.LeftValue = New DataCompositionField(Name);
		UserFilterItem.ComparisonType = ComparisonType;
		UserFilterItem.Use = True;
		UserFilterItem.RightValue = Value;
//		UserFilterItem.UserSettingID = New UUID();
	EndIf;
EndProcedure

&AtClient
Function GetReportsWithDetailProcesing()
	ReportsWithDetails = New Array();
	ReportsWithDetails.Add("TrialBalance");
	ReportsWithDetails.Add("TrialBalanceByAccount");
	ReportsWithDetails.Add("AccountAnalysis");
	Return ReportsWithDetails;
EndFunction
