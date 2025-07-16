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

Function GetLockFieldNames() Export
	Return "Company, Store, ItemKey";
EndFunction

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4050B_StockInventory", True) Then
		Return True;
	EndIf;
	
	Query = New Query();
	Query.TempTablesManager = PostingServer.PrepareRecordsTables(GetLockFieldNames(), "ItemKey", ItemList_InDocument,
		Records_InDocument, Records_Exists, Unposting, AddInfo);
	Query.Text =
	"SELECT
	|	ItemList.ItemKey.Item AS Item,
	|	ItemList.ItemKey,
	|	RegisterBalance.Company,
	|	RegisterBalance.Store,
	|	RegisterBalance.ItemKey,
	|	RegisterBalance.QuantityBalance 
	|		+ RegisterBalance.PreliminaryQuantityBalance AS QuantityBalance,
	|	ItemList.Quantity,
	|	- (RegisterBalance.QuantityBalance 
	|		+ RegisterBalance.PreliminaryQuantityBalance) AS LackOfBalance,
	|	ItemList.LineNumber AS LineNumber,
	|	&Unposting AS Unposting
	|FROM
	|	ItemList AS ItemList
	|		INNER JOIN AccumulationRegister.R4050B_StockInventory.Balance(, (Company, Store, ItemKey) IN
	|			(SELECT
	|				ItemList.Company,
	|				ItemList.Store,
	|				ItemList.ItemKey
	|				
	|			FROM
	|				ItemList AS ItemList)) AS RegisterBalance
	|		ON RegisterBalance.Company = ItemList.Company
	|		AND RegisterBalance.Store = ItemList.Store
	|		AND RegisterBalance.ItemKey = ItemList.ItemKey
	|		AND ItemList.Store.NegativeStockControl
	|		
	|WHERE
	|	(RegisterBalance.QuantityBalance
	|		+ RegisterBalance.PreliminaryQuantityBalance) < 0
	|ORDER BY
	|	LineNumber";
	Query.SetParameter("Unposting", Unposting);
	QueryResult = Query.Execute();
	QueryTable = QueryResult.Unload();

	Error = False;
	If QueryTable.Count() Then
		Error = True;
		ErrorParameters = New Structure();
		ErrorParameters.Insert("GroupColumns", "Company, Store, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("SumColumns", "Quantity");
		ErrorParameters.Insert("FilterColumns", "Company, Store, ItemKey, Item, LackOfBalance");
		ErrorParameters.Insert("Operation", "Stock inventory");
		ErrorParameters.Insert("RecordType", RecordType);
		PostingServer.ShowPostingErrorMessage(QueryTable, ErrorParameters, AddInfo);
	EndIf;
	Return Not Error;	
EndFunction