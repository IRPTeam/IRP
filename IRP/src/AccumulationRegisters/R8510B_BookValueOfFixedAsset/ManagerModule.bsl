
Procedure BookValueOfFixedAsset_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R8510B_BookValueOfFixedAsset.Recorder
	|FROM
	|	AccumulationRegister.R8510B_BookValueOfFixedAsset AS R8510B_BookValueOfFixedAsset
	|WHERE
	|	R8510B_BookValueOfFixedAsset.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R8510B_BookValueOfFixedAsset.Recorder";
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

Procedure BookValueOfFixedAsset_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	*,
	|	&Currency AS Currency,
	|	VALUE(AccumulationRecordType.Receipt) AS RecordType,
	|	T8510S_FixedAssetsInfo.Recorder AS CalculationMovementCosts
	|FROM
	|	InformationRegister.T8510S_FixedAssetsInfo AS T8510S_FixedAssetsInfo
	|WHERE
	|	T8510S_FixedAssetsInfo.Recorder = &Recorder
	|TOTALS
	|BY
	|	Document";
	Query.SetParameter("Recorder", CalculationMovementCostRef);
	Query.SetParameter("Currency", CurrenciesServer.GetLandedCostCurrency(CalculationMovementCostRef.Company));
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		
		BookValueTable = RecordSet.Unload();
		BookValueTable.Columns.Delete(BookValueTable.Columns.PointInTime);
		BookValueTable.Columns.Add("Key", Metadata.DefinedTypes.typeRowID.Type);
		
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRow = BookValueTable.Add();
			FillPropertyValues(NewRow, QuerySelectionDetails);
			NewRow.Recorder = QuerySelection.Document;
			NewRow.Period = QuerySelectionDetails.Period;
			NewRow.RecordType = QuerySelectionDetails.RecordType;
			NewRow.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		
		// Currency calculation
		
		CurrenciesParameters = New Structure();

		PostingDataTables = New Map();
		
		BookValueTableSettings = PostingServer.PostingTableSettings(BookValueTable, RecordSet);
		PostingDataTables.Insert(RecordSet.Metadata(), BookValueTableSettings);
		
		ArrayOfPostingInfo = New Array();
		For Each DataTable In PostingDataTables Do
			ArrayOfPostingInfo.Add(DataTable);
		EndDo;
		CurrenciesParameters.Insert("Object", QuerySelection.Document);
		CurrenciesParameters.Insert("Metadata", QuerySelection.Document.Metadata());
		CurrenciesParameters.Insert("ArrayOfPostingInfo", ArrayOfPostingInfo);
		CurrenciesServer.PreparePostingDataTables(CurrenciesParameters, Undefined);

		For Each ItemOfPostingInfo In ArrayOfPostingInfo Do
			If ItemOfPostingInfo.Key = Metadata.AccumulationRegisters.R8510B_BookValueOfFixedAsset Then
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