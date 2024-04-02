#language: en
@tree
@Positive
@Movements2
@MovementsCashRevenue

Feature: check Cash revenue movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _044100 preparation (Cash revenue)
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
		When Create catalog Countries objects
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create catalog CashAccounts objects (Second Company)
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load documents
		When Create document CashRevenue objects
		When Create document CashRevenue objects (OtherCompanyRevenue)
		And I execute 1C:Enterprise script at server
			| "Documents.CashRevenue.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CashRevenue.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I close all client application windows

Scenario: _0441001 check preparation
	When check preparation

Scenario: _044101 check Cash revenue movements by the Register "R3010 Cash on hand"
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 1 dated 07.09.2020 19:24:49'   | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'             | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'             | ''              | ''                      | ''            | ''               | ''          | ''                    | ''           | ''                       | ''                               | ''                        |
			| ''                                           | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'     | ''          | ''                    | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                           | ''              | ''                      | 'Amount'      | 'Company'        | 'Branch'    | 'Account'             | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                           | 'Receipt'       | '07.09.2020 19:24:49'   | '20,2'        | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                           | 'Receipt'       | '07.09.2020 19:24:49'   | '118'         | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                           | 'Receipt'       | '07.09.2020 19:24:49'   | '118'         | 'Main Company'   | 'Shop 01'   | 'Bank account, TRY'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows


Scenario: _044102 check Cash revenue movements by the Register "R5021 Revenues"
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 1 dated 07.09.2020 19:24:49' | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'           | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'               | ''                    | ''          | ''                  | ''             | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                         | 'Period'              | 'Resources' | ''                  | 'Dimensions'   | ''        | ''                   | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                         | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'      | 'Branch'  | 'Profit loss center' | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                         | '07.09.2020 19:24:49' | '17,12'     | '20,2'              | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                         | '07.09.2020 19:24:49' | '100'       | '118'               | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                         | '07.09.2020 19:24:49' | '100'       | '118'               | 'Main Company' | 'Shop 01' | 'Front office'       | 'Fuel'         | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        |
		
	And I close all client application windows


Scenario: _044105 check Cash revenue movements by the Register "R5021 Revenues" (Other company revenue)
		And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R5021 Revenues" 
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 14 dated 04.03.2023 11:03:03' | ''                    | ''          | ''                  | ''               | ''       | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Document registrations records'            | ''                    | ''          | ''                  | ''               | ''       | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| 'Register  "R5021 Revenues"'                | ''                    | ''          | ''                  | ''               | ''       | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                          | 'Period'              | 'Resources' | ''                  | 'Dimensions'     | ''       | ''                        | ''             | ''         | ''         | ''                    | ''                             | ''        |
			| ''                                          | ''                    | 'Amount'    | 'Amount with taxes' | 'Company'        | 'Branch' | 'Profit loss center'      | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' | 'Project' |
			| ''                                          | '04.03.2023 11:03:03' | '85,6'      | '85,6'              | 'Second Company' | ''       | 'Distribution department' | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                          | '04.03.2023 11:03:03' | '171,2'     | '171,2'             | 'Second Company' | ''       | 'Logistics department'    | 'Revenue'      | ''         | 'USD'      | ''                    | 'Reporting currency'           | ''        |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | '500'               | 'Second Company' | ''       | 'Distribution department' | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | '500'               | 'Second Company' | ''       | 'Distribution department' | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | '1 000'             | 'Second Company' | ''       | 'Logistics department'    | 'Revenue'      | ''         | 'TRY'      | ''                    | 'Local currency'               | ''        |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | '1 000'             | 'Second Company' | ''       | 'Logistics department'    | 'Revenue'      | ''         | 'TRY'      | ''                    | 'en description is empty'      | ''        |
	And I close all client application windows

Scenario: _044106 check Cash revenue movements by the Register "R3010 Cash on hand" (Other company revenue)
		And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R3010 Cash on hand" 
		And I click "Registrations report" button
		And I select "R3010 Cash on hand" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 14 dated 04.03.2023 11:03:03'   | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| 'Register  "R3010 Cash on hand"'              | ''              | ''                      | ''            | ''                 | ''         | ''               | ''           | ''                       | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'       | ''         | ''               | ''           | ''                       | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'          | 'Branch'   | 'Account'        | 'Currency'   | 'Transaction currency'   | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '85,6'        | 'Main Company'     | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '85,6'        | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '171,2'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '171,2'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Main Company'     | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '85,6'        | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '171,2'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'USD'        | 'TRY'                    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'Cash desk №4'   | 'TRY'        | 'TRY'                    | 'en description is empty'        | 'No'                      |
	And I close all client application windows


