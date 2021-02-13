#language: en
@tree
@Positive
@Movements
@MovementsSalesInvoice

Feature: check Sales invoice movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040130 preparation (Sales invoice)
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
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |	
	
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |

//1

# Scenario: _0401311 check Sales invoice movements by the Register  "R2005 Sales special offers" SO-SC-SI (use shedule)
# 	* Select Sales invoice
# 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 		And I go to line in "List" table
# 			| 'Number'  |
# 			| '1' |
# 	* Check movements by the Register  "R2005 Sales special offers"
# 		And I click "Registrations report" button
# 		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		Then "ResultTable" spreadsheet document is equal
# 			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Document registrations records'            | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Register  "R2005 Sales special offers"'    | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
# 			| ''                                          | '28.01.2021 18:48:53' | '95'           | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '494'          | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:48:53' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
		And I close all client application windows
		
Scenario: _040132 check Sales invoice movements by the Register  "R5010 Reconciliation statement" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'  | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'TRY'        | 'Main Company' | 'Company Ferron BP' |	
		And I close all client application windows
		
Scenario: _040133 check Sales invoice movements by the Register  "R4010 Actual stocks" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'           |
			
		And I close all client application windows
		
Scenario: _040134 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders" 
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2011 Shipment of sales orders"' |
		And I close all client application windows
		
Scenario: _040135 check Sales invoice movements by the Register  "R4050 Stock inventory" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Store 02' | '36/Red'   |
			
		And I close all client application windows
		
Scenario: _040136 check Sales invoice movements by the Register  "R2001 Sales" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Document registrations records'            | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '16,26'  | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '84,57'  | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '569,24' | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 1 dated 28.01.2021 18:48:53' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			
		And I close all client application windows
		
Scenario: _040137 check Sales invoice movements by the Register  "R2021 Customer transactions" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '670,08'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '3 914'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   |
			
		And I close all client application windows
		
Scenario: _040138 check Sales invoice movements by the Register  "R4011 Free stocks" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
		And I close all client application windows
		
Scenario: _040139 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows
		
Scenario: _040140 check Sales invoice movements by the Register  "R2013 Procurement of sales orders" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2013 Procurement of sales orders"
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'     | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '28.01.2021 18:48:53' | ''                 | ''                    | ''                  | ''                 | ''                 | '1'              | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                              | '28.01.2021 18:48:53' | ''                 | ''                    | ''                  | ''                 | ''                 | '10'             | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | '36/Red'   |

		And I close all client application windows
		
Scenario: _040141 check Sales invoice movements by the Register  "R5011 Partners aging" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R5011 Partners aging"
		And I click "Registrations report" button
		And I select "R5011 Partners aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Partners aging"'                     |
			
		And I close all client application windows
		
Scenario: _040142 check Sales invoice movements by the Register  "R2020 Advances from customer" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'                     |
			
		And I close all client application windows
		
Scenario: _040143 check Sales invoice movements by the Register  "R2040 Taxes incoming" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'          | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''    | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '80,51'          | '14,49'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '418,64'         | '75,36'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:48:53' | '2 817,8'        | '507,2'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			
		And I close all client application windows
		
Scenario: _040144 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'                     |
			
		And I close all client application windows
		
Scenario: _040145 check Sales invoice movements by the Register  "R4014 Serial lot numbers" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'                     |
			
		And I close all client application windows
		
Scenario: _040146 check Sales invoice movements by the Register  "R2031 Shipment invoicing" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53' | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                  | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'        | 'Basis'                                             | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '1'         | 'Main Company' | 'Store 02'     | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:48:53' | '10'        | 'Main Company' | 'Store 02'     | 'Shipment confirmation 2 dated 28.01.2021 18:43:36' | '36/Red'   |	
		And I close all client application windows
		
Scenario: _040147 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" SO-SC-SI (use shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 1 dated 28.01.2021 18:48:53'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:48:53' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 2 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
		And I close all client application windows

//2

