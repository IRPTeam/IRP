#language: en
@tree
@Positive
@Movements2
@MovementsRetailSalesReceipt


Feature: check Retail sales receipt movements

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042400 preparation (RetailSalesReceipt)
	When set True value to the constant
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
		When Create catalog Items objects (commission trade)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog SerialLotNumbers objects
		When Create PaymentType (advance)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
		When Create Certificate
		When Create Document discount
		* Add plugin for discount
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
			If "List" table does not contain lines Then
					| "Description"           |
					| "DocumentDiscount"      |
				When add Plugin for document discount
		When Create information register Taxes records (VAT)
	* Load PI
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load RetailSalesReceipt
		When Create document Retail sales receipt and Retail return receipt (payment type - bank credit)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(110).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt and RetailReturnReceipt (consignor)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt and RetailRetutnReceipt objects (with discount)
		When Create document RetailSalesReceipt (stock control serial lot numbers) 
		When Create document Retail sales receipt (payment type - customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create RetailSalesOrder objects
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document CashReceipt objects advance from retail customer
		And I execute 1C:Enterprise script at server
			| "Documents.CashReceipt.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document BankReceipt objects (retail customer advance)
		And I execute 1C:Enterprise script at server
			| "Documents.BankReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Retail sales receipt (based on retail sales order)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(314).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Retail sales receipt and Retail return receipt (certificate)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(18).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Retail sales receipt (postponed)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1314).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (serial lor numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1315).GetObject().Write(DocumentWriteMode.Posting);"    |


Scenario: _0424001 check preparation
	When check preparation

Scenario: _042401 check Retail sales receipt movements by the Register  "R4010 Actual stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'                      | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '1'           | 'Store 01'     | 'XS/Blue'     | ''                     |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '2'           | 'Store 01'     | '38/Yellow'   | ''                     |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '12'          | 'Store 01'     | '36/18SD'     | ''                     |
		And I close all client application windows

Scenario: _042402 check Retail sales receipt movements by the Register  "R4011 Free stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                        | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '1'           | 'Store 01'     | 'XS/Blue'      |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '2'           | 'Store 01'     | '38/Yellow'    |
			| ''                                                     | 'Expense'       | '15.03.2021 16:01:04'   | '12'          | 'Store 01'     | '36/18SD'      |
		And I close all client application windows

Scenario: _042403 check Retail sales receipt movements by the Register  "R3010 Cash on hand"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'   | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                       | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                                     | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                                     | 'Receipt'       | '15.03.2021 16:01:04'   | '1 664,06'    | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                                     | 'Receipt'       | '15.03.2021 16:01:04'   | '9 720'       | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                                     | 'Receipt'       | '15.03.2021 16:01:04'   | '9 720'       | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _042404 check Retail sales receipt with serial lot number movements by the Register  "R4010 Actual stocks"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 112 dated 24.05.2022 14:18:49'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                         | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                        | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                       | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                       | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                       | 'Expense'       | '24.05.2022 14:18:49'   | '5'           | 'Store 03'     | 'PZU'        | '8908899877'           |
			| ''                                                       | 'Expense'       | '24.05.2022 14:18:49'   | '5'           | 'Store 03'     | 'PZU'        | '8908899879'           |
			| ''                                                       | 'Expense'       | '24.05.2022 14:18:49'   | '10'          | 'Store 03'     | 'UNIQ'       | ''                     |
		And I close all client application windows

Scenario: _042408 check Retail sales receipt movements by the Register  "R2021 Customer transactions"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''              | ''                      | ''            | ''               | ''          | ''                               | ''           | ''                       | ''             | ''           | ''                        | ''                                                     | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''               | ''          | ''                               | ''           | ''                       | ''             | ''           | ''                        | ''                                                     | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'              | ''              | ''                      | ''            | ''               | ''          | ''                               | ''           | ''                       | ''             | ''           | ''                        | ''                                                     | ''        | ''        | ''                       | ''                              |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                               | ''           | ''                       | ''             | ''           | ''                        | ''                                                     | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                                     | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'    | 'Agreement'               | 'Basis'                                                | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                                     | 'Receipt'       | '28.07.2021 13:53:27'   | '1 797,22'    | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                                     | 'Receipt'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                                     | 'Receipt'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                                     | 'Expense'       | '28.07.2021 13:53:27'   | '1 797,22'    | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                                     | 'Expense'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                                     | 'Expense'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Customer'     | 'Customer'   | 'Customer partner term'   | 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows


Scenario: _042409 check Retail sales receipt movements by the Register  "R5010 Reconciliation statement"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27'   | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Register  "R5010 Reconciliation statement"'           | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''           | ''             | ''                       |
			| ''                                                     | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Currency'   | 'Legal name'   | 'Legal name contract'    |
			| ''                                                     | 'Receipt'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'TRY'        | 'Customer'     | ''                       |
			| ''                                                     | 'Expense'       | '28.07.2021 13:53:27'   | '10 497,79'   | 'Main Company'   | 'Shop 01'   | 'TRY'        | 'Customer'     | ''                       |
		And I close all client application windows

Scenario: _042410 check Retail sales receipt movements by the Register  "R2005 Sales special offers" (with discount)
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '203'       |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''            | ''                                       | ''                    |
			| 'Document registrations records'                       | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''            | ''                                       | ''                    |
			| 'Register  "R2005 Sales special offers"'               | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''            | ''                                       | ''                    |
			| ''                                                     | 'Period'                | 'Resources'      | ''             | ''                | ''                   | 'Dimensions'     | ''          | ''                               | ''           | ''                                                     | ''            | ''                                       | ''                    |
			| ''                                                     | ''                      | 'Sales amount'   | 'Net amount'   | 'Offers amount'   | 'Net offer amount'   | 'Company'        | 'Branch'    | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                              | 'Item key'    | 'Row key'                                | 'Special offer'       |
			| ''                                                     | '09.08.2021 11:39:42'   | '80,12'          | '67,9'         | '7,54'            | ''                   | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'     | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '123,26'         | '104,46'       | '11,61'           | ''                   | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '38/Yellow'   | 'b302922e-0b16-4707-9611-6738e0f0de46'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '468'            | '396,61'       | '44,07'           | ''                   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'     | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '468'            | '396,61'       | '44,07'           | ''                   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'     | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '719,99'         | '610,16'       | '67,8'            | ''                   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '38/Yellow'   | 'b302922e-0b16-4707-9611-6738e0f0de46'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '719,99'         | '610,16'       | '67,8'            | ''                   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '38/Yellow'   | 'b302922e-0b16-4707-9611-6738e0f0de46'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '1 414,12'       | '1 198,4'      | '133,16'          | ''                   | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'     | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '8 260,02'       | '7 000,02'     | '777,78'          | ''                   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'     | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                     | '09.08.2021 11:39:42'   | '8 260,02'       | '7 000,02'     | '777,78'          | ''                   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'     | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
		And I close all client application windows


Scenario: _042411 check Retail sales receipt movements by the Register  "R5021 Revenues"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'                     | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'                         | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             | ''        |
			| ''                                                   | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''        | ''                   | ''             | ''          | ''         | ''                    | ''                             | ''        |
			| ''                                                   | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Revenue type' | 'Item key'  | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                                   | '28.07.2021 13:53:27' | '75,44'     | '89,02'             | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '116,07'    | '136,96'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '440,68'    | '520'               | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '440,68'    | '520'               | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'   | 'TRY'      | ''                    | 'en description is empty'      | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '677,96'    | '799,99'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '677,96'    | '799,99'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '38/Yellow' | 'TRY'      | ''                    | 'en description is empty'      | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '1 331,56'  | '1 571,24'          | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '7 777,8'   | '9 177,8'           | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                                   | '28.07.2021 13:53:27' | '7 777,8'   | '9 177,8'           | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'   | 'TRY'      | ''                    | 'en description is empty'      | ''        |
		And I close all client application windows

Scenario: _042412 check Retail sales receipt movements by the Register  "R2005 Sales special offers" (without discount)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R2005 Sales special offers" 
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R2005 Sales special offers"    |
		And I close all client application windows

Scenario: _042413 check Retail sales receipt movements by the Register  "R2001 Sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'                       | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                              | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| ''                                                     | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| ''                                                     | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                              | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '79,8'   | '79,8'       | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Black' | ''                  | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '466,1'  | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Black' | ''                  | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '466,1'  | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Black' | ''                  | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '188,32' | '159,59'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | '0514'              | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | '0514'              | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | '0514'              | '6ebea8a7-366d-409c-84a7-19f5714085e9' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '273,92' | '273,92'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Green' | ''                  | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Green' | ''                  | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Green' | ''                  | 'f3d688c7-7c7b-4432-9725-06721e496320' | ''             |			
		And I close all client application windows

Scenario: _042414 check Retail sales receipt movements by the Register  "R4050 Stock inventory"
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 202 dated 28.07.2021 13:53:27' | ''            | ''                    | ''          | ''             | ''         | ''          |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''         | ''          |
			| 'Register  "R4050 Stock inventory"'                  | ''            | ''                    | ''          | ''             | ''         | ''          |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''          |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key'  |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '1'         | 'Main Company' | 'Store 03' | 'XS/Blue'   |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '2'         | 'Main Company' | 'Store 03' | '38/Yellow' |
			| ''                                                   | 'Expense'     | '28.07.2021 13:53:27' | '12'        | 'Main Company' | 'Store 03' | '36/18SD'   |		
		And I close all client application windows

Scenario: _042415 check Retail sales receipt movements by the Register  "R2050 Retail sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
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
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '466,1'  | '466,1'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Black' | ''                  | '8b0b91bc-33a7-4a41-a6f9-c2759ac4de23' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '1 100'  | '932,2'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'UNIQ'     | '0514'              | '6ebea8a7-366d-409c-84a7-19f5714085e9' |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'  | '1 600'      | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | 'XL/Green' | ''                  | 'f3d688c7-7c7b-4432-9725-06721e496320' |		
		And I close all client application windows

Scenario: _042416 check Retail sales receipt absence movements by the Register  "R4050 Stock inventory" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2050 Retail sales"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4050 Stock inventory'    |
		And I close all client application windows

Scenario: _042418 check Retail sales receipt movements by the Register  "R4010 Actual stocks" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
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
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '1'         | 'Store 02'   | 'XL/Black' | ''                  |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Store 02'   | 'UNIQ'     | ''                  |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '4'         | 'Store 02'   | 'XL/Green' | ''                  |	
		And I close all client application windows

Scenario: _042419 check Retail sales receipt movements by the Register  "R4011 Free stocks" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
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
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '1'         | 'Store 02'   | 'XL/Black' |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Store 02'   | 'UNIQ'     |
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '4'         | 'Store 02'   | 'XL/Green' |		
		And I close all client application windows

Scenario: _042420 check Retail sales receipt movements by the Register  "R4014 Serial lot numbers" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
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
			| ''                                                     | 'Expense'     | '14.11.2022 13:29:44' | '2'         | 'Main Company' | 'Shop 01' | ''      | 'UNIQ'     | '0514'              |		
		And I close all client application windows



Scenario: _042423 check Retail sales receipt movements by the Register  "R8014 Consignor sales" (consignor and own stocks) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R8014 Consignor sales"
		And I click "Registrations report" button
		And I select "R8014 Consignor sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| 'Document registrations records'                       | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| 'Register  "R8014 Consignor sales"'                    | ''                    | ''          | ''           | ''       | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| ''                                                     | 'Period'              | 'Resources' | ''           | ''       | 'Dimensions'                           | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| ''                                                     | ''                    | 'Quantity'  | 'Net amount' | 'Amount' | 'DELETE row key'                       | 'Company'      | 'DELETE partner' | 'DELETE Partner term' | 'Sales invoice'                                        | 'DELETE purchase invoice' | 'Item key' | 'Serial lot number' | 'Source of origin' | 'Unit' | 'Price type'              | 'DELETE dont calculate row' | 'Multi currency movement type' | 'Currency' | 'Price include tax' | 'DELETE consignor price' | 'Price' |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '79,8'       | '79,8'   | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Black' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Reporting currency'           | 'USD'      | 'No'                | ''                       | '79,8'  |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '466,1'      | '466,1'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Black' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Local currency'               | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '1'         | '466,1'      | '466,1'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Black' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'en description is empty'      | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '159,59'     | '188,32' | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Reporting currency'           | 'USD'      | 'No'                | ''                       | '79,8'  |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '932,2'      | '1 100'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Local currency'               | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '2'         | '932,2'      | '1 100'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'en description is empty'      | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '273,92'     | '273,92' | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Reporting currency'           | 'USD'      | 'No'                | ''                       | '68,48' |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'      | '1 600'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Local currency'               | 'TRY'      | 'No'                | ''                       | '400'   |
			| ''                                                     | '14.11.2022 13:29:44' | '4'         | '1 600'      | '1 600'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'en description is empty'      | 'TRY'      | 'No'                | ''                       | '400'   |		
		And I close all client application windows

Scenario: _042424 check Retail sales receipt movements by the Register "R5015 Other partners transactions" (payment type - bank credit) 
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '110'       |
	* Check movements by the Register  "R5015 Other partners transactions"
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 110 dated 29.12.2022 14:47:30' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| 'Register  "R5015 Other partners transactions"'      | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | 'Attributes'           |
			| ''                                                   | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Agreement' | 'Basis' | 'Deferred calculation' |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '984,4'     | 'Main Company' | 'Shop 02' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
			| ''                                                   | 'Receipt'     | '29.12.2022 14:47:30' | '5 750'     | 'Main Company' | 'Shop 02' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
		And I close all client application windows

Scenario: _042425 check Retail sales receipt movements by the Register  "R5010 Reconciliation statement" (payment type - bank credit) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '110'       |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 110 dated 29.12.2022 14:47:30'   | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Register  "R5010 Reconciliation statement"'           | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''           | ''             | ''                       |
			| ''                                                     | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Currency'   | 'Legal name'   | 'Legal name contract'    |
			| ''                                                     | 'Receipt'       | '29.12.2022 14:47:30'   | '5 750'       | 'Main Company'   | 'Shop 02'   | 'TRY'        | 'Bank 1'       | ''                       |
		And I close all client application windows

Scenario:_0424128 check absence Retail sales receipt movements by the Register  "R3010 Cash on hand" (payment agent)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '110'       |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3010 Cash on hand"    |
		And I close all client application windows

Scenario:_0424129 check absence Retail sales receipt movements by the Register  "R3050 Pos cash balances" (payment agent)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '110'       |
	* Check movements by the Register  "R3050 Pos cash balances" 
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3050 Pos cash balances"    |
		And I close all client application windows

Scenario: _042426 check Retail sales receipt movements by the Register  "R2023 Advances from retail customers" (payment type - customer advance) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '112'       |
	* Check movements by the Register  "R2023 Advances from retail customers"
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 112 dated 29.12.2022 17:25:31'   | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| 'Register  "R2023 Advances from retail customers"'     | ''              | ''                      | ''            | ''               | ''          | ''                   |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                   |
			| ''                                                     | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Retail customer'    |
			| ''                                                     | 'Expense'       | '29.12.2022 17:25:31'   | '500'         | 'Main Company'   | 'Shop 02'   | 'Sam Jons'           |
		And I close all client application windows

Scenario: _042427 check Retail sales receipt movements by the Register  "R2012 Invoice closing of sales orders" (based on retail sales order) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 314 dated 09.01.2023 13:34:51'   | ''              | ''                      | ''            | ''         | ''             | ''               | ''          | ''                                            | ''           | ''           | ''                                        |
			| 'Document registrations records'                       | ''              | ''                      | ''            | ''         | ''             | ''               | ''          | ''                                            | ''           | ''           | ''                                        |
			| 'Register  "R2012 Invoice closing of sales orders"'    | ''              | ''                      | ''            | ''         | ''             | ''               | ''          | ''                                            | ''           | ''           | ''                                        |
			| ''                                                     | 'Record type'   | 'Period'                | 'Resources'   | ''         | ''             | 'Dimensions'     | ''          | ''                                            | ''           | ''           | ''                                        |
			| ''                                                     | ''              | ''                      | 'Quantity'    | 'Amount'   | 'Net amount'   | 'Company'        | 'Branch'    | 'Order'                                       | 'Currency'   | 'Item key'   | 'Row key'                                 |
			| ''                                                     | 'Expense'       | '09.01.2023 13:34:51'   | '1'           | '520'      | '440,68'       | 'Main Company'   | 'Shop 01'   | 'Sales order 314 dated 09.01.2023 12:49:08'   | 'TRY'        | 'XS/Blue'    | '23b88999-d27d-462f-94f4-fa7b09b4b20c'    |
			| ''                                                     | 'Expense'       | '09.01.2023 13:34:51'   | '2'           | '1 400'    | '1 186,44'     | 'Main Company'   | 'Shop 01'   | 'Sales order 314 dated 09.01.2023 12:49:08'   | 'TRY'        | '37/18SD'    | '5bdde23c-effa-4551-9989-3e2d76766c28'    |
		And I close all client application windows

Scenario: _042427 check Retail sales receipt movements by the Register  "R3011 Cash flow" (with advance) 
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '314'       |
	* Check movements by the Register  "R3011 Cash flow"
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 314 dated 09.01.2023 13:34:51' | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'                     | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                        | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                                   | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                                   | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                   | '09.01.2023 13:34:51' | '157,5'     | 'Main Company' | 'Shop 01' | 'Cash desk №2' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                   | '09.01.2023 13:34:51' | '920'       | 'Main Company' | 'Shop 01' | 'Cash desk №2' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                   | '09.01.2023 13:34:51' | '920'       | 'Main Company' | 'Shop 01' | 'Cash desk №2' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _042428 check Retail sales receipt movements by the Register  "R3011 Cash flow" (without advance)
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R3011 Cash flow"
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'                     | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                        | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                                   | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                                   | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                   | '15.03.2021 16:01:04' | '1 664,06'  | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                   | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                   | '15.03.2021 16:01:04' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _0424281 check Retail sales receipt movements by the Register  "R2006 Certificates" (Selling certificate)
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '15'       |
	* Check movements by the Register  "R2006 Certificates"
		And I click "Registrations report" button
		And I select "R2006 Certificates" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 15 dated 22.08.2023 11:07:27' | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| 'Document registrations records'                    | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| 'Register  "R2006 Certificates"'                    | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| ''                                                  | 'Period'              | 'Resources' | ''       | 'Dimensions' | ''                  | 'Attributes'    |
			| ''                                                  | ''                    | 'Quantity'  | 'Amount' | 'Currency'   | 'Serial lot number' | 'Movement type' |
			| ''                                                  | '22.08.2023 11:07:27' | '1'         | '500'    | 'TRY'        | '99999999999'       | 'Sale'          |	
		And I close all client application windows

Scenario:_0424282 check absence Retail sales receipt movements by the Register  "R4010 Actual stocks" (Selling certificate)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '15'       |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4010 Actual stocks"    |
		And I close all client application windows

Scenario:_0424283 check absence Retail sales receipt movements by the Register  "R4011 Free stocks" (Selling certificate)
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '15'       |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4011 Free stocks"    |
		And I close all client application windows


Scenario: _0424284 check Retail sales receipt movements by the Register  "R2006 Certificates" (Payment with a certificate)
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '16'       |
	* Check movements by the Register  "R2006 Certificates"
		And I click "Registrations report info" button
		And I select "R2006 Certificates" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 16 dated 22.08.2023 11:22:15' | ''                    | ''         | ''                  | ''         | ''       | ''              |
			| 'Register  "R2006 Certificates"'                    | ''                    | ''         | ''                  | ''         | ''       | ''              |
			| ''                                                  | 'Period'              | 'Currency' | 'Serial lot number' | 'Quantity' | 'Amount' | 'Movement type' |
			| ''                                                  | '22.08.2023 11:22:15' | 'TRY'      | '99999999999'       | '-1'       | '-500'   | 'Used'          |	
		And I close all client application windows

Scenario: _0424285 check postponed Retail sales receipt movements
	And I close all client application windows
	* Select postponed Retail sales receipt (without reserve)
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
	* Check movements
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 314 dated 07.09.2023 16:01:50' |
			| 'Document registrations records'                       |
		And I close current window
	* Change status (Postponed with reserve)
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select "Postponed with reserve" exact value from "Status type" drop-down list
		And I click "Post" button
		And I click "Registrations report" button
		And I click "Generate report" button
	* Check movements
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2001 Sales"'             |
			| 'Register  "R2050 Retail sales"'      |
			| 'Register  "R3010 Cash on hand"'      |
			| 'Register  "R3011 Cash flow"'         |
			| 'Register  "R3050 Pos cash balances"' |
			| 'Register  "R4010 Actual stocks"'     |
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 314 dated 07.09.2023 16:01:50' | ''            | ''                    | ''          | ''           | ''         | ''                                                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         | ''                                                     |
			| 'Register  "R4012 Stock Reservation"'                  | ''            | ''                    | ''          | ''           | ''         | ''                                                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                                     |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                                |
			| ''                                                     | 'Receipt'     | '07.09.2023 16:01:50' | '1'         | 'Store 01'   | 'XS/Blue'  | 'Retail sales receipt 1 314 dated 07.09.2023 16:01:50' |
			| ''                                                     | 'Receipt'     | '07.09.2023 16:01:50' | '2'         | 'Store 01'   | '37/18SD'  | 'Retail sales receipt 1 314 dated 07.09.2023 16:01:50' |
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 314 dated 07.09.2023 16:01:50' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                        | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                     | 'Expense'     | '07.09.2023 16:01:50' | '1'         | 'Store 01'   | 'XS/Blue'  |
			| ''                                                     | 'Expense'     | '07.09.2023 16:01:50' | '2'         | 'Store 01'   | '37/18SD'  |
		And I close all client application windows
	* Change status (Canceled)
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
		And I select current line in "List" table
		And I move to "Other" tab
		And I move to "More" tab
		And I select "Canceled" exact value from "Status type" drop-down list
		And I click "Post" button
		And I click "Registrations report" button
		And I click "Generate report" button
	* Check movements
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2001 Sales"'             |
			| 'Register  "R2050 Retail sales"'      |
			| 'Register  "R3010 Cash on hand"'      |
			| 'Register  "R3011 Cash flow"'         |
			| 'Register  "R3050 Pos cash balances"' |
			| 'Register  "R4010 Actual stocks"'     |
			| 'Register  "R4011 Free stocks"'       |
			| 'Register  "R4012 Stock Reservation"' |
	And I close all client application windows
	
Scenario: _0424286 check Retail sales receipt movements by the Register  "R2001 Sales" (serial lot numbers)
		And I close all client application windows	
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 315'     |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | ''                    | ''          | ''         | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'                       | ''                    | ''          | ''         | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                              | ''                    | ''          | ''         | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| ''                                                     | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                     | ''         | ''                  | ''                                     | ''             |
			| ''                                                     | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                              | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                                     | '14.12.2023 16:12:46' | '1'         | '5,71'     | '4,84'       | '0,29'          | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '1'         | '33,33'    | '28,25'      | '1,67'          | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '1'         | '33,33'    | '28,25'      | '1,67'          | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '2'         | '11,41'    | '9,67'       | '0,57'          | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899877'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '2'         | '66,67'    | '56,5'       | '3,33'          | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899877'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '2'         | '66,67'    | '56,5'       | '3,33'          | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899877'        | 'b3fefa15-d15b-4319-946a-10cb1e53e17e' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '20,2'     | '17,12'      | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'S/Yellow' | ''                  | '33027652-ad8b-4e9b-a577-ccbd10be66e4' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '73,33'    | '62,15'      | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | '9aab5db9-aec6-4b53-83b4-9abf09f928f2' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '118'      | '100'        | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'S/Yellow' | ''                  | '33027652-ad8b-4e9b-a577-ccbd10be66e4' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '118'      | '100'        | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'S/Yellow' | ''                  | '33027652-ad8b-4e9b-a577-ccbd10be66e4' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '333,33'   | '282,48'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0512'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '428,34'   | '363'        | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | '9aab5db9-aec6-4b53-83b4-9abf09f928f2' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '428,34'   | '363'        | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '8908899879'        | '9aab5db9-aec6-4b53-83b4-9abf09f928f2' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '1 947,02' | '1 650,02'   | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0512'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '3'         | '1 947,02' | '1 650,02'   | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0512'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '5'         | '22,27'    | '18,88'      | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'UNIQ'     | '0512'              | 'b974016c-56d7-415d-8f5a-f3859d6404ca' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '5'         | '130,11'   | '110,26'     | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'UNIQ'     | '0512'              | 'b974016c-56d7-415d-8f5a-f3859d6404ca' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '5'         | '130,11'   | '110,26'     | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'UNIQ'     | '0512'              | 'b974016c-56d7-415d-8f5a-f3859d6404ca' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '6'         | '666,66'   | '564,97'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0514'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '6'         | '3 894,05' | '3 300,04'   | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0514'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |
			| ''                                                     | '14.12.2023 16:12:46' | '6'         | '3 894,05' | '3 300,04'   | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 315 dated 14.12.2023 16:12:46' | 'PZU'      | '0514'              | 'd103bb73-25db-4a27-915a-f51f024596aa' | ''             |		
		And I close all client application windows

Scenario: _042430 Retail sales receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'    |
			| 'Document registrations records'                        |
		And I close current window
	* Post Retail sales receipt
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail sales receipt 201 dated 15.03.2021 16:01:04'    |
			| 'Document registrations records'                        |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.RetailSalesReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And I select current line in "List" table
		And I select "Completed" exact value from "Status type" drop-down list
		And I click the button named "FormWrite"
		And I close current window
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
