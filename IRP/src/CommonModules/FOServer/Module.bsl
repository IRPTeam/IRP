// @strict-types

// Get FO List.
// 
// Returns:
//  Array of String - Get FO List
Function GetFOList() Export

	FOList = New Array; // Array of String
	
	For Each FunctionalOption In Metadata.FunctionalOptions Do
		NameParts = StrSplit(FunctionalOption.Name, "_");
		If StrStartsWith(NameParts[NameParts.UBound()], "Use") Then
			FOList.Add(FunctionalOption.Name);
		EndIf;
	EndDo;
	
	Return FOList;
	
EndFunction

// Get FO Subordination.
// 
// Returns:
//  Structure - Get FO Subordination
Function GetFOSubordination() Export

	Subordination = New Structure;
	
	UseLegalName = New Array; // Array of String
	UseLegalName.Add("UseLegalNameContract");
	Subordination.Insert("UseLegalName", UseLegalName);
	
	UseStores = New Array; // Array of String
	UseStores.Add("UseSimpleBatch");
	UseStores.Add("UseVariableStore");
	Subordination.Insert("UseStores", UseStores);
	
	UseItemKey = New Array; // Array of String
	UseItemKey.Add("UseVariableItemKey");
	Subordination.Insert("UseItemKey", UseItemKey);
	
	UsePurchase = New Array; // Array of String
	UsePurchase.Add("UseOrders");
	UsePurchase.Add("UsePlannedReceiptReservation");
	UsePurchase.Add("UseLandedCost");
	UsePurchase.Add("UsePreliminary");
	UsePurchase.Add("UseSourceOfOrigin");
	Subordination.Insert("UsePurchase", UsePurchase);
	
	UseSales = New Array; // Array of String
	UseSales.Add("UseOrders");
	UseSales.Add("UseSpecialOffers");
	UseSales.Add("UseDeliveryDate");
	UseSales.Add("UsePartnerTerms");
	UseSales.Add("UseWorkOrders");
	Subordination.Insert("UseSales", UseSales);
	
	UseRetail = New Array; // Array of String
	UseRetail.Add("UseRetailOrders");
	UseRetail.Add("UseConsolidatedRetailSales");
	Subordination.Insert("UseRetail", UseRetail);
	
	UseFinance = New Array; // Array of String
	UseFinance.Add("UseBankDocuments");
	UseFinance.Add("UseCashTransaction");
	UseFinance.Add("UseChequeBonds");
	UseFinance.Add("UseAging");
	UseFinance.Add("UseAccounting");
	UseFinance.Add("UseAccountingService");
	UseFinance.Add("UseELedger");
	UseFinance.Add("UseFixedAssets");
	UseFinance.Add("UseSalary");
	Subordination.Insert("UseFinance", UseFinance);
	
	Return Subordination;
	
EndFunction

// Get FO Groups.
// 
// Returns:
//  Structure - Get FO Groups
Function GetFOGroups() Export

	FOGroups = New Structure;
	
	FOList = New Array; // Array of String
	FOList.Add("UseAllFunctional");
	FOList.Add("UseAdditionalSettings");
	FOList.Add("UseAddAttributesAndProperties");
	FOList.Add("UseContactInformation");
	FOList.Add("UseNumberingRules");
	FOList.Add("UseEquipments");
	FOList.Add("UseObjectAccess");
	FOList.Add("UseObjectTransformation");
	FOList.Add("UseIncidents");
	FOList.Add("UseIntegrations");
	FOList.Add("UseJobQueueForExternalFunctions");
	FOList.Add("UseMobile");
	FOList.Add("UseBusinessProcess");
	FOList.Add("UseLockDataModification");
	FOList.Add("UseMessaging");
	FOGroups.Insert("BaseSettings", FOList);
	
	FOList = New Array; // Array of String
	FOList.Add("UseUnitsAndDimensions");
	FOList.Add("UseStores");
	FOList.Add("UseCompanies");
	FOList.Add("UseLegalName");
	FOList.Add("UseProfitLossCenter");
	FOList.Add("UseBusinessUnits");
	FOList.Add("UsePartnersHierarchy");
	FOList.Add("UsePartnerItems");
	FOList.Add("UseItemKey");
	FOList.Add("UseSerialLotNumbers");
	FOList.Add("UsePriceByProperties");
	FOList.Add("UseExpenseAndRevenueTypes");
	FOGroups.Insert("MasterData", FOList);
	
	FOList = New Array; // Array of String
	FOList.Add("UsePurchase");
	FOList.Add("UseSales");
	FOList.Add("UseRetail");
	FOGroups.Insert("Trading", FOList);
	
	FOList = New Array; // Array of String
	FOList.Add("UseStores");
	FOList.Add("UseShipmentAndReceiptPlaningOrders");
	FOList.Add("UseShipmentConfirmationAndGoodsReceipts");
	FOList.Add("UseBundling");
	FOList.Add("UseManufacturing");
	FOGroups.Insert("Inventory", FOList);

	FOList = New Array; // Array of String
	FOList.Add("UseFinance");
	FOGroups.Insert("Money", FOList);
	
	Return FOGroups;
	
