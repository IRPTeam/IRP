
Function GetPredefinedUserSettingNames() Export
	Result = New Structure();
	Result.Insert("USE_OBJECT_WITH_DELETION_MARK", "Use_object_with_deletion_mark");

	Return Result;
EndFunction

Function GetUserSettingsForClientModule(Ref) Export
	FilterParameters = New Structure();
	FilterParameters.Insert("MetadataObject", Ref.Metadata().FullName());
	Return GetUserSettings(SessionParameters.CurrentUser, FilterParameters, True);
EndFunction

Function GetUserSettings(User, FilterParameters, CallFromClient = False) Export
	Return UserSettingsServer._GetUserSettings(User, FilterParameters, CallFromClient);
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
	Query.SetParameter("MetadataFullName", MetadataObject);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return True;
	Else
		Return False;
	EndIf;
EndFunction
