
&AtClient
Procedure ShowJustErrorsOnChange(Item)
	If ShowJustErrors Then
		Items.Result.RowFilter = New FixedStructure("Error", True);
	Else
		Items.Result.RowFilter = Undefined;
	EndIf;		
EndProcedure

&AtClient
Procedure UpdateCurreiciesTable(Command)
	If Not CheckFilling() Then
		Return;
	EndIf;	
	UpdateCurreiciesTableOnServer();
	Items.GroupMainPages.CurrentPage = Items.GroupResult;
EndProcedure

&AtServer
Procedure UpdateCurreiciesTableOnServer()
	Object.Result.Clear();
	
	DocumentsNamesArray = DocumentsWithCurrenciesTabularSection();
	Query = New Query;
	Query.SetParameter("DateBegin", Period.StartDate);
	Query.SetParameter("DateEnd", Period.EndDate);
	Query.SetParameter("Company", Companies.UnloadValues());
	Query.Text = QueryTextCurrenciesUpdate(DocumentsNamesArray);
	
	Selection = Query.Execute().Select();
	While Selection.Next() Do
		NewRow = Object.Result.Add();
		NewRow.Ref = Selection.Ref;
		DocObject = Selection.Ref.GetObject(); //DocumentObject
		DocObject.AdditionalProperties.Insert("UpdateCurrenciesTable", True);
		Try
			DocObject.Write(DocumentWriteMode.Posting);
			NewRow.Comment = "Ok";	
		Except
			NewRow.Comment = ErrorProcessing.DetailErrorDescription(ErrorInfo());
			NewRow.Error = True;
		EndTry;			
	EndDo;		
EndProcedure

&AtServer
Function DocumentsWithCurrenciesTabularSection()	
	DocumentsNamesArray = New Array();	
	For Each DocumentMetadata In Metadata.Documents Do
		If DocumentMetadata.TabularSections.Find("Currencies") <> Undefined Then
			DocumentsNamesArray.Add(DocumentMetadata.Name);
		EndIf;		
	EndDo;
	
	Return DocumentsNamesArray;
EndFunction

&AtServer
Function QueryTextCurrenciesUpdate(DocumentsNamesArray)	
	QueryText = "";
	
	If DocumentsNamesArray.Count() = 0 Then
		Return QueryText;
	EndIf;
	
	TextsArray = New Array;
	
	For Each DocumentName In DocumentsNamesArray Do
		QueryText = "SELECT Table.Ref FROM Document.%1 AS Table WHERE Table.Date BETWEEN &DateBegin AND &DateEnd AND Table.Company IN (&Company) AND Table.Posted";
		QueryText = StrTemplate(QueryText, DocumentName);
		TextsArray.Add(QueryText);
	EndDo;
	
	QueryText = StrConcat(TextsArray, " UNION ALL ");
	Return QueryText;
EndFunction