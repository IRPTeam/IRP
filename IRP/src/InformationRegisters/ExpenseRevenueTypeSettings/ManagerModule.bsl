// @strict-types

// Get expense type.
// 
// Parameters:
//  Filter - see GetFilter
// 
// Returns:
//  CatalogRef.ExpenseAndRevenueTypes
Function GetExpenseType(Filter) Export

	ExpenseType = Catalogs.ExpenseAndRevenueTypes.EmptyRef();
	ERType = GetERType(Filter);
	If ERType.Count() Then
		ExpenseType = ERType[0].ExpenseType;
	EndIf;
	
	Return ExpenseType;

EndFunction

// Get revenue type.
// 
// Parameters:
//  Filter - see GetFilter
// 
// Returns:
//  CatalogRef.ExpenseAndRevenueTypes
Function GetRevenueType(Filter) Export

	RevenueType = Catalogs.ExpenseAndRevenueTypes.EmptyRef();
	ERType = GetERType(Filter);
	If ERType.Count() Then
		RevenueType = ERType[0].RevenueType;
	EndIf;
	
	Return RevenueType;

EndFunction

// Get ERType.
// 
// Parameters:
//  Filter - see GetFilter
// 
// Returns:
//  ValueTable - Get ERType:
//  	*ExpenseType - CatalogRef.ExpenseAndRevenueTypes
//  	*RevenueType - CatalogRef.ExpenseAndRevenueTypes
Function GetERType(Filter)

	Query = New Query;
	Query.Text =
		"SELECT ALLOWED
		|	ERTS.ExpenseType,
		|	ERTS.RevenueType,
		|	CASE
		|		When ERTS.ItemKey = &ItemKey And Not ERTS.ItemKey = Value(Catalog.ItemKeys.EmptyRef)   
		|			Then 1000
		|		Else 0
		|	END AS ItemKeyPart,
		|	CASE
		|		When ERTS.Item = &Item And Not ERTS.Item = Value(Catalog.Items.EmptyRef) 
		|			Then 100
		|		Else 0
		|	END AS ItemPart,
		|	CASE
		|		When ERTS.ItemType = &ItemType And Not ERTS.ItemType = Value(Catalog.ItemTypes.EmptyRef) 
		|			Then 10
		|		Else 0
		|	END AS ItemTypePart,
		|	CASE
		|		When ERTS.ItemType = Value(Catalog.ItemTypes.EmptyRef) 
		|			AND ERTS.Item = Value(Catalog.Items.EmptyRef)
		|			AND ERTS.ItemKey = Value(Catalog.ItemKeys.EmptyRef)
		|			Then 1
		|		Else 0
		|	END AS CompanyPart
		|INTO VT
		|FROM
		|	InformationRegister.ExpenseRevenueTypeSettings AS ERTS
		|WHERE
		|	ERTS.Company = &Company
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|SELECT
		|	VT.ExpenseType,
		|	VT.RevenueType,
		|	VT.ItemKeyPart + VT.ItemPart + VT.ItemTypePart + VT.CompanyPart AS Priority
		|FROM
		|	VT AS VT
		|
		|ORDER BY
		|	Priority DESC";
	
	Query.SetParameter("Item", Filter.Item);
	Query.SetParameter("Company", Filter.Company);
	Query.SetParameter("ItemType", Filter.ItemType);
	Query.SetParameter("ItemKey", Filter.ItemKey);
	
	Return Query.Execute().Unload();
EndFunction

// Get filter.
// 
// Returns:
//  Structure - Get filter:
// * Company - CatalogRef.Companies -
// * ItemKey - CatalogRef.ItemKeys -
// * Item - CatalogRef.Items -
// * ItemType - CatalogRef.ItemTypes -
Function GetFilter() Export
	
	Str = New Structure;
	Str.Insert("Company", Catalogs.Companies.EmptyRef());
	Str.Insert("ItemKey", Catalogs.ItemKeys.EmptyRef());
	Str.Insert("Item", Catalogs.Items.EmptyRef());
	Str.Insert("ItemType", Catalogs.ItemTypes.EmptyRef());
	
	Return Str;

EndFunction
