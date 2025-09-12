
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.MapRowsLeft = New ValueList();
	ThisObject.MapRowsRight = New ValueList();
	
	ThisObject.MapColumnsLeft = New ValueList();
	ThisObject.MapColumnsRight = New ValueList();
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	OnlyPosted = True;
	If PackSize = 0 Then
		PackSize = 100;
	EndIf;
EndProcedure

#Region FillDocuments
&AtClient
Procedure FillDocuments(Command)
	DocumentList.Clear();
	FillDocumentsAtServer();
EndProcedure

&AtServer
Procedure FillDocumentsAtServer()
	
	Settings = FixDocumentProblemsServer.GetDocumentListSettings();
	Settings.StartDate = Period.StartDate;
	Settings.EndDate = Period.EndDate;
	Settings.OnlyPosted = OnlyPosted;
	Settings.CompanyList = Company.UnloadValues();
	Settings.QueryText = QueryText;
	Result = FixDocumentProblemsServer.GetDocumentList(Settings);
	
	DocumentList.Load(Result);
EndProcedure

&AtClient
Procedure FillAccountingDocuments(Command)
	FillAccountingDocumentsAtServer();
EndProcedure

&AtServer
Procedure FillAccountingDocumentsAtServer()
	Settings = FixDocumentProblemsServer.GetDocumentListSettings();
	Settings.StartDate = Period.StartDate;
	Settings.EndDate = Period.EndDate;
	Settings.CompanyList = Company.UnloadValues();
	Settings.Accounting = True;
	Result = AccountingServer.GetDocumentList(Settings);	
	DocumentList.Load(Result);
EndProcedure

#EndRegion

#Region CheckDocuments

&AtClient
Procedure CheckDocuments(Command)
	ThisObject.ErrorsGroups.Clear();
	CheckList.GetItems().Clear();
	JobSettingsArray = GetJobsForCheckDocuments();
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
	Items.PagesDocuments.CurrentPage = Items.PageCheck;
EndProcedure

