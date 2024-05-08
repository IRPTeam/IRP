#language: en
@tree
@Positive
@Movements2
@MovementsRetailReturnReceipt


Feature: check Retail return receipt movements


Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042500 preparation (RetailReturnReceipt)
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
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog CashAccounts objects (POS)
		When Create catalog CashAccounts objects
		When Create Document discount
		When Create catalog Items objects (commission trade)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create information register Taxes records (VAT)
		When Create catalog BankTerms objects
		When Create catalog PaymentTerminals objects
		When Create catalog PaymentTypes objects
		When Create catalog Workstations objects
		When Create catalog RetailCustomers objects (check POS)
		When Create catalog Partners objects and Companies objects (Customer)
		When Create catalog Agreements objects (Customer)
	* Load RetailSalesReceipt
		When Create document RetailSalesReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load PI
		When Create document PurchaseInvoice and PurchaseReturn objects (comission trade)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(195).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(196).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load RetailReturnReceipt
		When Create document RetailReturnReceipt objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (with retail customer)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt and RetailRetutnReceipt objects (with discount) 
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(203).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (stock control serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.RetailReturnReceipt.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RSR and RRR (payment by POS)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1205).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailSalesReceipt and RetailReturnReceipt (consignor)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1113).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Retail sales receipt and Retail return receipt (payment type - bank credit)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(110).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1206).GetObject().Write(DocumentWriteMode.Posting);"    |
		When create RetailGoodsReceipt objects with Retail return receipt
		And I execute 1C:Enterprise script at server
			| "Documents.RetailGoodsReceipt.FindByNumber(1204).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(2207).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document Retail sales receipt and Retail return receipt (certificate)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(16).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(18).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (postponed)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1314).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document RetailReturnReceipt objects (serial lot numbers)
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1115).GetObject().Write(DocumentWriteMode.Posting);"    |


Scenario: _0425001 check preparation
	When check preparation

Scenario: _042501 check Retail return receipt movements by the Register  "R4010 Actual stocks"
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'                        | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'                       | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                                      | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                                      | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '1'           | 'Store 01'     | 'XS/Blue'     | ''                     |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '2'           | 'Store 01'     | '38/Yellow'   | ''                     |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '12'          | 'Store 01'     | '36/18SD'     | ''                     |
		And I close all client application windows

Scenario: _042502 check Retail return receipt movements by the Register  "R4011 Free stocks"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'                        | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                         | ''              | ''                      | ''            | ''             | ''             |
			| ''                                                      | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                      | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '1'           | 'Store 01'     | 'XS/Blue'      |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '2'           | 'Store 01'     | '38/Yellow'    |
			| ''                                                      | 'Receipt'       | '15.03.2021 16:01:25'   | '12'          | 'Store 01'     | '36/18SD'      |
		And I close all client application windows

Scenario: _042503 check Retail return receipt movements by the Register  "R3010 Cash on hand"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25'   | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                        | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                        | ''              | ''                      | ''            | ''               | ''          | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                                      | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                                      | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                                      | 'Expense'       | '15.03.2021 16:01:25'   | '1 664,06'    | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                                      | 'Expense'       | '15.03.2021 16:01:25'   | '9 720'       | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                                      | 'Expense'       | '15.03.2021 16:01:25'   | '9 720'       | 'Main Company'   | 'Shop 01'   | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows


Scenario: _042504 check Retail return receipt movements by the Register  "R2001 Sales"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                  | ''                                     | ''             |
			| 'Document registrations records'                      | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                             | ''                    | ''          | ''          | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                   | ''          | ''                  | ''                                     | ''             |
			| ''                                                    | 'Period'              | 'Resources' | ''          | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                   | ''          | ''                  | ''                                     | ''             |
			| ''                                                    | ''                    | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                            | 'Item key'  | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | ''                  | '27115324-bb2e-4c35-897e-0666d863ed5f' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | ''                  | '27115324-bb2e-4c35-897e-0666d863ed5f' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-8 400'    | '-7 118,64'  | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | ''                  | '27115324-bb2e-4c35-897e-0666d863ed5f' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-12'       | '-1 438,08' | '-1 218,71'  | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '36/18SD'   | ''                  | '27115324-bb2e-4c35-897e-0666d863ed5f' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | ''                  | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | ''                  | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-800'      | '-677,97'    | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | ''                  | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-2'        | '-136,96'   | '-116,07'    | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | '38/Yellow' | ''                  | '0481a0d2-13a8-45ee-b0ea-ad8662cf7edd' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | ''                  | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | ''                  | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-520'      | '-440,68'    | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | ''                  | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''             |
			| ''                                                    | '15.03.2021 16:01:25' | '-1'        | '-89,02'    | '-75,44'     | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 201 dated 15.03.2021 16:01:04' | 'XS/Blue'   | ''                  | 'd7b48944-49d7-4b9b-9a60-0d9a31003b55' | ''             |			
		And I close all client application windows

