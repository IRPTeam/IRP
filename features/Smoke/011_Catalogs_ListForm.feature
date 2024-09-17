
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Catalogs "User access groups" (AccessGroups)

	Given I open "AccessGroups" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AccessGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AccessGroups" exception
	And I close current window

Scenario: Opening the List form Catalogs "User access profiles" (AccessProfiles)

	Given I open "AccessProfiles" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AccessProfiles" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AccessProfiles" exception
	And I close current window

Scenario: Opening the List form Catalogs "Accounting operations" (AccountingOperations)

	Given I open "AccountingOperations" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AccountingOperations" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AccountingOperations" exception
	And I close current window

Scenario: Opening the List form Catalogs "Accrual and deduction types" (AccrualAndDeductionTypes)

	Given I open "AccrualAndDeductionTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AccrualAndDeductionTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Additional attribute sets" (AddAttributeAndPropertySets)

	Given I open "AddAttributeAndPropertySets" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AddAttributeAndPropertySets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AddAttributeAndPropertySets" exception
	And I close current window

Scenario: Opening the List form Catalogs "Additional attribute values" (AddAttributeAndPropertyValues)

	Given I open "AddAttributeAndPropertyValues" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AddAttributeAndPropertyValues" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AddAttributeAndPropertyValues" exception
	And I close current window

Scenario: Opening the List form Catalogs "Addresses" (Addresses)

	Given I open "Addresses" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Addresses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Addresses" exception
	And I close current window

Scenario: Opening the List form Catalogs "Aging periods" (AgingPeriods)

	Given I open "AgingPeriods" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs AgingPeriods" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs AgingPeriods" exception
	And I close current window

Scenario: Opening the List form Catalogs "Partner terms" (Agreements)

	Given I open "Agreements" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Agreements" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Agreements" exception
	And I close current window

Scenario: Opening the List form Catalogs "Bank terms" (BankTerms)

	Given I open "BankTerms" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs BankTerms" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs BankTerms" exception
	And I close current window

Scenario: Opening the List form Catalogs "Batches" (Batches)

	Given I open "Batches" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Batches" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Batches" exception
	And I close current window

Scenario: Opening the List form Catalogs "Batch keys" (BatchKeys)

	Given I open "BatchKeys" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs BatchKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs BatchKeys" exception
	And I close current window

Scenario: Opening the List form Catalogs "Bill of materials" (BillOfMaterials)

	Given I open "BillOfMaterials" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs BillOfMaterials" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs BillOfMaterials" exception
	And I close current window

Scenario: Opening the List form Catalogs "Business units" (BusinessUnits)

	Given I open "BusinessUnits" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs BusinessUnits" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs BusinessUnits" exception
	And I close current window

Scenario: Opening the List form Catalogs "Cancel/Return reasons" (CancelReturnReasons)

	Given I open "CancelReturnReasons" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs CancelReturnReasons" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs CancelReturnReasons" exception
	And I close current window

Scenario: Opening the List form Catalogs "Cash/Bank accounts" (CashAccounts)

	Given I open "CashAccounts" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs CashAccounts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs CashAccounts" exception
	And I close current window

Scenario: Opening the List form Catalogs "Cash statement statuses" (CashStatementStatuses)

	Given I open "CashStatementStatuses" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs CashStatementStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs CashStatementStatuses" exception
	And I close current window

Scenario: Opening the List form Catalogs "Cheque bonds" (ChequeBonds)

	Given I open "ChequeBonds" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ChequeBonds" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ChequeBonds" exception
	And I close current window

Scenario: Opening the List form Catalogs "Companies" (Companies)

	Given I open "Companies" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Companies" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Companies" exception
	And I close current window

Scenario: Opening the List form Catalogs "Configuration metadata" (ConfigurationMetadata)

	Given I open "ConfigurationMetadata" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ConfigurationMetadata" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ConfigurationMetadata" exception
	And I close current window

Scenario: Opening the List form Catalogs "Countries" (Countries)

	Given I open "Countries" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Countries" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Countries" exception
	And I close current window

Scenario: Opening the List form Catalogs "Currencies" (Currencies)

	Given I open "Currencies" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Currencies" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Currencies" exception
	And I close current window

Scenario: Opening the List form Catalogs "Multi currency movement sets" (CurrencyMovementSets)

	Given I open "CurrencyMovementSets" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs CurrencyMovementSets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs CurrencyMovementSets" exception
	And I close current window

