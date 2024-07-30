Function UniqueIDByName(ObjectMetadata, UniqueID) Export
	Return UniqueIDReuse.UniqueIDByName(ObjectMetadata.FullName(), UniqueID);
EndFunction

Procedure OnCopyRemoveUniqueIDOnCopy(Source, CopiedObject) Export
	Source.UniqueID = Undefined;
EndProcedure

Procedure CheckUniqueIDBeforeWrite(Source, Cancel) Export
	If Not ValueIsFilled(Source.UniqueID) Then
		Source.UniqueID = "_" + StrReplace(String(New UUID()), "-", "");
	EndIf;
	DataLock = New DataLock();
	DataLockItem = DataLock.Add(Source.Metadata().FullName());
	DataLockItem.Mode = DataLockMode.Shared;
	Try
		DataLock.Lock();
	Except
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_012, "UniqueID", Source);
		Return;
	EndTry;

	Ref = UniqueIDByName(Source.Metadata(), Source.UniqueID);
	If Ref <> Source.Ref And Ref <> Undefined Then
		Cancel = True;
		CommonFunctionsClientServer.ShowUsersMessage(R().Error_013, "UniqueID", Source);
	EndIf;
EndProcedure

// Find ref by unique m d5.
// 
// Parameters:
//  Object - CatalogObject, DocumentObject - Object
//  UniqueMD5 - String - Unique MD5
//  WithoutDeleted - Boolean - Without deleted
// 
// Returns:
//  Undefined - Find ref by unique MD5
Function FindRefByUniqueMD5(Object, UniqueMD5, WithoutDeleted = False) Export
	MetadataFullName = Object.Metadata().FullName();
	DataLock = New DataLock();
	DataLockItem = DataLock.Add(MetadataFullName);
	DataLockItem.Mode = DataLockMode.Shared;
	DataLock.Lock();
	Query = New Query();
	Query.Text =
	"SELECT
	|	T.Ref
	|FROM
	|	%1 AS T
	|WHERE
	|	T.UniqueMD5 = &UniqueMD5 
	|	AND T.Ref <> &Ref
	|	AND NOT(T.DeletionMark AND &WithoutDeleted)";
	Query.Text = StrTemplate(Query.Text, MetadataFullName);
	Query.SetParameter("UniqueMD5", UniqueMD5);
	Query.SetParameter("Ref", Object.Ref);
	Query.SetParameter("WithoutDeleted", WithoutDeleted);
	QueryResult = Query.Execute();
	QuerySelection = QueryResult.Select();
	If QuerySelection.Next() Then
		Return QuerySelection.Ref;
	Else
		Return Undefined;
	EndIf;
EndFunction