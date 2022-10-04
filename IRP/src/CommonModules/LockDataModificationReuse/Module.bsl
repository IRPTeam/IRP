// @strict-types

// Get DSCTemplate.
// 
// Parameters:
//  MetadataName - String - Metadata name
//  Rule - CatalogRef.LockDataModificationReasons - Rule
// 
// Returns:
//  DataCompositionTemplate - Get DSCTemplate
Function GetDSCTemplate(Val MetadataName, Rule) Export
	DCSTemplate = Catalogs.LockDataModificationReasons.GetTemplate("DCS");
	DataSources = DCSTemplate.DataSources.Add();
	DataSources.DataSourceType = "Local";
	DataSources.Name = "DataSource";
	
	Query = 
	"SELECT 
	|	*
	|FROM
	|    " + MetadataName + " AS DataSet";
	DataSet = DCSTemplate.DataSets.Add(Type("DataCompositionSchemaDataSetQuery"));
	DataSet.Query = Query;
	DataSet.Name = MetadataName;
	DataSet.DataSource = DataSources.Name;
	
	Settings = Rule.DCS.Get(); // DataCompositionSettings
	Composer = New DataCompositionTemplateComposer();
	Template = Composer.Execute(DCSTemplate, Settings, , , Type("DataCompositionValueCollectionTemplateGenerator"));
	Return Template
EndFunction


// Fill attribute list.
// 
// Parameters:
//  MetadataName - String - Metadata name
// 
// Returns:
//  Structure - Fill attribute list:
// * FieldsArray - Array of String - All fields, which can be used at query
// * ChoiceData - ValueList of String - List for all attributes with icons, path and synonym
Function FillAttributeList(MetadataName) Export
	Result = New Structure;
	Result.Insert("FieldsArray", New Array);
	Result.Insert("ChoiceData", New ValueList);
	
	If IsBlankString(MetadataName) Then
		Return Result;
	EndIf;
	
	MetadataType = Enums.MetadataTypes[StrSplit(MetadataName, ".")[0]];
	MetaItem = Metadata.FindByFullName(MetadataName);
	If MetadataInfo.hasAttributes(MetadataType) Then
		AddChild(MetaItem, Result, "Attributes");
	EndIf;
	If MetadataInfo.hasDimensions(MetadataType) Then
		AddChild(MetaItem, Result, "Dimensions");
	EndIf;
	If MetadataInfo.hasStandardAttributes(MetadataType) Then
		AddChild(MetaItem, Result, "StandardAttributes");
	EndIf;
	If MetadataInfo.hasRecalculations(MetadataType) Then
		AddChild(MetaItem, Result, "Recalculations");
	EndIf;
	If MetadataInfo.hasAccountingFlags(MetadataType) Then
		AddChild(MetaItem, Result, "AccountingFlags");
	EndIf;

	For Each CmAttribute In Metadata.CommonAttributes Do
		If Not CmAttribute.Content.Find(Metadata.FindByFullName(MetadataName)) = Undefined And CmAttribute.Content.Find(
			Metadata.FindByFullName(MetadataName)).Use = Metadata.ObjectProperties.CommonAttributeUse.Use Then
			Result.ChoiceData.Add("CommonAttribute." + CmAttribute.Name, ?(IsBlankString(CmAttribute.Synonym),
				CmAttribute.Name, CmAttribute.Synonym), , PictureLib.CommonAttributes);
			Result.FieldsArray.Add(CmAttribute.Name);
		EndIf;
	EndDo;
	Return Result;
EndFunction

// Add child.
// 
// Parameters:
//  MetaItem - MetadataObject - Meta item
//  Result - See FillAttributeList
//  MetadataName - String - Data type
Procedure AddChild(MetaItem, Result, MetadataName)

	If MetaItem = Undefined Then
		Return;
	EndIf;
	
	MetaCollection = MetaItem[MetadataName]; // Array of MetadataObjectAttribute
	If Not MetaCollection.Count() Then
		Return;
	EndIf;

	For Each AddChild In MetaCollection Do
		//@skip-check invocation-parameter-type-intersect
		Result.ChoiceData.Add(MetadataName + "." + AddChild.Name, ?(IsBlankString(AddChild.Synonym), AddChild.Name,
			AddChild.Synonym), , PictureLib[MetadataName]);
		Result.FieldsArray.Add(AddChild.Name);
	EndDo;

EndProcedure

// Get virtual table.
// 
// Parameters:
//  MetadataName - String - Metadata name
// 
// Returns:
//  ValueTable - Get virtual table
Function GetVirtualTable(MetadataName) Export
	
	Query = New Query;
	Query.Text =
		"SELECT
		|	" + StrConcat(FillAttributeList(MetadataName).FieldsArray, "," + Chars.LF) + "
		|FROM
		|	" + MetadataName + "
		|WHERE FALSE";
	
	Return Query.Execute().Unload();
	
EndFunction
