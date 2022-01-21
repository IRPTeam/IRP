
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Batch");
	Fields.Add("ItemKey");
	Fields.Add("Store");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.ItemKey)+" - "+String(Data.Store);
EndProcedure

Procedure Create_BatchKeys(Company, BeginPeriod, EndPeriod) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|INTO tmp
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	T6020S_BatchKeysInfo.Company = &Company
	|	AND T6020S_BatchKeysInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|GROUP BY
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Store,
	|	tmp.ItemKey
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.BatchKeys AS BatchKeys
	|		ON tmp.Store = BatchKeys.Store
	|		AND tmp.ItemKey = BatchKeys.ItemKey
	|		AND NOT BatchKeys.DeletionMark
	|WHERE
	|	BatchKeys.Ref IS NULL";
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewBatchKey = Catalogs.BatchKeys.CreateItem();
		NewBatchKey.ItemKey = QuerySelection.ItemKey;
		NewBatchKey.Store = QuerySelection.Store;
		NewBatchKey.Write();
	EndDo;
EndProcedure