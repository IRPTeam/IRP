// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.Period.StartDate = BegOfYear(CurrentSessionDate());
	Object.Period.EndDate = EndOfYear(CurrentSessionDate());
	
	FillDocumentsToControl();
		
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetVisibleForCheckMode(CheckMode);
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateObjectPictures_AddNewOne" Then
		CurrentDocStructure = GetCurrentDocInTable();
		If CurrentDocStructure = Undefined Then
			Return;
		EndIf;
		UpdateAttachedFiles(CurrentDocStructure.Ref, CurrentDocStructure.ID);
		
		DocsArray = New Array; // DocumentRef
		DocsArray.Add(CurrentDocStructure.Ref);
		
		UpdateDocsDataInTables(DocsArray);

	EndIf;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FillDocuments(Command)
	
	FillDocumentsToControl();
	
EndProcedure

&AtClient
Function CheckFileMaxSize(FileArray, MaxSizeMb)
	
	StringsArray = New Array; // Array of String
	
	Structure = New Structure;
	Structure.Insert("Result", True);
	Structure.Insert("Errors", StringsArray);  
	
	If MaxSizeMb = 0 Then
		Return Structure;
	EndIf;
	
	byteSize = 1024;
	For Each FileRef In FileArray Do
		CurrentSize = FileRef.Size(); // Number
		CurrentSizeMb = Round(CurrentSize/(byteSize * byteSize), 2);
		If CurrentSizeMb > MaxSizeMb Then
			FileName = FileRef.Name;
			//@skip-check invocation-parameter-type-intersect, property-return-type
			ErrorText = StrTemplate(R().InfoMessage_AttachFile_MaxFileSize, FileName, CurrentSizeMb, MaxSizeMb);
			
			Structure.Result = False;
			Structure.Errors.Add(ErrorText);
		EndIf;
	EndDo;
	
	Return Structure;
	
EndFunction

&AtClient
Procedure AddNewDocument(Command)
	//@skip-check property-return-type
	CurrentData = Items.CurrentFilesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Not ValueIsFilled(CurrentData.FilePresention) Then
		//@skip-check property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_041);
		Return;
	EndIf;	
	
	CurrentDocStructure = GetCurrentDocInTable();
	If CurrentDocStructure = Undefined Then
		Return;
	EndIf;
	
	Upload(CurrentDocStructure);
EndProcedure

&AtClient
Async Procedure DownloadFile(Command)
	CurrentData = Items.CurrentFilesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	PictureParameters = PictureViewerServer.CreatePictureParameters(CurrentData.File);
	URI = PictureViewerClient.GetPictureURL(PictureParameters); // String
	Dialog = New GetFilesDialogParameters();
	Try
		//@skip-check invocation-parameter-type-intersect, property-return-type
		Await GetFileFromServerAsync(URI, PictureParameters.Description, Dialog);
	Except
		//@skip-check property-return-type
		CommonFunctionsClientServer.ShowUsersMessage(R().InfoMessage_040);
	EndTry;
EndProcedure

&AtClient
Async Procedure Upload(StructureParams)
	
	Structure = New Structure;
	Structure.Insert("Ref", StructureParams.Ref);
	Structure.Insert("UUID", StructureParams.UUID);
	Structure.Insert("FilePrefix", StructureParams.FilePrefix);
	Structure.Insert("PrintFormName", StructureParams.PrintFormName);
	
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.Multiselect = False;
	OpenFileDialog.Filter = PictureViewerClientServer.FilterForPicturesDialog();
	FileRef = Await PutFileToServerAsync(, , , , StructureParams.UUID); // PlacedFileDescription
	
	If FileRef = Undefined Then
		Return;
	EndIf;
	
	FileArray = New Array; // Array of FileRef
	//@skip-check invocation-parameter-type-intersect, property-return-type
	FileArray.Add(FileRef.FileRef);
	CheckSizeResult = CheckFileMaxSize(FileArray, StructureParams.MaxSize);
	If CheckSizeResult.Result Then
		PictureViewerClient.AddFile(FileRef, StructureParams.Storage, Structure);
		
	Else
		For Each Error In CheckSizeResult.Errors Do
			CommonFunctionsClientServer.ShowUsersMessage(Error);
		EndDo;
	EndIf;
EndProcedure

&AtClient
Procedure CheckModeOnChange(Item)
	
	SetVisibleForCheckMode(CheckMode);
		
EndProcedure 

