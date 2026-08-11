Procedure Revenues_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R5021T_Revenues.Recorder
	|FROM
	|	AccumulationRegister.R5021T_Revenues AS R5021T_Revenues
	|WHERE
	|	R5021T_Revenues.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R5021T_Revenues.Recorder";
	Query.SetParameter("CalculationMovementCost", DocObjectRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Recorder);
		
		RecordSet.Read();
		ArrayForDelete = New Array();
		For Each Row In RecordSet Do
			If Row.CalculationMovementCost = DocObjectRef Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		For Each ItemForDelete In ArrayForDelete Do
			RecordSet.Delete(ItemForDelete);
		EndDo;
		
		RecordSet.Write();
	EndDo;
EndProcedure

Procedure Revenues_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	Reg.Period,
	|	Reg.Recorder as CalculationMovementCosts,
	|	Reg.Document,
	|	Reg.Company,
	|	Reg.Branch,
	|	Reg.ProfitLossCenter,
	|	Reg.CorrectionExpenseRevenueType as ExpenseType,
	|	Reg.ItemKey,
	|	Reg.Currency,
	|	"""",  //|	Reg.RowID as Key,
	|
	|	- Reg.InvoiceAmount as Amount,
	|	
	|	-(Reg.InvoiceAmount 
	|	+ Reg.InvoiceTaxAmount) as AmountWithTaxes
	|into revenues
	|FROM
	|	InformationRegister.T6095S_WriteOffBatchesInfo AS Reg
	|WHERE
	|	Reg.Recorder = &Recorder
	|	AND Reg.AmountCorrectionType = VALUE(enum.AmountCorrectionTypes.Revenue)
	|;
	|select * from revenues totals by Document";

	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
					
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		
		ArrayForSaveRecords = New Array();
		RecordSet.Read();
		For Each Record In RecordSet Do
			If Not ValueIsFilled(Record.CalculationMovementCost) Then
				ArrayForSaveRecords.Add(Record);
			EndIf;
		EndDo;
		RecordSet.Clear();
		
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRecord = RecordSet.Add();
			FillPropertyValues(NewRecord, QuerySelectionDetails);
			NewRecord.Recorder = QuerySelection.Document;
			NewRecord.Period   = QuerySelectionDetails.Period;
			NewRecord.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		
		Parameters = New Structure();
		Parameters.Insert("Object", QuerySelection.Document);
		Parameters.Insert("PostingByRef", True);
		Parameters.Insert("Metadata", QuerySelection.Document.Metadata());
		Parameters.Insert("PostingDataTables", New Map());
		
		RecordsTable = RecordSet.Unload();
		RecordsTable.Columns.Delete("PointIntime");
		
		RegMetadata = Metadata.AccumulationRegisters.R5021T_Revenues;
		PostingServer.SetPostingDataTable(Parameters.PostingDataTables, Parameters, RegMetadata.Name, RecordsTable);
		Parameters.PostingDataTables[RegMetadata].WriteInTransaction = False;
	
		CurrenciesTableParams = New Structure();
		CurrenciesTableParams.Insert("Ref"            , Parameters.Object);
		CurrenciesTableParams.Insert("Date"           , Parameters.Object.Date);
		CurrenciesTableParams.Insert("Company"        , Parameters.Object.Company);
		CurrenciesTableParams.Insert("Currency"       , Parameters.Object.Company.LandedCostCurrencyMovementType.Currency);
		CurrenciesTableParams.Insert("Agreement"      , Undefined);
		CurrenciesTableParams.Insert("RowKey"         , "");
		CurrenciesTableParams.Insert("DocumentAmount" , 0);
		CurrenciesTableParams.Insert("Currencies"     , New Array());
		
		CurrenciesTable = Parameters.Object.Currencies.UnloadColumns();
		CurrenciesServer.UpdateCurrencyTable(CurrenciesTableParams, CurrenciesTable);
		CurrenciesServer.PreparePostingDataTables(Parameters, CurrenciesTable);
		CurrenciesServer.ExcludePostingDataTable(Parameters, RegMetadata);
		
		RecordSet.Load(Parameters.PostingDataTables[RegMetadata].PrepareTable);
		For Each Record In ArrayForSaveRecords Do
			FillPropertyValues(RecordSet.Add(), Record);
		EndDo;
		RecordSet.Write();
	EndDo;
EndProcedure

#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure