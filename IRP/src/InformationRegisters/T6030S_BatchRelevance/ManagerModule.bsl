
Procedure BatchRelevance_SetBound(DocObject, TableForLoad) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	tmp.Company AS Company,
	|	tmp.Store AS Store,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.Period AS Date,
	|	tmp.Quantity AS Quantity,
	|	tmp.Amount AS Amount,
	|	tmp.BatchDocument AS BatchDocument
	|INTO TableForLoad
	|FROM
	|	&TableForLoad AS tmp
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TableForLoad.Company,
	|	TableForLoad.Store,
	|	TableForLoad.ItemKey,
	|	SUM(TableForLoad.Quantity) AS Quantity,
	|	TableForLoad.Date,
	|	SUM(TableForLoad.Amount) AS Amount,
	|	TableForLoad.BatchDocument
	|INTO TableForLoadGrouped
	|FROM
	|	TableForLoad AS TableForLoad
	|GROUP BY
	|	TableForLoad.Company,
	|	TableForLoad.Store,
	|	TableForLoad.ItemKey,
	|	TableForLoad.Date,
	|	TableForLoad.BatchDocument
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchKeysInfo.Company,
	|	LC_BatchKeysInfo.Store,
	|	LC_BatchKeysInfo.ItemKey,
	|	SUM(LC_BatchKeysInfo.Quantity) AS Quantity,
	|	LC_BatchKeysInfo.Period AS Date,
	|	SUM(LC_BatchKeysInfo.Amount) AS Amount,
	|	LC_BatchKeysInfo.BatchDocument AS BatchDocument
	|INTO TableFromRecordSetGrouped
	|FROM
	|	InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|WHERE
	|	LC_BatchKeysInfo.Recorder = &Recorder
	|GROUP BY
	|	LC_BatchKeysInfo.Company,
	|	LC_BatchKeysInfo.Store,
	|	LC_BatchKeysInfo.ItemKey,
	|	LC_BatchKeysInfo.Period,
	|	LC_BatchKeysInfo.BatchDocument
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TableForLoadGrouped.Company AS CompanyNew,
	|	TableForLoadGrouped.Store AS StoreNew,
	|	TableForLoadGrouped.ItemKey AS ItemKeyNew,
	|	TableForLoadGrouped.Date AS DateNew,
	|	TableFromRecordSetGrouped.Company AS CompanyOld,
	|	TableFromRecordSetGrouped.Store AS StoreOld,
	|	TableFromRecordSetGrouped.ItemKey AS ItemKeyOld,
	|	TableFromRecordSetGrouped.Date AS DateOld
	|INTO JoinedData
	|FROM
	|	TableForLoadGrouped AS TableForLoadGrouped
	|		FULL JOIN TableFromRecordSetGrouped AS TableFromRecordSetGrouped
	|		ON TableForLoadGrouped.Company = TableFromRecordSetGrouped.Company
	|		AND TableForLoadGrouped.Store = TableFromRecordSetGrouped.Store
	|		AND TableForLoadGrouped.ItemKey = TableFromRecordSetGrouped.ItemKey
	|		AND TableForLoadGrouped.Quantity = TableFromRecordSetGrouped.Quantity
	|		AND TableForLoadGrouped.Date = TableFromRecordSetGrouped.Date
	|		AND	TableForLoadGrouped.Amount = TableFromRecordSetGrouped.Amount
	|		AND TableForLoadGrouped.BatchDocument = TableFromRecordSetGrouped.BatchDocument
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	JoinedData.CompanyNew AS Company,
	|	JoinedData.StoreNew AS Store,
	|	JoinedData.ItemKeyNew AS ItemKey,
	|	JoinedData.DateNew AS Date
	|INTO ModifiedData
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.ItemKeyOld IS NULL
	|
	|UNION
	|
	|SELECT
	|	JoinedData.CompanyOld,
	|	JoinedData.StoreOld,
	|	JoinedData.ItemKeyOld,
	|	JoinedData.DateOld
	|FROM
	|	JoinedData AS JoinedData
	|WHERE
	|	JoinedData.ItemKeyNew IS NULL
	|;
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LC_BatchRelevance.Date AS DateOld,
	|	LC_BatchRelevance.Company AS CompanyOld,
	|	LC_BatchRelevance.Store AS StoreOld,
	|	LC_BatchRelevance.ItemKey AS ItemKeyOld,
	|	MIN(ModifiedData.Date) AS DateNew,
	|	ModifiedData.Company AS CompanyNew,
	|	ModifiedData.Store AS StoreNew,
	|	ModifiedData.ItemKey AS ItemKeyNew
	|FROM
	|	ModifiedData AS ModifiedData
	|		LEFT JOIN InformationRegister.LC_BatchRelevance AS LC_BatchRelevance
	|		ON ModifiedData.Company = LC_BatchRelevance.Company
	|		AND ModifiedData.Store = LC_BatchRelevance.Store
	|		AND ModifiedData.ItemKey = LC_BatchRelevance.ItemKey
	|GROUP BY
	|	LC_BatchRelevance.Date,
	|	LC_BatchRelevance.Company,
	|	LC_BatchRelevance.Store,
	|	LC_BatchRelevance.ItemKey,
	|	ModifiedData.Company,
	|	ModifiedData.Store,
	|	ModifiedData.ItemKey";

	Query.SetParameter("TableForLoad", TableForLoad);
	Query.SetParameter("Recorder", DocObject.Ref);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.DateOld) Then
			If GetPointInTime(QuerySelection.DateOld, QuerySelection.CompanyOld, QuerySelection.StoreOld,
				QuerySelection.ItemKeyOld).Compare(DocObject.PointInTime()) = 1 Then
				ClearRecordSet(QuerySelection.DateOld, QuerySelection.CompanyOld, QuerySelection.StoreOld,
					QuerySelection.ItemKeyOld);
				WriteRecordSet(DocObject.Ref, QuerySelection.DateNew, QuerySelection.CompanyNew, QuerySelection.StoreNew,
					QuerySelection.ItemKeyNew);
			Else
				SetIsRelevance(QuerySelection.DateOld, QuerySelection.CompanyOld,
					QuerySelection.StoreOld, QuerySelection.ItemKeyOld, DocObject.Ref);
			EndIf;
		Else //first registration
			WriteRecordSet(DocObject.Ref, QuerySelection.DateNew, QuerySelection.CompanyNew, QuerySelection.StoreNew,
				QuerySelection.ItemKeyNew);
		EndIf;
	EndDo;

EndProcedure

Procedure BatchRelevance_Restore(Company, EndPeriod) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	|	LC_BatchWiseBalance.Batch.Company AS Company,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.BatchKey.Store AS Store,
	|	LC_BatchWiseBalance.Document AS Document
	|INTO tmp
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Period <= ENDOFPERIOD(&EndPeriod, DAY)
	|	AND LC_BatchWiseBalance.Batch.Company = &Company
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageOutgoing.Period,
	|	LC_BatchShortageOutgoing.Company,
	|	LC_BatchShortageOutgoing.BatchKey.ItemKey,
	|	LC_BatchShortageOutgoing.BatchKey.Store,
	|	LC_BatchShortageOutgoing.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageOutgoing AS LC_BatchShortageOutgoing
	|WHERE
	|	LC_BatchShortageOutgoing.Period <= ENDOFPERIOD(&EndPeriod, DAY)
	|	AND LC_BatchShortageOutgoing.Company = &Company
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageIncoming.Period,
	|	LC_BatchShortageIncoming.Company,
	|	LC_BatchShortageIncoming.BatchKey.ItemKey,
	|	LC_BatchShortageIncoming.BatchKey.Store,
	|	LC_BatchShortageIncoming.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageIncoming AS LC_BatchShortageIncoming
	|WHERE
	|	LC_BatchShortageIncoming.Period <= ENDOFPERIOD(&EndPeriod, DAY)
	|	AND LC_BatchShortageIncoming.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(tmp.Period) AS Period,
	|	tmp.Company AS Company,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.Store AS Store
	|INTO tmp_Grouped
	|FROM
	|	tmp AS tmp
	|
	|GROUP BY
	|	tmp.Company,
	|	tmp.ItemKey,
	|	tmp.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_Grouped.Period AS Date,
	|	tmp_Grouped.Company AS Company,
	|	tmp_Grouped.ItemKey AS ItemKey,
	|	tmp_Grouped.Store AS Store,
	|	MAX(tmp.Document) AS Document
	|FROM
	|	tmp_Grouped AS tmp_Grouped
	|		LEFT JOIN tmp AS tmp
	|		ON tmp_Grouped.Period = tmp.Period
	|			AND tmp_Grouped.Company = tmp.Company
	|			AND tmp_Grouped.ItemKey = tmp.ItemKey
	|			AND tmp_Grouped.Store = tmp.Store
	|
	|GROUP BY
	|	tmp_Grouped.Period,
	|	tmp_Grouped.Company,
	|	tmp_Grouped.ItemKey,
	|	tmp_Grouped.Store";
	
	Query.SetParameter("EndPeriod", EndPeriod);
	Query.SetParameter("Company", Company);
	
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		WriteRecordSet(QuerySelection.Document, QuerySelection.Date, QuerySelection.Company, QuerySelection.Store, QuerySelection.ItemKey, True);
	EndDo;