# Scenario: _0401312 check Sales invoice movements by the Register  "R2005 Sales special offers" SO-SC-SI (without shedule)
# 	* Select Sales invoice
# 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 		And I go to line in "List" table
# 			| 'Number'  |
# 			| '2' |
# 	* Check movements by the Register  "R2005 Sales special offers"
# 		And I click "Registrations report" button
# 		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		Then "ResultTable" spreadsheet document is equal
# 			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Document registrations records'            | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Register  "R2005 Sales special offers"'    | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
# 			| ''                                          | '28.01.2021 18:49:39' | '95'           | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '494'          | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '3 325'        | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:49:39' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' | 'DocumentDiscount' |


		And I close all client application windows
		
Scenario: _0401322 check Sales invoice movements by the Register  "R5010 Reconciliation statement" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39'  | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '28.01.2021 18:49:39' | '3 914'     | 'TRY'        | 'Main Company' | 'Company Ferron BP' |
		And I close all client application windows
		
Scenario: _0401332 check Sales invoice movements by the Register  "R4010 Actual stocks" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4010 Actual stocks"'           |
			
		And I close all client application windows
		
Scenario: _0401342 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2011 Shipment of sales orders"' |
			
		And I close all client application windows
		
Scenario: _0401352 check Sales invoice movements by the Register  "R4050 Stock inventory" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:49:39' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:49:39' | '10'        | 'Main Company' | 'Store 02' | '36/Red'   |
			
		And I close all client application windows
		
Scenario: _0401362 check Sales invoice movements by the Register  "R2001 Sales" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Document registrations records'            | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''       | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | 'Period'              | 'Resources' | ''       | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '16,26'  | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '84,57'  | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '95'     | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                          | '28.01.2021 18:49:39' | '1'         | '494'    | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                          | '28.01.2021 18:49:39' | '10'        | '569,24' | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                          | '28.01.2021 18:49:39' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                          | '28.01.2021 18:49:39' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
			| ''                                          | '28.01.2021 18:49:39' | '10'        | '3 325'  | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 2 dated 28.01.2021 18:49:39' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
	
		And I close all client application windows
		
Scenario: _0401372 check Sales invoice movements by the Register  "R2021 Customer transactions" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '670,08'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '3 914'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '3 914'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '3 914'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 2 dated 28.01.2021 18:49:39' | 'No'                   |


			
		And I close all client application windows
		
Scenario: _0401382 check Sales invoice movements by the Register  "R4011 Free stocks" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4011 Free stocks"'             |
			
		And I close all client application windows
		
Scenario: _0401392 check Sales invoice movements by the Register  "R4012 Stock Reservation" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows
		
Scenario: _0401402 check Sales invoice movements by the Register  "R2013 Procurement of sales orders" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2013 Procurement of sales orders"
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39'     | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '28.01.2021 18:49:39' | ''                 | ''                    | ''                  | ''                 | ''                 | '1'              | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                              | '28.01.2021 18:49:39' | ''                 | ''                    | ''                  | ''                 | ''                 | '10'             | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   |

		And I close all client application windows
		
Scenario: _0401412 check Sales invoice movements by the Register  "R5011 Partners aging" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R5011 Partners aging"
		And I click "Registrations report" button
		And I select "R5011 Partners aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Partners aging"'                     |
			
		And I close all client application windows
		
Scenario: _0401422 check Sales invoice movements by the Register  "R2020 Advances from customer" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'                     |
			
		And I close all client application windows
		
Scenario: _0401432 check Sales invoice movements by the Register  "R2040 Taxes incoming" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'          | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''    | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '80,51'          | '14,49'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '418,64'         | '75,36'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:49:39' | '2 817,8'        | '507,2'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			
		And I close all client application windows
		
Scenario: _0401442 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39'   | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'              | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"' | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                            | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                            | 'Expense'     | '28.01.2021 18:49:39' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
	
		And I close all client application windows
		
Scenario: _0401452 check Sales invoice movements by the Register  "R4014 Serial lot numbers" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'                     |
			
		And I close all client application windows
		
