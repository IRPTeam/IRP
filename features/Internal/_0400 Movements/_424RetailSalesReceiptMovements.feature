#language: en
@tree
@Positive
@Movements
@MovementsRetailSalesReceipt


Feature: check Retail sales receipt movements

Variables:
import "Variables.feature"

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
		When Create catalog CashAccounts objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners and Payment type (Bank)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create catalog BankTerms objects (for Shop 02)
		When Create catalog BusinessUnits objects (Shop 02, use consolidated retail sales)
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create PaymentType (advance)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When update ItemKeys
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create Document discount
		* Add plugin for discount
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			If "List" table does not contain lines Then
					| "Description" |
					| "DocumentDiscount" |
				When add Plugin for document discount
		* Add plugin for taxes calculation
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			If "List" table does not contain lines Then
					| "Description" |
					| "TaxCalculateVAT_TR" |
				When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Load PI
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load RetailSalesReceipt
		When Create document Retail sales receipt and Retail return receipt (payment type - bank credit)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(110).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt and RetailReturnReceipt (consignor)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document RetailSalesReceipt and RetailRetutnReceipt objects (with discount)
		When Create document RetailSalesReceipt (stock control serial lot numbers) 
		When Create document Retail sales receipt (payment type - customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);" |
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);" |	
		When Create document CashReceipt objects advance from retail customer
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document BankReceipt objects (retail customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document Retail sales receipt (based on retail sales order)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);" |	


Scenario: _0424001 check preparation
	When check preparation

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
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''            | ''                    | ''          | ''           | ''          | ''          |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''           | ''          | ''          |
			| 'Register  "R4010 Actual stocks"'                    | ''            | ''                    | ''          | ''           | ''          | ''          |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''          | ''          |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key'  | 'Serial lot number'  |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '1'         | 'Store 01'   | 'XS/Blue'   | ''   |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '2'         | 'Store 01'   | '38/Yellow' | '' |
			| ''                                                   | 'Expense'     | '15.03.2021 16:01:04' | '12'        | 'Store 01'   | '36/18SD'   | ''   |
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
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| 'Register  "R3010 Cash on hand"'                     | ''            | ''                    | ''          | ''             | ''        | ''             | ''         | ''                     | ''                             | ''                     |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''         | ''                     | ''                             | 'Attributes'           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '1 664,06'  | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'No'                   |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'Local currency'               | 'No'                   |
			| ''                                                   | 'Receipt'     | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'No'                   |
		And I close all client application windows

Scenario: _042404 check Retail sales receipt with serial lot number movements by the Register  "R4010 Actual stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 112' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 112 dated 24.05.2022 14:18:49' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                      | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                     | 'Expense'     | '24.05.2022 14:18:49' | '5'         | 'Store 03'   | 'PZU'      | '8908899877'        |
			| ''                                                     | 'Expense'     | '24.05.2022 14:18:49' | '5'         | 'Store 03'   | 'PZU'      | '8908899879'        |
			| ''                                                     | 'Expense'     | '24.05.2022 14:18:49' | '10'        | 'Store 03'   | 'UNIQ'     | ''                  |	
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
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                   | ''                           | ''                     | ''                           |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                   | ''                           | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'            | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                   | ''                           | ''                     | ''                           |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                   | ''                           | 'Attributes'           | ''                           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Transaction Currency' | 'Legal name' | 'Partner'  | 'Agreement'             | 'Basis'                                              | 'Order'                      | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '1 797,22'  | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '1 797,22'  | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                           | 'No'                   | ''                           |
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
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Register  "R5010 Reconciliation statement"'         | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''         | ''           | ''                    |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Currency' | 'Legal name' | 'Legal name contract' |
			| ''                                                   | 'Receipt'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   | ''                    |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '10 497,79' | 'Main Company' | 'Shop 01' | 'TRY'      | 'Customer'   | ''                    |
		And I close all client application windows

