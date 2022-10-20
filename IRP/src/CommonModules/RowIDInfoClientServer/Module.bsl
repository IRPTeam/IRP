
Function GetLinkedDocumentsFilter_SI(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"      , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales"));
	Filter.Insert("ProcurementMethod"    , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SC(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"            , Object.Company);
	Filter.Insert("Branch"             , Object.Branch);
	Filter.Insert("PartnerSales"       , Object.Partner);
	Filter.Insert("LegalNameSales"     , Object.LegalName);
	Filter.Insert("PartnerPurchases"   , Object.Partner);
	Filter.Insert("LegalNamePurchases" , Object.LegalName);
	Filter.Insert("TransactionType"    , Object.TransactionType);
	Filter.Insert("ProcurementMethod"  , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"                , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SRO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_SR(Object) Export
	Filter = New Structure();
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"      , PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer"));
	Filter.Insert("Ref"                  , Object.Ref);
	
	Filter.Insert("CompanyReturn" , Object.Company);
	Filter.Insert("BranchReturn"  , Object.Branch);
	
	VisibleFields = New Structure();
	VisibleFields.Insert("Company");
	VisibleFields.Insert("Branch");
	Filter.Insert("VisibleFields", VisibleFields);
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
	Filter.Insert("Company"                  , Object.Company);
	Filter.Insert("Branch"                   , Object.Branch);
	Filter.Insert("PartnerPurchases"         , Object.Partner);
	Filter.Insert("LegalNamePurchases"       , Object.LegalName);
	Filter.Insert("AgreementPurchases"       , Object.Agreement);
	Filter.Insert("CurrencyPurchases"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxPurchases" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"          , PredefinedValue("Enum.GoodsReceiptTransactionTypes.Purchase"));
	Filter.Insert("ProcurementMethod"        , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("Ref"                      , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_GR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"            , Object.Company);
	Filter.Insert("Branch"             , Object.Branch);
	Filter.Insert("PartnerPurchases"   , Object.Partner);
	Filter.Insert("LegalNamePurchases" , Object.LegalName);
	Filter.Insert("PartnerSales"       , Object.Partner);
	Filter.Insert("LegalNameSales"     , Object.LegalName);
	Filter.Insert("TransactionType"    , Object.TransactionType);
	Filter.Insert("Ref"                , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PRO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"                  , Object.Company);
	Filter.Insert("Branch"                   , Object.Branch);
	Filter.Insert("PartnerPurchases"         , Object.Partner);
	Filter.Insert("LegalNamePurchases"       , Object.LegalName);
	Filter.Insert("AgreementPurchases"       , Object.Agreement);
	Filter.Insert("CurrencyPurchases"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxPurchases" , Object.PriceIncludeTax);
	Filter.Insert("Ref"                      , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_PR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"                  , Object.Company);
	Filter.Insert("Branch"                   , Object.Branch);
	Filter.Insert("PartnerPurchases"         , Object.Partner);
	Filter.Insert("LegalNamePurchases"       , Object.LegalName);
	Filter.Insert("AgreementPurchases"       , Object.Agreement);
	Filter.Insert("CurrencyPurchases"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxPurchases" , Object.PriceIncludeTax);
	Filter.Insert("TransactionType"          , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor"));
	Filter.Insert("Ref"                      , Object.Ref);
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

Function GetLinkedDocumentsFilter_PRR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"           , Object.Company);
	Filter.Insert("Branch"            , Object.Branch);
	Filter.Insert("Requester"         , Object.Requester);
	Filter.Insert("ProcurementMethod" , PredefinedValue("Enum.ProcurementMethods.IncomingReserve"));
	Filter.Insert("Ref"               , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_RRR(Object) Export
	Filter = New Structure();
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("Ref"                  , Object.Ref);

	VisibleFields = New Structure();
	VisibleFields.Insert("Company");
	VisibleFields.Insert("Branch");
	Filter.Insert("VisibleFields", VisibleFields);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_WO(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_WS(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Procedure FillVisibleFields(BasisesTree, VisibleFields) Export
	For Each Field In VisibleFields Do
		For Each TopLevel In BasisesTree.GetItems() Do
			TopLevel[Field.Key + "Presentation"] = TopLevel.Basis[Field.Key];
		EndDo;
	EndDo;
EndProcedure

