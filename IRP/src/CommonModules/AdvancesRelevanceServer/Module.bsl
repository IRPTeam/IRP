
Procedure Clear(DocRef, Company, EndOfPeriod) Export
	If TypeOf(DocRef) = Type("DocumentRef.VendorsAdvancesClosing") Then
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
	ElsIf TypeOf(DocRef) = Type("DocumentRef.CustomersAdvancesClosing") Then
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
	Else
		Raise StrTemplate("Unsupported document type [%1]", TypeOf(DocRef));
	EndIf;
	QueryText = GetQueryText_Clear();
	QueryText = StrTemplate(QueryText, RelevanceRegisterName);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("Company", Company);
	Query.SetParameter("EndOfPeriod", EndOfPeriod);
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		ClearRecordSet(QuerySelection, RelevanceRegisterName);
	EndDo;
EndProcedure

Procedure Restore(DocRef, Company, EndOfPeriod) Export
	If TypeOf(DocRef) = Type("DocumentRef.VendorsAdvancesClosing") Then
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
		DocumentName = "VendorsAdvancesClosing";
	ElsIf TypeOf(DocRef) = Type("DocumentRef.CustomersAdvancesClosing") Then
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
		DocumentName = "CustomersAdvancesClosing";
	Else
		Raise StrTemplate("Unsupported document type [%1]", TypeOf(DocRef));
	EndIf;
	QueryText = GetQueryText_Restore();
	QueryText = StrTemplate(QueryText, DocumentName);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("EndOfPeriod" , EndOfPeriod);
	Query.SetParameter("Company"     , Company);
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		WriteRecordSet(QuerySelection.Document, QuerySelection, RelevanceRegisterName, True);
	EndDo;
EndProcedure

Procedure Reset(DocRef, Company, BeginOfPeriod) Export
	If TypeOf(DocRef) = Type("DocumentRef.VendorsAdvancesClosing") Then
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
		DocumentName = "VendorsAdvancesClosing";
	ElsIf TypeOf(DocRef) = Type("DocumentRef.CustomersAdvancesClosing") Then
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
		DocumentName = "CustomersAdvancesClosing";
	Else
		Raise StrTemplate("Unsupported document type [%1]", TypeOf(DocRef));
	EndIf;
	QueryText = GetQueryText_Reset();
	QueryText = StrTemplate(QueryText, DocumentName);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("Company"       , Company);
	Query.SetParameter("BeginOfPeriod" , BeginOfPeriod);
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		WriteRecordSet(QuerySelection.Document, QuerySelection, RelevanceRegisterName, False, False);
	EndDo;
EndProcedure

