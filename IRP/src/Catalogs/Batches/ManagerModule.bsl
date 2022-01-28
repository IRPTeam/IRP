
Procedure PresentationFieldsGetProcessing(Fields, StandardProcessing)
	StandardProcessing = False;
	Fields.Add("Document");
EndProcedure

Procedure PresentationGetProcessing(Data, Presentation, StandardProcessing)
	StandardProcessing = False;
	Presentation = String(Data.Document);
EndProcedure

Procedure Create_Batches(Company, BeginPeriod, EndPeriod) Export
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
	|	T6010S_BatchesInfo.Company = &Company
	|	AND T6010S_BatchesInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|;
	|
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
	Query.SetParameter("Company", Company);
	Query.SetParameter("BeginPeriod", BeginPeriod);
	Query.SetParameter("EndPeriod", EndPeriod);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		If ValueIsFilled(QuerySelection.Ref) Then 
			If QuerySelection.Date <> QuerySelection.OldDate Then
				ObjBatch = QuerySelection.Ref.GetObject();
				ObjBatch.Date = QuerySelection.Date;
				ObjBatch.Write();
			EndIf;
		Else
			NewBatch = Catalogs.Batches.CreateItem();
			NewBatch.Document = QuerySelection.Document;
			NewBatch.Company = QuerySelection.Company;
			NewBatch.Date = QuerySelection.Date;
			NewBatch.Write();
		EndIf;
	EndDo;
EndProcedure