#language: en
@tree
@Positive
@Movements
@MovementsSalesReturnOrder

Feature: check Sales return movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041200 preparation (Sales return order)
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
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
	* Load Bank receipt
		When Create document BankReceipt objects (check movements, advance)
		And I execute 1C:Enterprise script at server
 			| "Documents.BankReceipt.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |	
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales return order
		When Create document SalesReturnOrder objects (check movements)
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows

Scenario: _041201 check Sales return order movements by the Register  "R2010 Sales orders"
	And I close all client application windows
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
	* Check movements by the Register  "R2010 Sales orders"
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''                     |
			| 'Document registrations records'                   | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''                     |
			| 'Register  "R2010 Sales orders"'                   | ''                    | ''          | ''         | ''           | ''              | ''             | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''                     |
			| ''                                                 | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | 'Attributes'           |
			| ''                                                 | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Order'                                            | 'Item key' | 'Row key'                              | 'Procurement method' | 'Deferred calculation' |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | ''                   | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' | ''                   | 'No'                   |
	And I close all client application windows

Scenario: _041201 check Sales return order movements by the Register  "R2012 Invoice closing of sales orders"
	And I close all client application windows
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54'  | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                            | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Receipt'     | '12.03.2021 09:19:54' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Receipt'     | '12.03.2021 09:19:54' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Receipt'     | '12.03.2021 09:19:54' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Receipt'     | '12.03.2021 09:19:54' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |		
	And I close all client application windows


Scenario: _041220 Sales return order clear posting
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2012 Invoice closing of sales orders' |
			| 'R2010 Sales orders' |
		And I close all client application windows