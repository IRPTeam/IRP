
// @strict-types

&AtClient
Var HTMLRegExpTestRowsAnalyzeDocument Export; // Structure - HTML document

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	CatalogsServer.OnCreateAtServerObject(ThisObject, Object, Cancel, StandardProcessing);
	HTMLRegExpTestRowsAnalyze = Catalogs.ExternalFunctions.GetTemplate("RegExpAnalyse").GetText();
	
	TypeList = FillTypes();
	For Each Row In TypeList Do
		//@skip-check typed-value-adding-to-untyped-collection
		Items.ResultType.ChoiceList.Add(Row.Value, Row.Presentation, , Row.Picture);
	EndDo;
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	JobScheduleInfo = CurrentObject.JobSchedule.Get();
	
	If CurrentObject.ExternalFunctionType = Enums.ExternalFunctionType.ReturnResultByRegExpMatch Then
		For Each Row In CurrentObject.ResultMatches Do
			NewRow = ResultMatches.Add();
			NewRow.Result = Row.Result;
			NewRow.RegExp.LoadValues(StrSplit(Row.RegExp, "|"));
		EndDo;
	EndIf;
	
	If Not IsBlankString(CurrentObject.ResultType) Then
		Items.ResultMatchesResult.TypeRestriction = New TypeDescription(CurrentObject.ResultType);
	EndIf;	
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.JobSchedule = New ValueStorage(JobScheduleInfo);
	
	If CurrentObject.ExternalFunctionType = Enums.ExternalFunctionType.ReturnResultByRegExpMatch Then
		CurrentObject.ResultMatches.Clear();
		For Each Row In ResultMatches Do
			NewRow = CurrentObject.ResultMatches.Add();
			NewRow.RegExp = StrConcat(Row.RegExp.UnloadValues(), "|");
			NewRow.Result = Row.Result;
		EndDo;
	EndIf;
	
EndProcedure

#EndRegion

#Region EvalAndExecute

&AtClient
Procedure Run(Command)
	RunAtServer();
EndProcedure

&AtServer
Procedure RunAtServer()
	
	//@skip-check invocation-parameter-type-intersect
	Params = CommonFunctionsServer.GetRecalculateExpressionParams(Object);
	
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
	Array = New Array; // Array Of String
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
			ResultInfo = RunRegExpExpressionAtServer(TestRexExpString.Row); // Array of String
			Array.Add("[Value]	> " + ResultInfo.Result);
			Array.Add("[Type]	> " + String(TypeOf(ResultInfo.Result)));
		EndIf;
	EndDo;
	RegExpResult = StrConcat(Array, Chars.LF);
EndProcedure

// Run reg exp expression at server.
// 
// Parameters:
//  TestString - String - Test string
// 
// Returns:
//  See CommonFunctionsServer.RecalculateExpressionResult
&AtServer
Function RunRegExpExpressionAtServer(TestString)
	
	//@skip-check invocation-parameter-type-intersect
	Params = CommonFunctionsServer.GetRecalculateExpressionParams(Object);
	Params.RegExpString = TestString; 
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
	HTMLRegExpTestRowsAnalyzeDocument = PictureViewerClient.InfoDocumentComplete(Item); // Structure
	FillRegExpTestData();
	CheckRegExp();
EndProcedure

&AtClient
Procedure TestRexExpStringsOnChange(Item)
	FillRegExpTestData();
EndProcedure

#EndRegion

#Region Scheduler

&AtClient
Procedure Scheduler(Command)
	If JobScheduleInfo = Undefined Then
		ScheduledJob = New JobSchedule();
	Else
		ScheduledJob = JobScheduleInfo; // JobSchedule
	EndIf;
	EditSchedule = New ScheduledJobDialog(ScheduledJob);
	EditSchedule.Show(New NotifyDescription("AfterSchedulerChange", ThisObject));
EndProcedure

