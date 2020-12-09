
Function GetOrCreateDataBaseStatusInfo() Export
	ComputerName = ComputerName();
	ConnectionString = InfoBaseConnectionString();
	
	ConnectionStringArray = StrSplit(ConnectionString, "\|/;=: ");
	ConnectionString = StrConcat(ConnectionStringArray, "_");
	Query = New Query;
	Query.Text =
		"SELECT
		|	DataBaseStatusConnectionSettings.Ref
		|FROM
		|	Catalog.DataBaseStatus.ConnectionSettings AS DataBaseStatusConnectionSettings
		|WHERE
		|	DataBaseStatusConnectionSettings.Computer = &Computer
		|	AND DataBaseStatusConnectionSettings.ConnectionString = &ConnectionString";
	
	Query.SetParameter("ConnectionString", ConnectionString);
	Query.SetParameter("Computer", ComputerName);
	
	QueryResult = Query.Execute();
	
	SelectionDetailRecords = QueryResult.Select();
	
	While SelectionDetailRecords.Next() Do
		Return SelectionDetailRecords.Ref;
	EndDo;
	
	NewConnection = Catalogs.DataBaseStatus.CreateItem();
	If Not Catalogs.DataBaseStatus.Select().Next() Then
		NewConnection.isProduction = True;
	EndIf;
	
	NewConnection.SelectedStyle = "Auto";
	
	Row = NewConnection.ConnectionSettings.Add();
	Row.Computer = ComputerName;
	Row.ConnectionString = ConnectionString;
	
	NewConnection.Write();
	Return NewConnection.Ref;
	
EndFunction
