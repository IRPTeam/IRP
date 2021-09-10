Procedure SetSessionParameter(Name, Value, AddInfo = Undefined) Export
	SessionParameters[Name] = Value;
EndProcedure

Function GetObjectAttribute(Ref, Name) Export
	Return Ref[Name];
EndFunction

Function GetConstantValue(ConstantName) Export
	Return Constants[ConstantName].Get();
EndFunction

Procedure SetConstantValue(ConstantName, Value) Export
	Constants[ConstantName].Set(Value);
EndProcedure

Function GetCompositeObjectAttribute(Object, AttributeName) Export
	If ObjectHasAttribute(AttributeName, Object) Then
		Return GetObjectAttribute(Object, AttributeName);
	EndIf;
	Return Undefined;
EndFunction

Function ObjectHasAttribute(AttributeName, Object) Export
	If Object = Undefined Then
		Return False;
	EndIf;
	ValueKey = New UUID();
	Str = New Structure(AttributeName, ValueKey);
	FillPropertyValues(Str, Object);
	Return Str[AttributeName] <> ValueKey;
EndFunction

Procedure UpdateScheduledJob(ScheduledJob, AddJob) Export

	Var Job, ScheduledJobsList;

	ScheduledJobsList = ScheduledJobs.GetScheduledJobs(New Structure("Key", ScheduledJob.Key));
	For Each Job In ScheduledJobsList Do
		Job.Delete();
	EndDo;
	If AddJob Then
		ScheduledJob = ScheduledJobs.CreateScheduledJob(ScheduledJob);
		ScheduledJob.Use = True;
		ScheduledJob.Write();
	EndIf;

EndProcedure

Function GetSessionParameter(Name, AddInfo = Undefined) Export

	Return SessionParameters[Name];

EndFunction

Function GetMetaDataStructure(Ref) Export
	RefMetadata = Ref.Metadata();
	MetaDataStructure = New Structure();
	Attributes = New Structure();
	For Each Attribute In RefMetadata.Attributes Do
		Attributes.Insert(Attribute.Name);
	EndDo;

	MetaDataStructure.Insert("Attributes", Attributes);
	TabularSections = New Structure();
	For Each TabularSection In RefMetadata.TabularSections Do
		TabularRow = New Structure();
		For Each Attribute In TabularSection.Attributes Do
			TabularRow.Insert(Attribute.Name);
		EndDo;

		TabularSections.Insert(TabularSection.Name, New Structure("Name, Attributes", TabularSection.Name, TabularRow));
	EndDo;

	MetaDataStructure.Insert("TabularSections", TabularSections);

	Return MetaDataStructure;
EndFunction

Function GetManagerByMetadata(CurrentMetadata) Export
	MetadataName = CurrentMetadata.Name;
	If Metadata.Catalogs.Contains(CurrentMetadata) Then
		Return Catalogs[MetadataName];
	ElsIf Metadata.Documents.Contains(CurrentMetadata) Then
		Return Documents[MetadataName];
	ElsIf Metadata.Enums.Contains(CurrentMetadata) Then
		Return Enums[MetadataName];
	ElsIf Metadata.ChartsOfCharacteristicTypes.Contains(CurrentMetadata) Then
		Return ChartsOfCharacteristicTypes[MetadataName];
	ElsIf Metadata.ChartsOfAccounts.Contains(CurrentMetadata) Then
		Return ChartsOfAccounts[MetadataName];
	ElsIf Metadata.ChartsOfCalculationTypes.Contains(CurrentMetadata) Then
		Return ChartsOfCalculationTypes[MetadataName];
	ElsIf Metadata.BusinessProcesses.Contains(CurrentMetadata) Then
		Return BusinessProcesses[MetadataName];
	ElsIf Metadata.Tasks.Contains(CurrentMetadata) Then
		Return Tasks[MetadataName];
	ElsIf Metadata.ExchangePlans.Contains(CurrentMetadata) Then
		Return ExchangePlans[MetadataName];
	ElsIf Metadata.InformationRegisters.Contains(CurrentMetadata) Then
		Return InformationRegisters[MetadataName];
	ElsIf Metadata.AccumulationRegisters.Contains(CurrentMetadata) Then
		Return AccumulationRegisters[MetadataName];
	ElsIf Metadata.AccountingRegisters.Contains(CurrentMetadata) Then
		Return AccountingRegisters[MetadataName];
	ElsIf Metadata.CalculationRegisters.Contains(CurrentMetadata) Then
		Return CalculationRegisters[MetadataName];
	Else
		// Primitive type
		Return Undefined;
	EndIf;
EndFunction

Function GetManagerByMetadataFullName(MetadataName) Export
	CurrentMetadata = Metadata.FindByFullName(MetadataName);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
	Return GetManagerByMetadata(CurrentMetadata);
EndFunction

Function GetManagerByType(TypeOfValue) Export
	If TypeOfValue = Undefined Then
		Return Undefined;
	EndIf;
	CurrentMetadata = Metadata.FindByType(TypeOfValue);
	If CurrentMetadata = Undefined Then
		Return Undefined;
	EndIf;
	Return GetManagerByMetadata(CurrentMetadata);
EndFunction

Function GetProgramTitle() Export
	DBName = String(SessionParameters.ConnectionSettings);
	If IsBlankString(DBName) Then
		DBName = "IRP";
	EndIf;

	If SessionParameters.ConnectionSettings.isProduction Then
		Return DBName;
	Else
		Return DBName + " (Test app)";
	EndIf;
EndFunction