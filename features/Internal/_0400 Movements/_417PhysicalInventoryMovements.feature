#language: en
@tree
@Positive
@Movements
@MovementsPhysicalInventory


Feature: check Physical inventory movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041700 preparation (Physical inventory)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog PartnersBankAccounts objects
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load Physical inventory
		When Create document PhysicalInventory objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.PhysicalInventory.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _041701 check Physical inventory movements by the Register  "R4010 Actual stocks"
	* Select Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Physical inventory 201 dated 15.03.2021 15:29:31' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                   | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4010 Actual stocks"'                  | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                 | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                 | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                 | 'Receipt'     | '15.03.2021 15:29:31' | '5'         | 'Store 06'   | '36/Yellow' |
			| ''                                                 | 'Expense'     | '15.03.2021 15:29:31' | '2'         | 'Store 06'   | 'XS/Blue'   |
		And I close all client application windows

Scenario: _041702 check Physical inventory movements by the Register  "R4011 Free stocks"
	* Select Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Physical inventory 201 dated 15.03.2021 15:29:31' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                   | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4011 Free stocks"'                    | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                 | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                 | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                 | 'Receipt'     | '15.03.2021 15:29:31' | '5'         | 'Store 06'   | '36/Yellow' |
			| ''                                                 | 'Expense'     | '15.03.2021 15:29:31' | '2'         | 'Store 06'   | 'XS/Blue'   |	
		And I close all client application windows


Scenario: _041730 Physical inventory clear posting/mark for deletion
	And I close all client application windows
	* Select Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Physical inventory 201 dated 15.03.2021 15:29:31' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Physical inventory
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks' |
			| 'R4010 Actual stocks' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Physical inventory 201 dated 15.03.2021 15:29:31' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PhysicalInventory"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks' |
			| 'R4010 Actual stocks' |
		And I close all client application windows
