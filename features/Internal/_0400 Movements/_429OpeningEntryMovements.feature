#language: en
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create OtherPartners objects
		When Create information register Taxes records (VAT)
		When Create catalog EmployeePositions objects
		When Create catalog SalaryCalculationType objects
		When Create catalog PlanningPeriods objects
		When Create catalog AccrualAndDeductionTypes objects
		When Create catalog EmployeeSchedule objects
		When Create information register T9500S_AccrualAndDeductionValues records
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
		When Create document OpeningEntry objects (other partner)
		When Create document OpeningEntry objects (cash in transit)
		When Create document OpeningEntry objects (employee for movements)
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
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(121).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(122).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.OpeningEntry.FindByNumber(222).GetObject().Write(DocumentWriteMode.Posting);"    |
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
			| 'Opening entry 3 dated 07.09.2020 21:26:50' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''          | ''        | ''                     | ''                         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''          | ''        | ''                     | ''                         |
			| 'Register  "R1020 Advances to vendors"'     | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''          | ''        | ''                     | ''                         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                  | ''          | ''      | ''          | ''        | 'Attributes'           | ''                         |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'        | 'Partner'   | 'Order' | 'Agreement' | 'Project' | 'Deferred calculation' | 'Vendors advances closing' |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '17,12'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | 'No'                   | ''                         |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '100'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | 'No'                   | ''                         |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '100'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Ferron BP' | 'Ferron BP' | ''      | ''          | ''        | 'No'                   | ''                         |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '200'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'EUR'      | 'EUR'                  | 'Big foot'          | 'Big foot'  | ''      | ''          | ''        | 'No'                   | ''                         |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '220'       | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'EUR'                  | 'Big foot'          | 'Big foot'  | ''      | ''          | ''        | 'No'                   | ''                         |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '1 200'     | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'EUR'                  | 'Big foot'          | 'Big foot'  | ''      | ''          | ''        | 'No'                   | ''                         |
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
			| 'Opening entry 3 dated 07.09.2020 21:26:50' | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''      | ''          | ''          | ''                     | ''                           |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''      | ''          | ''          | ''                     | ''                           |
			| 'Register  "R2020 Advances from customer"'  | ''            | ''                    | ''          | ''             | ''             | ''                             | ''         | ''                     | ''                | ''        | ''      | ''          | ''          | ''                     | ''                           |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                             | ''         | ''                     | ''                | ''        | ''      | ''          | ''          | 'Attributes'           | ''                           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'       | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner' | 'Order' | 'Agreement' | 'Project'   | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '17,12'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Company Kalipso' | 'Kalipso' | ''      | ''          | ''          | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '34,24'     | 'Main Company' | 'Front office' | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'DFC'             | 'DFC'     | ''      | ''          | ''          | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '100'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Company Kalipso' | 'Kalipso' | ''      | ''          | ''          | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '100'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Company Kalipso' | 'Kalipso' | ''      | ''          | ''          | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '200'       | 'Main Company' | 'Front office' | 'Local currency'               | 'TRY'      | 'TRY'                  | 'DFC'             | 'DFC'     | ''      | ''          | ''          | 'No'                   | ''                           |
			| ''                                          | 'Receipt'     | '07.09.2020 21:26:50' | '200'       | 'Main Company' | 'Front office' | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'DFC'             | 'DFC'     | ''      | ''          | ''          | 'No'                   | ''                           |
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
			| 'Opening entry 4 dated 07.09.2020 21:27:01'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'      | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''        | ''                       | ''                            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                              | ''        | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'                     | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:01'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Vendor by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                            |
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
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'      | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''        | ''                       | ''                            |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''                | ''          | ''                          | ''                                            | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'      | 'Partner'   | 'Agreement'                 | 'Basis'                                       | 'Order'   | 'Project' | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'             | 'DFC'       | 'Partner term vendor DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Company Maxim'   | 'Maxim'     | 'Partner term Maxim'        | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                            |
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
			| 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''        | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                   | ''                                            | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'          | 'Basis'                                       | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '34,24'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:57'   | '200'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'Partner term DFC'   | 'Opening entry 9 dated 07.09.2020 21:27:57'   | ''        | ''        | 'No'                     | ''                              |
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
			| 'Opening entry 5 dated 07.09.2020 21:27:18'   | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''        | ''                       | ''                              |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''        | ''                       | ''                              |
			| 'Register  "R2021 Customer transactions"'     | ''              | ''                      | ''            | ''               | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''        | ''                       | ''                              |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''               | ''                               | ''           | ''                       | ''             | ''          | ''                                | ''        | ''        | ''        | 'Attributes'             | ''                              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'   | 'Partner'   | 'Agreement'                       | 'Basis'   | 'Order'   | 'Project' | 'Deferred calculation'   | 'Customers advances closing'    |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '17,12'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                              |
			| ''                                            | 'Receipt'       | '07.09.2020 21:27:18'   | '100'         | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'DFC'          | 'DFC'       | 'DFC Customer by Partner terms'   | ''        | ''        | ''        | 'No'                     | ''                              |
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
			| 'Opening entry 15 dated 01.12.2022 12:41:39' | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| 'Register  "R4010 Actual stocks"'            | ''            | ''                    | ''          | ''           | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '01.12.2022 12:41:39' | '50'        | 'Store 08'   | 'M/Black'  | ''                  |
			| ''                                           | 'Receipt'     | '01.12.2022 12:41:39' | '70'        | 'Store 08'   | 'UNIQ'     | ''                  |		
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
			| 'Opening entry 15 dated 01.12.2022 12:41:39' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'              | ''            | ''                    | ''          | ''           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                           | 'Receipt'     | '01.12.2022 12:41:39' | '50'        | 'Store 08'   | 'M/Black'  |
			| ''                                           | 'Receipt'     | '01.12.2022 12:41:39' | '70'        | 'Store 08'   | 'UNIQ'     |		
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
			| 'Opening entry 15 dated 01.12.2022 12:41:39' | ''            | ''                    | ''          | ''             | ''       | ''      | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''       | ''      | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'       | ''            | ''                    | ''          | ''             | ''       | ''      | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''      | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Branch' | 'Store' | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '01.12.2022 12:41:39' | '70'        | 'Main Company' | ''       | ''      | 'UNIQ'     | '0514'              |		
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
			| 'Opening entry 15 dated 01.12.2022 12:41:39' | ''                    | ''          | ''             | ''            | ''                         | ''                                           | ''         | ''                  | ''                     | ''                             | ''         |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''            | ''                         | ''                                           | ''         | ''                  | ''                     | ''                             | ''         |
			| 'Register  "R8015 Consignor prices"'         | ''                    | ''          | ''             | ''            | ''                         | ''                                           | ''         | ''                  | ''                     | ''                             | ''         |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''            | ''                         | ''                                           | ''         | ''                  | ''                     | ''                             | ''         |
			| ''                                           | ''                    | 'Price'     | 'Company'      | 'Partner'     | 'Partner term'             | 'Purchase invoice'                           | 'Item key' | 'Serial lot number' | 'Source of origin'     | 'Multi currency movement type' | 'Currency' |
			| ''                                           | '01.12.2022 12:41:39' | '8,56'      | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'UNIQ'     | '0514'              | 'Source of origin 909' | 'Reporting currency'           | 'USD'      |
			| ''                                           | '01.12.2022 12:41:39' | '8,56'      | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'M/Black'  | ''                  | ''                     | 'Reporting currency'           | 'USD'      |
			| ''                                           | '01.12.2022 12:41:39' | '50'        | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'UNIQ'     | '0514'              | 'Source of origin 909' | 'Local currency'               | 'TRY'      |
			| ''                                           | '01.12.2022 12:41:39' | '50'        | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'UNIQ'     | '0514'              | 'Source of origin 909' | 'en description is empty'      | 'TRY'      |
			| ''                                           | '01.12.2022 12:41:39' | '50'        | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'M/Black'  | ''                  | ''                     | 'Local currency'               | 'TRY'      |
			| ''                                           | '01.12.2022 12:41:39' | '50'        | 'Main Company' | 'Consignor 1' | 'Consignor partner term 1' | 'Opening entry 15 dated 01.12.2022 12:41:39' | 'M/Black'  | ''                  | ''                     | 'en description is empty'      | 'TRY'      |		
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
			| 'Opening entry 312 dated 03.03.2023 11:46:31' | ''            | ''                    | ''          | ''             | ''       | ''                | ''               | ''         | ''                     | ''                             | ''                 |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''       | ''                | ''               | ''         | ''                     | ''                             | ''                 |
			| 'Register  "R9510 Salary payment"'            | ''            | ''                    | ''          | ''             | ''       | ''                | ''               | ''         | ''                     | ''                             | ''                 |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                | ''               | ''         | ''                     | ''                             | ''                 |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Employee'        | 'Payment period' | 'Currency' | 'Transaction currency' | 'Multi currency movement type' | 'Calculation type' |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '17,12'     | 'Main Company' | ''       | 'Alexander Orlov' | 'First'          | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '34,24'     | 'Main Company' | ''       | 'Anna Petrova'    | 'Second'         | 'USD'      | 'TRY'                  | 'Reporting currency'           | 'Salary'           |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '100'       | 'Main Company' | ''       | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '100'       | 'Main Company' | ''       | 'Alexander Orlov' | 'First'          | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '200'       | 'Main Company' | ''       | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'Local currency'               | 'Salary'           |
			| ''                                            | 'Receipt'     | '03.03.2023 11:46:31' | '200'       | 'Main Company' | ''       | 'Anna Petrova'    | 'Second'         | 'TRY'      | 'TRY'                  | 'en description is empty'      | 'Salary'           |		
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
		And I click "Registrations report info" button
		And I select "R2023 Advances from retail customers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 315 dated 03.03.2023 17:09:42'      | ''                    | ''           | ''             | ''       | ''                | ''       |
			| 'Register  "R2023 Advances from retail customers"' | ''                    | ''           | ''             | ''       | ''                | ''       |
			| ''                                                 | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Retail customer' | 'Amount' |
			| ''                                                 | '03.03.2023 17:09:42' | 'Receipt'    | 'Main Company' | ''       | 'Daniel Smith'    | '1 000'  |
			| ''                                                 | '03.03.2023 17:09:42' | 'Receipt'    | 'Main Company' | ''       | 'Sam Jons'        | '1 000'  |	
		And I close all client application windows

