﻿#language: en
@tree
@Positive
@Movements2
@MovementsOpeningEntry

Feature: check Opening entry movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _042900 preparation (Opening entry)
	When set True value to the constant
	When set True value to the constant Use commission trading
	When set True value to the constant Use salary 
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
		When Create catalog Countries objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers, with batch balance details)
		When Create catalog SourceOfOrigins objects
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create catalog Stores (trade agent)
		When Create catalog RetailCustomers objects (check POS)
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog LegalNameContracts objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create information register TaxSettings records (Concignor 1)
		When update ItemKeys
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	When settings for Main Company (commission trade)
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Company settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"	
		And I go to line in "List" table
			| Description     |
			| Main Company    |
		And I select current line in "List" table
		And I move to "Comission trading" tab
		And I click Select button of "Trade agent store" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Trade agent store'    |
		And I select current line in "List" table
		And I click "Save and close" button
		And I close all client application windows
	* Load documents
		When Create document OpeningEntry objects
		When Create document OpeningEntry objects (stock control serial lot numbers)
		When Create document OpeningEntry objects (commission trade)
		When Create document OpeningEntry objects (with source of origin)
		When Create document OpeningEntry objects (salary payment)
		When Create document OpeningEntry objects (employee cash advance)
		When Create document OpeningEntry objects (advance from retail customers)
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(9).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(111).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(1112).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(312).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(313).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(315).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows
		
Scenario: _0429001 check preparation
	When check preparation

Scenario: _042901 check Opening entry movements by the Register  "R4010 Actual stocks"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 2 dated 07.09.2020 21:26:35'   | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| 'Register  "R4010 Actual stocks"'             | ''              | ''                      | ''            | ''             | ''            | ''                     |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            | ''                     |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    | 'Serial lot number'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 01'     | '38/Yellow'   | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 01'     | '36/Red'      | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | 'L/Green'     | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | '38/Yellow'   | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | '36/Red'      | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '200'         | 'Store 02'     | '36/18SD'     | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '300'         | 'Store 01'     | '36/18SD'     | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '400'         | 'Store 01'     | 'XS/Blue'     | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '400'         | 'Store 02'     | 'S/Yellow'    | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '500'         | 'Store 01'     | 'XS/Blue'     | ''                     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '500'         | 'Store 01'     | 'L/Green'     | ''                     |
		And I close all client application windows

Scenario: _042902 check Opening entry movements by the Register  "R4011 Free stocks"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 2 dated 07.09.2020 21:26:35'   | ''              | ''                      | ''            | ''             | ''             |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'               | ''              | ''                      | ''            | ''             | ''             |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                            | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 01'     | '38/Yellow'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 01'     | '36/Red'       |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | 'L/Green'      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | '38/Yellow'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '100'         | 'Store 02'     | '36/Red'       |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '200'         | 'Store 02'     | '36/18SD'      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '300'         | 'Store 01'     | '36/18SD'      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '400'         | 'Store 01'     | 'XS/Blue'      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '400'         | 'Store 02'     | 'S/Yellow'     |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '500'         | 'Store 01'     | 'XS/Blue'      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:35'   | '500'         | 'Store 01'     | 'L/Green'      |
		And I close all client application windows


Scenario: _042903 check Opening entry movements by the Register  "R3010 Cash on hand"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 1 dated 07.09.2020 21:26:04'   | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'              | ''              | ''                      | ''            | ''               | ''               | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '178,4'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'        | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'        | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №1'        | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №2'        | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №2'        | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №3'        | 'EUR'        | 'EUR'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 100'       | 'Main Company'   | 'Front office'   | 'Cash desk №3'        | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '1 712'       | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '5 000'       | 'Main Company'   | 'Front office'   | 'Bank account, USD'   | 'USD'        | 'USD'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '5 000'       | 'Main Company'   | 'Front office'   | 'Bank account, USD'   | 'USD'        | 'USD'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '5 627,5'     | 'Main Company'   | 'Front office'   | 'Cash desk №2'        | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '6 000'       | 'Main Company'   | 'Front office'   | 'Cash desk №3'        | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '8 000'       | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'EUR'        | 'EUR'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '8 800'       | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'USD'        | 'EUR'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '10 000'      | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '10 000'      | 'Main Company'   | 'Front office'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '28 137,5'    | 'Main Company'   | 'Front office'   | 'Bank account, USD'   | 'TRY'        | 'USD'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:04'   | '52 000'      | 'Main Company'   | 'Front office'   | 'Bank account, EUR'   | 'TRY'        | 'EUR'                    | 'Local currency'                 | 'No'                      |
			
		And I close all client application windows

