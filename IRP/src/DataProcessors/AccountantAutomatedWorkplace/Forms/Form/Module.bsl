
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	DocumentList.Parameters.Items[0].Value = SessionParameters.CurrentUser;
	DocumentList.Parameters.Items[0].Use = True;
	
	ReadVisibility();

EndProcedure

#EndRegion

#Region FormCommandsEventHandlers

&AtClient
Procedure FindDocuments(Command)
	Items.FindDocuments.BackColor = Items.FormRefreshJE.BackColor;
	SetListFilterAtServer();
EndProcedure

&AtClient
Procedure Lock(Command)
	ChangedDocs = LockAtServer();
	For Each Doc In ChangedDocs Do
		NotifyChanged(Doc);
		Notify("DataChanged", Doc);
	EndDo;
EndProcedure

&AtClient
Procedure Unlock(Command)
	ChangedDocs = UnlockAtServer();
	For Each Doc In ChangedDocs Do
		NotifyChanged(Doc);
		Notify("DataChanged", Doc);
	EndDo;
EndProcedure

&AtClient
Procedure RefreshJE(Command)
	JournalEntry = Undefined;
	If Items.DocumentList.CurrentData <> Undefined Then
		JournalEntry = Items.DocumentList.CurrentData.JournalEntry;
	EndIf;
	AccountingReport = GetJournalReport(JournalEntry);
EndProcedure

&AtClient
Procedure OpenJE(Command)
	If Items.DocumentList.CurrentData <> Undefined Then
		JournalEntry = Items.DocumentList.CurrentData.JournalEntry;
		If ValueIsFilled(JournalEntry) Then
			OpenValueAsync(JournalEntry);
		EndIf;
	EndIf;
EndProcedure

&AtClient
Procedure OpenSettings(Command)
	OpenForm("DataProcessor.AccountantAutomatedWorkplace.Form.FormSettings",, 
		ThisObject,,,, 
		New CallbackDescription("OpenSettingsFinish", ThisObject), 
		FormWindowOpeningMode.LockWholeInterface);
EndProcedure

&AtClient
Procedure OpenSettingsFinish(Result, AddInfo) Export
	ReadVisibility();
EndProcedure

&AtClient
Procedure AttachFiles(Command)
	AttachFilesAtClient();
EndProcedure

&AtClient
Procedure SendMessage(Command)
	SendMessageAtServer();
EndProcedure

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure FilterOnChange(Item)
	//Items.FindDocuments.BackColor = New Color(255, 255, 153);
EndProcedure

&AtClient
Procedure DocumentTypeStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	Callback = New CallbackDescription("DoumentTypeChoiseEnd", ThisObject);
	FormParameters = New Structure();
	Settings = New Structure();
	Settings.Insert("StartDate"  , ThisObject.Period.StartDate);
	Settings.Insert("EndDate"    , ThisObject.Period.EndDate);
	Settings.Insert("Company"    , ThisObject.Company);
	Settings.Insert("LedgerType" , ThisObject.LedgerType);
	FormParameters.Insert("Settings", Settings);
	SelectedDocumentTypes = New Array();
	For Each Row In ThisObject.DocumentType Do
		SelectedDocumentTypes.Add(Row.Value);
	EndDo;
	FormParameters.Insert("SelectedDocumentTypes", SelectedDocumentTypes);
	
	OpenForm("DataProcessor.AccountantAutomatedWorkplace.Form.DocumentTypeChoiseForm", 
		FormParameters, ThisObject, , , , Callback, FormWindowOpeningMode.LockOwnerWindow);
EndProcedure

