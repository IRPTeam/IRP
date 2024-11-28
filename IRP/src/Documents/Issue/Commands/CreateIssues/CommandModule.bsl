
&AtClient
Async Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	LocationList = DocIssueServer.GetLocationIssuesBasedOnProject(CommandParameter);
	If LocationList.Count() = 0 Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Issue_1);
	Else                      
		Text = StrTemplate(R().Issue_2, StrConcat(LocationList, ", "));
		If Await DoQueryBoxAsync(Text, QuestionDialogMode.YesNo) = DialogReturnCode.No Then
			Return;
		EndIf;    
		
		DocIssueServer.CreateIssueBasedOnLocations(CommandParameter, LocationList);
	EndIf;
EndProcedure
