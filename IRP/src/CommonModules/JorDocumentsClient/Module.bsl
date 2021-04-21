
Procedure BasisDocumentStartChoice(Object, Form, Item, CurrentData, Parameters) Export
	TransferParameters = New Structure();
	TransferParameters.Insert("Unmarked", True);
	TransferParameters.Insert("Posted", True);
	If Parameters.Property("Filter") Then
		For Each KeyValue In Parameters.Filter Do
			TransferParameters.Insert(KeyValue.Key, KeyValue.Value);
		EndDo;
	EndIf;
	ArrayOfFilterFromCurrentData = StrSplit(Parameters.FilterFromCurrentData, ",");
	For Each ItemOfFilterFromCurrentData In ArrayOfFilterFromCurrentData Do
		If ValueIsFilled(CurrentData[TrimAll(ItemOfFilterFromCurrentData)]) Then
			TransferParameters.Insert(ItemOfFilterFromCurrentData, CurrentData[TrimAll(ItemOfFilterFromCurrentData)]);
		EndIf;
	EndDo;
	OpeningEntryTableName1 = Undefined;
	If Parameters.Property("OpeningEntryTableName1") Then
		OpeningEntryTableName1 = Parameters.OpeningEntryTableName1;
	EndIf;
	
	OpeningEntryTableName2 = Undefined;
	If Parameters.Property("OpeningEntryTableName2") Then
		OpeningEntryTableName2 = Parameters.OpeningEntryTableName2;
	EndIf;
	 
	FilterStructure = CreateFilterByParameters(Parameters.Ref,
		TransferParameters, 
		Parameters.TableName, 
		OpeningEntryTableName1, 
		OpeningEntryTableName2);
	FormParameters = New Structure("CustomFilter", FilterStructure);
	
	OpenForm("DocumentJournal." + Parameters.TableName + ".Form.ChoiceForm",
		FormParameters,
		Item,
		Form.UUID,
		,
		Form.URL,
		Parameters.Notify,
		FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

Function CreateFilterByParameters(Ref, Parameters, TableName, 
                                  OpeningEntryTableName1 = Undefined, 
                                  OpeningEntryTableName2 = Undefined)
	QueryText_TableName = "SELECT ALLOWED
		|	Obj.Ref,
		|	Obj.Ref.Company AS Company,
		|	Obj.Ref.Partner AS Partner,
		|	Obj.Ref.LegalName AS LegalName,
		|	Obj.Ref.Agreement AS Agreement,
		|	Obj.Ref.DocumentAmount AS DocumentAmount,
		|	Obj.Ref.Currency AS Currency
		|INTO Doc
		|FROM
		|	DocumentJournal.%1 AS Obj
		|WHERE
		|	True
		|	%2";
	
	QueryText_OpeningEntryTableName1 = "";
	If OpeningEntryTableName1 <> Undefined Then
		QueryText_OpeningEntryTableName1 = "
			|UNION ALL
			|SELECT
			|	OpeningEntry.Ref,
			|	MAX(OpeningEntry.Ref.Company),
			|	MAX(OpeningEntry.Partner),
			|	MAX(OpeningEntry.LegalName),
			|	MAX(OpeningEntry.Agreement),
			|	SUM(OpeningEntry.Amount),
			|	MAX(OpeningEntry.Currency)
			|FROM
			|Document.OpeningEntry.%1 AS OpeningEntry
			|	WHERE
			|	TRUE
			|	%2
			|GROUP BY
			|	OpeningEntry.Ref";
	EndIf;
	
	QueryText_OpeningEntryTableName2 = "";
	If OpeningEntryTableName2 <> Undefined Then
		QueryText_OpeningEntryTableName2 = "
			|UNION ALL
			|SELECT
			|	OpeningEntry.Ref,
			|	MAX(OpeningEntry.Ref.Company),
			|	MAX(OpeningEntry.Partner),
			|	MAX(OpeningEntry.LegalName),
			|	MAX(OpeningEntry.Agreement),
			|	SUM(OpeningEntry.Amount),
			|	MAX(OpeningEntry.Currency)
			|FROM
			|Document.OpeningEntry.%1 AS OpeningEntry
			|	WHERE
			|	TRUE
			|	%2
			|GROUP BY
			|	OpeningEntry.Ref";
	EndIf;
		
	QueryParameters = New Structure();
	QueryParameters.Insert("Ref", Ref);
	
	ArrayOfConditions = New Array();
	ArrayOfConditionsOpeningEntry = New Array();
	
	If Parameters.Property("Type") Then
		QueryParameters.Insert("Type", Parameters.Type);
		ArrayOfConditions.Add(" AND Obj.Type = &Type");
	EndIf;
	
	If Parameters.Property("Unmarked") Then
		QueryParameters.Insert("Unmarked", Parameters.Unmarked);
		ArrayOfConditions.Add(" AND NOT Obj.DeletionMark = &Unmarked");
		ArrayOfConditionsOpeningEntry.Add(" AND NOT OpeningEntry.Ref.DeletionMark = &Unmarked");
	EndIf;
	
	If Parameters.Property("Partner") Then
		QueryParameters.Insert("Partner", Parameters.Partner);
		ArrayOfConditions.Add(" AND Obj.Ref.Partner = &Partner");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Partner = &Partner");
	EndIf;
	
	If Parameters.Property("LegalName") Then
		QueryParameters.Insert("LegalName", Parameters.LegalName);
		ArrayOfConditions.Add(" AND Obj.Ref.LegalName = &LegalName");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.LegalName = &LegalName");
	EndIf;
	
	If Parameters.Property("Agreement") Then
		QueryParameters.Insert("Agreement", Parameters.Agreement);
		ArrayOfConditions.Add(" AND Obj.Ref.Agreement = &Agreement");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Agreement = &Agreement");
	EndIf;
	
	If Parameters.Property("Company") Then
		QueryParameters.Insert("Company", Parameters.Company);
		ArrayOfConditions.Add(" AND Obj.Ref.Company = &Company");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Ref.Company = &Company");
	EndIf;
	
	If Parameters.Property("Agreement_ApArPostingDetail") Then
		QueryParameters.Insert("Agreement_ApArPostingDetail", Parameters.Agreement_ApArPostingDetail);
		ArrayOfConditions.Add(" AND Obj.Ref.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Agreement.ApArPostingDetail = &Agreement_ApArPostingDetail");
	EndIf;
	
	If Parameters.Property("Posted") Then
		QueryParameters.Insert("Posted", Parameters.Posted);
		ArrayOfConditions.Add(" AND Obj.Ref.Posted = &Posted");
		ArrayOfConditionsOpeningEntry.Add(" AND OpeningEntry.Ref.Posted = &Posted");
	EndIf;
	
	ConditionsText             = StrConcat(ArrayOfConditions);
	ConditionsOpeningEntryText = StrConcat(ArrayOfConditionsOpeningEntry);
	QueryText_TableName = StrTemplate(QueryText_TableName, TableName, ConditionsText);
	
	If OpeningEntryTableName1 <> Undefined Then
		QueryText_OpeningEntryTableName1 = StrTemplate(QueryText_OpeningEntryTableName1, OpeningEntryTableName1, ConditionsOpeningEntryText);
	EndIf;

	If OpeningEntryTableName2 <> Undefined Then
		QueryText_OpeningEntryTableName2 = StrTemplate(QueryText_OpeningEntryTableName2, OpeningEntryTableName2, ConditionsOpeningEntryText);
	EndIf;
	
	QueryText = QueryText_TableName 
	+ QueryText_OpeningEntryTableName1 
	+ QueryText_OpeningEntryTableName2
	+ " ;
	|SELECT ALLOWED
	//|	CustomersTransactions.BasisDocument AS Ref,
	|	CustomersTransactions.Basis AS Ref,
	|	CustomersTransactions.Company AS Company,
	|	CustomersTransactions.Partner AS Partner,
	|	CustomersTransactions.LegalName AS LegalName,
	|	CustomersTransactions.Agreement AS Agreement,
	|	CustomersTransactions.Currency AS Currency,
	|	CustomersTransactions.AmountBalance AS DocumentAmount
	|FROM
//	|	AccumulationRegister.PartnerApTransactions.Balance(&Period,
	|	AccumulationRegister.R2021B_CustomersTransactions.Balance(&Period,
	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
//	|	AND (BasisDocument, Company, Partner, LegalName, Agreement, Currency) IN
	|	AND (Basis, Company, Partner, LegalName, Agreement, Currency) IN
	|		(SELECT
	|			Doc.Ref,
	|			Doc.Company,
	|			Doc.Partner,
	|			Doc.LegalName,
	|			Doc.Agreement,
	|			Doc.Currency
	|		FROM
	|			Doc AS Doc)) AS CustomersTransactions
	|//------
	|WHERE
	|	CustomersTransactions.AmountBalance > 0
	|
	|";
//	|
//	|UNION ALL
//	|
//	|SELECT
//	|	AR.BasisDocument,
//	|	AR.Company,
//	|	AR.Partner,
//	|	AR.LegalName,
//	|	AR.Agreement,
//	|	AR.Currency,
//	|	AR.AmountBalance
//	|FROM
//	|	AccumulationRegister.PartnerArTransactions.Balance(&Period,
//	|		CurrencyMovementType = VALUE(ChartOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency)
//	|	AND (BasisDocument, Company, Partner, LegalName, Agreement, Currency) IN
//	|		(SELECT
//	|			Doc.Ref,
//	|			Doc.Company,
//	|			Doc.Partner,
//	|			Doc.LegalName,
//	|			Doc.Agreement,
//	|			Doc.Currency
//	|		FROM
//	|			Doc AS Doc)) AS AR";
	
	FilterStructure = New Structure();
	FilterStructure.Insert("QueryText", QueryText);
	FilterStructure.Insert("QueryParameters", QueryParameters);
	
	Return FilterStructure;
EndFunction
