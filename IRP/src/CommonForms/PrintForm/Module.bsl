// @strict-types

#Region FormEventHandlers

// Print form config selection.
// 
// Parameters:
//  Item - FormTable - Item
//  RowSelected - See CommonForm.PrintForm.Items.PrintFormConfig
//  Field - FormField - Field
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PrintFormConfigSelection(Item, RowSelected, Field, StandardProcessing)
	if Field.Name = "PrintFormConfigPresentation" OR Field.Name = "PrintFormConfigNameTemplate" Then
		If Item.CurrentData <> Undefined and ValueIsFilled(Item.CurrentData.Ref) Then
			StandardProcessing = False;
			ShowValue(, Item.CurrentData.Ref);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	EditResultSwitch();
EndProcedure

// Notification processing.
// 
// Parameters:
//  EventName - String - Event name
//  Parameter - See UniversalPrintServer.InitPrintParam
//  Source - Undefined
&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "AddTemplatePrintForm" Then
		FillPrintFormConfig(Parameter)	
	EndIf;
EndProcedure

// Fill print form config.
// 
// Parameters:
//  Parameter See UniversalPrintServer.InitPrintParam
&AtClient
Procedure FillPrintFormConfig(Parameter)
	FindObj = New Structure();
	RefDoc = Parameter.RefDocument;
	NameTemplate = Parameter.NameTemplate;
	FindObj.Insert("Ref", RefDoc);
	FindObj.Insert("NameTemplate", NameTemplate);
	If PrintFormConfig.FindRows(FindObj).Count() = 0 Then
		NewStr				= PrintFormConfig.Add();
		NewStr.Print		= True;
		NewStr.Presentation = "" + Parameter.RefDocument;
		NewStr.CountCopy	= Parameter.CountCopy;
		NewStr.BuilderLayout= Parameter.BuilderLayout;
		NewStr.LayoutLang	= Parameter.LayoutLang;
		NewStr.DataLang		= Parameter.DataLang;
		NewStr.NameTemplate = NameTemplate;
		NewStr.Template		= UniversalPrintServer.GetSynonymTemplate(RefDoc, NameTemplate);
		NewStr.Ref			= Parameter.RefDocument;
		if Parameter.BuilderLayout then
			NewStr.SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(RefDoc, Parameter);
		else
			NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure PrintFormConfigOnActivateRow(Item)
	CurrentData = Item.CurrentData;
	if CurrentData <> Undefined Then
		Items.LayoutLang.ReadOnly = not CurrentData.BuilderLayout;
		Items.DataLang.ReadOnly = not CurrentData.BuilderLayout;
		LayoutLang = CurrentData.LayoutLang;
		DataLang = CurrentData.DataLang;
		SetResult(CurrentData.SpreadsheetDoc);
	EndIf;	
EndProcedure

&AtClient
Procedure LayoutLangOnChange(Item)
	CurrentData = Items.PrintFormConfig.CurrentData;
	if CurrentData <> Undefined And CurrentData.LayoutLang <> LayoutLang Then
		RefreshTemplate(CurrentData)
	EndIf;
EndProcedure

&AtClient
Procedure DataLangOnChange(Item)
	CurrentData = Items.PrintFormConfig.CurrentData;
	if CurrentData <> Undefined And CurrentData.DataLang <> DataLang Then
		RefreshTemplate(CurrentData)
	EndIf;
EndProcedure


&AtClient
Procedure PrintFormConfigOnStartEdit(Item, NewRow, Clone)
	if Clone Then
		CurrentData = Items.PrintFormConfig.CurrentData;
		if CurrentData <> Undefined Then
			PrintFormConfigOnActivateRow(Item)			
		EndIf;  
	EndIf;
EndProcedure


&AtClient
Procedure RefreshTemplate(CurrentData)
	Param = UniversalPrintServer.InitPrintParam(CurrentData.Ref);
	FillPropertyValues(Param, CurrentData);
	Param.DataLang = DataLang;
	Param.LayoutLang = LayoutLang;
	SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(Param.RefDocument, Param);
	Param.SpreadsheetDoc = SpreadsheetDoc;
	CurrentData.DataLang = DataLang;
	CurrentData.LayoutLang = LayoutLang;
	CurrentData.SpreadsheetDoc = SpreadsheetDoc;
	SetResult(SpreadsheetDoc);
EndProcedure

// Set result.
// 
// Parameters:
//  SpreadsheetDoc -  SpreadsheetDocument 
&AtServer
Procedure SetResult(SpreadsheetDoc)
	Result = SpreadsheetDoc;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure EditResult(Command)
	//@skip-check property-return-type
	Items.FormEditResult.Check = Not Items.FormEditResult.Check;
	EditResultSwitch();
EndProcedure

#EndRegion

#Region Private



&AtClient
Procedure EditResultSwitch()
	//@skip-check property-return-type
	//@skip-check statement-type-change
	Items.GroupResultCommandBar.Visible = Items.FormEditResult.Check;
	//@skip-check property-return-type
	//@skip-check statement-type-change
	Items.Result.Edit = Items.FormEditResult.Check;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	//@skip-check property-return-type
	Result = Parameters.Result;
	
	Items.LayoutLang.ChoiceList.Clear();
	For Each It In Metadata.Languages Do
		If It.Name = "HASH" Then
			Continue;			
		EndIf; 
		Items.LayoutLang.ChoiceList.Add(It.LanguageCode, It.Name);				
		Items.DataLang.ChoiceList.Add(It.LanguageCode, It.Name);
	EndDo; 
	
EndProcedure


&AtClient
Procedure Show(Command)
	Items.PrintFormConfig.Visible = True;
	Items.FormHide.Visible = True;
	Items.FormShow.Visible = False;		
EndProcedure

&AtClient
Procedure Hide(Command)
	Items.PrintFormConfig.Visible = False;
	Items.FormHide.Visible = False;
	Items.FormShow.Visible = True;		
EndProcedure

#EndRegion