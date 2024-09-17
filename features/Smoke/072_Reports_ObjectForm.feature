
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Reports - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows


Scenario: Opening form Reports "D0011 Price info" (D0011_PriceInfo)

	Given I open "D0011_PriceInfo" report default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Reports D0011_PriceInfo" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Reports D0011_PriceInfo" exception
	And I close current window

