// @strict-types

// Get acquiring hardware.
// 
// Parameters:
//  Filter - See GetAcquiringHardwareSettings
// 
// Returns:
//  CatalogRef.Hardware
Function GetAcquiringHardware(Filter) Export
	Return Filter.Account.Acquiring;
EndFunction

// Get acquiring hardware settings.
// 
// Returns:
//  Structure - Get acquiring hardware settings:
// * Account - CatalogRef.CashAccounts -
Function GetAcquiringHardwareSettings() Export
	Str = New Structure;
	Str.Insert("Account", Catalogs.CashAccounts.EmptyRef());
	Return Str;
EndFunction