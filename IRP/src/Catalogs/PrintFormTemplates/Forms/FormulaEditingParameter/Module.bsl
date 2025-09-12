// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	ThisObject.Title = Parameters.Name;
	If Not IsBlankString(Parameters.Table) Then
		ThisObject.Title = ThisObject.Title + " (" + Parameters.Table + ")";
	EndIf;
	
	ThisObject.TableName = Parameters.Table;
	If IsBlankString(ThisObject.TableName) Then
		Items.InsertCurrentRow.Visible = False;
		Items.InsertRowNumber.Visible = False;
	EndIf;
	
	ThisObject.FormulaText = Parameters.Expression;
	If IsBlankString(ThisObject.FormulaText) Then
		ThisObject.FormulaText = "Result = Source.<Attribute>;";
	EndIf;
	
	//@skip-check property-return-type
	TableData = Parameters.TableData; // Map
	//@skip-check property-return-type
	ThisObject.FormData = New Structure("TableData, TableCommand", New Map, New Map);
	//@skip-check property-return-type
	ThisObject.FormData.TableData = TableData;
	
	If TypeOf(TableData) = Type("Map") Then
		TableIndex = 0;
		For Each TableKeyValue In TableData Do // KeyAndValue
			NewCommand = Commands.Add("Table_"+Format(TableIndex, "NZ=; NG=;"));
			NewCommand.Title = String(TableKeyValue.Key);
			NewCommand.Action = "InsertTable";
			NewCommandButton = Items.Add(NewCommand.Name, Type("FormButton"), Items.TableCommands); // FormButton
			NewCommandButton.CommandName = NewCommand.Name;
			
			//@skip-check property-return-type, dynamic-access-method-not-found
			ThisObject.FormData.TableCommand.Insert(NewCommand.Name, "TableData[""" + NewCommand.Title + """]");
			TableIndex = TableIndex + 1;
		EndDo;
	EndIf; 
	
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

// Enter code here.

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Save(Command)
	Notify("FormulaIsReady", ThisObject.FormulaText);
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

&AtClient
Procedure InsertCurrentRow(Command)
	AddTextToFormula("CurrentRow");
EndProcedure

// Insert row number.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InsertRowNumber(Command)
	AddTextToFormula("RowNumber");
EndProcedure

// Insert table.
// 
// Parameters:
//  Command - FormCommand - Command
&AtClient
Procedure InsertTable(Command)
	//@skip-check invocation-parameter-type-intersect
	//@skip-check property-return-type, dynamic-access-method-not-found
	AddTextToFormula(ThisObject.FormData.TableCommand.Get(Command.Name));
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure TestOnServer()
	//@skip-check property-return-type
	Result = Catalogs.PrintFormTemplates.GetParameterValue(
		ThisObject.FormulaText, Source, Catalogs.PrintFormTemplates.GetTemplateTableInfo(
			FormData.TableData, , , ThisObject.TableName));
EndProcedure

&AtClient
Procedure AddTextToFormula(NewText) 

	PrevPosition = StrLen(ThisObject.FormulaText) + 1;
	ThisObject.FormulaText = ThisObject.FormulaText + NewText;
	NewPosition = PrevPosition + StrLen(NewText);
	
	ThisObject.RefreshDataRepresentation(Items.FormulaText);
	ThisObject.CurrentItem = Items.FormulaText;
	Items.FormulaText.SetTextSelectionBounds(PrevPosition, NewPosition);
	
EndProcedure

#EndRegion