Scenario: _042904 check Opening entry with serial lot numbers movements by the Register  "R4010 Actual stocks"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '1 112'     |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 1 112 dated 20.05.2022 17:07:07'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'                  | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'                 | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                                | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                                | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                                | 'Receipt'       | '20.05.2022 17:07:07'   | '5'           | 'Store 02'     | 'PZU'        | '8908899877'           |
			| ''                                                | 'Receipt'       | '20.05.2022 17:07:07'   | '5'           | 'Store 02'     | 'PZU'        | '8908899879'           |
			| ''                                                | 'Receipt'       | '20.05.2022 17:07:07'   | '5'           | 'Store 02'     | 'UNIQ'       | ''                     |
			| ''                                                | 'Receipt'       | '20.05.2022 17:07:07'   | '5'           | 'Store 02'     | 'UNIQ'       | ''                     |
			| ''                                                | 'Receipt'       | '20.05.2022 17:07:07'   | '10'          | 'Store 02'     | 'XL/Green'   | ''                     |
		And I close all client application windows

Scenario: _042905 check Opening entry movements by the Register  "R1020 Advances to vendors" 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R1020 Advances to vendors" 
		And I click "Registrations report" button
		And I select "R1020 Advances to vendors" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 3 dated 07.09.2020 21:26:50'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                            |
			| 'Register  "R1020 Advances to vendors"'       | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''        | ''                       | ''                            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                    | ''            | ''        | 'Attributes'             | ''                            |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'          | 'Partner'     | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Ferron BP'   | 'Ferron BP'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'EUR'        | 'EUR'                    | 'Big foot'            | 'Big foot'    | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '220'         | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'EUR'                    | 'Big foot'            | 'Big foot'    | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '1 200'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'EUR'                    | 'Big foot'            | 'Big foot'    | ''        | 'No'                     | ''                            |
		And I close all client application windows

Scenario: _042906 check Opening entry movements by the Register  "R2020 Advances from customer" 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '3'         |
	* Check movements by the Register  "R2020 Advances from customer" 
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 3 dated 07.09.2020 21:26:50'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''          | ''        | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''          | ''        | ''                       | ''                              |
			| 'Register  "R2020 Advances from customer"'    | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                  | ''          | ''        | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                  | ''          | ''        | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'        | 'Partner'   | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Kalipso'   | 'Kalipso'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'               | 'DFC'       | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Kalipso'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Kalipso'   | 'Kalipso'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '200'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'               | 'DFC'       | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:26:50'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'               | 'DFC'       | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _042907 check Opening entry movements by the Register  "R1021 Vendors transactions" by partner term 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 4 dated 07.09.2020 21:27:01'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'      | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''                       | ''                            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'                     | 'Basis'   | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows

Scenario: _042908 check Opening entry movements by the Register  "R1021 Vendors transactions" by document
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R1021 Vendors transactions" 
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''                       | ''                            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'      | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''                       | ''                            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | 'Attributes'             | ''                            |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'      | 'Partner'   | 'Agreement'                 | 'Basis'                                       | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                            |
		And I close all client application windows

Scenario: _042909 check Opening entry movements by the Register  "R2021 Customer transactions"  by document
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'          | 'Basis'                                       | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _042910 check Opening entry movements by the Register  "R2021 Customer transactions" by partner term 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R2021 Customer transactions" 
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 5 dated 07.09.2020 21:27:18'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'                       | 'Basis'   | 'Order'   | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | 'No'                     | ''                              |
		And I close all client application windows

Scenario: _042911 check Opening entry movements by the Register  "R5012 Vendors aging" by partner term 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R5012 Vendors aging" 
		And I click "Registrations report" button
		And I select "R5012 Vendors aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''          | ''                                            | ''                      | ''                 |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''          | ''                                            | ''                      | ''                 |
			| 'Register  "R5012 Vendors aging"'             | ''              | ''                      | ''            | ''               | ''               | ''           | ''                     | ''          | ''                                            | ''                      | ''                 |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                     | ''          | ''                                            | ''                      | 'Attributes'       |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Agreement'            | 'Partner'   | 'Invoice'                                     | 'Payment date'          | 'Aging closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'Partner term Maxim'   | 'Maxim'     | 'Opening entry 9 dated 07.09.2020 21:27:57'   | '01.06.2021 00:00:00'   | ''                 |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'Partner term Maxim'   | 'Maxim'     | 'Opening entry 9 dated 07.09.2020 21:27:57'   | '05.06.2021 00:00:00'   | ''                 |
		And I close all client application windows

