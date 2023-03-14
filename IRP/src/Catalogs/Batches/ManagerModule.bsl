
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Document");
EndProcedure

// Presentation get processing.
// 
// Parameters:
//  Data - Structure - Data:
//  * Document - See Catalog.Batches.Document
//  Presentation - String - Presentation
//  StandardProcessing - Boolean - Standard processing
Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.Document);
EndProcedure

// Create batches.
// 
// Parameters:
//  CalculationSettings - See LandedCostServer.GetCalculationSettings
// 
Procedure Create_Batches(CalculationSettings) Export
	Query = New Query;
	Query.Text =
	"SELECT
	|	T6010S_BatchesInfo.Company,
	|	T6010S_BatchesInfo.Document,
	|	T6010S_BatchesInfo.Period AS Date
	|INTO tmp
	|FROM
	|	InformationRegister.T6010S_BatchesInfo AS T6010S_BatchesInfo
	|WHERE
	|	case
	|		when &FilterByCompany
	|			then T6010S_BatchesInfo.Company = &Company
	|		else True
	|	end
	|	AND T6010S_BatchesInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|
	|union all
	|
	|select
	|	ReallocateIncoming.Company,
	|	ReallocateIncoming.Ref,
	|	ReallocateIncoming.Date
	|from
	|	Document.BatchReallocateIncoming as ReallocateIncoming
	|where
	|	ReallocateIncoming.BatchReallocate = &CalculationMovementCostRef
	|	AND NOT (ReallocateIncoming.Date BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Document,
	|	tmp.Date,
	|	Batches.Ref AS Ref,
	|	Batches.Date AS OldDate
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.Batches AS Batches
	|		ON tmp.Company = Batches.Company
	|		AND tmp.Document = Batches.Document
	|		AND NOT Batches.DeletionMark
	|WHERE
	|	Batches.Ref IS NULL
	|	OR Batches.Date <> tmp.Date";
	Query.SetParameter("FilterByCompany", ValueIsFilled(CalculationSettings.Company));
	Query.SetParameter("CalculationMovementCostRef", CalculationSettings.CalculationMovementCostRef);
	Query.SetParameter("Company", CalculationSettings.Company);
	Query.SetParameter("BeginPeriod", CalculationSettings.BeginPeriod);
	Query.SetParameter("EndPeriod", CalculationSettings.EndPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.Ref) Then 
			If QuerySelection.Date <> QuerySelection.OldDate Then
				BatchRef = QuerySelection.Ref; // CatalogRef.Batches
				ObjBatch = BatchRef.GetObject();
				ObjBatch.Date = QuerySelection.Date; // Date
				ObjBatch.Write();
			EndIf;
		Else
			NewBatch = CreateItem();
			NewBatch.Document = QuerySelection.Document;
			NewBatch.Company = QuerySelection.Company;
			NewBatch.Date = QuerySelection.Date;
			NewBatch.Write();
		EndIf;
	EndDo;
EndProcedure
