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
	|	T6095S_WriteOffBatchesInfo.Period AS Period,
	|	T6095S_WriteOffBatchesInfo.Recorder AS CalculationMovementCosts,
	|	T6095S_WriteOffBatchesInfo.Document AS Document,
	|	T6095S_WriteOffBatchesInfo.Company AS Company,
	|	T6095S_WriteOffBatchesInfo.Branch AS Branch,
	|	T6095S_WriteOffBatchesInfo.ProfitLossCenter AS ProfitLossCenter,
	|	T6095S_WriteOffBatchesInfo.ExpenseType AS ExpenseType,
	|	T6095S_WriteOffBatchesInfo.ItemKey AS ItemKey,
	|	T6095S_WriteOffBatchesInfo.Currency AS Currency,
	|	T6095S_WriteOffBatchesInfo.RowID AS Key,
	|	T6095S_WriteOffBatchesInfo.InvoiceAmount
	|	+T6095S_WriteOffBatchesInfo.IndirectCostAmount
	|	+T6095S_WriteOffBatchesInfo.ExtraCostAmountByRatio
	|	+T6095S_WriteOffBatchesInfo.ExtraDirectCostAmount
	|	+T6095S_WriteOffBatchesInfo.AllocatedCostAmount
	|	-T6095S_WriteOffBatchesInfo.AllocatedRevenueAmount AS Amount,
	|
	|	T6095S_WriteOffBatchesInfo.InvoiceAmount
	|	+T6095S_WriteOffBatchesInfo.InvoiceTaxAmount
	|	+T6095S_WriteOffBatchesInfo.IndirectCostAmount
	|	+T6095S_WriteOffBatchesInfo.IndirectCostTaxAmount
	|	+T6095S_WriteOffBatchesInfo.ExtraCostAmountByRatio
	|	+T6095S_WriteOffBatchesInfo.ExtraCostTaxAmountByRatio
	|	+T6095S_WriteOffBatchesInfo.ExtraDirectCostAmount
	|	+T6095S_WriteOffBatchesInfo.ExtraDirectCostTaxAmount
	|	+T6095S_WriteOffBatchesInfo.AllocatedCostAmount
	|	+T6095S_WriteOffBatchesInfo.AllocatedCostTaxAmount
	|	-T6095S_WriteOffBatchesInfo.AllocatedRevenueAmount
	|	-T6095S_WriteOffBatchesInfo.AllocatedRevenueTaxAmount AS AmountWithTaxes
	|FROM
	|	InformationRegister.T6095S_WriteOffBatchesInfo AS T6095S_WriteOffBatchesInfo
	|WHERE
	|	T6095S_WriteOffBatchesInfo.Recorder = &Recorder
	|TOTALS
	|BY
	|	Document";

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