Scenario: _042935 check Opening entry movements by the Register  "Cash in transit" (cash in transit)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '122'       |
	* Check movements by the Register  "Cash in transit" 
		And I click "Registrations report" button
		And I select "Cash in transit" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 122 dated 07.07.2023 12:34:10' | ''            | ''                    | ''          | ''             | ''               | ''                    | ''                    | ''         | ''                             | ''                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''               | ''                    | ''                    | ''         | ''                             | ''                     |
			| 'Register  "Cash in transit"'                 | ''            | ''                    | ''          | ''             | ''               | ''                    | ''                    | ''         | ''                             | ''                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''               | ''                    | ''                    | ''         | ''                             | 'Attributes'           |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Company'      | 'Basis document' | 'From account'        | 'To account'          | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | ''          | 'Main Company' | ''               | 'Bank account 2, EUR' | 'Bank account 2, EUR' | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | ''          | 'Main Company' | ''               | 'Bank account 2, EUR' | 'Bank account 2, EUR' | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | '17,12'     | 'Main Company' | ''               | 'Cash desk №3'        | 'Cash desk №1'        | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | '100'       | 'Main Company' | ''               | 'Cash desk №3'        | 'Cash desk №1'        | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | '100'       | 'Main Company' | ''               | 'Cash desk №3'        | 'Cash desk №1'        | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                            | 'Receipt'     | '07.07.2023 12:34:10' | '200'       | 'Main Company' | ''               | 'Bank account 2, EUR' | 'Bank account 2, EUR' | 'EUR'      | 'en description is empty'      | 'No'                   |		
		And I close all client application windows

