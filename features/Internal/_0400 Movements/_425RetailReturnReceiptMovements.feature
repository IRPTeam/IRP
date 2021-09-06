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
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
	* Tax settings
		When filling in Tax settings for company
	* Load RetailSalesReceipt
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load RetailReturnReceipt
		When Create document RetailReturnReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailReturnReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt and RetailRetutnReceipt objects (with discount) 
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.RetailReturnReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);" |



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
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'                      | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                             | ''                     |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''         | ''                             | 'Attributes'           |
			| ''                                                    | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '1 664,06'  | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                    | 'Expense'     | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'en description is empty'      | 'No'                   |
		And I close all client application windows


Scenario: _042504 check Retail return receipt movements by the Register  "R2001 Sales"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '201' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     |
			| 'Document registrations records'                      | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     |
			| 'Register  "R2001 Sales"'                             | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     |
			| ''                                                    | 'Period'              | 'Resources' | ''          | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     |
			| ''                                                    | ''                    | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                            | 'Item key'  | 'Row key'                              |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | '27115324-bb2e-4c35-897e-0666d863ed5f' |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | '27115324-bb2e-4c35-897e-0666d863ed5f' |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | '27115324-bb2e-4c35-897e-0666d863ed5f' |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-1 438,08' | '-1 218,71'  | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | '27115324-bb2e-4c35-897e-0666d863ed5f' |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-136,96'   | '-116,07'    | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-89,02'    | '-75,44'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' |
		And I close all client application windows



Scenario: _042508 check Retail return receipt movements by the Register  "R2021 Customer transactions"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                    | ''                     | ''                           |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                    | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'             | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                    | ''                     | ''                           |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''           | ''         | ''                      | ''                                                    | 'Attributes'           | ''                           |
			| ''                                                    | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Legal name' | 'Partner'  | 'Agreement'             | 'Basis'                                               | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-89,02'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '89,02'     | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '520'       | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '520'       | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '520'       | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | 'No'                   | ''                           |
		And I close all client application windows

Scenario: _042509 check Retail return receipt movements by the Register  "R5010 Reconciliation statement"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Register  "R5010 Reconciliation statement"'          | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''         | ''           | ''                    |
			| ''                                                    | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Currency' | 'Legal name' | 'Legal name contract' |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   | ''                    |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '520'       | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   | ''                    |
		And I close all client application windows


Scenario: _042510 check Retail return receipt movements by the Register  "R2005 Sales special offers"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '203' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 203 dated 09.08.2021 11:41:58' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''         | ''                                     | ''                 |
			| 'Document registrations records'                      | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''         | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'              | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''         | ''                                     | ''                 |
			| ''                                                    | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''        | ''                             | ''         | ''                                                   | ''         | ''                                     | ''                 |
			| ''                                                    | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                            | 'Item key' | 'Row key'                              | 'Special offer'    |
			| ''                                                    | '09.08.2021 11:41:58' | '-8 260,02'    | '-7 000,02'  | '-777,78'       | ''                 | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'  | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-8 260,02'    | '-7 000,02'  | '-777,78'       | ''                 | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'  | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-8 260,02'    | '-7 000,02'  | '-777,78'       | ''                 | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'  | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-1 414,12'    | '-1 198,4'   | '-133,16'       | ''                 | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'  | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-468'         | '-396,61'    | '-44,07'        | ''                 | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'  | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-468'         | '-396,61'    | '-44,07'        | ''                 | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'  | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-468'         | '-396,61'    | '-44,07'        | ''                 | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'  | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                    | '09.08.2021 11:41:58' | '-80,12'       | '-67,9'      | '-7,54'         | ''                 | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'  | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
		And I close all client application windows

Scenario: _042511 check Retail return receipt movements by the Register  "R2005 Sales special offers"
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R2005 Sales special offers" 
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R2005 Sales special offers" |
		And I close all client application windows

Scenario: _042512 check Retail return receipt movements by the Register  "R5021 Revenues"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '203' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 203 dated 09.08.2021 11:41:58' | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             |
			| 'Document registrations records'                      | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             |
			| 'Register  "R5021 Revenues"'                          | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                                    | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                                    | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                                    | '09.08.2021 11:41:58' | '-1 198,4'  | '-1 414,12'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                                    | '09.08.2021 11:41:58' | '-67,9'     | '-80,12'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'USD'      | ''                    | 'Reporting currency'           |		
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