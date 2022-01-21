
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
	|	LC_BatchesInfo.Company,
	|	LC_BatchesInfo.Document,
	|	LC_BatchesInfo.Period AS Date
	|INTO tmp
	|FROM
	|	InformationRegister.LC_BatchesInfo AS LC_BatchesInfo
	|WHERE
	|	LC_BatchesInfo.Company = &Company
	|	AND LC_BatchesInfo.Period BETWEEN BEGINOFPERIOD(&BeginPeriod, DAY) AND ENDOFPERIOD(&EndPeriod, DAY)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	tmp.Company,
	|	tmp.Document,
	|	tmp.Date,
	|	LC_Batches.Ref AS Ref,
	|	LC_Batches.Date AS OldDate
	|FROM
	|	tmp AS tmp
	|		LEFT JOIN Catalog.LC_Batches AS LC_Batches
	|		ON tmp.Company = LC_Batches.Company
	|		AND tmp.Document = LC_Batches.Document
	|		AND NOT LC_Batches.DeletionMark
	|WHERE
	|	LC_Batches.Ref IS NULL
	|	OR LC_Batches.Date <> tmp.Date";
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
			NewBatch = Catalogs.LC_Batches.CreateItem();
			NewBatch.Document = QuerySelection.Document;
			NewBatch.Company = QuerySelection.Company;
			NewBatch.Date = QuerySelection.Date;
			NewBatch.Write();
		EndIf;
	EndDo;
EndProcedure