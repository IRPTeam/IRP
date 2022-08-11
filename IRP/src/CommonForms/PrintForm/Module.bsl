// @strict-types

#Region FormEventHandlers

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
		//Message("" + EventName + "" + Source);
		//Result = Parameter.Result;
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
	FindObj.Insert("Ref", Parameter.RefDocument);
	FindObj.Insert("NameTemplate", Parameter.NameTemplate);
	If PrintFormConfig.FindRows(FindObj).Count() = 0 Then
		NewStr = PrintFormConfig.Add();
		NewStr.Print = True;
		NewStr.Presentation = "" + Parameter.RefDocument;
		NewStr.NameTemplate = Parameter.NameTemplate;
		NewStr.CountCopy = Parameter.CountCopy;
		//@skip-check property-return-type
		NewStr.SpreadsheetDoc = Parameter.SpreadsheetDoc;
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
Procedure LeftPanel(Command)
	Items.PrintFormConfig.Visible = not Items.PrintFormConfig.Visible;
EndProcedure

#EndRegion