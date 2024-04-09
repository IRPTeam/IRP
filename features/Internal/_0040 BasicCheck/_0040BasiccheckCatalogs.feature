#language: en
@tree
@Positive
@BasicFormsCheck

Feature: basic check catalogs

As an QA
I want to check opening and closing of catalogs forms

Background:
	Given I launch TestClient opening script or connect the existing one
	

Scenario: preparation
	When set True value to the constant
	When set True value to the constant use Salary
	When set True value to the constant use Fixed assets
	* Add VA extension
		Given I open hyperlink "e1cib/list/Catalog.Extensions"
		If "List" table does not contain lines Then
				| "Description"     |
				| "VAExtension"     |
			When add VAExtension

	
Scenario: Open list form "AccessGroups" 

	Given I open "AccessGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessGroups" exception
	And I close current window

Scenario: Open object form "AccessGroups"
	And I close all client application windows
	Given I open "AccessGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessGroups" exception
	And I close current window

	
Scenario: Open list form "AccessProfiles" 
	And I close all client application windows
	Given I open "AccessProfiles" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessProfiles" exception
	And I close current window

Scenario: Open object form "AccessProfiles"
	And I close all client application windows
	Given I open "AccessProfiles" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccessProfiles" exception
	And I close current window


	
Scenario: Open list form "AddAttributeAndPropertySets" 
	And I close all client application windows
	Given I open "AddAttributeAndPropertySets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertySets" exception
	And I close current window

Scenario: Open object form "AddAttributeAndPropertySets"
	And I close all client application windows
	Given I open "AddAttributeAndPropertySets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertySets" exception
	And I close current window

	
Scenario: Open list form "AddAttributeAndPropertyValues" 
	And I close all client application windows
	Given I open "AddAttributeAndPropertyValues" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
	And I close current window

Scenario: Open object form "AddAttributeAndPropertyValues"
	And I close all client application windows
	Given I open "AddAttributeAndPropertyValues" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AddAttributeAndPropertyValues" exception
	And I close current window


Scenario: Open list form "Partner terms" 
	And I close all client application windows
	Given I open "Agreements" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partner terms" exception
	And I close current window

Scenario: Open object form "Partner terms"
	And I close all client application windows
	Given I open "Agreements" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partner terms" exception
	And I close current window



	
Scenario: Open list form "BusinessUnits" 
	And I close all client application windows
	Given I open "BusinessUnits" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BusinessUnits" exception
	And I close current window

Scenario: Open object form "BusinessUnits"
	And I close all client application windows
	Given I open "BusinessUnits" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BusinessUnits" exception
	And I close current window

Scenario: Open list form "LegalNameContracts" 
	And I close all client application windows
	Given I open "LegalNameContracts" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form LegalNameContracts" exception
	And I close current window

Scenario: Open object form "LegalNameContracts"
	And I close all client application windows
	Given I open "LegalNameContracts" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form LegalNameContracts" exception
	And I close current window


	
Scenario: Open list form "CashAccounts" 
	And I close all client application windows
	Given I open "CashAccounts" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CashAccounts" exception
	And I close current window

Scenario: Open object form "CashAccounts"
	And I close all client application windows
	Given I open "CashAccounts" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CashAccounts" exception
	And I close current window




	
Scenario: Open list form "Companies" 
	And I close all client application windows
	Given I open "Companies" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Companies" exception
	And I close current window

Scenario: Open object form "Companies"
	And I close all client application windows
	Given I open "Companies" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Companies" exception
	And I close current window

	
Scenario: Open list form "PlanningPeriods" 
	And I close all client application windows
	Given I open "PlanningPeriods" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PlanningPeriods" exception
	And I close current window

Scenario: Open object form "PlanningPeriods"
	And I close all client application windows
	Given I open "PlanningPeriods" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PlanningPeriods" exception
	And I close current window


	
Scenario: Open list form "ConfigurationMetadata" 
	And I close all client application windows
	Given I open "ConfigurationMetadata" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ConfigurationMetadata" exception
	And I close current window

Scenario: Open object form "ConfigurationMetadata"
	And I close all client application windows
	Given I open "ConfigurationMetadata" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ConfigurationMetadata" exception
	And I close current window

	
Scenario: Open list form "Countries" 
	And I close all client application windows
	Given I open "Countries" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Countries" exception
	And I close current window

