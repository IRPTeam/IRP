
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening form Catalogs "User access groups" (AccessGroups)

	Given I open "AccessGroups" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AccessGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AccessGroups" exception
	And I close current window

Scenario: Opening form Catalogs "Access key" (AccessKey)

	Given I open "AccessKey" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AccessKey" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AccessKey" exception
	And I close current window

Scenario: Opening form Catalogs "User access profiles" (AccessProfiles)

	Given I open "AccessProfiles" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AccessProfiles" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AccessProfiles" exception
	And I close current window

Scenario: Opening form Catalogs "Accounting operations" (AccountingOperations)

	Given I open "AccountingOperations" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AccountingOperations" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AccountingOperations" exception
	And I close current window

Scenario: Opening form Catalogs "Accrual and deduction types" (AccrualAndDeductionTypes)

	Given I open "AccrualAndDeductionTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AccrualAndDeductionTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Additional attribute sets" (AddAttributeAndPropertySets)

	Given I open "AddAttributeAndPropertySets" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AddAttributeAndPropertySets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AddAttributeAndPropertySets" exception
	And I close current window

Scenario: Opening form Catalogs "Additional attribute values" (AddAttributeAndPropertyValues)

	Given I open "AddAttributeAndPropertyValues" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AddAttributeAndPropertyValues" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AddAttributeAndPropertyValues" exception
	And I close current window

Scenario: Opening form Catalogs "Addresses" (Addresses)

	Given I open "Addresses" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Addresses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Addresses" exception
	And I close current window


Scenario: Opening form Catalogs "Aging periods" (AgingPeriods)

	Given I open "AgingPeriods" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AgingPeriods" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AgingPeriods" exception
	And I close current window

Scenario: Opening form Catalogs "Partner terms" (Agreements)

	Given I open "Agreements" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Agreements" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Agreements" exception
	And I close current window

Scenario: Opening form Catalogs "Attached document settings" (AttachedDocumentSettings)

	Given I open "AttachedDocumentSettings" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs AttachedDocumentSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs AttachedDocumentSettings" exception
	And I close current window

Scenario: Opening form Catalogs "Bank terms" (BankTerms)

	Given I open "BankTerms" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs BankTerms" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs BankTerms" exception
	And I close current window

Scenario: Opening form Catalogs "Batches" (Batches)

	Given I open "Batches" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Batches" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Batches" exception
	And I close current window

Scenario: Opening form Catalogs "Batch keys" (BatchKeys)

	Given I open "BatchKeys" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs BatchKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs BatchKeys" exception
	And I close current window

Scenario: Opening form Catalogs "Bill of materials" (BillOfMaterials)

	Given I open "BillOfMaterials" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs BillOfMaterials" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs BillOfMaterials" exception
	And I close current window

Scenario: Opening form Catalogs "Business units" (BusinessUnits)

	Given I open "BusinessUnits" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs BusinessUnits" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs BusinessUnits" exception
	And I close current window

Scenario: Opening form Catalogs "Cancel/Return reasons" (CancelReturnReasons)

	Given I open "CancelReturnReasons" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs CancelReturnReasons" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs CancelReturnReasons" exception
	And I close current window

Scenario: Opening form Catalogs "Cash/Bank accounts" (CashAccounts)

	Given I open "CashAccounts" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs CashAccounts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs CashAccounts" exception
	And I close current window

Scenario: Opening form Catalogs "Cash statement statuses" (CashStatementStatuses)

	Given I open "CashStatementStatuses" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs CashStatementStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs CashStatementStatuses" exception
	And I close current window

Scenario: Opening form Catalogs "Cheque bonds" (ChequeBonds)

	Given I open "ChequeBonds" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ChequeBonds" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ChequeBonds" exception
	And I close current window

Scenario: Opening form Catalogs "Companies" (Companies)

	Given I open "Companies" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Companies" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Companies" exception
	And I close current window

Scenario: Opening form Catalogs "Configuration metadata" (ConfigurationMetadata)

	Given I open "ConfigurationMetadata" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ConfigurationMetadata" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ConfigurationMetadata" exception
	And I close current window

