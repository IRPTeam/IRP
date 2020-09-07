#language: en
@tree
@Positive
@Test
@OtherForms

Feature: basic check registers, reports, constants
As an QA
I want to check opening registers, reports and constants forms

Background:
	Given I launch TestClient opening script or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



Scenario: Open information register form "AddProperties" 

	Given I open "AddProperties" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  AddProperties" exception
	And I close current window



	
Scenario: Open information register form "AttachedFiles" 

	Given I open "AttachedFiles" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  AttachedFiles" exception
	And I close current window



	
Scenario: Open information register form "Barcodes" 

	Given I open "Barcodes" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  Barcodes" exception
	And I close current window



	
Scenario: Open information register form "BundleContents" 

	Given I open "BundleContents" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  BundleContents" exception
	And I close current window



	
Scenario: Open information register form "ChequeBondStatuses" 

	Given I open "ChequeBondStatuses" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ChequeBondStatuses" exception
	And I close current window


	
Scenario: Open information register form "CurrencyRates" 

	Given I open "CurrencyRates" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  CurrencyRates" exception
	And I close current window


	
Scenario: Open information register form "ExternalCommands" 

	Given I open "ExternalCommands" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ExternalCommands" exception
	And I close current window

	
Scenario: Open information register form "IDInfo" 

	Given I open "IDInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  IDInfo" exception
	And I close current window

	
Scenario: Open information register form "IntegrationInfo" 

	Given I open "IntegrationInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  IntegrationInfo" exception
	And I close current window

	
Scenario: Open information register form "ItemSegments" 

	Given I open "ItemSegments" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ItemSegments" exception
	And I close current window


	
Scenario: Open information register form "ObjectStatuses" 

	Given I open "ObjectStatuses" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  ObjectStatuses" exception
	And I close current window


	
Scenario: Open information register form "PartnerSegments" 

	Given I open "PartnerSegments" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PartnerSegments" exception
	And I close current window


	
Scenario: Open information register form "PricesByItemKeys" 

	Given I open "PricesByItemKeys" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByItemKeys" exception
	And I close current window


	
Scenario: Open information register form "PricesByItems" 

	Given I open "PricesByItems" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByItems" exception
	And I close current window

	
Scenario: Open information register form "PricesByProperties" 

	Given I open "PricesByProperties" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  PricesByProperties" exception
	And I close current window

	
Scenario: Open information register form "RemainingItemsInfo" 

	Given I open "RemainingItemsInfo" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  RemainingItemsInfo" exception
	And I close current window


	
Scenario: Open information register form "SavedItems" 

	Given I open "SavedItems" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  SavedItems" exception
	And I close current window


	
Scenario: Open information register form "Taxes" 

	Given I open "Taxes" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  Taxes" exception
	And I close current window


	
Scenario: Open information register form "TaxSettings" 

	Given I open "TaxSettings" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  TaxSettings" exception
	And I close current window 

	
Scenario: Open information register form "UserSettings" 

	Given I open "UserSettings" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  UserSettings" exception
	And I close current window

	
Scenario: Open information register form "SharedReportOptions" 

	Given I open "SharedReportOptions" information register default form
	If the warning is displayed then
		Then I raise "Failed to open information register form  SharedReportOptions" exception
	And I close current window


	
Scenario: Open information register form "BusinessUnitBankTerms" 

	Given I open "BusinessUnitBankTerms" information register default form 
	If the warning is displayed then
		Then I raise "Failed to open information register form  BusinessUnitBankTerms" exception
	And I close current window