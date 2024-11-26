
// Check via service.
// 
// Parameters:
//	CheckedData - Structure:
//  * Item - CatalogRef.Items -
//  * ItemKey - CatalogRef.ItemKeys -
//  * SerialLotNumber - CatalogRef.SerialLotNumbers -
//  * Hardware - CatalogRef.Hardware -
//  * isReturn - Boolean -
// 
// Returns:
//  Boolean
Function CheckViaService(CheckedData) Export
	Return False;
EndFunction

// Is a check needed.
// 
// Parameters:
//	CheckedData - Structure:
//  * Item - CatalogRef.Items -
//  * ItemKey - CatalogRef.ItemKeys -
//  * SerialLotNumber - CatalogRef.SerialLotNumbers -
//  * Hardware - CatalogRef.Hardware -
//  * isReturn - Boolean -
// 
// Returns:
//  Boolean - Is a check needed
Function IsCheckNeeded(CheckedData) Export
	Return True;
EndFunction
