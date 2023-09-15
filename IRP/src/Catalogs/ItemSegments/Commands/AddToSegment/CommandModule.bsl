
// Command processing.
// 
// Parameters:
//  CommandParameter - Array of CatalogRef.ItemKeys -  Command parameter
//  CommandExecuteParameters - CommandExecuteParameters -  Command execute parameters
&AtClient
Procedure CommandProcessing(CommandParameter, CommandExecuteParameters)
	If CommandParameter.Count() = 0 Then
		Return;
	EndIf;
	
	FormParameters = New Structure;
	FormParameters.Insert("ChoiceMode", True);
	FormParameters.Insert("MultipleChoice", False);
	FormParameters.Insert("CloseOnChoice", True);
	
	Notify = New NotifyDescription("ChoiceSegmentEnd", ThisObject, New Structure("Items", CommandParameter));
	
	OpenForm("Catalog.ItemSegments.ChoiceForm", 
		FormParameters, 
		CommandExecuteParameters.Source, 
		CommandExecuteParameters.Uniqueness, 
		CommandExecuteParameters.Window, 
		CommandExecuteParameters.URL,
		Notify);
EndProcedure

// Choice segment end.
// 
// Parameters:
//  SelectedSegment - CatalogRef.ItemSegments - Selected segment
//  AddInfo - Structure - Add info
&AtClient
Procedure ChoiceSegmentEnd(SelectedSegment, AddInfo) Export
	If SelectedSegment = Undefined Then
		Return;
	EndIf;
	
	SaveToSegmentAtServer(SelectedSegment, AddInfo.Items);
EndProcedure

// Save to segment at server.
// 
// Parameters:
//  Segment - CatalogRef.ItemSegments -  Segment
//  Refs - Array of CatalogRef.ItemKeys - Refs
&AtServer
Procedure SaveToSegmentAtServer(Segment, Refs)
	
	Query = New Query;
	Query.SetParameter("Refs", Refs);
	Query.SetParameter("Segment", Segment);
	
	If Refs.Count() > 0 And TypeOf(Refs[0]) = Type("CatalogRef.ItemKeys") Then
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
	
	Catalogs.ItemSegments.CheckContent(Segment);
	
EndProcedure