Scenario: _044107 check Cash revenue movements by the Register "R3027 Employee cash advance" (Other company revenue)
		And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R3027 Employee cash advance" 
		And I click "Registrations report" button
		And I select "R3027 Employee cash advance" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 14 dated 04.03.2023 11:03:03'   | ''              | ''                      | ''            | ''                 | ''         | ''           | ''                       | ''               | ''                               | ''                        |
			| 'Document registrations records'              | ''              | ''                      | ''            | ''                 | ''         | ''           | ''                       | ''               | ''                               | ''                        |
			| 'Register  "R3027 Employee cash advance"'     | ''              | ''                      | ''            | ''                 | ''         | ''           | ''                       | ''               | ''                               | ''                        |
			| ''                                            | 'Record type'   | 'Period'                | 'Resources'   | 'Dimensions'       | ''         | ''           | ''                       | ''               | ''                               | 'Attributes'              |
			| ''                                            | ''              | ''                      | 'Amount'      | 'Company'          | 'Branch'   | 'Currency'   | 'Transaction currency'   | 'Partner'        | 'Multi currency movement type'   | 'Deferred calculation'    |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '85,6'        | 'Second Company'   | ''         | 'USD'        | 'TRY'                    | 'Anna Petrova'   | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '171,2'       | 'Second Company'   | ''         | 'USD'        | 'TRY'                    | 'Arina Brown'    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'TRY'        | 'TRY'                    | 'Anna Petrova'   | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '500'         | 'Second Company'   | ''         | 'TRY'        | 'TRY'                    | 'Anna Petrova'   | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Receipt'       | '04.03.2023 11:03:03'   | '1 000'       | 'Second Company'   | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'    | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '85,6'        | 'Main Company'     | ''         | 'USD'        | 'TRY'                    | 'Anna Petrova'   | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '171,2'       | 'Main Company'     | ''         | 'USD'        | 'TRY'                    | 'Arina Brown'    | 'Reporting currency'             | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '500'         | 'Main Company'     | ''         | 'TRY'        | 'TRY'                    | 'Anna Petrova'   | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '500'         | 'Main Company'     | ''         | 'TRY'        | 'TRY'                    | 'Anna Petrova'   | 'en description is empty'        | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '1 000'       | 'Main Company'     | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'    | 'Local currency'                 | 'No'                      |
			| ''                                            | 'Expense'       | '04.03.2023 11:03:03'   | '1 000'       | 'Main Company'     | ''         | 'TRY'        | 'TRY'                    | 'Arina Brown'    | 'en description is empty'        | 'No'                      |
	And I close all client application windows

Scenario: _044108 check Cash revenue movements by the Register "R3011 Cash flow" (Other company revenue)
		And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '14'        |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 14 dated 04.03.2023 11:03:03' | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Document registrations records'            | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| 'Register  "R3011 Cash flow"'               | ''                    | ''          | ''               | ''       | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''                     |
			| ''                                          | 'Period'              | 'Resources' | 'Dimensions'     | ''       | ''             | ''          | ''                        | ''                 | ''                | ''         | ''                             | 'Attributes'           |
			| ''                                          | ''                    | 'Amount'    | 'Company'        | 'Branch' | 'Account'      | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Deferred calculation' |
			| ''                                          | '04.03.2023 11:03:03' | '85,6'      | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '85,6'      | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '85,6'      | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '171,2'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '171,2'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '171,2'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '500'       | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Main Company'   | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Outgoing'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | 'No'                   |
			| ''                                          | '04.03.2023 11:03:03' | '1 000'     | 'Second Company' | ''       | 'Cash desk №4' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | 'No'                   |		
	And I close all client application windows


Scenario: _044109 check Cash revenue movements by the Register "R3011 Cash flow" (Current company revenue)
		And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Check movements by the Register  "R3011 Cash flow" 
		And I click "Registrations report info" button
		And I select "R3011 Cash flow" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 1 dated 07.09.2020 19:24:49' | ''                    | ''             | ''        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| 'Register  "R3011 Cash flow"'              | ''                    | ''             | ''        | ''                  | ''          | ''                        | ''                 | ''                | ''         | ''                             | ''       | ''                     |
			| ''                                         | 'Period'              | 'Company'      | 'Branch'  | 'Account'           | 'Direction' | 'Financial movement type' | 'Cash flow center' | 'Planning period' | 'Currency' | 'Multi currency movement type' | 'Amount' | 'Deferred calculation' |
			| ''                                         | '07.09.2020 19:24:49' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'Local currency'               | '118'    | 'No'                   |
			| ''                                         | '07.09.2020 19:24:49' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'TRY'      | 'en description is empty'      | '118'    | 'No'                   |
			| ''                                         | '07.09.2020 19:24:49' | 'Main Company' | 'Shop 01' | 'Bank account, TRY' | 'Incoming'  | 'Movement type 1'         | 'Front office'     | ''                | 'USD'      | 'Reporting currency'           | '20,2'   | 'No'                   |
	And I close all client application windows

Scenario: _044130 Cash revenue clear posting/mark for deletion
	And I close all client application windows
	* Select Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 1 dated 07.09.2020 19:24:49'    |
			| 'Document registrations records'              |
		And I close current window
	* Post Cash revenue
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Cash revenue 1 dated 07.09.2020 19:24:49'    |
			| 'Document registrations records'              |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.CashRevenue"
		And I go to line in "List" table
			| 'Number'    |
			| '1'         |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R3010 Cash on hand'    |
		And I close all client application windows		