&AtServer
Function GetJobsForCheckDocuments()
	
	TypesTable = ThisObject.DocumentList.Unload(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForCheckDocuments_Callback";
	JobDataSettings.ProcedurePath = "AdditionalDocumentTableControl.CheckDocumentArray";
	
	For Each TypeItem In TypesTable Do
		 DocumentsRows = DocumentList.FindRows(New Structure("DocumentType", TypeItem.DocumentType));
		 DocumentTable = DocumentList.Unload(DocumentsRows, "Ref, Date, Picture");
		 
		 JobSettings = BackgroundJobAPIServer.JobSettings();

		 JobSettings.ProcedureParams.Add(DocumentTable.UnloadColumn("Ref"));
		 JobSettings.ProcedureParams.Add(True);

		 JobSettings.Description = String(TypeItem.DocumentType) + ": " + DocumentTable.Count();
		 JobDataSettings.JobSettings.Add(JobSettings);
	EndDo;

	Return JobDataSettings;
EndFunction

// Get jobs for check documents callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
//  AllJobDone - Boolean
&AtServer
Procedure GetJobsForCheckDocuments_Callback(Result, AllJobDone) Export
	CheckListTree = FormAttributeToValue("CheckList");
	DocumentErrors = New Array;
	ErrorsDescriptions = AdditionalDocumentTableControlReuse.GetAllErrorsDescription();	
	ErrorsGroupsTable = ThisObject.ErrorsGroups.Unload();
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		
		ErrorsTree = CommonFunctionsServer.GetFromCache(Row.CacheKey);
		For Each DocRow In ErrorsTree.Rows Do
			ParentRow = CheckListTree.Rows.Add();
			ParentRow.Ref = DocRow.Ref;
			ParentRow.LineNumber = DocRow.Rows.Count();
			ParentRow.Date = DocRow.Ref.Date;
			DocumentErrors.Clear();
			
			For Each ErrorRow In DocRow.Rows Do
				NewRow = ParentRow.Rows.Add();
				FillPropertyValues(NewRow, ErrorRow.Error);
				NewRow.Date = ParentRow.Date;
				NewRow.Picture = ParentRow.Picture;
				
				ErrorRecord = ErrorsGroupsTable.Find(NewRow.ErrorID, "ErrorID");
				If ErrorRecord = Undefined Then
					ErrorRecord = ErrorsGroupsTable.Add();
					ErrorRecord.ErrorID = NewRow.ErrorID;
					ErrorRecord.ErrorDescription = ErrorsDescriptions[ErrorRecord.ErrorID].ErrorDescription;
					ErrorRecord.FixDescription = ErrorsDescriptions[ErrorRecord.ErrorID].FixDescription;
				EndIf;
				
				ErrorRecord.Cases = ErrorRecord.Cases + 1;
				
				If DocumentErrors.Find(ErrorRecord.ErrorID) = Undefined Then
					DocumentErrors.Add(ErrorRecord.ErrorID);
					ErrorRecord.Documents = ErrorRecord.Documents + 1; 
				EndIf;
			EndDo;
		 EndDo;
	EndDo;
	ThisObject.ErrorsGroups.Load(ErrorsGroupsTable);
	
	CheckListTree.Rows.Sort("Date, Ref, ErrorID, LineNumber", True);
	ValueToFormAttribute(CheckListTree, "CheckList");
EndProcedure

&AtClient
Procedure UpdateCheckSelectedRows(Command)
	DocArray = New Array;
	For Each ID In Items.CheckList.SelectedRows Do
		Row = CheckList.FindByID(ID);
		Childrens = Row.GetItems();
		If Childrens.Count() = 0 Then
			Parent = Row.GetParent();
			DocArray.Add(Parent.GetID());
			Parent.GetItems().Clear();
		Else
			Childrens.Clear();
			DocArray.Add(ID);
		EndIf;
		
	EndDo;
	UpdateCheckSelectedRowsAtServer(DocArray);
EndProcedure

&AtServer
Procedure UpdateCheckSelectedRowsAtServer(DocArray)
	For Each ID In DocArray Do
		Row = CheckList.FindByID(ID);
		Result = AdditionalDocumentTableControl.CheckDocument(Row.Ref, , True);
		For Each Error In Result Do
			NewRow = Row.GetItems().Add();
			FillPropertyValues(NewRow, Row);
			NewRow.RowKey = Error.RowKey;
			NewRow.LineNumber = Error.LineNumber;
			NewRow.ErrorID = Error.ErrorID;
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#Region QuickFix

&AtClient
Procedure QuickFixError(Command)
	CurrentErrorRow = Items.ErrorsGroups.CurrentRow;
	If CurrentErrorRow = Undefined Then
		Return;
	EndIf;

	ErrorRecord = ThisObject.ErrorsGroups.FindByID(CurrentErrorRow);
	ErrorID = ErrorRecord.ErrorID;
	
	Map = New Map;
	For Each DocumentRow In ThisObject.CheckList.GetItems() Do
		For Each ErrorRow In DocumentRow.GetItems() Do
			If ErrorRow.Fixed OR ErrorRow.ErrorID <> ErrorID Then
				Continue;
			EndIf;
			DocRefErrors = Map.Get(ErrorRow.Ref);
			If DocRefErrors = Undefined Then
				DocRefErrors = New Structure;
				DocRefErrors.Insert(ErrorID, New Array);
				Map.Insert(ErrorRow.Ref, DocRefErrors);
			EndIf;
			DocRefErrors[ErrorID].Add(ErrorRow.RowKey);
		EndDo;
	EndDo;
	
	JobSettingsArray = GetJobsForQuickFix(Map);
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
	
	ErrorRecord.Fixed = True;
EndProcedure

&AtClient
Procedure QuickFix(Command)
	Map = New Map;
	For Each RowID In Items.CheckList.SelectedRows Do
		
		Row = CheckList.FindByID(RowID);
		
		If Row.Fixed Or IsBlankString(Row.ErrorID) Then
			Continue;
		EndIf;
		
		DocRefErrors = Map.Get(Row.Ref);
		If DocRefErrors = Undefined Then
			Map.Insert(Row.Ref, New Structure);
			DocRefErrors = Map.Get(Row.Ref);
		EndIf;
		
		If Not DocRefErrors.Property(Row.ErrorID) Then
			DocRefErrors.Insert(Row.ErrorID, New Array);
		EndIf;
		
		DocRefErrors[Row.ErrorID].Add(Row.RowKey);
	EndDo;
	
	JobSettingsArray = GetJobsForQuickFix(Map);
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
EndProcedure

&AtServer
Function GetJobsForQuickFix(Map)
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForQuickFix_Callback";
	JobDataSettings.ProcedurePath = "AdditionalDocumentTableControl.QuickFixArray";
	JobDataSettings.CallbackWhenAllJobsDone = False;
					
	DocsInPack = PackSize;
	StreamArray = New Array;
	Pack = 1;
	TotalDocs = Map.Count();
	For Each Row In Map Do
		StreamArray.Add(Row);
	 	
	 	If StreamArray.Count() = DocsInPack Then
	 		JobSettings = BackgroundJobAPIServer.JobSettings();
			JobSettings.ProcedureParams.Add(StreamArray);
			JobSettings.ProcedureParams.Add(True);
			JobSettings.Description = "Quick fix: " + Pack + " * (" + DocsInPack + ") / " + TotalDocs;
			JobDataSettings.JobSettings.Add(JobSettings);
			
			StreamArray = New Array;
	 		Pack = Pack + 1;
	 	EndIf;
	EndDo;
	If StreamArray.Count() > 0 Then
		JobSettings = BackgroundJobAPIServer.JobSettings();
		JobSettings.ProcedureParams.Add(StreamArray);
		JobSettings.ProcedureParams.Add(True);
		JobSettings.Description = "Quick fix: " + Pack + " * (" + StreamArray.Count() + ") / " + TotalDocs;
		JobDataSettings.JobSettings.Add(JobSettings);
 	EndIf;

	Return JobDataSettings;
	
EndFunction

// Get jobs for quick fix callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
//  AllJobDone - Boolean - 
&AtClient
Procedure GetJobsForQuickFix_Callback(Result, AllJobDone) Export
	
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		DocsData = CommonFunctionsServer.GetFromCache(Row.CacheKey); // See AdditionalDocumentTableControl.QuickFixArray
		For Each DocumentData In DocsData Do
			FixedArray = DocumentData.RowID;
			If FixedArray.Count() = 0 Then
				Continue;
			EndIf;
			
			For Each CheckRow In ThisObject.CheckList.GetItems() Do
				If Not CheckRow.Ref = DocumentData.Ref Then
					Continue;
				EndIf;
				For Each CheckSubRow In CheckRow.GetItems() Do
					If CheckSubRow.ErrorID = DocumentData.ErrorID And FixedArray.Find(CheckSubRow.RowKey) <> Undefined Then
						CheckSubRow.ProblemWhileQuickFix = DocumentData.Description;
						CheckSubRow.Fixed = DocumentData.Result;
					EndIf;
				EndDo;
				Break;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

#EndRegion

#Region Posting

&AtClient
Procedure CheckPosting(Command)
	PostingInfo.GetItems().Clear();
	JobSettingsArray = GetJobsForCheckPostingDocuments("PostingServer.CheckDocumentArray");
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
	Items.PagesDocuments.CurrentPage = Items.PagePosting;
EndProcedure

&AtClient
Procedure MoveWithoutCheck(Command)
	For Each Row In DocumentList Do
		NewRow = PostingInfo.GetItems().Add();
		NewRow.Date = Row.Date;
		NewRow.DocumentType = Row.DocumentType;
		NewRow.Ref = Row.Ref;
	EndDo;
EndProcedure

&AtClient
Procedure CheckAccountingAnalytics(Command)	
	PostingInfo.GetItems().Clear();
	ArrayOfExcludeTypes = AccountingServer.GetExcludeDocumentTypes_AccountingAnalytics();
	JobSettingsArray = GetJobsForCheckPostingDocuments("AccountingServer.CheckDocumentArray_AccountingAnalytics", ArrayOfExcludeTypes);
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);	
	Items.PagesDocuments.CurrentPage = Items.PagePosting;	
EndProcedure

&AtClient
Procedure CheckAccountingTranslations(Command)
	PostingInfo.GetItems().Clear();
	ArrayOfExcludeTypes = AccountingServer.GetExcludeDocumentTypes_AccountingTranslation();
	JobSettingsArray = GetJobsForCheckPostingDocuments("AccountingServer.CheckDocumentArray_AccountingTranslation", ArrayOfExcludeTypes);
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);	
	Items.PagesDocuments.CurrentPage = Items.PagePosting;	