&AtClient
Procedure SetVisibleForCheckMode(Val IsCheckMode)
	
	Items.DocumentsGroupLockUnlock.Visible = IsCheckMode;
	Items.DocumentsAttachedFiles.Visible = Not IsCheckMode;
	Items.AddNewDocument.Visible = Not IsCheckMode;
	Items.ShowSettings.Visible = IsCheckMode;
	
EndProcedure

&AtClient
Procedure CompanyOnChange(Item)
	FillDocumentsToControl();
EndProcedure

&AtClient
Procedure BranchOnChange(Item)
	FillDocumentsToControl();
EndProcedure

&AtClient
Procedure PeriodOnChange(Item)
	FillDocumentsToControl();
EndProcedure

&AtClient
Procedure ShowOnlyUnlocked(Command)
	
	Items.DocumentsShowOnlyUnlocked.Check = Not Items.DocumentsShowOnlyUnlocked.Check;
	
	If Items.DocumentsShowOnlyUnlocked.Check Then
		Items.DocumentList.RowFilter = New FixedStructure("IsAuditLock", -1);
	Else
		Items.DocumentList.RowFilter = Undefined;
	EndIf;
	
EndProcedure

#EndRegion

#Region FormTableItemsEventHandlers

&AtClient
Procedure DocumentsOnActivateRow(Item)

	CurrentData = Items.DocumentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	
	If CurrentData.DocRef = LastDocumentRef Then
		Return;
	EndIf;
	
	LastDocumentRef = CurrentData.DocRef;
	
	Items.DocumentsAttachedFiles.RowFilter = New FixedStructure("ID", CurrentData.ID);
	Preview = "";
	PDFViewer = New PDFDocument();
	UpdateAttachedFiles(CurrentData.DocRef, CurrentData.ID);
EndProcedure

&AtClient
Procedure CurrentFilesTableOnActivateRow(Item)
	
	CurrentData = Items.CurrentFilesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	If IsPDF(CurrentData.File) Then 
		ShowPreviewPDF(CurrentData.File);
	Else
		ShowPreview(CurrentData.File);
		GetFullPicture(CurrentData);
	EndIf;
EndProcedure

&AtClient
Async Procedure GetFullPicture(CurrentData)
	PictureParameters = PictureViewerServer.CreatePictureParameters(CurrentData.File);
	Preview = PictureViewerClient.GetPictureURL(PictureParameters); // String
EndProcedure

&AtClient
Procedure DocumentsAttachedFilesOnActivateRow(Item)
	CurrentData = Items.DocumentsAttachedFiles.CurrentData;
	If CurrentData = Undefined Then
		//@skip-check invocation-parameter-type-intersect, property-return-type, statement-type-change
		Items.AddNewDocument.Title = R().InfoMessage_AttachFile_NonSelectDocType;
		Return;
	EndIf;
	//@skip-check invocation-parameter-type-intersect, property-return-type
	Items.AddNewDocument.Title = StrTemplate(R().InfoMessage_AttachFile_SelectDocType, String(CurrentData.FilePresention));
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure UpdateDocsDataInTables(DocsArray)
	
	QueryStructure = PrepareQueryStructure(DocsArray);
	FillDocumentsTables(QueryStructure, True);
	
EndProcedure

&AtServer
Procedure ShowPreview(FileRef)
	Items.PDFViewer.Visible = False;
	Items.Preview.Visible = True;
	
	Preview = PutToTempStorage(FileRef.Preview.Get());
EndProcedure

&AtClient
Async Procedure ShowPreviewPDF(FileRef)
	
	Items.PDFViewer.Visible = True;
	Items.Preview.Visible = False;
	
	PictureViewerClient.SetPDFForView(FileRef, PDFViewer); 
	Items.PDFViewer.Scale = 20;
	
EndProcedure

&AtClient
Function GetDocPrefix(DocRef, NamingFormat)
	
	NewNamingFormat = NamingFormat;
	
	Prefix = "";
	
	If Not ValueIsFilled(DocRef) Or Not ValueIsFilled(NamingFormat) Then
		Return Prefix;
	EndIf;
	
	Structure = New Structure;
	Structure.Insert("Store", "Branch.Code");
	Structure.Insert("DocDate", "Date");
	Structure.Insert("DocNumber", "Number");
	
	AttributesArray = New Array; // Array Of String

	For Each KeyValue In Structure Do
		If StrFind(NewNamingFormat, KeyValue.Key) > 0 Then
					
			SearchSubstring = "%" + KeyValue.Key;
			ReplaceSubsting = "%" + KeyValue.Value;
			
			NewNamingFormat = StrReplace(NewNamingFormat, SearchSubstring, ReplaceSubsting);
			
			//@skip-check invocation-parameter-type-intersect
			AttributesArray.Add(KeyValue.Value);
		EndIf;
	EndDo;
	
	AttributesStructure = CommonFunctionsServer.GetAttributesFromRef(DocRef, AttributesArray);
	For Each Attribute In AttributesArray Do
		SearchSubstring = "%" + Attribute;
		If StrFind(Attribute, ".") > 0 Then
			Value = Eval("AttributesStructure." + Attribute);
		Else
			Value = AttributesStructure[Attribute]; // String
		EndIf;
		If IsTypeOf(Value, "Date") Then
			//@skip-check invocation-parameter-type-intersect
			ReplaceSubsting = Format(Value, "DF=yyyyMMdd");
		Else
			ReplaceSubsting = Value;
		EndIf;
		
		NewNamingFormat = StrReplace(NewNamingFormat, SearchSubstring, ReplaceSubsting);
	EndDo;
	Return NewNamingFormat;
	
