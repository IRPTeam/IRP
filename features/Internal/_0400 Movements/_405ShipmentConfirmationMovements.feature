#language: en
@tree
@Positive
@Movements
@MovementsShipmentConfirmation

Feature: check Shipment confirmation



Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _040170 preparation (Shipment confirmation)
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
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Shipment confirmation
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |

// 1

Scenario: _040171 check Shipment confirmation movements by the Register  "R4010 Actual stocks"
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4010 Actual stocks"'                   | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Store 02'   | 'XS/Blue'  |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows
		
Scenario: _040172 check Shipment confirmation movements by the Register  "R4022 Shipment of stock transfer orders" (not transfer)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4022 Shipment of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4022 Shipment of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4022 Shipment of stock transfer orders"' |
		And I close all client application windows
		
Scenario: _040173 check Shipment confirmation movements by the Register  "R2011 Shipment of sales orders" (SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2011 Shipment of sales orders"
		And I click "Registrations report" button
		And I select "R2011 Shipment of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| 'Register  "R2011 Shipment of sales orders"'        | ''            | ''                    | ''          | ''             | ''                                        | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Order'                                   | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'XS/Blue'  |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | '36/Red'   |
		And I close all client application windows
		
Scenario: _040174 check Shipment confirmation movements by the Register  "R4032 Goods in transit (outgoing)" (without IT)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4032 Goods in transit (outgoing)"
		And I click "Registrations report" button
		And I select "R4032 Goods in transit (outgoing)" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4032 Goods in transit (outgoing)"' |		
		And I close all client application windows
		
Scenario: _040175 check Shipment confirmation movements by the Register  "R4012 Stock Reservation"
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| 'Register  "R4012 Stock Reservation"'               | ''            | ''                    | ''          | ''           | ''         | ''                                        |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         | ''                                        |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' | 'Order'                                   |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Store 02'   | 'XS/Blue'  | 'Sales order 1 dated 27.01.2021 19:50:45' |
		And I close all client application windows
		
// Scenario: _040176 check Shipment confirmation movements by the Register  "R2013 Procurement of sales orders"
// 	* Select Shipment confirmation
// 		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '1' |
// 	* Check movements by the Register  "R2013 Procurement of sales orders"
// 		And I click "Registrations report" button
// 		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Shipment confirmation 1 dated *'               | '' | '' | '' | '' | '' |
// 			| 'Document registrations records'                | '' | '' | '' | '' | '' |
// 			| 'Register  "R2013 Procurement of sales orders"' | '' | '' | '' | '' | '' |
			
// 		And I close all client application windows
		
Scenario: _040177 check Shipment confirmation movements by the Register  "R4034 Scheduled goods shipments" (use sheduling, SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| 'Register  "R4034 Scheduled goods shipments"'       | ''            | ''                    | ''          | ''             | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                                        | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Basis'                                   | 'Store'    | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '1'         | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | 'XS/Blue'  | '63008c12-b682-4aff-b29f-e6927036b05a' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Main Company' | 'Sales order 1 dated 27.01.2021 19:50:45' | 'Store 02' | '36/Red'   | 'e34f52ea-1fe2-47b2-9b37-63c093896662' |	
		And I close all client application windows


Scenario: _0401771 check Shipment confirmation movements by the Register  "R4034 Scheduled goods shipments" (not use sheduling, SO exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '2' |
	* Check movements by the Register  "R4034 Scheduled goods shipments"
		And I click "Registrations report" button
		And I select "R4034 Scheduled goods shipments" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R4034 Scheduled goods shipments"'       |
		And I close all client application windows




Scenario: _040178 check Shipment confirmation movements by the Register  "R2031 Shipment invoicing" (SI exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '3' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 3 dated 28.01.2021 18:52:05' | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| 'Register  "R2031 Shipment invoicing"'              | ''            | ''                    | ''          | ''             | ''         | ''                                          | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                          | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                     | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '1'         | 'Main Company' | 'Store 02' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | 'XS/Blue'  |
			| ''                                                  | 'Expense'     | '28.01.2021 18:52:05' | '10'        | 'Main Company' | 'Store 02' | 'Sales invoice 3 dated 28.01.2021 18:50:57' | '36/Red'   |
		And I close all client application windows

Scenario: _0401781 check Shipment confirmation movements by the Register  "R2031 Shipment invoicing" (SI not exists)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R2031 Shipment invoicing"
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''             | ''         | ''                                                  | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''             | ''         | ''                                                  | ''         |
			| 'Register  "R2031 Shipment invoicing"'              | ''            | ''                    | ''          | ''             | ''         | ''                                                  | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                                  | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                             | 'Item key' |
			| ''                                                  | 'Receipt'     | '28.01.2021 18:42:17' | '1'         | 'Main Company' | 'Store 02' | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | 'XS/Blue'  |
			| ''                                                  | 'Receipt'     | '28.01.2021 18:42:17' | '10'        | 'Main Company' | 'Store 02' | 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | '36/Red'   |
		And I close all client application windows

Scenario: _040179 check Shipment confirmation movements by the Register  "R4011 Free stocks" (not transfer)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '1' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Shipment confirmation 1 dated 28.01.2021 18:42:17' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                     | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                  | 'Expense'     | '28.01.2021 18:42:17' | '10'        | 'Store 02'   | '36/Red'   |
		And I close all client application windows

//4

Scenario: _040179 check Shipment confirmation movements by the Register  "R4011 Free stocks" (not transfer)
	* Select Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
			| 'Number'  |
			| '4' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Shipment confirmation 4 dated 16.02.2021 12:14:52' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'                     | ''            | ''                    | ''          | ''           | ''         |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                                  | 'Expense'     | '16.02.2021 12:14:52' | '25'        | 'Store 02'   | 'XS/Blue'  |
		And I close all client application windows