Scenario: Opening form Catalogs "Countries" (Countries)

	Given I open "Countries" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Countries" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Countries" exception
	And I close current window

Scenario: Opening form Catalogs "Currencies" (Currencies)

	Given I open "Currencies" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Currencies" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Currencies" exception
	And I close current window

Scenario: Opening form Catalogs "Multi currency movement sets" (CurrencyMovementSets)

	Given I open "CurrencyMovementSets" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs CurrencyMovementSets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs CurrencyMovementSets" exception
	And I close current window

Scenario: Opening form Catalogs "Data areas" (DataAreas)

	Given I open "DataAreas" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs DataAreas" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs DataAreas" exception
	And I close current window

Scenario: Opening form Catalogs "Data base status" (DataBaseStatus)

	Given I open "DataBaseStatus" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs DataBaseStatus" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs DataBaseStatus" exception
	And I close current window

Scenario: Opening form Catalogs "Data mapping items" (DataMappingItems)

	Given I open "DataMappingItems" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs DataMappingItems" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs DataMappingItems" exception
	And I close current window

Scenario: Opening form Catalogs "Depreciation schedules" (DepreciationSchedules)

	Given I open "DepreciationSchedules" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs DepreciationSchedules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs DepreciationSchedules" exception
	And I close current window

Scenario: Opening form Catalogs "Employee positions" (EmployeePositions)

	Given I open "EmployeePositions" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs EmployeePositions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs EmployeePositions" exception
	And I close current window

Scenario: Opening form Catalogs "Employee schedule" (EmployeeSchedule)

	Given I open "EmployeeSchedule" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs EmployeeSchedule" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs EmployeeSchedule" exception
	And I close current window

Scenario: Opening form Catalogs "Equipment drivers" (EquipmentDrivers)

	Given I open "EquipmentDrivers" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs EquipmentDrivers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs EquipmentDrivers" exception
	And I close current window

Scenario: Opening form Catalogs "Expense and revenue types" (ExpenseAndRevenueTypes)

	Given I open "ExpenseAndRevenueTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ExpenseAndRevenueTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ExpenseAndRevenueTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Extensions" (Extensions)

	Given I open "Extensions" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Extensions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Extensions" exception
	And I close current window

Scenario: Opening form Catalogs "Plugins" (ExternalDataProc)

	Given I open "ExternalDataProc" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ExternalDataProc" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ExternalDataProc" exception
	And I close current window

Scenario: Opening form Catalogs "External functions" (ExternalFunctions)

	Given I open "ExternalFunctions" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ExternalFunctions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ExternalFunctions" exception
	And I close current window

Scenario: Opening form Catalogs "Files" (Files)

	Given I open "Files" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Files" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Files" exception
	And I close current window

Scenario: Opening form Catalogs "File storages info" (FileStoragesInfo)

	Given I open "FileStoragesInfo" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs FileStoragesInfo" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs FileStoragesInfo" exception
	And I close current window

Scenario: Opening form Catalogs "File storage volumes" (FileStorageVolumes)

	Given I open "FileStorageVolumes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs FileStorageVolumes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs FileStorageVolumes" exception
	And I close current window

Scenario: Opening form Catalogs "Filling templates" (FillingTemplates)

	Given I open "FillingTemplates" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs FillingTemplates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs FillingTemplates" exception
	And I close current window

Scenario: Opening form Catalogs "Fixed assets" (FixedAssets)

	Given I open "FixedAssets" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs FixedAssets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs FixedAssets" exception
	And I close current window

Scenario: Opening form Catalogs "Fixed assets ledger types" (FixedAssetsLedgerTypes)

	Given I open "FixedAssetsLedgerTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs FixedAssetsLedgerTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Hardware" (Hardware)

	Given I open "Hardware" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Hardware" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Hardware" exception
	And I close current window

Scenario: Opening form Catalogs "Addresses hierarchy" (IDInfoAddresses)

	Given I open "IDInfoAddresses" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs IDInfoAddresses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs IDInfoAddresses" exception
	And I close current window

