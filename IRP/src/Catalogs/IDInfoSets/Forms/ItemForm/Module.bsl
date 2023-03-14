&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	LocalizationEvents.CreateMainFormItemDescription(ThisObject, "GroupDescriptions");
	ExtensionServer.AddAttributesFromExtensions(ThisObject, Object.Ref);
EndProcedure

&AtClient
Procedure AfterWrite(WriteParameters)
	Notify("UpdateIDInfo");
EndProcedure

&AtClient
Procedure DescriptionOpening(Item, StandardProcessing) Export
	LocalizationClient.DescriptionOpening(Object, ThisObject, Item, StandardProcessing);
EndProcedure

&AtClient
Procedure SetConditionCommand(Command)
	SetCondition("IDInfoTypes", "IDInfoType");
EndProcedure

&AtClient
Procedure SetCondition(TableName, ColumnName, AddInfo = Undefined)
	If AddInfo = Undefined Then
		AddInfo = New Structure();
	EndIf;
	AddInfo.Insert("TableName", TableName);
	AddInfo.Insert("ColumnName", ColumnName);

	If Not ValueIsFilled(Object.Ref) Or ThisObject.Modified Then
		QuestionToUserNotify = New NotifyDescription("SetConditionNotify", ThisObject, AddInfo);
		ShowQueryBox(QuestionToUserNotify, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		SetConditionNotify(DialogReturnCode.Yes, AddInfo);
	EndIf;
EndProcedure

&AtClient
Procedure SetConditionNotify(Result, AddInfo = Undefined) Export
	If Result = DialogReturnCode.Yes And Write() Then
		CurrentRow = Items[AddInfo.TableName].CurrentData;
		If CurrentRow = Undefined Then
			Return;
		EndIf;

		AddInfo.Insert("Element", CurrentRow[AddInfo.ColumnName]);

		Notify = New NotifyDescription("OnFinishEditFilter", ThisObject, AddInfo);
		OpeningParameters = New Structure();
		OpeningParameters.Insert("SavedSettings", GetSettings(CurrentRow[AddInfo.ColumnName], AddInfo));
		OpeningParameters.Insert("Ref", Object.Ref);
		OpenForm("Catalog.IDInfoSets.Form.EditCondition", OpeningParameters, ThisObject, , , , Notify);
	EndIf;
EndProcedure

&AtClient
Procedure OnFinishEditFilter(Result, AddInfo = Undefined) Export
	If TypeOf(Result) = Type("Structure") Then
		SaveSettings(AddInfo.Element, Result.Settings, Result.AddAttributesMap, AddInfo);
	EndIf;
EndProcedure

&AtServer
Function GetSettings(Element, AddInfo = Undefined)
	Filter = New Structure(AddInfo.ColumnName, Element);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[AddInfo.TableName].FindRows(Filter);
	If ArrayOfRows.Count() Then
		Return ArrayOfRows[0].Condition.Get();
	Else
		Return Undefined;
	EndIf;
EndFunction

&AtServer
Procedure SaveSettings(Element, Settings, AddAttributesMap, AddInfo = Undefined)
	Filter = New Structure(AddInfo.ColumnName, Element);
	CatalogObject = Object.Ref.GetObject();
	ArrayOfRows = CatalogObject[AddInfo.TableName].FindRows(Filter);
	For Each Row In ArrayOfRows Do

		SettingsIsSet = False;
		If Settings <> Undefined Then
			For Each FilterItem In Settings.Filter.Items Do
				If FilterItem.Use Then
					SettingsIsSet = True;
					Break;
				EndIf;
			EndDo;
		EndIf;

		If SettingsIsSet Then
			Row.Condition = New ValueStorage(New Structure("Settings, AddAttributesMap", Settings, AddAttributesMap));
			Row.IsConditionSet = 1;
		Else
			Row.Condition = Undefined;
			Row.IsConditionSet = 0;
		EndIf;

	EndDo;
	CatalogObject.Write();
	ThisObject.Read();
EndProcedure