
&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	ThisObject.Company.Add(Catalogs.Companies.FindByCode(85));	
EndProcedure

&AtClient
Procedure OnOpen(Cancel)
	OnlyPosted = True;
EndProcedure

#Region FillDocuments
&AtClient
Procedure FillDocuments(Command)
	DocumentList.Clear();
	FillDocumentsAtServer();
EndProcedure

&AtServer
Procedure FillDocumentsAtServer()
	
	Template = "SELECT Doc.Ref, Doc.Date, VALUETYPE(Doc.Ref) %1 %2 FROM Document.%3 AS Doc WHERE Doc.Date BETWEEN &StartDate AND &EndDate";
	Array  = New Array;
	For Each Doc In Metadata.Documents Do
		Array.Add(StrTemplate(Template, ?(Array.Count(), "", "AS DocumentType"), ?(Array.Count(), "", "INTO AllDocuments"), Doc.Name));
	EndDo;	
	
	QueryTxt = StrConcat(Array, Chars.LF + "UNION ALL" + Chars.LF) +	"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	AllDocuments.Date AS Date,
	|	AllDocuments.Ref,
	|	AllDocuments.DocumentType,
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
	
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Period.StartDate);
	Query.SetParameter("EndDate", Period.EndDate);
	Query.SetParameter("OnlyPosted", OnlyPosted);
	Query.SetParameter("CompanySet", Company.Count() > 0);
	Query.SetParameter("CompanyList", Company.UnloadValues());
	Result = Query.Execute().Unload();
	
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
					
	DocsInPack = 100;
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
Procedure CheckAccountingAnalytics(Command)
	PostingInfo.GetItems().Clear();
	JobSettingsArray = GetJobsForCheckPostingDocuments("AccountingServer.CheckDocumentArray_AccountingAnalytics");
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);	
	Items.PagesDocuments.CurrentPage = Items.PagePosting;	
EndProcedure

&AtServer
Function GetJobsForCheckPostingDocuments(ProcedurePath)
	
	TypesTable = ThisObject.DocumentList.Unload(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForCheckPostingDocuments_Callback";
	JobDataSettings.ProcedurePath = ProcedurePath;
	JobDataSettings.CallbackWhenAllJobsDone = False;
					
	DocsInPack = 100;
	For Each TypeItem In TypesTable Do
		DocumentsRows = DocumentList.FindRows(New Structure("DocumentType", TypeItem.DocumentType));
		 
		StreamArray = New Array;
		Pack = 1;
		TotalDocs = DocumentsRows.Count();
		For Each Row In DocumentsRows Do
			StreamArray.Add(Row.Ref);
		 	
		 	If StreamArray.Count() = DocsInPack Then
		 		JobSettings = BackgroundJobAPIServer.JobSettings();
				JobSettings.ProcedureParams.Add(StreamArray);
				JobSettings.ProcedureParams.Add(True);
				JobSettings.Description = String(TypeItem.DocumentType) + ": " + Pack + " * (" + DocsInPack + ") / " + TotalDocs;
				JobDataSettings.JobSettings.Add(JobSettings);
				
				StreamArray = New Array;
		 		Pack = Pack + 1;
		 	EndIf;
		EndDo;
		If StreamArray.Count() > 0 Then
			JobSettings = BackgroundJobAPIServer.JobSettings();
			JobSettings.ProcedureParams.Add(StreamArray);
			JobSettings.ProcedureParams.Add(True);
			JobSettings.Description = String(TypeItem.DocumentType) + ": " + Pack + " * (" + StreamArray.Count() + ") / " + TotalDocs;
			JobDataSettings.JobSettings.Add(JobSettings);
	 	EndIf;
	EndDo;

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
					
	DocsInPack = 100;
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
EndProcedure

&AtServer
Procedure PostingInfo_UpdateTable(Ref, NewMovementStorage)	
	If AccountingServer.IsAccountingAnalyticsRegister(CurrentRegName) Then
		ValueTable = AccountingServer.GetCurrentAnalyticsRegisterRecord(Ref, CurrentRegName);
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
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForWriteRecordSet_Callback";
	JobDataSettings.ProcedurePath = "PostingServer.WriteDocumentsRecords";
					
	DocsInPack = 100;
	StreamArray = New Array;
	For Each Doc In PostingInfo.GetItems() Do
		
		For Each Row In Doc.GetItems() Do
		
			If Not Row.Select OR Row.Processed Then
				Continue;
			EndIf;
			
			Pack = 1;
			Str = New Structure;
			Str.Insert("Ref", Row.Ref);
			Str.Insert("NewMovement", Row.NewMovement);
			Str.Insert("RegName", Row.RegName);
			StreamArray.Add(Str);
			
			If StreamArray.Count() = DocsInPack Then
				JobSettings = BackgroundJobAPIServer.JobSettings();
				JobSettings.ProcedureParams.Add(StreamArray);
				JobSettings.ProcedureParams.Add(True);
				JobSettings.Description = "Write records: " + Pack + " * (" + DocsInPack + ")";
				JobDataSettings.JobSettings.Add(JobSettings);
				
				StreamArray = New Array;
				Pack = Pack + 1;
			EndIf;
		EndDo;
	EndDo;
	If StreamArray.Count() > 0 Then
		JobSettings = BackgroundJobAPIServer.JobSettings();
		JobSettings.ProcedureParams.Add(StreamArray);
		JobSettings.ProcedureParams.Add(True);
		JobSettings.Description = "Write records: " + Pack + " * (" + StreamArray.Count() + ")";
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

#EndRegion