Scenario: Open object form "Countries"
	And I close all client application windows
	Given I open "Countries" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Countries" exception
	And I close current window

Scenario: Open list form "Currencies" 
	And I close all client application windows
	Given I open "Currencies" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Currencies" exception
	And I close current window

Scenario: Open object form "Currencies"
	And I close all client application windows
	Given I open "Currencies" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Currencies" exception
	And I close current window

	
Scenario: Open list form "ExpenseAndRevenueTypes" 
	And I close all client application windows
	Given I open "ExpenseAndRevenueTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExpenseAndRevenueTypes" exception
	And I close current window

Scenario: Open object form "ExpenseAndRevenueTypes"
	And I close all client application windows
	Given I open "ExpenseAndRevenueTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExpenseAndRevenueTypes" exception
	And I close current window

	
Scenario: Open list form "ExternalDataProc" 
	And I close all client application windows
	Given I open "ExternalDataProc" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExternalDataProc" exception
	And I close current window

Scenario: Open object form "ExternalDataProc"
	And I close all client application windows
	Given I open "ExternalDataProc" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ExternalDataProc" exception
	And I close current window


	
Scenario: Open list form "Files" 
	And I close all client application windows
	Given I open "Files" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Files" exception
	And I close current window

Scenario: Open object form "Files"
	And I close all client application windows
	Given I open "Files" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Files" exception
	And I close current window


Scenario: Open list form "FileStoragesInfo" 
	And I close all client application windows
	Given I open "FileStoragesInfo" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStoragesInfo" exception
	And I close current window

Scenario: Open object form "FileStoragesInfo"
	And I close all client application windows
	Given I open "FileStoragesInfo" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStoragesInfo" exception
	And I close current window

Scenario: Open list form "FileStorageVolumes" 
	And I close all client application windows
	Given I open "FileStorageVolumes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStorageVolumes" exception
	And I close current window

Scenario: Open object form "FileStorageVolumes"
	And I close all client application windows
	Given I open "FileStorageVolumes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FileStorageVolumes" exception
	And I close current window




	
	
Scenario: Open list form "IDInfoAddresses" 
	And I close all client application windows
	Given I open "IDInfoAddresses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoAddresses" exception
	And I close current window

Scenario: Open object form "IDInfoAddresses"
	And I close all client application windows
	Given I open "IDInfoAddresses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoAddresses" exception
	And I close current window




	
	
Scenario: Open list form "IDInfoSets" 
	And I close all client application windows
	Given I open "IDInfoSets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoSets" exception
	And I close current window

Scenario: Open object form "IDInfoSets"
	And I close all client application windows
	Given I open "IDInfoSets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IDInfoSets" exception
	And I close current window




	
	
Scenario: Open list form "IntegrationSettings" 
	And I close all client application windows
	Given I open "IntegrationSettings" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IntegrationSettings" exception
	And I close current window

Scenario: Open object form "IntegrationSettings"
	And I close all client application windows
	Given I open "IntegrationSettings" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form IntegrationSettings" exception
	And I close current window




	
	
Scenario: Open list form "InterfaceGroups" 
	And I close all client application windows
	Given I open "InterfaceGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form InterfaceGroups" exception
	And I close current window

Scenario: Open object form "InterfaceGroups"
	And I close all client application windows
	Given I open "InterfaceGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form InterfaceGroups" exception
	And I close current window




	
	
Scenario: Open list form "ItemKeys" 
	And I close all client application windows
	Given I open "ItemKeys" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemKeys" exception
	And I close current window

Scenario: Open object form "ItemKeys"
	And I close all client application windows
	Given I open "ItemKeys" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemKeys" exception
	And I close current window




	
	
Scenario: Open list form "Items" 
	And I close all client application windows
	Given I open "Items" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Items" exception
	And I close current window

Scenario: Open object form "Items"
	And I close all client application windows
	Given I open "Items" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Items" exception
	And I close current window




	
	
Scenario: Open list form "ItemSegments" 
	And I close all client application windows
	Given I open "ItemSegments" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemSegments" exception
	And I close current window

Scenario: Open object form "ItemSegments"
	And I close all client application windows
	Given I open "ItemSegments" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemSegments" exception
	And I close current window




	
	
Scenario: Open list form "ItemTypes" 
	And I close all client application windows
	Given I open "ItemTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemTypes" exception
	And I close current window

