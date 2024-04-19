// @strict-types

#Region FormEventHandlers

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	Object.Period.StartDate = BegOfYear(CurrentSessionDate());
	Object.Period.EndDate = EndOfYear(CurrentSessionDate());
	
	FillDocumentsToControl();
		
EndProcedure

&AtClient
Procedure NotificationProcessing(EventName, Parameter, Source)
	If EventName = "UpdateObjectPictures_AddNewOne" Then
		CurrentDocStructure = GetCurrentDocInTable();
		UpdateAttachedFiles(CurrentDocStructure.Ref);
		
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
Function CurrentMaxFileSize()
	
	CurrentData = Items.DocumentsAttachedFiles.CurrentData;
	
	Return CurrentData.MaximumFileSize;
	
EndFunction

&AtClient
Procedure UploadFileDrag(Item, DragParameters, StandardProcessing)
	StandardProcessing = False;
	
	FileArray = New Array; // Array of FileRef
	If TypeOf(DragParameters.Value) = Type("Array") Then
		IncomingArray = DragParameters.Value; // Array of FileRef
		For Each ArrayItem In IncomingArray Do  
			FileArray.Add(ArrayItem);
		EndDo;
	Else
		IncomingRef = DragParameters.Value; // FileRef
		FileArray.Add(IncomingRef);
	EndIf;
	
	CheckStructure = CheckFileMaxSize(FileArray, CurrentMaxFileSize());
	
	If CheckStructure.Result Then
		UploadFileDragWithQuestion(FileArray);
	Else
		For Each Error In CheckStructure.Errors Do
			CommonFunctionsClientServer.ShowUsersMessage(Error);
		EndDo;
	EndIf;
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
			ErrorText = StrTemplate("File size %1 is %2 Mb, which is larger than the allowed size of %3 Mb.",
			FileName,
			CurrentSizeMb,
			MaxSizeMb);
			
			Structure.Result = False;
			Structure.Errors.Add(ErrorText);
		EndIf;
	EndDo;
	
	Return Structure;
	
EndFunction

&AtClient
Async Procedure UploadFileDragWithQuestion(FileArray)
	
	QueryText = GetQueryTextForCurrentUpload();
	If Await DoQueryBoxAsync(QueryText, QuestionDialogMode.OKCancel) = DialogReturnCode.OK Then
		
		CurrentDocStructure = GetCurrentDocInTable();
		
		UploadFiles(FileArray, CurrentDocStructure);
	EndIf;
	
EndProcedure

&AtClient
Function GetQueryTextForCurrentUpload()
	
	CurrentDocumentsData = Items.Documents.CurrentData;
	CurrentDoc = CurrentDocumentsData.DocRef;
	
	CurrentDocumentsAttachedFilesData = Items.DocumentsAttachedFiles.CurrentData;
	CurrentFormName = CurrentDocumentsAttachedFilesData.FilePresention;
	
	Text = "Attach file for %1" + Chars.LF + "as %2";
	Return StrTemplate(Text, CurrentDoc, CurrentFormName);
	
EndFunction

&AtClient
Procedure UploadFileClick(Item, StandardProcessing)
	
	StandardProcessing = False;
	
	UploadFileWithQuestion();
	
EndProcedure

&AtClient
Async Procedure UploadFileWithQuestion()
	
	QueryText = GetQueryTextForCurrentUpload();
	If Await DoQueryBoxAsync(QueryText, QuestionDialogMode.OKCancel) = DialogReturnCode.OK Then
	
		CurrentDocStructure = GetCurrentDocInTable();
		
		Upload(CurrentDocStructure);
	EndIf;
	
EndProcedure

&AtClient
Procedure UploadFileDragCheck(Item, DragParameters, StandardProcessing)
	StandardProcessing = False;
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
	Preview = "";
	UpdateAttachedFiles(CurrentData.DocRef);
	
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
	EndIf;
EndProcedure

#EndRegion

#Region Private

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
	FileRef = Await PutFileToServerAsync(, , , , StructureParams.UUID);
	
	If FileRef = Undefined Then
		Return;
	EndIf;
	
	FileArray = New Array; // Array of FileRef
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

&AtServer
Procedure UpdateDocsDataInTables(DocsArray)
	
	Query = PrepareQueryStructure(DocsArray).Query;
	FillDocumentsTables(Query, , True);
	
EndProcedure

// File attach empty structure.
// 
// Returns:
//  Structure - File attach empty structure:
// * FileIDs - Array of String  
// * FileOwner - DocumentRef
// * FilesStorageVolume - CatalogRef.FileStorageVolumes - 
// * FilePrefix - String - 
// * PrintFormName - String - 
&AtClient
Function FileAttachEmptyStructure()
	
	Structure = New Structure;
	Structure.Insert("FileIDs", New Array);  
	Structure.Insert("FileOwner");
	Structure.Insert("FilesStorageVolume");
	Structure.Insert("FilePrefix", "");
	Structure.Insert("PrintFormName", "");
	Return Structure;
	