EndProcedure

&AtServer
Function GetJobsForCheckPostingDocuments(ProcedurePath, ArrayOfExcludeTypes = Undefined)
	DocumentsTable = DocumentList.Unload();
	If ArrayOfExcludeTypes <> Undefined Then
		ArrayForDelete = New Array();
		
		For Each Row In DocumentsTable Do
			If ArrayOfExcludeTypes.Find(TypeOf(Row.Ref)) <> Undefined Then
				ArrayForDelete.Add(Row);
			EndIf;
		EndDo;
		
		For Each ItemForDelete In ArrayForDelete Do
			DocumentsTable.Delete(ItemForDelete);
		EndDo;
	EndIf;
	
	JobDataSettings = FixDocumentProblemsServer.GetJobsForCheckPostingDocuments(DocumentsTable, ProcedurePath);
	Return JobDataSettings;
EndFunction

// Get jobs for check posting documents callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
//  AllJobDone - Boolean - 
&AtServer
Procedure GetJobsForCheckPostingDocuments_Callback(Result, AllJobDone) Export  
	TreeRow = PostingInfo.GetItems();
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		
		RegInfoArray = CommonFunctionsServer.GetFromCache(Row.CacheKey);
		FillRegInfoInRow(TreeRow, RegInfoArray);
	EndDo;
EndProcedure

&AtServer
Procedure FillRegInfoInRow(TreeRow, RegInfoArray, Parent = Undefined)
	SkipRegFilled = SkipCheckRegisters.Count() > 0;
	For Each DocRow In RegInfoArray Do
			
			//If DocRow.RegInfo.Count() = 0 Then
			//	Continue;
			//EndIf;
			
			ParentRow = ?(Parent = Undefined, TreeRow.Add(), Parent);
			ParentRow.Ref = DocRow.Ref;
			ParentRow.DocumentType = TypeOf(DocRow.Ref);
			ParentRow.Errors = DocRow.Error;
			
			For Each RegInfoData In DocRow.RegInfo Do
				
				If SkipRegFilled And Not SkipCheckRegisters.FindByValue(RegInfoData.RegName) = Undefined Then
					Continue;
				EndIf;
				
				NewRow = ParentRow.GetItems().Add();
				FillPropertyValues(NewRow, RegInfoData);
				NewRow.Date = ParentRow.Date;
				NewRow.Ref = ParentRow.Ref;
				NewRow.DocumentType = ParentRow.DocumentType;
				NewRow.NewMovement = New ValueStorage(RegInfoData.NewPostingData, New Deflation(9));
					
			EndDo;
			
			If SkipRegFilled And ParentRow.GetItems().Count() = 0 Then
				TreeRow.Delete(ParentRow);
			Else
				ParentRow.Date = DocRow.Ref.Date;
			EndIf;
			
		 EndDo;
EndProcedure

&AtClient
Procedure CheckAllPostInfo(Command)
	For Each Row In Items.PostingInfo.SelectedRows Do
		RowData = PostingInfo.FindByID(Row);
		RowData.Select = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAllPostInfo(Command)
	For Each Row In Items.PostingInfo.SelectedRows Do
		RowData = PostingInfo.FindByID(Row);
		RowData.Select = False;
	EndDo;
EndProcedure

&AtClient
Procedure PostingInfoPostSelectedDocument(Command)
	JobSettingsArray = GetJobsForPostSelectedDocument();
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
EndProcedure

&AtServer
Function GetJobsForPostSelectedDocument()
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForPostSelectedDocument_Callback";
	JobDataSettings.ProcedurePath = "PostingServer.PostingDocumentArray";
	JobDataSettings.CallbackWhenAllJobsDone = False;
					
	DocsInPack = PackSize;
	StreamArray = New Array;
	For Each Row In PostingInfo.GetItems() Do
		If Not Row.Select OR Row.Processed Then
			Continue;
		EndIf;
		
		Pack = 1;
		StreamArray.Add(Row.Ref);
		
		If StreamArray.Count() = DocsInPack Then
			JobSettings = BackgroundJobAPIServer.JobSettings();
			JobSettings.ProcedureParams.Add(StreamArray);
			JobSettings.ProcedureParams.Add(True);
			JobSettings.Description = "Posting: " + Pack + " * (" + DocsInPack + ")";
			JobDataSettings.JobSettings.Add(JobSettings);
			
			StreamArray = New Array;
			Pack = Pack + 1;
		EndIf;
	EndDo;
	If StreamArray.Count() > 0 Then
		JobSettings = BackgroundJobAPIServer.JobSettings();
		JobSettings.ProcedureParams.Add(StreamArray);
		JobSettings.ProcedureParams.Add(True);
		JobSettings.Description = "Posting: " + Pack + " * (" + StreamArray.Count() + ")";
		JobDataSettings.JobSettings.Add(JobSettings);
	EndIf;

	Return JobDataSettings;
EndFunction

// Get jobs for check posting documents callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
//  AllJobDone - Boolean - 
&AtServer
Procedure GetJobsForPostSelectedDocument_Callback(Result, AllJobDone) Export  
	Tree = FormAttributeToValue("PostingInfo");
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		
		RegInfoArray = CommonFunctionsServer.GetFromCache(Row.CacheKey);
		For Each DocRow In RegInfoArray Do
			Found = Tree.Rows.FindRows(New Structure("Ref, RegName", DocRow.Ref, ""), True);
			Found[0].Errors = DocRow.Error;
			Found[0].Processed = True;
		 EndDo;
	EndDo;
	ValueToFormAttribute(Tree, "PostingInfo");
EndProcedure

&AtClient
Procedure ShowPosingDiff(Command)
	Items.PostingInfoShowPostingDiff.Check = Not Items.PostingInfoShowPostingDiff.Check;
	Items.GroupDiff.Visible = Items.PostingInfoShowPostingDiff.Check;
	
	If Not Items.GroupDiff.Visible Then
		PostingInfo_ClearTables();
	EndIf;
EndProcedure