Scenario: _042912 check Opening entry movements by the Register  "R5011 Customers aging" by partner term 
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R5011 Customers aging" 
		And I click "Registrations report" button
		And I select "R5011 Customers aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                   | ''          | ''                                            | ''                      | ''                 |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''           | ''                   | ''          | ''                                            | ''                      | ''                 |
			| 'Register  "R5011 Customers aging"'           | ''              | ''                      | ''            | ''               | ''               | ''           | ''                   | ''          | ''                                            | ''                      | ''                 |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                   | ''          | ''                                            | ''                      | 'Attributes'       |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Agreement'          | 'Partner'   | 'Invoice'                                     | 'Payment date'          | 'Aging closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'Partner term DFC'   | 'DFC'       | 'Opening entry 9 dated 07.09.2020 21:27:57'   | '01.01.2022 00:00:00'   | ''                 |
		And I close all client application windows

Scenario: _042913 check Opening entry movements by the Register  "R5010 Reconciliation statement" (AP by partner term)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '4'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 4 dated 07.09.2020 21:27:01'    | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                       |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                       |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                       |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''             | ''                       |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'   | 'Legal name contract'    |
			| ''                                             | 'Expense'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'DFC'          | ''                       |
		And I close all client application windows

Scenario: _042914 check Opening entry movements by the Register  "R5010 Reconciliation statement" (AR by partner term)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '5'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 5 dated 07.09.2020 21:27:18'    | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                           |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                           |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''             | ''                           |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''             | ''                           |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'   | 'Legal name contract'        |
			| ''                                             | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'DFC'          | 'DFC Legal name contract'    |
		And I close all client application windows

Scenario: _042915 check Opening entry movements by the Register  "R4010 Actual stocks" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'   | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'              | ''              | ''                      | ''            | ''                    | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'          | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'               | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '20'          | 'Trade agent store'   | 'PZU'        | '8908899879'           |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '30'          | 'Trade agent store'   | 'XS/Blue'    | ''                     |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '100'         | 'Trade agent store'   | 'UNIQ'       | ''                     |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '20'          | 'Store 05'            | 'PZU'        | '8908899879'           |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '30'          | 'Store 05'            | 'XS/Blue'    | ''                     |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '100'         | 'Store 05'            | 'UNIQ'       | ''                     |
		And I close all client application windows

Scenario: _042916 check Opening entry movements by the Register  "R4011 Free stocks" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                | ''              | ''                      | ''            | ''             | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '20'          | 'Store 05'     | 'PZU'         |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '30'          | 'Store 05'     | 'XS/Blue'     |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '100'         | 'Store 05'     | 'UNIQ'        |
		And I close all client application windows

Scenario: _042917 check Opening entry movements by the Register  "R4014 Serial lot numbers" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R4014 Serial lot numbers" 
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'   | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'         | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''        | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'   | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '20'          | 'Main Company'   | ''         | ''        | 'PZU'        | '8908899879'           |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '100'         | 'Main Company'   | ''         | ''        | 'UNIQ'       | '09987897977889'       |
		And I close all client application windows

Scenario: _042918 check Opening entry movements by the Register  "R4050 Stock inventory" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R4050 Stock inventory" 
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'   | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| 'Register  "R4050 Stock inventory"'            | ''              | ''                      | ''            | ''               | ''                    | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                    | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Store'               | 'Item key'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '20'          | 'Main Company'   | 'Trade agent store'   | 'PZU'         |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '30'          | 'Main Company'   | 'Trade agent store'   | 'XS/Blue'     |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '100'         | 'Main Company'   | 'Trade agent store'   | 'UNIQ'        |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '20'          | 'Main Company'   | 'Store 05'            | 'PZU'         |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '30'          | 'Main Company'   | 'Store 05'            | 'XS/Blue'     |
			| ''                                             | 'Expense'       | '01.12.2022 12:41:27'   | '100'         | 'Main Company'   | 'Store 05'            | 'UNIQ'        |
		And I close all client application windows