Scenario: _042936 check Opening entry movements by the Register  "R3021 Cash in transit (incoming)" (cash in transit)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '122'       |
	* Check movements by the Register  "R3021 Cash in transit (incoming)" 
		And I click "Registrations report" button
		And I select "R3021 Cash in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 122 dated 07.07.2023 12:34:10'  | ''            | ''                    | ''          | ''             | ''                   | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Document registrations records'               | ''            | ''                    | ''          | ''             | ''                   | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| 'Register  "R3021 Cash in transit (incoming)"' | ''            | ''                    | ''          | ''             | ''                   | ''                    | ''                             | ''         | ''                     | ''      | ''                     |
			| ''                                             | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                   | ''                    | ''                             | ''         | ''                     | ''      | 'Attributes'           |
			| ''                                             | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch'             | 'Account'             | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Basis' | 'Deferred calculation' |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | ''          | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'Local currency'               | 'TRY'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | ''          | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'Reporting currency'           | 'USD'      | 'EUR'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | '17,12'     | 'Main Company' | 'Front office'       | 'Cash desk №1'        | 'Reporting currency'           | 'USD'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | '100'       | 'Main Company' | 'Front office'       | 'Cash desk №1'        | 'Local currency'               | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | '100'       | 'Main Company' | 'Front office'       | 'Cash desk №1'        | 'en description is empty'      | 'TRY'      | 'TRY'                  | ''      | 'No'                   |
			| ''                                             | 'Receipt'     | '07.07.2023 12:34:10' | '200'       | 'Main Company' | 'Accountants office' | 'Bank account 2, EUR' | 'en description is empty'      | 'EUR'      | 'EUR'                  | ''      | 'No'                   |		
		And I close all client application windows

