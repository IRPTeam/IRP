// @strict-types

&AtClient
Procedure FillTests(Command)
	
	FillTestsAtServer();  
	UpdateLog();
	
EndProcedure

&AtServer
Procedure FillTestsAtServer()

	TestList.Clear();
	Tests = Unit_Service.GetAllTest();
	For Each Test In Tests Do
		NewTest = TestList.Add();
		NewTest.Test = Test;
	EndDo;

EndProcedure

&AtClient
Procedure RunTest(Command)
	ClearMessages();
	RunTestAtServer();
	UpdateLog();
	
EndProcedure

&AtServer
Procedure RunTestAtServer()
	
	For Each RowID In Items.TestList.SelectedRows Do // Number
		Row = TestList.FindByID(RowID);
		RunTestByRow(Row);
	EndDo;
	
EndProcedure

&AtServer
Procedure RunTestByRow(Row)
	
	Result = Unit_Service.RunTest(Row.Test);
	If IsBlankString(Result) Then
		Row.Done = True;
	Else
		Row.Error = Result;
	EndIf;
	
	
EndProcedure

&AtClient
Procedure RunAllTest(Command)
	ClearMessages();
	RunAllTestAtServer();
	UpdateLog(); 
	
EndProcedure

&AtServer
Procedure RunAllTestAtServer()
	
	For Each Row In TestList Do
		RunTestByRow(Row);
	EndDo;
	
EndProcedure

&AtServer
Procedure UpdateLog()
	Done = 0;
	Error = 0;
	Total = 0;            
	Logs = "";
	For Each Row In TestList Do
		If Row.Done Then
			Done = Done + 1;
		ElsIf Not IsBlankString(Row.Error) Then
			Error = Error + 1; 
			Logs = Logs + Row.Test + Chars.LF + Row.Error + Chars.LF + "========================================" + Chars.Lf;			
		EndIf;
		Total = Total + 1;
	EndDo;
	
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	FillTestsAtServer();  
EndProcedure
