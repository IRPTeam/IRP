// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Title = Parameters.Name;
	
	FormulaText = Parameters.Expression;
	If IsBlankString(FormulaText) Then
		FormulaText = "Result = Source.<Table>;";
	EndIf;
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

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

&AtClient
Procedure InsertResult(Command)
	AddTextToFormula("Result");
EndProcedure

&AtClient
Procedure InsertSource(Command)
	AddTextToFormula("Source");
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure TestOnServer()
	TableResult = Catalogs.PrintFormTemplates.GetTableValue(FormulaText, Source);
	Try
		Result = StrTemplate(R().I_4, Format(TableResult.Count(), "NZ=; NG=;"));
	Except
		Result = R().I_5;
	EndTry;
EndProcedure

&AtClient
Procedure AddTextToFormula(NewText) 

	PrevPosition = StrLen(FormulaText) + 1;
	FormulaText = FormulaText + NewText;
	NewPosition = PrevPosition + StrLen(NewText);
	
	ThisObject.RefreshDataRepresentation(Items.FormulaText);
	ThisObject.CurrentItem = Items.FormulaText;
	Items.FormulaText.SetTextSelectionBounds(PrevPosition, NewPosition);
	
EndProcedure

#EndRegion