Scenario: _042505 check Retail return receipt movements by the Register  "R4010 Actual stocks"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 112 dated 20.05.2022 18:28:10'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                          | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                         | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                        | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                        | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:28:10'   | '5'           | 'Store 01'     | 'PZU'        | '8908899877'           |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:28:10'   | '5'           | 'Store 01'     | 'PZU'        | '8908899879'           |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:28:10'   | '10'          | 'Store 01'     | 'XL/Green'   | ''                     |
			| ''                                                        | 'Receipt'       | '20.05.2022 18:28:10'   | '10'          | 'Store 01'     | 'UNIQ'       | ''                     |
		And I close all client application windows

Scenario: _042506 check Retail return receipt movements by the Register  "R4050 Stock inventory"
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''            | ''                    | ''          | ''             | ''         | ''          |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''         | ''          |
			| 'Register  "R4050 Stock inventory"'                   | ''            | ''                    | ''          | ''             | ''         | ''          |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''          |
			| ''                                                    | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key'  |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '1'         | 'Main Company' | 'Store 01' | 'XS/Blue'   |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '2'         | 'Main Company' | 'Store 01' | '38/Yellow' |
			| ''                                                    | 'Receipt'     | '15.03.2021 16:01:25' | '12'        | 'Main Company' | 'Store 01' | '36/18SD'   |		
		And I close all client application windows

Scenario: _042508 check Retail return receipt movements by the Register  "R2021 Customer transactions"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                    | ''      | ''        | ''                     | ''                           |
			| 'Document registrations records'                      | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                    | ''      | ''        | ''                     | ''                           |
			| 'Register  "R2021 Customer transactions"'             | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                    | ''      | ''        | ''                     | ''                           |
			| ''                                                    | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''                     | ''           | ''         | ''                      | ''                                                    | ''      | ''        | 'Attributes'           | ''                           |
			| ''                                                    | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner'  | 'Agreement'             | 'Basis'                                               | 'Order' | 'Project' | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Receipt'     | '28.07.2021 14:03:40' | '-89,02'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '-520'      | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |
			| ''                                                    | 'Expense'     | '28.07.2021 14:03:40' | '-89,02'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Customer'   | 'Customer' | 'Customer partner term' | 'Retail return receipt 202 dated 28.07.2021 14:03:40' | ''      | ''        | 'No'                   | ''                           |		
		And I close all client application windows

Scenario: _042509 check Retail return receipt movements by the Register  "R5010 Reconciliation statement"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '202'       |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 202 dated 28.07.2021 14:03:40'   | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Document registrations records'                        | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Register  "R5010 Reconciliation statement"'            | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| ''                                                      | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''           | ''             | ''                       |
			| ''                                                      | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Currency'   | 'Legal name'   | 'Legal name contract'    |
			| ''                                                      | 'Receipt'       | '28.07.2021 14:03:40'   | '-520'        | 'Main Company'   | 'Shop 01'   | 'TRY'        | 'Customer'     | ''                       |
			| ''                                                      | 'Receipt'       | '28.07.2021 14:03:40'   | '520'         | 'Main Company'   | 'Shop 01'   | 'TRY'        | 'Customer'     | ''                       |
		And I close all client application windows


