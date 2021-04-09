#language: en
@tree
@Positive
@Movements
@MovementsRetailReturnReceipt


Feature: check Retail return receipt movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042500 preparation (RetailReturnReceipt)
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
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
	* Tax settings
		When filling in Tax settings for company
	* Load RetailSalesReceipt
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load RetailReturnReceipt
		When Create document RetailReturnReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |



Scenario: _042501 check Retail return receipt movements by the Register  "R4010 Actual stocks"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4010 Actual stocks"'                     | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                    | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '1'         | 'Store 01'   | 'XS/Blue'   |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '2'         | 'Store 01'   | '38/Yellow' |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '12'        | 'Store 01'   | '36/18SD'   |
		And I close all client application windows

Scenario: _042502 check Retail return receipt movements by the Register  "R4011 Free stocks"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4011 Free stocks"'                       | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                    | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '1'         | 'Store 01'   | 'XS/Blue'   |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '2'         | 'Store 01'   | '38/Yellow' |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '12'        | 'Store 01'   | '36/18SD'   |
		And I close all client application windows

Scenario: _042503 check Retail return receipt movements by the Register  "R3010 Cash on hand"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''            | ''                    | ''          | ''             | ''             | ''         | ''                             | ''                     |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''             | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'                      | ''            | ''                    | ''          | ''             | ''             | ''         | ''                             | ''                     |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''         | ''                             | 'Attributes'           |
			| ''                                                    | ''            | ''                    | 'Amount'    | 'Company'      | 'Account'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '1 664,06'  | 'Main Company' | 'Cash desk №4' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Cash desk №4' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Cash desk №4' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows


Scenario: _042530 Retail return receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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