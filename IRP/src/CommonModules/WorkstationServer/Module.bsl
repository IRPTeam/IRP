
// @strict-types

#Region Public

// Get workstation by unique ID.
// 
// Parameters:
//  UniqueIDValue - String - Unique IDValue
// 
// Returns:
//  CatalogRef.Workstations - Get workstation by unique ID
Function GetWorkstationByUniqueID(UniqueIDValue) Export
	If Not Saas.isAreaActive() Then
		Return Catalogs.Workstations.EmptyRef();
	EndIf;

	Query = New Query();
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
		ReturnValue = QuerySelection.Ref; // CatalogRef.Workstations 
	EndIf;
	Return ReturnValue;
EndFunction

// Set workstation.
// 
// Parameters:
//  Workstation - CatalogRef.Workstations
Procedure SetWorkstation(Workstation) Export
	SessionParameters.Workstation = Workstation;
	RefreshReusableValues();
EndProcedure
#EndRegion