&AtClient
Procedure DoumentTypeChoiseEnd(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	ThisObject.DocumentType.Clear();
	For Each Row In Result.SelectedDocumentTypes Do
		ThisObject.DocumentType.Add(Row.Value, Row.Presentation);
	EndDo;
EndProcedure

&AtClient
Procedure DocumentListOnActivateRow(Item)
	
	If Items.DocumentList.CurrentData <> Undefined Then
		If CurrentDocument <> Items.DocumentList.CurrentData.Document Then
			DocumentInfo = GetDocumentInfo(
				Items.DocumentList.CurrentData.Document, 
				Items.DocumentList.CurrentData.JournalEntry,
				VisibleSettings);
			SetDocumentInfoAtClient(DocumentInfo);
			CurrentDocument = Items.DocumentList.CurrentData.Document;
		EndIf;
	ElsIf Not InfoUpdated Then
		DocumentInfo = GetDocumentInfo(Undefined, Undefined, VisibleSettings);
		SetDocumentInfoAtClient(DocumentInfo);
		InfoUpdated = True;
	EndIf;

EndProcedure

&AtClient
Procedure AttachedFilesStartChoice(Item, ChoiceData, ChoiceByAdding, StandardProcessing)
	StandardProcessing = False;
	AttachFilesAtClient();
EndProcedure

&AtClient
Procedure AttachedFilesOnChange(Item)
	Items.ChatAttachedFiles.Visible = (ChatAttachedFiles.Count() > 0);
EndProcedure

&AtClient
Procedure ChatOnClick(Item, EventData, StandardProcessing)
	StandardProcessing = False;
	If IsBlankString(EventData.Href) Then
		Return;
	EndIf;
	If StrStartsWith(EventData.Href, "e1c:") Then
		GotoURL("e1cib/data/" + StrSplit(EventData.Href, "/")[StrSplit(EventData.Href, "/").UBound()]);
	ElsIf StrStartsWith(EventData.Href, "e1cib") Then
		GotoURL(EventData.Href);
	ElsIf StrStartsWith(EventData.Href, "attached-file:") Then
		DownloadFileAtClient(StrReplace(EventData.Href, "attached-file:", ""));
	EndIf;
EndProcedure

&AtClient
Procedure HistoryVersionTableOnActivateRow(Item)
	
	CurrentVersionData = Items.HistoryVersionTable.CurrentData;
	If CurrentVersionData = Undefined Then
		Return;
	EndIf;
	
	ReadVersionDifference(CurrentVersionData.VersionNumber);

EndProcedure

&AtClient
Procedure ShowFilePreviewOnChange(Item)
	Items.FilePreviewPages.Visible = ShowFilePreview;
	FileTableOnActivateRow(Item);
EndProcedure

&AtClient
Procedure FileTableOnActivateRow(Item)
	
//	Items.NoFilePage.Visible = True;
//	Items.PDFPage.Visible = False;
//	Items.ImagePage.Visible = False;
	
	Items.FilePreviewPages.CurrentPage = Items.NoFilePage;
	
	If Not ShowFilePreview Then
		Return;
	EndIf;
	
	If Items.FileTable.CurrentData = Undefined Then
		Return;
	EndIf;
	
	If Items.FileTable.CurrentData.isPDF Then
		PictureViewerClient.SetPDFForView(Items.FileTable.CurrentData.Ref, PDFPreview);
//		Items.NoFilePage.Visible = False;
//		Items.PDFPage.Visible = True;
		Items.FilePreviewPages.CurrentPage = Items.PDFPage;
	Else
		PictureParameters = PictureViewerServer.CreatePictureParameters(Items.FileTable.CurrentData.Ref);
		ImagePreview = PictureViewerClient.GetPictureURL(PictureParameters);
//		Items.NoFilePage.Visible = False;
//		Items.ImagePage.Visible = True;
		Items.FilePreviewPages.CurrentPage = Items.ImagePage;
	EndIf;

EndProcedure

&AtClient
Procedure FileTableSelection(Item, RowSelected, Field, StandardProcessing)
	//TODO: Insert the handler content
EndProcedure

#EndRegion

#Region Private

&AtServer
Procedure ReadVisibility()
	
	VisibleSettings = DataProcessors.AccountantAutomatedWorkplace.GetSettings();

	Items.LedgerType.Visible = VisibleSettings.Filter_LedgerType;
	Items.DocumentType.Visible = VisibleSettings.Filter_DocumentType;
	Items.LockType.Visible = VisibleSettings.Filter_LockType;
	Items.FilesType.Visible = VisibleSettings.Filter_FilesType;
	Items.TasksType.Visible = VisibleSettings.Filter_TasksType;
	
	Items.GroupReport.Visible = VisibleSettings.Panel_GroupReport;
	Items.GroupFiles.Visible = VisibleSettings.Panel_GroupFiles;
	Items.GroupChat.Visible = VisibleSettings.Panel_GroupChat;
	Items.GroupHistory.Visible = VisibleSettings.Panel_GroupHistory;
	
	Items.DocumentListTaskIcon.Visible = VisibleSettings.Filter_TasksType;
	
EndProcedure

&AtServer
Procedure SetListFilterAtServer()
	
	QuerySchemaAPI = DynamicListAPI.Get(DocumentList);
	DynamicListAPI.ClearFilter(QuerySchemaAPI);
	
	If Period.EndDate > Date(1,1,1) Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Registry.Date Between &StartDate AND &EndDate");
	EndIf;
	If Not Company.IsEmpty() Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Registry.Document.Company = &Company");
	EndIf;
	If Not LedgerType.IsEmpty() Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "JournalEntry.LedgerType = &LedgerType");
	EndIf;
	If LockType = 1 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Not AuditLock.Document IS NULL");
	ElsIf LockType = 2 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "AuditLock.Document IS NULL");
	EndIf;
	If FilesType = 1 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Not AttachedFiles.File IS NULL");
	ElsIf FilesType = 2 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "AttachedFiles.File IS NULL");
	EndIf;
	If TasksType = 1 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Not DocTasks.ExecutionObject IS NULL");
	ElsIf TasksType = 2 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "DocTasks.MyTask = TRUE");
	EndIf;
	If ThisObject.DocumentType.Count() > 0 Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "ValueType(Registry.Document) in (&ArrayOfDocumentTypes)");
	EndIf;
	
	DynamicListAPI.Set(QuerySchemaAPI);
	
	If Period.EndDate > Date(1,1,1) Then
		DocumentList.Parameters.SetParameterValue("StartDate", Period.StartDate);
		DocumentList.Parameters.SetParameterValue("EndDate", Period.EndDate); 
	EndIf;
	If Not Company.IsEmpty() Then
		DocumentList.Parameters.SetParameterValue("Company", Company);
	EndIf;
	If Not LedgerType.IsEmpty() Then
		DocumentList.Parameters.SetParameterValue("LedgerType", LedgerType);
	EndIf;
	If ThisObject.DocumentType.Count() > 0 Then
		ArrayOfDocumentTypes = New Array();
		For Each Row In ThisObject.DocumentType Do
			ArrayOfDocumentTypes.Add(Type("DocumentRef." + Row.Value));
		EndDo;
		DocumentList.Parameters.SetParameterValue("ArrayOfDocumentTypes", ArrayOfDocumentTypes);
	EndIf;

	InfoUpdated = False;