EndFunction

&AtClient
Async Procedure AttachFileToOwner(StructureParams)

	FilesAtServer = Await PutFilesToServerAsync( , , StructureParams.FileIDs, UUID);	
	
	StructureParam = New Structure;
	StructureParam.Insert("Ref", StructureParams.FileOwner);
	StructureParam.Insert("UUID", UUID);
	StructureParam.Insert("FilePrefix", StructureParams.FilePrefix);
	StructureParam.Insert("PrintFormName", StructureParams.PrintFormName);
	
	For Each File In FilesAtServer Do
		PictureViewerClient.AddFile(File, StructureParams.FilesStorageVolume, StructureParam);
	EndDo;
	NotifyChanged(Type("InformationRegisterRecordKey.AttachedFiles"));
EndProcedure

&AtClient
Async Procedure UploadFiles(FileArray, DocStructure)

	FilesToTransfer = New Array; //Array of FileRef
	For Each FileRef In FileArray Do
		If Not Await FileRef.File.IsDirectoryAsync() Then
			FilesToTransfer.Add(FileRef);
		EndIf;
	EndDo;
			
	Structure = FileAttachEmptyStructure();
	Structure.FileIDs = FilesToTransfer;
	Structure.FileOwner = DocStructure.Ref;
	Structure.FilesStorageVolume = DocStructure.Storage;
	Structure.FilePrefix = DocStructure.FilePrefix;
	Structure.PrintFormName = DocStructure.PrintFormName;
	
	AttachFileToOwner(Structure);	
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
	
	PictureParameters = PictureViewerServer.CreatePictureParameters(FileRef);
	
	URI = PictureViewerClient.GetPictureURL(PictureParameters); //String
	PDFViewer.ReadAsync(URI);
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
	Structure.Insert("Shop", "Branch.Code");
	Structure.Insert("DocDate", "Date");
	Structure.Insert("DocNumber", "Number");
	
	AttributesArray = New Array;

	For Each KeyValue In Structure Do
		If StrFind(NewNamingFormat, KeyValue.Key) > 0 Then
					
			SearchSubstring = "%" + KeyValue.Key;
			ReplaceSubsting = "%" + KeyValue.Value;
			
			NewNamingFormat = StrReplace(NewNamingFormat, SearchSubstring, ReplaceSubsting);
			
			AttributesArray.Add(KeyValue.Value);
		EndIf;
	EndDo;
	
	AttributesStructure = CommonFunctionsServer.GetAttributesFromRef(DocRef, AttributesArray);
	For Each Attribute In AttributesArray Do
		SearchSubstring = "%" + Attribute;
		If StrFind(Attribute, ".") > 0 Then
			Value = Eval("AttributesStructure."+Attribute);
		Else
			Value = AttributesStructure[Attribute];
		EndIf;
		If IsTypeOf(Value, "Date") Then
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

&AtClient
Function GetCurrentDocInTable()
	
	Structure = New Structure;
	Structure.Insert("Object", New Structure);
	Structure.Insert("UUID", ThisObject.UUID);
	Structure.Insert("Items", ThisObject.Items);
		
	DocRef = Undefined;
	CurrentData = Items.Documents.CurrentData;
	If CurrentData <> Undefined Then
		DocRef = CurrentData.DocRef;
	EndIf;
	
	FilePrefix = "";
	CurrentDataAttachedDocs = Items.DocumentsAttachedFiles.CurrentData;
	If CurrentDataAttachedDocs <> Undefined Then
		FilePrefix = GetDocPrefix(DocRef, CurrentDataAttachedDocs.NamingFormat);
	EndIf;
	
	Structure.Object.Insert("Ref", DocRef); 
	Structure.Insert("Ref", DocRef);
	Structure.Insert("DocMetaName", CurrentData.DocMetaName);
	Structure.Insert("Branch", CurrentData.Branch);
	Structure.Insert("Company", CurrentData.Company);
	Structure.Insert("Storage", CurrentData.FileStorageVolume);
	Structure.Insert("FilePrefix", FilePrefix);
	Structure.Insert("PrintFormName", CurrentDataAttachedDocs.FilePresention);
	Structure.Insert("MaxSize", CurrentDataAttachedDocs.MaximumFileSize);
	
	Return Structure;
	