EndFunction

&AtClient
Function IsTypeOf(SourceValue, Type)
	Return TypeOf(SourceValue) = Type(Type);
EndFunction

// Get current doc in table.
// 
// Returns:
//  Undefined, Structure - Get current doc in table:
// * Object - Structure - 
// * UUID - UUID - 
// * Items - FormAllItems - 
// * Ref - See DataProcessor.AttachedFilesToDocumentsControl.Documents.DocRef
// * DocMetaName - See DataProcessor.AttachedFilesToDocumentsControl.Documents.DocMetaName
// * Branch - See DataProcessor.AttachedFilesToDocumentsControl.Documents.Branch 
// * Company - See DataProcessor.AttachedFilesToDocumentsControl.Documents.Company
// * Storage - See DataProcessor.AttachedFilesToDocumentsControl.Documents.FileStorageVolume 
// * FilePrefix - String - 
// * PrintFormName - String -
// * MaxSize - Number -
&AtClient
Function GetCurrentDocInTable()
	CurrentData = Items.DocumentList.CurrentData; // 
	If CurrentData = Undefined Then
		Return Undefined;
	EndIf;
	
	Structure = New Structure;
	Structure.Insert("Object", New Structure);
	Structure.Insert("UUID", ThisObject.UUID);
	Structure.Insert("Items", ThisObject.Items);
		
	CurrentDataAttachedDocs = Items.DocumentsAttachedFiles.CurrentData;
	
	FilePrefix = "";
	CurrentItemName = ThisObject.CurrentItem.Name;
	PrintFormName = Undefined;
	If CurrentItemName = "CurrentFilesTable" Then
		CurrentDataCurrentAttachments = Items.CurrentFilesTable.CurrentData;		
	ElsIf CurrentItemName = "DocumentsAttachedFiles" Then
		CurrentDataCurrentAttachments = Items.DocumentsAttachedFiles.CurrentData;		
	Else
		CurrentDataCurrentAttachments = CurrentDataAttachedDocs;
	EndIf;
	PrintFormName = CurrentDataCurrentAttachments.FilePresention;
	FilePrefix = GetDocPrefix(CurrentData.DocRef, CurrentDataCurrentAttachments.NamingFormat);		
	
	Structure.Object.Insert("Ref", CurrentData.DocRef); 
	Structure.Insert("ID", CurrentData.ID);
	Structure.Insert("Ref", CurrentData.DocRef);
	Structure.Insert("DocMetaName", CurrentData.DocMetaName);
	Structure.Insert("Branch", CurrentData.Branch);
	Structure.Insert("Company", CurrentData.Company);
	Structure.Insert("Storage", CurrentData.FileStorageVolume);
	Structure.Insert("FilePrefix", FilePrefix);
	Structure.Insert("PrintFormName", PrintFormName);
	Structure.Insert("MaxSize", CurrentDataAttachedDocs.MaximumFileSize);
	
	Return Structure;
	
EndFunction

// Get array meta docs to control.
// 
// Returns:
//  Array of Structure:
//  * DocMetaName - String -
//  * FileStorageVolume - CatalogRef.FileStorageVolumes -
&AtServer
Function GetArrayMetaDocsToControl()
	
	ArrayDocsNames = New Array; // Array of Structure
	
	Query = New Query;
	Query.Text = 
	"SELECT
	|	AttachedDocumentSettings.Description AS Name,
	|	AttachedDocumentSettings.FileStorageVolume AS FileStorageVolume
	|FROM
	|	Catalog.AttachedDocumentSettings AS AttachedDocumentSettings
	|WHERE
	|	NOT AttachedDocumentSettings.DeletionMark";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	While SelectionDetailRecords.Next() Do
		Structure = New Structure;
		//@skip-check property-return-type
		Structure.Insert("DocMetaName", SelectionDetailRecords.Name);
		//@skip-check property-return-type
		Structure.Insert("FileStorageVolume", SelectionDetailRecords.FileStorageVolume);
		ArrayDocsNames.Add(Structure);
	EndDo;
		
	Return ArrayDocsNames;
	
