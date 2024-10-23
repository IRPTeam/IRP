
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Accumulation registers - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Accumulation registers "TM1020 Advances key" (TM1020B_AdvancesKey)

	Given I open "TM1020B_AdvancesKey" accumulation register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Accumulation registers TM1020B_AdvancesKey" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Accumulation registers TM1020B_AdvancesKey" exception
	And I close current window

Scenario: Opening the List form Accumulation registers "TM1030 Transactions key" (TM1030B_TransactionsKey)

	Given I open "TM1030B_TransactionsKey" accumulation register list form
	If the warning is displayed then
		Then I raise "The list form could not be opened Accumulation registers TM1030B_TransactionsKey" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Accumulation registers TM1030B_TransactionsKey" exception
	And I close current window
