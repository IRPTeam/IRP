
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	DocumentList.Parameters.Items[0].Value = SessionParameters.CurrentUser;
	DocumentList.Parameters.Items[0].Use = True;
	
	FillDocumentTypeList();
	
	SetVisible();

EndProcedure

&AtServer
Procedure BeforeLoadDataFromSettingsAtServer(Settings)
	
	If Settings.Count() Then
		FillDocumentTypeList(Settings);
	EndIf;

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
	EndDo;
EndProcedure

&AtClient
Procedure Unlock(Command)
	ChangedDocs = UnlockAtServer();
	For Each Doc In ChangedDocs Do
		NotifyChanged(Doc);
	EndDo;
EndProcedure

&AtClient
Procedure RefreshJE(Command)
	If Items.DocumentList.CurrentData = Undefined Then
		RefreshJEAtServer(Undefined);
	Else
		RefreshJEAtServer(Items.DocumentList.CurrentData.JournalEntry);
	EndIf;
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
	
	OpenForm("DataProcessor.AccountantAutomatedWorkplace.Form.FormSettings", , ThisObject, ,,, New CallbackDescription("OpenSettingsFinish", ThisObject), FormWindowOpeningMode.LockWholeInterface);
	
EndProcedure

&AtClient
Procedure OpenSettingsFinish(Result, AddInfo) Export
	
	SetVisible();
	
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
	Items.FindDocuments.BackColor = New Color(255, 255, 153);
	If Item = Items.Period Or Item = Items.Company Or Item = Items.LedgerType Then
		FillDocumentTypeList();
	EndIf;
EndProcedure

&AtClient
Procedure DocumentListOnActivateRow(Item)
	
	If Items.DocumentList.CurrentData <> Undefined Then
		If CurrentDocument <> Items.DocumentList.CurrentData.Document Then
			LoadDocumentInfo(
				Items.DocumentList.CurrentData.Document, 
				Items.DocumentList.CurrentData.JournalEntry);
			SetCurrentPageAtClient();
		EndIf;
	ElsIf Not InfoUpdated Then
		LoadDocumentInfo(Undefined, Undefined);
		SetCurrentPageAtClient();
	EndIf;

EndProcedure

&AtClient
Procedure GroupFilesOnCurrentPageChange(Item, CurrentPage)
	SetCurrentPageAtClient();
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

#EndRegion

#Region Private

&AtServer
Procedure SetVisible()
	
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
		DynamicListAPI.AddFilter(QuerySchemaAPI, "JournalEntry.Company = &Company");
	EndIf;
	If Not LedgerType.IsEmpty() Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "JournalEntry.LedgerType = &LedgerType");
	EndIf;
	If Not IsBlankString(DocumentType) And DocumentType <> "All" Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Registry.Document Refs Document." + DocumentType);
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

&AtServer
Procedure LoadDocumentInfo(DocumentRef, JournalEntryRef)
	RefreshJEAtServer(JournalEntryRef);
	RefreshFilesAtServer(DocumentRef);
	RefreshChatAtServer(DocumentRef);
	RefreshHistoryAtServer(DocumentRef);
	CurrentDocument = DocumentRef;
	InfoUpdated = True;
EndProcedure

&AtServer
Procedure RefreshJEAtServer(JournalEntryRef)
	
	AccountingReport = New SpreadsheetDocument();
	
	Template = DataProcessors.AccountantAutomatedWorkplace.GetTemplate("PrintFormJE");
	AccountingReport.Put(Template.GetArea("Header"));
	
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
		AccountingReport.Put(Row);
	EndDo;
	
EndProcedure

