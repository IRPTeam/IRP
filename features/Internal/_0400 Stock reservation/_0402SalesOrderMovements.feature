#language: en
@tree
@Positive
@Movements

Feature: check Sales order movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040148 preparation (sales order movements)
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
	* Tax settings
		When filling in Tax settings for company
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "DocumentDiscount" |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |	
	

Scenario: _040149 check Sales order movements by the Register  "R2010 Sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2010 Sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Register  "R2010 Sales orders"'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key' | 'Row key'                              | 'Procurement method' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' | 'Purchase'           | 'No'                   |
		And I close all client application windows
		
Scenario: _040150 check Sales order movements by the Register  "R2014 Canceled sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2014 Canceled sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2014 Canceled sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Register  "R2014 Canceled sales orders"' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key'  | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '325,28' | '275,66'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 1 dated 27.01.2021 19:50:45' | '38/Yellow' | '84a27f76-82ee-4a1f-970f-fe490b4e8fe0' | 'not available' | 'No'                   |

		And I close all client application windows
		
// Scenario: _040151 check Sales order movements by the Register  "R4013 Stock Reservation planning"
// 	* Select Sales order
// 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '1' |
// 	* Check movements by the Register  "R4013 Stock Reservation planning" (Receipt, Expense)
// 		And I click "Registrations report" button
// 		And I select "R4013 Stock Reservation planning" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales order 1 dated *'					 	  | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Register  "R4013 Stock Reservation planning"'                     | ''            | ''                    | ''          | ''           | ''          |
			
// 		And I close all client application windows
		
Scenario: _040152 check Sales order movements by the Register  "R2011 Shipment of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'    | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _040153 check Sales order movements by the Register  "R4011 Free stocks"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  |
	
		And I close all client application windows
		
Scenario: _040154 check Sales order movements by the Register  "R4012 Stock Reservation"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'     | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                        | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 1 dated 27.01.2021 19:50:45' |

		And I close all client application windows
		
Scenario: _040155 check Sales order movements by the Register  "R2013 Procurement of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2013 Procurement of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'       | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '27.01.2021 19:50:45' | '24'               | ''                    | ''                  | ''                 | ''                 | ''               | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '37/18SD'  |
	
		And I close all client application windows
		
Scenario: _040156 check Sales order movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 1 dated 27.01.2021 19:50:45'     | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"' | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                            | 'Receipt'     | '27.01.2021 00:00:00' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
		And I close all client application windows
		
Scenario: _040157 check Sales order movements by the Register  "R2012 Invoice closing of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
		| 'Sales order 1 dated 27.01.2021 19:50:45'           | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
		| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
		| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
		| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
		| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
		| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
		| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
		| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
		| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '37/18SD'  | '5d82f8d1-e3f8-4453-aa45-4f7ac9601689' |



		And I close all client application windows

//SO 2
	Scenario: _0401492 check Sales order movements by the Register  "R2010 Sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2010 Sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
		| 'Sales order 2 dated 27.01.2021 19:50:45' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
		| 'Document registrations records'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
		| 'Register  "R2010 Sales orders"'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
		| ''                                        | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | 'Attributes'           |
		| ''                                        | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key' | 'Row key'                              | 'Procurement method' | 'Deferred calculation' |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
		| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |



		And I close all client application windows
		
Scenario: _0401502 check Sales order movements by the Register  "R2014 Canceled sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2014 Canceled sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2014 Canceled sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Register  "R2014 Canceled sales orders"' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key'  | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '325,28' | '275,66'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 2 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |



		And I close all client application windows
		
// Scenario: _0401512 check Sales order movements by the Register  "R4013 Stock Reservation planning"
// 	* Select Sales order
// 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '2' |
// 	* Check movements by the Register  "R4013 Stock Reservation planning" (Receipt, Expense)
// 		And I click "Registrations report" button
// 		And I select "R4013 Stock Reservation planning" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales order 1 dated *'					 	  | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Register  "R4013 Stock Reservation planning"'                     | ''            | ''                    | ''          | ''           | ''          |
			
