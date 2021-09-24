
Function GetLinkedDocumentsFilter_SI(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"           , Object.Company);
	Filter.Insert("Branch"            , Object.Branch);
	Filter.Insert("Partner"           , Object.Partner);
	Filter.Insert("LegalName"         , Object.LegalName);
	Filter.Insert("Agreement"         , Object.Agreement);
	Filter.Insert("Currency"          , Object.Currency);
	Filter.Insert("PriceIncludeTax"   , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"   , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales"));
	Filter.Insert("ProcurementMethod" , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"               , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SC(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"        , Object.Company);
	Filter.Insert("Branch"         , Object.Branch);
	Filter.Insert("Partner"        , Object.Partner);
	Filter.Insert("LegalName"      , Object.LegalName);
	Filter.Insert("TransactionType", Object.TransactionType);
	Filter.Insert("Ref"            , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SRO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"         , Object.Company);
	Filter.Insert("Branch"          , Object.Branch);
	Filter.Insert("Partner"         , Object.Partner);
	Filter.Insert("LegalName"       , Object.LegalName);
	Filter.Insert("Agreement"       , Object.Agreement);
	Filter.Insert("Currency"        , Object.Currency);
	Filter.Insert("PriceIncludeTax" , Object.PriceIncludeTax);
	Filter.Insert("Ref"             , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"         , Object.Company);
	Filter.Insert("Branch"          , Object.Branch);
	Filter.Insert("Partner"         , Object.Partner);
	Filter.Insert("LegalName"       , Object.LegalName);
	Filter.Insert("Agreement"       , Object.Agreement);
	Filter.Insert("Currency"        , Object.Currency);
	Filter.Insert("PriceIncludeTax" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType" , PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer"));
	Filter.Insert("Ref"             , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"          , Object.Company);
	Filter.Insert("Branch"           , Object.Branch);
	Filter.Insert("ProcurementMethod", PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"              , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PI(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"           , Object.Company);
	Filter.Insert("Branch"            , Object.Branch);
	Filter.Insert("Partner"           , Object.Partner);
	Filter.Insert("LegalName"         , Object.LegalName);
	Filter.Insert("Agreement"         , Object.Agreement);
	Filter.Insert("Currency"          , Object.Currency);
	Filter.Insert("PriceIncludeTax"   , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"   , PredefinedValue("Enum.GoodsReceiptTransactionTypes.Purchase"));
	Filter.Insert("ProcurementMethod" , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"               , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_GR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"         , Object.Company);
	Filter.Insert("Branch"          , Object.Branch);
	Filter.Insert("Partner"         , Object.Partner);
	Filter.Insert("LegalName"       , Object.LegalName);
	Filter.Insert("TransactionType" , Object.TransactionType);
	Filter.Insert("Ref"             , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PRO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"         , Object.Company);
	Filter.Insert("Branch"          , Object.Branch);
	Filter.Insert("Partner"         , Object.Partner);
	Filter.Insert("LegalName"       , Object.LegalName);
	Filter.Insert("Agreement"       , Object.Agreement);
	Filter.Insert("Currency"        , Object.Currency);
	Filter.Insert("PriceIncludeTax" , Object.PriceIncludeTax);
	Filter.Insert("Ref"             , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"         , Object.Company);
	Filter.Insert("Branch"          , Object.Branch);
	Filter.Insert("Partner"         , Object.Partner);
	Filter.Insert("LegalName"       , Object.LegalName);
	Filter.Insert("Agreement"       , Object.Agreement);
	Filter.Insert("Currency"        , Object.Currency);
	Filter.Insert("PriceIncludeTax" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType" , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor"));
	Filter.Insert("Ref"             , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_IT(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"       , Object.Company);
	Filter.Insert("Branch"        , Object.Branch);
	Filter.Insert("StoreSender"   , Object.StoreSender);
	Filter.Insert("StoreReceiver" , Object.StoreReceiver);
	Filter.Insert("Ref"           , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_ITO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company" , Object.Company);
	Filter.Insert("Branch"  , Object.Branch);
	Filter.Insert("Ref"     , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_StockAdjustmentAsSurplus(Object) Export
	Filter = New Structure();
	Filter.Insert("Company" , Object.Company);
	Filter.Insert("Branch"  , Object.Branch);
	Filter.Insert("Store"   , Object.Store);
	Filter.Insert("Ref"     , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_StockAdjustmentAsWriteOff(Object) Export
	Filter = New Structure();
	Filter.Insert("Company" , Object.Company);
	Filter.Insert("Branch"  , Object.Branch);
	Filter.Insert("Store"   , Object.Store);
	Filter.Insert("Ref"     , Object.Ref);
	Return Filter;
EndFunction
