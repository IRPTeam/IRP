

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
Procedure CheckAllUserGroups(Command)
	For Each Item In UserGroupsList Do
		Item.Use = True;
	EndDo;
EndProcedure

&AtClient
Procedure UncheckAllUserGroups(Command)
	For Each Item In UserGroupsList Do
		Item.Use = False;
	EndDo;
EndProcedure

&AtClient
Procedure SaveShare(Command)
	FormCloseParameters = New Structure;
	FormCloseParameters.Insert("Users", SharedUsers());
	FormCloseParameters.Insert("UserGroups", SharedUserGroups());
	Close(FormCloseParameters)
EndProcedure

#EndRegion

#Region Events

&AtServer
Procedure OnCreateAtServer(Cancel, StandardProcessing)
		
	If Parameters.UseUsers Then
		FillUsersList(Parameters.Users);
		Items.UsersList.Visible = True;
	Else
		Items.UsersList.Visible = False;
	EndIf;
	
	If Parameters.UseUserGroups Then
		FillUserGroupsList(Parameters.UserGroups);
		Items.GroupUsers.Visible = True;
	Else
		Items.GroupUsers.Visible = False;
	EndIf;
	
EndProcedure

#EndRegion

#Region Private

&AtServer
Function SharedUsers()
	ReturnValue = New ValueList();
	FilterChecked = New Structure("Use", True);
	Users = UsersList.Unload(FilterChecked, "User");
	ReturnValue.LoadValues(Users.UnloadColumn("User"));
	Return ReturnValue;
EndFunction

&AtServer
Function SharedUserGroups()
	ReturnValue = New ValueList();
	FilterChecked = New Structure("Use", True);
	UserGroups = UserGroupsList.Unload(FilterChecked, "UserGroup");
	ReturnValue.LoadValues(UserGroups.UnloadColumn("UserGroup"));
	Return ReturnValue;
EndFunction

Procedure FillUsersList(ListData)
	SourceTable = New ValueTable;
	SourceTable.Columns.Add("Ref", New TypeDescription("CatalogRef.Users"));
	For Each Item In ListData Do
		SourceTableRow = SourceTable.Add();
		SourceTableRow.Ref = Item.Value;
	EndDo;
	Query = New Query;
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
EndProcedure

Procedure FillUserGroupsList(ListData)
	SourceTable = New ValueTable;
	SourceTable.Columns.Add("Ref", New TypeDescription("CatalogRef.UserGroups"));
	For Each Item In Parameters.Users Do
		SourceTableRow = SourceTable.Add();
		SourceTableRow.Ref = Item.Value;
	EndDo;
	Query = New Query;
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
				 |	Catalog.UserGroups AS Cat
				 |		LEFT JOIN CheckedItems AS CheckedItems
				 |		ON Cat.Ref = CheckedItems.Ref";
	Query.SetParameter("SourceTable", SourceTable);
	QueryResult = Query.Execute().Unload();
	ThisObject.UserGroupsList.Load(QueryResult);
EndProcedure

#EndRegion