// 		And I close all client application windows
		
Scenario: _0401522 check Sales order movements by the Register  "R2011 Shipment of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2011 Shipment of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45'    | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _0401532 check Sales order movements by the Register  "R4011 Free stocks"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4011 Free stocks" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  |

		And I close all client application windows
		
Scenario: _0401542 check Sales order movements by the Register  "R4012 Stock Reservation"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4012 Stock Reservation" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'     | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                        | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 2 dated 27.01.2021 19:50:45' |

		And I close all client application windows
		
Scenario: _0401552 check Sales order movements by the Register  "R2013 Procurement of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2013 Procurement of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45'       | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '27.01.2021 19:50:45' | '24'               | ''                    | ''                  | ''                 | ''                 | ''               | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | '37/18SD'  |


		And I close all client application windows
		
Scenario: _0401562 check Sales order movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4034 Scheduled goods shipments" |
		And I close all client application windows
		
Scenario: _0401572 check Sales order movements by the Register  "R2012 Invoice closing of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 2 dated 27.01.2021 19:50:45'           | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |

		And I close all client application windows

//SO 3
	Scenario: _0401493 check Sales order movements by the Register  "R2010 Sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2010 Sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| 'Register  "R2010 Sales orders"'          | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                        | ''         | ''                                     | ''                   | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key' | 'Row key'                              | 'Procurement method' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'Stock'              | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'No reserve'         | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'Purchase'           | 'No'                   |

		And I close all client application windows
		
Scenario: _0401503 check Sales order movements by the Register  "R2014 Canceled sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2014 Canceled sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2014 Canceled sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Document registrations records'          | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| 'Register  "R2014 Canceled sales orders"' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | ''                     |
			| ''                                        | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''                                        | ''          | ''                                     | ''              | 'Attributes'           |
			| ''                                        | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                   | 'Item key'  | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '325,28' | '275,66'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |
			| ''                                        | '27.01.2021 19:50:45' | '5'         | '1 900'  | '1 610,17'   | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales order 3 dated 27.01.2021 19:50:45' | '38/Yellow' | '78cd7647-05a3-497e-adba-e2173a7c1651' | 'not available' | 'No'                   |



		And I close all client application windows
		
// Scenario: _0401513 check Sales order movements by the Register  "R4013 Stock Reservation planning"
// 	* Select Sales order
// 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '3' |
// 	* Check movements by the Register  "R4013 Stock Reservation planning" (Receipt, Expense)
// 		And I click "Registrations report" button
// 		And I select "R4013 Stock Reservation planning" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales order 1 dated *'					 	  | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Register  "R4013 Stock Reservation planning"'                     | ''            | ''                    | ''          | ''           | ''          |
			
// 		And I close all client application windows
		
Scenario: _0401523 check Sales order movements by the Register  "R2011 Shipment of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2011 Shipment of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45'    | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   |
			| ''                                           | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _0401533 check Sales order movements by the Register  "R4011 Free stocks"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4011 Free stocks" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                        | 'Expense'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  |


		And I close all client application windows
		
Scenario: _0401543 check Sales order movements by the Register  "R4012 Stock Reservation"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4012 Stock Reservation" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'          | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'     | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                        | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                        | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                        | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 3 dated 27.01.2021 19:50:45' |

		And I close all client application windows
		
Scenario: _0401553 check Sales order movements by the Register  "R2013 Procurement of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2013 Procurement of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45'       | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '27.01.2021 19:50:45' | '24'               | ''                    | ''                  | ''                 | ''                 | ''               | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _0401563 check Sales order movements by the Register  "R4034 Scheduled goods shipments"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4034 Scheduled goods shipments" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4034 Scheduled goods shipments" |
		And I close all client application windows
		
Scenario: _0401573 check Sales order movements by the Register  "R2012 Invoice closing of sales orders"
	* Select Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders" (Receipt, Expense)
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales order 3 dated 27.01.2021 19:50:45'           | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Receipt'     | '27.01.2021 19:50:45' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |

		And I close all client application windows