// After scheduler change.
// 
// Parameters:
//  Schedule - ScheduledJobDialog -
//  AddInfo - Structure - Add info
&AtClient
Procedure AfterSchedulerChange(Schedule, AddInfo) Export

	If Schedule = Undefined Then
		Return;
	EndIf;
	
	JobScheduleInfo = Schedule;

EndProcedure

&AtClient
Procedure isSchedulerSetOnChange(Item)
	SetVisible();
EndProcedure

#EndRegion

#Region ResultMatch

&AtClient
Procedure ResultMatchesOnStartEdit(Item, NewRow, Clone)
	Item.CurrentData.RegExp.ValueType = New TypeDescription("String");
EndProcedure

&AtClient
Procedure CheckTestResult(Command)
	CheckTestResultAtServer();
EndProcedure

&AtServer
Procedure CheckTestResultAtServer()
	//@skip-check invocation-parameter-type-intersect
	Params = CommonFunctionsServer.GetRecalculateExpressionParams(Object);
	Params.RegExpString = TestCheckResultStringMatch;
	
	ResultInfo = CommonFunctionsServer.RecalculateExpression(Params);
	CheckResultMatch = ResultInfo.Result;
	
	If ResultInfo.isError Then
		CommonFunctionsClientServer.ShowUsersMessage(ResultInfo.Description);
	EndIf;
	
EndProcedure

&AtClient
Procedure ResultTypeOnChange(Item)
	Items.ResultMatchesResult.TypeRestriction = New TypeDescription(Object.ResultType);
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
		Items.GroupResultByRegexp.Visible = False;
	ElsIf Object.ExternalFunctionType = PredefinedValue("Enum.ExternalFunctionType.ReturnResultByRegExpMatch") Then
		Items.PageCode.Visible = False;
		Items.PageResult.Visible = False;
		Items.PageRegExp.Visible = False;
		Items.GroupResultByRegexp.Visible = True;
	Else
		Items.PageCode.Visible = True;
		Items.PageResult.Visible = True;
		Items.PageRegExp.Visible = False;
		Items.GroupResultByRegexp.Visible = False;
	EndIf;
	Items.PageScheduler.Visible = Object.isSchedulerSet;
EndProcedure

&AtClient
//@skip-check dynamic-access-method-not-found, property-return-type, variable-value-type
Procedure FillRegExpTestData()
	Text = HTMLRegExpTestRowsAnalyzeDocument.document.getElementById("list"); // Structure
	Text.innerHTML = "";
	For Each Row In Object.TestRexExpStrings Do
		li = HTMLRegExpTestRowsAnalyzeDocument.document.createElement("li");
		li.innerText = Row.Row;
		Text.appendChild(li);
	EndDo;
EndProcedure

&AtServer
Function FillTypes()
	ValueList = New ValueList(); // ValueList Of String
	ValueList.Add("String", "String", , PictureLib.Rename);
	ValueList.Add("Number", "Number", , PictureLib.Calculator);
	ValueList.Add("Date", "Date", , PictureLib.Calendar);
	For Each Cat In Metadata.Catalogs Do
		Parts = StrSplit(Cat.FullName(), ".");
		ResultTypeRef = Parts[0] + "Ref." + Parts[1];
		ValueList.Add(ResultTypeRef, Cat.Synonym, , PictureLib.Catalog);
	EndDo;
	For Each Doc In Metadata.Documents Do
		Parts = StrSplit(Doc.FullName(), ".");
		ResultTypeRef = Parts[0] + "Ref." + Parts[1];
		ValueList.Add(ResultTypeRef, Doc.Synonym, , PictureLib.Document);
	EndDo;
	For Each Enum In Metadata.Enums Do
		Parts = StrSplit(Enum.FullName(), ".");
		ResultTypeRef = Parts[0] + "Ref." + Parts[1];
		ValueList.Add(ResultTypeRef, Enum.Synonym, , PictureLib.Enum);
	EndDo;
	
	Return ValueList;
EndFunction

#EndRegion

#Region COMMANDS

// Generated form command action by name.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

// Internal command action.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

// Internal command action with server context.
// 
// Parameters:
//  Command - CommandBarButton - Command
&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

#EndRegion