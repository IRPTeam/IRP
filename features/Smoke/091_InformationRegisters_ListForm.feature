
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Information registers - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Information registers "Item barcodes" (Barcodes)

	Given I open "Barcodes" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers Barcodes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers Barcodes" exception
	And I close current window

Scenario: Opening the List form Information registers "Currency rates" (CurrencyRates)

	Given I open "CurrencyRates" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers CurrencyRates" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers CurrencyRates" exception
	And I close current window

Scenario: Opening the List form Information registers "Hardware log" (HardwareLog)

	Given I open "HardwareLog" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers HardwareLog" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers HardwareLog" exception
	And I close current window

Scenario: Opening the List form Information registers "Objects status history" (ObjectStatuses)

	Given I open "ObjectStatuses" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers ObjectStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers ObjectStatuses" exception
	And I close current window

Scenario: Opening the List form Information registers "T7010 Bill of materials" (T7010S_BillOfMaterials)

	Given I open "T7010S_BillOfMaterials" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers T7010S_BillOfMaterials" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers T7010S_BillOfMaterials" exception
	And I close current window

Scenario: Opening the List form Information registers "T9500 Accrual and deduction values" (T9500S_AccrualAndDeductionValues)

	Given I open "T9500S_AccrualAndDeductionValues" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers T9500S_AccrualAndDeductionValues" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers T9500S_AccrualAndDeductionValues" exception
	And I close current window

Scenario: Opening the List form Information registers "T9530 Work days" (T9530S_WorkDays)

	Given I open "T9530S_WorkDays" information register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Information registers T9530S_WorkDays" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Information registers T9530S_WorkDays" exception
	And I close current window