Scenario: _0401462 check Sales invoice movements by the Register  "R2031 Shipment invoicing" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39' | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''             | ''                                                  | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                                  | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'        | 'Basis'                                             | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:49:39' | '1'         | 'Main Company' | 'Store 02'     | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:49:39' | '10'        | 'Main Company' | 'Store 02'     | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | '36/Red'   |


		And I close all client application windows
		
Scenario: _0401472 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" SO-SC-SI (without shedule)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 2 dated 28.01.2021 18:49:39'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:49:39' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '0a13bddb-cb97-4515-a9ef-777b6924ebf1' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:49:39' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:49:39' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |
		And I close all client application windows

//3

# Scenario: _0401313 check Sales invoice movements by the Register  "R2005 Sales special offers" (SO-SI-SC, without sheduling)
# 	* Select Sales invoice
# 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 		And I go to line in "List" table
# 			| 'Number'  |
# 			| '3' |
# 	* Check movements by the Register  "R2005 Sales special offers"
# 		And I click "Registrations report" button
# 		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
# 		And I click "Generate report" button
# 		Then "ResultTable" spreadsheet document is equal
# 			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Document registrations records'            | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| 'Register  "R2005 Sales special offers"'    | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     | ''                 |
# 			| ''                                          | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              | 'Special offer'    |
# 			| ''                                          | '28.01.2021 18:50:57' | '95'           | '13,78'      | '0,86'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '95'           | '80,51'      | '5'             | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '494'          | '71,67'      | '4,45'          | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '494'          | '418,64'     | '26'            | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '3 325'        | '482,41'     | '29,96'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '3 325'        | '2 817,8'    | '175'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '15 960'       | '2 315,55'   | '143,81'        | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '15 960'       | '13 525,42'  | '840'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '15 960'       | '13 525,42'  | '840'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'DocumentDiscount' |
# 			| ''                                          | '28.01.2021 18:50:57' | '15 960'       | '13 525,42'  | '840'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | 'DocumentDiscount' |


		And I close all client application windows
		
Scenario: _0401323 check Sales invoice movements by the Register  "R5010 Reconciliation statement" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R5010 Reconciliation statement"
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'  | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '28.01.2021 18:50:57' | '19 874'    | 'TRY'        | 'Main Company' | 'Company Ferron BP' |
		And I close all client application windows
		
Scenario: _0401333 check Sales invoice movements by the Register  "R4010 Actual stocks" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4010 Actual stocks"'           | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  |
			
		And I close all client application windows
		
Scenario: _0401343 check Sales invoice movements by the Register  "R2011 Shipment of sales orders" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'  | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                           | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |
			
		And I close all client application windows
		
Scenario: _0401353 check Sales invoice movements by the Register  "R4050 Stock inventory" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'         | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '10'        | 'Main Company' | 'Store 02' | '36/Red'   |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Main Company' | 'Store 02' | '37/18SD'  |
			
		And I close all client application windows
		
Scenario: _0401363 check Sales invoice movements by the Register  "R2001 Sales" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2001 Sales"
		And I click "Registrations report" button
		And I select "R2001 Sales" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Document registrations records'            | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| 'Register  "R2001 Sales"'                   | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                          | ''         | ''                                     |
			| ''                                          | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                   | 'Item key' | 'Row key'                              |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:50:57' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                          | '28.01.2021 18:50:57' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:50:57' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:50:57' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:50:57' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                          | '28.01.2021 18:50:57' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
			| ''                                          | '28.01.2021 18:50:57' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
			| ''                                          | '28.01.2021 18:50:57' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
			| ''                                          | '28.01.2021 18:50:57' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |

		And I close all client application windows
		
Scenario: _0401373 check Sales invoice movements by the Register  "R2021 Customer transactions" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| 'Register  "R2021 Customer transactions"'   | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           |
			| ''                                          | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '3 402,43'  | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '19 874'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '19 874'    | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'No'                   |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '19 874'    | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'No'                   |
			
		And I close all client application windows
		