EndProcedure

&AtServer
Function LockAtServer()
	
	ChangedDocs = New Array;
	
	For Each SelectedRow In Items.DocumentList.SelectedRows Do
		LockIsSet = AuditLockPrivileged.LockIsSet(SelectedRow.Document);
		If Not LockIsSet Then
			AuditLockPrivileged.SetLock(SelectedRow.Document);
			ChangedDocs.Add(SelectedRow.Document);
		EndIf;
	EndDo;

	Return ChangedDocs;
	
EndFunction

&AtServer
Function UnlockAtServer()
	
	ChangedDocs = New Array;
	
	For Each SelectedRow In Items.DocumentList.SelectedRows Do
		LockIsSet = AuditLockPrivileged.LockIsSet(SelectedRow.Document);
		If LockIsSet Then
			AuditLockPrivileged.UnsetLock(SelectedRow.Document);
			ChangedDocs.Add(SelectedRow.Document);
		EndIf;
	EndDo;

	Return ChangedDocs;
	
EndFunction

// Load document info.
// 
// Parameters:
//  DocumentRef - DocumentRef, Undefined - Document ref
//  JournalEntryRef - DocumentRef.JournalEntry, Undefined - Journal entry ref
//  VisibleSettings - See DataProcessors.AccountantAutomatedWorkplace.GetSettings
// 
// Returns:
//  Structure - Load document info:
// * JournalEntry - Undefined - 
// * Files - Array - 
// * ChatInfo - See GetChatInfo 
// * HistoryTable - Array - 
&AtServerNoContext
Function GetDocumentInfo(DocumentRef, JournalEntryRef, VisibleSettings)
	Result = New Structure;
	Result.Insert("JournalEntry", Undefined);
	Result.Insert("Files", New Array);
	Result.Insert("ChatInfo", Undefined);
	Result.Insert("HistoryTable", New Array);
	
	If VisibleSettings.Panel_GroupReport Then
		Result.JournalEntry = GetJournalReport(JournalEntryRef);
	EndIf;
	
	If VisibleSettings.Panel_GroupFiles Then
		Result.Files = GetDocumentFiles(DocumentRef);
	EndIf;
	
	If VisibleSettings.Panel_GroupChat Then
		Result.ChatInfo = GetChatInfo(DocumentRef);
	EndIf;
	
	If VisibleSettings.Panel_GroupHistory Then
		Result.HistoryTable = GetDocumentHistory(DocumentRef);
	EndIf;
	
	Return Result;
EndFunction

