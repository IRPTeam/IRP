
&AtServer
Procedure OnSaveDataInSettingsAtServer(Settings)
	Settings.Insert("DataSettingsComposer", New ValueStorage(DataSettingsComposer.GetSettings()));
EndProcedure

&AtServer
Procedure OnLoadDataFromSettingsAtServer(Settings)
	If Not Settings["DataSettingsComposer"] = Undefined Then
		DataSettingsComposer.LoadSettings(Settings["DataSettingsComposer"].Get());
		DataSettingsComposer.Settings.Selection.Items.Clear();
	EndIf;
EndProcedure

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	Schema = Reports.T0001_FilesAnalyser.GetTemplate("MainDataCompositionSchema"); // DataCompositionSchema
	Address = PutToTempStorage(Schema, ThisObject.UUID);
	AvailableSettingsSource = New DataCompositionAvailableSettingsSource(Address);
	DataSettingsComposer.Initialize(AvailableSettingsSource);
    DataSettingsComposer.LoadSettings(Schema.DefaultSettings);
    DataSettingsComposer.Settings.Selection.Items.Clear();
EndProcedure

#Region Analyze

&AtClient
Procedure Analyze(Command)
	If IsBlankString(Path) Then
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_149, "Path");
		Return;
	EndIf;
	AnalyzeAtServer();
EndProcedure

&AtServer
Procedure AnalyzeAtServer()
	FileTable.Clear();
	DataTable = GetReportData();
	CorrectPath = StrConcat(StrSplit(Path, "/\", False), "/");
	FillFilePath(DataTable, DataTable, CorrectPath);
EndProcedure

&AtServer
Procedure FillFilePath(DataTable, DataTableTop, CorrectPath)
	For Each Row In DataTable.Rows Do
		If Row.File = Undefined Then
			FillFilePath(Row, DataTableTop, CorrectPath);
			Continue;
		EndIf;
		NewRow = FileTable.Add();
		Descriptions = New Array;
		Descriptions.Add(CorrectPath);
		For Each Column In DataTableTop.Columns Do 
			If Column.ValueType.ContainsType(Type("Number")) Then
				LocalPath = Format(Row[Column.Name], "NG=");
			ELsIf Column.ValueType.ContainsType(Type("Date")) Then
				LocalPath = Format(Row[Column.Name], "DF=dd.MM.yyyy;");
			Else
				LocalPath = String(Row[Column.Name]);
			EndIf;
			
			LocalPath = StrConcat(StrSplit(LocalPath, ":/\"));
			If IsBlankString(LocalPath) Then
				LocalPath = "_";
			EndIf;
			
			LocalPath = TrimAll(LocalPath);
			Descriptions.Add(LocalPath);
		EndDo;
		NewRow.Path = StrConcat(Descriptions, "/");
		NewRow.File = Row.File;
	EndDo;
EndProcedure

#EndRegion

#Region Check

&AtClient
Procedure Check(Command)
	For Each Row In FileTable Do
		File = New File(Row.Path);
		Row.FileExists = File.Exists();
	EndDo;
EndProcedure

#EndRegion

#Region Download

&AtClient
Procedure Download(Command)
	For Each Row In FileTable Do
		If Row.FileExists Then
			Continue;
		EndIf;
		
		PictureParameters = PictureViewerServer.CreatePictureParameters(Row.File);
		URI = PictureViewerClient.GetPictureURL(PictureParameters); //String
		If IsBlankString(URI) Then
			Row.Error = R().Error_150;
			Continue;
		EndIf;
		BD = GetFromTempStorage(URI); // BinaryData
		If Not ValueIsFilled(BD) Then
			Row.Error = R().Error_151;
			Continue;
		EndIf;
		BD.WriteAsync(Row.Path);
	EndDo;
EndProcedure

#EndRegion

#Region Service

&AtServer
Function GetReportData()
	Schema = Reports.T0001_FilesAnalyser.GetTemplate("MainDataCompositionSchema"); // DataCompositionSchema
	
	TemplateComposer = New DataCompositionTemplateComposer;
	DataCompositionTemplate = TemplateComposer.Execute(
		Schema, 
		ThisObject.DataSettingsComposer.GetSettings(), , , 
		Type("DataCompositionValueCollectionTemplateGenerator"));
	
	DataCompositionProcessor = New DataCompositionProcessor;
	DataCompositionProcessor.Initialize(DataCompositionTemplate);
	
	DataTable = New ValueTree();
	OutputProcessor = New DataCompositionResultValueCollectionOutputProcessor;
	OutputProcessor.SetObject(DataTable);
	OutputProcessor.Output(DataCompositionProcessor);
	
	Return DataTable;
EndFunction

#EndRegion