EndFunction

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
		Structure.Insert("DocMetaName", SelectionDetailRecords.Name);
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
	Query.SetParameter("CompanyArray", Company.UnloadValues());
	Query.SetParameter("BranchArray", Branch.UnloadValues());
	Query.SetParameter("DocsArray", DocsArray);

	Template = "SELECT Doc.Ref, Doc.Date, Doc.Posted, Doc.Author, Doc.Branch, Doc.Number, Doc.Company, Doc.DeletionMark, ""%1"" %2, VALUETYPE(Doc.Ref) %3 FROM Document.%4 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate %5 %6 %7";
	
	Array = New Array;
	For Each Doc In DocsNamesArray Do
		Array.Add(StrTemplate(
		Template,
		Doc.DocMetaName,
		?(Array.Count(), "", "AS DocMetaName"),
		?(Array.Count(), "", "AS DocumentType"), 
		Doc.DocMetaName,
		?(DocsArray = Undefined, "", "AND Doc.Ref IN (&DocsArray)"),
		?(Company.Count() > 0, "AND Doc.Company IN (&CompanyArray)", ""),
		?(Branch.Count() > 0, "AND Doc.Branch IN (&BranchArray)", "")
		));
	EndDo;

	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF);
	
	Query.Text = QueryTxt;
	
	AllDocumentsTempTable = Query.Execute().Unload();
	Return AllDocumentsTempTable;

EndFunction

&AtServerNoContext
Function GetQueryText()
	QueryTxt = 
	"SELECT
	|	AllDocumentsTempTable.Ref AS DocRef,
	|	AllDocumentsTempTable.Date AS DocDate,
	|	AllDocumentsTempTable.DocMetaName AS DocMetaName,
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
	|	TT_AllDocuments.Company AS Company
	|INTO TT_AllDocumentsAndRequiredAttacments
	|FROM
	|	TT_AllDocuments AS TT_AllDocuments
	|		LEFT JOIN Catalog.AttachedDocumentSettings.FileSettings AS AttachedDocumentSettingsFileSettings
	|		ON TT_AllDocuments.DocMetaName = AttachedDocumentSettingsFileSettings.Ref.Description
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	TT_AllDocumentsAndRequiredAttacments.DocDate AS DocDate,
	|	TT_AllDocumentsAndRequiredAttacments.DocRef AS DocRef,
	|	TT_AllDocumentsAndRequiredAttacments.DocMetaName AS DocMetaName,
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
	|	NULL AS Comment
	|FROM
	|	TT_AllDocumentsAndRequiredAttacments AS TT_AllDocumentsAndRequiredAttacments
	|		LEFT JOIN InformationRegister.AttachedFiles AS AttachedFiles
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AttachedFiles.Owner
	|			AND TT_AllDocumentsAndRequiredAttacments.PrintFormName = AttachedFiles.File.PrintFormName
	|		LEFT JOIN InformationRegister.AuditLock AS AuditLock
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AuditLock.Document
	|
	|UNION ALL
	|
	|SELECT
	|	TT_AllDocumentsAndRequiredAttacments.DocDate,
	|	TT_AllDocumentsAndRequiredAttacments.DocRef,
	|	TT_AllDocumentsAndRequiredAttacments.DocMetaName,
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
	|	AttachedFiledControl.Comment
	|FROM
	|	TT_AllDocumentsAndRequiredAttacments AS TT_AllDocumentsAndRequiredAttacments
	|		INNER JOIN InformationRegister.AttachedFiledControl AS AttachedFiledControl
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AttachedFiledControl.Document
	|TOTALS
	|	MAX(DocDate),
	|	MAX(DocMetaName),
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
	
	Return QueryTxt;
	
EndFunction

&AtServer
Procedure FillDocumentsToControl()
	
	Object.Documents.Clear();
	Object.DocumentsAttachedFiles.Clear();
	
	QueryStructure = PrepareQueryStructure();
	Query = QueryStructure.Query;
	DocsNamesAndStorageStructure = QueryStructure.DocsNamesAndStorageStructure;
	
	FillDocumentsTables(Query, DocsNamesAndStorageStructure);
	
EndProcedure

&AtServer
Function PrepareQueryStructure(DocsArray = Undefined)
	
	DocsToControl = GetArrayMetaDocsToControl(); //Array
	AllDocumentsTempTable = GetAllDocumentsTempTable(DocsToControl, DocsArray);
	DocsNamesAndStorageStructure = New Structure;
	For Each Doc In DocsToControl Do
		DocsNamesAndStorageStructure.Insert(Doc.DocMetaName, Doc.FileStorageVolume);
	EndDo;
	
	Query = New Query();
	Query.Text = GetQueryText();
	Query.SetParameter("AllDocumentsTempTable", AllDocumentsTempTable);
	
	Structure = New Structure;
	Structure.Insert("Query", Query);
	Structure.Insert("DocsNamesAndStorageStructure", DocsNamesAndStorageStructure);
	
	Return Structure;
	
