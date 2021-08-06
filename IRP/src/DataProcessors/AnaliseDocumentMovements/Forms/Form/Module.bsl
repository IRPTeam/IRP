
&AtClient
Procedure FillMovements(Command)
	FillMovementsAtServer();
EndProcedure

&AtServer
Procedure FillMovementsAtServer()
	Object.Info.Clear();
	For Each Document In Metadata.Documents Do
		For Each Reg In Document.RegisterRecords Do
			If ShowAllRegisters Or PostingServer.UseRegister(Reg.Name) Then
				NewRow = Object.Info.Add();
				NewRow.Document = Document.Name;
				NewRow.Register = Reg.Name;
				NewRow.Recorder = True;
			EndIf;
		EndDo;
	EndDo;
	
	For Each Document In Metadata.Documents Do
		Ref = Documents[Document.Name].EmptyRef();
		ParametersStructure = Documents[Document.Name].GetInformationAboutMovements(Ref);
		
		ParametersInfo = New Array;
		For Each Param In ParametersStructure.QueryParameters Do
			ParametersInfo.Add(Param.Key + ": " + TypeOf(Param.Value));
		EndDo;
		ParametersInfo = StrConcat(ParametersInfo, Chars.LF);
		
		TotalQueryArray = ParametersStructure.QueryTextsSecondaryTables;
		For Each El In ParametersStructure.QueryTextsMasterTables Do
			TotalQueryArray.Add(El);
		EndDo;
		TotalQueryArray.Add("SELECT NULL");
		QuerySchema = New QuerySchema;
		QuerySchema.SetQueryText(StrConcat(TotalQueryArray, Chars.LF+ Chars.LF + ";" + Chars.LF + Chars.LF));
		For Each Batch In QuerySchema.QueryBatch Do
			If TypeOf(Batch) = Type("QuerySchemaTableDropQuery") Then
				Continue;
			EndIf;
			FindRows = Object.Info.FindRows(New Structure("Document, Register", Document.Name, Batch.PlacementTable));
			If Not FindRows.Count() Then
				Continue;
			EndIf;
			Conditions = New Array;
			For Index = 0 To Batch.Operators.Count() - 1 Do
				Operator = Batch.Operators[Index];
				RecordType = "";
				
				For Each SelectedField In Operator.SelectedFields Do
					If Lower(SelectedField) = Lower("VALUE(AccumulationRecordType.Receipt)") Then
						FindRows[0].Receipt = True;
						RecordType = "Receipt";
					ElsIf 	Lower(SelectedField) = Lower("VALUE(AccumulationRecordType.Expense)") Then
						FindRows[0].Expense = True;
						RecordType = "Expense";
					EndIf;
				EndDo;
				If Batch.Operators.Count() > 1 Then
					Conditions.Add("Query " + ?(IsBlankString(RecordType), Index, RecordType) + ":");
				EndIf;
				For Each Filter In Operator.Filter Do
					Conditions.Add(Filter);
				EndDo;
			EndDo;
			FindRows[0].Conditions = StrReplace(StrConcat(Conditions, Chars.LF), "QueryTable.", "");
			FindRows[0].Query = Batch.GetQueryText();
			FindRows[0].Parameters = ParametersInfo;
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