&AtClient
Procedure PostingInfoBeforeRowChange(Item, Cancel)
	
	If Not Item.CurrentItem = Items.PostingInfoRegName Then
		Return;
	EndIf;
	
	Cancel = True;
	
	CurrentMovement.Clear();
	NewMovement.Clear();
	
	If Not Items.GroupDiff.Visible Then
		Return;
	EndIf;
	
	CurrentRow = Items.PostingInfo.CurrentData;
	
	If CurrentRow = Undefined Then
		Return;
	EndIf;
	
	If IsBlankString(CurrentRow.RegName) Then
		Return;
	EndIf;
	
	If Not CurrentRegName = CurrentRow.RegName Then
		PostingInfo_ClearTables();
		CurrentRegName = CurrentRow.RegName;
		PostingInfo_CreateTable(CurrentRow.NewMovement);
	EndIf;

	PostingInfo_UpdateTable(CurrentRow.Ref, CurrentRow.NewMovement);
	ShowDiff();
EndProcedure

&AtServer
Procedure PostingInfo_UpdateTable(Ref, NewMovementStorage)	
	If AccountingServer.IsAccountingAnalyticsRegister(CurrentRegName) Then
		ValueTable = AccountingServer.GetCurrentAnalyticsRegisterRecords(Ref, CurrentRegName);
	ElsIf AccountingServer.IsAccountingDataRegister(CurrentRegName) Then
		ValueTable = AccountingServer.GetCurrentDataRegisterRecords(Ref, CurrentRegName);
	Else 
		ValueTable = PostingServer.GetDocumentMovementsByRegisterName(Ref, CurrentRegName);
	EndIf;
	
	CurrentMovement.Load(ValueTable);
	NewMovement.Load(NewMovementStorage.Get());
EndProcedure

&AtServer
Procedure PostingInfo_CreateTable(NewMovementStorage)
	
	Table = NewMovementStorage.Get(); // ValueTable
	
	CurrentMovementStructure = CommonFunctionsServer.BlankFormTableCreationStructure();
	CurrentMovementStructure.TableName	= "CurrentMovement";
	CurrentMovementStructure.ValueTable = Table;
	CurrentMovementStructure.Form		= ThisObject;
	
	CommonFunctionsServer.CreateFormTable(CurrentMovementStructure);
	
	NewMovementStructure = CommonFunctionsServer.BlankFormTableCreationStructure();
	NewMovementStructure.TableName	= "NewMovement";
	NewMovementStructure.ValueTable = Table;
	NewMovementStructure.Form		= ThisObject;
	
	CommonFunctionsServer.CreateFormTable(NewMovementStructure);
	
EndProcedure

&AtServer
Procedure PostingInfo_ClearTables()
	ArrayRemovedAttributes = New Array; // Array Of String
	
	For Each Column In CurrentMovement.Unload().Columns Do // ValueTableColumn
	    ArrayRemovedAttributes.Add("CurrentMovement." + Column.Name);
		ItemElement = Items.Find("CurrentMovement" + Column.Name);  
		If ItemElement = Undefined Then
			Continue;
		EndIf;
	    Items.Delete(Items.Find("CurrentMovement" + Column.Name));
	EndDo;
	
	For Each Column In NewMovement.Unload().Columns Do // ValueTableColumn
	    ArrayRemovedAttributes.Add("NewMovement." + Column.Name); 
		ItemElement = Items.Find("CurrentMovement" + Column.Name);
		If ItemElement = Undefined Then
			Continue;
		EndIf;
	    Items.Delete(Items.Find("NewMovement" + Column.Name));
	EndDo;
	
	ChangeAttributes(, ArrayRemovedAttributes);
	
	CurrentRegName = "";
EndProcedure

&AtClient
Procedure PostingInfoWriteRecordSet(Command)
	JobSettingsArray = GetJobsForWriteRecordSet();
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
EndProcedure

&AtServer
Function GetJobsForWriteRecordSet()
	Tree = FormAttributeToValue("PostingInfo", Type("ValueTree"));
	JobDataSettings = FixDocumentProblemsServer.GetJobsForWriteRecordSet(Tree);
	Return JobDataSettings;
EndFunction

// Get jobs for check posting documents callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
//  AllJobDone - Boolean - 
&AtServer
Procedure GetJobsForWriteRecordSet_Callback(Result, AllJobDone) Export  
	Tree = FormAttributeToValue("PostingInfo");
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		
		RegInfoArray = CommonFunctionsServer.GetFromCache(Row.CacheKey);
		For Each DocRow In RegInfoArray Do
			Found = Tree.Rows.FindRows(New Structure("Ref, RegName", DocRow.Ref, DocRow.RegName), True);
			Found[0].Errors = DocRow.Error;
			Found[0].Processed = True;
		 EndDo;
	EndDo;
	ValueToFormAttribute(Tree, "PostingInfo");
EndProcedure

&AtClient
Async Procedure PostingInfoExportData(Command)
	DialogParameters = New GetFilesDialogParameters();
	BD = PostingInfoExportDataAtServer();
	Address = PutToTempStorage(BD, UUID);
	GetFileFromServerAsync(Address, "Data.zip", DialogParameters);
EndProcedure

&AtServer
Function PostingInfoExportDataAtServer()
	Tree = FormAttributeToValue("PostingInfo");
	Data = CommonFunctionsServer.SerializeXMLUseXDTO(Tree);
	BD = CommonFunctionsServer.StringToBase64ZIP(Data, "Data", True);
	Return BD;
EndFunction

&AtClient
Async Procedure PostingInfoImportData(Command)
	DialogParameters = New PutFilesDialogParameters(, False, "Data file|*.zip;");
	StoredFileDescription = Await PutFileToServerAsync(, , , DialogParameters); // StoredFileDescription
	If StoredFileDescription.PutFileCanceled Then
		Return;
	EndIf;
	PostingInfoImportDataAtServer(StoredFileDescription.Address);
EndProcedure

&AtServer
Procedure PostingInfoImportDataAtServer(Address)
	File = GetFromTempStorage(Address);
	BD = CommonFunctionsServer.StringFromBase64ZIP(File);
	Data = GetStringFromBinaryData(BD);
	Tree = CommonFunctionsServer.DeserializeXMLUseXDTO(Data);
	ValueToFormAttribute(Tree, "PostingInfo");
EndProcedure

&AtClient
Procedure PostingInfoClearSkipRows(Command)
	If SkipCheckRegisters.Count() = 0 Then
		Return;
	EndIf;
	
	ClearRows();
EndProcedure