Scenario: _042919 check Opening entry movements by the Register  "R8010 Trade agent inventory" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R8010 Trade agent inventory" 
		And I click "Registrations report" button
		And I select "R8010 Trade agent inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'   | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                 |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                 |
			| 'Register  "R8010 Trade agent inventory"'      | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                 |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''                | ''                             | ''                 |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Item key'   | 'Partner'         | 'Agreement'                    | 'Legal name'       |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '20'          | 'Main Company'   | 'PZU'        | 'Trade agent 1'   | 'Trade agent partner term 1'   | 'Trade agent 1'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '30'          | 'Main Company'   | 'XS/Blue'    | 'Trade agent 1'   | 'Trade agent partner term 1'   | 'Trade agent 1'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:27'   | '100'         | 'Main Company'   | 'UNIQ'       | 'Trade agent 1'   | 'Trade agent partner term 1'   | 'Trade agent 1'    |
		And I close all client application windows

Scenario: _042920 check Opening entry movements by the Register  "R8011 Trade agent serial lot number" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R8011 Trade agent serial lot number" 
		And I click "Registrations report" button
		And I select "R8011 Trade agent serial lot number" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27'        | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                     |
			| 'Document registrations records'                    | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                     |
			| 'Register  "R8011 Trade agent serial lot number"'   | ''              | ''                      | ''            | ''               | ''           | ''                | ''                             | ''                     |
			| ''                                                  | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''                | ''                             | ''                     |
			| ''                                                  | ''              | ''                      | 'Quantity'    | 'Company'        | 'Item key'   | 'Partner'         | 'Agreement'                    | 'Serial lot number'    |
			| ''                                                  | 'Receipt'       | '01.12.2022 12:41:27'   | '20'          | 'Main Company'   | 'PZU'        | 'Trade agent 1'   | 'Trade agent partner term 1'   | '8908899879'           |
			| ''                                                  | 'Receipt'       | '01.12.2022 12:41:27'   | '100'         | 'Main Company'   | 'UNIQ'       | 'Trade agent 1'   | 'Trade agent partner term 1'   | '09987897977889'       |
		And I close all client application windows

Scenario: _042921 check Opening entry movements by the Register  "T6020 Batch keys info" (shipment to trade agent)
	When set True value to the constant Use commission trading
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "T6020 Batch keys info" 
		And I click "Registrations report" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 14 dated 01.12.2022 12:41:27' | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''                  | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''                  | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| 'Register  "T6020 Batch keys info"'          | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''                  | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Dimensions'   | ''       | ''                  | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Amount tax' | 'Amount cost ratio' | 'Not direct costs' | 'Amount cost' | 'Amount cost tax' | 'Amount revenue' | 'Amount revenue tax' | 'Company'      | 'Branch' | 'Store'             | 'Item key' | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Work' | 'Work sheet' | 'Batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document' |
			| ''                                           | '01.12.2022 12:41:27' | '20'        | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Store 05'          | 'PZU'      | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | '8908899879'        | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:27' | '20'        | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Trade agent store' | 'PZU'      | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | '8908899879'        | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:27' | '30'        | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Store 05'          | 'XS/Blue'  | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:27' | '30'        | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Trade agent store' | 'XS/Blue'  | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:27' | '100'       | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Store 05'          | 'UNIQ'     | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:27' | '100'       | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Trade agent store' | 'UNIQ'     | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
		And I close all client application windows

Scenario: _042922 check Opening entry movements by the Register  "R5010 Reconciliation statement" (AR/AP by documents)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'         |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57'    | ''              | ''                      | ''            | ''               | ''               | ''           | ''                | ''                           |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''               | ''           | ''                | ''                           |
			| 'Register  "R5010 Reconciliation statement"'   | ''              | ''                      | ''            | ''               | ''               | ''           | ''                | ''                           |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''           | ''                | ''                           |
			| ''                                             | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Currency'   | 'Legal name'      | 'Legal name contract'        |
			| ''                                             | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'DFC'             | 'DFC Legal name contract'    |
			| ''                                             | 'Expense'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'DFC'             | 'DFC Legal name contract'    |
			| ''                                             | 'Expense'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'TRY'        | 'Company Maxim'   | ''                           |
		And I close all client application windows

