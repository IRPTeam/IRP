
#Region Public

//
Function GetWorkstationByUniqueID(UniqueIDValue) Export
	If Not Saas.isAreaActive() Then
		Return Catalogs.Workstations.EmptyRef();
	EndIf;
	
	Query = New Query;
	Query.Text = "SELECT
	|	Workstations.Ref
	|FROM
	|	Catalog.Workstations AS Workstations
	|WHERE
	|	Workstations.UniqueID = &UniqueID";
	Query.SetParameter("UniqueID", UniqueIDValue);
	QueryExecute = Query.Execute();
	If QueryExecute.IsEmpty() Then
		ReturnValue = Catalogs.Workstations.EmptyRef();
	Else
		QuerySelection = QueryExecute.Select();
		QuerySelection.Next();
		ReturnValue = QuerySelection.Ref; 
	EndIf;
	Return ReturnValue;
EndFunction

#EndRegion