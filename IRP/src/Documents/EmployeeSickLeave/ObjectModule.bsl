Procedure BeforeWrite(Cancel, WriteMode, PostingMode)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure OnWrite(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure BeforeDelete(Cancel)
	If DataExchange.Load Then
		Return;
	EndIf;
EndProcedure

Procedure Posting(Cancel, PostingMode)
	PostingServer.Post(ThisObject, Cancel, PostingMode, ThisObject.AdditionalProperties);
EndProcedure

Procedure UndoPosting(Cancel)
	UndopostingServer.Undopost(ThisObject, Cancel, ThisObject.AdditionalProperties);
EndProcedure

Procedure Filling(FillingData, FillingText, StandardProcessing)
	Return;
EndProcedure

Procedure FillCheckProcessing(Cancel, CheckedAttributes)
	For Each Row In ThisObject.EmployeeList Do
		If ValueIsFilled(Row.BeginDate) And ValueIsFilled(Row.EndDate)
			And Row.BeginDate > Row.EndDate Then
			
			CommonFunctionsClientServer.ShowUsersMessage(R().Salary_Err_003, 
				"EmployeeList[" + (Row.LineNumber - 1) + "].BeginDate", ThisObject);
			
			Cancel = True;
		EndIf;
	EndDo;
EndProcedure
