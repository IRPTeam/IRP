
// Taxes server

Function GetTaxRatesForItemKey(Date, Company, Tax, ItemKey) Export
	Return TaxesServer._GetTaxRatesForItemKey(Date, Company, Tax, ItemKey);
EndFunction
	
Function GetTaxRatesForAgreement(Date, Company, Tax, Agreement) Export
	Return TaxesServer._GetTaxRatesForAgreement(Date, Company, Tax, Agreement);
EndFunction

Function GetTaxRatesForCompany(Date, Company, Tax) Export
	Return TaxesServer._GetTaxRatesForCompany(Date, Company, Tax);
EndFunction

Function GetTaxesByCompany(Date, Company) Export
	Return TaxesServer._GetTaxesByCompany(Date, Company);
EndFunction

Function GetTaxRatesByTax(Tax) Export
	Return TaxesServer._GetTaxRatesByTax(Tax);
EndFunction

// Get item info

Function ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType) Export
	Return GetItemInfo._ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType);
EndFunction

// Catalogs Agreements

Function GetAgreementInfo(Agreement) Export
	Return Catalogs.Agreements._GetAgreementInfo(Agreement);
EndFunction
