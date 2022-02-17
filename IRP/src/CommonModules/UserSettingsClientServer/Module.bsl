
Procedure FillingRowFromSettings(Object, DataPath, Row, OnlyNotFilled = False) Export
	UserSettings = UserSettingsServer.GetUserSettingsForClientModule(Object.Ref);
	For Each ArrayItem In UserSettings Do
		If ArrayItem.KindOfAttribute <> PredefinedValue("Enum.KindsOfAttributes.Column") Then
			Continue;
		EndIf;

		TableNameDataPath = "";
		SegmentsDataPath = StrSplit(DataPath, ".");
		If SegmentsDataPath.Count() > 1 Then
			TableNameDataPath = SegmentsDataPath[1];
		EndIf;

		TableName = "";
		ColumnName = "";
		SegmentsAttributeName = StrSplit(ArrayItem.AttributeName, ".");
		If SegmentsAttributeName.Count() > 1 Then
			TableName = SegmentsAttributeName[0];
			ColumnName = SegmentsAttributeName[1];
		EndIf;

		If TableNameEqualToDataPath(TableName, TableNameDataPath, ColumnName) Then
			If Row.Property(ColumnName) Then
				If Not OnlyNotFilled Or (OnlyNotFilled And Not ValueIsFilled(Row[ColumnName])) Then
					Row[ColumnName] = ArrayItem.Value;
				EndIf;
			EndIf;
		EndIf;
	EndDo;
EndProcedure

Function TableNameEqualToDataPath(TableName, TableNameDataPath, ColumnName)
	Return ValueIsFilled(TableNameDataPath) 
			And ValueIsFilled(TableName) 
			And ValueIsFilled(ColumnName) 
			And Upper(TrimAll(TableNameDataPath)) = Upper(TrimAll(TableName));
EndFunction