EndFunction

&AtServer
Procedure FillDocumentsTables(Query, DocsNamesAndStorageStructure = Undefined, IsUpdate = False)
	
	QueryResult = Query.Execute();
	SelectionDoc = QueryResult.Select(QueryResultIteration.ByGroups, "DocRef");
	
	While SelectionDoc.Next() Do
		If Not IsUpdate Then
			ParentRow = Object.Documents.Add();
			ParentRow.ID = New UUID;
			ParentRow.FileStorageVolume = DocsNamesAndStorageStructure[SelectionDoc.DocMetaName];
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
			
			If SelectionPrintForm.IsFile Then
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
Procedure UpdateAttachedFiles(DocRef)
	
	CurrentFilesTable.Clear();
	FilesArray = PictureViewerServer.PicturesInfoForSlider(DocRef);
	
	For Each Structure In FilesArray Do
		NewRow = CurrentFilesTable.Add();
		NewRow.File = Structure.FileRef;
		NewRow.Comment = "Click to enlarge!";
	EndDo;

	Query = New Query;
	Query.SetParameter("Document", DocRef);
	Query.Text = 
		"SELECT
		|	AttachedFiledControl.Comment AS Comment
		|FROM
		|	InformationRegister.AttachedFiledControl AS AttachedFiledControl
		|WHERE
		|	AttachedFiledControl.Document = &Document";
	
	QueryResult = Query.Execute();
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		
		NewRow = CurrentFilesTable.Add();
		NewRow.Comment = SelectionDetailRecords.Comment;
		
	EndDo;
	
	
EndProcedure

&AtClıent
Function GetSelectedDocs()
	
	DocsArray = New Array; // Array of DocumentRef
	For Each Row In Items.Documents.SelectedRows Do
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
	OpenForm("DataProcessor.AttachedDocsControl.Form.PictureViewer", Structure, , , , , ,FormWindowOpeningMode.LockOwnerWindow);
	
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
		TemplateFile = SelectionDetailRecords.FileTemplate;
	EndIf;
	
	Return TemplateFile;
	
EndFunction

&AtClient
Procedure ShowSettings(Command)
	
	OpenForm("Catalog.AttachedDocumentSettings.ListForm",,,,,,,FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure AttachOther(Command)

	Message = "Please enter link or any other description";
	
	CurrentDocStructure = GetCurrentDocInTable();
	
	Structure = New Structure;
	Structure.Insert("Company", CurrentDocStructure.Company);
	Structure.Insert("Branch", CurrentDocStructure.Branch);
	Structure.Insert("DocumentType", CurrentDocStructure.DocMetaName);
	Structure.Insert("Document", CurrentDocStructure.Ref);
	
	NotifyDescription = New NotifyDescription("AfterOtherAttachmentInput", ThisObject, Structure);
	ShowInputString(NotifyDescription, "", Message);
	
EndProcedure

&AtClient
Procedure AfterOtherAttachmentInput(Result, AdditionalParameters) Export
	
	If ValueIsFilled(Result) Then
		
		AdditionalParameters.Insert("Comment", Result);
		
		WriteOtherAttachmentInput(AdditionalParameters);
	EndIf;
	
EndProcedure

&AtServerNoContext
Procedure WriteOtherAttachmentInput(Structure)

	RecordManager = InformationRegisters.AttachedFiledControl.CreateRecordManager();
	RecordManager.Company = Structure.Company;
	RecordManager.Branch = Structure.Branch;
	RecordManager.DocumentType = Structure.DocumentType;
	RecordManager.Document = Structure.Document;
	RecordManager.RecordID = New UUID;
	RecordManager.Comment= Structure.Comment;
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
	OpenForm("DataProcessor.AttachedDocsControl.Form.PictureViewer", Structure, , , , , ,FormWindowOpeningMode.LockOwnerWindow);
	
EndProcedure

&AtClient
Procedure CheckModeOnChange(Item)
	
	SetVisibleForCheckMode(CheckMode);
		
EndProcedure 

&AtClient
Procedure SetVisibleForCheckMode(Val IsCheckMode)
	
	Items.DocumentsGroupLockUnlock.Visible = IsCheckMode;
	Items.DecorationFileTemplate.Visible = Not IsCheckMode;
	Items.DocumentsAttachedFiles.Visible = Not IsCheckMode;
	Items.GroupAttachButton.Visible = Not IsCheckMode;
	Items.ShowSettings.Visible = IsCheckMode;

	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	SetVisibleForCheckMode(CheckMode);
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
		Items.Documents.RowFilter = New FixedStructure("IsAuditLock", -1);
	Else
		Items.Documents.RowFilter = Undefined;
	EndIf;
	
EndProcedure

#EndRegion

