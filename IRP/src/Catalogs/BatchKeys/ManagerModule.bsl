
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Batch");
	Fields.Add("ItemKey");
	Fields.Add("Store");
EndProcedure

// Presentation get processing.
// 
// Parameters:
//  Data - Structure - Data:
//  * ItemKey - CatalogRef.ItemKeys
//  * Store - CatalogRef.Stores
//  Presentation - String - Presentation
//  StandardProcessing - Boolean - Standard processing
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.ItemKey) + " - " + String(Data.Store);
EndProcedure

// Create batch keys.
// 
// Parameters:
//  CalculationSettings - See LandedCostServer.GetCalculationSettings
Procedure Create_BatchKeys(CalculationSettings) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	T6020S_BatchKeysInfo.Store,
	|	T6020S_BatchKeysInfo.ItemKey
	|INTO tmp
	|FROM
	|	InformationRegister.T6020S_BatchKeysInfo AS T6020S_BatchKeysInfo
	|WHERE
	|	case
	|		when &FilterByCompany
	|			then T6020S_BatchKeysInfo.Company = &Company
	|		else true
	|	end
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
	Query.SetParameter("FilterByCompany", ValueIsFilled(CalculationSettings.Company));
	Query.SetParameter("Company", CalculationSettings.Company);
	Query.SetParameter("BeginPeriod", CalculationSettings.BeginPeriod);
	Query.SetParameter("EndPeriod", CalculationSettings.EndPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		NewBatchKey = CreateItem();
		NewBatchKey.ItemKey = QuerySelection.ItemKey;
		NewBatchKey.Store = QuerySelection.Store;
		NewBatchKey.Write();
	EndDo;
EndProcedure