Scenario: _042510 check Retail return receipt movements by the Register  "R2005 Sales special offers"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '203'       |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 203 dated 09.08.2021 11:41:58'   | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''           | ''                                       | ''                    |
			| 'Document registrations records'                        | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''           | ''                                       | ''                    |
			| 'Register  "R2005 Sales special offers"'                | ''                      | ''               | ''             | ''                | ''                   | ''               | ''          | ''                               | ''           | ''                                                     | ''           | ''                                       | ''                    |
			| ''                                                      | 'Period'                | 'Resources'      | ''             | ''                | ''                   | 'Dimensions'     | ''          | ''                               | ''           | ''                                                     | ''           | ''                                       | ''                    |
			| ''                                                      | ''                      | 'Sales amount'   | 'Net amount'   | 'Offers amount'   | 'Net offer amount'   | 'Company'        | 'Branch'    | 'Multi currency movement type'   | 'Currency'   | 'Invoice'                                              | 'Item key'   | 'Row key'                                | 'Special offer'       |
			| ''                                                      | '09.08.2021 11:41:58'   | '-8 260,02'      | '-7 000,02'    | '-777,78'         | ''                   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'    | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-8 260,02'      | '-7 000,02'    | '-777,78'         | ''                   | 'Main Company'   | 'Shop 01'   | 'TRY'                            | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'    | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-8 260,02'      | '-7 000,02'    | '-777,78'         | ''                   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'    | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-1 414,12'      | '-1 198,4'     | '-133,16'         | ''                   | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | '36/18SD'    | '996e771d-7b70-4d2f-9a32-f92836115173'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-468'           | '-396,61'      | '-44,07'          | ''                   | 'Main Company'   | 'Shop 01'   | 'Local currency'                 | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'    | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-468'           | '-396,61'      | '-44,07'          | ''                   | 'Main Company'   | 'Shop 01'   | 'TRY'                            | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'    | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-468'           | '-396,61'      | '-44,07'          | ''                   | 'Main Company'   | 'Shop 01'   | 'en description is empty'        | 'TRY'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'    | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
			| ''                                                      | '09.08.2021 11:41:58'   | '-80,12'         | '-67,9'        | '-7,54'           | ''                   | 'Main Company'   | 'Shop 01'   | 'Reporting currency'             | 'USD'        | 'Retail sales receipt 203 dated 09.08.2021 11:39:42'   | 'XS/Blue'    | '8c5b09d8-ec48-4846-be01-39bd9dc72d58'   | 'DocumentDiscount'    |
		And I close all client application windows

Scenario: _042511 check Retail return receipt movements by the Register  "R2005 Sales special offers"
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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

Scenario: _042512 check Retail return receipt movements by the Register  "R5021 Revenues"
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '203'       |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 203 dated 09.08.2021 11:41:58' | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'                      | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'                          | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                                    | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                                    | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'TRY'                          | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-7 000,02' | '-8 260,02'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'TRY'      | ''                    | 'en description is empty'      | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-1 198,4'  | '-1 414,12'         | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | '36/18SD'  | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'TRY'                          | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-396,61'   | '-468'              | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'en description is empty'      | ''        |
			| ''                                                    | '09.08.2021 11:41:58' | '-67,9'     | '-80,12'            | 'Main Company' | 'Shop 01' | 'Shop 01'            | 'Revenue'      | 'XS/Blue'  | 'USD'      | ''                    | 'Reporting currency'           | ''        |
		And I close all client application windows

Scenario: _042513 check Retail return receipt movements by the Register  "R3050 Pos cash balances" (payment by POS, not PostponedPayment) 
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 204'     |
	* Check movements by the Register  "R3050 Pos cash balances"
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 204 dated 27.06.2022 16:10:43' | ''                    | ''          | ''           | ''             | ''        | ''                   | ''             | ''                    |
			| 'Document registrations records'                        | ''                    | ''          | ''           | ''             | ''        | ''                   | ''             | ''                    |
			| 'Register  "R3050 Pos cash balances"'                   | ''                    | ''          | ''           | ''             | ''        | ''                   | ''             | ''                    |
			| ''                                                      | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''        | ''                   | ''             | ''                    |
			| ''                                                      | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'  | 'Account'            | 'Payment type' | 'Payment terminal'    |
			| ''                                                      | '27.06.2022 16:10:43' | '-468'      | '-4,68'      | 'Main Company' | 'Shop 01' | 'POS account 1, TRY' | 'Card 01'      | 'Payment terminal 01' |
		And I close all client application windows

