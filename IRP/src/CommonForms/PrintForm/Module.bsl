// @strict-types

#Region FormEventHandlers

// Print form config selection.
// 
// Parameters:
//  Item - FormTable - Item
//  RowSelected - 
//  Field - FormField - Field
//  StandardProcessing - Boolean - Standard processing
&AtClient
Procedure PrintFormConfigSelection(Item, RowSelected, Field, StandardProcessing)
	//TODO specify the correct type RowSelected
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
		NewStr = PrintFormConfig.Add();
		NewStr.Print = True;
		NewStr.Presentation = "" + Parameter.RefDocument;
		NewStr.CountCopy = Parameter.CountCopy;
		NewStr.BuilderLayout = Parameter.BuilderLayout;
		if Parameter.BuilderLayout then
			//NewStr.SpreadsheetDoc = UniversalPrintServer.BuildSpreadsheetDoc(RefDoc, NameTemplate);		
		else
			//@skip-check property-return-type
			NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
		EndIf;
		
		NewStr.NameTemplate = UniversalPrintServer.GetSynonymTemplate(RefDoc, NameTemplate);
		NewStr.Ref = Parameter.RefDocument;
	EndIf;
EndProcedure

&AtClient
Procedure PrintFormConfigOnActivateRow(Item)
	if Item.CurrentData <> Undefined Then
		//@skip-check invocation-parameter-type-intersect
		//@skip-check property-return-type
		SetResult(Item.CurrentData.SpreadsheetDoc); 
	EndIf;	
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