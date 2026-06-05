
&AtServer
Procedure OnReadAtServer(CurrentObject)
	FillFixedOffsetOfAdvances(CurrentObject.Ref);
EndProcedure

&AtServer
Procedure AfterWriteAtServer(CurrentObject, WriteParameters)
	FillFixedOffsetOfAdvances(CurrentObject.Ref);
EndProcedure

&AtClient
Procedure SaveFixedOffset(Command)
	SaveFixedOffsetAtServer();
EndProcedure

&AtServer
Procedure SaveFixedOffsetAtServer()
	RecordSet = InformationRegisters.T2018S_FixedOffsetOfAdvances.CreateRecordSet();
	RecordSet.Filter.Document.Set(Object.Ref);
	For Each Row In ThisObject.FixedOffsetOfAdvances Do
		FillPropertyValues(RecordSet.Add(), Row);
	EndDo;
	RecordSet.Write();
EndProcedure

&AtClient
Procedure FixedOffsetOfAdvancesBeforeAddRow(Item, Cancel, Clone, Parent, IsFolder, Parameter)
	Cancel = True;
	
	If Not ValueIsFilled(Object.Ref) Then
		Callback = New CallbackDescription("WriteBeforAddNewRow", ThisObject);
		ShowQueryBox(Callback, R().QuestionToUser_001, QuestionDialogMode.YesNo);
	Else
		FixedOffsetOfAdvancesAddRow();
	EndIf;
EndProcedure

&AtClient
Procedure WriteBeforAddNewRow(Result, Params) Export
	If Result = DialogReturnCode.Yes And Write() Then
		FixedOffsetOfAdvancesAddRow();
	EndIf;
EndProcedure

&AtClient
Procedure FixedOffsetOfAdvancesAddRow()
	NewRow = ThisObject.FixedOffsetOfAdvances.Add();
	NewRow.Document = Object.Ref;
	NewRow.Company = Object.Company;
	NewRow.Branch  = Object.Branch;
	NewRow.IsFixed = True;
	Items.FixedOffsetOfAdvances.CurrentRow = NewRow.GetID();
	If Items.FixedOffsetOfAdvances.CurrentRow <> Undefined Then
		Items.FixedOffsetOfAdvances.ChangeRow();
	EndIf;
EndProcedure

&AtServer
Procedure FillFixedOffsetOfAdvances(DocRef)
	If Not ValueIsFilled(DocRef) Then
		Return;
	EndIf;
	
	Query = New Query();
	Query.Text = 
	"SELECT *
	|FROM
	|	InformationRegister.T2018S_FixedOffsetOfAdvances AS T2018S_FixedOffsetOfAdvances
	|WHERE
	|	T2018S_FixedOffsetOfAdvances.Document = &DocRef";
	Query.SetParameter("DocRef", DocRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	
	ThisObject.FixedOffsetOfAdvances.Clear();
	
	While QuerySelection.Next() Do
		NewRow = ThisObject.FixedOffsetOfAdvances.Add();
		FillPropertyValues(NewRow, QuerySelection);
	EndDo; 
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	DocumentsServer.OnCreateAtServer(Object, ThisObject, Cancel, StandardProcessing);
EndProcedure

&AtClient
Procedure SetNewNumber(Command)
	SetNewNumberAtServer();
EndProcedure

&AtServer
Procedure SetNewNumberAtServer()
	If Object.NumeratorRules.IsEmpty() Then
		Object.NumeratorRules = 
			NumberingRulesServer.GetNumeratorGroupForDocument(Object.Ref.Metadata().FullName(), Object.Date);
	EndIf;
	NumberingRulesServer.SetSourceNewNumber(Object);
EndProcedure

#Region COMMANDS

&AtClient
Procedure InternalCommandAction(Command) Export
	InternalCommandsClient.RunCommandAction(Command, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure InternalCommandActionWithServerContext(Command) Export
	InternalCommandActionWithServerContextAtServer(Command.Name);
EndProcedure

&AtServer
Procedure InternalCommandActionWithServerContextAtServer(CommandName)
	InternalCommandsServer.RunCommandAction(CommandName, ThisObject, Object, Object.Ref);
EndProcedure

&AtClient
Procedure GeneratedFormCommandActionByName(Command) Export
	ExternalCommandsClient.GeneratedFormCommandActionByName(Object, ThisObject, Command.Name);
	GeneratedFormCommandActionByNameServer(Command.Name);
EndProcedure

&AtServer
Procedure GeneratedFormCommandActionByNameServer(CommandName) Export
	ExternalCommandsServer.GeneratedFormCommandActionByName(Object, ThisObject, CommandName);
EndProcedure

#EndRegion