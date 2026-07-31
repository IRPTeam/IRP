
Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	CheckPeriods(Cancel, "OverduePeriods");
	CheckPeriods(Cancel, "FuturePeriods");
EndProcedure

Procedure CheckPeriods(Cancel, TabularSectionName)
	If ThisObject[TabularSectionName].Count() = 0 Then
		Return;
	EndIf;
	PrevToDays = Undefined;
	LastLineNumber = ThisObject[TabularSectionName][ThisObject[TabularSectionName].Count()-1].LineNumber;
	For Each Row In ThisObject[TabularSectionName] Do
		If Row.LineNumber = LastLineNumber and Row.ToDays <> 0 Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_197, 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].ToDays", ThisObject);
		EndIf;	
		If Row.FromDays > Row.ToDays and Row.LineNumber <> LastLineNumber  Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().Error_194, Row.FromDays, Row.ToDays), 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].ToDays", ThisObject);
		EndIf;
		If PrevToDays <> Undefined And Row.FromDays - 1 > PrevToDays Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_195, 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].FromDays", ThisObject);
		EndIf;
		If PrevToDays <> Undefined And Row.FromDays <= PrevToDays Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_196, 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].FromDays", ThisObject);
		EndIf;
		If Row.FromDays = 0 And Row.ToDays = 0 Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_198, 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].FromDays", ThisObject);
		EndIf;
		If Row.FromDays = Row.ToDays And Not (Row.FromDays = 0 And Row.ToDays = 0) Then
			Cancel = True;
			CommonFunctionsClientServer.ShowUsersMessage(R().Error_199, 
			TabularSectionName+"[" + Format((Row.LineNumber - 1), "NZ=0; NG=0;") + "].FromDays", ThisObject);
		EndIf;
		PrevToDays = Row.ToDays;
	EndDo;		
EndProcedure