Scenario: _042937 check Opening entry movements by the Register  "R5010 Reconciliation statement" (other partner transaction)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '121'       |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 121 dated 07.07.2023 12:17:50' | ''            | ''                    | ''          | ''             | ''       | ''         | ''                | ''                    |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''       | ''         | ''                | ''                    |
			| 'Register  "R5010 Reconciliation statement"'  | ''            | ''                    | ''          | ''             | ''       | ''         | ''                | ''                    |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''         | ''                | ''                    |
			| ''                                            | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Currency' | 'Legal name'      | 'Legal name contract' |
			| ''                                            | 'Receipt'     | '07.07.2023 12:17:50' | '10'        | 'Main Company' | ''       | 'TRY'      | 'Other partner 2' | ''                    |
			| ''                                            | 'Expense'     | '07.07.2023 12:17:50' | '50'        | 'Main Company' | ''       | 'TRY'      | 'Other partner 1' | ''                    |
			| ''                                            | 'Expense'     | '07.07.2023 12:17:50' | '100'       | 'Main Company' | ''       | 'TRY'      | 'Other partner 2' | ''                    |		
		And I close all client application windows

Scenario: _042938 check Opening entry movements by the Register  "R5015 Other partners transactions" (other partner transaction)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '121'       |
	* Check movements by the Register  "R5015 Other partners transactions" 
		And I click "Registrations report" button
		And I select "R5015 Other partners transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 121 dated 07.07.2023 12:17:50'   | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                | ''      | ''                     |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                | ''      | ''                     |
			| 'Register  "R5015 Other partners transactions"' | ''            | ''                    | ''          | ''             | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                | ''      | ''                     |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''       | ''                             | ''         | ''                     | ''                | ''                | ''                | ''      | 'Attributes'           |
			| ''                                              | ''            | ''                    | 'Amount'    | 'Company'      | 'Branch' | 'Multi currency movement type' | 'Currency' | 'Transaction currency' | 'Legal name'      | 'Partner'         | 'Agreement'       | 'Basis' | 'Deferred calculation' |
			| ''                                              | 'Receipt'     | '07.07.2023 12:17:50' | '1,71'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |
			| ''                                              | 'Receipt'     | '07.07.2023 12:17:50' | '10'        | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |
			| ''                                              | 'Receipt'     | '07.07.2023 12:17:50' | '10'        | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '8,56'      | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '17,12'     | 'Main Company' | ''       | 'Reporting currency'           | 'USD'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '50'        | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '50'        | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '100'       | 'Main Company' | ''       | 'Local currency'               | 'TRY'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |
			| ''                                              | 'Expense'     | '07.07.2023 12:17:50' | '100'       | 'Main Company' | ''       | 'en description is empty'      | 'TRY'      | 'TRY'                  | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''      | 'No'                   |		
		And I close all client application windows

