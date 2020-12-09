
#Region EventSubscriptions

Procedure BeforeWrite_DocumentsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	If Cancel Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
		SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = Source.IsNew();
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_CatalogsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	If Cancel Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = Source.IsNew();
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_InformationRegistersLockDataModification(Source, Cancel, Replacing) Export
	If Cancel Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = False;
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_AccumulationRegistersLockDataModification(Source, Cancel, Replacing) Export
	If Cancel Or Not Constants.UseLockDataModification.Get() Then
		Return;
	EndIf;
	SourceParams = FillLockDataSettings();
	SourceParams.Source = Source;
	SourceParams.isNew = False;
	SourceParams.MetadataName = Source.Metadata().FullName();
	If SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Public
Function IsLockFormAttribute(Ref) Export
	
	LockForOtherReason = Catalogs.Units.GetListLockedAttributes_LockForOtherReason(Ref);
	
	If LockForOtherReason Then
		Return True;
	EndIf;
	
	Array = New Array;
	Array.Add(Ref);
	IncludeObjects = Catalogs.Units.GetListLockedAttributes_IncludeObjects();
	ExcludeObjects = Catalogs.Units.GetListLockedAttributes_ExcludeObjects();
	
	VT = FindByRef(Array, , IncludeObjects, ExcludeObjects);
	
	VT_Count = VT.Count(); 
	If VT_Count = 0 Then
		Return False;
	EndIf; 

	CommonFunctionsClientServer.ShowUsersMessage(StrTemplate(R().InfoMessage_021, VT_Count));
	ShowTop = 5;
	VT.GroupBy("Metadata");
	For Index = 0 To ?(VT.Count() - 1 > ShowTop, ShowTop, VT.Count() - 1) Do
		CommonFunctionsClientServer.ShowUsersMessage(VT[Index].Metadata);
	EndDo;
	Return True;
EndFunction
#EndRegion

#Region Privat

Function FillLockDataSettings()
	SourceParams = New Structure;
	SourceParams.Insert("Source", Undefined);
	SourceParams.Insert("isNew", True);
	SourceParams.Insert("MetadataName", "");
	Return SourceParams;
EndFunction

Function SourceisLocked(Val SourceParams)
	Rules = CalculateRuleByObject(SourceParams);
	If Rules = Undefined Then
		Return False;
	EndIf;
	
	Return SourceLockedByRules(SourceParams, Rules);
EndFunction

Function CalculateRuleByObject(SourceParams, AddInfo = Undefined)
	Query = New Query;
	Query.Text =
		"SELECT
		|	LockDataModificationRules.Attribute,
		|	LockDataModificationRules.ComparisonType,
		|	LockDataModificationRules.Value,
		|	LockDataModificationRules.LockDataModificationReasons
		|FROM
		|	InformationRegister.LockDataModificationRules AS LockDataModificationRules
		|WHERE
		|	LockDataModificationRules.Type = &MetadataName
		|	AND Not LockDataModificationRules.DisableRule";
	
	Query.SetParameter("MetadataName", SourceParams.MetadataName);
	
	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		Return Undefined;
	EndIf;
	VT = QueryResult.Unload();
	For Each Row In VT Do
		Row.Attribute = StrSplit(Row.Attribute, ".")[1];
	EndDo;
	
	Return VT;
EndFunction

Function SourceLockedByRules(SourceParams, Rules, AddInfo = Undefined)
	MetaNameType = StrSplit(SourceParams.MetadataName, ".")[0];
		
	If MetaNameType = "Catalog" Or MetaNameType = "Document" Then
		Return Not SourceParams.isNew And DataIsLocked_ByRef(SourceParams, Rules, True, AddInfo) 
			OR DataIsLocked_ByRef(SourceParams, Rules, False, AddInfo);
	ElsIf  MetaNameType = "AccumulationRegister" Or MetaNameType = "InformationRegister" Then
		Return Not SourceParams.isNew And ModifyDataIsLocked_ByTable(SourceParams, Rules, True, AddInfo)
			OR ModifyDataIsLocked_ByTable(SourceParams, Rules, False, AddInfo);
	Else
		Raise MetaNameType;
	EndIf;

	Return False;
