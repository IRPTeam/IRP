
Procedure CheckContent(Segment) Export
	
	Query = New Query;
	Query.SetParameter("Segment", Segment);
	Query.Text =
	"SELECT
	|	ItemKeySegments.Segment,
	|	ItemKeySegments.ItemKey,
	|	ItemKeySegments.Item
	|FROM
	|	InformationRegister.ItemSegments AS ItemKeySegments
	|		INNER JOIN InformationRegister.ItemSegments AS ItemSegments
	|		ON ItemKeySegments.Segment = ItemSegments.Segment
	|		AND ItemKeySegments.Item = ItemSegments.Item
	|		AND ItemSegments.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
	|WHERE
	|	ItemKeySegments.Segment = &Segment
	|	AND ItemKeySegments.ItemKey <> VALUE(Catalog.ItemKeys.EmptyRef)";
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Record = InformationRegisters.ItemSegments.CreateRecordManager();
		FillPropertyValues(Record, QuerySelection);
		Record.Delete();
	EndDo;	
	
	Query.Text =
	"SELECT
	|	ItemSegments.Segment,
	|	ItemSegments.ItemKey,
	|	ItemSegments.ItemKey.Item
	|FROM
	|	InformationRegister.ItemSegments AS ItemSegments
	|WHERE
	|	ItemSegments.Segment = &Segment
	|	AND ItemSegments.ItemKey <> VALUE(Catalog.ItemKeys.EmptyRef)
	|	AND ItemSegments.Item = VALUE(Catalog.Items.EmptyRef)";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		RecordSet = InformationRegisters.ItemSegments.CreateRecordSet();
		RecordSet.Filter.Segment = QuerySelection.Segment;
		RecordSet.Filter.ItemKey = QuerySelection.ItemKey;
		
		RecordRow = RecordSet.Add();
		FillPropertyValues(RecordRow, QuerySelection);
		Record.Write(True);
	EndDo;
	
EndProcedure