Scenario: _042939 check Opening entry movements by the Register  "R9545 Paid vacations" (employee)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '222'       |
	* Check movements by the Register  "R9545 Paid vacations" 
		And I click "Registrations report" button
		And I select "R9545 Paid vacations" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 222 dated 03.04.2024 15:22:43' | ''                    | ''          | ''             | ''              |
			| 'Document registrations records'              | ''                    | ''          | ''             | ''              |
			| 'Register  "R9545 Paid vacations"'            | ''                    | ''          | ''             | ''              |
			| ''                                            | 'Period'              | 'Resources' | 'Dimensions'   | ''              |
			| ''                                            | ''                    | 'Paid'      | 'Company'      | 'Employee'      |
			| ''                                            | '03.04.2024 15:22:43' | '14'        | 'Main Company' | 'Anna Petrova'  |
			| ''                                            | '03.04.2024 15:22:43' | '19'        | 'Main Company' | 'David Romanov' |	
		And I close all client application windows

Scenario: _042940 check Opening entry movements by the Register  "T9510 Staffing" (employee)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '222'       |
	* Check movements by the Register  "T9510 Staffing" 
		And I click "Registrations report" button
		And I select "T9510 Staffing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 222 dated 03.04.2024 15:22:43' | ''                    | ''          | ''       | ''             | ''                                  | ''                   | ''              | ''             |
			| 'Document registrations records'              | ''                    | ''          | ''       | ''             | ''                                  | ''                   | ''              | ''             |
			| 'Register  "T9510 Staffing"'                  | ''                    | ''          | ''       | ''             | ''                                  | ''                   | ''              | ''             |
			| ''                                            | 'Period'              | 'Resources' | ''       | ''             | ''                                  | ''                   | 'Dimensions'    | ''             |
			| ''                                            | ''                    | 'Fired'     | 'Branch' | 'Position'     | 'Employee schedule'                 | 'Profit loss center' | 'Employee'      | 'Company'      |
			| ''                                            | '03.04.2024 15:22:43' | 'No'        | ''       | 'Manager'      | '5 working days / 2 days off (day)' | 'Front office'       | 'David Romanov' | 'Main Company' |
			| ''                                            | '03.04.2024 15:22:43' | 'No'        | ''       | 'Sales person' | '1 working day / 2 days off (day)'  | 'Shop 01'            | 'Anna Petrova'  | 'Main Company' |	
		And I close all client application windows

Scenario: _042941 check Opening entry movements by the Register  "R5020 Partners balance" (customers and vendors)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '9'       |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57' | ''                    | ''           | ''             | ''             | ''        | ''              | ''                        | ''                                          | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'        | ''                    | ''           | ''             | ''             | ''        | ''              | ''                        | ''                                          | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                          | 'Period'              | 'RecordType' | 'Company'      | 'Branch'       | 'Partner' | 'Legal name'    | 'Agreement'               | 'Document'                                  | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                          | '07.09.2020 21:27:57' | 'Receipt'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term DFC'        | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'Local currency'               | 'TRY'                  | '200'    | '200'                  | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Receipt'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term DFC'        | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '200'    | '200'                  | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Receipt'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term DFC'        | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '34,24'  | '34,24'                | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term vendor DFC' | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'Local currency'               | 'TRY'                  | '100'    | ''                     | ''                 | '100'                | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term vendor DFC' | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '100'    | ''                     | ''                 | '100'                | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'DFC'     | 'DFC'           | 'Partner term vendor DFC' | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '17,12'  | ''                     | ''                 | '17,12'              | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim'      | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'Local currency'               | 'TRY'                  | '200'    | ''                     | ''                 | '200'                | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim'      | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'TRY'      | 'en description is empty'      | 'TRY'                  | '200'    | ''                     | ''                 | '200'                | ''               | ''                  | ''                 |
			| ''                                          | '07.09.2020 21:27:57' | 'Expense'    | 'Main Company' | 'Front office' | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim'      | 'Opening entry 9 dated 07.09.2020 21:27:57' | 'USD'      | 'Reporting currency'           | 'TRY'                  | '34,24'  | ''                     | ''                 | '34,24'              | ''               | ''                  | ''                 |		
		And I close all client application windows