Scenario: Open object form "ItemTypes"
	And I close all client application windows
	Given I open "ItemTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ItemTypes" exception
	And I close current window




	
	
Scenario: Open list form "PrintTemplates" 
	And I close all client application windows
	Given I open "PrintTemplates" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PrintTemplates" exception
	And I close current window

Scenario: Open object form "PrintTemplates"
	And I close all client application windows
	Given I open "PrintTemplates" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PrintTemplates" exception
	And I close current window




	
	
Scenario: Open list form "ObjectStatuses" 
	And I close all client application windows
	Given I open "ObjectStatuses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ObjectStatuses" exception
	And I close current window

Scenario: Open object form "ObjectStatuses"
	And I close all client application windows
	Given I open "ObjectStatuses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ObjectStatuses" exception
	And I close current window




	
	
Scenario: Open list form "Partners" 
	And I close all client application windows
	Given I open "Partners" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partners" exception
	And I close current window

Scenario: Open object form "Partners"
	And I close all client application windows
	Given I open "Partners" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Partners" exception
	And I close current window




	
	
Scenario: Open list form "PartnerSegments" 
	And I close all client application windows
	Given I open "PartnerSegments" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerSegments" exception
	And I close current window

Scenario: Open object form "PartnerSegments"
	And I close all client application windows
	Given I open "PartnerSegments" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerSegments" exception
	And I close current window




	
	
Scenario: Open list form "PaymentSchedules" 
	And I close all client application windows
	Given I open "PaymentSchedules" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentSchedules" exception
	And I close current window

Scenario: Open object form "PaymentSchedules"
	And I close all client application windows
	Given I open "PaymentSchedules" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentSchedules" exception
	And I close current window




	
	
Scenario: Open list form "PaymentTypes" 
	And I close all client application windows
	Given I open "PaymentTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentTypes" exception
	And I close current window

Scenario: Open object form "PaymentTypes"
	And I close all client application windows
	Given I open "PaymentTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PaymentTypes" exception
	And I close current window




	
	
Scenario: Open list form "PriceKeys" 
	And I close all client application windows
	Given I open "PriceKeys" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceKeys" exception
	And I close current window

Scenario: Open object form "PriceKeys"
	And I close all client application windows
	Given I open "PriceKeys" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceKeys" exception
	And I close current window




	
	
Scenario: Open list form "PriceTypes" 
	And I close all client application windows
	Given I open "PriceTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceTypes" exception
	And I close current window

Scenario: Open object form "PriceTypes"
	And I close all client application windows
	Given I open "PriceTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PriceTypes" exception
	And I close current window




	
	
Scenario: Open list form "SerialLotNumbers" 
	And I close all client application windows
	Given I open "SerialLotNumbers" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SerialLotNumbers" exception
	And I close current window

Scenario: Open object form "SerialLotNumbers"
	And I close all client application windows
	Given I open "SerialLotNumbers" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SerialLotNumbers" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOfferRules" 
	And I close all client application windows
	Given I open "SpecialOfferRules" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferRules" exception
	And I close current window

Scenario: Open object form "SpecialOfferRules"
	And I close all client application windows
	Given I open "SpecialOfferRules" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferRules" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOffers" 
	And I close all client application windows
	Given I open "SpecialOffers" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOffers" exception
	And I close current window

Scenario: Open object form "SpecialOffers"
	And I close all client application windows
	Given I open "SpecialOffers" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOffers" exception
	And I close current window




	
	
Scenario: Open list form "SpecialOfferTypes" 
	And I close all client application windows
	Given I open "SpecialOfferTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferTypes" exception
	And I close current window

Scenario: Open object form "SpecialOfferTypes"
	And I close all client application windows
	Given I open "SpecialOfferTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOfferTypes" exception
	And I close current window




	
	
Scenario: Open list form "Specifications" 
	And I close all client application windows
	Given I open "Specifications" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Specifications" exception
	And I close current window

Scenario: Open object form "Specifications"
	And I close all client application windows
	Given I open "Specifications" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Specifications" exception
	And I close current window




	
	
Scenario: Open list form "Stores" 
	And I close all client application windows
	Given I open "Stores" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Stores" exception
	And I close current window

Scenario: Open object form "Stores"
	And I close all client application windows
	Given I open "Stores" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Stores" exception
	And I close current window




	
	