Scenario: _042923 check Opening entry movements by the Register  "R4010 Actual stocks" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R4010 Actual stocks" 
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'   | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| 'Register  "R4010 Actual stocks"'              | ''              | ''                      | ''            | ''             | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '50'          | 'Store 08'     | 'M/White'    | ''                     |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '70'          | 'Store 08'     | 'PZU'        | '8908899877'           |
		And I close all client application windows

Scenario: _042924 check Opening entry movements by the Register  "R4011 Free stocks" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R4011 Free stocks" 
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'   | ''              | ''                      | ''            | ''             | ''            |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                | ''              | ''                      | ''            | ''             | ''            |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '50'          | 'Store 08'     | 'M/White'     |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '70'          | 'Store 08'     | 'PZU'         |
		And I close all client application windows

Scenario: _042925 check Opening entry movements by the Register  "R4014 Serial lot numbers" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R4014 Serial lot numbers" 
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'   | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| 'Register  "R4014 Serial lot numbers"'         | ''              | ''                      | ''            | ''               | ''         | ''        | ''           | ''                     |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''        | ''           | ''                     |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'   | 'Store'   | 'Item key'   | 'Serial lot number'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '70'          | 'Main Company'   | ''         | ''        | 'PZU'        | '8908899877'           |
		And I close all client application windows

Scenario: _042926 check Opening entry movements by the Register  "R8012 Consignor inventory" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R8012 Consignor inventory" 
		And I click "Registrations report" button
		And I select "R8012 Consignor inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'   | ''              | ''                      | ''            | ''               | ''           | ''                    | ''              | ''                           | ''               |
			| 'Document registrations records'               | ''              | ''                      | ''            | ''               | ''           | ''                    | ''              | ''                           | ''               |
			| 'Register  "R8012 Consignor inventory"'        | ''              | ''                      | ''            | ''               | ''           | ''                    | ''              | ''                           | ''               |
			| ''                                             | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''           | ''                    | ''              | ''                           | ''               |
			| ''                                             | ''              | ''                      | 'Quantity'    | 'Company'        | 'Item key'   | 'Serial lot number'   | 'Partner'       | 'Agreement'                  | 'Legal name'     |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'M/White'    | ''                    | 'Consignor 1'   | 'Consignor partner term 1'   | 'Consignor 1'    |
			| ''                                             | 'Receipt'       | '01.12.2022 12:41:39'   | '70'          | 'Main Company'   | 'PZU'        | '8908899877'          | 'Consignor 1'   | 'Consignor partner term 1'   | 'Consignor 1'    |
		And I close all client application windows

Scenario: _042927 check Opening entry movements by the Register  "R8013 Consignor batch wise balance" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R8013 Consignor batch wise balance" 
		And I click "Registrations report" button
		And I select "R8013 Consignor batch wise balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'     | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         | ''                  | ''                 |
			| 'Document registrations records'                 | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         | ''                  | ''                 |
			| 'Register  "R8013 Consignor batch wise balance"' | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         | ''                  | ''                 |
			| ''                                               | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                           | ''         | ''                  | ''                 |
			| ''                                               | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Batch'                                      | 'Item key' | 'Serial lot number' | 'Source of origin' |
			| ''                                               | 'Receipt'     | '01.12.2022 12:41:39' | '50'        | 'Main Company' | 'Store 08' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'M/White'  | ''                  | ''                 |
			| ''                                               | 'Receipt'     | '01.12.2022 12:41:39' | '70'        | 'Main Company' | 'Store 08' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'PZU'      | '8908899877'        | ''                 |
		And I close all client application windows

