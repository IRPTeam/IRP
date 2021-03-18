#language: en
@tree
@Positive
@Movements
@MovementsPurchaseOrderClosing

Feature: check Purchase order closing movements



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _041158 preparation (Purchase order closing)
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
	*Load Purchase order and Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number" |
				| "37" |
			When Create document PurchaseOrder objects (for check closing)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document PurchaseInvoice objects (movements, purchase order closing)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Purchase order closing document
		When Create document PurchaseOrderClosing objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.PurchaseOrderClosing.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number' |
			| '2'      |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		
		
				



Scenario: _041159 check Purchase order closing movements by the Register  "Register  "R1010 Purchase orders""
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order closing 2 dated 09.03.2021 15:41:08' | ''                    | ''          | ''          | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''                     |
			| 'Document registrations records'                     | ''                    | ''          | ''          | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''                     |
			| 'Register  "R1010 Purchase orders"'                  | ''                    | ''          | ''          | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''                     |
			| ''                                                   | 'Period'              | 'Resources' | ''          | ''           | 'Dimensions'   | ''                             | ''         | ''                                            | ''         | ''                                     | 'Attributes'           |
			| ''                                                   | ''                    | 'Quantity'  | 'Amount'    | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                       | 'Item key' | 'Row key'                              | 'Deferred calculation' |
			| ''                                                   | '09.03.2021 15:41:08' | '-64'       | '-7 680'    | '-6 508,47'  | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-64'       | '-7 680'    | '-6 508,47'  | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-64'       | '-7 680'    | '-6 508,47'  | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-64'       | '-1 314,82' | '-1 114,25'  | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-1'        | '-100'      | '-84,75'     | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-1'        | '-100'      | '-84,75'     | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-1'        | '-100'      | '-84,75'     | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '-1'        | '-17,12'    | '-14,51'     | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '25,68'     | '25,68'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '150'       | '150'        | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '150'       | '150'        | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '150'       | '150'        | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' | 'No'                   |
		
		And I close all client application windows
		
Scenario: _041160 check Purchase order closing movements by the Register  "R2014 Canceled Purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2014 Canceled Purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order closing 2 dated 09.03.2021 15:41:08' | ''                    | ''          | ''         | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''              | ''                     |
			| 'Document registrations records'                     | ''                    | ''          | ''         | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''              | ''                     |
			| 'Register  "R1014 Canceled purchase orders"'         | ''                    | ''          | ''         | ''           | ''             | ''                             | ''         | ''                                            | ''         | ''                                     | ''              | ''                     |
			| ''                                                   | 'Period'              | 'Resources' | ''         | ''           | 'Dimensions'   | ''                             | ''         | ''                                            | ''         | ''                                     | ''              | 'Attributes'           |
			| ''                                                   | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                       | 'Item key' | 'Row key'                              | 'Cancel reason' | 'Deferred calculation' |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '17,12'    | '14,51'      | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '100'      | '84,75'      | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '100'      | '84,75'      | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '1'         | '100'      | '84,75'      | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '64'        | '1 314,82' | '1 114,25'   | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '64'        | '7 680'    | '6 508,47'   | 'Main Company' | 'Local currency'               | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '64'        | '7 680'    | '6 508,47'   | 'Main Company' | 'TRY'                          | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'not available' | 'No'                   |
			| ''                                                   | '09.03.2021 15:41:08' | '64'        | '7 680'    | '6 508,47'   | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | 'not available' | 'No'                   |	
		And I close all client application windows
		
// Scenario: _041161 check Purchase order closing movements by the Register  "R4013 Stock Reservation planning"
// 	* Select Purchase order closing
// 		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '2' |
// 	* Check movements by the Register  "R4013 Stock Reservation planning" 
// 		And I click "Registrations report" button
// 		And I select "R4013 Stock Reservation planning" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Purchase order closing 1 dated *'					 	  | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''          |
// 			| 'Register  "R4013 Stock Reservation planning"'                     | ''            | ''                    | ''          | ''           | ''          |
			
// 		And I close all client application windows
		
Scenario: _041162 check Purchase order closing movements by the Register  "R2011 Shipment of Purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2011 Shipment of Purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order closing 2 dated 09.03.2021 15:41:08' | ''            | ''                    | ''          | ''             | ''                                            | ''         |
			| 'Document registrations records'                     | ''            | ''                    | ''          | ''             | ''                                            | ''         |
			| 'Register  "R1011 Receipt of purchase orders"'       | ''            | ''                    | ''          | ''             | ''                                            | ''         |
			| ''                                                   | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                            | ''         |
			| ''                                                   | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                       | 'Item key' |
			| ''                                                   | 'Receipt'     | '09.03.2021 15:41:08' | '-64'       | 'Main Company' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  |
			| ''                                                   | 'Receipt'     | '09.03.2021 15:41:08' | '1'         | 'Main Company' | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' |

		And I close all client application windows
		
		

		
Scenario: _041165 check Purchase order closing movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'   |
		And I close all client application windows
		
Scenario: _041166 check Purchase order closing movements by the Register  ""R4033 Scheduled goods receipts""
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Register  "R4033 Scheduled goods receipts"'     |
		And I close all client application windows
		
Scenario: _041167 check Purchase order closing movements by the Register  "R1012 Invoice closing of Purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R2012 Invoice closing of Purchase orders" 
		And I click "Registrations report" button
		And I select "R1012 Invoice closing of Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Purchase order closing 2 dated 09.03.2021 15:41:08'   | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                            | ''         | ''         | ''                                     |
			| 'Document registrations records'                       | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                            | ''         | ''         | ''                                     |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                            | ''         | ''         | ''                                     |
			| ''                                                     | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                            | ''         | ''         | ''                                     |
			| ''                                                     | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                       | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                     | 'Receipt'     | '09.03.2021 15:41:08' | '-64'       | '-7 680' | '-6 508,47'  | 'Main Company' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'TRY'      | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' |
			| ''                                                     | 'Receipt'     | '09.03.2021 15:41:08' | '1'         | '150,00' | '127,12'     | 'Main Company' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'TRY'      | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' |
		And I close all client application windows


