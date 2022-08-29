
// @strict-types

&AtClient
Var HTMLRegExpTestRowsAnalyzeDocument Export; // AddInObject - HTML document

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTMLRegExpTestRowsAnalyze = Catalogs.ExternalFunctions.GetTemplate("RegExpAnalyse").GetText();
EndProcedure

#Region EvalAndExecute

&AtClient
Procedure Run(Command)
	RunAtServer();
EndProcedure

&AtServer
Procedure RunAtServer()
	
	Params = CommonFunctionsServer.GetRecalculateExpressionParams();
	Params.Eval = Object.ExternalFunctionType = Enums.ExternalFunctionType.Eval;
	Params.SafeMode = Object.SafeModeIsOn;
	Params.Expression = Object.ExternalCode;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	
	Result = ResultInfo.Result;
	Items.Result.ToolTip = String(TypeOf(ResultInfo.Result));

	If ResultInfo.isError Then
		CommonFunctionsClientServer.ShowUsersMessage(ResultInfo.Description);
	EndIf;

	ResultJSON = CommonFunctionsServer.SerializeJSON(Result);
	
EndProcedure

#EndRegion

#Region RexExp

&AtClient
Procedure RunRegExp(Command)
	FindMatches();
EndProcedure

&AtClient
Async Procedure FindMatches()
	Array = New Array;
	For Each TestRexExpString In Object.TestRexExpStrings Do
		ResultArray = Await CommonFunctionsClient.RegExpFindMatch(TestRexExpString.Row, Object.RegExp); // Array of String
		
		If ResultArray.Count() = 0 Then
			Continue;
		EndIf;
		
		Array.Add(TestRexExpString.Row);
		
		For Index = 0 To ResultArray.UBound() Do
			Array.Add("[" + Index + "]	> " + ResultArray[Index]);
		EndDo;
		Array.Add("");
		If Not IsBlankString(Object.ExternalCode) Then
			Array.Add("Result:");
			
			//@skip-check transfer-object-between-client-server
			ResultInfo = RunRegExpExpressionAtServer(ResultArray);
			Array.Add("[Value]	> " + ResultInfo.Result);
			Array.Add("[Type]	> " + String(TypeOf(ResultInfo.Result)));
		EndIf;
	EndDo;
	RegExpResult = StrConcat(Array, Chars.LF);
EndProcedure

// Run reg exp expression at server.
// 
// Parameters:
//  ResultArray - Array of String - Result array
// 
// Returns:
//  See CommonFunctionsServer.RecalculateExpressionResult
&AtServer
Function RunRegExpExpressionAtServer(ResultArray)
	
	Params = CommonFunctionsServer.GetRecalculateExpressionParams();
	Params.Eval = Object.ExternalFunctionType = Enums.ExternalFunctionType.Eval;
	Params.SafeMode = Object.SafeModeIsOn;
	Params.Expression = Object.ExternalCode;
	Params.RegExpResult = ResultArray;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	
	If ResultInfo.isError Then
		CommonFunctionsClientServer.ShowUsersMessage(ResultInfo.Description);
	EndIf;

	Return ResultInfo;
	
EndFunction

&AtClient
Async Procedure CheckRegExp(Text = Undefined)
	
	Facet = ?(Text = Undefined, Object.RegExp, Text);
	//@skip-check dynamic-access-method-not-found
	HTMLRegExpTestRowsAnalyzeDocument.displayMatches(Facet);
	
EndProcedure

&AtClient
Procedure RegExpEditTextChange(Item, Text, StandardProcessing)
	CheckRegExp(Text);
EndProcedure

#EndRegion

#Region FormHeaderItemsEventHandlers

&AtClient
Procedure ExternalFunctionTypeOnChange(Item)
	SetVisible();
EndProcedure

&AtClient
Procedure HTMLRegExpTestRowsAnalyzeDocumentComplete(Item)
	HTMLRegExpTestRowsAnalyzeDocument = PictureViewerClient.InfoDocumentComplete(Item); // AddInObject
	FillRegExpTestData();
	CheckRegExp();
EndProcedure

&AtClient
Procedure TestRexExpStringsOnChange(Item)
	FillRegExpTestData();
EndProcedure

#EndRegion

#Region Service

//@skip-check variable-value-type
&AtClient
Procedure SetVisible()
	If Object.ExternalFunctionType = PredefinedValue("Enum.ExternalFunctionType.RegExp") Then
		Items.PageCode.Visible = False;
		Items.PageResult.Visible = False;
		Items.PageRegExp.Visible = True;
	Else
		Items.PageCode.Visible = True;
		Items.PageResult.Visible = True;
		Items.PageRegExp.Visible = False;
	EndIf;
EndProcedure

&AtClient
Procedure FillRegExpTestData()
	Text = HTMLRegExpTestRowsAnalyzeDocument.document.getElementById("list");
	Text.innerHTML = "";
	For Each Row In Object.TestRexExpStrings Do
		li = HTMLRegExpTestRowsAnalyzeDocument.document.createElement("li");
		li.innerText = Row.Row;
		Text.appendChild(li);
	EndDo;
EndProcedure

#EndRegion
