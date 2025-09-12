Function GetOrCreateTopLevel(UniqueID, AddInfo = Undefined) Export
	Query = New Query();
	Query.Text =
	"SELECT
	|	DataMappingItems.Ref
	|FROM
	|	Catalog.DataMappingItems AS DataMappingItems
	|WHERE
	|	DataMappingItems.UniqueID = &UniqueID
	|	AND DataMappingItems.IsFolder";

	Query.SetParameter("UniqueID", UniqueID);

	QueryResult = Query.Execute().Select();

	If QueryResult.Next() Then
		Return QueryResult.Ref;
	EndIf;

	NewGroup = CreateFolder();
	NewGroup.Description = UniqueID;
	NewGroup.UniqueID = UniqueID;
	NewGroup.Write();

	Return NewGroup.Ref;
EndFunction

Function GetOrCreateMappingItem(CreationStructure, AddInfo = Undefined) Export

	MapItem = GetMappingItem(CreationStructure, AddInfo);

	If Not ValueIsFilled(CreationStructure.Ref) Then
		Return Undefined;
	EndIf;

	If Not MapItem.IsEmpty() Then
		If MapItem.Ref.RefValue = CreationStructure.Ref Then
			Return MapItem.Ref;
		EndIf;

		NewItem = MapItem.Ref.GetObject();

	Else
		NewItem = CreateItem();
		NewItem.Description = CreationStructure.Value;
		NewItem.SimpleValue = CreationStructure.Value;
		NewItem.TypeValue = CreationStructure.Type;
		NewItem.Parent = CreationStructure.TopLevel;
	EndIf;

	NewItem.RefValue = CreationStructure.Ref;
	NewItem.Write();

	Return NewItem.Ref;
EndFunction

// Get mapping item.
// 
// Parameters:
//  CreationStructure - See GetCreationStructure
//  AddInfo - Undefined - Add info
// 
// Returns:
//  CatalogRef.DataMappingItems - Get mapping item
Function GetMappingItem(CreationStructure, AddInfo = Undefined) Export

	Query = New Query();
	Query.Text =
	"SELECT
	|	DataMappingItems.Ref
	|FROM
	|	Catalog.DataMappingItems AS DataMappingItems
	|WHERE
	|	DataMappingItems.Parent = &Parent
	|	AND DataMappingItems.SimpleValue = &SimpleValue
	|	AND DataMappingItems.TypeValue = &TypeValue";
	
	Query.Text = Query.Text + CreationStructure.AdditionalConditions.ConditionString;
	For Each KeyAndValue In CreationStructure.AdditionalConditions.AddParametersStructure Do
		Query.SetParameter(KeyAndValue.Key, KeyAndValue.Value);
	EndDo;	

	Query.SetParameter("Parent", CreationStructure.TopLevel);
	Query.SetParameter("SimpleValue", CreationStructure.Value);
	Query.SetParameter("TypeValue", CreationStructure.Type);

	QueryResult = Query.Execute().Select();

	If QueryResult.Next() Then
		Return QueryResult.Ref;
	EndIf;

	Return EmptyRef();
EndFunction

// Get creation structure.
// 
// Parameters:
//  AddInfo - Undefined - Add info
// 
// Returns:
//  Structure - Get creation structure:
// * Value - String 
// * Type - String 
// * TopLevel - CatalogRef.DataMappingItems 
// * Ref - Undefined 
// * AdditionalConditions - See GetAdditionalConditionsStructure
Function GetCreationStructure(AddInfo = Undefined) Export
	CreationStructure = New Structure();
	CreationStructure.Insert("Value", "");
	CreationStructure.Insert("Type", "");
	CreationStructure.Insert("TopLevel", EmptyRef());
	CreationStructure.Insert("Ref", Undefined);
	CreationStructure.Insert("AdditionalConditions", GetAdditionalConditionsStructure());
	Return CreationStructure;
EndFunction

// Get additional conditions structure.
// 
// Returns:
//  Structure - Get additional conditions structure:
// * ConditionString - String - 
// * AddParametersStructure - Structure - 
Function GetAdditionalConditionsStructure()
	AdditionalConditionsStructure = New Structure;
	AdditionalConditionsStructure.Insert("ConditionString", "");
	AdditionalConditionsStructure.Insert("AddParametersStructure", New Structure);
	
	Return AdditionalConditionsStructure;
EndFunction

	