
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
	Catalogs.ItemSegments.SaveItemsToSegment(Segment, Refs);
	Catalogs.ItemSegments.CheckContent(Segment);
EndProcedure