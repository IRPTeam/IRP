#language: en
@tree
@Positive
@Movements
@MovementsRetailSalesReceipt


Feature: check Retail sales receipt movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042400 preparation (RetailSalesReceipt)
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
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load RetailSalesReceipt
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
	

Scenario: _042401 check Retail sales receipt movements by the Register  "R4010 Actual stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4010 Actual stocks"'                    | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '1'         | 'Store 01'   | 'XS/Blue'   |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '2'         | 'Store 01'   | '38/Yellow' |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '12'        | 'Store 01'   | '36/18SD'   |
		And I close all client application windows

Scenario: _042402 check Retail sales receipt movements by the Register  "R4011 Free stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''            | ''                    | ''          | ''           | ''          |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''           | ''          |
			| 'Register  "R4011 Free stocks"'                      | ''            | ''                    | ''          | ''           | ''          |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '1'         | 'Store 01'   | 'XS/Blue'   |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '2'         | 'Store 01'   | '38/Yellow' |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '12'        | 'Store 01'   | '36/18SD'   |
		And I close all client application windows

Scenario: _042403 check Retail sales receipt movements by the Register  "R3010 Cash on hand"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'                     | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''         | ''                             | 'Attributes'           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '1 664,06'  | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows

Scenario: _042408 check Retail sales receipt movements by the Register  "R2021 Customer transactions"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                   | ''                     | ''                           |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                   | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'            | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                   | ''                     | ''                           |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                   | 'Attributes'           | ''                           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Legal name' | 'Partner'  | 'Agreement'             | 'Basis'                                              | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '1 797,22'  | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '1 797,22'  | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | 'No'                   | ''                           |
		And I close all client application windows


Scenario: _042409 check Retail sales receipt movements by the Register  "R5010 Reconciliation statement"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''            | ''                    | ''          | ''             | ''        | ''         | ''           |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''         | ''           |
			| 'Register  "R5010 Reconciliation statement"'         | ''            | ''                    | ''          | ''             | ''        | ''         | ''           |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''         | ''           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Currency' | 'Legal name' |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   |
		And I close all client application windows



Scenario: _042430 Retail sales receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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
