Function GetOrCreateDataBaseStatusInfo() Export

	If Not Saas.isAreaActive() Then
		Return Catalogs.DataBaseStatus.EmptyRef();
	EndIf;

	ComputerName = ComputerName();
	ConnectionString = InfoBaseConnectionString();

	ConnectionStringArray = StrSplit(ConnectionString, "\|/;=: ");
	ConnectionString = StrConcat(ConnectionStringArray, "_");
	Query = New Query();
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
	For Each Lang In LocalizationReuse.AllDescription() Do
		NewConnection[Lang] = ConnectionString;
	EndDo;
	Row = NewConnection.ConnectionSettings.Add();
	Row.Computer = ComputerName;
	Row.ConnectionString = ConnectionString;

	NewConnection.Write();
	Return NewConnection.Ref;

EndFunction