&AtServerNoContext
Function GetJournalReport(JournalEntryRef)
	
	Result = New SpreadsheetDocument();
	
	Template = DataProcessors.AccountantAutomatedWorkplace.GetTemplate("PrintFormJE");
	Result.Put(Template.GetArea("Header"));
	
	Query = New Query;
	Query.SetParameter("DocumentRef", JournalEntryRef);
	Query.Text =
	"SELECT ALLOWED
	|	BasicRecordsWithExtDimensions.LineNumber,
	|	BasicRecordsWithExtDimensions.AccountDr,
	|	BasicRecordsWithExtDimensions.ExtDimensionDr1,
	|	BasicRecordsWithExtDimensions.ExtDimensionDr2,
	|	BasicRecordsWithExtDimensions.ExtDimensionDr3,
	|	BasicRecordsWithExtDimensions.CurrencyDr,
	|	BasicRecordsWithExtDimensions.CurrencyAmountDr,
	|	BasicRecordsWithExtDimensions.QuantityDr,
	|	BasicRecordsWithExtDimensions.AccountCr,
	|	BasicRecordsWithExtDimensions.ExtDimensionCr1,
	|	BasicRecordsWithExtDimensions.ExtDimensionCr2,
	|	BasicRecordsWithExtDimensions.ExtDimensionCr3,
	|	BasicRecordsWithExtDimensions.CurrencyCr,
	|	BasicRecordsWithExtDimensions.CurrencyAmountCr,
	|	BasicRecordsWithExtDimensions.QuantityCr,
	|	BasicRecordsWithExtDimensions.Amount
	|FROM
	|	AccountingRegister.Basic.RecordsWithExtDimensions(,, Recorder = &DocumentRef,,) AS BasicRecordsWithExtDimensions
	|
	|ORDER BY
	|	BasicRecordsWithExtDimensions.LineNumber";
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Row = Template.GetArea("Row");
		Row.Parameters.Fill(QuerySelection);
		Result.Put(Row);
	EndDo;
	
	Return Result;
	
EndFunction

// Get file description.
// 
// Returns:
//  Structure - Get file description:
// * Ref - CatalogRef.Files - 
// * Name - String - 
// * isPDF - Boolean - 
&AtClientAtServerNoContext
Function GetFileDescription()
	FileDescription = New Structure;
	FileDescription.Insert("Ref", PredefinedValue("Catalog.Files.EmptyRef"));
	FileDescription.Insert("Name", "");
	FileDescription.Insert("isPDF", False);
	Return FileDescription;
EndFunction

// Get document files.
// 
// Parameters:
//  DocumentRef - DocumentRef, Undefined - Document ref
// 
// Returns:
//  Array of See GetFileDescription - Get document files 
&AtServerNoContext
Function GetDocumentFiles(DocumentRef)
	
	Result = New Array; // Array of See GetFileDescription
	
	If DocumentRef = Undefined Then
		Return Result;
	EndIf;
	
	Query = New Query;
	Query.SetParameter("DocumentRef", DocumentRef);
	Query.Text =
	"SELECT
	|	AttachedFiles.File,
	|	AttachedFiles.File.Extension AS Extension,
	|	AttachedFiles.File.Description AS Name
	|FROM
	|	InformationRegister.AttachedFiles AS AttachedFiles
	|WHERE
	|	AttachedFiles.Owner = &DocumentRef";
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		If Not StrCompare(QuerySelection.Extension, "pdf") Then
			FileRecord = GetFileDescription();
			FileRecord.Ref = QuerySelection.File;
			FileRecord.Name = QuerySelection.Name;
			FileRecord.isPDF = True;
			Result.Add(FileRecord);
		ElsIf PictureViewerServer.isImage(QuerySelection.Extension) Then
			FileRecord = GetFileDescription();
			FileRecord.Ref = QuerySelection.File;
			FileRecord.Name = QuerySelection.Name;
			FileRecord.isPDF = False;
			Result.Add(FileRecord);
		EndIf;
	EndDo;
	
	Return Result;
	
EndFunction

// Get history item.
// 
// Returns:
//  Structure - Get history item:
// * VersionNumber - Number - 
// * UserName - String - 
// * Date - Date - 
// * DataChangeType - String - 
// * IsImportant - Boolean - 
&AtClientAtServerNoContext
Function GetHistoryItem()
	Result = New Structure;
	Result.Insert("VersionNumber", 0); 
	Result.Insert("UserName", ""); 
	Result.Insert("Date", Date(1,1,1)); 
	Result.Insert("DataChangeType", ""); 
	Result.Insert("IsImportant", False); 
	Return Result;
EndFunction
	
// Get document history.
// 
// Parameters:
//  DocumentRef - DocumentRef, Undefined - Document ref
// 
// Returns:
//  Array of See GetHistoryItem - Get document history 
&AtServerNoContext
Function GetDocumentHistory(DocumentRef)
	
	Result = New Array; // Array of See GetHistoryItem
	
	If Not ValueIsFilled(DocumentRef) Then
		Return Result;
	EndIf;
	
	SetPrivilegedMode(True);
	
	ImportantTableAttributes = 
		CatConfigurationMetadataServer.GetCustomizedAttributesByObject(DocumentRef).Important;
	
	Try
		DataHistory.UpdateHistory();
		HistoryTable = DataHistory.SelectVersions(New Structure("Data", DocumentRef),, "VersionNumber");
		For Each HistoryRow In HistoryTable Do
			NewVersion = GetHistoryItem();
			FillPropertyValues(NewVersion, HistoryRow);
			CheckImportantAttributesInVersion(DocumentRef, NewVersion, ImportantTableAttributes);
			Result.Add(NewVersion);
		EndDo;
	Except
		// don't have permission to read history
	EndTry;
	
	Return Result;
	
