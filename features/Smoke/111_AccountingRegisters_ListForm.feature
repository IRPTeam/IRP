
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Accounting registers - ListForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening the List form Accounting registers "Accounting records (Basic)" (Basic)

	Given I open the list form of Accounting register "Basic"
	If the warning is displayed then
		Then I raise "The list form could not be opened Accounting registers Basic" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The list form could not be opened Accounting registers Basic" exception
	And I close current window