EndProcedure

Procedure BatchRelevance_Reset(Company, BeginPeriod) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchWiseBalance.Period AS Period,
	|	LC_BatchWiseBalance.Batch.Company AS Company,
	|	LC_BatchWiseBalance.BatchKey.ItemKey AS ItemKey,
	|	LC_BatchWiseBalance.BatchKey.Store AS Store,
	|	LC_BatchWiseBalance.Document AS Document
	|INTO tmp
	|FROM
	|	AccumulationRegister.LC_BatchWiseBalance AS LC_BatchWiseBalance
	|WHERE
	|	LC_BatchWiseBalance.Period <= BEGINOFPERIOD(&BeginPeriod, DAY)
	|	AND LC_BatchWiseBalance.Batch.Company = &Company
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageOutgoing.Period,
	|	LC_BatchShortageOutgoing.Company,
	|	LC_BatchShortageOutgoing.BatchKey.ItemKey,
	|	LC_BatchShortageOutgoing.BatchKey.Store,
	|	LC_BatchShortageOutgoing.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageOutgoing AS LC_BatchShortageOutgoing
	|WHERE
	|	LC_BatchShortageOutgoing.Period <= BEGINOFPERIOD(&BeginPeriod, DAY)
	|	AND LC_BatchShortageOutgoing.Company = &Company
	|
	|UNION ALL
	|
	|SELECT
	|	LC_BatchShortageIncoming.Period,
	|	LC_BatchShortageIncoming.Company,
	|	LC_BatchShortageIncoming.BatchKey.ItemKey,
	|	LC_BatchShortageIncoming.BatchKey.Store,
	|	LC_BatchShortageIncoming.Document
	|FROM
	|	AccumulationRegister.LC_BatchShortageIncoming AS LC_BatchShortageIncoming
	|WHERE
	|	LC_BatchShortageIncoming.Period <= BEGINOFPERIOD(&BeginPeriod, DAY)
	|	AND LC_BatchShortageIncoming.Company = &Company
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	MAX(tmp.Period) AS Period,
	|	tmp.Company AS Company,
	|	tmp.ItemKey AS ItemKey,
	|	tmp.Store AS Store
	|INTO tmp_Grouped
	|FROM
	|	tmp AS tmp
	|
	|GROUP BY
	|	tmp.Company,
	|	tmp.ItemKey,
	|	tmp.Store
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp_Grouped.Period AS Date,
	|	tmp_Grouped.Company AS Company,
	|	tmp_Grouped.ItemKey AS ItemKey,
	|	tmp_Grouped.Store AS Store,
	|	MAX(tmp.Document) AS Document
	|FROM
	|	tmp_Grouped AS tmp_Grouped
	|		LEFT JOIN tmp AS tmp
	|		ON tmp_Grouped.Period = tmp.Period
	|			AND tmp_Grouped.Company = tmp.Company
	|			AND tmp_Grouped.ItemKey = tmp.ItemKey
	|			AND tmp_Grouped.Store = tmp.Store
	|
	|GROUP BY
	|	tmp_Grouped.Period,
	|	tmp_Grouped.Company,
	|	tmp_Grouped.ItemKey,
	|	tmp_Grouped.Store";
	
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		WriteRecordSet(QuerySelection.Document, QuerySelection.Date, QuerySelection.Company, QuerySelection.Store, QuerySelection.ItemKey, False, False);
	EndDo;