EndFunction

&AtServer
Function GetAllDocumentsTempTable(DocsNamesArray, DocsArray = Undefined)
	
	Query = New Query;
	Query.SetParameter("StartDate", Object.Period.StartDate);
	Query.SetParameter("EndDate", Object.Period.EndDate);
	Query.SetParameter("OnlyPosted", True);
	Query.SetParameter("CompanyArray", Company);
	Query.SetParameter("BranchArray", Branch.UnloadValues());
	Query.SetParameter("DocsArray", DocsArray);

	Template = "SELECT Doc.Ref, Doc.Date, Doc.Posted, Doc.Author, Doc.Branch, Doc.Number, Doc.Company, Doc.DeletionMark, ""%1"" %2, PRESENTATION(VALUETYPE(Doc.Ref)) %3 FROM Document.%4 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate %5 %6 %7";
	
	Array = New Array; // Array Of String
	For Each Doc In DocsNamesArray Do
		Array.Add(StrTemplate(
				Template,
				Doc.DocMetaName,
				?(Array.Count() > 0, "", "AS DocMetaName"),
				?(Array.Count() > 0, "", "AS DocumentType"), 
				Doc.DocMetaName,
				?(DocsArray = Undefined, "", "AND Doc.Ref IN (&DocsArray)"),
				?(Not Company.isEmpty(), "AND Doc.Company IN (&CompanyArray)", ""),
				?(Branch.Count() > 0, "AND Doc.Branch IN (&BranchArray)", "")
			)
		);
	EndDo;

	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF);
	
	AllDocumentsTempTable = New ValueTable();
	If Not IsBlankString(QueryTxt) Then
		Query.Text = QueryTxt;
		AllDocumentsTempTable = Query.Execute().Unload();
	EndIf;
	
	Return AllDocumentsTempTable;

EndFunction