EndFunction

Function ModifyDataIsLocked_ByTable(SourceParams, Rules, CheckCurrent, AddInfo = Undefined)
	Text = New Array;
	Fields = New Array;
	Query = New Query;
	If CheckCurrent Then
		TemplateFilter = "Table.%1 = &%1";
		MetadataName = SourceParams.MetadataName;
		For Each Filter In SourceParams.Source.Filter Do
			If Not Filter.Use Then
				Continue;
			EndIf;
			Text.Add(StrTemplate(TemplateFilter, Filter.Name));
			Query.SetParameter(Filter.Name, Filter.Value);
		EndDo;
	Else
		Attributes = Rules.UnloadColumn("Attribute");
		Query.TempTablesManager = New TempTablesManager();
		Query.Text = "SELECT * INTO Table From &VTTable AS VTTable";
		MetadataName = "Table";
		Query.SetParameter("VTTable", SourceParams.Source.Unload(, StrConcat(Attributes, ",")));
		Query.Execute();
	EndIf;
	
	
	For Index = 0 To Rules.Count() - 1 Do
		Text.Add("Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		Fields.Add("CASE WHEN Table." + Rules[Index].Attribute + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")
		|THEN 
		|	&Reason" + Index + " 
		|END AS Reason" + Index);
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
	EndDo;
	Query.Text = "SELECT DISTINCT " + Chars.LF + StrConcat(Fields, "," + Chars.LF) + Chars.LF +
				 " From " + MetadataName + " AS Table 
				 |WHERE " + StrConcat(Text, " AND ");
	
	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		Return False;
	EndIf;
	ShowInfoAboutLock(QueryResult);
	Return True;

EndFunction

Function DataIsLocked_ByRef(SourceParams, Rules, CheckCurrent, AddInfo = Undefined)
	Filter = New Array;
	Fields = New Array;
	Query = New Query;
		
	For Index = 0 To Rules.Count() - 1 Do
		Filter.Add("&SourceParam" + Index + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		Fields.Add("CASE WHEN &SourceParam" + Index + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")
		|THEN 
		|	&Reason" + Index + " 
		|END AS Reason" + Index);
		Query.SetParameter("Reason" + Index, Rules[Index].LockDataModificationReasons);
		Query.SetParameter("Param" + Index, Rules[Index].Value);
	EndDo;
	
	Query.Text = "SELECT DISTINCT " + Chars.LF + StrConcat(Fields, "," + Chars.LF) + Chars.LF +
				 "WHERE " + StrConcat(Filter, " AND" + Chars.LF);
	
	For Index = 0 To Rules.Count() - 1 Do
		If CheckCurrent Then
			SourceValue = SourceParams.Source.Ref[Rules[Index].Attribute];
		Else
			If Rules[Index].ComparisonType = "IN HIERARCHY" And Rules[Index].Attribute = "Ref" Then
				SourceValue = SourceParams.Source.Parent;
			Else
				SourceValue = SourceParams.Source[Rules[Index].Attribute];
			EndIf;
		EndIf;
		Query.SetParameter("SourceParam" + Index , SourceValue);
	EndDo;
	QueryResult = Query.Execute();
	
	If QueryResult.IsEmpty() Then
		Return False;
	EndIf;
	ShowInfoAboutLock(QueryResult);
	Return True;
EndFunction


Procedure ShowInfoAboutLock(QueryResult)

	Reasons = New Array;
	ReasonsTable = QueryResult.Unload();
	Reasons.Add(R().InfoMessage_019);
	For Each Column In ReasonsTable.Columns Do
		If Not ValueIsFilled(ReasonsTable[0][Column.Name]) Then
			Continue;
		EndIf;
		Reasons.Add(ReasonsTable[0][Column.Name]);
	EndDo;
	
	CommonFunctionsClientServer.ShowUsersMessage(StrConcat(Reasons, Chars.LF));
EndProcedure


#EndRegion