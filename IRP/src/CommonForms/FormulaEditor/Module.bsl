
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)	
	ThisObject.Formula     = Parameters.Formula;
	ThisObject.PropertySet = Parameters.PropertySet;
	DCS = Catalogs[Parameters.TemplateOwner].GetTemplate(Parameters.TemplateName);	
	DCS.Parameters.PropertySet.Value = ThisObject.PropertySet;
	DCS_Source = New DataCompositionAvailableSettingsSource(PutToTempStorage(DCS, ThisObject.UUID));
	ThisObject.SettingsComposer.Initialize(DCS_Source);
				
	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_Delimiters;
		
	AddOperator(OperatorGroup, "/", " + ""/"" + ");
	AddOperator(OperatorGroup, "\", " + ""\"" + ");
	AddOperator(OperatorGroup, "|", " + ""|"" + ");
	AddOperator(OperatorGroup, "_", " + ""_"" + ");
	AddOperator(OperatorGroup, ",", " + "", "" + ");
	AddOperator(OperatorGroup, ".", " + "". "" + ");
	AddOperator(OperatorGroup, R().FormulaEditor_Space, " + "" "" + ");
	AddOperator(OperatorGroup, "(", " + "" ("" + ");
	AddOperator(OperatorGroup, ")", " + "") "" + ");
	AddOperator(OperatorGroup, """", " + """""""" + ");
	
	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_Operators;
	
	AddOperator(OperatorGroup, "+", " + ");
	AddOperator(OperatorGroup, "-", " - ");
	AddOperator(OperatorGroup, "*", " * ");
	AddOperator(OperatorGroup, "/", " / ");

	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_LogicalOperatorsAndConstants;
	
	AddOperator(OperatorGroup, "<", " < ");
	AddOperator(OperatorGroup, ">", " > ");
	AddOperator(OperatorGroup, "<=", " <= ");
	AddOperator(OperatorGroup, ">=", " >= ");
	AddOperator(OperatorGroup, "=", " = ");
	AddOperator(OperatorGroup, "<>", " <> ");
	AddOperator(OperatorGroup, R().FormulaEditor_AND, " " + "AND"      + " ");
	AddOperator(OperatorGroup, R().FormulaEditor_OR, " " + "OR"    + " ");
	AddOperator(OperatorGroup, R().FormulaEditor_NOT, " " + "NOT"     + " ");
	AddOperator(OperatorGroup, R().FormulaEditor_TRUE, " " + "TRUE" + " ");
	AddOperator(OperatorGroup, R().FormulaEditor_FALSE, " " + "FALSE"   + " ");
		
	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_NumericFunctions;

	AddOperator(OperatorGroup, R().FormulaEditor_Max, "Max(,)", 2);
	AddOperator(OperatorGroup, R().FormulaEditor_Min, "Min(,)",  2);
	AddOperator(OperatorGroup, R().FormulaEditor_Round, "Round(,)",  2);
	AddOperator(OperatorGroup, R().FormulaEditor_Int, "Int()",   1);
	
	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_StringFunctions;
			
	AddOperator(OperatorGroup, R().FormulaEditor_String, "String()");
	AddOperator(OperatorGroup, R().FormulaEditor_Upper, "Upper()");
	AddOperator(OperatorGroup, R().FormulaEditor_Left, "Left()");
	AddOperator(OperatorGroup, R().FormulaEditor_Lower, "Lower()");
	AddOperator(OperatorGroup, R().FormulaEditor_Right, "Right()");
	AddOperator(OperatorGroup, R().FormulaEditor_TrimL, "TrimL()");
	AddOperator(OperatorGroup, R().FormulaEditor_TrimAll, "TrimAll()");
	AddOperator(OperatorGroup, R().FormulaEditor_TrimR, "TrimR()");
	AddOperator(OperatorGroup, R().FormulaEditor_Title, "Title()");
	AddOperator(OperatorGroup, R().FormulaEditor_StrReplace, "StrReplace(,,)");
	AddOperator(OperatorGroup, R().FormulaEditor_StrLen, "StrLen()");
		
	OperatorGroup = ThisObject.Operators.GetItems().Add();
	OperatorGroup.Description = R().FormulaEditor_OtherFunctions;
	
	AddOperator(OperatorGroup, R().FormulaEditor_Condition, "?(,,)", 3);
	AddOperator(OperatorGroup, R().FormulaEditor_PredefinedValue, "PredefinedValue()");
	AddOperator(OperatorGroup, R().FormulaEditor_ValueIsFilled, "ValueIsFilled()");
	AddOperator(OperatorGroup, R().FormulaEditor_Format, "Format(,)");
EndProcedure

&AtServer
Procedure AddOperator(OperatorGroup, Description, Operator, Shift=0)
	NewRow = OperatorGroup.GetItems().Add();
	NewRow.Description = Description;
	NewRow.Operator    = Operator;
	NewRow.Shift       = Shift;
EndProcedure

&AtClient
Procedure SettingsComposerSelection(Item, RowSelected, Field, StandardProcessing)
	RowText = String(ThisObject.SettingsComposer.Settings.OrderAvailableFields.GetObjectByID(RowSelected).Field);
	Operand = OperandTextProcessing(RowText);
	If Not ValueIsFilled(Operand) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error01);
		Return;
	EndIf;
	InsertTextToFormula(Operand);
EndProcedure

&AtClient
Procedure SettingsComposerDragStart(Item, DragParameters, Perform)
	ItemText = String(ThisObject.SettingsComposer.Settings.OrderAvailableFields.GetObjectByID(Items.SettingsComposer.CurrentRow).Field);
	Operand = OperandTextProcessing(ItemText);
	If Not ValueIsFilled(Operand) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error01);
		Return;
	EndIf;
	DragParameters.Value = Operand;
EndProcedure

&AtClient
Procedure OperatorsSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	InsertOperatorToFormula();	
EndProcedure

&AtClient
Procedure OperatorsDragStart(Item, DragParameters, Perform)
	If Item.CurrentData = Undefined Then
		Perform = False;
		Return;
	EndIf;
	
	If ValueIsFilled(Item.CurrentData.Operator) Then
		DragParameters.Value = Item.CurrentData.Operator;
	Else
		Perform = False;
	EndIf;
EndProcedure

&AtClient
Procedure OperatorsDragEnd(Item, DragParameters, StandardProcessing)
	If Item.CurrentData.Operator = "Format(,)" Then
		Wizard = New FormatStringWizard();
		Wizard.Show(New NotifyDescription("InsertOperatorToFormulaDragEnd", 
			ThisObject, New Structure("Wizard",Wizard)));
	EndIf;
EndProcedure

&AtClient
Procedure Ok(Command)
	If Not CheckFourmula() Then
		Return;
	EndIf;
		
	Close(ThisObject.Formula);
EndProcedure

&AtClient
Procedure Check(Command)
	If CheckFourmula() Then
		CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Msg01);
	EndIf;
EndProcedure

&AtClient
Function OperandTextProcessing(Val OperandText)
	BeginOperand = StrFind(OperandText, "[");
	EndOperand = StrFind(OperandText, "]");
	If BeginOperand <> 0
		And EndOperand <> 0
		And BeginOperand < EndOperand Then
		
		NameOperand = Mid(OperandText, BeginOperand + 1, EndOperand - BeginOperand - 1);
		If StrFind(NameOperand, ".") <> 0 Then
			Return Undefined;
		EndIf;
		If Not IsBlankString(NameOperand) Then
			OperandText = GetAttributeUniqueID(NameOperand);
		EndIf;
	EndIf;
		
	OperandText = StrReplace(OperandText, "[", "");
	OperandText = StrReplace(OperandText, "]", "");
	Return "[" + StrReplace(OperandText, "Item.", "") + "]";
EndFunction

&AtServerNoContext
Function GetAttributeUniqueID(NameOperand)
	For Each Desc In LocalizationReuse.AllDescription() Do
		AddAttribute = ChartsOfCharacteristicTypes.AddAttributeAndProperty.FindByAttribute(Desc, NameOperand);
		If ValueIsFilled(AddAttribute) Then
			Return CommonFunctionsServer.GetRefAttribute(AddAttribute, "UniqueID");
		EndIf;
	EndDo;
	Return NameOperand;
EndFunction

&AtClient
Procedure InsertTextToFormula(FormulaText, Shift = 0)
	LineBegin = 0;
	LineEnd = 0;
	ColumnBegin = 0;
	ColumnEnd = 0;
	
	Items.Formula.GetTextSelectionBounds(LineBegin, ColumnBegin, LineEnd, ColumnEnd);
	
	If (ColumnEnd = ColumnBegin) And (ColumnEnd + StrLen(FormulaText)) > Items.Formula.Width / 8 Then
		Items.Formula.SelectedText = "";
	EndIf;
		
	Items.Formula.SelectedText = FormulaText;
	
	If Shift <> 0 Then
		Items.Formula.GetTextSelectionBounds(LineBegin, ColumnBegin, LineEnd, ColumnEnd);
		Items.Formula.SetTextSelectionBounds(LineBegin, ColumnBegin - Shift, LineEnd, ColumnEnd - Shift);
	КонецЕсли;
		
	ThisObject.CurrentItem = Items.Formula;
EndProcedure

&AtClient
Procedure InsertOperatorToFormula()
	If Items.Operators.CurrentData.Operator = "Format(,)" Then
		Wizard = New FormatStringWizard();
		Wizard.Show(New NotifyDescription("InsertOperatorToFormulaEnd", 
			ThisObject, New Structure("Wizard",Wizard)));
        Return;
	Else
		InsertTextToFormula(Items.Operators.CurrentData.Operator, Items.Operators.CurrentData.Shift);
	EndIf;
EndProcedure

&AtClient
Procedure InsertOperatorToFormulaEnd(Text, NotifyParameters) Export
    FormatString = NotifyParameters.Wizard.Text;
    
    If ValueIsFilled(FormatString) Then
        FormulaText = "Format( , """ + FormatString + """)";
        InsertTextToFormula(FormulaText, Items.Operators.CurrentData.Shift);
    Else	
        InsertTextToFormula(Items.Operators.CurrentData.Operator, Items.Operators.CurrentData.Shift);
    EndIf;
EndProcedure

&AtClient
Procedure InsertOperatorToFormulaDragEnd(Text, NotifyParameters) Export
    FormatString = NotifyParameters.Wizard.Text;
    
    If ValueIsFilled(FormatString) Then
        FormulaText = "Format( , """ + FormatString + """)";
  		Items.Formula.SelectedText = FormulaText;
  	EndIf;
EndProcedure

&AtClient
Function CheckFourmula() Export
	Result = True;
	
	If ValueIsFilled(ThisObject.Formula) Then
		Text = """String"" + " + ThisObject.Formula;
		ReplaceValue = """1""";
			
		Operands = GetArrayOfOperands();
		For Each Operand In Operands Do
			Text = StrReplace(Text, "[" + Operand + "]", ReplaceValue);
		EndDo;
		
		Try
			//@skip-check module-unused-local-variable
			EvalResult = Eval(Text);
			CheckText = StrReplace(ThisObject.Formula, Chars.LF, "");
			CheckText = StrReplace(CheckText, " ", "");
			If StrFind(CheckText, "][") + StrFind(CheckText, """[") + StrFind(CheckText, "]""") > 0 Then
				CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error03);		
				Result = False;
			EndIf;
		Except
			Result = False;
			CommonFunctionsClientServer.ShowUsersMessage(R().FormulaEditor_Error02);
		EndTry;
		
	EndIf;
	Return Result;
EndFunction

&AtClient
FUnction GetArrayOfOperands()
	ArrayOfOperands = New Array();
	FormulaText = TrimAll(ThisObject.Formula);
	If StrOccurrenceCount(FormulaText, "[") <> StrOccurrenceCount(FormulaText, "]") Then
		OperandsIsPresent = False;
	Else
		OperandsIsPresent = True;
	EndIf;
	
	While OperandsIsPresent = True Do
		BeginOperand = StrFind(FormulaText, "[");
		EndOperand = StrFind(FormulaText, "]");
		
		If BeginOperand = 0
			Or EndOperand = 0
			Or BeginOperand > EndOperand Then
			OperandsIsPresent = False;
			Break;
		EndIf;
		
		OperandName = Mid(FormulaText, BeginOperand + 1, EndOperand - BeginOperand - 1);
		ArrayOfOperands.Add(OperandName);
		FormulaText = StrReplace(FormulaText, "[" + OperandName + "]", "");
	EndDo;	
	Return ArrayOfOperands;
EndFunction
