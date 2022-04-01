// @strict-types

&AtClient
Procedure FillTests(Command)
	
	FillTestsAtServer();
	
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
	
	RunTestAtServer();
	
EndProcedure

&AtServer
Procedure RunTestAtServer()
	
	For Each RowID In Items.TestList.SelectedRows Do
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
	
	RunAllTestAtServer();
	
EndProcedure

&AtServer
Procedure RunAllTestAtServer()
	
	For Each Row In TestList Do
		RunTestByRow(Row);
	EndDo;
	
EndProcedure