Scenario: _042514 check Retail return receipt movements by the Register  "R3010 Cash on hand" (payment by POS, not PostponedPayment) 
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 204'     |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 204 dated 27.06.2022 16:10:43'   | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'                          | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'                          | ''              | ''                      | ''            | ''               | ''          | ''                     | ''           | ''                       | ''                               | ''                        |
			| ''                                                        | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                     | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                                        | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'              | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                                        | 'Expense'       | '27.06.2022 16:10:43'   | '80,12'       | 'Main Company'   | 'Shop 01'   | 'POS account 1, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                                        | 'Expense'       | '27.06.2022 16:10:43'   | '468'         | 'Main Company'   | 'Shop 01'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                                        | 'Expense'       | '27.06.2022 16:10:43'   | '468'         | 'Main Company'   | 'Shop 01'   | 'POS account 1, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
		And I close all client application windows


Scenario: _042515 check Retail return receipt movements by the Register  "R3022 Cash in transit (outgoing)" (payment by POS, not PostponedPayment) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 204'     |
	* Check movements by the Register  "R3022 Cash in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R3022 Cash in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3022 Cash in transit (outgoing)"    |
		And I close all client application windows

Scenario: _042516 check Retail return receipt movements by the Register  "R3022 Cash in transit (outgoing)" (payment by POS, PostponedPayment) 
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 205'     |
	* Check movements by the Register  "R3022 Cash in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R3022 Cash in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 205 dated 27.06.2022 16:11:19' | ''            | ''                    | ''          | ''           | ''             | ''        | ''                                     | ''                             | ''         | ''                     | ''                                                      | ''                     |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''             | ''        | ''                                     | ''                             | ''         | ''                     | ''                                                      | ''                     |
			| 'Register  "R3022 Cash in transit (outgoing)"'          | ''            | ''                    | ''          | ''           | ''             | ''        | ''                                     | ''                             | ''         | ''                     | ''                                                      | ''                     |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | ''           | 'Dimensions'   | ''        | ''                                     | ''                             | ''         | ''                     | ''                                                      | 'Attributes'           |
			| ''                                                      | ''            | ''                    | 'Amount'    | 'Commission' | 'Company'      | 'Branch'  | 'Account'                              | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis'                                                 | 'Deferred calculation' |
			| ''                                                      | 'Receipt'     | '27.06.2022 16:11:19' | '123,26'    | '1,23'       | 'Main Company' | 'Shop 01' | 'POS account 1, TRY' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Retail return receipt 1 205 dated 27.06.2022 16:11:19' | 'No'                   |
			| ''                                                      | 'Receipt'     | '27.06.2022 16:11:19' | '719,99'    | '7,2'        | 'Main Company' | 'Shop 01' | 'POS account 1, TRY' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Retail return receipt 1 205 dated 27.06.2022 16:11:19' | 'No'                   |
			| ''                                                      | 'Receipt'     | '27.06.2022 16:11:19' | '719,99'    | '7,2'        | 'Main Company' | 'Shop 01' | 'POS account 1, TRY' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Retail return receipt 1 205 dated 27.06.2022 16:11:19' | 'No'                   |
			| ''                                                      | 'Receipt'     | '27.06.2022 16:11:19' | '719,99'    | '7,2'        | 'Main Company' | 'Shop 01' | 'POS account 1, TRY' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Retail return receipt 1 205 dated 27.06.2022 16:11:19' | 'No'                   |
		And I close all client application windows

Scenario: _042517 check Retail return receipt movements by the Register  "R3010 Cash on hand" (payment by POS, PostponedPayment) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 205'     |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3010 Cash on hand"    |
		And I close all client application windows


Scenario: _042518 check Retail return receipt movements by the Register  "R2001 Sales" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''                    | ''          | ''        | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'                        | ''                    | ''          | ''        | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                               | ''                    | ''          | ''        | ''           | ''              | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| ''                                                      | 'Period'              | 'Resources' | ''        | ''           | ''              | 'Dimensions'   | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| ''                                                      | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                               | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-205,44' | '-205,44'    | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | ''              | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | ''              | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | ''              | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-188,32' | '-159,59'    | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''             |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-178,05' | '-150,89'    | ''              | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''             |		
		And I close all client application windows