Scenario: _042410 check Retail sales receipt movements by the Register  "R2005 Sales special offers" (with discount)
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '203' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     | ''                 |
			| 'Document registrations records'                     | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'             | ''                    | ''             | ''           | ''              | ''                 | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     | ''                 |
			| ''                                                   | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''        | ''                             | ''         | ''                                                   | ''          | ''                                     | ''                 |
			| ''                                                   | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                            | 'Item key'  | 'Row key'                              | 'Special offer'    |
			| ''                                                   | '09.08.2021 11:39:42' | '80,12'        | '67,9'       | '7,54'          | ''                 | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'   | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '123,26'       | '104,46'     | '11,61'         | ''                 | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '38/Yellow' | 'b302922e-0b16-4707-9611-6738e0f0de46' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '468'          | '396,61'     | '44,07'         | ''                 | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'   | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '468'          | '396,61'     | '44,07'         | ''                 | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'   | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '468'          | '396,61'     | '44,07'         | ''                 | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | 'XS/Blue'   | '8c5b09d8-ec48-4846-be01-39bd9dc72d58' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '719,99'       | '610,16'     | '67,8'          | ''                 | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '38/Yellow' | 'b302922e-0b16-4707-9611-6738e0f0de46' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '719,99'       | '610,16'     | '67,8'          | ''                 | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '38/Yellow' | 'b302922e-0b16-4707-9611-6738e0f0de46' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '719,99'       | '610,16'     | '67,8'          | ''                 | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '38/Yellow' | 'b302922e-0b16-4707-9611-6738e0f0de46' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '1 414,12'     | '1 198,4'    | '133,16'        | ''                 | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'   | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '8 260,02'     | '7 000,02'   | '777,78'        | ''                 | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'   | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '8 260,02'     | '7 000,02'   | '777,78'        | ''                 | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'   | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
			| ''                                                   | '09.08.2021 11:39:42' | '8 260,02'     | '7 000,02'   | '777,78'        | ''                 | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 203 dated 09.08.2021 11:39:42' | '36/18SD'   | '996e771d-7b70-4d2f-9a32-f92836115173' | 'DocumentDiscount' |
		And I close all client application windows


Scenario: _042411 check Retail sales receipt movements by the Register  "R5021 Revenues"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '202' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             |
			| 'Document registrations records'                     | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             |
			| 'Register  "R5021 Revenues"'                         | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             |
			| ''                                                   | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             |
			| ''                                                   | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Revenue type' | 'Item key'  | 'Currency' | 'Additional analytic' | 'Multi currency movement type' |
			| ''                                                   | '28.07.2021 13:53:27' | '75,44'     | '89,02'             | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                                   | '28.07.2021 13:53:27' | '116,07'    | '136,96'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                                   | '28.07.2021 13:53:27' | '440,68'    | '520'               | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                                   | '28.07.2021 13:53:27' | '440,68'    | '520'               | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                                   | '28.07.2021 13:53:27' | '440,68'    | '520'               | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                                   | '28.07.2021 13:53:27' | '677,96'    | '799,99'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                                   | '28.07.2021 13:53:27' | '677,96'    | '799,99'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                                   | '28.07.2021 13:53:27' | '677,96'    | '799,99'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                                   | '28.07.2021 13:53:27' | '1 331,56'  | '1 571,24'          | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                                   | '28.07.2021 13:53:27' | '7 777,8'   | '9 177,8'           | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                                   | '28.07.2021 13:53:27' | '7 777,8'   | '9 177,8'           | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                                   | '28.07.2021 13:53:27' | '7 777,8'   | '9 177,8'           | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'TRY'      | ''                    | 'en description is empty'      |			
		And I close all client application windows

Scenario:_042412 check Retail sales receipt movements by the Register  "R2005 Sales special offers" (without discount)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
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

Scenario: _042413 check Retail sales receipt movements by the Register  "R2001 Sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                                     | ''             |
			| 'Document registrations records'                       | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                              | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                                     | ''             |
			| ''                                                     | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                     | ''         | ''                                     | ''             |
			| ''                                                     | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                              | 'Item key' | 'Row key'                              | 'Sales person' |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '94,16'  | '79,8'       | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '550'    | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '550'    | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '550'    | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '188,32' | '159,59'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '273,92' | '273,92'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |		
		And I close all client application windows


Scenario: _042415 check Retail sales receipt movements by the Register  "R2050 Retail sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R2050 Retail sales"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                     | ''         | ''                  | ''                                     |
			| 'Document registrations records'                       | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                     | ''         | ''                  | ''                                     |
			| 'Register  "R2050 Retail sales"'                       | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                     | ''         | ''                  | ''                                     |
			| ''                                                     | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''        | ''         | ''             | ''                                                     | ''         | ''                  | ''                                     |
			| ''                                                     | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Store'    | 'Sales person' | 'Retail sales receipt'                                 | 'Item key' | 'Serial lot number' | 'Row key'                              |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '550'    | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | ''                  | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'S/Yellow' | ''                  | '6ebea8a7-366d-409c-84a7-19f5714085e9' |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | '09987897977890'    | 'f3d688c7-7c7b-4432-9725-06721e496320' |		
		And I close all client application windows


Scenario: _042418 check Retail sales receipt movements by the Register  "R4010 Actual stocks" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                      | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '3'         | 'Store 02'   | 'S/Yellow' | ''                  |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '4'         | 'Store 02'   | 'UNIQ'     | ''                  |		
		And I close all client application windows

