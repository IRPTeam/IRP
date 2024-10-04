
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Charts of account - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening form Charts of account "Account charts (Basic)" (Basic)

	Given I open the main form of Chart of accounts "Basic"
	If the warning is displayed then
		Then I raise "The main form could not be opened Charts of account Basic" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Charts of account Basic" exception
	And I close current window
