Function GetPredefinedUserSettingNames() Export
	Return UserSettingsServerReuse.GetPredefinedUserSettingNames();
EndFunction

Function GetUserSettingsForClientModule(Ref) Export
	Return UserSettingsServerReuse.GetUserSettingsForClientModule(Ref);
EndFunction

Function GetUserSettings(User, FilterParameters, CallFromClient = False) Export
	If FilterParameters.Property("MetadataObject") Then
		FilterParameters.MetadataObject = FilterParameters.MetadataObject.FullName();
	EndIf;
	
	Return UserSettingsServerReuse.GetUserSettings(User, FilterParameters, CallFromClient);
EndFunction

Procedure SetDefaultUserSettings() Export
	Query = New Query();
	Query.Text = 
	"SELECT
	|	Users.Ref
	|FROM
	|	Catalog.Users AS Users
	|WHERE
	|	NOT Users.DeletionMark";
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	While QuerySelection.Next() Do
		SetDefaultUserSettings_ByUser(QuerySelection.Ref);
	EndDo;
EndProcedure

Procedure SetDefaultUserSettings_ByUser(User) Export
	DefaultCurrent = New Structure();
	DefaultCurrent.Insert("Company"  , FOServer.GetDefault_Company());
	DefaultCurrent.Insert("Store"    , FOServer.GetDefault_Store());
	DefaultCurrent.Insert("Currency" , FOServer.GetDefault_Currency());
	
	DefaultIfNotSet = New Structure();
	DefaultIfNotSet.Insert("Company"  , FOServer.GetDefault_Company(Undefined, True));
	DefaultIfNotSet.Insert("Store"    , FOServer.GetDefault_Store(Undefined, True));
	DefaultIfNotSet.Insert("Currency" , FOServer.GetDefault_Currency(Undefined, True));
	
	RecordSetInfo = InformationRegisters.UserSettings.CreateRecordSet().UnloadColumns();
	
	For Each MetadataObject In Metadata.Documents Do
		// Header attributes
		For Each Attribute In MetadataObject.Attributes Do
			If Not DefaultCurrent.Property(Attribute.Name)
				Or Not AccessRight("View", Attribute, Metadata.Roles.FilterForUserSettings) Then
				Continue;
			EndIf;
			RecordInfo = RecordSetInfo.Add();
			RecordInfo.UserOrGroup     = User;
			RecordInfo.MetadataObject  = MetadataObject.FullName();
			RecordInfo.AttributeName   = Attribute.Name;
			RecordInfo.KindOfAttribute = Enums.KindsOfAttributes.Regular;
			RecordInfo.Value = DefaultCurrent[Attribute.Name];
		EndDo;
		
		// Tabular section columns
		For Each TabularSection In MetadataObject.TabularSections Do
			For Each Column In TabularSection.Attributes Do
				If Not DefaultCurrent.Property(Column.Name)
					Or Not AccessRight("View", Column, Metadata.Roles.FilterForUserSettings) Then
					Continue;
				EndIf;
				RecordInfo = RecordSetInfo.Add();
				RecordInfo.UserOrGroup     = User;
				RecordInfo.MetadataObject  = MetadataObject.FullName();
				RecordInfo.AttributeName   = StrTemplate("%1.%2", TabularSection.Name, Column.Name);
				RecordInfo.KindOfAttribute = Enums.KindsOfAttributes.Column;
				RecordInfo.Value           = DefaultCurrent[Column.Name];
			EndDo;
		EndDo;
	EndDo;
	
	// Write to register
	For Each RecordInfo In RecordSetInfo Do
		DefaultIfNotSet_Value = Undefined;
		If RecordInfo.KindOfAttribute = Enums.KindsOfAttributes.Column Then
			DefaultIfNotSet_Value = DefaultIfNotSet[StrSplit(RecordInfo.AttributeName, ".")[1]];
		Else
			DefaultIfNotSet_Value = DefaultIfNotSet[RecordInfo.AttributeName];
		EndIf;
		
		RecordSet = InformationRegisters.UserSettings.CreateRecordSet();
		RecordSet.Filter.UserOrGroup.Set(RecordInfo.UserOrGroup);
		RecordSet.Filter.MetadataObject.Set(RecordInfo.MetadataObject);
		RecordSet.Filter.AttributeName.Set(RecordInfo.AttributeName);
		RecordSet.Read();
		If RecordSet.Count() 
			And ValueIsFilled(RecordSet[0].Value) And RecordSet[0].Value <> DefaultIfNotSet_Value Then
				Continue; // Exists and filled user defined value
		EndIf;
		If ValueIsFilled(RecordInfo.Value) Then
			If RecordSet.Count() Then
				Record = RecordSet[0];
			Else
				Record = RecordSet.Add();
			EndIf;
			FillPropertyValues(Record, RecordInfo);
		Else
			RecordSet.Clear();
		EndIf;
		RecordSet.Write();
	EndDo;
EndProcedure

Function GeneratePassword() Export

	Var Alphabet, Index, NewPass, RNG;

	Alphabet = "1234567890ABCDEFGHKLMNPRSTUVWXYZ";

	RNG = New RandomNumberGenerator();
	NewPass = "";
	For I = 1 To 10 Do
		Index = RNG.RandomNumber(1, (StrLen(Alphabet)));
		NewPass = NewPass + Mid(Alphabet, Index, 1);
	EndDo;
	Return NewPass;

EndFunction

Function CustomAttributeHaveRefToObject(AttributeName, MetadataObject) Export
	Return UserSettingsServerReuse.CustomAttributeHaveRefToObject(AttributeName, MetadataObject.FullName());
EndFunction