Scenario: _042942 check Opening entry movements by the Register  "R5020 Partners balance" (other partner transaction)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'    |
			| '121'       |
	* Check movements by the Register  "R5020 Partners balance" 
		And I click "Registrations report info" button
		And I select "R5020 Partners balance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 121 dated 07.07.2023 12:17:50' | ''                    | ''           | ''             | ''       | ''                | ''                | ''                | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| 'Register  "R5020 Partners balance"'          | ''                    | ''           | ''             | ''       | ''                | ''                | ''                | ''         | ''         | ''                             | ''                     | ''       | ''                     | ''                 | ''                   | ''               | ''                  | ''                 |
			| ''                                            | 'Period'              | 'RecordType' | 'Company'      | 'Branch' | 'Partner'         | 'Legal name'      | 'Agreement'       | 'Document' | 'Currency' | 'Multi currency movement type' | 'Transaction currency' | 'Amount' | 'Customer transaction' | 'Customer advance' | 'Vendor transaction' | 'Vendor advance' | 'Other transaction' | 'Advances closing' |
			| ''                                            | '07.07.2023 12:17:50' | 'Receipt'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '10'     | ''                     | ''                 | ''                   | ''               | '10'                | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Receipt'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '10'     | ''                     | ''                 | ''                   | ''               | '10'                | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Receipt'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '1,71'   | ''                     | ''                 | ''                   | ''               | '1,71'              | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '50'     | ''                     | ''                 | ''                   | ''               | '50'                | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '50'     | ''                     | ''                 | ''                   | ''               | '50'                | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 1' | 'Other partner 1' | 'Other partner 1' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '8,56'   | ''                     | ''                 | ''                   | ''               | '8,56'              | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'TRY'      | 'Local currency'               | 'TRY'                  | '100'    | ''                     | ''                 | ''                   | ''               | '100'               | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'TRY'      | 'en description is empty'      | 'TRY'                  | '100'    | ''                     | ''                 | ''                   | ''               | '100'               | ''                 |
			| ''                                            | '07.07.2023 12:17:50' | 'Expense'    | 'Main Company' | ''       | 'Other partner 2' | 'Other partner 2' | 'Other partner 2' | ''         | 'USD'      | 'Reporting currency'           | 'TRY'                  | '17,12'  | ''                     | ''                 | ''                   | ''               | '17,12'             | ''                 |	
		And I close all client application windows

Scenario: _042943 check Opening entry movements by the Register  "T2014 Advances info" (Advances)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'  |
			| '3'       |
	* Check movements by the Register  "T2014 Advances info" 
		And I click "Registrations report info" button
		And I select "T2014 Advances info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 3 dated 07.09.2020 21:26:50' | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                  | ''        | ''       | ''                        | ''                     | ''            |
			| 'Register  "T2014 Advances info"'           | ''             | ''             | ''                    | ''    | ''         | ''          | ''                  | ''      | ''                  | ''                    | ''          | ''                  | ''        | ''       | ''                        | ''                     | ''            |
			| ''                                          | 'Company'      | 'Branch'       | 'Date'                | 'Key' | 'Currency' | 'Partner'   | 'Legal name'        | 'Order' | 'Is vendor advance' | 'Is customer advance' | 'Unique ID' | 'Advance agreement' | 'Project' | 'Amount' | 'Is purchase order close' | 'Is sales order close' | 'Record type' |
			| ''                                          | 'Main Company' | 'Front office' | '07.09.2020 21:26:50' | '*'   | 'TRY'      | 'Kalipso'   | 'Company Kalipso'   | ''      | 'No'                | 'Yes'                 | '*'         | ''                  | ''        | '100'    | 'No'                      | 'No'                   | 'Receipt'     |
			| ''                                          | 'Main Company' | 'Front office' | '07.09.2020 21:26:50' | '*'   | 'EUR'      | 'Big foot'  | 'Big foot'          | ''      | 'Yes'               | 'No'                  | '*'         | ''                  | ''        | '200'    | 'No'                      | 'No'                   | 'Receipt'     |
			| ''                                          | 'Main Company' | 'Front office' | '07.09.2020 21:26:50' | '*'   | 'TRY'      | 'Ferron BP' | 'Company Ferron BP' | ''      | 'Yes'               | 'No'                  | '*'         | ''                  | ''        | '100'    | 'No'                      | 'No'                   | 'Receipt'     |
			| ''                                          | 'Main Company' | 'Front office' | '07.09.2020 21:26:50' | '*'   | 'TRY'      | 'DFC'       | 'DFC'               | ''      | 'No'                | 'Yes'                 | '*'         | ''                  | ''        | '200'    | 'No'                      | 'No'                   | 'Receipt'     |
		And I close all client application windows

