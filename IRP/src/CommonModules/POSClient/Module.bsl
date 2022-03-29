// @strict-types

#Region Constructors


// Button Settings.
// 
// Returns:
//  Structure - Button Settings:
// * PaymentType - CatalogRef.PaymentTypes -
// * BankTerm - CatalogRef.BankTerms -
// * PaymentTypeEnum - EnumRef.PaymentTypes -
Function ButtonSettings() Export
	
	ButtonSettings = New Structure();
	ButtonSettings.Insert("PaymentType", PredefinedValue("Catalog.PaymentTypes.EmptyRef"));
	ButtonSettings.Insert("BankTerm", PredefinedValue("Catalog.BankTerms.EmptyRef"));
	ButtonSettings.Insert("PaymentTypeEnum", PredefinedValue("Enum.PaymentTypes.EmptyRef"));
	
	Return ButtonSettings;
	
EndFunction

#EndRegion
