#Region PrintForm

Function GetPrintForm(Ref, PrintFormName, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

#EndRegion

#Region Posting

Function PostingGetDocumentDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Tables = New Structure();

	ObjectStatusesServer.WriteStatusToRegister(Ref, Ref.Status);
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	Parameters.Insert("StatusInfo", StatusInfo);
	If Not StatusInfo.Posting Then
#Region NewRegistersPosting
		QueryArray = GetQueryTextsSecondaryTables();
		Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
		PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion
		Return Tables;
	EndIf
	;

#Region NewRegistersPosting
	QueryArray = GetQueryTextsSecondaryTables();
	Parameters.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	PostingServer.ExecuteQuery(Ref, QueryArray, Parameters);
#EndRegion

	Return Tables;
EndFunction

Function PostingGetLockDataSource(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	DataMapWithLockFields = New Map();
	Return DataMapWithLockFields;
EndFunction

Procedure PostingCheckBeforeWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
#Region NewRegistersPosting
	Tables = Parameters.DocumentDataTables;
	QueryArray = GetQueryTextsMasterTables();
	PostingServer.SetRegisters(Tables, Ref);

	Tables.R3035T_CashPlanning.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);

	PostingServer.FillPostingTables(Tables, Ref, QueryArray, Parameters);
#EndRegion
EndProcedure

Function PostingGetPostingDataTables(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	PostingDataTables = New Map();

#Region NewRegistersPosting
	PostingServer.SetPostingDataTables(PostingDataTables, Parameters);
#EndRegion

	Return PostingDataTables;
EndFunction

Procedure PostingCheckAfterWrite(Ref, Cancel, PostingMode, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region Undoposting

Function UndopostingGetDocumentDataTables(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Function UndopostingGetLockDataSource(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return Undefined;
EndFunction

Procedure UndopostingCheckBeforeWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

Procedure UndopostingCheckAfterWrite(Ref, Cancel, Parameters, AddInfo = Undefined) Export
	Return;
EndProcedure

#EndRegion

#Region NewRegistersPosting
Function GetInformationAboutMovements(Ref) Export
	Str = New Structure();
	Str.Insert("QueryParameters", GetAdditionalQueryParameters(Ref));
	Str.Insert("QueryTextsMasterTables", GetQueryTextsMasterTables());
	Str.Insert("QueryTextsSecondaryTables", GetQueryTextsSecondaryTables());
	Return Str;
EndFunction

Function GetAdditionalQueryParameters(Ref)
	StrParams = New Structure();
	StatusInfo = ObjectStatusesServer.GetLastStatusInfo(Ref);
	StrParams.Insert("StatusInfoPosting", StatusInfo.Posting);
	StrParams.Insert("Ref", Ref);
	Return StrParams;
EndFunction

Function GetQueryTextsSecondaryTables()
	QueryArray = New Array();
	QueryArray.Add(PaymentList());
	Return QueryArray;
EndFunction

Function GetQueryTextsMasterTables()
	QueryArray = New Array();
	QueryArray.Add(R2022B_CustomersPaymentPlanning());
	QueryArray.Add(R3035T_CashPlanning());
	Return QueryArray;
EndFunction

Function PaymentList()
	Return "SELECT
		   |	PaymentList.Ref.Date AS Date,
		   |	PaymentList.Ref.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.Ref.Company AS Company,
		   |	PaymentList.Ref.Currency AS Currency,
		   |	PaymentList.Basis,
		   |	PaymentList.Payer AS LegalName,
		   |	PaymentList.Partner AS Partner,
		   |	PaymentList.Basis.Agreement AS Agreement,
		   |	PaymentList.Ref.Account AS Account,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Amount,
		   |	PaymentList.Key,
		   |	PaymentList.Ref,
		   |	PaymentList.Ref.Branch AS Branch
		   |INTO PaymentList
		   |FROM
		   |	Document.IncomingPaymentOrder.PaymentList AS PaymentList
		   |WHERE
		   |	PaymentList.Ref = &Ref
		   |	AND &StatusInfoPosting";
EndFunction

Function R2022B_CustomersPaymentPlanning()
	Return "SELECT
		   |	VALUE(AccumulationRecordType.Expense) AS RecordType,
		   |	PaymentList.Date AS Period,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Basis,
		   |	PaymentList.LegalName,
		   |	PaymentList.Partner,
		   |	PaymentList.Agreement,
		   |	PaymentList.Amount
		   |INTO R2022B_CustomersPaymentPlanning
		   |FROM 
		   |	PaymentList AS PaymentList
		   |WHERE
		   |	NOT PaymentList.Basis.Ref IS NULL";
EndFunction

Function R3035T_CashPlanning()
	Return "SELECT
		   |	PaymentList.Date AS Period,
		   |	PaymentList.PlanningPeriod AS PlanningPeriod,
		   |	PaymentList.Company,
		   |	PaymentList.Branch,
		   |	PaymentList.Ref AS BasisDocument,
		   |	PaymentList.Account,
		   |	PaymentList.Currency,
		   |	VALUE(Enum.CashFlowDirections.Incoming) AS CashFlowDirection,
		   |	PaymentList.Partner,
		   |	PaymentList.LegalName,
		   |	PaymentList.FinancialMovementType,
		   |	PaymentList.Amount,
		   |	PaymentList.Key
		   |INTO R3035T_CashPlanning
		   |FROM
		   |	PaymentList AS PaymentList";
EndFunction

#EndRegion