Scenario: _042419 check Retail sales receipt movements by the Register  "R4011 Free stocks" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                        | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '3'         | 'Store 02'   | 'S/Yellow' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '4'         | 'Store 02'   | 'UNIQ'     |		
		And I close all client application windows

Scenario: _042420 check Retail sales receipt movements by the Register  "R4014 Serial lot numbers" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'                 | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''      | ''         | ''                  |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'  | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '4'         | 'Main Company' | 'Shop 01' | ''      | 'UNIQ'     | '09987897977890'    |		
		And I close all client application windows

Scenario: _042421 check Retail sales receipt movements by the Register  "R8012 Consignor inventory" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R8012 Consignor inventory"
		And I click "Registrations report" button
		And I select "R8012 Consignor inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         | ''            |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         | ''            |
			| 'Register  "R8012 Consignor inventory"'                | ''            | ''                    | ''          | ''             | ''         | ''                  | ''            | ''                         | ''            |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                  | ''            | ''                         | ''            |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Serial lot number' | 'Partner'     | 'Agreement'                | 'Legal name'  |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'S/Yellow' | ''                  | 'Consignor 1' | 'Consignor partner term 1' | 'Consignor 1' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'UNIQ'     | '09987897977890'    | 'Consignor 1' | 'Consignor partner term 1' | 'Consignor 1' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'UNIQ'     | '09987897977890'    | 'Consignor 2' | 'Consignor 2 partner term' | 'Consignor 2' |
		And I close all client application windows

Scenario: _042422 check Retail sales receipt movements by the Register  "R8013 Consignor batch wise balance" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R8013 Consignor batch wise balance"
		And I click "Registrations report" button
		And I select "R8013 Consignor batch wise balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| 'Register  "R8013 Consignor batch wise balance"'       | ''            | ''                    | ''          | ''             | ''                                               | ''         | ''         | ''                  | ''                 |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                               | ''         | ''         | ''                  | ''                 |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Company'      | 'Batch'                                          | 'Store'    | 'Item key' | 'Serial lot number' | 'Source of origin' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'S/Yellow' | ''                  | ''                 |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'Store 02' | 'UNIQ'     | '09987897977890'    | ''                 |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'Store 02' | 'UNIQ'     | '09987897977890'    | ''                 |
		And I close all client application windows

Scenario: _042423 check Retail sales receipt movements by the Register  "R8014 Consignor sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '1 113' |
	* Check movements by the Register  "R8014 Consignor sales"
		And I click "Registrations report" button
		And I select "R8014 Consignor sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''            | ''                         | ''                                                     | ''                                               | ''         | ''                  | ''                  | ''     | ''                        | ''                   | ''                             | ''         | ''                  | ''                | ''      |
			| 'Document registrations records'                       | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''            | ''                         | ''                                                     | ''                                               | ''         | ''                  | ''                  | ''     | ''                        | ''                   | ''                             | ''         | ''                  | ''                | ''      |
			| 'Register  "R8014 Consignor sales"'                    | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''            | ''                         | ''                                                     | ''                                               | ''         | ''                  | ''                  | ''     | ''                        | ''                   | ''                             | ''         | ''                  | ''                | ''      |
			| ''                                                     | 'Period'              | 'Resources' | ''           | ''       | 'Dimensions'                           | ''             | ''            | ''                         | ''                                                     | ''                                               | ''         | ''                  | ''                  | ''     | ''                        | ''                   | ''                             | ''         | ''                  | ''                | ''      |
			| ''                                                     | ''                    | 'Quantity'  | 'Net amount' | 'Amount' | 'Row key'                              | 'Company'      | 'Partner'     | 'Partner term'             | 'Sales invoice'                                        | 'Purchase invoice'                               | 'Item key' | 'Serial lot number' | 'Source of origin'  | 'Unit' | 'Price type'              | 'Dont calculate row' | 'Multi currency movement type' | 'Currency' | 'Price include tax' | 'Consignor price' | 'Price' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '136,96'     | '136,96' | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'Reporting currency'           | 'USD'      | 'No'                | '17,12'           | '68,48' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '136,96'     | '136,96' | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 2' | 'Consignor 2 partner term' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'Reporting currency'           | 'USD'      | 'No'                | '17,12'           | '68,48' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '159,59'     | '188,32' | '6ebea8a7-366d-409c-84a7-19f5714085e9' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'S/Yellow' | ''                  | ''                  | 'pcs'  | 'Basic Price without VAT' | 'No'                 | 'Reporting currency'           | 'USD'      | 'No'                | '94,16'           | '79,8'  |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'Local currency'               | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'TRY'                          | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'en description is empty'      | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 2' | 'Consignor 2 partner term' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'Local currency'               | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 2' | 'Consignor 2 partner term' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'TRY'                          | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '800'        | '800'    | 'f3d688c7-7c7b-4432-9725-06721e496320' | 'Main Company' | 'Consignor 2' | 'Consignor 2 partner term' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 196 dated 03.11.2022 16:32:57' | 'UNIQ'     | '09987897977890'    | ''                  | 'pcs'  | 'en description is empty' | 'No'                 | 'en description is empty'      | 'TRY'      | 'No'                | '100'             | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '932,2'      | '1 100'  | '6ebea8a7-366d-409c-84a7-19f5714085e9' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'S/Yellow' | ''                  | ''                  | 'pcs'  | 'Basic Price without VAT' | 'No'                 | 'Local currency'               | 'TRY'      | 'No'                | '550'             | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '932,2'      | '1 100'  | '6ebea8a7-366d-409c-84a7-19f5714085e9' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'S/Yellow' | ''                  | ''                  | 'pcs'  | 'Basic Price without VAT' | 'No'                 | 'TRY'                          | 'TRY'      | 'No'                | '550'             | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '932,2'      | '1 100'  | '6ebea8a7-366d-409c-84a7-19f5714085e9' | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'Purchase invoice 195 dated 02.11.2022 16:31:38' | 'S/Yellow' | ''                  | ''                  | 'pcs'  | 'Basic Price without VAT' | 'No'                 | 'en description is empty'      | 'TRY'      | 'No'                | '550'             | '466,1' |		
		And I close all client application windows