Scenario: Open list form "TaxAnalytics" 
	And I close all client application windows
	Given I open "TaxAnalytics" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxAnalytics" exception
	And I close current window

Scenario: Open object form "TaxAnalytics"
	And I close all client application windows
	Given I open "TaxAnalytics" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxAnalytics" exception
	And I close current window




	
	
Scenario: Open list form "Tax types" 
	And I close all client application windows
	Given I open "Taxes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Taxes" exception
	And I close current window

Scenario: Open object form "Tax types"
	And I close all client application windows
	Given I open "Taxes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Taxes" exception
	And I close current window




	
	
Scenario: Open list form "TaxRates" 
	And I close all client application windows
	Given I open "TaxRates" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxRates" exception
	And I close current window

Scenario: Open object form "TaxRates"
	And I close all client application windows
	Given I open "TaxRates" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form TaxRates" exception
	And I close current window




	
	
Scenario: Open list form "Units" 
	And I close all client application windows
	Given I open "Units" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Units" exception
	And I close current window

Scenario: Open object form "Units"
	And I close all client application windows
	Given I open "Units" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Units" exception
	And I close current window




	
	
Scenario: Open list form "UserGroups" 
	And I close all client application windows
	Given I open "UserGroups" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form UserGroups" exception
	And I close current window

Scenario: Open object form "UserGroups"
	And I close all client application windows
	Given I open "UserGroups" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form UserGroups" exception
	And I close current window




	
	
Scenario: Open list form "Users" 
	And I close all client application windows
	Given I open "Users" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Users" exception
	And I close current window

Scenario: Open object form "Users"
	And I close all client application windows
	Given I open "Users" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Users" exception
	And I close current window




	
	
Scenario: Open list form "CurrencyMovementSets" 
	And I close all client application windows
	Given I open "CurrencyMovementSets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CurrencyMovementSets" exception
	And I close current window

Scenario: Open object form "CurrencyMovementSets"
	And I close all client application windows
	Given I open "CurrencyMovementSets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CurrencyMovementSets" exception
	And I close current window


	
Scenario: Open list form "Extensions" 
	And I close all client application windows
	Given I open "Extensions" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Extensions" exception
	And I close current window

Scenario: Open object form "Extensions"
	And I close all client application windows
	Given I open "Extensions" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Extensions" exception
	And I close current window


Scenario: Open list form "CashStatementStatuses" 
	And I close all client application windows
	Given I open "CashStatementStatuses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Cash Statement Statuses" exception
	And I close current window

Scenario: Open object form "CashStatementStatuses"
	And I close all client application windows
	Given I open "CashStatementStatuses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Cash Statement Statuses" exception
	And I close current window


Scenario: Open list form "EquipmentDrivers" 
	And I close all client application windows
	Given I open "EquipmentDrivers" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EquipmentDrivers" exception
	And I close current window

Scenario: Open object form "EquipmentDrivers"
	And I close all client application windows
	Given I open "EquipmentDrivers" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EquipmentDrivers" exception
	And I close current window


Scenario: Open list form "Hardware" 
	And I close all client application windows
	Given I open "Hardware" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Hardware" exception
	And I close current window

Scenario: Open object form "Hardware"
	And I close all client application windows
	Given I open "Hardware" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Hardware" exception
	And I close current window

Scenario: Open list form "Data base status" 
	And I close all client application windows
	Given I open "DataBaseStatus" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DataBaseStatus" exception
	And I close current window

Scenario: Open object form "DataBaseStatus"
	And I close all client application windows
	Given I open "DataBaseStatus" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DataBaseStatus" exception
	And I close current window

Scenario: Open list form "Data mapping items" 
	And I close all client application windows
	Given I open "DataMappingItems" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DataMappingItems" exception
	And I close current window

Scenario: Open object form "DataMappingItems"
	And I close all client application windows
	Given I open "DataMappingItems" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DataMappingItems" exception
	And I close current window

	
Scenario: Open list form "PartnersBankAccounts" 
	And I close all client application windows
	Given I open "PartnersBankAccounts" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnersBankAccounts" exception
	And I close current window

Scenario: Open object form "PartnersBankAccounts"
	And I close all client application windows
	Given I open "PartnersBankAccounts" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnersBankAccounts" exception
	And I close current window


