
// Get structure of entered item.
// 
// Returns:
//  Structure - Get structure entered item:
// * Ref - Undefined - Basis document
// * Company - Undefined - Company
// * Partner - Undefined - Partner
// * LegalName - Undefined - LegalName
// * Agreement - Undefined - Agreement
// * Currency - Undefined - Currency
// * Amount - Number - Amount
Function GetStructureEnteredItem() Export
	Resultat = New Structure;
	Resultat.Insert("Ref", Undefined);
	Resultat.Insert("Company", Undefined);
	Resultat.Insert("Partner", Undefined);
	Resultat.Insert("LegalName", Undefined);
	Resultat.Insert("Agreement", Undefined);
	Resultat.Insert("Currency", Undefined);
	Resultat.Insert("Amount", 0);
	Return Resultat;
EndFunction

// Set period in dynamic list.
// 
// Parameters:
//  List - DynamicList - list to set the date
//  ByDocumentDate - Boolean - By document date (otherwise by current date)
Procedure SetPeriodInDynamicList(List, ByDocumentDate) Export
	NewPeriod = EndOfDay(CurrentDate());
	If ByDocumentDate Then
		AdditionalParameters = Undefined; // Structure
		If List.SettingsComposer.Settings.AdditionalProperties.Property("AdditionalParameters", AdditionalParameters) Then
			NewPeriod = CommonFunctionsClientServer.GetSliceLastDateByRefAndDate(
				AdditionalParameters.Ref, AdditionalParameters.DocumentDate);
		EndIf;
	EndIf;
	List.Parameters.SetParameterValue("Period", NewPeriod);
EndProcedure