// Get attached documents.
// 
// Parameters:
//  AllDocumentsTempTable - ValueTable - All documents temp table
// 
// Returns:
//  QueryResultSelection - Get attached documents:
//  * DocMetaName - String -
//  * DocRef - DocumentRefDocumentName -
//  * PrintFormName - ChartOfCharacteristicTypesRef.AddAttributeAndProperty -
//  * IsFile - Boolean -
//  * IsRequired - Boolean -
&AtServerNoContext
Function GetAttachedDocuments(AllDocumentsTempTable)
	QueryTxt = 
	"SELECT
	|	AllDocumentsTempTable.Ref AS DocRef,
	|	AllDocumentsTempTable.Date AS DocDate,
	|	AllDocumentsTempTable.DocMetaName AS DocMetaName,
	|	AllDocumentsTempTable.DocumentType AS DocType,
	|	AllDocumentsTempTable.Author AS Author,
	|	AllDocumentsTempTable.Branch AS Branch,
	|	AllDocumentsTempTable.Posted AS Posted,
	|	AllDocumentsTempTable.DeletionMark AS DeletionMark,
	|	AllDocumentsTempTable.Number AS DocNumber,
	|	AllDocumentsTempTable.Company AS Company
	|INTO TT_AllDocuments
	|FROM
	|	&AllDocumentsTempTable AS AllDocumentsTempTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TT_AllDocuments.DocDate AS DocDate,
	|	TT_AllDocuments.Author AS Author,
	|	TT_AllDocuments.Branch AS Branch,
	|	TT_AllDocuments.DocNumber AS DocNumber,
	|	TT_AllDocuments.DocRef AS DocRef,
	|	TT_AllDocuments.DocMetaName AS DocMetaName,
	|	TT_AllDocuments.DocType AS DocType,
	|	CASE
	|		WHEN TT_AllDocuments.Posted
	|			THEN 0
	|		WHEN TT_AllDocuments.DeletionMark
	|			THEN 1
	|		ELSE 2
	|	END AS Picture,
	|	AttachedDocumentSettingsFileSettings.FilePresention AS PrintFormName,
	|	AttachedDocumentSettingsFileSettings.FilePresention.Comment AS FileTooltips,
	|	AttachedDocumentSettingsFileSettings.NamingFormat AS NamingFormat,
	|	AttachedDocumentSettingsFileSettings.Required AS Required,
	|	AttachedDocumentSettingsFileSettings.MaximumFileSize AS MaximumFileSize,
	|	AttachedDocumentSettingsFileSettings.FileExtension AS FileExtension,
	|	TT_AllDocuments.Company AS Company,
	|	ISNULL(AttachedDocumentSettingsFileSettings.LineNumber, 0) AS LineNumber
	|INTO TT_AllDocumentsAndRequiredAttacments
	|FROM
	|	TT_AllDocuments AS TT_AllDocuments
	|		INNER JOIN Catalog.AttachedDocumentSettings.FileSettings AS AttachedDocumentSettingsFileSettings
	|		ON TT_AllDocuments.DocMetaName = AttachedDocumentSettingsFileSettings.Ref.Description
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TT_AllDocumentsAndRequiredAttacments.DocDate AS DocDate,
	|	TT_AllDocumentsAndRequiredAttacments.DocRef AS DocRef,
	|	TT_AllDocumentsAndRequiredAttacments.DocMetaName AS DocMetaName,
	|	TT_AllDocumentsAndRequiredAttacments.DocType AS DocType,
	|	TT_AllDocumentsAndRequiredAttacments.PrintFormName AS PrintFormName,
	|	CAST(TT_AllDocumentsAndRequiredAttacments.PrintFormName.Comment AS STRING(1000)) AS FileToolTip,
	|	TT_AllDocumentsAndRequiredAttacments.NamingFormat AS NamingFormat,
	|	TT_AllDocumentsAndRequiredAttacments.Required AS IsRequired,
	|	TT_AllDocumentsAndRequiredAttacments.MaximumFileSize AS MaximumFileSize,
	|	TT_AllDocumentsAndRequiredAttacments.FileExtension AS FileExtension,
	|	CASE
	|		WHEN AttachedFiles.File IS NOT NULL
	|			THEN TRUE
	|		ELSE FALSE
	|	END AS IsFile,
	|	CASE
	|		WHEN AuditLock.Document IS NULL
	|			THEN -1
	|		ELSE 0
	|	END AS IsAuditLock,
	|	TT_AllDocumentsAndRequiredAttacments.Author AS Author,
	|	TT_AllDocumentsAndRequiredAttacments.Branch AS Branch,
	|	TT_AllDocumentsAndRequiredAttacments.DocNumber AS DocNumber,
	|	TT_AllDocumentsAndRequiredAttacments.Company AS Company,
	|	NULL AS Comment,
	|	TT_AllDocumentsAndRequiredAttacments.LineNumber AS LineNumber
	|FROM
	|	TT_AllDocumentsAndRequiredAttacments AS TT_AllDocumentsAndRequiredAttacments
	|		LEFT JOIN InformationRegister.AttachedFiles AS AttachedFiles
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AttachedFiles.Owner
	|		AND TT_AllDocumentsAndRequiredAttacments.PrintFormName = AttachedFiles.File.PrintFormName
	|		LEFT JOIN InformationRegister.AuditLock AS AuditLock
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AuditLock.Document
	|
	|UNION ALL
	|
	|SELECT
	|	TT_AllDocumentsAndRequiredAttacments.DocDate,
	|	TT_AllDocumentsAndRequiredAttacments.DocRef,
	|	TT_AllDocumentsAndRequiredAttacments.DocMetaName,
	|	TT_AllDocumentsAndRequiredAttacments.DocType AS DocType,
	|	TT_AllDocumentsAndRequiredAttacments.PrintFormName,
	|	CAST(TT_AllDocumentsAndRequiredAttacments.PrintFormName.Comment AS STRING(1000)),
	|	TT_AllDocumentsAndRequiredAttacments.NamingFormat,
	|	TT_AllDocumentsAndRequiredAttacments.Required,
	|	TT_AllDocumentsAndRequiredAttacments.MaximumFileSize,
	|	TT_AllDocumentsAndRequiredAttacments.FileExtension,
	|	FALSE,
	|	FALSE,
	|	TT_AllDocumentsAndRequiredAttacments.Author,
	|	TT_AllDocumentsAndRequiredAttacments.Branch,
	|	TT_AllDocumentsAndRequiredAttacments.DocNumber,
	|	TT_AllDocumentsAndRequiredAttacments.Company,
	|	AttachedFiledControl.Comment,
	|	TT_AllDocumentsAndRequiredAttacments.LineNumber
	|FROM
	|	TT_AllDocumentsAndRequiredAttacments AS TT_AllDocumentsAndRequiredAttacments
	|		INNER JOIN InformationRegister.AttachedFilesControl AS AttachedFiledControl
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AttachedFiledControl.Document
	|
	|ORDER BY
	|	LineNumber
	|TOTALS
	|	MAX(DocDate),
	|	MAX(DocMetaName),
	|	MAX(DocType),
	|	MAX(FileToolTip),
	|	MAX(NamingFormat),
	|	MAX(IsRequired),
	|	MAX(MaximumFileSize),
	|	MAX(FileExtension),
	|	MAX(IsFile),
	|	MAX(IsAuditLock),
	|	MAX(Author),
	|	MAX(Branch),
	|	MAX(DocNumber),
	|	MAX(Company)
	|BY
	|	DocRef,
	|	PrintFormName";
	
	Query = New Query();
	Query.Text = QueryTxt;
	Query.SetParameter("AllDocumentsTempTable", AllDocumentsTempTable);
	
	QueryResult = Query.Execute();
	Return QueryResult.Select(QueryResultIteration.ByGroups, "DocRef");