Scenario: Opening the List form Catalogs "Data areas" (DataAreas)

	Given I open "DataAreas" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs DataAreas" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs DataAreas" exception
	And I close current window

Scenario: Opening the List form Catalogs "Data base status" (DataBaseStatus)

	Given I open "DataBaseStatus" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs DataBaseStatus" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs DataBaseStatus" exception
	And I close current window

Scenario: Opening the List form Catalogs "Depreciation schedules" (DepreciationSchedules)

	Given I open "DepreciationSchedules" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs DepreciationSchedules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs DepreciationSchedules" exception
	And I close current window

Scenario: Opening the List form Catalogs "Employee positions" (EmployeePositions)

	Given I open "EmployeePositions" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs EmployeePositions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs EmployeePositions" exception
	And I close current window

Scenario: Opening the List form Catalogs "Employee schedule" (EmployeeSchedule)

	Given I open "EmployeeSchedule" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs EmployeeSchedule" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs EmployeeSchedule" exception
	And I close current window

Scenario: Opening the List form Catalogs "Expense and revenue types" (ExpenseAndRevenueTypes)

	Given I open "ExpenseAndRevenueTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ExpenseAndRevenueTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ExpenseAndRevenueTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Extensions" (Extensions)

	Given I open "Extensions" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Extensions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Extensions" exception
	And I close current window

Scenario: Opening the List form Catalogs "Plugins" (ExternalDataProc)

	Given I open "ExternalDataProc" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ExternalDataProc" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ExternalDataProc" exception
	And I close current window

Scenario: Opening the List form Catalogs "External functions" (ExternalFunctions)

	Given I open "ExternalFunctions" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ExternalFunctions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ExternalFunctions" exception
	And I close current window

Scenario: Opening the List form Catalogs "Files" (Files)

	Given I open "Files" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Files" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Files" exception
	And I close current window

Scenario: Opening the List form Catalogs "File storages info" (FileStoragesInfo)

	Given I open "FileStoragesInfo" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs FileStoragesInfo" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs FileStoragesInfo" exception
	And I close current window

Scenario: Opening the List form Catalogs "File storage volumes" (FileStorageVolumes)

	Given I open "FileStorageVolumes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs FileStorageVolumes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs FileStorageVolumes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Filling templates" (FillingTemplates)

	Given I open "FillingTemplates" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs FillingTemplates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs FillingTemplates" exception
	And I close current window

Scenario: Opening the List form Catalogs "Fixed assets" (FixedAssets)

	Given I open "FixedAssets" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs FixedAssets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs FixedAssets" exception
	And I close current window

Scenario: Opening the List form Catalogs "Fixed assets ledger types" (FixedAssetsLedgerTypes)

	Given I open "FixedAssetsLedgerTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs FixedAssetsLedgerTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Hardware" (Hardware)

	Given I open "Hardware" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Hardware" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Hardware" exception
	And I close current window

Scenario: Opening the List form Catalogs "Addresses hierarchy" (IDInfoAddresses)

	Given I open "IDInfoAddresses" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs IDInfoAddresses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs IDInfoAddresses" exception
	And I close current window

Scenario: Opening the List form Catalogs "Contact info sets" (IDInfoSets)

	Given I open "IDInfoSets" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs IDInfoSets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs IDInfoSets" exception
	And I close current window

Scenario: Opening the List form Catalogs "Incoterms" (Incoterms)

	Given I open "Incoterms" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Incoterms" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Incoterms" exception
	And I close current window

Scenario: Opening the List form Catalogs "Integration settings" (IntegrationSettings)

	Given I open "IntegrationSettings" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs IntegrationSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs IntegrationSettings" exception
	And I close current window

Scenario: Opening the List form Catalogs "UI groups" (InterfaceGroups)

	Given I open "InterfaceGroups" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs InterfaceGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs InterfaceGroups" exception
	And I close current window

Scenario: Opening the List form Catalogs "Item keys" (ItemKeys)

	Given I open "ItemKeys" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ItemKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ItemKeys" exception
	And I close current window

Scenario: Opening the List form Catalogs "Items" (Items)

	Given I open "Items" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Items" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Items" exception
	And I close current window

Scenario: Opening the List form Catalogs "Item segments" (ItemSegments)

	Given I open "ItemSegments" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ItemSegments" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ItemSegments" exception
	And I close current window

Scenario: Opening the List form Catalogs "Item types" (ItemTypes)

	Given I open "ItemTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ItemTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ItemTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Ledger types" (LedgerTypes)

	Given I open "LedgerTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs LedgerTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs LedgerTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Ledger type variants" (LedgerTypeVariants)

	Given I open "LedgerTypeVariants" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs LedgerTypeVariants" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs LedgerTypeVariants" exception
	And I close current window

