
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
		RefreshJEAtServer(Items.DocumentList.CurrentData.Document);
	Else
		RefreshJEAtServer(Items.DocumentList.CurrentData.Document);
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
			CurrentDocument = Items.DocumentList.CurrentData.Document;
			LoadDocumentInfo(CurrentDocument);
			SetCurrentPageAtClient();
		EndIf;
	ElsIf Not InfoUpdated Then
		LoadDocumentInfo(Undefined);
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
Procedure LoadDocumentInfo(DocumentRef)
	RefreshJEAtServer(DocumentRef);
	RefreshFilesAtServer(DocumentRef);
	InfoUpdated = True;
EndProcedure

&AtServer
Procedure RefreshJEAtServer(DocumentRef)
	
	If DocumentRef = Undefined Then
		AccountingReport = New SpreadsheetDocument();
		Return;
	EndIf;

	AccountingReport = GetPrintFormJE(DocumentRef);

EndProcedure

&AtServer
Function GetPrintFormJE(DocumentRef)
	
	Report = New SpreadsheetDocument();
	
	Template = DataProcessors.AccountantAutomatedWorkplace.GetTemplate("PrintFormJE");
	
	Report.Put(Template.GetArea("Header"));
	
	Query = New Query;
	
	Query.SetParameter("DocumentRef", DocumentRef);
	Query.Text =
	"SELECT ALLOWED
	|	JournalEntry.Ref AS RefJE
	|FROM
	|	Document.JournalEntry AS JournalEntry
	|WHERE
	|	JournalEntry.Basis = &DocumentRef";
	Journals = Query.Execute().Unload().UnloadColumn(0); 
	
	Query.SetParameter("Journals", Journals);
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
	|	AccountingRegister.Basic.RecordsWithExtDimensions(,, Recorder IN (&Journals),,) AS BasicRecordsWithExtDimensions
	|
	|ORDER BY
	|	BasicRecordsWithExtDimensions.LineNumber";
	
	QuerySelection = Query.Execute().Select();
	While QuerySelection.Next() Do
		Row = Template.GetArea("Row");
		Row.Parameters.Fill(QuerySelection);
		Report.Put(Row);
	EndDo;
	
	Return Report;

EndFunction

&AtServer
Procedure RefreshFilesAtServer(DocumentRef)
	
	FileTable.Clear();
	
	Items.NoFile.Visible = False;
	Items.FilePDF.Visible = False;
	Items.FilePicture.Visible = False;
	
	If DocumentRef = Undefined Then
		Items.GroupFiles.CurrentPage = Items.NoFile;
		Items.NoFile.Visible = True;
		Return;
	EndIf;
	
	ForDelete = New Array;
	For Each PageItem In Items.GroupFiles.ChildItems Do
		If PageItem <> Items.NoFile And PageItem <> Items.FilePDF And PageItem <> Items.FilePicture Then
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
		Items.GroupFiles.CurrentPage = Items.NoFile;
		Items.NoFile.Visible = True;
		Return;
	EndIf;
	
	For Each FileRecord In FileTable Do
		FileIndex = Format(FileTable.IndexOf(FileRecord), "NZ=; NG=;");
		If FileIndex = "0" Then
			If FileRecord.isPDF Then
				CurrentPage = Items.FilePDF;
			Else
				CurrentPage = Items.FilePicture;
			EndIf;
			CurrentPage.Visible = True;
			CurrentPage.Title = FileRecord.Name;
			Items.GroupFiles.CurrentPage = CurrentPage;
		Else
			NewPage = Items.Add("Page_"+FileIndex, Type("FormGroup"), Items.GroupFiles);
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
	
	If Items.GroupFiles.CurrentPage = Undefined Then
		If FileTable.Count() = 0 Then
			Items.GroupFiles.CurrentPage = Items.NoFile
		Else
			FileRecord = FileTable.Get(0);
			Items.GroupFiles.CurrentPage = ?(FileRecord.isPDF, Items.FilePDF, Items.FilePicture);
		EndIf;
	EndIf;
	
	If Items.GroupFiles.CurrentPage = Items.NoFile Then
		Return;
	EndIf;
	
	If Items.GroupFiles.CurrentPage = Items.FilePDF Or Items.GroupFiles.CurrentPage = Items.FilePicture Then
		FileRecord = FileTable.Get(0);
	Else
		FileIndex = Number(StrReplace(Items.GroupFiles.CurrentPage.Name, "Page_", ""));
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