EndFunction

&AtClient
Procedure DocumentListSelection(Item, RowSelected, Field, StandardProcessing)
	StandardProcessing = False;
	CurrentDoc = Item.CurrentData.DocRef;
	OpenDocByRef(CurrentDoc);
EndProcedure

&AtClient
Async Procedure OpenDocByRef(DocRef)
	OpenValueAsync(DocRef);
EndProcedure	


&AtServer
Procedure FillDocumentsToControl()
	
	Object.Documents.Clear();
	Object.DocumentsAttachedFiles.Clear();
	CurrentFilesTable.Clear();
	
	QueryStructure = PrepareQueryStructure();
	
	FillDocumentsTables(QueryStructure);
	
	If Items.DocumentList.CurrentRow = Undefined Then
		If Object.Documents.Count() > 0 Then
			Items.DocumentList.CurrentRow = Object.Documents[0].GetID();
		EndIf;
	EndIf;
	
EndProcedure

&AtServer
Function PrepareQueryStructure(DocsArray = Undefined)
	
	DocsToControl = GetArrayMetaDocsToControl();
	AllDocumentsTempTable = GetAllDocumentsTempTable(DocsToControl, DocsArray);
	DocsNamesAndStorageStructure = New Structure;
	For Each Doc In DocsToControl Do
		DocsNamesAndStorageStructure.Insert(Doc.DocMetaName, Doc.FileStorageVolume);
	EndDo;
	
	Structure = New Structure;
	Structure.Insert("AllDocumentsTempTable", AllDocumentsTempTable);
	Structure.Insert("DocsNamesAndStorageStructure", DocsNamesAndStorageStructure);
	
	Return Structure;
	
EndFunction

&AtServer
Procedure FillDocumentsTables(QueryStructure, IsUpdate = False)
	
	If QueryStructure.AllDocumentsTempTable.Count() = 0 Then
		Return;
	EndIf;
	
	SelectionDoc = GetAttachedDocuments(QueryStructure.AllDocumentsTempTable);
	
	While SelectionDoc.Next() Do
		If Not IsUpdate Then
			ParentRow = Object.Documents.Add();
			ParentRow.ID = New UUID;
			//@skip-check statement-type-change
			ParentRow.FileStorageVolume = QueryStructure.DocsNamesAndStorageStructure[SelectionDoc.DocMetaName];
		Else
			SearchArray = Object.Documents.FindRows(New Structure("DocRef", SelectionDoc.DocRef));
			ParentRow = SearchArray[0];
		EndIf;
			
		FillPropertyValues(ParentRow, SelectionDoc);
		
		SelectionPrintForm = SelectionDoc.Select(QueryResultIteration.ByGroups, "PrintFormName");
		RequiredPrintForms = 0;
		IsFile = 0;
		While SelectionPrintForm.Next() Do
			If Not IsUpdate Then
				ChildRow = Object.DocumentsAttachedFiles.Add();
				ChildRow.FilePresention = SelectionPrintForm.PrintFormName;
				ChildRow.ID = ParentRow.ID;
			Else
				SearchStructure = New Structure;
				SearchStructure.Insert("ID", ParentRow.ID);
				SearchStructure.Insert("FilePresention", SelectionPrintForm.PrintFormName);
				
				SearchArray = Object.DocumentsAttachedFiles.FindRows(SearchStructure);
				ChildRow = SearchArray[0];
			EndIf;
				
			FillPropertyValues(ChildRow, SelectionPrintForm);
			
			If SelectionPrintForm.IsFile And SelectionPrintForm.IsRequired Then
				IsFile = IsFile + 1;
			EndIf;
			If SelectionPrintForm.IsRequired Then
				RequiredPrintForms = RequiredPrintForms + 1;
			EndIf;
			
		EndDo;
		If IsFile = 0 Then
			ParentRow.FillCheckingStatus = Enums.DocAttachmentStatus.NoFiles;
			ParentRow.FillChecking = 2;
		ElsIf IsFile < RequiredPrintForms Then
			ParentRow.FillCheckingStatus = Enums.DocAttachmentStatus.NotEnoughFiles;
			ParentRow.FillChecking = 1;
		ElsIf IsFile = RequiredPrintForms Then
			ParentRow.FillCheckingStatus = Enums.DocAttachmentStatus.AllFilesPresent;
			ParentRow.FillChecking = 0;
		EndIf;
	EndDo;

