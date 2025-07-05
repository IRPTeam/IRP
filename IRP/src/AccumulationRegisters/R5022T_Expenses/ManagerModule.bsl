Procedure Expenses_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R5022T_Expenses.Recorder
	|FROM
	|	AccumulationRegister.R5022T_Expenses AS R5022T_Expenses
	|WHERE
	|	R5022T_Expenses.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R5022T_Expenses.Recorder";
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

Procedure Expenses_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	Reg.Period AS Period,
	|	Reg.Recorder AS CalculationMovementCosts,
	|	Reg.Document AS Document,
	|	Reg.Company AS Company,
	|	Reg.Branch AS Branch,
	|	Reg.ProfitLossCenter AS ProfitLossCenter,
	|	Reg.ExpenseType AS ExpenseType,
	|	Reg.ItemKey AS ItemKey,
	|	Reg.Currency AS Currency,
	|	Reg.RowID AS Key,
	|
	|	Reg.InvoiceAmount 
	|	+ Reg.PreliminaryAmount 
	|	+ Reg.IndirectCostAmount 
	|	+ Reg.ExtraCostAmountByRatio 
	|	+ Reg.ExtraDirectCostAmount 
	|	+ Reg.AllocatedCostAmount 
	|	- Reg.AllocatedRevenueAmount AS Amount,
	|	
	|	Reg.InvoiceAmount 
	|	+ Reg.PreliminaryAmount 
	|	+ Reg.InvoiceTaxAmount 
	|	+ Reg.PreliminaryTaxAmount 
	|	+ Reg.IndirectCostAmount
	|	+ Reg.IndirectCostTaxAmount 
	|	+ Reg.ExtraCostAmountByRatio 
	|	+ Reg.ExtraCostTaxAmountByRatio 
	|	+ Reg.ExtraDirectCostAmount
	|	+ Reg.ExtraDirectCostTaxAmount 
	|	+ Reg.AllocatedCostAmount 
	|	+ Reg.AllocatedCostTaxAmount 
	|	- Reg.AllocatedRevenueAmount 
	|	- Reg.AllocatedRevenueTaxAmount AS AmountWithTaxes
	|into expenses
	|FROM
	|	InformationRegister.T6095S_WriteOffBatchesInfo AS Reg
	|WHERE
	|	Reg.Recorder = &Recorder
	|	AND Reg.AmountCorrectionType = VALUE(enum.AmountCorrectionTypes.EmptyRef)
	|
	|union all
	|
	|SELECT
	|	Reg.Period,
	|	Reg.Recorder,
	|	Reg.Document,
	|	Reg.Company,
	|	Reg.Branch,
	|	Reg.ProfitLossCenter,
	|	Reg.CorrectionExpenseRevenueType,
	|	Reg.ItemKey,
	|	Reg.Currency,
	|	"""",  //|	Reg.RowID,
	|
	|	Reg.InvoiceAmount,
	|	
	|	Reg.InvoiceAmount 
	|	+ Reg.InvoiceTaxAmount
	|
	|FROM
	|	InformationRegister.T6095S_WriteOffBatchesInfo AS Reg
	|WHERE
	|	Reg.Recorder = &Recorder
	|	AND Reg.AmountCorrectionType = VALUE(enum.AmountCorrectionTypes.Expense)
	|;
	|select * from expenses totals by Document";

	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		
		ExpenseTable = RecordSet.Unload();
		ExpenseTable.Columns.Delete(ExpenseTable.Columns.PointInTime);
		ExpenseTable.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRow = ExpenseTable.Add();
			FillPropertyValues(NewRow, QuerySelectionDetails);
			NewRow.Recorder = QuerySelection.Document;
			NewRow.Period   = QuerySelectionDetails.Period;
			NewRow.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
	
		// Currency calculation
		
		CurrenciesParameters = New Structure();

		PostingDataTables = New Map();
		
		ExpenseTableSettings = PostingServer.PostingTableSettings(ExpenseTable, RecordSet);
		PostingDataTables.Insert(RecordSet.Metadata(), ExpenseTableSettings);
		
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		CurrenciesParameters.Insert("Object", QuerySelection.Document);
		CurrenciesParameters.Insert("Metadata", QuerySelection.Document.Metadata());
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);

		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.R5022T_Expenses Then
				RecordSet.Read();
				For Each RowPostingInfo In ItemOfPostingInfo.Value.PrepareTable Do
					FillPropertyValues(RecordSet.Add(), RowPostingInfo);
				EndDo;
				RecordSet.SetActive(True);
				RecordSet.Write();
			EndIf;			
		EndDo;
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