Scenario: Opening form Catalogs "Contact info sets" (IDInfoSets)

	Given I open "IDInfoSets" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs IDInfoSets" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs IDInfoSets" exception
	And I close current window

Scenario: Opening form Catalogs "Incoterms" (Incoterms)

	Given I open "Incoterms" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Incoterms" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Incoterms" exception
	And I close current window

Scenario: Opening form Catalogs "Integration settings" (IntegrationSettings)

	Given I open "IntegrationSettings" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs IntegrationSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs IntegrationSettings" exception
	And I close current window

Scenario: Opening form Catalogs "UI groups" (InterfaceGroups)

	Given I open "InterfaceGroups" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs InterfaceGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs InterfaceGroups" exception
	And I close current window

Scenario: Opening form Catalogs "Item keys" (ItemKeys)

	Given I open "ItemKeys" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ItemKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ItemKeys" exception
	And I close current window

Scenario: Opening form Catalogs "Items" (Items)

	Given I open "Items" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Items" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Items" exception
	And I close current window

Scenario: Opening form Catalogs "Item segments" (ItemSegments)

	Given I open "ItemSegments" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ItemSegments" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ItemSegments" exception
	And I close current window

Scenario: Opening form Catalogs "Item types" (ItemTypes)

	Given I open "ItemTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ItemTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ItemTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Ledger types" (LedgerTypes)

	Given I open "LedgerTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs LedgerTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs LedgerTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Ledger type variants" (LedgerTypeVariants)

	Given I open "LedgerTypeVariants" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs LedgerTypeVariants" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs LedgerTypeVariants" exception
	And I close current window

Scenario: Opening form Catalogs "Legal name contracts" (LegalNameContracts)

	Given I open "LegalNameContracts" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs LegalNameContracts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs LegalNameContracts" exception
	And I close current window

Scenario: Opening form Catalogs "Lock data modification reasons" (LockDataModificationReasons)

	Given I open "LockDataModificationReasons" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs LockDataModificationReasons" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs LockDataModificationReasons" exception
	And I close current window

Scenario: Opening form Catalogs "Objects statuses" (ObjectStatuses)

	Given I open "ObjectStatuses" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ObjectStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ObjectStatuses" exception
	And I close current window

Scenario: Opening form Catalogs "Partner items" (PartnerItems)

	Given I open "PartnerItems" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PartnerItems" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PartnerItems" exception
	And I close current window

Scenario: Opening form Catalogs "Partners" (Partners)

	Given I open "Partners" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Partners" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Partners" exception
	And I close current window

Scenario: Opening form Catalogs "Partners bank accounts" (PartnersBankAccounts)

	Given I open "PartnersBankAccounts" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PartnersBankAccounts" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PartnersBankAccounts" exception
	And I close current window

Scenario: Opening form Catalogs "Partner segments" (PartnerSegments)

	Given I open "PartnerSegments" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PartnerSegments" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PartnerSegments" exception
	And I close current window

Scenario: Opening form Catalogs "Payment terms" (PaymentSchedules)

	Given I open "PaymentSchedules" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PaymentSchedules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PaymentSchedules" exception
	And I close current window

Scenario: Opening form Catalogs "Payment terminals" (PaymentTerminals)

	Given I open "PaymentTerminals" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PaymentTerminals" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PaymentTerminals" exception
	And I close current window

Scenario: Opening form Catalogs "Payment types" (PaymentTypes)

	Given I open "PaymentTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PaymentTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PaymentTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Planning periods" (PlanningPeriods)

	Given I open "PlanningPeriods" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PlanningPeriods" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PlanningPeriods" exception
	And I close current window

Scenario: Opening form Catalogs "Price keys" (PriceKeys)

	Given I open "PriceKeys" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PriceKeys" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PriceKeys" exception
	And I close current window

Scenario: Opening form Catalogs "Price types" (PriceTypes)

	Given I open "PriceTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PriceTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PriceTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Print info" (PrintInfo)

	Given I open "PrintInfo" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PrintInfo" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PrintInfo" exception
	And I close current window