EndProcedure

&AtServer
Procedure UpdateAttachedFiles(DocRef, RowID)
	CurrentFilesTable.Clear();
	
	ArrayDocsToAttach = Object.DocumentsAttachedFiles.FindRows(New Structure("ID", RowID));
	For Each ArrayItem In ArrayDocsToAttach Do
		NewRow = CurrentFilesTable.Add();
		NewRow.FilePresention = ArrayItem.FilePresention;
		NewRow.IsRequired = ArrayItem.IsRequired;
		NewRow.NamingFormat = ArrayItem.NamingFormat;
	EndDo;		
	
	FilesArray = PictureViewerServer.PicturesInfoForSlider(DocRef);
	
	For Each Structure In FilesArray Do
		SearchStructure = New Structure;
		SearchStructure.Insert("FilePresention", CommonFunctionsServer.GetRefAttribute(Structure.FileRef, "PrintFormName"));
		SearchStructure.Insert("File", Catalogs.Files.EmptyRef());
		
		SearchArray = CurrentFilesTable.FindRows(SearchStructure);
		If SearchArray.Count() = 0 Then
			TableRow = CurrentFilesTable.Add();			
		Else
			TableRow = SearchArray[0];		
		EndIf;
		TableRow.File = Structure.FileRef;		
				
	EndDo;

	Query = New Query;
	Query.SetParameter("Document", DocRef);
	Query.Text = 
		"SELECT
		|	AttachedFiledControl.Comment AS Comment,
		|	AttachedFiledControl.FileType
		|FROM
		|	InformationRegister.AttachedFilesControl AS AttachedFiledControl
		|WHERE
		|	AttachedFiledControl.Document = &Document";
	
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		//@skip-check structure-consructor-value-type
		//@skip-check property-return-type
		SearchStructure = New Structure("FilePresention", SelectionDetailRecords.FileType);
		SearchArray = CurrentFilesTable.FindRows(SearchStructure);
		
		If SearchArray.Count() > 0 Then
			TableRow = SearchArray[0];
		Else
			TableRow = CurrentFilesTable.Add();		
		EndIf;	 
		//@skip-check property-return-type
		//@skip-check statement-type-change
		TableRow.Comment = SelectionDetailRecords.Comment;
	EndDo;
EndProcedure

&AtClıent
Function GetSelectedDocs()
	
	DocsArray = New Array; // Array of DocumentRef
	For Each Row In Items.DocumentList.SelectedRows Do // Number
		DocsArray.Add(Object.Documents.FindByID(Row).DocRef);
	EndDo;
	Return DocsArray;
	
EndFunction

&AtClient
Procedure LockDocuments(Command)
	DocsArray = GetSelectedDocs();
	LockDocumentsAtServer(DocsArray);
EndProcedure

&AtServer
Procedure LockDocumentsAtServer(DocsArray)
	
	For Each DocRef In DocsArray Do
		AuditLockPrivileged.SetLock(DocRef);
	EndDo;
	UpdateDocsDataInTables(DocsArray);
	
EndProcedure

&AtClient
Procedure UnlockDocuments(Command)
	
	DocsArray = GetSelectedDocs();
	UnlockDocumentsArServer(DocsArray);

EndProcedure

&AtServer
Procedure UnlockDocumentsArServer(DocsArray)
	For Each DocRef In DocsArray Do
		AuditLockPrivileged.UnsetLock(DocRef);
	EndDo;
	UpdateDocsDataInTables(DocsArray);
EndProcedure