Scenario: Open list form "CancelReturnReasons (Catalogs)" 
	And I close all client application windows
	Given I open "CancelReturnReasons" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CancelReturnReasons" exception
	And I close current window

Scenario: Open object form "CancelReturnReasons"
	And I close all client application windows
	Given I open "CancelReturnReasons" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form CancelReturnReasons" exception
	And I close current window

Scenario: Open list form "PartnerItems" 

	Given I open "PartnerItems" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerItems" exception
	And I close current window

Scenario: Open object form "PartnerItems"
	And I close all client application windows
	Given I open "PartnerItems" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form PartnerItems" exception
	And I close current window

Scenario: Open list form "BillOfMaterials" 

	Given I open "BillOfMaterials" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BillOfMaterials" exception
	And I close current window

Scenario: Open object form "BillOfMaterials"
	And I close all client application windows
	Given I open "BillOfMaterials" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form BillOfMaterials" exception
	And I close current window

Scenario: Open list form "AccrualAndDeductionTypes" 

	Given I open "AccrualAndDeductionTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open object form "AccrualAndDeductionTypes"
	And I close all client application windows
	Given I open "AccrualAndDeductionTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open list form "EmployeePositions" 

	Given I open "EmployeePositions" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
	And I close current window

Scenario: Open object form "EmployeePositions"
	And I close all client application windows
	Given I open "EmployeePositions" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
	And I close current window

Scenario: Open choise form "EmployeePositions"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeePositions.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
	And I close current window

Scenario: Open list form "EmployeeSchedule" 

	Given I open "EmployeeSchedule" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeeSchedule" exception
	And I close current window

Scenario: Open object form "EmployeeSchedule"
	And I close all client application windows
	Given I open "EmployeeSchedule" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeeSchedule" exception
	And I close current window

Scenario: Open choise form "EmployeeSchedule"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeeSchedule.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeeSchedule" exception
	And I close current window

Scenario: Open choise form "AccrualAndDeductionTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.AccrualAndDeductionTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open choise form "BillOfMaterials"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.BillOfMaterials.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form BillOfMaterials" exception
	And I close current window

Scenario: Open choise form "SpecialOffers"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.SpecialOffers.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form SpecialOffers" exception
	And I close current window

Scenario: Open choise form "AddAttributeAndPropertySets"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.AddAttributeAndPropertySets.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form AddAttributeAndPropertySets" exception
	And I close current window

Scenario: Open choise form "IdInfoSets"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.IdInfoSets.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form IdInfoSets" exception
	And I close current window

Scenario: Open choise form "ObjectStatuses"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.ObjectStatuses.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form ObjectStatuses" exception
	And I close current window

Scenario: Open choise form "ItemTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.ItemTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form ItemTypes" exception
	And I close current window

Scenario: Open choise form "TaxAnalytics"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.TaxAnalytics.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form TaxAnalytics" exception
	And I close current window

Scenario: Open choise form "WorkStations"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.WorkStations.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form WorkStations" exception
	And I close current window

Scenario: Open choise form "Currencies"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Currencies.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Currencies" exception
	And I close current window

Scenario: Open choise form "CurrencyMovementSets"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.CurrencyMovementSets.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form CurrencyMovementSets" exception
	And I close current window

Scenario: Open choise form "UnitsOfMeasurement"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.UnitsOfMeasurement.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form UnitsOfMeasurement" exception
	And I close current window

Scenario: Open choise form "AccountingOperations"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.AccountingOperations.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form AccountingOperations" exception
	And I close current window

Scenario: Open choise form "LedgerTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.LedgerTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form LedgerTypes" exception
	And I close current window

Scenario: Open choise form "IdInfoAddresses"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.IdInfoAddresses.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form IdInfoAddresses" exception
	And I close current window

Scenario: Open list form "ChequeBonds" 
	And I close all client application windows
	Given I open "ChequeBonds" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ChequeBonds" exception
	And I close current window

Scenario: Open object form "ChequeBonds"
	And I close all client application windows
	Given I open "ChequeBonds" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form ChequeBonds" exception
	And I close current window

Scenario: Open choise form "ChequeBonds"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.ChequeBonds.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form IChequeBonds" exception
	And I close current window

Scenario: Open list form "Addresses" 
	And I close all client application windows
	Given I open "Addresses" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Addresses" exception
	And I close current window

