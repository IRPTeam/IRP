// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Mock = Parameters.Mock;
	Expression = Parameters.Expression;
	CurrentVariableName = Parameters.VariableName;
	
	Expression = StrReplace(Expression, "¶", Chars.CR);
	LoadVariables();
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure RequestOnChange(Item)
	RefreshVariables(Undefined);
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlersVariables

&AtClient
Procedure VariablesSelection(Item, RowSelected, Field, StandardProcessing)
	VariablesOk(Undefined);
EndProcedure

&AtClient
Procedure SubexpressionVariablesSelection(Item, RowSelected, Field, StandardProcessing)
	CurrentData = Items.SubexpressionVariables.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Subexpression = Subexpression + CurrentData.FullName;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure Ok(Command)
	ThisObject.NotifyChoice(Expression);
EndProcedure

&AtClient
Procedure RefreshVariables(Command)
	LoadVariables();
EndProcedure

&AtClient
Procedure Back(Command)
	Items.ConstructorPages.CurrentPage = Items.ExpressionPage;
EndProcedure

&AtClient
Procedure VariablesOk(Command)
	CurrentData = Items.Variables.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	Expression = Expression + StrTemplate("$$$%1$$$", CurrentData.Name);
	Items.ConstructorPages.CurrentPage = Items.ExpressionPage;
EndProcedure

&AtClient
Procedure SubexpressionOk(Command)
	If Not ValueIsFilled(Subexpression) Then
		Return;
	EndIf;
	
	Cancel = False;
	If isComplexExpression Then
		SubexpressionShort = StrReplace(Subexpression, " ", "");
		SubexpressionShort = StrReplace(SubexpressionShort, Chars.CR, "");
		SubexpressionShort = Lower(SubexpressionShort);
		If Not StrFind(SubexpressionShort, "result=") Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Mock_Error_NotFound_SetResult);
		EndIf;
	EndIf;
	If Cancel Then
		Return;
	EndIf;
	
	TemplateExpression = "{{{%1}}}";
	If isComplexExpression Then
		TemplateExpression = "[[[%1]]]";
	EndIf;
	
	Expression = Expression + StrTemplate(TemplateExpression, Subexpression);
	Subexpression = ""; 
	
	Items.ConstructorPages.CurrentPage = Items.ExpressionPage;
EndProcedure

&AtClient
Procedure Calculate(Command)
	RunCalculate();
EndProcedure

&AtClient
Procedure AddVariable(Command)
	Items.ConstructorPages.CurrentPage = Items.VariablesPage;
EndProcedure

&AtClient
Procedure AddSimpleExpression(Command)
	isComplexExpression = False;
	Items.ConstructorPages.CurrentPage = Items.SubexpressionPage;
EndProcedure

&AtClient
Procedure AddComplexExpression(Command)
	isComplexExpression = True;
	Items.ConstructorPages.CurrentPage = Items.SubexpressionPage;
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure LoadVariables()
	
	Variables.Clear();
	
	RequestStructure = Unit_MockService.GetStructureRequestByRef(ThisObject.Request);
	MockStructure = Unit_MockService.GetSelectionMockStructure();
	MockStructure.Ref = Mock;
	
	RequestVariables = New Structure;
	Unit_MockService.CheckRequestToMockData(RequestStructure, MockStructure, RequestVariables);
	
	For Each KeyValue In RequestVariables Do
		If KeyValue.Key = CurrentVariableName Then
			Continue;
		EndIf;
		RecordVariables = ThisObject.Variables.Add();
		RecordVariables.Name = "" + KeyValue.Key;
		RecordVariables.FullName = "Params.AddInfo." + KeyValue.Key;
		RecordVariables.Value = "" + KeyValue.Value; 
	EndDo;
	
EndProcedure

&AtServer
Procedure RunCalculate()
	RequestStructure = Unit_MockService.GetStructureRequestByRef(ThisObject.Request);
	MockStructure = Unit_MockService.GetSelectionMockStructure();
	MockStructure.Ref = Mock;
	
	RequestVariables = New Structure;
	Unit_MockService.CheckRequestToMockData(RequestStructure, MockStructure, RequestVariables);
	
	Result = Unit_MockService.TransformationText(Expression, RequestVariables);
EndProcedure

#EndRegion