Scenario: Opening form Catalogs "Print templates" (PrintTemplates)

	Given I open "PrintTemplates" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs PrintTemplates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs PrintTemplates" exception
	And I close current window

Scenario: Opening form Catalogs "Projects" (Projects)

	Given I open "Projects" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Projects" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Projects" exception
	And I close current window

Scenario: Opening form Catalogs "Report options" (ReportOptions)

	Given I open "ReportOptions" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs ReportOptions" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs ReportOptions" exception
	And I close current window

Scenario: Opening form Catalogs "Retail customers" (RetailCustomers)

	Given I open "RetailCustomers" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs RetailCustomers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs RetailCustomers" exception
	And I close current window

Scenario: Opening form Catalogs "Row IDs" (RowIDs)

	Given I open "RowIDs" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs RowIDs" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs RowIDs" exception
	And I close current window

Scenario: Opening form Catalogs "Salary calculation type" (SalaryCalculationType)

	Given I open "SalaryCalculationType" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SalaryCalculationType" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SalaryCalculationType" exception
	And I close current window

Scenario: Opening form Catalogs "Item serial/lot numbers" (SerialLotNumbers)

	Given I open "SerialLotNumbers" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SerialLotNumbers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SerialLotNumbers" exception
	And I close current window

Scenario: Opening form Catalogs "Source of origins" (SourceOfOrigins)

	Given I open "SourceOfOrigins" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SourceOfOrigins" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SourceOfOrigins" exception
	And I close current window

Scenario: Opening form Catalogs "Special offer rules" (SpecialOfferRules)

	Given I open "SpecialOfferRules" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SpecialOfferRules" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SpecialOfferRules" exception
	And I close current window

Scenario: Opening form Catalogs "Special offers" (SpecialOffers)

	Given I open "SpecialOffers" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SpecialOffers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SpecialOffers" exception
	And I close current window

Scenario: Opening form Catalogs "Special offer types" (SpecialOfferTypes)

	Given I open "SpecialOfferTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs SpecialOfferTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs SpecialOfferTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Specifications" (Specifications)

	Given I open "Specifications" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Specifications" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Specifications" exception
	And I close current window

Scenario: Opening form Catalogs "Stores" (Stores)

	Given I open "Stores" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Stores" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Stores" exception
	And I close current window

Scenario: Opening form Catalogs "Tax additional analytics" (TaxAnalytics)

	Given I open "TaxAnalytics" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs TaxAnalytics" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs TaxAnalytics" exception
	And I close current window

Scenario: Opening form Catalogs "Tax types" (Taxes)

	Given I open "Taxes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Taxes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Taxes" exception
	And I close current window

Scenario: Opening form Catalogs "Tax rates" (TaxRates)

	Given I open "TaxRates" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs TaxRates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs TaxRates" exception
	And I close current window


Scenario: Opening form Catalogs "Item units" (Units)

	Given I open "Units" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Units" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Units" exception
	And I close current window

Scenario: Opening form Catalogs "Units of measurement" (UnitsOfMeasurement)

	Given I open "UnitsOfMeasurement" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs UnitsOfMeasurement" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs UnitsOfMeasurement" exception
	And I close current window

Scenario: Opening form Catalogs "User groups" (UserGroups)

	Given I open "UserGroups" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs UserGroups" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs UserGroups" exception
	And I close current window

Scenario: Opening form Catalogs "Users" (Users)

	Given I open "Users" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Users" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Users" exception
	And I close current window


Scenario: Opening form Catalogs "Vehicles" (Vehicles)

	Given I open "Vehicles" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Vehicles" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Vehicles" exception
	And I close current window

Scenario: Opening form Catalogs "Vehicle types" (VehicleTypes)

	Given I open "VehicleTypes" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs VehicleTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs VehicleTypes" exception
	And I close current window

Scenario: Opening form Catalogs "Workstations" (Workstations)

	Given I open "Workstations" reference main form
	If the warning is displayed then
		Then I raise "The main form could not be opened Catalogs Workstations" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Catalogs Workstations" exception
	And I close current window