Scenario: _042424 check Retail sales receipt movements by the Register "R2021 Customer transactions" (payment type - bank credit) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '110' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''                                                   | ''      | ''                     | ''                           |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''                                                   | ''      | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'            | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''                                                   | ''      | ''                     | ''                           |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''                                                   | ''      | 'Attributes'           | ''                           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Agreement' | 'Basis'                                              | 'Order' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '984,4'     | 'Main Company' | 'Shop 02' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''      | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''      | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''      | 'No'                   | ''                           |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''      | 'No'                   | ''                           |		
		And I close all client application windows

Scenario: _042425 check Retail sales receipt movements by the Register  "R5010 Reconciliation statement" (payment type - bank credit) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '110' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| 'Register  "R5010 Reconciliation statement"'         | ''            | ''                    | ''          | ''             | ''        | ''         | ''           | ''                    |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''         | ''           | ''                    |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Currency' | 'Legal name' | 'Legal name contract' |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'TRY'      | 'Bank 1'     | ''                    |		
		And I close all client application windows

Scenario:_0424128 check absence Retail sales receipt movements by the Register  "R3010 Cash on hand" (payment agent)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '110' |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3010 Cash on hand" |
		And I close all client application windows

Scenario:_0424129 check absence Retail sales receipt movements by the Register  "R3050 Pos cash balances" (payment agent)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '110' |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3050 Pos cash balances" |
		And I close all client application windows

Scenario: _042426 check Retail sales receipt movements by the Register  "R2023 Advances from retail customers" (payment type - customer advance) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '112' |
	* Check movements by the Register  "R2023 Advances from retail customers"
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 112 dated 29.12.2022 17:25:31' | ''            | ''                    | ''          | ''             | ''        | ''                |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''                |
			| 'Register  "R2023 Advances from retail customers"'   | ''            | ''                    | ''          | ''             | ''        | ''                |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Retail customer' |
			| ''                                                   | 'Expense'     | '29.12.2022 17:25:31' | '500'       | 'Main Company' | 'Shop 02' | 'Sam Jons'        |		
		And I close all client application windows

Scenario: _042427 check Retail sales receipt movements by the Register  "R2012 Invoice closing of sales orders" (based on retail sales order) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'  |
			| '314' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 314 dated 09.01.2023 13:34:51' | ''            | ''                    | ''          | ''       | ''           | ''             | ''        | ''                                          | ''         | ''         | ''                                     |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''       | ''           | ''             | ''        | ''                                          | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"'  | ''            | ''                    | ''          | ''       | ''           | ''             | ''        | ''                                          | ''         | ''         | ''                                     |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''        | ''                                          | ''         | ''         | ''                                     |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Branch'  | 'Order'                                     | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                   | 'Expense'     | '09.01.2023 13:34:51' | '1'         | '520'    | '440,68'     | 'Main Company' | 'Shop 01' | 'Sales order 314 dated 09.01.2023 12:49:08' | 'TRY'      | 'XS/Blue'  | '23b88999-d27d-462f-94f4-fa7b09b4b20c' |
			| ''                                                   | 'Expense'     | '09.01.2023 13:34:51' | '2'         | '1 400'  | '1 186,44'   | 'Main Company' | 'Shop 01' | 'Sales order 314 dated 09.01.2023 12:49:08' | 'TRY'      | '37/18SD'  | '5bdde23c-effa-4551-9989-3e2d76766c28' |	
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