Scenario: Opening the List form Catalogs "Legal name contracts" (LegalNameContracts)

	Given I open "LegalNameContracts" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs LegalNameContracts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs LegalNameContracts" exception
	And I close current window

Scenario: Opening the List form Catalogs "Lock data modification reasons" (LockDataModificationReasons)

	Given I open "LockDataModificationReasons" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs LockDataModificationReasons" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs LockDataModificationReasons" exception
	And I close current window

Scenario: Opening the List form Catalogs "Objects statuses" (ObjectStatuses)

	Given I open "ObjectStatuses" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ObjectStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ObjectStatuses" exception
	And I close current window

Scenario: Opening the List form Catalogs "Partner items" (PartnerItems)

	Given I open "PartnerItems" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PartnerItems" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PartnerItems" exception
	And I close current window

Scenario: Opening the List form Catalogs "Partners" (Partners)

	Given I open "Partners" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Partners" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Partners" exception
	And I close current window

Scenario: Opening the List form Catalogs "Partners bank accounts" (PartnersBankAccounts)

	Given I open "PartnersBankAccounts" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PartnersBankAccounts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PartnersBankAccounts" exception
	And I close current window

Scenario: Opening the List form Catalogs "Partner segments" (PartnerSegments)

	Given I open "PartnerSegments" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PartnerSegments" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PartnerSegments" exception
	And I close current window

Scenario: Opening the List form Catalogs "Payment terms" (PaymentSchedules)

	Given I open "PaymentSchedules" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PaymentSchedules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PaymentSchedules" exception
	And I close current window

Scenario: Opening the List form Catalogs "Payment terminals" (PaymentTerminals)

	Given I open "PaymentTerminals" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PaymentTerminals" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PaymentTerminals" exception
	And I close current window

Scenario: Opening the List form Catalogs "Payment types" (PaymentTypes)

	Given I open "PaymentTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PaymentTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PaymentTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Planning periods" (PlanningPeriods)

	Given I open "PlanningPeriods" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PlanningPeriods" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PlanningPeriods" exception
	And I close current window

Scenario: Opening the List form Catalogs "Price keys" (PriceKeys)

	Given I open "PriceKeys" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PriceKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PriceKeys" exception
	And I close current window

Scenario: Opening the List form Catalogs "Price types" (PriceTypes)

	Given I open "PriceTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PriceTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PriceTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Print info" (PrintInfo)

	Given I open "PrintInfo" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PrintInfo" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PrintInfo" exception
	And I close current window

Scenario: Opening the List form Catalogs "Print templates" (PrintTemplates)

	Given I open "PrintTemplates" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs PrintTemplates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs PrintTemplates" exception
	And I close current window

Scenario: Opening the List form Catalogs "Projects" (Projects)

	Given I open "Projects" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Projects" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Projects" exception
	And I close current window

Scenario: Opening the List form Catalogs "Row IDs" (RowIDs)

	Given I open "RowIDs" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs RowIDs" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs RowIDs" exception
	And I close current window

Scenario: Opening the List form Catalogs "Salary calculation type" (SalaryCalculationType)

	Given I open "SalaryCalculationType" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SalaryCalculationType" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SalaryCalculationType" exception
	And I close current window

Scenario: Opening the List form Catalogs "Item serial/lot numbers" (SerialLotNumbers)

	Given I open "SerialLotNumbers" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SerialLotNumbers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SerialLotNumbers" exception
	And I close current window

Scenario: Opening the List form Catalogs "Source of origins" (SourceOfOrigins)

	Given I open "SourceOfOrigins" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SourceOfOrigins" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SourceOfOrigins" exception
	And I close current window

Scenario: Opening the List form Catalogs "Special offer rules" (SpecialOfferRules)

	Given I open "SpecialOfferRules" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SpecialOfferRules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SpecialOfferRules" exception
	And I close current window

Scenario: Opening the List form Catalogs "Special offers" (SpecialOffers)

	Given I open "SpecialOffers" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SpecialOffers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SpecialOffers" exception
	And I close current window

Scenario: Opening the List form Catalogs "Special offer types" (SpecialOfferTypes)

	Given I open "SpecialOfferTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs SpecialOfferTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs SpecialOfferTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Specifications" (Specifications)

	Given I open "Specifications" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Specifications" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Specifications" exception
	And I close current window