EndFunction

&AtServerNoContext
Procedure CheckImportantAttributesInVersion(DocumentRef, NewVersion, ImportantTableAttributes)
	
	If NewVersion.DataChangeType = "Add" OR NewVersion.VersionNumber = 1 Then
		Return;
	EndIf;
	
	VersionDifference = DataHistory.GetVersionDifferences(DocumentRef, NewVersion.VersionNumber);
	
	Tables = New Structure;
	Attributes = New Structure;
	For Each VersionDifferenceItem In VersionDifference Do
		If TypeOf(VersionDifferenceItem.Value) = Type("FixedStructure") Then
			Attributes.Insert(VersionDifferenceItem.Key, VersionDifferenceItem.Value);
		ElsIf TypeOf(VersionDifferenceItem.Value) = Type("FixedArray") Then
			Tables.Insert(VersionDifferenceItem.Key, VersionDifferenceItem.Value);
		EndIf;
	EndDo;
	
	ImportantAttributes = ImportantTableAttributes.Get(""); // Array of String
	If Attributes.Count() Then
		For Each AttributKeyValue In Attributes Do
			If ImportantAttributes <> Undefined And ImportantAttributes.Find(AttributKeyValue.Key) <> Undefined Then
				NewVersion.IsImportant = True;
				Return;
			EndIf;
		EndDo;
	EndIf;
	
	For Each TableKeyValue In Tables Do
		If TableKeyValue.Value.Count() = 0 Then
			Continue;
		EndIf;
		ImportantAttributes = ImportantTableAttributes.Get(TableKeyValue.Key); // Array of String
		For Each FieldKeyValue In TableKeyValue.Value[0].Fields Do
			If ImportantAttributes <> Undefined And ImportantAttributes.Find(FieldKeyValue.Key) <> Undefined Then
				NewVersion.IsImportant = True;
				Return;
			EndIf;
		EndDo;
	EndDo;
	
EndProcedure

// Get chat info.
// 
// Parameters:
//  DocumentRef - DocumentRef, Undefined - Document ref
// 
// Returns:
//  Structure - Get chat info:
// * Count - Number - 
// * HTML - String - 
&AtServerNoContext
Function GetChatInfo(DocumentRef)
	
	Result = New Structure;
	Result.Insert("Count", 0);
	Result.Insert("HTML", "");
	
	Query = New Query;
	Query.SetParameter("Basis", DocumentRef);
	Query.SetParameter("CurrentUser", SessionParameters.CurrentUser);
	
	Query.Text =
	"SELECT
	|	Logger.Period AS Period,
	|	REFPRESENTATION(Logger.User) AS User,
	|	Logger.User = &CurrentUser AS CurrentUser,
	|	Logger.Comment AS Message,
	|	Logger.ManualComment,
	|	Logger.NotifyID,
	|	Logger.MessageID
	|FROM
	|	InformationRegister.Logger AS Logger
	|WHERE
	|	Logger.Basis = &Basis
	|
	|ORDER BY
	|	Period,
	|	Logger.TimeStamp";
	ChatMessages = Query.Execute().Unload();	
	Data = CommonFunctionsServer.TableToStructure(ChatMessages);
	Result.Count = Data.Count();
	
	Query.Text =
	"SELECT
	|	LoggerNotification.NotifyID,
	|	REFPRESENTATION(LoggerNotification.User) AS User,
	|	LoggerNotification.SendEmail,
	|	LoggerNotification.Sended,
	|	LoggerNotification.UserRead,
	|	LoggerNotification.WaitForOpenRef,
	|	LoggerNotification.RefOpened
	|FROM
	|	InformationRegister.LoggerNotification AS LoggerNotification
	|WHERE
	|	LoggerNotification.Basis = &Basis";
	ChatNotify = Query.Execute().Unload();
	
	Query.Text =
	"SELECT
	|	LoggerFiles.MessageID,
	|	""attached-file:"" + LoggerFiles.FileID AS FileID,
	|	LoggerFiles.FileName AS SourceFileName,
	|	LoggerFiles.FileSize
	|FROM
	|	InformationRegister.LoggerFiles AS LoggerFiles
	|WHERE
	|	LoggerFiles.Basis = &Basis";
	ChatFiles = Query.Execute().Unload();
	ChatFiles.Columns.Add("FileName");
	ChatFiles.Columns.Add("Icon");
	Base64 = Base64String(PictureLib.DownloadFile.GetBinaryData());
	Base64 = StrReplace(Base64, Char(13), "");
	Base64 = StrReplace(Base64, Char(10), "");
	IconURL = "data:image\jpg;base64," + Base64;
	For Each Row In ChatFiles Do
		Row.FileName = StrTemplate("%1 (%2)", 
			Row.SourceFileName, CommonFunctionsClientServer.GetSizePresentation(Row.FileSize));
		Row.Icon = IconURL;
	EndDo;
	
	For Each Msg In Data Do
		If Not IsBlankString(Msg.NotifyID) Then
			ObjectNotify = ChatNotify.Copy(New Structure("NotifyID", Msg.NotifyID));
			Msg.Insert("Notify", CommonFunctionsServer.TableToStructure(ObjectNotify));
		EndIf;
		
		MessageFiles = ChatFiles.Copy(New Structure("MessageID", Msg.MessageID));
		If MessageFiles.Count() > 0 Then
			Msg.Insert("AttachedFiles", CommonFunctionsServer.TableToStructure(MessageFiles));
		EndIf;
	EndDo;
	
	JSON = CommonFunctionsServer.SerializeJSON(Data);
	Template = DataProcessors.Chat.GetTemplate("ChatHTML").GetText();
	ChatHTML = StrReplace(Template, "#MessageArray#", JSON);
	ChatHTML = StrReplace(ChatHTML, "#LocalCode#", StrReplace(GetInfoBaseRegionalSettings().LocaleCode, "_", "-"));
	
	Result.HTML = ChatHTML;
	
	Return Result;
	
