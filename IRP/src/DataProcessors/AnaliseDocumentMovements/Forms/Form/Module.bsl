
&AtClient
Procedure FillMovements(Command)
	FillMovementsAtServer();
EndProcedure

&AtServer
Procedure FillMovementsAtServer()
	Object.Info.Clear();
	For Each Document In Metadata.Documents Do
		For Each Reg In Document.RegisterRecords Do
			If Not ShowAllRegisters AND PostingServer.NotUseRegister(Reg.Name) Then
				Continue;
			EndIf;
			
			NewRow = Object.Info.Add();
			NewRow.Document = Document.Name;
			NewRow.Register = Reg.Name;
			NewRow.Recorder = True;
		EndDo;
	EndDo;
	
	For Each Document In Metadata.Documents Do
		Ref = Documents[Document.Name].EmptyRef();
		Try
			ParametersStructure = Documents[Document.Name].GetInformationAboutMovements(Ref);
		Except
//			CommonFunctionsClientServer.ShowUsersMessage(ErrorProcessing.DetailErrorDescription(ErrorInfo()));
			Continue;
		EndTry;
		
		TotalQueryArray = ParametersStructure.QueryTextsSecondaryTables;
		For Each El In ParametersStructure.QueryTextsMasterTables Do
			TotalQueryArray.Add(El);
		EndDo;
		
		QuerySchema = New QuerySchema;
		QuerySchema.SetQueryText(StrConcat(TotalQueryArray, Chars.LF+ Chars.LF + ";" + Chars.LF + Chars.LF));
		For Each Batch In QuerySchema.QueryBatch Do
			FindRows = Object.Info.FindRows(New Structure("Document, Register", Document.Name, Batch.PlacementTable));
			If Not FindRows.Count() Then
				Continue;
			EndIf;
			Conditions = New Array;
			For Each Filter In Batch.Operators[0].Filter Do
				Conditions.Add(Filter);
			EndDo;
			FindRows[0].Conditions = StrConcat(Conditions, Chars.LF);
			FindRows[0].Query = Batch.GetQueryText();
		EndDo;
	
	EndDo;
EndProcedure

&AtClient
Procedure GenerateFeatureTemplate(Command)
	Data = GenerateFeatureTemplateAtServer();
	OpenForm("CommonForm.HTMLField", New Structure("HTML", Data));
EndProcedure

&AtServer
Function GenerateFeatureTemplateAtServer()
	AllDocument = Object.Info.Unload();
	AllDocument.GroupBy("Document");
	
	HeadTemplate = DataProcessors.AnaliseDocumentMovements.GetTemplate("FeatureTemplate").GetText();
	RowTemplate = DataProcessors.AnaliseDocumentMovements.GetTemplate("FeatureRowTemplate").GetText();
	
	FeatureArray = New Array;
	FeatureNumber = 0;
	For Each DocumentRow In AllDocument Do
		FeatureNumber = FeatureNumber + 1;
		StrParam = New Structure("DocumentSynonym, DocumentName, FeatureNumber, RegisterSynonym");
		StrParam.DocumentSynonym = Metadata.Documents[DocumentRow.Document].Synonym; 
		StrParam.DocumentName = DocumentRow.Document;
		StrParam.FeatureNumber = FeatureNumber;
		StrParam.RegisterSynonym = "";
		
		FeatureArray.Add(ReplaceTemplate(HeadTemplate, StrParam));
		
		FindReg = Object.Info.FindRows(New Structure("Document", DocumentRow.Document));
		For Each RegRow In FindReg Do
			FeatureNumber = FeatureNumber + 1;
			StrParam.FeatureNumber = FeatureNumber;
			StrParam.RegisterSynonym = Metadata.AccumulationRegisters[RegRow.Register].Synonym;
			
			FeatureArray.Add(ReplaceTemplate(RowTemplate, StrParam));
		EndDo;
	EndDo;
	Return StrConcat(FeatureArray);
EndFunction

&AtServer
Function ReplaceTemplate(Val Template, StrParam)
	
	For Each Elem In StrParam Do
		Template = StrReplace(Template, "#" + Elem.Key + "#", Elem.Value);		
	EndDo;
	Return Template;
EndFunction