EndProcedure

Procedure BatchRelevance_Clear(Company, EndPeriod) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchRelevance.Date,
	|	LC_BatchRelevance.Company,
	|	LC_BatchRelevance.Store,
	|	LC_BatchRelevance.ItemKey
	|FROM
	|	InformationRegister.LC_BatchRelevance AS LC_BatchRelevance
	|WHERE
	|	LC_BatchRelevance.Company = &Company
	|	AND LC_BatchRelevance.Date <= ENDOFPERIOD(&EndPeriod, DAY)";
	Query.SetParameter("Company", Company);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResults = Query.Execute();
	QuerySelection = QueryResults.Select();
	While QuerySelection.Next() Do
		ClearRecordSet(QuerySelection.Date, QuerySelection.Company, QuerySelection.Store, QuerySelection.ItemKey);
	EndDo;
EndProcedure

Function GetPointInTime(Date, Company, Store, ItemKey)
	Query = New Query;
	Query.Text =
	"SELECT
	|	LC_BatchRelevance.Document.PointInTime AS PointInTime
	|FROM
	|	InformationRegister.LC_BatchRelevance AS LC_BatchRelevance
	|WHERE
	|	LC_BatchRelevance.Date = &Date
	|	AND 
	|	LC_BatchRelevance.Company = &Company
	|	AND LC_BatchRelevance.Store = &Store
	|	AND LC_BatchRelevance.ItemKey = &ItemKey";
	Query.SetParameter("Date", Date);
	Query.SetParameter("Company", Company);
	Query.SetParameter("Store", Store);
	Query.SetParameter("ItemKey", ItemKey);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.PointInTime;
	Else
		Raise "Can not get point in time";
	EndIf;
EndFunction

Procedure SetIsRelevance(Date, Company, Store, ItemKey, DocRef)
	RecordSet = InformationRegisters.LC_BatchRelevance.CreateRecordSet();
	RecordSet.Filter.Date.Set(Date);
	RecordSet.Filter.Company.Set(Company);
	RecordSet.Filter.Store.Set(Store);
	RecordSet.Filter.ItemKey.Set(ItemKey);
	RecordSet.Read();
	For Each Row In RecordSet Do
		If Row.Document = DocRef Then
			Row.IsRelevance = False;
		EndIf;
	EndDo;
	RecordSet.Write();
EndProcedure

Procedure ClearRecordSet(Date, Company, Store, ItemKey)
	RecordSet = InformationRegisters.LC_BatchRelevance.CreateRecordSet();
	RecordSet.Filter.Date.Set(Date);
	RecordSet.Filter.Company.Set(Company);
	RecordSet.Filter.Store.Set(Store);
	RecordSet.Filter.ItemKey.Set(ItemKey);
	RecordSet.Clear();
	RecordSet.Write();
EndProcedure

Procedure WriteRecordSet(DocumentRef, Date, Company, Store, ItemKey, IsRelevance = False, FilterByDate = True)
	RecordSet = InformationRegisters.LC_BatchRelevance.CreateRecordSet();
	If FilterByDate Then
		RecordSet.Filter.Date.Set(Date);
	EndIf;
	RecordSet.Filter.Company.Set(Company);
	RecordSet.Filter.Store.Set(Store);
	RecordSet.Filter.ItemKey.Set(ItemKey);
	NewRecord = RecordSet.Add();
	NewRecord.Date = Date;
	NewRecord.Company = Company;
	NewRecord.Store = Store;
	NewRecord.ItemKey = ItemKey;
	NewRecord.Document = DocumentRef;
	NewRecord.IsRelevance = IsRelevance;
	RecordSet.Write();
EndProcedure