Scenario: _042928 check Opening entry movements by the Register  "R8015 Consignor prices" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R8015 Consignor prices" 
		And I click "Registrations report" button
		And I select "R8015 Consignor prices" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39'   | ''                      | ''            | ''               | ''              | ''                           | ''                                             | ''           | ''                    | ''                   | ''                               | ''            |
			| 'Document registrations records'               | ''                      | ''            | ''               | ''              | ''                           | ''                                             | ''           | ''                    | ''                   | ''                               | ''            |
			| 'Register  "R8015 Consignor prices"'           | ''                      | ''            | ''               | ''              | ''                           | ''                                             | ''           | ''                    | ''                   | ''                               | ''            |
			| ''                                             | 'Period'                | 'Resources'   | 'Dimensions'     | ''              | ''                           | ''                                             | ''           | ''                    | ''                   | ''                               | ''            |
			| ''                                             | ''                      | 'Price'       | 'Company'        | 'Partner'       | 'Partner term'               | 'Purchase invoice'                             | 'Item key'   | 'Serial lot number'   | 'Source of origin'   | 'Multi currency movement type'   | 'Currency'    |
			| ''                                             | '01.12.2022 12:41:39'   | '8,56'        | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'M/White'    | ''                    | ''                   | 'Reporting currency'             | 'USD'         |
			| ''                                             | '01.12.2022 12:41:39'   | '8,56'        | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'PZU'        | '8908899877'          | ''                   | 'Reporting currency'             | 'USD'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'M/White'    | ''                    | ''                   | 'Local currency'                 | 'TRY'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'M/White'    | ''                    | ''                   | 'TRY'                            | 'TRY'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'M/White'    | ''                    | ''                   | 'en description is empty'        | 'TRY'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'PZU'        | '8908899877'          | ''                   | 'Local currency'                 | 'TRY'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'PZU'        | '8908899877'          | ''                   | 'TRY'                            | 'TRY'         |
			| ''                                             | '01.12.2022 12:41:39'   | '50'          | 'Main Company'   | 'Consignor 1'   | 'Consignor partner term 1'   | 'Opening entry 15 dated 01.12.2022 12:41:39'   | 'PZU'        | '8908899877'          | ''                   | 'en description is empty'        | 'TRY'         |
		
				
		And I close all client application windows

Scenario: _042929 check Opening entry movements by the Register  "T6020 Batch keys info" (receipt from consignor)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "T6020 Batch keys info" 
		And I click "Registrations report" button
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 15 dated 01.12.2022 12:41:39' | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| 'Register  "T6020 Batch keys info"'          | ''                    | ''          | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | ''             | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Dimensions'   | ''       | ''         | ''         | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Amount tax' | 'Amount cost ratio' | 'Not direct costs' | 'Amount cost' | 'Amount cost tax' | 'Amount revenue' | 'Amount revenue tax' | 'Company'      | 'Branch' | 'Store'    | 'Item key' | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Work' | 'Work sheet' | 'Batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document' |
			| ''                                           | '01.12.2022 12:41:39' | '50'        | '2 500'  | '381,36'     | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Store 08' | 'M/White'  | 'Receipt'   | 'Local currency'         | 'TRY'      | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | ''                  | ''                 | ''                    | ''                          |
			| ''                                           | '01.12.2022 12:41:39' | '70'        | '3 500'  | '533,9'      | ''                  | ''                 | ''            | ''                | ''               | ''                   | 'Main Company' | ''       | 'Store 08' | 'PZU'      | 'Receipt'   | 'Local currency'         | 'TRY'      | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                | '8908899877'        | ''                 | ''                    | ''                          |
		And I close all client application windows

Scenario: _042931 check Opening entry movements by the Register  "R9010 Source of origin stock" (source of origin)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '111'       |
	* Check movements by the Register  "R9010 Source of origin stock" 
		And I click "Registrations report" button
		And I select "R9010 Source of origin stock" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 111 dated 08.12.2022 15:48:28'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''           | ''                     | ''                     |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''                          | ''           | ''           | ''                     | ''                     |
			| 'Register  "R9010 Source of origin stock"'      | ''              | ''                      | ''            | ''               | ''                          | ''           | ''           | ''                     | ''                     |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''           | ''                     | ''                     |
			| ''                                              | ''              | ''                      | 'Quantity'    | 'Company'        | 'Branch'                    | 'Store'      | 'Item key'   | 'Source of origin'     | 'Serial lot number'    |
			| ''                                              | 'Receipt'       | '08.12.2022 15:48:28'   | '2'           | 'Main Company'   | 'Distribution department'   | 'Store 01'   | 'XS/Blue'    | 'Source of origin 5'   | ''                     |
			| ''                                              | 'Receipt'       | '08.12.2022 15:48:28'   | '2'           | 'Main Company'   | 'Distribution department'   | 'Store 01'   | 'M/White'    | 'Source of origin 6'   | ''                     |
			| ''                                              | 'Receipt'       | '08.12.2022 15:48:28'   | '2'           | 'Main Company'   | 'Distribution department'   | 'Store 01'   | 'UNIQ'       | 'Source of origin 4'   | '09987897977893'       |
		And I close all client application windows

