// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	FormulaText = Parameters.Expression;
	
	If IsBlankString(FormulaText) Then
		FormulaText = "Result = """";";
	EndIf;
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

// Enter code here.

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Save(Command)
	Notify("FormulaIsReady", FormulaText);
	Close();
EndProcedure

&AtClient
Procedure Test(Command)
	TestOnServer();
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure TestOnServer()
	Result = Catalogs.PrintFormTemplates.GetParameterValue(FormulaText, Source);
EndProcedure

#EndRegion