&AtClient
Procedure DocumentsAttachedFilesSelection(Item, SelectedRow, Field, StandardProcessing)
	
	FileTemplate = GetDocTemplate(Item.CurrentData.FilePresention);
	
	Structure = New Structure;
	Structure.Insert("FileRef", FileTemplate);
	Structure.Insert("Title", Item.CurrentData.FilePresention);
	Structure.Insert("Description", Item.CurrentData.FileTooltip);
	OpenForm("DataProcessor.AttachedFilesToDocumentsControl.Form.PictureViewer", Structure, , , , , ,FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtServerNoContext
Function GetDocTemplate(FileSettingPresention)
	
	TemplateFile = Undefined;
	Query = New Query;
	Query.SetParameter("FilePresention", FileSettingPresention);
	Query.Text = 
		"SELECT TOP 1
		|	AttachedDocumentSettingsFileSettings.FileTemplate AS FileTemplate
		|FROM
		|	Catalog.AttachedDocumentSettings.FileSettings AS AttachedDocumentSettingsFileSettings
		|WHERE
		|	AttachedDocumentSettingsFileSettings.FilePresention = &FilePresention";
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	If SelectionDetailRecords.Next() Then
		//@skip-check property-return-type, statement-type-change
		TemplateFile = SelectionDetailRecords.FileTemplate;
	EndIf;
	
	Return TemplateFile;
	
EndFunction

&AtClient
Procedure ShowSettings(Command)
	
	OpenForm("Catalog.AttachedDocumentSettings.ListForm", , , , , , , FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure AttachOther(Command)
	CurrentData = Items.DocumentsAttachedFiles.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;

	CurrentDocStructure = GetCurrentDocInTable();
	
	If CurrentDocStructure = Undefined Then
		Return;
	EndIf;
	
	Structure = GetOtherAttachmentSettings(CurrentDocStructure);
	
	NotifyDescription = New NotifyDescription("AfterOtherAttachmentInput", ThisObject, Structure);
	ShowInputString(NotifyDescription, "", R().InfoMessage_037, , True);
	
EndProcedure

// Get other attachment settings.
// 
// Parameters:
//  CurrentDocStructure - See GetCurrentDocInTable
// 
// Returns:
//  Structure - Get other attachment settings:
// * Company - CatalogRef.Companies - 
// * Branch - CatalogRef.BusinessUnits - 
// * DocumentType - String - 
// * Document - DocumentRef -
// * FileType - ChartOfCharacteristicTypesRef.AddAttributeAndProperty - 
&AtClient
Function GetOtherAttachmentSettings(CurrentDocStructure)
	Structure = New Structure;
	Structure.Insert("Company", CurrentDocStructure.Company);
	Structure.Insert("Branch", CurrentDocStructure.Branch);
	Structure.Insert("DocumentType", CurrentDocStructure.DocMetaName);
	Structure.Insert("Document", CurrentDocStructure.Ref);
	Structure.Insert("FileType", CurrentDocStructure.PrintFormName);
	Return Structure
EndFunction

// After other attachment input.
// 
// Parameters:
//  Result - String - Result
//  AdditionalParameters - See GetOtherAttachmentSettings
&AtClient
Procedure AfterOtherAttachmentInput(Result, AdditionalParameters) Export
	
	If ValueIsFilled(Result) Then
		
		AdditionalParameters.Insert("Comment", Result);
		
		WriteOtherAttachmentInput(AdditionalParameters);
		
		Notify("UpdateObjectPictures_AddNewOne", Undefined, Undefined);
		
	EndIf;
	
EndProcedure

// Write other attachment input.
// 
// Parameters:
//  Structure - Structure:
//	* Company - CatalogRef.Companies
//	* Branch - CatalogRef.BusinessUnits
&AtServerNoContext
Procedure WriteOtherAttachmentInput(Structure)

	RecordManager = InformationRegisters.AttachedFilesControl.CreateRecordManager();
	RecordManager.Company = Structure.Company;
	RecordManager.Branch = Structure.Branch;
	RecordManager.DocumentType = Structure.DocumentType;
	RecordManager.Document = Structure.Document;
	RecordManager.RecordID = New UUID;
	RecordManager.Comment = Structure.Comment;
	RecordManager.FileType = Structure.FileType;
	RecordManager.Write();
	
EndProcedure

&AtClient
Function IsPDF(FileRef)
	
	FileAsString = String(FileRef);
	
	Return ?(StrFind(FileAsString, ".pdf")> 0, True, False)
	
EndFunction

&AtClient
Procedure CurrentFilesTableSelection(Item, SelectedRow, Field, StandardProcessing)
	
	FileRef = Item.CurrentData.File;
	
	Structure = New Structure;
	Structure.Insert("FileRef", FileRef);
	Structure.Insert("Title", StrTemplate("%1", FileRef));
	Structure.Insert("Description", "");
	Structure.Insert("IsPdf", IsPDF(FileRef));
	OpenForm("DataProcessor.AttachedFilesToDocumentsControl.Form.PictureViewer", Structure, , , , , ,FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

#EndRegion

