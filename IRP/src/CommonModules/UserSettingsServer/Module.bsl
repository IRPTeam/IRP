Function GetPredefinedUserSettingNames() Export
	Result = New Structure();
	Result.Insert("USE_OBJECT_WITH_DELETION_MARK", "Use_object_with_deletion_mark");

	Return Result;
EndFunction

Function GetUserSettingsForClientModule(Ref) Export
	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Ref.Metadata());
	Return GetUserSettings(SessionParameters.CurrentUser, FilterParameters, True);
EndFunction

Function GetUserSettings(User, FilterParameters, CallFromClient = False) Export

	If Not ValueIsFilled(User) Then
		User = SessionParameters.CurrentUser;
	EndIf;
	Query = New Query();
	Query.Text =
	"SELECT
	|	UserSettings.UserOrGroup,
	|	UserSettings.MetadataObject,
	|	UserSettings.AttributeName,
	|	UserSettings.KindOfAttribute,
	|	UserSettings.Value
	|INTO tmp_group
	|FROM
	|	InformationRegister.UserSettings AS UserSettings
	|WHERE
	|	UserSettings.UserOrGroup = &Group
	|	AND CASE
	|		WHEN &Filter_MetadataObject
	|			THEN UserSettings.MetadataObject = &MetadataObject
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_AttributeName
	|			THEN UserSettings.AttributeName = &AttributeName
	|		ELSE TRUE
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	UserSettings.UserOrGroup,
	|	UserSettings.MetadataObject,
	|	UserSettings.AttributeName,
	|	UserSettings.KindOfAttribute,
	|	UserSettings.Value
	|INTO tmp_user
	|FROM
	|	InformationRegister.UserSettings AS UserSettings
	|WHERE
	|	UserSettings.UserOrGroup = &User
	|	AND CASE
	|		WHEN &Filter_MetadataObject
	|			THEN UserSettings.MetadataObject = &MetadataObject
	|		ELSE TRUE
	|	END
	|	AND CASE
	|		WHEN &Filter_AttributeName
	|			THEN UserSettings.AttributeName = &AttributeName
	|		ELSE TRUE
	|	END
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|SELECT
	|	ISNULL(tmp_user.UserOrGroup, tmp_user_group.UserOrGroup) AS UserOrGroup,
	|	ISNULL(tmp_user.MetadataObject, tmp_user_group.MetadataObject) AS MetadataObject,
	|	ISNULL(tmp_user.AttributeName, tmp_user_group.AttributeName) AS AttributeName,
	|	ISNULL(tmp_user.KindOfAttribute, tmp_user_group.KindOfAttribute) AS KindOfAttribute,
	|	ISNULL(tmp_user.Value, tmp_user_group.Value) AS Value
	|FROM
	|	tmp_user AS tmp_user
	|		FULL JOIN tmp_group AS tmp_user_group
	|		ON tmp_user.MetadataObject = tmp_user_group.MetadataObject
	|		AND tmp_user.AttributeName = tmp_user_group.AttributeName
	|		AND tmp_user.KindOfAttribute = tmp_user_group.KindOfAttribute";
	Query.SetParameter("User", User);
	Query.SetParameter("Group", User.UserGroup);

	MetadataObject = Undefined;
	FilterParameters.Property("MetadataObject", MetadataObject);
	Query.SetParameter("Filter_MetadataObject", MetadataObject <> Undefined);
	Query.SetParameter("MetadataObject", ?(MetadataObject <> Undefined, MetadataObject.FullName(), ""));

	AttributeName = Undefined;
	FilterParameters.Property("AttributeName", AttributeName);
	Query.SetParameter("Filter_AttributeName", AttributeName <> Undefined);
	Query.SetParameter("AttributeName", AttributeName);

	QueryResult = Query.Execute();
	If CallFromClient Then
		ResultTable = QueryResult.Unload();
		ArrayOfResults = New Array();
		For Each Row In ResultTable Do
			StructureOfResult = New Structure();
			StructureOfResult.Insert("UserOrGroup", Row.UserOrGroup);
			StructureOfResult.Insert("MetadataObject", Row.MetadataObject);
			StructureOfResult.Insert("AttributeName", Row.AttributeName);
			StructureOfResult.Insert("KindOfAttribute", Row.KindOfAttribute);
			StructureOfResult.Insert("Value", Row.Value);
			ArrayOfResults.Add(StructureOfResult);
		EndDo;
		Return ArrayOfResults;
	Else
		Return QueryResult.Unload();
	EndIf;
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
	Query = New Query();
	Query.Text =
	"SELECT
	|	CustomUserSettingsRefersToObjects.Ref
	|FROM
	|	ChartOfCharacteristicTypes.CustomUserSettings.RefersToObjects AS CustomUserSettingsRefersToObjects
	|WHERE
	|	NOT CustomUserSettingsRefersToObjects.Ref.IsCommon
	|	AND CustomUserSettingsRefersToObjects.FullName = &MetadataFullName
	|	AND CustomUserSettingsRefersToObjects.Ref.UniqueID = &AttributeName";
	Query.SetParameter("AttributeName", AttributeName);
	Query.SetParameter("MetadataFullName", MetadataObject.FullName());
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return True;
	Else
		Return False;
	EndIf;
EndFunction