//	If Not ChatHTML = Chat Then
//		Chat = ChatHTML;
//	EndIf;
//	
//	Items.ChatAttachedFiles.Visible = (ChatAttachedFiles.Count() > 0);
EndFunction

// Set document info at client.
// 
// Parameters:
//  DocumentInfo - See GetDocumentInfo
&AtClient
Procedure SetDocumentInfoAtClient(DocumentInfo)
	
	If VisibleSettings.Panel_GroupReport Then
		AccountingReport = DocumentInfo.JournalEntry;
	EndIf;
	
	FilesCount = 0;
	FileTable.Clear();
	If VisibleSettings.Panel_GroupFiles Then
		For Each FileDescription In DocumentInfo.Files Do
			FillPropertyValues(FileTable.Add(), FileDescription);
		EndDo;
		FilesCount = FileTable.Count();
	EndIf;
	
	ChatAttachedFiles.Clear();
	Items.ChatAttachedFiles.Visible = False;
	If VisibleSettings.Panel_GroupChat Then
		Chat = DocumentInfo.ChatInfo.HTML;
		ChatCount = DocumentInfo.ChatInfo.Count;
	EndIf;
	
	HistoryCount = 0;
	HistoryVersionTable.Clear();
	HistoryReport = New SpreadsheetDocument();
	If VisibleSettings.Panel_GroupHistory Then
		For Each HistoryItem In DocumentInfo.HistoryTable Do
			FillPropertyValues(HistoryVersionTable.Add(), HistoryItem);
		EndDo;
		HistoryCount = HistoryVersionTable.Count();
	EndIf;
	
EndProcedure

&AtClient
Procedure AttachFilesAtClient()
	OpenFileDialog = New FileDialog(FileDialogMode.Open);
	OpenFileDialog.CheckFileExistence = True;
	OpenFileDialog.Multiselect = True;
	CallbackParams = New Structure("UUID", ThisObject.UUID);
	Callback = New CallbackDescription("AttachFilesEnd", ThisObject, CallbackParams);	
	OpenFileDialog.Show(Callback);
EndProcedure

