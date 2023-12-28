
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
	|
	|ORDER BY
	|	AllDocuments.Date";
	
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Period.StartDate);
	Query.SetParameter("EndDate", Period.EndDate);
	Query.SetParameter("OnlyPosted", OnlyPosted);
	Result = Query.Execute().Unload();
	
	DocumentList.Load(Result);
EndProcedure

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
&AtServer
Procedure GetJobsForCheckDocuments_Callback(Result) Export
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
				DocRefErrors.Insert(ErrorID, New Structure("Result, RowKey", New Array, New Array));
				Map.Insert(ErrorRow.Ref, DocRefErrors);
			EndIf;
			DocRefErrors[ErrorID].RowKey.Add(ErrorRow.RowKey);
		EndDo;
	EndDo;
	
	RunQuickFixLoop(Map);
	
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
			DocRefErrors.Insert(Row.ErrorID, New Structure("Result, RowKey", New Array, New Array));
		EndIf;
		
		DocRefErrors[Row.ErrorID].RowKey.Add(Row.RowKey);
	EndDo;
	
	RunQuickFixLoop(Map);
EndProcedure

&AtClient
Procedure RunQuickFixLoop(Map)
	TotalDocument = Map.Count();
	While True Do
		CurrentDoc = New Map;
		For Each Doc In Map Do
			CurrentDoc.Insert(Doc.Key, Doc.Value);
			Map.Delete(Doc.Key);
			
			If CurrentDoc.Count() > Int(TotalDocument / 100) Then
				Break;
			EndIf;
		EndDo;
		
		If CurrentDoc.Count() = 0 Then
			Break;
		EndIf;
		
		UserInterruptProcessing();
		Status("Quick fix. Left: " + Map.Count(), 100 * (TotalDocument - Map.Count()) / TotalDocument, Doc.Key);
		
		Result = QuickFixAtServer(CurrentDoc);
		SetFlagFixed(Result);
	EndDo;
	ShowMessageBox(, R().InfoMessage_005);
EndProcedure

&AtServerNoContext
Function QuickFixAtServer(Val CurrentDoc)
	For Each Doc In CurrentDoc Do
		For Each Error In Doc.Value Do
			Try
				Error.Value.Result = AdditionalDocumentTableControl.QuickFix(Doc.Key, Error.Value.RowKey, Error.Key);
			Except
				Errors = "Errors in " + Doc.Key + Chars.LF + ErrorProcessing.BriefErrorDescription(ErrorInfo());
				CommonFunctionsClientServer.ShowUsersMessage(Errors);
				Error.Value.Result.Add(Errors);
			EndTry;
		EndDo;
	EndDo;
	Return CurrentDoc;
EndFunction

&AtClient
Procedure SetFlagFixed(DocsData)
	For Each DocumentData In DocsData Do
		For Each ErrorRow In DocumentData.Value Do
			FixedArray = New Array;
			For Each RowKeyValue In ErrorRow.Value.RowKey Do
				FixedArray.Add(RowKeyValue);
			EndDo;
			If FixedArray.Count() = 0 Then
				Continue;
			EndIf;
			
			For Each CheckRow In ThisObject.CheckList.GetItems() Do
				If CheckRow.Ref = DocumentData.Key Then
					If ErrorRow.Value.Result.Count() = 0 Then
						AllFixed = True;
						For Each CheckSubRow In CheckRow.GetItems() Do
							If CheckSubRow.ErrorID = ErrorRow.Key And FixedArray.Find(CheckSubRow.RowKey) <> Undefined Then
								CheckSubRow.Fixed = True;
							EndIf;
							AllFixed = AllFixed And CheckSubRow.Fixed;
						EndDo;
						CheckRow.Fixed = AllFixed;
					Else
						ProblemWhileQuickFix = StrConcat(ErrorRow.Value.Result, Chars.CR);
						For Each CheckSubRow In CheckRow.GetItems() Do
							If CheckSubRow.ErrorID = ErrorRow.Key And FixedArray.Find(CheckSubRow.RowKey) <> Undefined Then
								CheckSubRow.ProblemWhileQuickFix = ProblemWhileQuickFix;
							EndIf;
						EndDo;
					EndIf;
					Break;
				EndIf;
			EndDo;
		EndDo;
	EndDo;
EndProcedure

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

#Region Posting

&AtClient
Procedure CheckPosting(Command)
	PostingInfo.GetItems().Clear();
	JobSettingsArray = GetJobsForCheckPostingDocuments();
	BackgroundJobAPIClient.OpenJobForm(JobSettingsArray, ThisObject);
	Items.PagesDocuments.CurrentPage = Items.PagePosting;
EndProcedure

&AtServer
Function GetJobsForCheckPostingDocuments()
	
	TypesTable = ThisObject.DocumentList.Unload(, "DocumentType");
	TypesTable.GroupBy("DocumentType");
	
	JobDataSettings = BackgroundJobAPIServer.JobDataSettings();
	JobDataSettings.CallbackFunction = "GetJobsForCheckPostingDocuments_Callback";
	JobDataSettings.ProcedurePath = "PostingServer.CheckDocumentArray";
	
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

// Get jobs for check posting documents callback.
// 
// Parameters:
//  Result - See BackgroundJobAPIServer.GetJobsResult
&AtServer
Procedure GetJobsForCheckPostingDocuments_Callback(Result) Export
	PostingInfoTree = FormAttributeToValue("PostingInfo");
	DocumentErrors = New Array;
	For Each Row In Result Do
		
		If Not Row.Result Then
			Continue;
		EndIf;
		
		RegInfoArray = CommonFunctionsServer.GetFromCache(Row.CacheKey);
		For Each DocRow In RegInfoArray Do
			ParentRow = PostingInfoTree.Rows.Add();
			ParentRow.Ref = DocRow.Ref;
			ParentRow.Date = DocRow.Ref.Date;
			
			For Each RegInfoData In DocRow.RegInfo Do
				NewRow = ParentRow.Rows.Add();
				FillPropertyValues(NewRow, RegInfoData);
				NewRow.Date = ParentRow.Date;
				NewRow.Ref = ParentRow.Ref;
			EndDo;
		 EndDo;
	EndDo;
	
	PostingInfoTree.Rows.Sort("Date, Ref, RegName", True);
	ValueToFormAttribute(PostingInfoTree, "PostingInfo");
EndProcedure

#EndRegion