Scenario: Opening the List form Catalogs "Stores" (Stores)

	Given I open "Stores" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Stores" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Stores" exception
	And I close current window

Scenario: Opening the List form Catalogs "Tax additional analytics" (TaxAnalytics)

	Given I open "TaxAnalytics" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs TaxAnalytics" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs TaxAnalytics" exception
	And I close current window

Scenario: Opening the List form Catalogs "Tax types" (Taxes)

	Given I open "Taxes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Taxes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Taxes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Tax rates" (TaxRates)

	Given I open "TaxRates" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs TaxRates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs TaxRates" exception
	And I close current window

Scenario: Opening the List form Catalogs "Item units" (Units)

	Given I open "Units" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Units" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Units" exception
	And I close current window

Scenario: Opening the List form Catalogs "Units of measurement" (UnitsOfMeasurement)

	Given I open "UnitsOfMeasurement" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs UnitsOfMeasurement" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs UnitsOfMeasurement" exception
	And I close current window

Scenario: Opening the List form Catalogs "User groups" (UserGroups)

	Given I open "UserGroups" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs UserGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs UserGroups" exception
	And I close current window

Scenario: Opening the List form Catalogs "Users" (Users)

	Given I open "Users" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Users" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Users" exception
	And I close current window


Scenario: Opening the List form Catalogs "Vehicle types" (VehicleTypes)

	Given I open "VehicleTypes" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs VehicleTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs VehicleTypes" exception
	And I close current window

Scenario: Opening the List form Catalogs "Workstations" (Workstations)

	Given I open "Workstations" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Workstations" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Workstations" exception
	And I close current window

Scenario: Opening the List form Catalogs "Incoming messages (IAS)" (гкс_ВходящиеСообщенияRMQ)

	Given I open "гкс_ВходящиеСообщенияRMQ" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs гкс_ВходящиеСообщенияRMQ" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs гкс_ВходящиеСообщенияRMQ" exception
	And I close current window

Scenario: Opening the List form Catalogs "Queue for deferred formation of outgoing messages (IAS)" (гкс_ОчередьОтложенногоФормированияИсходящихСообщений)

	Given I open "гкс_ОчередьОтложенногоФормированияИсходящихСообщений" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs гкс_ОчередьОтложенногоФормированияИсходящихСообщений" exception
	And I close current window

Scenario: Opening the List form Catalogs "Exchange participants (IAS)" (гкс_УчастникиОбменаRMQ)

	Given I open "гкс_УчастникиОбменаRMQ" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs гкс_УчастникиОбменаRMQ" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs гкс_УчастникиОбменаRMQ" exception
	And I close current window

Scenario: Opening the List form Catalogs "Exchange message formats (IAS)" (гкс_ФорматыОбменаИАС)

	Given I open "гкс_ФорматыОбменаИАС" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs гкс_ФорматыОбменаИАС" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs гкс_ФорматыОбменаИАС" exception
	And I close current window

Scenario: Opening the List form Catalogs "Message sending tasks (IAS)" (ЗаданияОтправкиИсходящихСообщений)

	Given I open "ЗаданияОтправкиИсходящихСообщений" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ЗаданияОтправкиИсходящихСообщений" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ЗаданияОтправкиИсходящихСообщений" exception
	And I close current window

Scenario: Opening the List form Catalogs "Outgoing messages (IAS)" (ИсходящиеСообщения)

	Given I open "ИсходящиеСообщения" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ИсходящиеСообщения" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ИсходящиеСообщения" exception
	And I close current window

Scenario: Opening the List form Catalogs "RMQ event handlers (IAS)" (ОбработчикиСобытийRMQ)

	Given I open "ОбработчикиСобытийRMQ" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ОбработчикиСобытийRMQ" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ОбработчикиСобытийRMQ" exception
	And I close current window

Scenario: Opening the List form Catalogs "Subscriptions to message queues (IAS)" (ПодпискиНаОчередиСообщений)

	Given I open "ПодпискиНаОчередиСообщений" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs ПодпискиНаОчередиСообщений" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs ПодпискиНаОчередиСообщений" exception
	And I close current window

Scenario: Opening the List form Catalogs "Service exchange history" (Unit_ServiceExchangeHistory)

	Given I open "Unit_ServiceExchangeHistory" catalog default form
	If the warning is displayed then
		Then I raise "The list form could not be opened Catalogs Unit_ServiceExchangeHistory" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Catalogs Unit_ServiceExchangeHistory" exception
	And I close current window
