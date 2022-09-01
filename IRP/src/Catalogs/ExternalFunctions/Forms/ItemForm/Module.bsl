
// @strict-types

&AtClient
Var HTMLRegExpTestRowsAnalyzeDocument Export; // Structure - HTML document

#Region FormEventHandlers

&AtClient
Procedure OnOpen(Cancel)
	SetVisible();
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	HTMLRegExpTestRowsAnalyze = Catalogs.ExternalFunctions.GetTemplate("RegExpAnalyse").GetText();
EndProcedure

&AtServer
Procedure OnReadAtServer(CurrentObject)
	JobScheduleInfo = CurrentObject.JobSchedule.Get();
EndProcedure

&AtServer
Procedure BeforeWriteAtServer(Cancel, CurrentObject, WriteParameters)
	CurrentObject.JobSchedule = New ValueStorage(JobScheduleInfo);
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
	
	//@skip-check invocation-parameter-type-intersect
	Params = CommonFunctionsServer.GetRecalculateExpressionParams(Object);
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
	Items.PageSheduler.Visible = Object.isSchedulerSet;
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

#EndRegion
