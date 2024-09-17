
#language: en

@tree
@SmokeTest


Feature: Smoke tests - Data processors - ObjectForm
# Configuration IRP
# Version: 2024.32.117

Background:
	Given I launch TestClient opening script or connect the existing one
	And I close all client application windows

Scenario: Opening form Data processors "Analise document movements" (AnaliseDocumentMovements)

	Given I open "AnaliseDocumentMovements" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors AnaliseDocumentMovements" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors AnaliseDocumentMovements" exception
	And I close current window

Scenario: Opening form Data processors "Analyse XDTO" (AnalyseXDTO)

	Given I open "AnalyseXDTO" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors AnalyseXDTO" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors AnalyseXDTO" exception
	And I close current window

Scenario: Opening form Data processors "Builder example" (BuilderExample)

	Given I open "BuilderExample" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors BuilderExample" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors BuilderExample" exception
	And I close current window

Scenario: Opening form Data processors "Create RegExp" (CreateRegExp)

	Given I open "CreateRegExp" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors CreateRegExp" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors CreateRegExp" exception
	And I close current window

Scenario: Opening form Data processors "Create serial lot numbers" (CreateSerialLotNumbers)

	Given I open "CreateSerialLotNumbers" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors CreateSerialLotNumbers" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors CreateSerialLotNumbers" exception
	And I close current window

Scenario: Opening form Data processors "Data history" (DataHistory)

	Given I open "DataHistory" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors DataHistory" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors DataHistory" exception
	And I close current window

Scenario: Opening form Data processors "Fix document problems" (FixDocumentProblems)

	Given I open "FixDocumentProblems" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors FixDocumentProblems" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors FixDocumentProblems" exception
	And I close current window

Scenario: Opening form Data processors "Functional option settings" (FunctionalOptionSettings)

	Given I open "FunctionalOptionSettings" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors FunctionalOptionSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors FunctionalOptionSettings" exception
	And I close current window

Scenario: Opening form Data processors "Load and unload data" (LoadAndUnloadData)

	Given I open "LoadAndUnloadData" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors LoadAndUnloadData" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors LoadAndUnloadData" exception
	And I close current window

Scenario: Opening form Data processors "Mobile create document" (MobileCreateDocument)

	Given I open "MobileCreateDocument" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors MobileCreateDocument" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors MobileCreateDocument" exception
	And I close current window

Scenario: Opening form Data processors "Desktop" (MobileDesktop)

	Given I open "MobileDesktop" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors MobileDesktop" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors MobileDesktop" exception
	And I close current window

Scenario: Opening form Data processors "Mobile invent" (MobileInvent)

	Given I open "MobileInvent" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors MobileInvent" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors MobileInvent" exception
	And I close current window

Scenario: Opening form Data processors "Object property editor" (ObjectPropertyEditor)

	Given I open "ObjectPropertyEditor" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors ObjectPropertyEditor" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors ObjectPropertyEditor" exception
	And I close current window

Scenario: Opening form Data processors "Point of sale" (PointOfSale)

	Given I open "PointOfSale" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors PointOfSale" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors PointOfSale" exception
	And I close current window

Scenario: Opening form Data processors "Print labels" (PrintLabels)

	Given I open "PrintLabels" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors PrintLabels" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors PrintLabels" exception
	And I close current window

Scenario: Opening form Data processors "Production workspace" (ProductionWorkspace)

	Given I open "ProductionWorkspace" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors ProductionWorkspace" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors ProductionWorkspace" exception
	And I close current window

Scenario: Opening form Data processors "Replace serial lot number" (ReplaceSerialLotNumber)

	Given I open "ReplaceSerialLotNumber" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors ReplaceSerialLotNumber" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors ReplaceSerialLotNumber" exception
	And I close current window


Scenario: Opening form Data processors "Store keeper workspace" (StoreKeeperWorkspace)

	Given I open "StoreKeeperWorkspace" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors StoreKeeperWorkspace" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors StoreKeeperWorkspace" exception
	And I close current window

Scenario: Opening form Data processors "System settings" (SystemSettings)

	Given I open "SystemSettings" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors SystemSettings" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors SystemSettings" exception
	And I close current window


Scenario: Opening form Data processors "Edit documents movements" (EditDocumentsMovements)

	Given I open "EditDocumentsMovements" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors EditDocumentsMovements" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors EditDocumentsMovements" exception
	And I close current window

Scenario: Opening form Data processors "Attached files to documents control" (AttachedFilesToDocumentsControl)

	Given I open "AttachedFilesToDocumentsControl" data processor default form
	If the warning is displayed then
		Then I raise "The main form could not be opened Data processors AttachedFilesToDocumentsControl" exception
	If current form name is "ErrorWindow" Then
		Then I raise "The main form could not be opened Data processors AttachedFilesToDocumentsControl" exception
	And I close current window
