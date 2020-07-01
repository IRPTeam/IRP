
#Region Public

Function GetUserGroupsByUser(Val User) Export
	ReturnValue = New Array;
	
	Query = New Query;
	Query.Text = "SELECT ALLOWED
	|	Users.UserGroup
	|FROM
	|	Catalog.Users AS Users
	|WHERE
	|	Users.Ref = &Ref
	|	AND
	|	NOT Users.UserGroup.DeletionMark";
	Query.SetParameter("Ref", User);
	QueryExecution = Query.Execute();
	If Not QueryExecution.IsEmpty() Then
		ReturnValue = QueryExecution.Unload().UnloadColumn("Ref");
	EndIf;
	
	Return ReturnValue;	
EndFunction

#EndRegion