Scenario: _042944 check Opening entry movements by the Register  "T2015 Transactions info" (AP-by partner term)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'  |
			| '4'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 4 dated 07.09.2020 21:27:01' | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''           | ''                            | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'       | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''           | ''                            | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| ''                                          | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name' | 'Agreement'                   | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:01' | '*'   | 'TRY'      | 'DFC'     | 'DFC'        | 'DFC Vendor by Partner terms' | 'Yes'                   | 'No'                      | ''                  | '*'         | ''        | '100'    | 'Yes'    | 'No'      |
		And I close all client application windows

Scenario: _042945 check Opening entry movements by the Register  "T2015 Transactions info" (AR-by partner term)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'  |
			| '5'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 5 dated 07.09.2020 21:27:18' | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''           | ''                              | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'       | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''           | ''                              | ''                      | ''                        | ''                  | ''          | ''        | ''       | ''       | ''        |
			| ''                                          | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name' | 'Agreement'                     | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:18' | '*'   | 'TRY'      | 'DFC'     | 'DFC'        | 'DFC Customer by Partner terms' | 'No'                    | 'Yes'                     | ''                  | '*'         | ''        | '100'    | 'Yes'    | 'No'      |
		And I close all client application windows

Scenario: _042945 check Opening entry movements by the Register  "T2015 Transactions info" (AP-by documents)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'  |
			| '9'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57' | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                        | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'       | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                        | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| ''                                          | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name'    | 'Agreement'               | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                         | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'DFC'     | 'DFC'           | 'Partner term vendor DFC' | 'Yes'                   | 'No'                      | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '100'    | 'Yes'    | 'No'      |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'DFC'     | 'DFC'           | 'Partner term DFC'        | 'No'                    | 'Yes'                     | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '200'    | 'Yes'    | 'No'      |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim'      | 'Yes'                   | 'No'                      | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '200'    | 'Yes'    | 'No'      |
		And I close all client application windows

Scenario: _042946 check Opening entry movements by the Register  "T2015 Transactions info" (AP, AR-by documents)
	And I close all client application windows
	* Select Opening entry
		Given I open hyperlink "e1cib/list/Document.OpeningEntry"
		And I go to line in "List" table
			| 'Number'  |
			| '9'       |
	* Check movements by the Register  "T2015 Transactions info" 
		And I click "Registrations report info" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Opening entry 9 dated 07.09.2020 21:27:57' | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                        | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| 'Register  "T2015 Transactions info"'       | ''             | ''             | ''      | ''                    | ''    | ''         | ''        | ''              | ''                        | ''                      | ''                        | ''                                          | ''          | ''        | ''       | ''       | ''        |
			| ''                                          | 'Company'      | 'Branch'       | 'Order' | 'Date'                | 'Key' | 'Currency' | 'Partner' | 'Legal name'    | 'Agreement'               | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis'                         | 'Unique ID' | 'Project' | 'Amount' | 'Is due' | 'Is paid' |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'DFC'     | 'DFC'           | 'Partner term vendor DFC' | 'Yes'                   | 'No'                      | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '100'    | 'Yes'    | 'No'      |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'DFC'     | 'DFC'           | 'Partner term DFC'        | 'No'                    | 'Yes'                     | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '200'    | 'Yes'    | 'No'      |
			| ''                                          | 'Main Company' | 'Front office' | ''      | '07.09.2020 21:27:57' | '*'   | 'TRY'      | 'Maxim'   | 'Company Maxim' | 'Partner term Maxim'      | 'Yes'                   | 'No'                      | 'Opening entry 9 dated 07.09.2020 21:27:57' | '*'         | ''        | '200'    | 'Yes'    | 'No'      |
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