&AtServer
Procedure ClearRows()
	Tree = FormAttributeToValue("PostingInfo");
	
	For Each Reg In SkipCheckRegisters Do
		Found = Tree.Rows.FindRows(New Structure("RegName", Reg.Value), True);
		For Each DelRow In Found Do
			ParentRow = DelRow.Parent;
			ParentRow.Rows.Delete(DelRow);
			If ParentRow.Rows.Count() = 0 Then
				Tree.Rows.Delete(ParentRow);
			EndIf;
		EndDo;
	EndDo;
	
	ValueToFormAttribute(Tree, "PostingInfo");
EndProcedure

&AtClient
Procedure UpdatePostingSelectedRows(Command)

	DocArray = New Array;
	For Each ID In Items.PostingInfo.SelectedRows Do
		Row = PostingInfo.FindByID(ID);
		Childrens = Row.GetItems();
		If Childrens.Count() = 0 Then
			Parent = Row.GetParent();
			DocArray.Add(Parent.GetID());
			Parent.GetItems().Clear();
		Else
			Childrens.Clear();
			DocArray.Add(ID);
		EndIf;
		
	EndDo;
	UpdatePostingSelectedRowsAtServer(DocArray);
EndProcedure

&AtServer
Procedure UpdatePostingSelectedRowsAtServer(DocArray)
	For Each ID In DocArray Do
		Row = PostingInfo.FindByID(ID);
		Array = New Array;
		Array.Add(Row.Ref);
		Result = PostingServer.CheckDocumentArray(Array);
		FillRegInfoInRow(Row.GetItems(), Result, Row);
	EndDo;
EndProcedure

#EndRegion

#Region Service

&AtClient
Procedure DocumentListRefOnChange(Item)
	CurrentData = Items.DocumentList.CurrentData;
	If CurrentData = Undefined Then
		Return;
	ElsIf Not ValueIsFilled(CurrentData.Ref) Then
		CurrentData.DocumentType = "";
	Else
		CurrentData.DocumentType = TypeOf(CurrentData.Ref);
	EndIf;
EndProcedure

&AtClient
Procedure SetFilterByError(Command)
	CurrentErrorRow = Items.ErrorsGroups.CurrentRow;
	If CurrentErrorRow = Undefined Then
		Return;
	EndIf;

	ErrorRecord = ThisObject.ErrorsGroups.FindByID(CurrentErrorRow);
	ErrorFilter = ErrorRecord.ErrorID;
	
	ErrorFilterOnChange(Undefined);
EndProcedure

&AtClient
Procedure ErrorFilterOnChange(Item)
	
	If IsBlankString(ThisObject.ErrorFilter) Then
		RestoreOriginCheckList();
	Else
		ApplyFilterToCheckList();
	EndIf;

EndProcedure

&AtClient
Procedure ApplyFilterToCheckList()
	If ThisObject.FullCheckList.GetItems().Count() = 0 Then
		CopyFormData(ThisObject.CheckList, ThisObject.FullCheckList);
	Else
		CopyFormData(ThisObject.FullCheckList, ThisObject.CheckList);
	EndIf;

	HightRowsToDelete = new Array;
	For Each HightRow In ThisObject.CheckList.GetItems() Do
		LowRowsToDelete = new Array;
		For Each LowRow In HightRow.GetItems() Do
			If LowRow.ErrorID <> ThisObject.ErrorFilter Then
				LowRowsToDelete.Add(LowRow);
			EndIf;
		EndDo;
		For Each LowRow In LowRowsToDelete Do
			HightRow.GetItems().Delete(LowRow);
		EndDo;
		If HightRow.GetItems().Count() = 0 Then
			HightRowsToDelete.Add(HightRow);
		EndIf;
	EndDo;
	For Each HightRow In HightRowsToDelete Do
		ThisObject.CheckList.GetItems().Delete(HightRow);
	EndDo;

	For Each HightRow In ThisObject.CheckList.GetItems() Do
		Items.CheckList.Expand(HightRow.GetID(), True);
	EndDo;
	
EndProcedure

&AtClient
Procedure RestoreOriginCheckList()
	CopyFormData(ThisObject.FullCheckList, ThisObject.CheckList);
	ThisObject.FullCheckList.GetItems().Clear();
	For Each HightRow In ThisObject.CheckList.GetItems() Do
		Items.CheckList.Collapse(HightRow.GetID());
	EndDo;
EndProcedure

&AtClient
Procedure FillQueryTemplate(Command)
	QueryText = FixDocumentProblemsServer.GetDocumentQueryText();
EndProcedure

#EndRegion

#Region ShowDiff

&AtServer	
Procedure ShowDiff()
	ThisObject.BlockDiffDocActivate = True;
	
	ThisObject.MapRowsLeft = New ValueList();
	ThisObject.MapRowsRight = New ValueList();
	
	ThisObject.MapColumnsLeft = New ValueList();
	ThisObject.MapColumnsRight = New ValueList();
	
	ThisObject.DiffCellsLeft.Clear();
	ThisObject.DiffCellsRight.Clear();
	
	ThisObject.DiffDocLeft.Clear();
	ThisObject.DiffDocRight.Clear();
	
	ReportBuilder = New ReportBuilder();
	ReportBuilder.PutReportHeader = False;
	
	IgnoreColumns = "Recorder,LineNumber,PointInTime,UniqueID, UUID";
	
	_NewMovement = ThisObject.NewMovement.Unload();
	_CurrentMovement = ThisObject.CurrentMovement.Unload();
	
	For Each Column In StrSplit(IgnoreColumns, ",") Do
		CommonFunctionsServer.DeleteColumn(_NewMovement, TrimAll(Column));
		CommonFunctionsServer.DeleteColumn(_CurrentMovement, TrimAll(Column));
	EndDo;
	
	ReportBuilder.DataSource = New DataSourceDescription(_CurrentMovement);
	ReportBuilder.Put(ThisObject.DiffDocLeft);
	
	ReportBuilder.DataSource = New DataSourceDescription(_NewMovement);       
	ReportBuilder.Put(ThisObject.DiffDocRight);
	
	CompareSpreadsheetDocuments();
	
	ThisObject.DiffDocLeft.FixedTop = 1;
	ThisObject.DiffDocRight.FixedTop = 1;
		
	ThisObject.BlockDiffDocActivate = False;
EndProcedure

&AtClient
Procedure ExpandDiff(Command)
	Items.ExpandDiff.Check = Not Items.ExpandDiff.Check;
	Items.GroupClearRows.Visible = Not Items.ExpandDiff.Check;
	Items.PostingInfo.Visible = Not Items.ExpandDiff.Check;
	ExpandDiffAtServer();
