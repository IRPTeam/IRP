
#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	
	For Each DocMetadata In Metadata.Documents Do
		Items.DocumentType.ChoiceList.Add(DocMetadata.Name, DocMetadata.Synonym);
	EndDo;

EndProcedure

#EndRegion

#Region Commands

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

#EndRegion

#Region FormItemsEvents

&AtClient
Procedure FilterOnChange(Item)
	Items.FindDocuments.BackColor = New Color(255, 255, 153);
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

#EndRegion

#Region Private

&AtServer
Procedure SetListFilterAtServer()
	
	QuerySchemaAPI = DynamicListAPI.Get(DocumentList);
	DynamicListAPI.ClearFilter(QuerySchemaAPI);
	
	If Period.EndDate > Date(1,1,1) Then
		DynamicListAPI.AddFilter(QuerySchemaAPI, "Registry.Date Between &StartDate AND &EndDate");
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
	
	DynamicListAPI.Set(QuerySchemaAPI);
	
	If Period.EndDate > Date(1,1,1) Then
		DocumentList.Parameters.SetParameterValue("StartDate", Period.StartDate);
		DocumentList.Parameters.SetParameterValue("EndDate", Period.EndDate); 
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

#EndRegion
