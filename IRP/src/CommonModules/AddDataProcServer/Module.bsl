Function ConnectAddDataProc(Info, AddInfo)
	
	If ValueIsFilled(Info.ExternalDataProc.PathToExtDataProcForTest) Then
		DataProcBD = New BinaryData(Info.ExternalDataProc.PathToExtDataProcForTest);
		DataProcStorage = PutToTempStorage(DataProcBD);
		If Info.ExternalDataProc.UnsafeMode Then
			UnsafeOperationProtectionDescription = New UnsafeOperationProtectionDescription();
			UnsafeOperationProtectionDescription.UnsafeOperationWarnings = False;
			DataProc = ExternalDataProcessors.Connect(DataProcStorage, 
			                                          Info.ExternalDataProcName, 
			                                          False, 
			                                          UnsafeOperationProtectionDescription);
		Else
			DataProc = ExternalDataProcessors.Connect(DataProcStorage, Info.ExternalDataProcName);
		EndIf;
	Else
		DataProcStorage = PutToTempStorage(Info.ExternalDataProc.DataProcStorage.Get(), New UUID());
		If Info.ExternalDataProc.UnsafeMode Then
			UnsafeOperationProtectionDescription = New UnsafeOperationProtectionDescription();
			UnsafeOperationProtectionDescription.UnsafeOperationWarnings = False;
			DataProc = ExternalDataProcessors.Connect(DataProcStorage, 
			                                          Info.ExternalDataProcName, 
			                                          False, 
			                                          UnsafeOperationProtectionDescription);
		Else
			DataProc = ExternalDataProcessors.Connect(DataProcStorage, Info.ExternalDataProcName);
		EndIf;
	EndIf;
	
	Return DataProc;
EndFunction

Function CreateAddDataProc(Info, AddInfo)
	DataProc = Undefined;
	
	If ValueIsFilled(Info.ExternalDataProc.PathToExtDataProcForTest) Then
		
		File = New File(Info.ExternalDataProc.PathToExtDataProcForTest);
		If File.Exist() Then
			DataProc = ExternalDataProcessors.Create(Info.ExternalDataProc.PathToExtDataProcForTest, Info.ExternalDataProcName);
		EndIf;
	Else
		ConnectedDataProc(Info, AddInfo);
		DataProc = ExternalDataProcessors.Create(Info.ExternalDataProcName);
	EndIf;
	
	Return DataProc;
EndFunction


Function CallMetodAddDataProc(Info, AddInfo = Undefined) Export
	Result = Undefined;
	
	If UseInternalDataProcessor(Info.ExternalDataProcName) Then
		Result = DataProcessors[Info.ExternalDataProcName].Create();
		If AddInfo <> Undefined And AddInfo.Property("ClientCall") And AddInfo.ClientCall Then
			Return Undefined;
		Else
			Return Result;
		EndIf;
	Else
		ExtDataProc = Undefined;
		If NOT Info.Create Then
			ExtDataProc = ConnectedDataProc(Info, AddInfo);
		Else
			ExtDataProc = CreateAddDataProc(Info, AddInfo);
		EndIf;
		Result = ExtDataProc;
	EndIf;
	
	If Result = Undefined Then
		Raise StrTemplate(R().Error_071, Info.ExternalDataProcName);
	EndIf;
	
	Return Result;
EndFunction

Function ConnectedDataProc(Info, AddInfo)
	ExtDataProc = Undefined;
	If NOT SessionParameters.ConnectedAddDataProc.Property(Info.ExternalDataProcName) Then
		ExtDataProc = ConnectAddDataProc(Info, AddInfo);
		ConnectedAddDataProc = New Structure(SessionParameters.ConnectedAddDataProc);
		ConnectedAddDataProc.Insert(Info.ExternalDataProcName, ExtDataProc);
		SessionParameters.ConnectedAddDataProc = New FixedStructure(ConnectedAddDataProc);
	Else
		ExtDataProc = SessionParameters.ConnectedAddDataProc[Info.ExternalDataProcName];
	EndIf;
	Return ExtDataProc;
EndFunction

Function AddDataProcInfo(RefSettings, AddInfo = Undefined) Export
	If TypeOf(RefSettings) = Type("CatalogRef.ExternalDataProc") Then
		Info = New Structure();
		Info.Insert("ExternalDataProc", RefSettings);
		Info.Insert("ExternalDataProcName", RefSettings.Name);
		Info.Insert("Create", False);
		Return Info;
	Else
		Info = New Structure;
		Info.Insert("ExternalDataProc", RefSettings.ExternalDataProc);
		Info.Insert("ExternalDataProcName", RefSettings.ExternalDataProc.Name);
		Info.Insert("Create", False);
		Return Info;
	EndIf;
EndFunction

Function UseInternalDataProcessor(DataProcName) Export
	Return Metadata.DataProcessors.Find(DataProcName) <> Undefined;
EndFunction

