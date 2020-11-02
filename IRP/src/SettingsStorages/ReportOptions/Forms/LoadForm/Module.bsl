
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.ObjectKey = Parameters.ObjectKey;
	ThisObject.CurrentSettingsKey = Parameters.CurrentSettingsKey;
	
	OptionsList.Parameters.SetParameterValue("ObjectKey", ThisObject.ObjectKey);
	OptionsList.Parameters.SetParameterValue("CurrentSettingsKey", ThisObject.CurrentSettingsKey);
	OptionsList.Parameters.SetParameterValue("Author", SessionParameters.CurrentUser);
	
	For Each StandardSetting In Parameters.StandardSettings Do
		NewRow = ThisObject.StandardOptions.Add();
		NewRow.Presentation = StandardSetting.Presentation;
		NewRow.OptionKey = StandardSetting.Value;
	EndDo;
	
	FoundCustomOption = Catalogs.ReportOptions.FindByCode(ThisObject.CurrentSettingsKey);
	If FoundCustomOption.IsEmpty() Then
		StandardOptionsFilter = New Structure("OptionKey", ThisObject.CurrentSettingsKey);
		FoundStandardOption = ThisObject.StandardOptions.FindRows(StandardOptionsFilter);
		If FoundStandardOption.Count() Then
			FoundStandardOption[0].isCurrentOption = True;
			Items.GroupOptionTypes.CurrentPage = Items.GroupPageStandard;
			Items.StandardOptions.CurrentRow = FoundStandardOption[0].GetID();
		EndIf;
	Else
		Items.GroupOptionTypes.CurrentPage = Items.GroupPageCustom;
		Items.OptionsList.CurrentRow = FoundCustomOption;
	EndIf;
	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	ShowMarkedForDeleteReportOptions();
EndProcedure

&AtClient
Procedure OptionsListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.OptionsList.CurrentData;
	LoadChosenSetting(CurrentData.OptionKey);
EndProcedure

&AtClient
Procedure StandardOptionsSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentData = Items.StandardOptions.CurrentData;
	LoadChosenSetting(CurrentData.OptionKey);
EndProcedure


&AtClient
Procedure LoadSetting(Command)
	If Items.GroupOptionTypes.CurrentPage = Items.GroupPageCustom Then
		CurrentData = Items.OptionsList.CurrentData;
	ElsIf Items.GroupOptionTypes.CurrentPage = Items.GroupPageStandard Then
		CurrentData = Items.StandardOptions.CurrentData;		
	Else
		Return; 
	EndIf;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	OptionKey = CurrentData.OptionKey;
	LoadChosenSetting(OptionKey);
EndProcedure

&AtClient
Procedure LoadChosenSetting(Val OptionKey)
	Close(New SettingsChoice(OptionKey));
EndProcedure

&AtClient
Procedure ShowMarkedForDeletion(Command)
	Items.OptionsListShowMarkedForDeletion.Check = Not Items.OptionsListShowMarkedForDeletion.Check;
	ShowMarkedForDeleteReportOptions();
EndProcedure

&AtClient
Procedure ShowMarkedForDeleteReportOptions()
	UseDeletionMarkFilter = Items.OptionsListShowMarkedForDeletion.Check;
	LeftValue = New DataCompositionField("DeletionMark");
	EditedFilterItem = Undefined;
	For Each FilterItem In OptionsList.Filter.Items Do
		If FilterItem.LeftValue = LeftValue Then
			EditedFilterItem = FilterItem;
			Break;
		EndIf;
	EndDo;
	If UseDeletionMarkFilter Then
		If EditedFilterItem <> Undefined Then
			OptionsList.Filter.Items.Delete(FilterItem);
		EndIf;
	Else
		If EditedFilterItem = Undefined Then
			EditedFilterItem = OptionsList.Filter.Items.Add(Type("DataCompositionFilterItem"));
		EndIf;
		EditedFilterItem.LeftValue = LeftValue;
		EditedFilterItem.ComparisonType = DataCompositionComparisonType.Equal; 
		EditedFilterItem.ViewMode = DataCompositionSettingsItemViewMode.Inaccessible;
    	EditedFilterItem.RightValue = False;
	EndIf;	
EndProcedure