Scenario: _042519 check Retail return receipt movements by the Register  "R2002 Sales returns" (consignor stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''                    | ''          | ''        | ''           | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Document registrations records'                        | ''                    | ''          | ''        | ''           | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Register  "R2002 Sales returns"'                       | ''                    | ''          | ''        | ''           | ''             | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| ''                                                      | 'Period'              | 'Resources' | ''        | ''           | 'Dimensions'   | ''        | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | 'Attributes'           |
			| ''                                                      | ''                    | 'Quantity'  | 'Amount'  | 'Net amount' | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Invoice'                                               | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Return reason' | 'Sales person' | 'Deferred calculation' |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'  | '-1 200'     | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-205,44' | '-205,44'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100'  | '-932,2'     | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | 'Main Company' | 'Shop 01' | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | 'Main Company' | 'Shop 01' | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040'  | '-881,36'    | 'Main Company' | 'Shop 01' | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-188,32' | '-159,59'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-178,05' | '-150,89'    | 'Main Company' | 'Shop 01' | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' | ''              | ''             | 'No'                   |	
		And I close all client application windows


	
Scenario: _042521 check Retail return receipt movements by the Register  "R2050 Retail sales" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R2050 Retail sales"
		And I click "Registrations report" button
		And I select "R2050 Retail sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                      | ''         | ''                  | ''                                     |
			| 'Document registrations records'                        | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                      | ''         | ''                  | ''                                     |
			| 'Register  "R2050 Retail sales"'                        | ''                    | ''          | ''       | ''           | ''              | ''             | ''        | ''         | ''             | ''                                                      | ''         | ''                  | ''                                     |
			| ''                                                      | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''        | ''         | ''             | ''                                                      | ''         | ''                  | ''                                     |
			| ''                                                      | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'  | 'Store'    | 'Sales person' | 'Retail sales receipt'                                  | 'Item key' | 'Serial lot number' | 'Row key'                              |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200' | '-1 200'     | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'XL/Green' | ''                  | '4474defc-f03b-49cb-b7f0-3375b0cb7fdd' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 100' | '-932,2'     | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44'  | 'UNIQ'     | '0514'              | 'c6dfd8cf-4eec-4200-a618-f67121718cb3' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-1 040' | '-881,36'    | ''              | 'Main Company' | 'Shop 01' | 'Store 02' | ''             | 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | 'XS/Blue'  | ''                  | '57bbb717-2bd9-4f1b-8b07-1e0b4c2839a4' |		
		And I close all client application windows

Scenario: _042522 check Retail return receipt movements by the Register  "R4010 Actual stocks" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'                       | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '2'         | 'Store 02'   | 'XS/Blue'  | ''                  |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '2'         | 'Store 02'   | 'UNIQ'     | ''                  |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '3'         | 'Store 02'   | 'XL/Green' | ''                  |		
		And I close all client application windows

Scenario: _042523 check Retail return receipt movements by the Register  "R4011 Free stocks" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                         | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '2'         | 'Store 02'   | 'XS/Blue'  |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '2'         | 'Store 02'   | 'UNIQ'     |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '3'         | 'Store 02'   | 'XL/Green' |		
		And I close all client application windows

Scenario: _042524 check Retail return receipt movements by the Register  "R4014 Serial lot numbers" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'                  | ''            | ''                    | ''          | ''             | ''        | ''      | ''         | ''                  |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''      | ''         | ''                  |
			| ''                                                      | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch'  | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                                      | 'Receipt'     | '14.11.2022 13:57:09' | '2'         | 'Main Company' | 'Shop 01' | ''      | 'UNIQ'     | '0514'              |		
		And I close all client application windows

Scenario: _042525 check Retail sales receipt absence movements by the Register  "R4050 Stock inventory" (consignor and own stocks) 
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report info" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''                    | ''           | ''             | ''         | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'                     | ''                    | ''           | ''             | ''         | ''         | ''         |
			| ''                                                      | 'Period'              | 'RecordType' | 'Company'      | 'Store'    | 'Item key' | 'Quantity' |
			| ''                                                      | '14.11.2022 13:57:09' | 'Receipt'    | 'Main Company' | 'Store 02' | 'XS/Blue'  | '2'        |	
		And I close all client application windows

Scenario: _042527 check Retail return receipt movements by the Register  "R8014 Consignor sales" (consignor and own stocks)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 113'     |
	* Check movements by the Register  "R8014 Consignor sales"
		And I click "Registrations report" button
		And I select "R8014 Consignor sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 113 dated 14.11.2022 13:57:09' | ''                    | ''          | ''           | ''        | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| 'Document registrations records'                        | ''                    | ''          | ''           | ''        | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| 'Register  "R8014 Consignor sales"'                     | ''                    | ''          | ''           | ''        | ''                                     | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| ''                                                      | 'Period'              | 'Resources' | ''           | ''        | 'Dimensions'                           | ''             | ''               | ''                    | ''                                                     | ''                        | ''         | ''                  | ''                 | ''     | ''                        | ''                          | ''                             | ''         | ''                  | ''                       | ''      |
			| ''                                                      | ''                    | 'Quantity'  | 'Net amount' | 'Amount'  | 'DELETE row key'                       | 'Company'      | 'DELETE partner' | 'DELETE Partner term' | 'Sales invoice'                                        | 'DELETE purchase invoice' | 'Item key' | 'Serial lot number' | 'Source of origin' | 'Unit' | 'Price type'              | 'DELETE dont calculate row' | 'Multi currency movement type' | 'Currency' | 'Price include tax' | 'DELETE consignor price' | 'Price' |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'     | '-1 200'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Local currency'               | 'TRY'      | 'No'                | ''                       | '400'   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'     | '-1 200'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'TRY'                          | 'TRY'      | 'No'                | ''                       | '400'   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-1 200'     | '-1 200'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'en description is empty'      | 'TRY'      | 'No'                | ''                       | '400'   |
			| ''                                                      | '14.11.2022 13:57:09' | '-3'        | '-205,44'    | '-205,44' | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'XL/Green' | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Reporting currency'           | 'USD'      | 'No'                | ''                       | '68,48' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-932,2'     | '-1 100'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Local currency'               | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-932,2'     | '-1 100'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'TRY'                          | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-932,2'     | '-1 100'  | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'en description is empty'      | 'TRY'      | 'No'                | ''                       | '466,1' |
			| ''                                                      | '14.11.2022 13:57:09' | '-2'        | '-159,59'    | '-188,32' | '                                    ' | 'Main Company' | ''               | ''                    | 'Retail sales receipt 1 113 dated 14.11.2022 13:29:44' | ''                        | 'UNIQ'     | ''                  | ''                 | 'pcs'  | 'en description is empty' | 'No'                        | 'Reporting currency'           | 'USD'      | 'No'                | ''                       | '79,8'  |
		And I close all client application windows


Scenario: _042531 check Retail return receipt movements by the Register  "R5015 Other partners transactions" (bank credit)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 206'     |
	* Check movements by the Register  "R5015 Other partners transactions"
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 206 dated 01.02.2023 10:28:22' | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| 'Document registrations records'                        | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| 'Register  "R5015 Other partners transactions"'         | ''            | ''                    | ''          | ''             | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | ''                     |
			| ''                                                      | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''                             | ''         | ''                     | ''           | ''        | ''          | ''      | 'Attributes'           |
			| ''                                                      | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name' | 'Partner' | 'Agreement' | 'Basis' | 'Deferred calculation' |
			| ''                                                      | 'Receipt'     | '01.02.2023 10:28:22' | '-5 750'    | 'Main Company' | 'Shop 02' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
			| ''                                                      | 'Receipt'     | '01.02.2023 10:28:22' | '-5 750'    | 'Main Company' | 'Shop 02' | 'TRY'                          | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
			| ''                                                      | 'Receipt'     | '01.02.2023 10:28:22' | '-5 750'    | 'Main Company' | 'Shop 02' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |
			| ''                                                      | 'Receipt'     | '01.02.2023 10:28:22' | '-984,4'    | 'Main Company' | 'Shop 02' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Bank 1'     | 'Bank 1'  | 'Bank 1'    | ''      | 'No'                   |	
		And I close all client application windows

Scenario: _042532 check Retail return receipt movements by the Register  "R5010 Reconciliation statement" (bank credit)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 206'     |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 206 dated 01.02.2023 10:28:22'   | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Document registrations records'                          | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| 'Register  "R5010 Reconciliation statement"'              | ''              | ''                      | ''            | ''               | ''          | ''           | ''             | ''                       |
			| ''                                                        | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''           | ''             | ''                       |
			| ''                                                        | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Currency'   | 'Legal name'   | 'Legal name contract'    |
			| ''                                                        | 'Receipt'       | '01.02.2023 10:28:22'   | '-5 750'      | 'Main Company'   | 'Shop 02'   | 'TRY'        | 'Bank 1'       | ''                       |
		And I close all client application windows

Scenario: _042533 check Retail return receipt movements absence by the Register  "R3010 Cash on hand" (bank credit) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 206'     |
	* Check movements by the Register  "R3010 Cash on hand"
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3010 Cash on hand"    |
		And I close all client application windows

Scenario: _042533 check Retail return receipt movements absence by the Register  "R3050 Pos cash balances" (bank credit) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 206'     |
	* Check movements by the Register  "R3050 Pos cash balances"
		And I click "Registrations report" button
		And I select "R3050 Pos cash balances" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R3050 Pos cash balances"    |
		And I close all client application windows

Scenario: _042534 check Retail return receipt movements by the Register  "R3011 Cash flow"
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R3011 Cash flow"
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25' | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'                      | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'                         | ''                    | ''          | ''             | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                                    | 'Period'              | 'Resources' | 'Dimensions'   | ''        | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                                    | ''                    | 'Amount'    | 'Company'      | 'Branch'  | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                                    | '15.03.2021 16:01:25' | '1 664,06'  | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                                    | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                                    | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'TRY'                          | 'No'                   |
			| ''                                                    | '15.03.2021 16:01:25' | '9 720'     | 'Main Company' | 'Shop 01' | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Shop 01'          | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows


Scenario: _042535 check Retail return receipt movements absence by the Register  "R4011 Free stocks" (RGR exist) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 207'     |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4011 Free stocks"    |
		And I close all client application windows

Scenario: _042536 check Retail return receipt movements absence by the Register  "R4010 Actual stocks" (RGR exist) 
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '2 207'     |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4010 Actual stocks"    |
		And I close all client application windows

Scenario: _042537 check Retail return receipt movements by the Register  "R2006 Certificates" (Return of a product paid for with a certificate)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '12'       |
	* Check movements by the Register  "R2006 Certificates"
		And I click "Registrations report info" button
		And I select "R2006 Certificates" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 12 dated 22.08.2023 14:22:30' | ''                    | ''         | ''                  | ''         | ''       | ''              |
			| 'Register  "R2006 Certificates"'                     | ''                    | ''         | ''                  | ''         | ''       | ''              |
			| ''                                                   | 'Period'              | 'Currency' | 'Serial lot number' | 'Quantity' | 'Amount' | 'Movement type' |
			| ''                                                   | '22.08.2023 14:22:30' | 'TRY'      | '99999999999'       | '1'        | '500'    | 'ReturnUsed'    |	
		And I close all client application windows

Scenario: _042538 check Retail return receipt movements by the Register  "R2006 Certificates" (Return of an unused certificate)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '14'       |
	* Check movements by the Register  "R2006 Certificates"
		And I click "Registrations report" button
		And I select "R2006 Certificates" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 14 dated 22.08.2023 14:57:38' | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| 'Document registrations records'                     | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| 'Register  "R2006 Certificates"'                     | ''                    | ''          | ''       | ''           | ''                  | ''              |
			| ''                                                   | 'Period'              | 'Resources' | ''       | 'Dimensions' | ''                  | 'Attributes'    |
			| ''                                                   | ''                    | 'Quantity'  | 'Amount' | 'Currency'   | 'Serial lot number' | 'Movement type' |
			| ''                                                   | '22.08.2023 14:57:38' | '-1'        | '-300'   | 'TRY'        | '99999999998'       | 'Return'        |		
		And I close all client application windows

Scenario: _042540 check Retail return receipt movements by the Register  "R2001 Sales" (serial lot numbers)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '1 115'    |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | ''                    | ''          | ''          | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| 'Document registrations records'                        | ''                    | ''          | ''          | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| 'Register  "R2001 Sales"'                               | ''                    | ''          | ''          | ''           | ''              | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| ''                                                      | 'Period'              | 'Resources' | ''          | ''           | ''              | 'Dimensions'   | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''             |
			| ''                                                      | ''                    | 'Quantity'  | 'Amount'    | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                               | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Sales person' |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-666,66'   | '-564,97'    | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-22,27'    | '-18,87'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-333,33'   | '-282,49'    | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | ''              | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | ''              | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | ''              | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-73,33'    | '-62,15'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-20,2'     | '-17,12'     | ''              | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | '-3,33'         | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-11,41'    | '-9,67'      | '-0,57'         | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | '-1,67'         | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-5,71'     | '-4,84'      | '-0,29'         | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''             |	
		And I close all client application windows


Scenario: _042541 check Retail return receipt movements by the Register  "R2002 Sales returns" (serial lot numbers)
		And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'   |
			| '1 115'    |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | ''                    | ''          | ''          | ''           | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Document registrations records'                        | ''                    | ''          | ''          | ''           | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| 'Register  "R2002 Sales returns"'                       | ''                    | ''          | ''          | ''           | ''             | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | ''                     |
			| ''                                                      | 'Period'              | 'Resources' | ''          | ''           | 'Dimensions'   | ''       | ''                             | ''         | ''                                                      | ''         | ''                  | ''                                     | ''              | ''             | 'Attributes'           |
			| ''                                                      | ''                    | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Invoice'                                               | 'Item key' | 'Serial lot number' | 'Row key'                              | 'Return reason' | 'Sales person' | 'Deferred calculation' |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-3 894,07' | '-3 300,06'  | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-6'        | '-666,66'   | '-564,97'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0514'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-130,1'    | '-110,25'    | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-5'        | '-22,27'    | '-18,87'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'UNIQ'     | '0512'              | '5b285fd4-8073-4d00-82b8-c251cb774ce9' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-1 947,04' | '-1 650,03'  | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-428,34'   | '-363'       | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-333,33'   | '-282,49'    | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '0512'              | '216a1b58-ce95-4b53-b3ff-a84088046cd3' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-117,99'   | '-99,99'     | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-73,33'    | '-62,15'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '73b72e3d-42b0-46cc-9eec-c515c85c8100' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-3'        | '-20,2'     | '-17,12'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'S/Yellow' | ''                  | 'f54f9f5b-ddc3-4ce8-843f-7fe1df04c15d' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-66,67'    | '-56,5'      | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-2'        | '-11,41'    | '-9,67'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899877'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | 'Main Company' | ''       | 'TRY'                          | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-33,33'    | '-28,25'     | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |
			| ''                                                      | '14.12.2023 19:07:10' | '-1'        | '-5,71'     | '-4,84'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'Retail return receipt 1 115 dated 14.12.2023 19:07:10' | 'PZU'      | '8908899879'        | '453ac288-74b3-46c2-9ca0-fe5a9891788a' | ''              | ''             | 'No'                   |	
		And I close all client application windows

Scenario: _042539 check postponed Retail return receipt movements
	And I close all client application windows
	* Select postponed Retail return receipt (without reserve)
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
	* Check movements
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 1 314 dated 07.09.2023 17:35:13' |
			| 'Document registrations records'                        |
		And I close current window
	* Change status (Postponed with reserve)
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
		And I select current line in "List" table
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
			| 'Register  "R4012 Stock Reservation"' |
			| 'Register  "R4011 Free stocks"'       |
		And I close all client application windows
	* Change status (Canceled)
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '1 314'     |
		And I select current line in "List" table
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

Scenario: _042530 Retail return receipt clear posting/mark for deletion
	And I close all client application windows
	* Select Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25'    |
			| 'Document registrations records'                         |
		And I close current window
	* Post Retail return receipt
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
			| 'Retail return receipt 201 dated 15.03.2021 16:01:25'    |
			| 'Document registrations records'                         |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.RetailReturnReceipt"
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
