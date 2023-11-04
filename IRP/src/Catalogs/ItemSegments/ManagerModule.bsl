
Procedure SaveItemsToSegment(Segment, ItemRefs) Export
	
	Query = New Query;
	Query.SetParameter("Refs", ItemRefs);
	Query.SetParameter("Segment", Segment);
	
	If ItemRefs.Count() > 0 And TypeOf(ItemRefs[0]) = Type("CatalogRef.ItemKeys") Then
		Query.Text =
		"SELECT
		|	&Segment,
		|	ItemKeys.Ref AS ItemKey,
		|	ItemKeys.Item
		|FROM
		|	Catalog.ItemKeys AS ItemKeys
		|		LEFT JOIN InformationRegister.ItemSegments AS ItemSegments
		|		ON ItemSegments.Segment = &Segment
		|		AND ItemKeys.Ref = ItemSegments.ItemKey
		|WHERE
		|	ItemKeys.Ref IN (&Refs)
		|	AND ItemSegments.Segment IS NULL";
	Else
		Query.Text =
		"SELECT
		|	&Segment,
		|	VALUE(Catalog.ItemKeys.EmptyRef) AS ItemKey,
		|	Items.Ref AS Item
		|FROM
		|	Catalog.Items AS Items
		|		LEFT JOIN InformationRegister.ItemSegments AS ItemSegments
		|		ON ItemSegments.Segment = &Segment
		|		AND Items.Ref = ItemSegments.Item
		|		AND ItemSegments.ItemKey = VALUE(Catalog.ItemKeys.EmptyRef)
		|WHERE
		|	Items.Ref IN (&Refs)
		|	AND ItemSegments.Segment IS NULL";
	EndIf;
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Record = InformationRegisters.ItemSegments.CreateRecordManager();
		FillPropertyValues(Record, QuerySelection);
		Record.Write();
	EndDo;
	
EndProcedure

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
	|	ItemSegments.ItemKey.Item AS Item
	|FROM
	|	InformationRegister.ItemSegments AS ItemSegments
	|WHERE
	|	ItemSegments.Segment = &Segment
	|	AND ItemSegments.ItemKey <> VALUE(Catalog.ItemKeys.EmptyRef)
	|	AND ItemSegments.Item = VALUE(Catalog.Items.EmptyRef)";
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		RecordSet = InformationRegisters.ItemSegments.CreateRecordSet();
		RecordSet.Filter.Segment.Set(QuerySelection.Segment);
		RecordSet.Filter.ItemKey.Set(QuerySelection.ItemKey);
		
		RecordRow = RecordSet.Add();
		FillPropertyValues(RecordRow, QuerySelection);
		RecordSet.Write(True);
	EndDo;
	
EndProcedure