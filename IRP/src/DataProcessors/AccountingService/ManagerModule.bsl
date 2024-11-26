Function RunEAOExchangeAtServer(IntegrationSettingsRef) Export
	ResultStructure = New Structure;
	ResultStructure.Insert("SpreadSheetDoc", Undefined);
	ResultStructure.Insert("Result", True);
	ResultStructure.Insert("Error", "");
	
	TestRegisterName = "";
	
	Try
		EAOResultArray = New Array;
		AccountingServer.LoadAccountingRecordsAll(IntegrationSettingsRef, TestRegisterName, EAOResultArray);
		If EAOResultArray.Count() = 0 Then
			Return ResultStructure;
		EndIf;
		ArrayOfLedgerTypes = GetArrayOfLedgerTypes();
		AccountingServer.CreateJE_ByArrayRefs(EAOResultArray, ArrayOfLedgerTypes);
		
		ErrorsStructure = New Structure();
		ErrorsStructure.Insert("TableErrorsInEAOArray", TableErrorsInEAO(EAOResultArray));
		ErrorsStructure.Insert("TableErrorInJE", TableErrorsInJE(EAOResultArray));
		
		SpreadSheetDoc = Undefined;
		If ErrorsStructure.TableErrorsInEAOArray.Count() Or ErrorsStructure.TableErrorInJE.Count() Then
			SpreadSheetDoc = CreateReportByErrors(ErrorsStructure);
		EndIf;
		ResultStructure.SpreadSheetDoc = SpreadSheetDoc;
	Except
		Error = ErrorDescription();
		CommonFunctionsClientServer.ShowUsersMessage(Error);
		
		ResultStructure.Result = False;
		ResultStructure.Error = Error;
	EndTry;
	
	Return ResultStructure;
EndFunction

Function CreateReportByErrors(ErrorsStructure)
	
	SDocument = New SpreadsheetDocument;
	Template = DataProcessors.AccountingService.GetTemplate("EAOLoadReport");
	AreaHeader = Template.GetArea("Header");
	AreaRow = Template.GetArea("Row");
	
	SDocument.Put(AreaHeader);
	For Each TableRow In ErrorsStructure.TableErrorsInEAOArray Do
		FillPropertyValues(AreaRow.Parameters, TableRow);
		SDocument.Put(AreaRow);
	EndDo;
	For Each TableRow In ErrorsStructure.TableErrorInJE Do
		FillPropertyValues(AreaRow.Parameters, TableRow);
		SDocument.Put(AreaRow);
	EndDo;
	
	SDocument.ShowGrid = False;
	SDocument.ShowHeaders = False;
	SDocument.FixedTop = 2;
	SDocument.ReadOnly = True;
	
	Return SDocument;
	
EndFunction

Function TableErrorsInJE(EAOArray)
	Query = New Query;
	Query.SetParameter("ArrayOfBasis", EAOArray);
	Query.Text = 
	"SELECT
	|	JournalEntryErrors.Ref AS DocumentRef,
	|	JournalEntryErrors.Error AS Error
	|FROM
	|	Document.JournalEntry.Errors AS JournalEntryErrors
	|WHERE
	|	JournalEntryErrors.Ref.Basis IN (&ArrayOfBasis)
	|	AND NOT JournalEntryErrors.Ref.DeletionMark
	|
	|ORDER BY
	|	DocumentRef";
		
	Table = Query.Execute().Unload();
	
	Return Table;
EndFunction

Function TableErrorsInEAO(EAOArray)
	Query = New Query;
	Query.SetParameter("EAOArray", EAOArray);
	Query.Text = 
	"SELECT
	|	ExternalAccountingOperationErrors.Error AS Error,
	|	ExternalAccountingOperationErrors.Ref AS DocumentRef
	|FROM
	|	Document.ExternalAccountingOperation.Errors AS ExternalAccountingOperationErrors
	|WHERE
	|	ExternalAccountingOperationErrors.Ref IN (&EAOArray)
	|
	|ORDER BY
	|	DocumentRef";
	
	Table = Query.Execute().Unload();
	
	Return Table;
EndFunction

&AtServer
Function GetArrayOfLedgerTypes()
	Query = New Query();
	Query.Text = 
	"SELECT
	|	LedgerTypes.Ref AS LedgerType
	|FROM
	|	Catalog.LedgerTypes AS LedgerTypes
	|WHERE
	|	NOT LedgerTypes.DeletionMark";
	
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();
	
	ArrayOfLedgerTypes = QueryTable.UnloadColumn("LedgerType");
	
	Return ArrayOfLedgerTypes;
EndFunction

&AtClient
Procedure RunEAOExchange(Command)
	RunEAOExchangeAtServer();
EndProcedure
