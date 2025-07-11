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
		
		RevenueTable = RecordSet.Unload();
		RevenueTable.Columns.Delete(RevenueTable.Columns.PointInTime);
		RevenueTable.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRow = RevenueTable.Add();
			FillPropertyValues(NewRow, QuerySelectionDetails);
			NewRow.Recorder = QuerySelection.Document;
			NewRow.Period   = QuerySelectionDetails.Period;
			NewRow.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
	
		// Currency calculation
		
		CurrenciesParameters = New Structure();

		PostingDataTables = New Map();
		
		RevenueTableSettings = PostingServer.PostingTableSettings(RevenueTable, RecordSet);
		PostingDataTables.Insert(RecordSet.Metadata(), RevenueTableSettings);
		
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		CurrenciesParameters.Insert("Object", QuerySelection.Document);
		CurrenciesParameters.Insert("Metadata", QuerySelection.Document.Metadata());
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);

		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.R5021T_Revenues Then
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