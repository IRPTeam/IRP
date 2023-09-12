﻿#language: en
@tree
@Positive
@MovementsSalesReportToConsignors


Feature: check sales report to consignors movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _047000 preparation (sales report to consignors movements)
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Items objects (serial lot numbers)
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create catalog Partners objects (trade agent and consignor)
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Stores (trade agent)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog BusinessUnits objects
		When Create catalog ExpenseAndRevenueTypes objects
		When update ItemKeys
		When Create catalog Partners objects
		When Create catalog Companies objects (own Second company)
		When Create information register Taxes records (VAT)
		When Create catalog Partners objects (Kalipso)
	* Setting for Company
		When settings for Company (commission trade)
	* LoadDocuments
		When Create document SalesReportToConsignor objects (comission trade)
	* Post document
		* Posting SalesReportToConsignor
			And I execute 1C:Enterprise script at server
				| "Documents.SalesReportToConsignor.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);"     |
	And I close all client application windows

Scenario: _047001 check preparation
	When check preparation


Scenario: _047002 check Sales report to consignor movements by the Register  "R1021 Vendors transactions"
		And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R1021 Vendors transactions"
		And I click "Registrations report" button
		And I select "R1021 Vendors transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales report to consignor 15 dated 12.12.2022 09:53:54'   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''              | ''              | ''                           | ''        | ''        | ''                       | ''                            |
			| 'Document registrations records'                           | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''              | ''              | ''                           | ''        | ''        | ''                       | ''                            |
			| 'Register  "R1021 Vendors transactions"'                   | ''              | ''                      | ''            | ''               | ''                          | ''                               | ''           | ''                       | ''              | ''              | ''                           | ''        | ''        | ''                       | ''                            |
			| ''                                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''                               | ''           | ''                       | ''              | ''              | ''                           | ''        | ''        | 'Attributes'             | ''                            |
			| ''                                                         | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Multi currency movement type'   | 'Currency'   | 'Transaction currency'   | 'Legal name'    | 'Partner'       | 'Agreement'                  | 'Basis'   | 'Order'   | 'Deferred calculation'   | 'Vendors advances closing'    |
			| ''                                                         | 'Receipt'       | '12.12.2022 09:53:54'   | '2 044,13'    | 'Main Company'   | 'Distribution department'   | 'Reporting currency'             | 'USD'        | 'TRY'                    | 'Consignor 1'   | 'Consignor 1'   | 'Consignor partner term 1'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                                         | 'Receipt'       | '12.12.2022 09:53:54'   | '11 940'      | 'Main Company'   | 'Distribution department'   | 'Local currency'                 | 'TRY'        | 'TRY'                    | 'Consignor 1'   | 'Consignor 1'   | 'Consignor partner term 1'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                                         | 'Receipt'       | '12.12.2022 09:53:54'   | '11 940'      | 'Main Company'   | 'Distribution department'   | 'TRY'                            | 'TRY'        | 'TRY'                    | 'Consignor 1'   | 'Consignor 1'   | 'Consignor partner term 1'   | ''        | ''        | 'No'                     | ''                            |
			| ''                                                         | 'Receipt'       | '12.12.2022 09:53:54'   | '11 940'      | 'Main Company'   | 'Distribution department'   | 'en description is empty'        | 'TRY'        | 'TRY'                    | 'Consignor 1'   | 'Consignor 1'   | 'Consignor partner term 1'   | ''        | ''        | 'No'                     | ''                            |
		And I close all client application windows

Scenario: _047003 check Sales report to consignor movements by the Register  "R5010 Reconciliation statement"
		And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales report to consignor 15 dated 12.12.2022 09:53:54'   | ''              | ''                      | ''            | ''               | ''                          | ''           | ''              | ''                       |
			| 'Document registrations records'                           | ''              | ''                      | ''            | ''               | ''                          | ''           | ''              | ''                       |
			| 'Register  "R5010 Reconciliation statement"'               | ''              | ''                      | ''            | ''               | ''                          | ''           | ''              | ''                       |
			| ''                                                         | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''                          | ''           | ''              | ''                       |
			| ''                                                         | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'                    | 'Currency'   | 'Legal name'    | 'Legal name contract'    |
			| ''                                                         | 'Expense'       | '12.12.2022 09:53:54'   | '11 940'      | 'Main Company'   | 'Distribution department'   | 'TRY'        | 'Consignor 1'   | ''                       |
		And I close all client application windows

Scenario: _047004 check Sales report to consignor movements by the Register  "T2015 Transactions info"
		And I close all client application windows
	* Select Sales report to consignor
		Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
		And I go to line in "List" table
			| 'Number'    |
			| '15'        |
	* Check movements by the Register  "T2015 Transactions info"
		And I click "Registrations report" button
		And I select "T2015 Transactions info" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales report to consignor 15 dated 12.12.2022 09:53:54' | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''            | ''            | ''                         | ''                      | ''                        | ''                  | ''          |
			| 'Document registrations records'                         | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''            | ''            | ''                         | ''                      | ''                        | ''                  | ''          |
			| 'Register  "T2015 Transactions info"'                    | ''          | ''       | ''        | ''             | ''                        | ''      | ''                    | ''                                     | ''         | ''            | ''            | ''                         | ''                      | ''                        | ''                  | ''          |
			| ''                                                       | 'Resources' | ''       | ''        | 'Dimensions'   | ''                        | ''      | ''                    | ''                                     | ''         | ''            | ''            | ''                         | ''                      | ''                        | ''                  | ''          |
			| ''                                                       | 'Amount'    | 'Is due' | 'Is paid' | 'Company'      | 'Branch'                  | 'Order' | 'Date'                | 'Key'                                  | 'Currency' | 'Partner'     | 'Legal name'  | 'Agreement'                | 'Is vendor transaction' | 'Is customer transaction' | 'Transaction basis' | 'Unique ID' |
			| ''                                                       | '11 940'    | 'Yes'    | 'No'      | 'Main Company' | 'Distribution department' | ''      | '12.12.2022 09:53:54' | '                                    ' | 'TRY'      | 'Consignor 1' | 'Consignor 1' | 'Consignor partner term 1' | 'Yes'                   | 'No'                      | ''                  | '*'         |
		And I close all client application windows
