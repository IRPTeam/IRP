
#Region EventSubscriptions

Procedure BeforeWrite_DocumentsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	SourceParams = New Structure;
	Array = New Array;
	Array.Add(Source);
	SourceParams.Insert("Source", Array);
	SourceParams.Insert("isNew", Source.IsNew());
	SourceParams.Insert("MetadataName", Source.Metadata().FullName());
	If Constants.UseLockDataModification.Get() And SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_CatalogsLockDataModification(Source, Cancel, WriteMode, PostingMode) Export
	SourceParams = New Structure;
	Array = New Array;
	Array.Add(Source);
	SourceParams.Insert("Source", Array);
	SourceParams.Insert("isNew", Source.IsNew());
	SourceParams.Insert("MetadataName", Source.Metadata().FullName());
	If Constants.UseLockDataModification.Get() And SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_InformationRegistersLockDataModification(Source, Cancel, Replacing) Export
	SourceParams = New Structure;
	SourceParams.Insert("Source", Source);
	SourceParams.Insert("isNew", True);
	SourceParams.Insert("MetadataName", Source.Metadata().FullName());	
	If Constants.UseLockDataModification.Get() And SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

Procedure BeforeWrite_AccumulationRegistersLockDataModification(Source, Cancel, Replacing) Export
	SourceParams = New Structure;
	SourceParams.Insert("Source", Source);
	SourceParams.Insert("isNew", True);
	SourceParams.Insert("MetadataName", Source.Metadata().FullName());
	If Constants.UseLockDataModification.Get() And SourceisLocked(SourceParams) Then
		Cancel = True;
	EndIf;
EndProcedure

#EndRegion

#Region Privat

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
		|	LockDataModificationRules.Value
		|FROM
		|	InformationRegister.LockDataModificationRules AS LockDataModificationRules
		|WHERE
		|	LockDataModificationRules.Type = &MetadataName";
	
	Query.SetParameter("MetadataName", SourceParams.MetadataName);
	
	QueryResult = Query.Execute();
	If QueryResult.IsEmpty() Then
		Return Undefined;
	EndIf;
	Return QueryResult.Unload();
EndFunction

Function SourceLockedByRules(SourceParams, Rules, AddInfo = Undefined)
	
	Text = New Array;
	
	Query = New Query;
	For Index = 0 To Rules.Count() - 1 Do
		For AddIndex = 0 To SourceParams.Source.Count() - 1 Do
			Text.Add("&SourceParam" + Index + AddIndex + " " + Rules[Index].ComparisonType + " (" + "&Param" + Index + ")");
		EndDo;
		Query.SetParameter("Param" + Index, Rules[Index].Value);
	EndDo;
	Query.Text = "SELECT True WHERE " + StrConcat(Text, " AND ");
		
	If Not SourceParams.isNew Then
		For Index = 0 To Rules.Count() - 1 Do
			Attribute = StrSplit(Rules[Index].Attribute, ".")[1];
			For AddIndex = 0 To SourceParams.Source.Count() - 1 Do
				Query.SetParameter("SourceParam" + Index + AddIndex, SourceParams.Source[AddIndex].Ref[Attribute]);
			EndDo;
		EndDo;
		QueryResult = Query.Execute();
		If Not QueryResult.IsEmpty() Then
			Return True;
		EndIf;
	EndIf;
	For Index = 0 To Rules.Count() - 1 Do
		Attribute = StrSplit(Rules[Index].Attribute, ".")[1];
		For AddIndex = 0 To SourceParams.Source.Count() - 1 Do
			Query.SetParameter("SourceParam" + Index + AddIndex, SourceParams.Source[AddIndex][Attribute]);
		EndDo;
		
	EndDo;
	Return Not Query.Execute().IsEmpty();
EndFunction
#EndRegion