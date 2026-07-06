
&AtServer
Procedure OnReadAtServer(CurrentObject)
	FillFixedOffsetOfAdvances(CurrentObject.Ref);
EndProcedure

&AtClient
Procedure BeforeWrite(Cancel, WriteParameters)
	SaveFixedOffsetAtServer();	
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
Procedure UncheckAll(Command)
	For Each Row In ThisObject.FixedOffsetOfAdvances Do
		Row.IsFixed = False;
	EndDo;
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
Procedure FixedOffsetOfAdvancesAgreementStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	CurrentData = Items.FixedOffsetOfAdvances.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	OpenSettings = DocumentsClient.GetOpenSettingsStructure();

	OpenSettings.ArrayOfFilters = New Array();
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, DataCompositionComparisonType.NotEqual));
	OpenSettings.ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"), DataCompositionComparisonType.NotEqual));
	
	OpenSettings.FormParameters = New Structure();
	OpenSettings.FormParameters.Insert("Partner"                     , CurrentData.Partner);
	OpenSettings.FormParameters.Insert("IncludeFilterByPartner"      , True);
	OpenSettings.FormParameters.Insert("IncludePartnerSegments"      , True);
	OpenSettings.FormParameters.Insert("IncludeFilterByEndOfUseDate" , False);
	
	OpenSettings.FillingData = New Structure();
	OpenSettings.FillingData.Insert("Partner"   , CurrentData.Partner);
	OpenSettings.FillingData.Insert("LegalName" , CurrentData.LegalName);
	OpenSettings.FillingData.Insert("Company"   , Object.Company);
	DocumentsClient.AgreementStartChoice(Object, ThisObject, Item, ChoiceData, StandardProcessing, OpenSettings);	
EndProcedure

&AtClient
Procedure FixedOffsetOfAdvancesAgreementEditTextChange(Item, Text, StandardProcessing)
	CurrentData = Items.FixedOffsetOfAdvances.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	ArrayOfFilters = New Array();
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("DeletionMark", True, ComparisonType.NotEqual));
	ArrayOfFilters.Add(DocumentsClientServer.CreateFilterItem("Kind", PredefinedValue("Enum.AgreementKinds.Standard"),ComparisonType.NotEqual));
	AdditionalParameters = New Structure();
	AdditionalParameters.Insert("IncludeFilterByEndOfUseDate" , False);
	AdditionalParameters.Insert("IncludeFilterByPartner"      , True);
	AdditionalParameters.Insert("IncludePartnerSegments"      , True);
	AdditionalParameters.Insert("Partner", CurrentData.Partner);
	DocumentsClient.AgreementEditTextChange(Object, ThisObject, Item, Text, StandardProcessing, ArrayOfFilters, AdditionalParameters);
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