EndFunction

// Get FOGroup synonym.
// 
// Parameters:
//  GroupName - String - Group name
// 
// Returns:
//  String - Get FOGroup synonym
Function GetFOGroupSynonym(GroupName) Export
	
	NameParts = StrSplit(GroupName, "_");
	If NameParts.Count() = 1 Then
		SynonymName = "FO_Group_" + GroupName;
	Else
		NamePostfix = NameParts[NameParts.UBound()];
		NamePrefix = Mid(GroupName, 1, StrLen(GroupName) - StrLen(NamePostfix));
		SynonymName = NamePrefix + "FO_Group_" + NamePostfix;
	EndIf;
	
	GroupSynonym = Undefined;
	If Not R().Property(SynonymName, GroupSynonym) Then
		GroupSynonym = "";
	EndIf;
	
	Return GroupSynonym;

EndFunction

// Get functional option value.
// 
// Parameters:
//  Name - String - Name
// 
// Returns:
//  Arbitrary - Get FOValue
Function GetFunctionalOptionValue(Name) Export
	MethodName = "Is" + Name + "()";
	SetSafeMode(True);
	Try
		Result = Eval(MethodName);
	Except
		Result = IsUseFunctionalOptionByName(Name);
	EndTry;
	Return Result;
EndFunction

// Set functional option value.
// 
// Parameters:
//  Name - String - Name
//  Value - Boolean - Value
Procedure SetFunctionalOptionValue(Name, Value) Export
	
	If Value = GetFunctionalOptionValue(Name) Then
		Return;
	EndIf;
	
	Constants[Name].Set(Value);
	
EndProcedure

#Region FunctionalOptions

// Is use functional option by name.
// 
// Parameters:
//  FunctionalOptionName - String - Functional option name
// 
// Returns:
//  Arbitrary - Is use functional option by name
Function IsUseFunctionalOptionByName(FunctionalOptionName)
	FunctionalOptionMetadata = Metadata.FunctionalOptions.Find(FunctionalOptionName);
	If FunctionalOptionMetadata = Undefined Then
		Raise StrTemplate(R().Exc_010, FunctionalOptionName)
	EndIf;
	Return GetFunctionalOption(FunctionalOptionName);
EndFunction

Function IsUseAccounting() Export
	Return GetFunctionalOption("UseAccounting");
EndFunction

Function IsUseBankDocuments() Export
	Return GetFunctionalOption("UseBankDocuments");
EndFunction

Function IsUseItemKey() Export
	Return GetFunctionalOption("UseItemKey");
EndFunction

Function IsUsePriceByProperties() Export
	Return GetFunctionalOption("UsePriceByProperties");
EndFunction

Function IsUsePartnerTerms() Export
	Return GetFunctionalOption("UsePartnerTerms");
EndFunction

Function IsUseCompanies() Export
	Return GetFunctionalOption("UseCompanies");
EndFunction

Function IsUseLegalName() Export
	Return GetFunctionalOption("UseLegalName");
EndFunction

Function IsUsePartnersHierarchy() Export
	Return GetFunctionalOption("UsePartnersHierarchy");
EndFunction

Function IsUseUnitsAndDimensions() Export
	Return GetFunctionalOption("UseUnitsAndDimensions");
EndFunction

Function IsUseStores() Export
	Return GetFunctionalOption("UseStores");
EndFunction

Function IsUseCashTransaction() Export
	Return GetFunctionalOption("UseCashTransaction");
EndFunction

Function IsUseConsolidatedRetailSales() Export
	Return GetFunctionalOption("UseConsolidatedRetailSales");
EndFunction

Function IsUseManufacturing() Export
	Return GetFunctionalOption("UseManufacturing");
EndFunction

Function IsUseWorkOrders() Export
	Return GetFunctionalOption("UseWorkOrders");
EndFunction

Function IsUseCommissionTrading() Export
	Return GetFunctionalOption("UseCommissionTrading");
EndFunction

Function IsUseRetailOrders() Export
	Return GetFunctionalOption("UseRetailOrders");
EndFunction

Function IsUseSalary() Export
	Return GetFunctionalOption("UseSalary");
EndFunction

Function IsUseRetail() Export
	Return GetFunctionalOption("UseRetail");
EndFunction

Function IsUseLockDataModification() Export
	Return GetFunctionalOption("UseLockDataModification");
EndFunction

Function IsUseAdditionalTableControlDocument() Export
	Return GetFunctionalOption("UseAdditionalTableControlDocument");
EndFunction

Function IsUseSimpleMode() Export
	Return GetFunctionalOption("UseSimpleMode");
EndFunction

Function IsUseFixedAssets() Export
	Return GetFunctionalOption("UseFixedAssets");
EndFunction

Function IsUseShipmentConfirmationAndGoodsReceipts() Export
	Return GetFunctionalOption("UseShipmentConfirmationAndGoodsReceipts");
