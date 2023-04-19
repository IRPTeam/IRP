
// Taxes server

Function GetTaxRatesForItemKey(Date, Company, Tax, ItemKey) Export
	Return TaxesServer._GetTaxRatesForItemKey(Date, Company, Tax, ItemKey);
EndFunction
	
Function GetTaxRatesForAgreement(Date, Company, Tax, Agreement) Export
	Return TaxesServer._GetTaxRatesForAgreement(Date, Company, Tax, Agreement);
EndFunction

Function GetTaxRatesForTransactionType(Date, Company, Tax, TransactionType) Export
	Return TaxesServer._GetTaxRatesForTransactionType(Date, Company, Tax, TransactionType);
EndFunction

Function GetTaxRatesForCompany(Date, Company, Tax) Export
	Return TaxesServer._GetTaxRatesForCompany(Date, Company, Tax);
EndFunction

Function GetTaxesInfo(Date, Company, DocumentName, TransactionType) Export
	Return TaxesServer._GetTaxesInfo(Date, Company, DocumentName, TransactionType);
EndFunction

Function GetTaxRatesByTax(Tax) Export
	Return TaxesServer._GetTaxRatesByTax(Tax);
EndFunction

Function CalculateTax(Tax, TaxRateOrAmount, PriceIncludeTax, _Key, TotalAmount, NetAmount, Ref, Reverse) Export
	Return TaxesServer._CalculateTax(Tax, TaxRateOrAmount, PriceIncludeTax, _Key, TotalAmount, NetAmount, Ref, Reverse);
EndFunction

// Get item info

Function ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType) Export
	Return GetItemInfo._ItemPriceInfo(Parameter_Period, Parameter_ItemKey, Parameter_Unit, Parameter_PriceType);
EndFunction

// Catalogs Agreements

Function GetAgreementInfo(Agreement) Export
	Return Catalogs.Agreements._GetAgreementInfo(Agreement);
EndFunction

// RowIDInfo

Function GetAllDataFromBasis(DocRef, Basis, BasisKey, RowID, CurrentStep, ProportionalScaling) Export
	Return RowIDInfoServer._GetAllDataFromBasis(DocRef, Basis, BasisKey, RowID, CurrentStep, ProportionalScaling);
EndFunction


