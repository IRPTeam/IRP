
Function GetLinkedDocumentsFilter_SI(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("AgreementSales"       , Object.Agreement);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	
	If Object.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.Sales") Then
		Filter.Insert("TransactionType", PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.Sales"));
	ElsIf Object.TransactionType = PredefinedValue("Enum.SalesTransactionTypes.ShipmentToTradeAgent") Then
		Filter.Insert("TransactionType", PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ShipmentToTradeAgent"));
	EndIf;
	
	Filter.Insert("ProcurementMethod"    , PredefinedValue("Enum.ProcurementMethods.Purchase"));	
	Filter.Insert("TransactionTypeSales" , Object.TransactionType);
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

Function GetLinkedDocumentsFilter_RSC(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"            , Object.Company);
	Filter.Insert("RetailCustomer"     , Object.RetailCustomer);
	Filter.Insert("TransactionType"    , Object.TransactionType);
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
	Filter.Insert("TransactionTypeSR"    , Object.TransactionType);
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
	
	If Object.TransactionType = PredefinedValue("Enum.SalesReturnTransactionTypes.ReturnFromCustomer") Then
		Filter.Insert("TransactionType" , PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromCustomer"));
	ElsIf Object.TransactionType = PredefinedValue("Enum.SalesReturnTransactionTypes.ReturnFromTradeAgent") Then
		Filter.Insert("TransactionType" , PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReturnFromTradeAgent"));
	EndIf;
	Filter.Insert("Ref"           , Object.Ref);
	Filter.Insert("CompanyReturn" , Object.Company);
	Filter.Insert("BranchReturn"  , Object.Branch);
	Filter.Insert("TransactionTypeSR", Object.TransactionType);
	
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
	
	If Object.TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.Purchase") Then
		Filter.Insert("TransactionType", PredefinedValue("Enum.GoodsReceiptTransactionTypes.Purchase"));
	ElsIf Object.TransactionType = PredefinedValue("Enum.PurchaseTransactionTypes.ReceiptFromConsignor") Then
		Filter.Insert("TransactionType", PredefinedValue("Enum.GoodsReceiptTransactionTypes.ReceiptFromConsignor"));
	EndIf;
	
	Filter.Insert("ProcurementMethod"        , PredefinedValue("Enum.ProcurementMethods.Purchase"));
	Filter.Insert("TransactionTypePurchases" , Object.TransactionType);
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

Function GetLinkedDocumentsFilter_RGR(Object) Export
	Map = New Map();
	
	Map.Insert(PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.CourierDelivery"),
	PredefinedValue("Enum.RetailShipmentConfirmationTransactionTypes.CourierDelivery"));
	
	Map.Insert(PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.Pickup"),
	PredefinedValue("Enum.RetailShipmentConfirmationTransactionTypes.Pickup"));
	
	Filter = New Structure();
	Filter.Insert("Company"            , Object.Company);
	Filter.Insert("RetailCustomer"     , Object.RetailCustomer);
	Filter.Insert("TransactionType"    , Map.Get(Object.TransactionType));
	Filter.Insert("PartnerSales"       , Object.Partner);
	Filter.Insert("LegalNameSales"     , Object.LegalName);
	Filter.Insert("TransactionTypeRGR" , Object.TransactionType);
		
	Filter.Insert("Ref"                , Object.Ref);
	
	VisibleFields = New Structure();
	VisibleFields.Insert("Company");
	VisibleFields.Insert("Branch");
	Filter.Insert("VisibleFields", VisibleFields);
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
	Filter.Insert("TransactionTypePR"        , Object.TransactionType);
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
	
	If Object.TransactionType = PredefinedValue("Enum.PurchaseReturnTransactionTypes.ReturnToVendor") Then
		Filter.Insert("TransactionType" , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToVendor"));
	ElsIf Object.TransactionType = PredefinedValue("Enum.PurchaseReturnTransactionTypes.ReturnToConsignor") Then
		Filter.Insert("TransactionType" , PredefinedValue("Enum.ShipmentConfirmationTransactionTypes.ReturnToConsignor"));
	EndIf;
	
	Filter.Insert("TransactionTypePR"        , Object.TransactionType);
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
	Filter.Insert("CompanyReturn"      , Object.Company);
	Filter.Insert("BranchReturn"       , Object.Branch);
	Filter.Insert("TransactionTypeRGR" , PredefinedValue("Enum.RetailGoodsReceiptTransactionTypes.ReturnFromCustomer"));
	Filter.Insert("RetailCustomer"     , Object.RetailCustomer);
	
	Filter.Insert("Ref"                  , Object.Ref);

	VisibleFields = New Structure();
	VisibleFields.Insert("Company");
	VisibleFields.Insert("Branch");
	Filter.Insert("VisibleFields", VisibleFields);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_RSR(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("RetailCustomer"       , Object.RetailCustomer);
	Filter.Insert("CurrencySales"        , Object.Currency);
	Filter.Insert("TransactionTypeSales" , PredefinedValue("Enum.SalesTransactionTypes.RetailSales"));
	Filter.Insert("PriceIncludeTaxSales" , Object.PriceIncludeTax);
	Filter.Insert("Ref"                  , Object.Ref);
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
	Filter.Insert("TransactionTypeSales" , PredefinedValue("Enum.SalesTransactionTypes.Sales"));
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Function GetLinkedDocumentsFilter_WS(Object) Export
	Filter = New Structure();
	Filter.Insert("Company"              , Object.Company);
	Filter.Insert("Branch"               , Object.Branch);
	Filter.Insert("PartnerSales"         , Object.Partner);
	Filter.Insert("LegalNameSales"       , Object.LegalName);
	Filter.Insert("TransactionTypeSales" , PredefinedValue("Enum.SalesTransactionTypes.Sales"));
	Filter.Insert("Ref"                  , Object.Ref);
	Return Filter;
EndFunction

Procedure FillVisibleFields(BasisesTree, VisibleFields) Export
	For Each Field In VisibleFields Do
		For Each TopLevel In BasisesTree.GetItems() Do
			If Not ValueIsFilled(TopLevel.Basis) Then
				Continue;
			EndIf;
			TopLevel[Field.Key + "Presentation"] = TopLevel.Basis[Field.Key];
			FillVisibleFields(TopLevel, VisibleFields);
		EndDo;
	EndDo;
EndProcedure

