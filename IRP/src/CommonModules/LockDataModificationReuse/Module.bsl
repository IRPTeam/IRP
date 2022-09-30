// @strict-types

// Get DSCTemplate.
// 
// Parameters:
//  MetadataName - String - Metadata name
// 
// Returns:
//  DataCompositionSchema - Get DSCTemplate
Function GetDSCTemplate(Val MetadataName) Export
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
	Return DCSTemplate
EndFunction