&AtServer
Procedure RefreshFilesAtServer(DocumentRef)
	
	FileTable.Clear();
	FilesCount = 0;
	
	Items.PagesFiles.CurrentPage = Items.FirstPage;
	
	Items.NoFileLabel.Visible = False;
	Items.PDFPreview.Visible = False;
	Items.ImagePreview.Visible = False;
	
	If DocumentRef = Undefined Then
		Items.NoFileLabel.Visible = True;
		Return;
	EndIf;
	
	ForDelete = New Array;
	For Each PageItem In Items.PagesFiles.ChildItems Do
		If PageItem <> Items.FirstPage Then
			For Each ChildItem In PageItem.ChildItems Do
				ForDelete.Add(ChildItem);
			EndDo;
			ForDelete.Add(PageItem);
		EndIf;
	EndDo;
	For Each DeletedItem In ForDelete Do
		Items.Delete(DeletedItem);
	EndDo;
	
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
			FileRecord = FileTable.Add();
			FileRecord.Ref = QuerySelection.File;
			FileRecord.Name = QuerySelection.Name;
			FileRecord.isPDF = True;
		ElsIf PictureViewerServer.isImage(QuerySelection.Extension) Then
			FileRecord = FileTable.Add();
			FileRecord.Ref = QuerySelection.File;
			FileRecord.Name = QuerySelection.Name;
			FileRecord.isPDF = False;
		EndIf;
	EndDo;
	FilesCount = FileTable.Count();
	
	If FileTable.Count() = 0 Then
		Items.NoFileLabel.Visible = True;
		Items.FirstPage.Title = Items.NoFileLabel.Title;
		Return;
	EndIf;
	
	For Each FileRecord In FileTable Do
		FileIndex = Format(FileTable.IndexOf(FileRecord), "NZ=; NG=;");
		If FileIndex = "0" Then
			If FileRecord.isPDF Then
				Items.PDFPreview.Visible = True;
			Else
				Items.ImagePreview.Visible = True;
			EndIf;
			Items.FirstPage.Title = FileRecord.Name;
		Else
			NewPage = Items.Add("Page_"+FileIndex, Type("FormGroup"), Items.PagesFiles);
			NewPage.Type = FormGroupType.Page;
			NewPage.Title = FileRecord.Name;
			If FileRecord.isPDF Then
				NewItem = Items.Add("PDF_"+FileIndex, Type("FormField"), NewPage);
				NewItem.Type = FormFieldType.PDFDocumentField;
				NewItem.DataPath = "PDFPreview";
			Else
				NewItem = Items.Add("IMG_"+FileIndex, Type("FormField"), NewPage);
				NewItem.Type = FormFieldType.PictureField;
				NewItem.DataPath = "ImagePreview";
				NewItem.PictureSize = PictureSize.Proportionally;
			EndIf;
			NewItem.TitleLocation = FormItemTitleLocation.None;
			NewItem.AutoMaxWidth = False;
		EndIf;
	EndDo;
	
EndProcedure

&AtServer
Procedure RefreshHistoryAtServer(DocumentRef)
	
	HistoryVersionTable.Clear();
	HistoryReport.Clear();
	HistoryCount = 0;
	
	If Not ValueIsFilled(DocumentRef) Then
		Return;
	EndIf;
	
	DataHistory.UpdateHistory();
	HistoryTable = DataHistory.SelectVersions(New Structure("Data", DocumentRef),, "VersionNumber");
	For Each HistoryRow In HistoryTable Do
		NewVersion = HistoryVersionTable.Add();
		FillPropertyValues(NewVersion, HistoryRow);
	EndDo;
	HistoryCount = HistoryVersionTable.Count();
	
EndProcedure

&AtServer
Procedure RefreshChatAtServer(DocumentRef)
	
	ChatCount = 0;
	
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
	ChatCount = Data.Count();
	
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
	
	If Not ChatHTML = Chat Then
		Chat = ChatHTML;
	EndIf;
	
	Items.ChatAttachedFiles.Visible = (ChatAttachedFiles.Count() > 0);
EndProcedure