EndProcedure

&AtServer
Procedure ExpandDiffAtServer()
	Items.GroupDiffDocs.Group = ?(Items.ExpandDiff.Check, ChildFormItemsGroup.Vertical, ChildFormItemsGroup.Horizontal);
EndProcedure	

&AtClient
Procedure PrevChangesLeft(Command)
	PrevChanges(Items.DiffDocLeft, ThisObject.DiffDocLeft, ThisObject.DiffCellsLeft);
EndProcedure

&AtClient
Procedure PrevChangesRight(Command)
	PrevChanges(Items.DiffDocRight, ThisObject.DiffDocRight, ThisObject.DiffCellsRight);
EndProcedure

&AtClient
Procedure NextChangeLeft(Command)
	NextChanges(Items.DiffDocLeft, ThisObject.DiffDocLeft, ThisObject.DiffCellsLeft);
EndProcedure

&AtClient
Procedure NextChangeRight(Command)
	NextChanges(Items.DiffDocRight, ThisObject.DiffDocRight, ThisObject.DiffCellsRight);
EndProcedure

&AtClient
Procedure DiffDocLeftOnActivate(Item)
	If ThisObject.BlockDiffDocActivate Then
		Return;
	EndIf;
	
	Source = New Structure("FormAttribute, FormItem", ThisObject.DiffDocLeft, Items.DiffDocLeft);
	Receiver = New Structure("FormAttribute, FormItem", ThisObject.DiffDocRight, Items.DiffDocRight);
	
	MapSource = New Structure("Rows, Columns", ThisObject.MapRowsLeft, ThisObject.MapColumnsLeft);
	MapReceiver = New Structure("Rows, Columns", ThisObject.MapRowsRight, ThisObject.MapColumnsRight);
	
	DiffDocOnActivate(Source, Receiver, MapSource, MapReceiver);
EndProcedure

&AtClient
Procedure DiffDocRightOnActivate(Item)
	If ThisObject.BlockDiffDocActivate Then
		Return;
	EndIf;
		
	Source = New Structure("FormAttribute, FormItem", ThisObject.DiffDocRight, Items.DiffDocRight);
	Receiver = New Structure("FormAttribute, FormItem", ThisObject.DiffDocLeft, Items.DiffDocLeft);
	
	MapSource = New Structure("Rows, Columns", ThisObject.MapRowsRight, ThisObject.MapColumnsRight);
	MapReceiver = New Structure("Rows, Columns", ThisObject.MapRowsLeft, ThisObject.MapColumnsLeft);
	
	DiffDocOnActivate(Source, Receiver, MapSource, MapReceiver);
EndProcedure

&AtClient
Procedure PrevChanges(FormItem, FormAttribute, DiffTable)
	
	Var Index;
	
	CurrentCell = FormItem.CurrentArea;
	NumberRow = CurrentCell.Top;
	NumberColumn = CurrentCell.Left;
	For Each CurrentRow In DiffTable Do
		If CurrentRow.NumberRow < NumberRow 
			Or CurrentRow.NumberRow = NumberRow And CurrentRow.NumberColumn < NumberColumn Then
			Index = DiffTable.Индекс(CurrentRow);
		ElsIf CurrentRow.NumberRow >= NumberRow And CurrentRow.NumberColumn > NumberColumn Then
			Break;
		EndIf;
	EndDo;
	
	If Index <> Undefined Then
		RowDiff = DiffTable[Index];
		NumberRow = RowDiff.NumberRow;
		NumberColumn = RowDiff.NumberColumn;
		FormItem.CurrentArea = FormAttribute.Area(NumberRow, NumberColumn, NumberRow, NumberColumn);
	EndIf;
EndProcedure

&AtClient
Procedure NextChanges(FormItem, FormAttribute, DiffTable)
	
	CurrentCell = FormItem.CurrentArea;
	NumberRow = CurrentCell.Top;
	NumberColumn = CurrentCell.Left;
	For Each CurrentRow In DiffTable Do
		If CurrentRow.NumberRow = NumberRow And CurrentRow.NumberColumn > NumberColumn 
			Or CurrentRow.NumberRow > NumberRow Then
			Index = DiffTable.Индекс(CurrentRow);
			Break;
		EndIf;
	EndDo;
	
	If Index <> Undefined Then
		RowDiff = DiffTable[Index];
		NumberRow = RowDiff.NumberRow;
		NumberColumn = RowDiff.NumberColumn;
		FormItem.CurrentArea = FormAttribute.Area(NumberRow, NumberColumn, NumberRow, NumberColumn);
	EndIf;
EndProcedure

&AtClient
Procedure DiffDocOnActivate(Source, Receiver, MapSource, MapReceiver)
	
	ThisObject.BlockDiffDocActivate = True;
	
	CurrentArea = Source.FormItem.CurrentArea;
	
	If CurrentArea.AreaType = SpreadsheetDocumentCellAreaType.Table Then
		
		SelectedArea = Receiver.Area();
		
	Else
	
		If CurrentArea.Bottom < MapSource.Rows.Count() Then
			RowNumber = MapSource.Rows[CurrentArea.Bottom].Value;
		Else
			RowNumber = CurrentArea.Bottom - MapSource.Rows.Count() + MapReceiver.Rows.Count();
		EndIf;
		
		If CurrentArea.Left < MapSource.Columns.Count() Then
			ColumnNumber = MapSource.Columns[CurrentArea.Left].Value;
		Else
			ColumnNumber = CurrentArea.Left - MapSource.Columns.Count() + MapReceiver.Columns.Count();
		EndIf;
		
		SelectedArea = Undefined;
		
		If CurrentArea.AreaType = SpreadsheetDocumentCellAreaType.Rectangle Then		
			If RowNumber <> Undefined And ColumnNumber <> Undefined Then
				SelectedArea = Receiver.FormAttribute.Area(RowNumber, ColumnNumber);
			EndIf;
		ElsIf CurrentArea.AreaType = SpreadsheetDocumentCellAreaType.Rows Then
			If RowNumber <> Undefined Then
				SelectedArea = Receiver.FormAttribute.Area(RowNumber, 0, RowNumber, 0);
			EndIf;
		ElsIf CurrentArea.AreaType = SpreadsheetDocumentCellAreaType.Columns Then
			If ColumnNumber <> Undefined Then
				SelectedArea = Receiver.FormAttribute.Area(0, ColumnNumber, 0, ColumnNumber);
			EndIf;
		Else
			Return;
		EndIf;
	EndIf;
	
	Receiver.FormItem.CurrentArea = SelectedArea;
	ThisObject.BlockDiffDocActivate = False;
