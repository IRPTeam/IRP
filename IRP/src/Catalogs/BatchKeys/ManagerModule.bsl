
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
	|	LC_BatchKeysInfo.Store,
	|	LC_BatchKeysInfo.ItemKey
	|INTO tmp
	|FROM
	|	InformationRegister.LC_BatchKeysInfo AS LC_BatchKeysInfo
	|WHERE
	|	LC_BatchKeysInfo.Company = &Company
	|	AND LC_BatchKeysInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|GROUP BY
	|	LC_BatchKeysInfo.Store,
	|	LC_BatchKeysInfo.ItemKey
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Store,
	|	tmp.ItemKey
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.LC_BatchKeys AS LC_BatchKeys
	|		ON tmp.Store = LC_BatchKeys.Store
	|		AND tmp.ItemKey = LC_BatchKeys.ItemKey
	|		AND
	|		NOT LC_BatchKeys.DeletionMark
	|WHERE
	|	LC_BatchKeys.Ref IS NULL";
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewBatchKey = Catalogs.LC_BatchKeys.CreateItem();
		NewBatchKey.ItemKey = QuerySelection.ItemKey;
		NewBatchKey.Store = QuerySelection.Store;
		NewBatchKey.Write();
	EndDo;
EndProcedure