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