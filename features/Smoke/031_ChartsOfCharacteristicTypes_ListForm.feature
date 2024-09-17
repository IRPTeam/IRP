
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Charts of characteristic types - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Charts of characteristic types "Accounting extra dimensions" (AccountingExtraDimensionTypes)

	Given I open the list form of Chart of characteristic types "AccountingExtraDimensionTypes"
	If the warning is displayed then
		Then I raise "The list form could not be opened Charts of characteristic types AccountingExtraDimensionTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Charts of characteristic types AccountingExtraDimensionTypes" exception
	And I close current window

Scenario: Opening the List form Charts of characteristic types "Additional attribute types" (AddAttributeAndProperty)

	Given I open the list form of Chart of characteristic types "AddAttributeAndProperty"
	If the warning is displayed then
		Then I raise "The list form could not be opened Charts of characteristic types AddAttributeAndProperty" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Charts of characteristic types AddAttributeAndProperty" exception
	And I close current window

Scenario: Opening the List form Charts of characteristic types "Multi currency movement types" (CurrencyMovementType)

	Given I open the list form of Chart of characteristic types "CurrencyMovementType"
	If the warning is displayed then
		Then I raise "The list form could not be opened Charts of characteristic types CurrencyMovementType" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Charts of characteristic types CurrencyMovementType" exception
	And I close current window

Scenario: Opening the List form Charts of characteristic types "Custom user settings" (CustomUserSettings)

	Given I open the list form of Chart of characteristic types "CustomUserSettings"
	If the warning is displayed then
		Then I raise "The list form could not be opened Charts of characteristic types CustomUserSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Charts of characteristic types CustomUserSettings" exception
	And I close current window

Scenario: Opening the List form Charts of characteristic types "Contact info types" (IDInfoTypes)

	Given I open the list form of Chart of characteristic types "IDInfoTypes"
	If the warning is displayed then
		Then I raise "The list form could not be opened Charts of characteristic types IDInfoTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Charts of characteristic types IDInfoTypes" exception
	And I close current window