Scenario: _042932 check Opening entry movements by the Register  "R9510 Salary payment"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '312'       |
	* Check movements by the Register  "R9510 Salary payment" 
		And I click "Registrations report" button
		And I select "R9510 Salary payment" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 312 dated 03.03.2023 11:46:31'   | ''              | ''                      | ''            | ''               | ''         | ''                  | ''                 | ''           | ''                       | ''                                |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''         | ''                  | ''                 | ''           | ''                       | ''                                |
			| 'Register  "R9510 Salary payment"'              | ''              | ''                      | ''            | ''               | ''         | ''                  | ''                 | ''           | ''                       | ''                                |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                  | ''                 | ''           | ''                       | ''                                |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Employee'          | 'Payment period'   | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'    |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '17,12'       | 'Main Company'   | ''         | 'Alexander Orlov'   | ''                 | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '34,24'       | 'Main Company'   | ''         | 'Anna Petrova'      | ''                 | 'USD'        | 'TRY'                    | 'Reporting currency'              |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '100'         | 'Main Company'   | ''         | 'Alexander Orlov'   | ''                 | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '100'         | 'Main Company'   | ''         | 'Alexander Orlov'   | ''                 | 'TRY'        | 'TRY'                    | 'en description is empty'         |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '200'         | 'Main Company'   | ''         | 'Anna Petrova'      | ''                 | 'TRY'        | 'TRY'                    | 'Local currency'                  |
			| ''                                              | 'Receipt'       | '03.03.2023 11:46:31'   | '200'         | 'Main Company'   | ''         | 'Anna Petrova'      | ''                 | 'TRY'        | 'TRY'                    | 'en description is empty'         |
		And I close all client application windows

Scenario: _042933 check Opening entry movements by the Register  "R3027 Employee cash advance"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '313'       |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 313 dated 03.03.2023 16:56:36'   | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Document registrations records'                | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| 'Register  "R3027 Employee cash advance"'       | ''              | ''                      | ''            | ''               | ''         | ''           | ''                       | ''                | ''                               | ''                        |
			| ''                                              | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''           | ''                       | ''                | ''                               | 'Attributes'              |
			| ''                                              | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Currency'   | 'Transaction currency'   | 'Partner'         | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '100'         | 'Main Company'   | ''         | 'USD'        | 'USD'                    | 'David Romanov'   | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '100'         | 'Main Company'   | ''         | 'USD'        | 'USD'                    | 'David Romanov'   | 'en description is empty'        | 'No'                      |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '171,2'       | 'Main Company'   | ''         | 'USD'        | 'TRY'                    | 'Arina Brown'     | 'Reporting currency'             | 'No'                      |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '562,75'      | 'Main Company'   | ''         | 'TRY'        | 'USD'                    | 'David Romanov'   | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '1 000'       | 'Main Company'   | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'     | 'Local currency'                 | 'No'                      |
			| ''                                              | 'Receipt'       | '03.03.2023 16:56:36'   | '1 000'       | 'Main Company'   | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'     | 'en description is empty'        | 'No'                      |
		And I close all client application windows

Scenario: _042934 check Opening entry movements by the Register  "R2023 Advances from retail customers"
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '315'       |
	* Check movements by the Register  "R2023 Advances from retail customers" 
		And I click "Registrations report" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 315 dated 03.03.2023 17:09:42'        | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Document registrations records'                     | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| 'Register  "R2023 Advances from retail customers"'   | ''              | ''                      | ''            | ''               | ''         | ''                   |
			| ''                                                   | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''         | ''                   |
			| ''                                                   | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'   | 'Retail customer'    |
			| ''                                                   | 'Receipt'       | '03.03.2023 17:09:42'   | '1 000'       | 'Main Company'   | ''         | 'Daniel Smith'       |
			| ''                                                   | 'Receipt'       | '03.03.2023 17:09:42'   | '1 000'       | 'Main Company'   | ''         | 'Sam Jons'           |
		And I close all client application windows

Scenario: _042930 Opening entry clear posting/mark for deletion
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 2 dated 07.09.2020 21:26:35'    |
			| 'Document registrations records'               |
		And I close current window
	* Post Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'      |
			| 'R4010 Actual stocks'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 2 dated 07.09.2020 21:26:35'    |
			| 'Document registrations records'               |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '2'         |
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
