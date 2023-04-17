
&AtClient
Procedure FillDocuments(Command)
	DocumentList.Clear();
	FillDocumentsAtServer();
EndProcedure

&AtServer
Procedure FillDocumentsAtServer()
	QueryTxt = Reports.AdditionalDocumentTablesCheck.GetTemplate("Template").DataSets[0].Query;
	QueryTxt = QueryTxt + 
		"
		|WHERE 
		|	AllDocuments.Ref.Date BETWEEN &StartDate AND &EndDate
		|ORDER BY 
		|	AllDocuments.Ref.Date";
	Query = New Query(QueryTxt);
	Query.SetParameter("StartDate", Period.StartDate);
	Query.SetParameter("EndDate", Period.EndDate);
	Result = Query.Execute().Unload();
	
	DocumentList.Load(Result);
EndProcedure

&AtClient
Procedure CheckDocuments(Command)
	CheckList.GetItems().Clear();
	CheckDocumentsAtServer();
	Items.PagesDocuments.CurrentPage = Items.PageCheck;
EndProcedure

&AtServer
Procedure CheckDocumentsAtServer()
	For Each Document In DocumentList Do
		Result = AdditionalDocumentTableControl.CheckDocument(Document.Ref, , True);
		If Result.Count() = 0 Then
			Continue;
		EndIf;
		
		ParentRow = CheckList.GetItems().Add();
		ParentRow.Ref = Document.Ref;
		ParentRow.LineNumber = Result.Count();
		ParentRow.Date = Document.Ref.Date;
		For Each Row In Result Do
			NewRow = ParentRow.GetItems().Add();
			FillPropertyValues(NewRow, Row);
			NewRow.Date = Row.Ref.Date;
		EndDo;
		
	EndDo;
EndProcedure

&AtClient
Procedure QuickFix(Command)
	Map = New Map;
	For Each RowID In Items.CheckList.SelectedRows Do
		
		Row = CheckList.FindByID(RowID);
		
		If Row.Fixed Then
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
		
	EndDo;
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
