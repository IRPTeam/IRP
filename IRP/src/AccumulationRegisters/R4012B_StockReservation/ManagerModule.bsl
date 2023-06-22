#Region AccessObject

// Get access key.
// 	See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
//  
// Returns:
//  Structure
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion