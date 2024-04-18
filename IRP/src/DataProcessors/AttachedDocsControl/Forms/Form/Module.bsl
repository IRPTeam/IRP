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
	EndIf;
EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FillDocuments(Command)
	
	FillDocumentsToControl();
	
EndProcedure

&AtClient
Procedure UploadFileDrag(Item, DragParameters, StandardProcessing)
	StandardProcessing = False;
	
	FileArray = New Array();
	If TypeOf(DragParameters.Value) = Type("Array") Then
		FileArray = DragParameters.Value;
	Else
		FileArray.Add(DragParameters.Value);
	EndIf;
	
	CurrentDocStructure = GetCurrentDocInTable();
	
	UploadFiles(FileArray, CurrentDocStructure);
	
EndProcedure

&AtClient
Procedure UploadFileClick(Item, StandardProcessing)
	CurrentDocStructure = GetCurrentDocInTable();
	
	StandardProcessing = False;
	Upload(CurrentDocStructure);
	
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
	Preview = Undefined;
	UpdateAttachedFiles(CurrentData.DocRef);
	
EndProcedure

&AtClient
Procedure CurrentFilesTableOnActivateRow(Item)
	
	CurrentData = Items.CurrentFilesTable.CurrentData;
	If CurrentData = Undefined Then
		Return;
	EndIf;
	ShowPreview(CurrentData.File);	
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
	PictureViewerClient.AddFile(FileRef, StructureParams.Storage, Structure);

EndProcedure

&AtClient
Function FileAttachEmptyStructure()
	
	Structure = New Structure;
	Structure.Insert("FileIDs", New Array);
	Structure.Insert("FileOwner");
	Structure.Insert("FilesStorageVolume");
	Structure.Insert("FilePrefix");
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
	UserNotify = New Array();
	FilesToTransfer = New Array;
	For Each FileRef In FileArray Do
		If Not Await FileRef.File.IsDirectoryAsync() Then
			Size = FileRef.Size();
			byteSize = 1024;
			Size = Format(Size / (byteSize * byteSize), "NFD=3;");
			UserNotify.Add(FileRef.Name + " ( " + Size + "Mb )");
			FilesToTransfer.Add(FileRef);
		EndIf;
	EndDo;
	QueryText = StrTemplate(R().QuestionToUser_022, StrConcat(UserNotify, Chars.LF));
	If Await DoQueryBoxAsync(QueryText, QuestionDialogMode.OKCancel) = DialogReturnCode.OK Then
		
		Structure = FileAttachEmptyStructure();
		Structure.FileIDs = FilesToTransfer;
		Structure.FileOwner = DocStructure.Ref;
		Structure.FilesStorageVolume = DocStructure.Storage;
		Structure.FilePrefix = DocStructure.FilePrefix;
		Structure.PrintFormName = DocStructure.PrintFormName;
		
		AttachFileToOwner(Structure);
	EndIf;
EndProcedure

&AtServer
Procedure ShowPreview(FileRef)
	Preview = PutToTempStorage(FileRef.Preview.Get());
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
	Structure.Insert("Storage", CurrentData.FileStorageVolume);
	Structure.Insert("FilePrefix", FilePrefix);
	Structure.Insert("PrintFormName", CurrentDataAttachedDocs.FilePresention);
	
	Return Structure;
	
EndFunction