EndProcedure
	
&AtServer
Procedure CompareSpreadsheetDocuments()
	LeftDocumentTable = ReadSpreadsheetDocument(ThisObject.DiffDocLeft);
	RightDocumentTable = ReadSpreadsheetDocument(ThisObject.DiffDocRight);
	
	Mapping = CreateMapping(LeftDocumentTable, RightDocumentTable, True);
	LeftRowMapping = Mapping[0];
	RightRowMapping = Mapping[1];
	
	Mapping = CreateMapping(LeftDocumentTable, RightDocumentTable, False);
	LeftColumnMapping = Mapping[0];
	RightColumnMapping = Mapping[1];
	
	LeftDocumentTable  = Undefined;
	RightDocumentTable = Undefined;
			
	BackColor_Delete    = WebColors.LightPink;
	BackColor_Add	    = WebColors.LightGreen;
	BackColor_Changed	= WebColors.LightCyan;
	TextColor_Changed	= WebColors.Blue;

	LeftTableHeight = ThisObject.DiffDocLeft.TableHeight;
	LeftTableWidth  = ThisObject.DiffDocLeft.TableWidth;
	
	RightTableHeight = ThisObject.DiffDocRight.TableHeight;
	RightTableWidth  = ThisObject.DiffDocRight.TableWidth;

	For RowNumber = 1 To LeftRowMapping.Count() - 1 Do
		If LeftRowMapping[RowNumber].Value = Undefined Then
			ThisObject.DiffDocLeft.Area(RowNumber, 1, RowNumber, LeftTableWidth).BackColor = BackColor_Delete;
			
			NewDiffRow = ThisObject.DiffCellsLeft.Add();
			NewDiffRow.NumberRow = RowNumber;
			NewDiffRow.NumberColumn = 0;
			
		EndIf;		
	EndDo;
	
	For ColumnNumber = 1 По LeftColumnMapping.Count() - 1 Do
		If LeftColumnMapping[ColumnNumber].Value = Undefined Then
			ThisObject.DiffDocLeft.Area(1, ColumnNumber, LeftTableHeight, ColumnNumber).BackColor = BackColor_Delete;
			
			NewDiffRow = ThisObject.DiffCellsLeft.Add();
			NewDiffRow.NumberRow = 0;
			NewDiffRow.NumberColumn = ColumnNumber;
			
		EndIf;
	EndDo;
	
	For RowNumber = 1 To RightRowMapping.Count() - 1 Do
		If RightRowMapping[RowNumber].Value = Undefined Then
			ThisObject.DiffDocRight.Area(RowNumber, 1, RowNumber, RightTableWidth).BackColor = BackColor_Add;
			
			NewDiffRow = ThisObject.DiffCellsRight.Add();
			NewDiffRow.NumberRow = RowNumber;
			NewDiffRow.NumberColumn = 0;
			
		EndIf;
	EndDo;
	
	For ColumnNumber = 1 To RightColumnMapping.Count() - 1 Do
		If RightColumnMapping[ColumnNumber].Value = Undefined Then
			ThisObject.DiffDocRight.Area(1, ColumnNumber, RightTableHeight, ColumnNumber).BackColor = BackColor_Add;
			
			NewDiffRow = ThisObject.DiffCellsRight.Add();
			NewDiffRow.NumberRow = 0;
			NewDiffRow.NumberColumn = ColumnNumber;
			
		EndIf;
	EndDo;
	
	For RowNumber1 = 1 To LeftRowMapping.Count() - 1 Do
		
		RowNumber2 = LeftRowMapping[RowNumber1].Value;
		If RowNumber2 = Undefined Then
			Continue;
		EndIf;
		
		For ColumnNumber1 = 1 To LeftColumnMapping.Count() - 1 Do
			
			ColumnNumber2 = LeftColumnMapping[ColumnNumber1].Value;
			If ColumnNumber2 = Undefined Then
				Continue;
			EndIf;
			
			Area1 = ThisObject.DiffDocLeft.Area(RowNumber1, ColumnNumber1, RowNumber1, ColumnNumber1);
			Area2 = ThisObject.DiffDocRight.Area(RowNumber2, ColumnNumber2, RowNumber2, ColumnNumber2);
			
			If Not CompareAreas(Area1, Area2) Then
				
				Area1 = ThisObject.DiffDocLeft.Area(RowNumber1, ColumnNumber1);
				Area2 = ThisObject.DiffDocRight.Area(RowNumber2, ColumnNumber2);
				
				Area1.TextColor = TextColor_Changed;
				Area2.TextColor = TextColor_Changed;
				
				Area1.BackColor = BackColor_Changed;
				Area2.BackColor = BackColor_Changed;
				
				NewDiffRow = ThisObject.DiffCellsLeft.Add();
				NewDiffRow.NumberRow = RowNumber1;
				NewDiffRow.NumberColumn = ColumnNumber1;
				
				NewDiffRow = ThisObject.DiffCellsRight.Add();
				NewDiffRow.NumberRow = RowNumber2;
				NewDiffRow.NumberColumn = ColumnNumber2;
				
			EndIf;
		EndDo;
	EndDo;
	
	ThisObject.DiffCellsLeft.Sort("NumberRow, NumberColumn");
	ThisObject.DiffCellsRight.Sort("NumberRow, NumberColumn");	
EndProcedure

&AtServer
Function CompareAreas(Area1, Area2)
	If Area1.Text <> Area2.Text Then
		Return False;
	EndIf;
	
	If Area1.Comment.Text <> Area2.Comment.Text Then
		Return False;
	EndIf;
	
	Return True;
EndFunction

&AtServer
Function ReadSpreadsheetDocument(SourceSpreadsheetDocument)
	
	CountColumns = SourceSpreadsheetDocument.TableWidth;
	
	If CountColumns = 0 Then
		Return New ValueTable();
	EndIf;
	
	SpreadsheetDocument = New SpreadsheetDocument();
	For ColumnNumber = 1 To CountColumns Do
		SpreadsheetDocument.Area(1, ColumnNumber, 1, ColumnNumber).Text = "Number_" + Format(ColumnNumber,"NG=0;");
	EndDo;
	
	SpreadsheetDocument.Put(SourceSpreadsheetDocument);
	QueryBuilder = New QueryBuilder();
	QueryBuilder.DataSource = New DataSourceDescription(SpreadsheetDocument.Area());
	QueryBuilder.Execute();
	Return QueryBuilder.Result.Unload();	