&AtClient
Procedure AttachFilesEnd(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	For Each PathToFile In Result Do
		FileDescription = FilesClientServer.GetStoredFileDescriptionWrapper(PathToFile);
		CallbackParams = New Structure("FileDescription", FileDescription);
		Callback = New CallbackDescription("FilesUploaded", ThisObject, CallbackParams);
		BeginPutFileToServer(Callback, , , , PathToFile, Params.UUID);
	EndDo;
EndProcedure

&AtClient
Procedure FilesUploaded(Result, Params) Export
	If Result = Undefined Then
		Return;
	EndIf;
	
	FilePresentation = StrTemplate("%1 (%2)", 
			Params.FileDescription.FileRef.Name, 
			CommonFunctionsClientServer.GetSizePresentation(Params.FileDescription.Size));
	
	ChatAttachedFiles.Add(
		New Structure("Address, FileDescription", Result.Address, Params.FileDescription), 
		FilePresentation, 
		False, 
		PictureLib.Attach);
		
	Items.ChatAttachedFiles.Visible = (ChatAttachedFiles.Count() > 0);
	
EndProcedure

&AtServer
Procedure SendMessageAtServer()
	
	LoggerServerCall.AddLog(CurrentDocument, NewMessage, ChatAttachedFiles, True);
	
	NewMessage = "";
	ChatAttachedFiles.Clear();
	
	ChatInfo = GetChatInfo(CurrentDocument);
	Chat = ChatInfo.HTML;
	ChatCount = ChatInfo.Count;
	
EndProcedure	

&AtClient
Async Procedure DownloadFileAtClient(FileID)
	FileInfo = DownloadFileAtServer(FileID, ThisObject.UUID);
	If FileInfo <> Undefined Then
		Dialog = New GetFilesDialogParameters();
		Await GetFileFromServerAsync(FileInfo.Address, FileInfo.FileName, Dialog);
	EndIf;
EndProcedure

&AtServer
Function DownloadFileAtServer(FileID, FormUUID)
	Query = New Query();
	Query.Text = 
	"SELECT TOP 1
	|	LoggerFiles.File,
	|	LoggerFiles.FileName,
	|	LoggerFiles.FileSize
	|FROM
	|	InformationRegister.LoggerFiles AS LoggerFiles
	|WHERE
	|	LoggerFiles.FileID = &FileID";
	Query.SetParameter("FileID", FileID);
	QuerySelection = Query.Execute().Select();
	If QuerySelection.Next() Then
		Address = PutToTempStorage(QuerySelection.File.Get(), FormUUID);
		Return New Structure("Address, FileName", Address, QuerySelection.FileName);
	EndIf;
	Return Undefined;
EndFunction

&AtServer
Procedure ReadVersionDifference(VersionNumber)
	HistoryReport.Clear();
	
	Tables = New Structure;
	Attributes = New Structure;
	
	AttributeNames = CatConfigurationMetadataServer.GetAttributeNamesByObject(CurrentDocument);
	ImportantTableAttributes = 
		CatConfigurationMetadataServer.GetCustomizedAttributesByObject(CurrentDocument).Important;
	
	VersionDifference = DataHistory.GetVersionDifferences(CurrentDocument, VersionNumber);
	For Each VersionDifferenceItem In VersionDifference Do
		If TypeOf(VersionDifferenceItem.Value) = Type("FixedStructure") Then
			Attributes.Insert(VersionDifferenceItem.Key, VersionDifferenceItem.Value);
		ElsIf TypeOf(VersionDifferenceItem.Value) = Type("FixedArray") Then
			Tables.Insert(VersionDifferenceItem.Key, VersionDifferenceItem.Value);
		EndIf;
	EndDo;
	
	Template = DataProcessors.AccountantAutomatedWorkplace.GetTemplate("PrintHistory");
	
	If Attributes.Count() Then
		ImportantAttributes = ImportantTableAttributes.Get(""); // Array of String
	    HistoryReport.Put(Template.GetArea("AttributeHeader"));
		For Each AttributKeyValue In Attributes Do
			AttributeName = AttributeNames.Attributes.Get(AttributKeyValue.Key);
			If AttributeName = Undefined or AttributeName = "" Then
				AttributeName = AttributKeyValue.Key;
			EndIf;
			
			AttributeValueNew = AttributKeyValue.Value.ValueAfterChange;
			If TypeOf(AttributKeyValue.Value.ValueAfterChange) = Type("FixedStructure") Then
				AttributeValueNew = Undefined;
				If AttributKeyValue.Value.ValueAfterChange.Property("Presentation") Then
					AttributeValueNew = AttributKeyValue.Value.ValueAfterChange.Presentation;
				ElsIf AttributKeyValue.Value.ValueAfterChange.Property("Ref") Then
					AttributeValueNew = AttributKeyValue.Value.ValueAfterChange.Ref;
				EndIf;
			EndIf;
			
			If AttributKeyValue.Value.Property("ValueBeforeChange") Then
				AttributeValueOld = AttributKeyValue.Value.ValueBeforeChange;
				If TypeOf(AttributKeyValue.Value.ValueBeforeChange) = Type("FixedStructure") Then
					AttributeValueOld = Undefined;
					If AttributKeyValue.Value.ValueBeforeChange.Property("Presentation") Then
						AttributeValueOld = AttributKeyValue.Value.ValueBeforeChange.Presentation;
					ElsIf AttributKeyValue.Value.ValueBeforeChange.Property("Ref") Then
						AttributeValueOld = AttributKeyValue.Value.ValueBeforeChange.Ref;
					EndIf;
				EndIf;
			Else
				AttributeValueOld = Undefined;
			EndIf;
			
			Row = Template.GetArea("AttributeRow");
			Row.Parameters.Name = AttributeName;
			Row.Parameters.ValueBefore = AttributeValueOld;
			Row.Parameters.ValueAfter = AttributeValueNew;
			If ImportantAttributes <> Undefined And ImportantAttributes.Find(AttributKeyValue.Key) <> Undefined Then
				Row.Area(1, 1, 1, 4).TextColor = WebColors.Red;
			EndIf;
			HistoryReport.Put(Row);
		EndDo;
	EndIf;
	
	For Each TableKeyValue In Tables Do
		If TableKeyValue.Value.Count() = 0 Then
			Continue;
		EndIf;
		
		ImportantAttributes = ImportantTableAttributes.Get(TableKeyValue.Key); // Array of String
		TableAttributeNames = AttributeNames.Tables.Get(TableKeyValue.Key);
		
		If TableAttributeNames = Undefined Then
			TableAttributeNames = New Structure("Synonym, Attributes", "", New Map);
		EndIf;
		TableName = TableAttributeNames.Synonym;
		If TableName = "" Then
			TableName = TableKeyValue.Key;
		EndIf;
		
		TableHeader = Template.GetArea("TableHeader");
		TableHeader.Parameters.TableName = TableName;
		HistoryReport.Put(TableHeader);
		
		TableHeader = New SpreadsheetDocument;
		TableHeader.Put(Template.GetArea("NumberHeader"));
		For Each FieldKeyValue In TableKeyValue.Value[0].Fields Do
			AttributeName = TableAttributeNames.Attributes.Get(FieldKeyValue.Key);
			If AttributeName = Undefined or AttributeName = "" Then
				AttributeName = FieldKeyValue.Key;
			EndIf;
			FieldHeader = Template.GetArea("FieldHeader");
			FieldHeader.Parameters.FieldName = AttributeName;
			TableHeader.Join(FieldHeader);
		EndDo;
		HistoryReport.Put(TableHeader);
		
		For Each TableRecord In TableKeyValue.Value Do
			TableRow = New SpreadsheetDocument;
			
			NumberRow = Template.GetArea("NumberRow");
			NumberRow.Parameters.Number = TableRecord.LineNumberAfterVersionChange;
			TableRow.Put(NumberRow);
			For Each FieldKeyValue In TableRecord.Fields Do
				FieldValueOld = Undefined;
				FieldValue = FieldKeyValue.Value;
				If TypeOf(FieldValue) = Type("FixedStructure") Then
					If FieldValue.Property("Presentation") Then
						FieldValue = FieldValue.Presentation;
					ElsIf FieldValue.Property("Ref") Then
						FieldValue = FieldValue.Ref;
					ElsIf FieldValue.Property("ValueAfterChange") Then
						FieldValuesAll = FieldValue;
						FieldValue = FieldValuesAll.ValueAfterChange;
						If TypeOf(FieldValue) = Type("FixedStructure") Then
							If FieldValue.Property("Presentation") Then
								FieldValue = FieldValue.Presentation;
							ElsIf FieldValue.Property("Ref") Then
								FieldValue = FieldValue.Ref;
							EndIf;
						EndIf;
						If FieldValuesAll.Property("ValueBeforeChange") Then
							FieldValueOld = FieldValuesAll.ValueBeforeChange;
							If TypeOf(FieldValueOld) = Type("FixedStructure") Then
								If FieldValueOld.Property("Presentation") Then
									FieldValueOld = FieldValueOld.Presentation;
								ElsIf FieldValueOld.Property("Ref") Then
									FieldValueOld = FieldValueOld.Ref;
								EndIf;
							EndIf;
						EndIf;
					EndIf;
				EndIf;
				
				FieldRow = Template.GetArea("FieldRow");
				FieldRow.Parameters.ValueBefore = FieldValueOld;
				FieldRow.Parameters.ValueAfter = FieldValue;
				If ImportantAttributes <> Undefined And ImportantAttributes.Find(FieldKeyValue.Key) <> Undefined Then
					FieldRow.Area(1, 1, 1, 2).TextColor = WebColors.Red;
				EndIf;
				
				TableRow.Join(FieldRow);
			EndDo;
			
			HistoryReport.Put(TableRow);
		EndDo;
	EndDo;
	
	For ColumnNumber = 5 to HistoryReport.TableWidth Do
		If HistoryReport.Area(1, ColumnNumber).ColumnWidth < 20 Then
			HistoryReport.Area(1, ColumnNumber).ColumnWidth = 20;
		EndIf;
	EndDo;
	
EndProcedure

#EndRegion
