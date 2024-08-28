#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Store - CatalogRef.Stores -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Store", Catalogs.Stores.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

// Additional data filling.
// 
// Parameters:
//  MovementsValueTable - ValueTable
Procedure AdditionalDataFilling(MovementsValueTable) Export
	Return;	
EndProcedure

Function CheckBalance(Ref, ItemList_InDocument, Records_InDocument, Records_Exists, RecordType, Unposting, AddInfo = Undefined) Export

	If Not PostingServer.CheckingBalanceIsRequired(Ref, "CheckBalance_R4050B_StockInventory") Then
		Return True;
	EndIf;

	Tables = New Structure();
	Tables.Insert("ItemList_InDocument", ItemList_InDocument);
	Tables.Insert("Records_InDocument", Records_InDocument);
	Tables.Insert("Records_Exists", Records_Exists);

	Return PostingServer.CheckBalance_R4050B_StockInventory(Ref, Tables, RecordType, Unposting, AddInfo);
EndFunction