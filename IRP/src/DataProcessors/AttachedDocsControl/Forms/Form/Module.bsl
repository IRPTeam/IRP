#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.Period.StartDate = BegOfYear(CurrentDate());
	Object.Period.EndDate = EndOfYear(CurrentDate());
	
	FillDocumentsToControl();

EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	
	//PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, ThisObject);
	PictureViewerClient.HTMLEventAction(EventName, Parameter, Source, GetCurrentDocInTable());
	
EndProcedure


#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FillDocuments(Command)
	
	FillDocumentsToControl();
	
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure DocumentsOnActivateRow(Item)

	CurrentData = Items.Documents.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	Items.DocumentsAttachedFiles.RowFilter = New FixedStructure("ID", CurrentData.ID);
	PictureViewerClient.UpdateObjectPictures(ThisObject, CurrentData.DocRef);
	IRPTE_send_to_1C("{""value"":""update_slider""}");
	
EndProcedure

	
#EndRegion

#Region PictureViewer

&AtClient
Procedure HTMLViewControl(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewDetailsTree.Name);
	EndIf;
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

&AtServer
Procedure SaveSettings()

EndProcedure

&AtClient
Function GetCurrentDocInTable()
	
	Structure = New Structure;
	Structure.Insert("Object", New Structure);
	Structure.Insert("UUID", ThisObject.UUID);
	Structure.Insert("Items", ThisForm.Items);
	
	DocRef = Undefined;
	CurrentData = Items.Documents.CurrentData;
	If CurrentData <> Undefined Then
		DocRef = CurrentData.DocRef;
	EndIf;
	
	Structure.Object.Insert("Ref", DocRef);
	
	Return Structure;
	
EndFunction

&НаКлиенте
Procedure IRPTE_send_to_1C(Text)
	HTMLWindowPictures = PictureViewerClient.InfoDocumentComplete(Items.PictureViewHTML);
	HTMLWindowPictures.send_to_1C("call1C", Text);
EndProcedure


&AtClient
Procedure PictureViewHTMLOnClick(Item, EventData, StandardProcessing)
	PictureViewerClient.PictureViewHTMLOnClick(GetCurrentDocInTable(), Item, EventData, StandardProcessing);
EndProcedure

&AtClient
Procedure PictureViewerHTMLDocumentComplete(Item)
	PictureViewerClient.UpdateHTMLPicture(Item, GetCurrentDocInTable());
EndProcedure

&AtClient
Procedure ViewDetailsTree(Command)
	PictureViewerClient.HTMLViewControl(ThisObject, Command.Name);
	If Items.ViewDetailsTree.Check And Items.ViewPictures.Check Then
		PictureViewerClient.HTMLViewControl(ThisObject, Commands.ViewPictures.Name);
	EndIf;
	ChangingFormBySettings();
	SaveSettings();
EndProcedure

&AtClient
// @skip-check unknown-method-property
Procedure ChangingFormBySettings()
	
EndProcedure

#EndRegion

#Region Private

&AtServerNoContext
Function GetArrayMetaDocsToControl()
	
	ArrayDocsNames = New Array;
	
	Query = New Query;
	Query.Text = 
	"SELECT
	|	AttachedDocumentSettings.Description AS Name
	|FROM
	|	Catalog.AttachedDocumentSettings AS AttachedDocumentSettings
	|WHERE
	|	NOT AttachedDocumentSettings.DeletionMark";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	While SelectionDetailRecords.Next() Do
		ArrayDocsNames.Add(SelectionDetailRecords.Name);
	EndDo;
		
	Return ArrayDocsNames;
	
EndFunction

&AtServerNoContext
Function GetQueryText(DocsNamesArray)
	
	Template = "SELECT Doc.Ref, Doc.Date, ""%1"" %2, VALUETYPE(Doc.Ref) %3 %4 FROM Document.%5 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate";
	
	Array = New Array;
	For Each DocName In DocsNamesArray Do
		Array.Add(StrTemplate(
		Template,
		DocName,
		?(Array.Count(), "", "AS DocMetaName"),
		?(Array.Count(), "", "AS DocumentType"), 
		?(Array.Count(), "", "INTO AllDocuments"),
		DocName));
	EndDo;

	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF) +	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDocuments.Date AS DocDate,
	|	AllDocuments.Ref.Author AS Author,
	|	AllDocuments.Ref.Branch AS Branch,
	|	AllDocuments.Ref.Number AS DocNumber,
	|	AllDocuments.Ref AS DocRef,
	|	AllDocuments.DocumentType,
	|	AllDocuments.DocMetaName,
	|	CASE
	|		WHEN AllDocuments.Ref.Posted
	|			THEN 0
	|		WHEN AllDocuments.Ref.DeletionMark
	|			THEN 1
	|		ELSE 2
	|	END AS Picture
	|FROM
	|	AllDocuments AS AllDocuments
	|WHERE
	|	AllDocuments.Ref.Date BETWEEN &StartDate AND &EndDate
	|	AND CASE WHEN &OnlyPosted THEN AllDocuments.Ref.Posted ELSE TRUE END
	|	AND CASE WHEN &CompanySet THEN AllDocuments.Ref.Company IN (&CompanyList) ELSE TRUE END
	|
	|ORDER BY
	|	AllDocuments.Date";
	
	Return QueryTxt;
	
EndFunction

&AtServerNoContext
Function GetDocsTypeToAttachValueTable(DocsNamesArray)
	
	Query = New Query;
	Query.SetParameter("DocsNamesArray", DocsNamesArray);
	Query.Text = 
	"SELECT
	|	AttachedDocumentSettingsFileSettings.Ref.Description AS DocMetaName,
	|	AttachedDocumentSettingsFileSettings.FilePresention AS FilePresention,
	|	AttachedDocumentSettingsFileSettings.FileTooltips AS FileTooltips,
	|	AttachedDocumentSettingsFileSettings.FileTemplate AS FileTemplate,
	|	AttachedDocumentSettingsFileSettings.NamingFormat AS NamingFormat,
	|	AttachedDocumentSettingsFileSettings.Required AS Required,
	|	AttachedDocumentSettingsFileSettings.MaximumFileSize AS MaximumFileSize,
	|	AttachedDocumentSettingsFileSettings.FileFormat AS FileFormat
	|FROM
	|	Catalog.AttachedDocumentSettings.FileSettings AS AttachedDocumentSettingsFileSettings
	|WHERE
	|	AttachedDocumentSettingsFileSettings.Ref.Description IN(&DocsNamesArray)";
	
	Return Query.Execute().Unload();
	
EndFunction

&AtServer
Procedure FillDocumentsToControl()
	
	Object.Documents.Clear();
	
	DocsNamesToControl = GetArrayMetaDocsToControl(); //Array
	If DocsNamesToControl.Count() = 0 Then
		Return;
	EndIf;

	QueryTxt = GetQueryText(DocsNamesToControl);
	
	DocsTypeToAttachVT = GetDocsTypeToAttachValueTable(DocsNamesToControl);
		
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Object.Period.StartDate);
	Query.SetParameter("EndDate", Object.Period.EndDate);
	Query.SetParameter("OnlyPosted", True);
	Query.SetParameter("CompanySet", Company.Count() > 0);
	Query.SetParameter("CompanyList", Company.UnloadValues());
	
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();

	Array = New Array;
	While SelectionDetailRecords.Next() Do
		NewRow = Object.Documents.Add();
		FillPropertyValues(NewRow, SelectionDetailRecords);
		
		NewRow.ID = New UUID;
		
		SearchArray = DocsTypeToAttachVT.FindRows(New Structure("DocMetaName", SelectionDetailRecords.DocMetaName));
		For Each Row In SearchArray Do
			NewChildRow = Object.DocumentsAttachedFiles.Add();
			FillPropertyValues(NewChildRow, Row);
			NewChildRow.ID = NewRow.ID;
		EndDo;
		
	EndDo;

	
EndProcedure


#EndRegion

