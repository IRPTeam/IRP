
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Information registers - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening form Information registers "Item barcodes" (Barcodes)

	Given I open "Barcodes" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers Barcodes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers Barcodes" exception
	And I close current window

Scenario: Opening form Information registers "Company Ledger types" (CompanyLedgerTypes)

	Given I open "CompanyLedgerTypes" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers CompanyLedgerTypes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers CompanyLedgerTypes" exception
	And I close current window

Scenario: Opening form Information registers "Document fiscal status" (DocumentFiscalStatus)

	Given I open "DocumentFiscalStatus" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers DocumentFiscalStatus" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers DocumentFiscalStatus" exception
	And I close current window

Scenario: Opening form Information registers "Hardware log" (HardwareLog)

	Given I open "HardwareLog" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers HardwareLog" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers HardwareLog" exception
	And I close current window

Scenario: Opening form Information registers "Item segments content" (ItemSegments)

	Given I open "ItemSegments" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers ItemSegments" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers ItemSegments" exception
	And I close current window

Scenario: Opening form Information registers "Job queue" (JobQueue)

	Given I open "JobQueue" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers JobQueue" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers JobQueue" exception
	And I close current window

Scenario: Opening form Information registers "Objects status history" (ObjectStatuses)

	Given I open "ObjectStatuses" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers ObjectStatuses" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers ObjectStatuses" exception
	And I close current window

Scenario: Opening form Information registers "Scanned barcode" (T1010S_ScannedBarcode)

	Given I open "T1010S_ScannedBarcode" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T1010S_ScannedBarcode" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T1010S_ScannedBarcode" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Item key)" (T9010S_AccountsItemKey)

	Given I open "T9010S_AccountsItemKey" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9010S_AccountsItemKey" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9010S_AccountsItemKey" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Cash account)" (T9011S_AccountsCashAccount)

	Given I open "T9011S_AccountsCashAccount" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9011S_AccountsCashAccount" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9011S_AccountsCashAccount" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Partner)" (T9012S_AccountsPartner)

	Given I open "T9012S_AccountsPartner" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9012S_AccountsPartner" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9012S_AccountsPartner" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Tax)" (T9013S_AccountsTax)

	Given I open "T9013S_AccountsTax" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9013S_AccountsTax" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9013S_AccountsTax" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Expense / Revenue)" (T9014S_AccountsExpenseRevenue)

	Given I open "T9014S_AccountsExpenseRevenue" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9014S_AccountsExpenseRevenue" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9014S_AccountsExpenseRevenue" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Fixed asset)" (T9015S_AccountsFixedAsset)

	Given I open "T9015S_AccountsFixedAsset" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9015S_AccountsFixedAsset" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9015S_AccountsFixedAsset" exception
	And I close current window

Scenario: Opening form Information registers "Accounts (Employee)" (T9016S_AccountsEmployee)

	Given I open "T9016S_AccountsEmployee" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9016S_AccountsEmployee" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9016S_AccountsEmployee" exception
	And I close current window

Scenario: Opening form Information registers "T9500 Accrual and deduction values" (T9500S_AccrualAndDeductionValues)

	Given I open "T9500S_AccrualAndDeductionValues" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9500S_AccrualAndDeductionValues" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9500S_AccrualAndDeductionValues" exception
	And I close current window

Scenario: Opening form Information registers "T9530 Work days" (T9530S_WorkDays)

	Given I open "T9530S_WorkDays" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9530S_WorkDays" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9530S_WorkDays" exception
	And I close current window

Scenario: Opening form Information registers "T9545 Vacation days limits " (T9545S_VacationDaysLimits)

	Given I open "T9545S_VacationDaysLimits" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers T9545S_VacationDaysLimits" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers T9545S_VacationDaysLimits" exception
	And I close current window

Scenario: Opening form Information registers "Company taxes" (Taxes)

	Given I open "Taxes" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers Taxes" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers Taxes" exception
	And I close current window

Scenario: Opening form Information registers "Tax rate settings" (TaxSettings)

	Given I open "TaxSettings" information register default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Information registers TaxSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Information registers TaxSettings" exception
	And I close current window