EndFunction

Function IsUseChequeBonds() Export
	Return GetFunctionalOption("UseChequeBonds");
EndFunction

Function IsUseAccountingService() Export
	Return GetFunctionalOption("UseAccountingService");
EndFunction

Function IsUseELedger() Export
	Return GetFunctionalOption("UseELedger");
EndFunction

Function IsUseUseSerialLotNumbers() Export
	Return GetFunctionalOption("UseSerialLotNumbers");
EndFunction

Function IsUseShipmentAndReceiptPlaningOrders() Export
	Return GetFunctionalOption("UseShipmentAndReceiptPlaningOrders");
EndFunction

Function IsUseSimpleBatch() Export
	Return GetFunctionalOption("UseSimpleBatch");
EndFunction

Function IsUsePreliminary() Export
	Return GetFunctionalOption("UsePreliminary");
EndFunction

Function IsUseAddAttributesAndProperties() Export
	Return GetFunctionalOption("UseAddAttributesAndProperties");
EndFunction

Function IsUseNumberingRules() Export
	Return GetFunctionalOption("UseNumberingRules");
EndFunction

Function IsUseAdditionalSettings() Export
	Return GetFunctionalOption("UseAdditionalSettings");
EndFunction

Function IsUseAging() Export
	Return GetFunctionalOption("UseAging");
EndFunction

Function IsUseAllFunctional() Export
	Return GetFunctionalOption("UseAllFunctional");
EndFunction

Function IsUseBundling() Export
	Return GetFunctionalOption("UseBundling");
EndFunction

Function IsUseBusinessUnits() Export
	Return GetFunctionalOption("UseBusinessUnits");
EndFunction

Function IsUseContactInformation() Export
	Return GetFunctionalOption("UseContactInformation");
EndFunction

Function IsUseDeliveryDate() Export
	Return GetFunctionalOption("UseDeliveryDate");
EndFunction

Function IsUseEquipments() Export
	Return GetFunctionalOption("UseEquipments");
EndFunction

Function IsUseExpenseAndRevenueTypes() Export
	Return GetFunctionalOption("UseExpenseAndRevenueTypes");
EndFunction

Function IsUseFinance() Export
	Return GetFunctionalOption("UseFinance");
EndFunction

Function IsUseIncidents() Export
	Return GetFunctionalOption("UseIncidents");
EndFunction

Function IsUseIntegrations() Export
	Return GetFunctionalOption("UseIntegrations");
EndFunction

Function IsUseJobQueueForExternalFunctions() Export
	Return GetFunctionalOption("UseJobQueueForExternalFunctions");
EndFunction

Function IsUseLandedCost() Export
	Return GetFunctionalOption("UseLandedCost");
EndFunction

Function IsUseLegalNameContract() Export
	Return GetFunctionalOption("UseLegalNameContract");
EndFunction

Function IsUseManagersAndSalesPersons() Export
	Return GetFunctionalOption("UseManagersAndSalesPersons");
EndFunction

Function IsUseMessaging() Export
	Return GetFunctionalOption("UseMessaging");
EndFunction

Function IsUseMobile() Export
	Return GetFunctionalOption("UseMobile");
EndFunction

Function IsUseObjectAccess() Export
	Return GetFunctionalOption("UseObjectAccess");
EndFunction

Function IsUseObjectTransformation() Export
	Return GetFunctionalOption("UseObjectTransformation");
EndFunction

Function IsUseOrders() Export
	Return GetFunctionalOption("UseOrders");
EndFunction

Function IsUsePartnerItems() Export
	Return GetFunctionalOption("UsePartnerItems");
EndFunction

Function IsUsePlannedReceiptReservation() Export
	Return GetFunctionalOption("UsePlannedReceiptReservation");
EndFunction

Function IsUseProfitLossCenter() Export
	Return GetFunctionalOption("UseProfitLossCenter");
EndFunction

Function IsUsePurchase() Export
	Return GetFunctionalOption("UsePurchase");
EndFunction

Function IsUseResponsiblePerson() Export
	Return GetFunctionalOption("UseResponsiblePerson");
EndFunction

Function IsUseSales() Export
	Return GetFunctionalOption("UseSales");
EndFunction

Function IsUseSerialLotNumbers() Export
	Return GetFunctionalOption("UseSerialLotNumbers");
EndFunction

Function IsUseSourceOfOrigin() Export
	Return GetFunctionalOption("UseSourceOfOrigin");
EndFunction

Function IsUseSpecialOffers() Export
	Return GetFunctionalOption("UseSpecialOffers");
EndFunction

Function IsUseVariableItemKey() Export
	Return GetFunctionalOption("UseVariableItemKey");
EndFunction

Function IsUseVariableStore() Export
	Return GetFunctionalOption("UseVariableStore");
EndFunction

Function IsUseBusinessProcess() Export
	Return GetFunctionalOption("UseBusinessProcess");
EndFunction

Function IsUseDashboard() Export
	Return GetFunctionalOption("UseDashboard");
EndFunction

#EndRegion
