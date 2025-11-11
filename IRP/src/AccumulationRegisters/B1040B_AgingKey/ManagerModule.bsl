
#Region AccessObject

// Get access key.
// See Role.TemplateAccumulationRegisters - Parameters orders has to be the same
// 
// Returns:
//  Structure - Get access key:
// * Company - CatalogRef.Companies -
// * Branch - CatalogRef.BusinessUnits -
Function GetAccessKey() Export
	AccessKeyStructure = New Structure;
	AccessKeyStructure.Insert("Company", Catalogs.Companies.EmptyRef());
	AccessKeyStructure.Insert("Branch", Catalogs.BusinessUnits.EmptyRef());
	Return AccessKeyStructure;
EndFunction

#EndRegion

Procedure AdditionalDataFilling(MovementsValueTable) Export
	ArrayForDelete = New Array();
	
	For Each Row In MovementsValueTable Do
		If Row.CurrencyMovementType <> ChartsOfCharacteristicTypes.CurrencyMovementType.SettlementCurrency Then
			ArrayForDelete.Add(Row);
		EndIf;
	EndDo;
	
	For Each Item In ArrayForDelete Do
		MovementsValueTable.Delete(Item);
	EndDo;
EndProcedure
