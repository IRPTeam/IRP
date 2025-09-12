#Region Commands

&AtClient
Procedure CheckAllUsers(Command)
	For Each Item In UsersList Do
		Item.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAllUsers(Command)
	For Each Item In UsersList Do
		Item.Use = False;
	EndDo;
EndProcedure

&AtClient
Procedure SaveShare(Command)
	FormCloseParameters = New Structure();
	FormCloseParameters.Insert("Users", ShareReducers());
	Close(FormCloseParameters);
EndProcedure

#EndRegion

#Region FormEvents

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
	If Parameters.Users <> Undefined Then
		Users = Parameters.Users;
	Else
		Users = New Array();
	EndIf;
	FillUsersList(Users);
EndProcedure

#EndRegion

#Region Private

&AtServer
Function ShareReducers()
	ReturnValue = New ValueList();
	FilterChecked = New Structure("Use", True);
	Users = UsersList.Unload(FilterChecked, "User");
	ReturnValue.LoadValues(Users.UnloadColumn("User"));
	Return ReturnValue;
EndFunction

&AtServer
Procedure FillUsersList(ListData)
	SourceTable = New ValueTable();
	SourceTable.Columns.Add("Ref", New TypeDescription("CatalogRef.Users"));
	For Each Item In ListData Do
		SourceTableRow = SourceTable.Add();
		SourceTableRow.Ref = Item.Value;
	EndDo;
	Query = New Query();
	Query.Text = "SELECT
				 |	SourceTable.Ref AS Ref,
				 |	TRUE AS Checked
				 |INTO CheckedItems
				 |FROM
				 |	&SourceTable AS SourceTable
				 |;
				 |////////////////////////////////////////////////////////////////////////////////
				 |SELECT
				 |	Cat.Ref AS User,
				 |	ISNULL(CheckedItems.Checked, FALSE) AS Use
				 |FROM
				 |	Catalog.Users AS Cat
				 |		LEFT JOIN CheckedItems AS CheckedItems
				 |		ON Cat.Ref = CheckedItems.Ref";
	Query.SetParameter("SourceTable", SourceTable);
	QueryResult = Query.Execute().Unload();
	ThisObject.UsersList.Load(QueryResult);
	
	RowAllUsers = ThisObject.UsersList.Insert(0);
	RowAllUsers.User = Catalogs.Users.EmptyRef();
EndProcedure

#EndRegion