
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Catalogs - Generate
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Open choise form "EmployeePositions"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeePositions.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog form EmployeePositions" exception
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

Scenario: Open choise form "ChequeBonds"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.ChequeBonds.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form IChequeBonds" exception
	And I close current window

Scenario: Open choise form "Addresses"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Addresses.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Addresses" exception
	And I close current window

Scenario: Open choise form "Vehicles"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Vehicles.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Vehicles" exception
	And I close current window

Scenario: Open choise form "VehicleTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.VehicleTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form VehicleTypes" exception
	And I close current window

Scenario: Open choise form "Projects"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Projects.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Projects" exception
	And I close current window


Scenario: Open choise form "Incoterms"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.Incoterms.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form Incoterms" exception
	And I close current window

Scenario: Open choise form "AccrualAndDeductionTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.AccrualAndDeductionTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form AccrualAndDeductionTypes" exception
	And I close current window


Scenario: Open choise form "EmployeePositions"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeePositions.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form EmployeePositions" exception
	And I close current window

Scenario: Open choise form "EmployeeSchedule"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.EmployeeSchedule.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form EmployeeSchedule" exception
	And I close current window

Scenario: Open choise form "FixedAssets"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.FixedAssets.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form FixedAssets" exception
	And I close current window

Scenario: Open choise form "FixedAssetsLedgerTypes"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.FixedAssetsLedgerTypes.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form FixedAssetsLedgerTypes" exception
	And I close current window

Scenario: Open choise form "DepreciationSchedules"
	And I close all client application windows
	And I execute the built-in language code (Extension)
		| 'OpenForm("Catalog.DepreciationSchedules.ChoiceForm", , Undefined, , , , , FormWindowOpeningMode.Independent)'   |
	If the warning is displayed then
		Then I raise "Failed to open catalog choise form DepreciationSchedules" exception
	And I close current window