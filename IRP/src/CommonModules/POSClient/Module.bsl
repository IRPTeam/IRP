// @strict-types

#Region Constructors


// Button setings.
// 
// Returns:
//  Structure - Button setings:
// * PaymentType - CatalogRef.PaymentTypes -
// * BankTerm - CatalogRef.BankTerms -
// * PaymentTypeEnum - EnumRef.PaymentTypes -
Function ButtonSetings() Export
	
	ButtonSetings = New Structure();
	ButtonSetings.Insert("PaymentType", PredefinedValue("Catalog.PaymentTypes.EmptyRef"));
	ButtonSetings.Insert("BankTerm", PredefinedValue("Catalog.BankTerms.EmptyRef"));
	ButtonSetings.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.EmptyRef"));
	
	Return ButtonSetings;
	
EndFunction

#EndRegion