EndFunction

&AtServer
Function CreateMapping(LeftTable, RightTable, ByRow)
	Data_LeftTable = GetDataForCompare(LeftTable, ByRow);
	Data_RightTable = GetDataForCompare(RightTable, ByRow);
	
	If ByRow Then
		MappingResult_Left = New ValueList();
		MappingResult_Left.LoadValues(New Array(LeftTable.Count() + 1));
		
		MappingResult_Right = New ValueList();
		MappingResult_Right.LoadValues(New Array(RightTable.Count() + 1));		
	Else
		MappingResult_Left = New ValueList();
		MappingResult_Left.LoadValues(New Array(LeftTable.Columns.Count() + 1));
		
		MappingResult_Right = New ValueList();
		MappingResult_Right.LoadValues(New Array(RightTable.Columns.Count() + 1));
	EndIf;
	
	Query = New Query();
	Query.Text =
	"SELECT
	|	*
	|INTO LeftTable
	|FROM
	|	&Data_LeftTable AS Data_LeftTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	*
	|INTO RightTable
	|FROM
	|	&Data_RightTable AS Data_RightTable
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	LeftTable.Number AS NumberLeft,
	|	RightTable.Number AS NumberRight,
	|	CASE
	|		WHEN RightTable.Number - LeftTable.Number < 0
	|			THEN LeftTable.Number - RightTable.Number
	|		ELSE RightTable.Number - LeftTable.Number
	|	END AS DistanceOfBegin,
	|	CASE
	|		WHEN &RightTable_Count - RightTable.Number - (&LeftTable_Count - LeftTable.Number) < 0
	|			THEN &LeftTable_Count - LeftTable.Number - (&RightTable_Count - RightTable.Number)
	|		ELSE &RightTable_Count - RightTable.Number - (&LeftTable_Count - LeftTable.Number)
	|	END AS DistanceOfEnd,
	|	SUM(CASE
	|		WHEN LeftTable.Value <> """"
	|			THEN CASE
	|				WHEN LeftTable.Count < RightTable.Count
	|					THEN LeftTable.Count
	|				ELSE RightTable.Count
	|			END
	|		ELSE 0
	|	END) AS ValueMatches,
	|	SUM(CASE
	|		WHEN LeftTable.Count < RightTable.Count
	|			THEN LeftTable.Count
	|		ELSE RightTable.Count
	|	END) AS TotalMatches
	|INTO GroupingData
	|FROM
	|	LeftTable AS LeftTable
	|		INNER JOIN RightTable AS RightTable
	|		ON LeftTable.Value = RightTable.Value
	|GROUP BY
	|	LeftTable.Number,
	|	RightTable.Number,
	|	CASE
	|		WHEN RightTable.Number - LeftTable.Number < 0
	|			THEN LeftTable.Number - RightTable.Number
	|		ELSE RightTable.Number - LeftTable.Number
	|	END,
	|	CASE
	|		WHEN &RightTable_Count - RightTable.Number - (&LeftTable_Count - LeftTable.Number) < 0
	|			THEN &LeftTable_Count - LeftTable.Number - (&RightTable_Count - RightTable.Number)
	|		ELSE &RightTable_Count - RightTable.Number - (&LeftTable_Count - LeftTable.Number)
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	GroupingData.NumberLeft AS NumberLeft,
	|	GroupingData.NumberRight AS NumberRight,
	|	GroupingData.ValueMatches AS ValueMatches,
	|	GroupingData.TotalMatches AS TotalMatches,
	|	CASE
	|		WHEN GroupingData.DistanceOfBegin < GroupingData.DistanceOfEnd
	|			THEN GroupingData.DistanceOfBegin
	|		ELSE GroupingData.DistanceOfEnd
	|	END AS MinDistance
	|FROM
	|	GroupingData AS GroupingData
	|
	|ORDER BY
	|	ValueMatches DESC,
	|	TotalMatches DESC,
	|	MinDistance,
	|	NumberLeft,
	|	NumberRight";

	Query.SetParameter("Data_LeftTable", Data_LeftTable);
	Query.SetParameter("Data_RightTable", Data_RightTable);
	Query.SetParameter("LeftTable_Count", LeftTable.Count());
	Query.SetParameter("RightTable_Count", RightTable.Count());
	
	QuerySelection = Query.Execute().Select();
	
	While QuerySelection.Next() Do
		If MappingResult_Left[QuerySelection.NumberLeft].Value = Undefined
			And MappingResult_Right[QuerySelection.NumberRight].Value = Undefined Then
				MappingResult_Left[QuerySelection.NumberLeft].Value = QuerySelection.NumberRight;
				MappingResult_Right[QuerySelection.NumberRight].Value = QuerySelection.NumberLeft;
		EndIf;
	EndDo;
	
	Result = New Array();
	Result.Add(MappingResult_Left);
	Result.Add(MappingResult_Right);
	
	Return Result;
EndFunction

&AtServer
Function GetDataForCompare(ValueTableSource, ByRow)
	Result = New ValueTable();
	Result.Columns.Add("Number", New TypeDescription("Number"));
	Result.Columns.Add("Value",	 New TypeDescription("String", , New StringQualifiers(100)));
	
	Bound1 = ?(ByRow, ValueTableSource.Count(), ValueTableSource.Columns.Count()) - 1;
	Bound2 = ?(ByRow, ValueTableSource.Columns.Count(), ValueTableSource.Count()) - 1;
		
	For Index1 = 0 To Bound1 Do
		For Index2 = 0 To Bound2 Do
			NewRow = Result.Add();
			NewRow.Number = Index1 + 1;
			NewRow.Value = ?(ByRow, ValueTableSource[Index1][Index2], ValueTableSource[Index2][Index1]);
		EndDo;
	EndDo;

	Result.Columns.Add("Count", New TypeDescription("Number"));
	Result.FillValues(1, "Count");
	
	Result.GroupBy("Number, Value", "Count");
	
	Return Result;
EndFunction
	
#EndRegion