Procedure SetBound_Advances(DocObject, Records, RegisterMetadata) Export
	QueryText = GetQueryText_Advances();
	AccReg = Metadata.AccumulationRegisters;
	If RegisterMetadata = AccReg.R1020B_AdvancesToVendors Then
		FilterAttribute = "VendorsAdvancesClosing";
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R1020B_AdvancesToVendors", FilterAttribute, RelevanceRegisterName);
	ElsIf RegisterMetadata = AccReg.R2020B_AdvancesFromCustomers Then
		FilterAttribute = "CustomersAdvancesClosing";
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R2020B_AdvancesFromCustomers", FilterAttribute, RelevanceRegisterName);
	Else
		Raise StrTemplate("Unsupported register metadata [%1]", RegisterMetadata);
	EndIf;
	RecordsCopy = CopyRecords(Records, RegisterMetadata, FilterAttribute, True);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("RecordsCopy", RecordsCopy);
	Query.SetParameter("Recorder", DocObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		SetBound(DocObject, QuerySelection, RelevanceRegisterName);
	EndDo;	
EndProcedure

Procedure SetBound_Transactions(DocObject, Records, RegisterMetadata) Export
	QueryText = GetQueryText_Transactions();
	AccReg = Metadata.AccumulationRegisters;
	If RegisterMetadata = AccReg.R1021B_VendorsTransactions Then
		FilterAttribute = "VendorsAdvancesClosing";
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R1021B_VendorsTransactions", FilterAttribute, RelevanceRegisterName);
	ElsIf RegisterMetadata = AccReg.R2021B_CustomersTransactions Then
		FilterAttribute = "CustomersAdvancesClosing";
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R2021B_CustomersTransactions", FilterAttribute, RelevanceRegisterName);
	Else
		Raise StrTemplate("Unsupported register metadata [%1]", RegisterMetadata);
	EndIf;
	RecordsCopy = CopyRecords(Records, RegisterMetadata, FilterAttribute, True);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("RecordsCopy", RecordsCopy);
	Query.SetParameter("Recorder", DocObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		SetBound(DocObject, QuerySelection, RelevanceRegisterName);
	EndDo;	
EndProcedure

Procedure SetBound_Aging(DocObject, Records, RegisterMetadata) Export
	QueryText = GetQueryText_Aging();
	AccReg = Metadata.AccumulationRegisters;
	If RegisterMetadata = AccReg.R5012B_VendorsAging Then
		FilterAttribute = "AgingClosing";
		RelevanceRegisterName = "T2016S_VendorsAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R5012B_VendorsAging", FilterAttribute, RelevanceRegisterName);
	ElsIf RegisterMetadata = AccReg.R5011B_CustomersAging Then
		FilterAttribute = "AgingClosing";
		RelevanceRegisterName = "T2017S_CustomersAdvancesRelevance";
		QueryText = StrTemplate(QueryText, "R5011B_CustomersAging", FilterAttribute, RelevanceRegisterName);
	Else
		Raise StrTemplate("Unsupported register metadata [%1]", RegisterMetadata);
	EndIf;
	RecordsCopy = CopyRecords(Records, RegisterMetadata, FilterAttribute, False);
	Query = New Query();
	Query.Text = QueryText;
	Query.SetParameter("RecordsCopy", RecordsCopy);
	Query.SetParameter("Recorder", DocObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		SetBound(DocObject, QuerySelection, RelevanceRegisterName);
	EndDo;	
EndProcedure

Function GetQueryText_Clear()
	Return
	"SELECT
	|	RegisterRelevance.Date AS DateOld,
	|	RegisterRelevance.Company AS CompanyOld,
	|	RegisterRelevance.Branch AS BranchOld,
	|	RegisterRelevance.Currency AS CurrencyOld,
	|	RegisterRelevance.Partner AS PartnerOld
	|FROM
	|	InformationRegister.%1 AS RegisterRelevance
	|WHERE
	|	RegisterRelevance.Company = &Company
	|	AND RegisterRelevance.Date <= ENDOFPERIOD(&EndOfPeriod, DAY)";
EndFunction

Function GetQueryText_Restore()
	Return
	"SELECT
	|	OffsetOfAdvances.Period AS Period,
	|	OffsetOfAdvances.Company AS Company,
	|	OffsetOfAdvances.Branch AS Branch,
	|	OffsetOfAdvances.Currency AS Currency,
	|	OffsetOfAdvances.Partner AS Partner,
	|	OffsetOfAdvances.Document AS Document
	|INTO tmp
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
	|WHERE
	|	OffsetOfAdvances.Period <= ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND OffsetOfAdvances.Company = &Company
	|	AND OffsetOfAdvances.Recorder REFS Document.%1
	|
	|UNION ALL
	|
	|SELECT
	|	OffsetOfAging.Period,
	|	OffsetOfAging.Company,
	|	OffsetOfAging.Branch,
	|	OffsetOfAging.Currency,
	|	OffsetOfAging.Partner,
	|	OffsetOfAging.Document
	|FROM
	|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
	|WHERE
	|	OffsetOfAging.Period <= ENDOFPERIOD(&EndOfPeriod, DAY)
	|	AND OffsetOfAging.Company = &Company
	|	AND OffsetOfAging.Recorder REFS Document.%1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(tmp.Period) AS Period,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner
	|INTO tmp_Grouped
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Branch,
	|	tmp.Currency,
	|	tmp.Partner
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_Grouped.Period AS DateNew,
	|	tmp_Grouped.Company AS CompanyNew,
	|	tmp_Grouped.Branch AS BranchNew,
	|	tmp_Grouped.Currency AS CurrencyNew,
	|	tmp_Grouped.Partner AS PartnerNew,
	|	MAX(tmp.Document) AS Document
	|FROM
	|	tmp_Grouped AS tmp_Grouped
	|		LEFT JOIN tmp AS tmp
	|		ON tmp_Grouped.Period = tmp.Period
	|		AND tmp_Grouped.Company = tmp.Company
	|		AND tmp_Grouped.Branch = tmp.Branch
	|		AND tmp_Grouped.Currency = tmp.Currency
	|		AND tmp_Grouped.Partner = tmp.Partner
	|GROUP BY
	|	tmp_Grouped.Period,
	|	tmp_Grouped.Company,
	|	tmp_Grouped.Branch,
	|	tmp_Grouped.Currency,
	|	tmp_Grouped.Partner";
EndFunction

Function GetQueryText_Reset()
	Return
	"SELECT
	|	OffsetOfAdvances.Period AS Period,
	|	OffsetOfAdvances.Company AS Company,
	|	OffsetOfAdvances.Branch AS Branch,
	|	OffsetOfAdvances.Currency AS Currency,
	|	OffsetOfAdvances.Partner AS Partner,
	|	OffsetOfAdvances.Document AS Document
	|INTO tmp
	|FROM
	|	InformationRegister.T2010S_OffsetOfAdvances AS OffsetOfAdvances
	|WHERE
	|	OffsetOfAdvances.Period <= BEGINOFPERIOD(&BeginOfPeriod, DAY)
	|	AND OffsetOfAdvances.Company = &Company
	|	AND OffsetOfAdvances.Recorder REFS Document.%1
	|
	|UNION ALL
	|
	|SELECT
	|	OffsetOfAging.Period,
	|	OffsetOfAging.Company,
	|	OffsetOfAging.Branch,
	|	OffsetOfAging.Currency,
	|	OffsetOfAging.Partner,
	|	OffsetOfAging.Document
	|FROM
	|	InformationRegister.T2013S_OffsetOfAging AS OffsetOfAging
	|WHERE
	|	OffsetOfAging.Period <= BEGINOFPERIOD(&BeginOfPeriod, DAY)
	|	AND OffsetOfAging.Company = &Company
	|	AND OffsetOfAging.Recorder REFS Document.%1
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(tmp.Period) AS Period,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Partner AS Partner
	|INTO tmp_Grouped
	|FROM
	|	tmp AS tmp
	|GROUP BY
	|	tmp.Company,
	|	tmp.Branch,
	|	tmp.Currency,
	|	tmp.Partner
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_Grouped.Period AS DateNew,
	|	tmp_Grouped.Company AS CompanyNew,
	|	tmp_Grouped.Branch AS BranchNew,
	|	tmp_Grouped.Currency AS CurrencyNew,
	|	tmp_Grouped.Partner AS PartnerNew,
	|	MAX(tmp.Document) AS Document
	|FROM
	|	tmp_Grouped AS tmp_Grouped
	|		LEFT JOIN tmp AS tmp
	|		ON tmp_Grouped.Period = tmp.Period
	|		AND tmp_Grouped.Company = tmp.Company
	|		AND tmp_Grouped.Branch = tmp.Branch
	|		AND tmp_Grouped.Currency = tmp.Currency
	|		AND tmp_Grouped.Partner = tmp.Partner
	|GROUP BY
	|	tmp_Grouped.Period,
	|	tmp_Grouped.Company,
	|	tmp_Grouped.Branch,
	|	tmp_Grouped.Currency,
	|	tmp_Grouped.Partner";
EndFunction

Function GetQueryText_Advances()
	Return
	"SELECT
	|	tmp.Period AS Date,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.LegalName AS LegalName,
	|	tmp.Partner AS Partner,
	|	tmp.Order AS Order,
	|	tmp.Amount AS Amount
	|INTO Records
	|FROM
	|	&RecordsCopy AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.LegalName,
	|	Records.Partner,
	|	Records.Order,
	|	SUM(Records.Amount) AS Amount
	|INTO tmp1
	|FROM
	|	Records AS Records
	|GROUP BY
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.LegalName,
	|	Records.Partner,
	|	Records.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Register.Period AS Date,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.LegalName,
	|	Register.Partner,
	|	Register.Order,
	|	SUM(Register.Amount) AS Amount
	|INTO tmp2
	|FROM
	|	AccumulationRegister.%1 AS Register
	|WHERE
	|	Register.Recorder = &Recorder
	|	AND Register.%2.Ref IS NULL
	|	AND Register.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	Register.Period,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.LegalName,
	|	Register.Partner,
	|	Register.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp1.Date AS DateNew,
	|	tmp1.Company AS CompanyNew,
	|	tmp1.Branch AS BranchNew,
	|	tmp1.Currency AS CurrencyNew,
	|	tmp1.Partner AS PartnerNew,
	|	tmp2.Date AS DateOld,
	|	tmp2.Company AS CompanyOld,
	|	tmp2.Branch AS BranchOld,
	|	tmp2.Currency AS CurrencyOld,
	|	tmp2.Partner AS PartnerOld
	|INTO JoinedData
	|FROM
	|	tmp1 AS tmp1
	|		FULL JOIN tmp2 AS tmp2
	|		ON tmp1.Date = tmp2.Date
	|		AND tmp1.Company = tmp2.Company
	|		AND tmp1.Branch = tmp2.Branch
	|		AND tmp1.Currency = tmp2.Currency
	|		AND tmp1.LegalName = tmp2.LegalName
	|		AND tmp1.Partner = tmp2.Partner
	|		AND tmp1.Order = tmp2.Order
	|		AND tmp1.Amount = tmp2.Amount
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JoinedData.DateNew AS Date,
	|	JoinedData.CompanyNew AS Company,
	|	JoinedData.BranchNew AS Branch,
	|	JoinedData.CurrencyNew AS Currency,
	|	JoinedData.PartnerNew AS Partner
	|INTO ModifiedData
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateOld IS NULL
	|
	|UNION
	|
	|SELECT
	|	JoinedData.DateOld,
	|	JoinedData.CompanyOld,
	|	JoinedData.BranchOld,
	|	JoinedData.CurrencyOld,
	|	JoinedData.PartnerOld
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateNew IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RegisterRelevance.Date AS DateOld,
	|	RegisterRelevance.Company AS CompanyOld,
	|	RegisterRelevance.Branch AS BranchOld,
	|	RegisterRelevance.Currency AS CurrencyOld,
	|	RegisterRelevance.Partner AS PartnerOld,
	|	MIN(ModifiedData.Date) AS DateNew,
	|	ModifiedData.Company AS CompanyNew,
	|	ModifiedData.Branch AS BranchNew,
	|	ModifiedData.Currency AS CurrencyNew,
	|	ModifiedData.Partner AS PartnerNew
	|FROM
	|	ModifiedData AS ModifiedData
	|		LEFT JOIN InformationRegister.%3 AS RegisterRelevance
	|		ON ModifiedData.Company = RegisterRelevance.Company
	|		AND ModifiedData.Branch = RegisterRelevance.Branch
	|		AND ModifiedData.Currency = RegisterRelevance.Currency
	|		AND ModifiedData.Partner = RegisterRelevance.Partner
	|GROUP BY
	|	RegisterRelevance.Date,
	|	RegisterRelevance.Company,
	|	RegisterRelevance.Branch,
	|	RegisterRelevance.Currency,
	|	RegisterRelevance.Partner,
	|	ModifiedData.Company,
	|	ModifiedData.Branch,
	|	ModifiedData.Currency,
	|	ModifiedData.Partner";
EndFunction

Function GetQueryText_Transactions()
	Return
	"SELECT
	|	tmp.Period AS Date,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.LegalName AS LegalName,
	|	tmp.Partner AS Partner,
	|	tmp.Agreement AS Agreement,
	|	tmp.Basis AS Basis,
	|	tmp.Order AS Order,
	|	tmp.Amount AS Amount
	|INTO Records
	|FROM
	|	&RecordsCopy AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.LegalName,
	|	Records.Partner,
	|	Records.Agreement,
	|	Records.Basis,
	|	Records.Order,
	|	SUM(Records.Amount) AS Amount
	|INTO tmp1
	|FROM
	|	Records AS Records
	|GROUP BY
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.LegalName,
	|	Records.Partner,
	|	Records.Agreement,
	|	Records.Basis,
	|	Records.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Register.Period AS Date,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.LegalName,
	|	Register.Partner,
	|	Register.Agreement,
	|	Register.Basis,
	|	Register.Order,
	|	SUM(Register.Amount) AS Amount
	|INTO tmp2
	|FROM
	|	AccumulationRegister.%1 AS Register
	|WHERE
	|	Register.Recorder = &Recorder
	|	AND Register.%2.Ref IS NULL
	|	AND Register.CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
	|GROUP BY
	|	Register.Period,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.LegalName,
	|	Register.Partner,
	|	Register.Agreement,
	|	Register.Basis,
	|	Register.Order
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp1.Date AS DateNew,
	|	tmp1.Company AS CompanyNew,
	|	tmp1.Branch AS BranchNew,
	|	tmp1.Currency AS CurrencyNew,
	|	tmp1.Partner AS PartnerNew,
	|	tmp2.Date AS DateOld,
	|	tmp2.Company AS CompanyOld,
	|	tmp2.Branch AS BranchOld,
	|	tmp2.Currency AS CurrencyOld,
	|	tmp2.Partner AS PartnerOld
	|INTO JoinedData
	|FROM
	|	tmp1 AS tmp1
	|		FULL JOIN tmp2 AS tmp2
	|		ON tmp1.Date = tmp2.Date
	|		AND tmp1.Company = tmp2.Company
	|		AND tmp1.Branch = tmp2.Branch
	|		AND tmp1.Currency = tmp2.Currency
	|		AND tmp1.LegalName = tmp2.LegalName
	|		AND tmp1.Partner = tmp2.Partner
	|		AND tmp1.Agreement = tmp2.Agreement
	|		AND tmp1.Basis = tmp2.Basis
	|		AND tmp1.Order = tmp2.Order
	|		AND tmp1.Amount = tmp2.Amount
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JoinedData.DateNew AS Date,
	|	JoinedData.CompanyNew AS Company,
	|	JoinedData.BranchNew AS Branch,
	|	JoinedData.CurrencyNew AS Currency,
	|	JoinedData.PartnerNew AS Partner
	|INTO ModifiedData
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateOld IS NULL
	|
	|UNION
	|
	|SELECT
	|	JoinedData.DateOld,
	|	JoinedData.CompanyOld,
	|	JoinedData.BranchOld,
	|	JoinedData.CurrencyOld,
	|	JoinedData.PartnerOld
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateNew IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RegisterRelevance.Date AS DateOld,
	|	RegisterRelevance.Company AS CompanyOld,
	|	RegisterRelevance.Branch AS BranchOld,
	|	RegisterRelevance.Currency AS CurrencyOld,
	|	RegisterRelevance.Partner AS PartnerOld,
	|	MIN(ModifiedData.Date) AS DateNew,
	|	ModifiedData.Company AS CompanyNew,
	|	ModifiedData.Branch AS BranchNew,
	|	ModifiedData.Currency AS CurrencyNew,
	|	ModifiedData.Partner AS PartnerNew
	|FROM
	|	ModifiedData AS ModifiedData
	|		LEFT JOIN InformationRegister.%3 AS RegisterRelevance
	|		ON ModifiedData.Company = RegisterRelevance.Company
	|		AND ModifiedData.Branch = RegisterRelevance.Branch
	|		AND ModifiedData.Currency = RegisterRelevance.Currency
	|		AND ModifiedData.Partner = RegisterRelevance.Partner
	|GROUP BY
	|	RegisterRelevance.Date,
	|	RegisterRelevance.Company,
	|	RegisterRelevance.Branch,
	|	RegisterRelevance.Currency,
	|	RegisterRelevance.Partner,
	|	ModifiedData.Company,
	|	ModifiedData.Branch,
	|	ModifiedData.Currency,
	|	ModifiedData.Partner";
EndFunction

Function GetQueryText_Aging()
	Return
	"SELECT
	|	tmp.Period AS Date,
	|	tmp.Company AS Company,
	|	tmp.Branch AS Branch,
	|	tmp.Currency AS Currency,
	|	tmp.Agreement AS Agreement,
	|	tmp.Partner AS Partner,
	|	tmp.Invoice AS Invoice,
	|	tmp.PaymentDate AS PaymentDate,
	|	tmp.Amount AS Amount
	|INTO Records
	|FROM
	|	&RecordsCopy AS tmp
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.Agreement,
	|	Records.Partner,
	|	Records.Invoice,
	|	Records.PaymentDate,
	|	SUM(Records.Amount) AS Amount
	|INTO tmp1
	|FROM
	|	Records AS Records
	|GROUP BY
	|	Records.Date,
	|	Records.Company,
	|	Records.Branch,
	|	Records.Currency,
	|	Records.Agreement,
	|	Records.Partner,
	|	Records.Invoice,
	|	Records.PaymentDate
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	Register.Period AS Date,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.Agreement,
	|	Register.Partner,
	|	Register.Invoice,
	|	Register.PaymentDate,
	|	SUM(Register.Amount) AS Amount
	|INTO tmp2
	|FROM
	|	AccumulationRegister.%1 AS Register
	|WHERE
	|	Register.Recorder = &Recorder
	|	AND Register.%2.Ref IS NULL
	|GROUP BY
	|	Register.Period,
	|	Register.Company,
	|	Register.Branch,
	|	Register.Currency,
	|	Register.Agreement,
	|	Register.Partner,
	|	Register.Invoice,
	|	Register.PaymentDate
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp1.Date AS DateNew,
	|	tmp1.Company AS CompanyNew,
	|	tmp1.Branch AS BranchNew,
	|	tmp1.Currency AS CurrencyNew,
	|	tmp1.Partner AS PartnerNew,
	|	tmp2.Date AS DateOld,
	|	tmp2.Company AS CompanyOld,
	|	tmp2.Branch AS BranchOld,
	|	tmp2.Currency AS CurrencyOld,
	|	tmp2.Partner AS PartnerOld
	|INTO JoinedData
	|FROM
	|	tmp1 AS tmp1
	|		FULL JOIN tmp2 AS tmp2
	|		ON tmp1.Date = tmp2.Date
	|		AND tmp1.Company = tmp2.Company
	|		AND tmp1.Branch = tmp2.Branch
	|		AND tmp1.Currency = tmp2.Currency
	|		AND tmp1.Agreement = tmp2.Agreement
	|		AND tmp1.Partner = tmp2.Partner
	|		AND tmp1.Invoice = tmp2.Invoice
	|		AND tmp1.PaymentDate = tmp2.PaymentDate
	|		AND tmp1.Amount = tmp2.Amount
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JoinedData.DateNew AS Date,
	|	JoinedData.CompanyNew AS Company,
	|	JoinedData.BranchNew AS Branch,
	|	JoinedData.CurrencyNew AS Currency,
	|	JoinedData.PartnerNew AS Partner
	|INTO ModifiedData
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateOld IS NULL
	|
	|UNION
	|
	|SELECT
	|	JoinedData.DateOld,
	|	JoinedData.CompanyOld,
	|	JoinedData.BranchOld,
	|	JoinedData.CurrencyOld,
	|	JoinedData.PartnerOld
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.DateNew IS NULL
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	RegisterRelevance.Date AS DateOld,
	|	RegisterRelevance.Company AS CompanyOld,
	|	RegisterRelevance.Branch AS BranchOld,
	|	RegisterRelevance.Currency AS CurrencyOld,
	|	RegisterRelevance.Partner AS PartnerOld,
	|	MIN(ModifiedData.Date) AS DateNew,
	|	ModifiedData.Company AS CompanyNew,
	|	ModifiedData.Branch AS BranchNew,
	|	ModifiedData.Currency AS CurrencyNew,
	|	ModifiedData.Partner AS PartnerNew
	|FROM
	|	ModifiedData AS ModifiedData
	|		LEFT JOIN InformationRegister.%3 AS RegisterRelevance
	|		ON ModifiedData.Company = RegisterRelevance.Company
	|		AND ModifiedData.Branch = RegisterRelevance.Branch
	|		AND ModifiedData.Currency = RegisterRelevance.Currency
	|		AND ModifiedData.Partner = RegisterRelevance.Partner
	|GROUP BY
	|	RegisterRelevance.Date,
	|	RegisterRelevance.Company,
	|	RegisterRelevance.Branch,
	|	RegisterRelevance.Currency,
	|	RegisterRelevance.Partner,
	|	ModifiedData.Company,
	|	ModifiedData.Branch,
	|	ModifiedData.Currency,
	|	ModifiedData.Partner";
EndFunction

Procedure SetBound(DocObject, BoundParameters, RelevanceRegisterName)
	If ValueIsFilled(BoundParameters.DateOld) Then
		If GetPointInTime(BoundParameters, RelevanceRegisterName).Compare(DocObject.PointInTime()) = 1 Then
			ClearRecordSet(BoundParameters, RelevanceRegisterName);
			WriteRecordSet(DocObject.Ref, BoundParameters, RelevanceRegisterName);
		Else
			SetIsRelevance(DocObject.Ref, BoundParameters, RelevanceRegisterName);
		EndIf;
	Else //first registration
		WriteRecordSet(DocObject.Ref, BoundParameters, RelevanceRegisterName);
	EndIf;
EndProcedure

Function CopyRecords(Records, RegisterMetadata, FilterAttribute, FilterByCurrencyMovementType)
	RecordsCopy = PostingServer.CreateTable(RegisterMetadata);
	For Each Record In Records Do
		If ValueIsFilled(Record[FilterAttribute]) Then
			Continue;
		EndIf;
		If FilterByCurrencyMovementType And
			Record.CurrencyMovementType <> ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
			Continue;
		EndIf;
		FillPropertyValues(RecordsCopy.Add(), Record);
	EndDo;
	Return RecordsCopy;
EndFunction

Function GetPointInTime(QueryParameters, RelevanceRegisterName)
	Query = New Query();
	Query.Text =
	"SELECT
	|	RegisterRelevance.Document.PointInTime AS PointInTime
	|FROM
	|	InformationRegister.%1 AS RegisterRelevance
	|WHERE
	|	RegisterRelevance.Date = &Date
	|	AND RegisterRelevance.Company = &Company
	|	AND RegisterRelevance.Branch = &Branch
	|	AND RegisterRelevance.Currency = &Currency
	|	AND RegisterRelevance.Partner = &Partner";
	Query.Text = StrTemplate(Query.Text, RelevanceRegisterName);
	Query.SetParameter("Date"     , QueryParameters.DateOld);
	Query.SetParameter("Company"  , QueryParameters.CompanyOld);
	Query.SetParameter("Branch"   , QueryParameters.BranchOld);
	Query.SetParameter("Currency" , QueryParameters.CurrencyOld);
	Query.SetParameter("Partner"  , QueryParameters.PartnerOld);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.PointInTime;
	Else
		Raise "Can not get point in time";
	EndIf;
EndFunction

Procedure SetIsRelevance(DocRef, RelevanceParameters, RelevanceRegisterName)
	RecordSet = InformationRegisters[RelevanceRegisterName].CreateRecordSet();
	RecordSet.Filter.Date.Set(RelevanceParameters.DateOld);
	RecordSet.Filter.Company.Set(RelevanceParameters.CompanyOld);
	RecordSet.Filter.Branch.Set(RelevanceParameters.BranchOld);
	RecordSet.Filter.Currency.Set(RelevanceParameters.CurrencyOld);
	RecordSet.Filter.Partner.Set(RelevanceParameters.PartnerOld);
	RecordSet.Read();
	For Each Row In RecordSet Do
		If Row.Document = DocRef Then
			Row.IsRelevance = False;
		EndIf;
	EndDo;
	RecordSet.Write();
EndProcedure

Procedure ClearRecordSet(RecordParameters, RelevanceRegisterName)
	RecordSet = InformationRegisters[RelevanceRegisterName].CreateRecordSet();
	RecordSet.Filter.Date.Set(RecordParameters.DateOld);
	RecordSet.Filter.Company.Set(RecordParameters.CompanyOld);
	RecordSet.Filter.Branch.Set(RecordParameters.BranchOld);
	RecordSet.Filter.Currency.Set(RecordParameters.CurrencyOld);
	RecordSet.Filter.Partner.Set(RecordParameters.PartnerOld);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

Procedure WriteRecordSet(DocumentRef, RecordParameters, RelevanceRegisterName, IsRelevance = False, FilterByDate = True)
	RecordSet = InformationRegisters[RelevanceRegisterName].CreateRecordSet();
	If FilterByDate Then
		RecordSet.Filter.Date.Set(RecordParameters.DateNew);
	EndIf;
	RecordSet.Filter.Company.Set(RecordParameters.CompanyNew);
	RecordSet.Filter.Branch.Set(RecordParameters.BranchNew);
	RecordSet.Filter.Currency.Set(RecordParameters.CurrencyNew);
	RecordSet.Filter.Partner.Set(RecordParameters.PartnerNew);
	NewRecord = RecordSet.Add();
	NewRecord.Date     = RecordParameters.DateNew;
	NewRecord.Company  = RecordParameters.CompanyNew;
	NewRecord.Branch   = RecordParameters.BranchNew;
	NewRecord.Currency = RecordParameters.CurrencyNew;
	NewRecord.Partner  = RecordParameters.PartnerNew;
	NewRecord.Document = DocumentRef;
	NewRecord.IsRelevance = IsRelevance;
	RecordSet.Write();
EndProcedure
