
// Get open form args pickup special offers for document.
// 
// Parameters:
//  Object - DefinedType.typeObjectWithSpecialOffers
// 
// Returns:
//  Structure - Get open form args pickup special offers for document:
// * ArrayOfOffers - Array -
// * Type - String -
// * Object - DefinedType.typeObjectWithSpecialOffers
// * ItemListRowKey - Undefined -
Function GetOpenFormArgsPickupSpecialOffers_ForDocument(Object) Export
	OpenArgs = New Structure();
	OpenArgs.Insert("ArrayOfOffers", OffersServer.GetAllActiveOffers_ForDocument(Object));
	OpenArgs.Insert("Type", "Offers_ForDocument");
	OpenArgs.Insert("Object", Object);
	OpenArgs.Insert("ItemListRowKey", Undefined);
	Return OpenArgs;
EndFunction
