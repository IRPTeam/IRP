Procedure StockInventory_Clear(DocObjectRef, Cancel) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	R4050B_StockInventory.Recorder
	|FROM
	|	AccumulationRegister.R4050B_StockInventory AS R4050B_StockInventory
	|WHERE
	|	R4050B_StockInventory.CalculationMovementCost = &CalculationMovementCost
	|GROUP BY
	|	R4050B_StockInventory.Recorder";
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

Procedure StockInventory_LoadRecords(CalculationMovementCostRef) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	CASE
	|		WHEN T4050_StockInventoryInfo.Direction = VALUE(enum.BatchDirection.Expense)
	|			THEN value(AccumulationRecordType.Expense)
	|		ELSE value(AccumulationRecordType.Receipt)
	|	END AS RecordType,
	|	T4050_StockInventoryInfo.Period AS Period,
	|	T4050_StockInventoryInfo.Recorder AS CalculationMovementCosts,
	|	T4050_StockInventoryInfo.Document AS Document,
	|	T4050_StockInventoryInfo.Company AS Company,
	|	T4050_StockInventoryInfo.Store AS Store,
	|	T4050_StockInventoryInfo.ItemKey AS ItemKey,
	|	T4050_StockInventoryInfo.Quantity AS Quantity,
	|	T4050_StockInventoryInfo.PreliminaryQuantity AS PreliminaryQuantity
	|FROM
	|	InformationRegister.T4050_StockInventoryInfo AS T4050_StockInventoryInfo
	|WHERE
	|	T4050_StockInventoryInfo.Recorder = &Recorder
	|TOTALS
	|BY
	|	Document";

	Query.SetParameter("Recorder", CalculationMovementCostRef);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select(QueryResultIteration.ByGroups);
	While QuerySelection.Next() Do
		
		RecordSet = CreateRecordSet();
		RecordSet.Filter.Recorder.Set(QuerySelection.Document);
		RecordSet.Read();
		
		Records = RecordSet.Unload();
		Records.Columns.Delete(Records.Columns.PointInTime);
		
		QuerySelectionDetails = QuerySelection.Select();
		While QuerySelectionDetails.Next() Do
			NewRow = Records.Add();
			FillPropertyValues(NewRow, QuerySelectionDetails);
			NewRow.Active = True;
			NewRow.Recorder = QuerySelection.Document;
			NewRow.Period   = QuerySelectionDetails.Period;
			NewRow.CalculationMovementCost = QuerySelectionDetails.CalculationMovementCosts;
		EndDo;
		RecordSet.Load(Records);
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
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
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

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4050B_StockInventory") Then
		Return True;
	EndIf;

	Tables = New Structure();
	Tables.Insert("ItemList_InDocument", ItemList_InDocument);
	Tables.Insert("Records_InDocument", Records_InDocument);
	Tables.Insert("Records_Exists", Records_Exists);

	Return PostingServer.CheckBalance_R4050B_StockInventory(Ref, Tables, RecordType, Unposting, AddInfo);
EndFunction