Function UniqueIDByName(ObjectMetadataFullName, UniqueID) Export
    Query = New Query;
    Query.Text =
        "SELECT
        |    T.Ref
        |FROM
        |    %1 AS T
        |WHERE
        |    T.UniqueID = &UniqueID";
    Query.Text = StrTemplate(Query.Text, ObjectMetadataFullName);
    Query.SetParameter("UniqueID", UniqueID);
    QueryResult = Query.Execute();
    QuerySelection = QueryResult.Select();
    If QuerySelection.Next() Then
        Return QuerySelection.Ref;
    Else
        Return Undefined;
    EndIf;
EndFunction