Scenario: _0401383 check Sales invoice movements by the Register  "R4011 Free stocks" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'             | ''            | ''                    | ''          | ''           | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '24'        | 'Store 02'   | '37/18SD'  |
			| ''                                          | 'Expense'     | '28.01.2021 18:50:57' | '10'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows 
		
Scenario: _0401393 check Sales invoice movements by the Register  "R4012 Stock Reservation" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4012 Stock Reservation"'                     |
			
		And I close all client application windows
		
Scenario: _0401403 check Sales invoice movements by the Register  "R2013 Procurement of sales orders" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2013 Procurement of sales orders"
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'     | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Document registrations records'                | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| 'Register  "R2013 Procurement of sales orders"' | ''                    | ''                 | ''                    | ''                  | ''                 | ''                 | ''               | ''             | ''                                        | ''         |
			| ''                                              | 'Period'              | 'Resources'        | ''                    | ''                  | ''                 | ''                 | ''               | 'Dimensions'   | ''                                        | ''         |
			| ''                                              | ''                    | 'Ordered quantity' | 'Re ordered quantity' | 'Purchase quantity' | 'Receipt quantity' | 'Shipped quantity' | 'Sales quantity' | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                              | '28.01.2021 18:50:57' | ''                 | ''                    | ''                  | ''                 | ''                 | '1'              | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                              | '28.01.2021 18:50:57' | ''                 | ''                    | ''                  | ''                 | ''                 | '10'             | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '36/Red'   |
			| ''                                              | '28.01.2021 18:50:57' | ''                 | ''                    | ''                  | ''                 | ''                 | '24'             | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | '37/18SD'  |

		And I close all client application windows
		
Scenario: _0401413 check Sales invoice movements by the Register  "R5011 Partners aging" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R5011 Partners aging"
		And I click "Registrations report" button
		And I select "R5011 Partners aging" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R5011 Partners aging"'                     |
			
		And I close all client application windows
		
Scenario: _0401423 check Sales invoice movements by the Register  "R2020 Advances from customer" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2020 Advances from customer"
		And I click "Registrations report" button
		And I select "R2020 Advances from customer" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2020 Advances from customer"'                     |
			
		And I close all client application windows
		
Scenario: _0401433 check Sales invoice movements by the Register  "R2040 Taxes incoming" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Document registrations records'            | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'          | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| ''                                          | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''    | ''         | ''                  |
			| ''                                          | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '80,51'          | '14,49'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '418,64'         | '75,36'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '2 817,8'        | '507,2'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '13 525,42'      | '2 434,58'   | 'Main Company' | 'VAT' | '18%'      | ''                  |
			
		And I close all client application windows
		
Scenario: _0401443 check Sales invoice movements by the Register  "R4034 Scheduled goods shipments" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"' |
		And I close all client application windows
		
Scenario: _0401453 check Sales invoice movements by the Register  "R4014 Serial lot numbers" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4014 Serial lot numbers"'                     |
			
		And I close all client application windows
		
Scenario: _0401463 check Sales invoice movements by the Register  "R2031 Shipment invoicing" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57' | ''            | ''                    | ''          | ''             | ''             | ''                                          | ''         |
			| 'Document registrations records'            | ''            | ''                    | ''          | ''             | ''             | ''                                          | ''         |
			| 'Register  "R2031 Shipment invoicing"'      | ''            | ''                    | ''          | ''             | ''             | ''                                          | ''         |
			| ''                                          | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''             | ''                                          | ''         |
			| ''                                          | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'        | 'Basis'                                     | 'Item key' |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '1'         | 'Main Company' | 'Store 02'     | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  |
			| ''                                          | 'Receipt'     | '28.01.2021 18:50:57' | '10'        | 'Main Company' | 'Store 02'     | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   |

		And I close all client application windows
		
Scenario: _0401473 check Sales invoice movements by the Register  "R2012 Invoice closing of sales orders" (SO-SI-SC, without sheduling)
	* Select Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales invoice 3 dated 28.01.2021 18:50:57'         | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                   | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:50:57' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:50:57' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:50:57' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:50:57' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales order 3 dated 27.01.2021 19:50:45' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
		And I close all client application windows