Scenario: Open object form "Addresses"
	And I close all client application windows
	Given I open "Addresses" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Addresses" exception
	And I close current window

Scenario: Open choise form "Addresses"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Addresses.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Addresses" exception
	And I close current window

Scenario: Open list form "Vehicles" 
	And I close all client application windows
	Given I open "Vehicles" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Vehicles" exception
	And I close current window

Scenario: Open object form "Vehicles"
	And I close all client application windows
	Given I open "Vehicles" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Vehicles" exception
	And I close current window

Scenario: Open choise form "Vehicles"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Vehicles.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Vehicles" exception
	And I close current window

Scenario: Open list form "VehicleTypes" 
	And I close all client application windows
	Given I open "VehicleTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form VehicleTypes" exception
	And I close current window

Scenario: Open object form "VehicleTypes"
	And I close all client application windows
	Given I open "VehicleTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form VehicleTypes" exception
	And I close current window

Scenario: Open choise form "VehicleTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.VehicleTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form VehicleTypes" exception
	And I close current window

Scenario: Open list form "Projects" 
	And I close all client application windows
	Given I open "Projects" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Projects" exception
	And I close current window

Scenario: Open object form "Projects"
	And I close all client application windows
	Given I open "Projects" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Projects" exception
	And I close current window

Scenario: Open choise form "Projects"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Projects.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Projects" exception
	And I close current window

Scenario: Open list form "Incoterms" 

	Given I open "Incoterms" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Incoterms" exception
	And I close current window

Scenario: Open object form "Incoterms"
	And I close all client application windows
	Given I open "Incoterms" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form Incoterms" exception
	And I close current window

Scenario: Open choise form "Incoterms"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Incoterms.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Incoterms" exception
	And I close current window

Scenario: Open list form "AccrualAndDeductionTypes" 
	And I close all client application windows
	Given I open "AccrualAndDeductionTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open object form "AccrualAndDeductionTypes"
	And I close all client application windows
	Given I open "AccrualAndDeductionTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open choise form "AccrualAndDeductionTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.AccrualAndDeductionTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form AccrualAndDeductionTypes" exception
	And I close current window

Scenario: Open list form "EmployeePositions" 
	And I close all client application windows
	Given I open "EmployeePositions" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
	And I close current window

Scenario: Open object form "EmployeePositions"
	And I close all client application windows
	Given I open "EmployeePositions" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
	And I close current window

Scenario: Open choise form "EmployeePositions"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeePositions.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form EmployeePositions" exception
	And I close current window

Scenario: Open list form "EmployeeSchedule" 
	And I close all client application windows
	Given I open "EmployeeSchedule" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeeSchedule" exception
	And I close current window

Scenario: Open object form "EmployeeSchedule"
	And I close all client application windows
	Given I open "EmployeeSchedule" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeeSchedule" exception
	And I close current window

Scenario: Open choise form "EmployeeSchedule"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeeSchedule.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form EmployeeSchedule" exception
	And I close current window

Scenario: Open list form "FixedAssets" 
	And I close all client application windows
	Given I open "FixedAssets" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FixedAssets" exception
	And I close current window

Scenario: Open object form "FixedAssets"
	And I close all client application windows
	Given I open "FixedAssets" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FixedAssets" exception
	And I close current window

Scenario: Open choise form "FixedAssets"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.FixedAssets.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form FixedAssets" exception
	And I close current window

Scenario: Open list form "FixedAssetsLedgerTypes" 
	And I close all client application windows
	Given I open "FixedAssetsLedgerTypes" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Open object form "FixedAssetsLedgerTypes"
	And I close all client application windows
	Given I open "FixedAssetsLedgerTypes" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Open choise form "FixedAssetsLedgerTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.FixedAssetsLedgerTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Open list form "DepreciationSchedules" 
	And I close all client application windows
	Given I open "DepreciationSchedules" catalog default form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DepreciationSchedules" exception
	And I close current window

Scenario: Open object form "DepreciationSchedules"
	And I close all client application windows
	Given I open "DepreciationSchedules" reference main form
	If the warning is displayed then
		Then I raise "Failed to open catalog form DepreciationSchedules" exception
	And I close current window

Scenario: Open choise form "DepreciationSchedules"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.DepreciationSchedules.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form DepreciationSchedules" exception
	And I close current window