&AtServer
Function GetArrayMetaDocsToControl()
	
	ArrayDocsNames = New Array; //Array of Structure
	
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
	Query.SetParameter("CompanySet", Company.Count() > 0);
	Query.SetParameter("CompanyList", Company.UnloadValues());
	Query.SetParameter("DocsArray", DocsArray);

	Template = "SELECT Doc.Ref, Doc.Date, Doc.Posted, Doc.Author, Doc.Branch, Doc.Number, Doc.DeletionMark, ""%1"" %2, VALUETYPE(Doc.Ref) %3 FROM Document.%4 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate %5";
	
	Array = New Array;
	For Each Doc In DocsNamesArray Do
		Array.Add(StrTemplate(
		Template,
		Doc.DocMetaName,
		?(Array.Count(), "", "AS DocMetaName"),
		?(Array.Count(), "", "AS DocumentType"), 
		Doc.DocMetaName,
		?(DocsArray = Undefined, "", "AND Doc.Ref IN (&DocsArray)")
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
	|	AllDocumentsTempTable.Number AS DocNumber
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
	|	AttachedDocumentSettingsFileSettings.FileTooltips AS FileTooltips,
	|	AttachedDocumentSettingsFileSettings.NamingFormat AS NamingFormat,
	|	AttachedDocumentSettingsFileSettings.Required AS Required,
	|	AttachedDocumentSettingsFileSettings.MaximumFileSize AS MaximumFileSize,
	|	AttachedDocumentSettingsFileSettings.FileFormat AS FileFormat
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
	|	CAST(TT_AllDocumentsAndRequiredAttacments.FileTooltips AS STRING(100)) AS FileToolTip,
	|	TT_AllDocumentsAndRequiredAttacments.NamingFormat AS NamingFormat,
	|	TT_AllDocumentsAndRequiredAttacments.Required AS IsRequired,
	|	TT_AllDocumentsAndRequiredAttacments.MaximumFileSize AS MaximumFileSize,
	|	TT_AllDocumentsAndRequiredAttacments.FileFormat AS FileFormat,
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
	|	TT_AllDocumentsAndRequiredAttacments.DocNumber AS DocNumber
	|FROM
	|	TT_AllDocumentsAndRequiredAttacments AS TT_AllDocumentsAndRequiredAttacments
	|		LEFT JOIN InformationRegister.AttachedFiles AS AttachedFiles
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AttachedFiles.Owner
	|			AND TT_AllDocumentsAndRequiredAttacments.PrintFormName = AttachedFiles.File.PrintFormName
	|		LEFT JOIN InformationRegister.AuditLock AS AuditLock
	|		ON TT_AllDocumentsAndRequiredAttacments.DocRef = AuditLock.Document
	|TOTALS
	|	MAX(DocDate),
	|	MAX(DocMetaName),
	|	MAX(FileToolTip),
	|	MAX(NamingFormat),
	|	MAX(IsRequired),
	|	MAX(MaximumFileSize),
	|	MAX(FileFormat),
	|	MAX(IsFile),
	|	MAX(IsAuditLock),
	|	MAX(Author),
	|	MAX(Branch),
	|	MAX(DocNumber)
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
	
	//DocsToControl = GetArrayMetaDocsToControl(); //Array
	//If DocsToControl.Count() = 0 Then
	//	Return;
	//EndIf;
	//	
	//AllDocumentsTempTable = GetAllDocumentsTempTable(DocsToControl);
	//
	//DocsNamesAndStorageStructure = New Structure;
	//For Each Doc In DocsToControl Do
	//	DocsNamesAndStorageStructure.Insert(Doc.DocMetaName, Doc.FileStorageVolume);
	//EndDo;
	//	
	//Query = New Query();
	//Query.Text = GetQueryText();
	//Query.SetParameter("AllDocumentsTempTable", AllDocumentsTempTable);
	
	FillDocumentsTables(Query, DocsNamesAndStorageStructure, );
	
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
			ParentRow.FillChecking = 0;	//Doc has no files
		ElsIf IsFile < RequiredPrintForms Then
			ParentRow.FillChecking = 1;	//Doc has not enough files
		ElsIf IsFile = RequiredPrintForms Then
			ParentRow.FillChecking = 2;	//Good. Doc has all files
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
	EndDo;
	
EndProcedure

&AtClient
Procedure HideLegendOnChange(Item)
	
	SetVisibleToLegend(Not HideLegend);
	
EndProcedure

&AtClient
Procedure SetVisibleToLegend(IsVisible)
	
	Items.GroupLegend.Visible = IsVisible;
	
EndProcedure

&AtClıent
Function GetSelectedDocs()
	
	DocsArray = New Array;
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
	Query = PrepareQueryStructure(DocsArray).Query;
	FillDocumentsTables(Query, , True);
	
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
	Query = PrepareQueryStructure(DocsArray).Query;
	FillDocumentsTables(Query, , True);
EndProcedure

#EndRegion