&AtClient
Procedure SetCurrentPageAtClient()
	
	If Items.PagesFiles.CurrentPage = Undefined Then
		Items.PagesFiles.CurrentPage = Items.FirstPage
	EndIf;
	
	If FileTable.Count() = 0 Then
		Return;
	EndIf;
	
	If Items.PagesFiles.CurrentPage = Items.FirstPage Then
		FileRecord = FileTable.Get(0);
	Else
		FileIndex = Number(StrReplace(Items.PagesFiles.CurrentPage.Name, "Page_", ""));
		FileRecord = FileTable.Get(FileIndex);
	EndIf;
	
	If FileRecord.isPDF Then
		PictureViewerClient.SetPDFForView(FileRecord.Ref, PDFPreview);
	Else
		PictureParameters = PictureViewerServer.CreatePictureParameters(FileRecord.Ref);
		ImagePreview = PictureViewerClient.GetPictureURL(PictureParameters);
	EndIf;
	
EndProcedure

Procedure FillDocumentTypeList(Settings=Undefined)
	
	Items.DocumentType.ChoiceList.Clear();	
	
	PeriodFilter = Undefined;
	CompanyFilter = Undefined;
	LedgerTypeFilter = Undefined;
	
	If Settings <> Undefined Then
		PeriodFilter = Settings.Get("Period");
		CompanyFilter = Settings.Get("Company");
		LedgerTypeFilter = Settings.Get("Ledger");
	EndIf;
	If PeriodFilter = Undefined Then
		PeriodFilter = Period;
	EndIf;
	If CompanyFilter = Undefined Then
		CompanyFilter = Company;
	EndIf;
	If LedgerTypeFilter = Undefined Then
		LedgerTypeFilter = LedgerType;
	EndIf;
	
	Query = New Query;
	Query.Text =
	"SELECT DISTINCT
	|	VALUETYPE(BasicTurnovers.Recorder.Basis) AS RecorderType
	|FROM
	|	AccountingRegister.Basic.Turnovers(&Begin, &End, Recorder,,, TRUE
	|	AND Company = &Company
	|	AND LedgerType = &LedgerType,,) AS BasicTurnovers
	|WHERE
	|	NOT BasicTurnovers.Recorder.Basis IS NULL
	|	AND BasicTurnovers.Recorder.Basis <> UNDEFINED";
	
	If PeriodFilter.StartDate = Date(1,1,1) Then
		Query.Text = StrReplace(Query.Text, "&Begin", "");
	Else
		Query.SetParameter("Begin", PeriodFilter.StartDate);
	EndIf;
	If PeriodFilter.EndDate = Date(1,1,1) Then
		Query.Text = StrReplace(Query.Text, "&End", "");
	Else	
		Query.SetParameter("End", PeriodFilter.EndDate);
	EndIf;
	If CompanyFilter.IsEmpty() Then
		Query.Text = StrReplace(Query.Text, "Company = &Company", "True");
	Else	
		Query.SetParameter("Company", CompanyFilter);
	EndIf;
	If LedgerTypeFilter.IsEmpty() Then
		Query.Text = StrReplace(Query.Text, "LedgerType = &LedgerType", "True");
	Else	
		Query.SetParameter("LedgerType", LedgerTypeFilter);
	EndIf;
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		DocMetadata = Metadata.FindByType(QuerySelection.RecorderType);
		Items.DocumentType.ChoiceList.Add(DocMetadata.Name, DocMetadata.Synonym);
	EndDo;
	Items.DocumentType.ChoiceList.SortByPresentation();
	
	Items.DocumentType.ChoiceList.Insert(0, "All", "<" + R().Form_033 + ">");

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
	
	RefreshChatAtServer(CurrentDocument);
	
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
	
	AttributeNames = Catalogs.ConfigurationMetadata.GetAttributeNamesByObject(CurrentDocument);
	
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
			HistoryReport.Put(Row);
		EndDo;
	EndIf;
	
	For Each TableKeyValue In Tables Do
		If TableKeyValue.Value.Count() = 0 Then
			Continue;
		EndIf;
		
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
