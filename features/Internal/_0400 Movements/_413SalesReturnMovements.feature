#language: en
@tree
@Positive
@Movements
@MovementsSalesReturn

Feature: check Sales return movements



Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041300 preparation (Sales return)
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
 			| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
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
	* Load Goods
		When Create document GoodsReceipt objects (check movements, transaction type - return from customers)
		And I execute 1C:Enterprise script at server
 			| "Documents.GoodsReceipt.FindByNumber(125).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales return order
		When Create document SalesReturnOrder objects (check movements)
		And Delay 5
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'  |
			| '102' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		When Create document SalesInvoice objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesInvoice.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
		When Create document BankReceipt objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
 			| "Documents.BankReceipt.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	* Load Sales return
		When Create document SalesReturn objects (check movements)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(101).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(102).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(103).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(105).GetObject().Write(DocumentWriteMode.Posting);" |
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '104' |
		And in the table "List" I click the button named "ListContextMenuPost"
		When Create document SalesReturn objects (offsetting advances on returns)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesReturn.FindByNumber(106).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(107).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(108).GetObject().Write(DocumentWriteMode.Posting);" |
			| "Documents.SalesReturn.FindByNumber(109).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
	

Scenario: _041301 check Sales return movements by the Register "R5010 Reconciliation statement"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'TRY'        | 'Main Company' | 'Company Ferron BP' |		
	And I close all client application windows

Scenario: _041302 check Sales return movements by the Register "R5010 Reconciliation statement"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R5010 Reconciliation statement" 
		And I click "Registrations report" button
		And I select "R5010 Reconciliation statement" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| 'Register  "R5010 Reconciliation statement"' | ''            | ''                    | ''          | ''           | ''             | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''             | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Currency'   | 'Company'      | 'Legal name'        |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'TRY'        | 'Main Company' | 'Company Ferron BP' |		
	And I close all client application windows

Scenario: _041303 check Sales return movements by the Register  "R2005 Sales special offers"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2005 Sales special offers"
		And I click "Registrations report" button
		And I select "R2005 Sales special offers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                           | ''         | ''                                     | ''                 |
			| 'Document registrations records'             | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                           | ''         | ''                                     | ''                 |
			| 'Register  "R2005 Sales special offers"'     | ''                    | ''             | ''           | ''              | ''                 | ''             | ''                             | ''         | ''                                           | ''         | ''                                     | ''                 |
			| ''                                           | 'Period'              | 'Resources'    | ''           | ''              | ''                 | 'Dimensions'   | ''                             | ''         | ''                                           | ''         | ''                                     | ''                 |
			| ''                                           | ''                    | 'Sales amount' | 'Net amount' | 'Offers amount' | 'Net offer amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice'                                    | 'Item key' | 'Row key'                              | 'Special offer'    |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-665'         | '-563,56'    | '-35'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-494'         | '-418,64'    | '-26'           | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-113,85'       | '-96,48'     | '-5,99'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return 101 dated 12.03.2021 08:44:18' | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'Local currency'               | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'TRY'                          | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-95'          | '-80,51'     | '-5'            | ''                 | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-84,57'       | '-71,67'     | '-4,45'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | 'DocumentDiscount' |
			| ''                                           | '12.03.2021 08:44:18' | '-16,26'       | '-13,78'     | '-0,86'         | ''                 | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Sales return 101 dated 12.03.2021 08:44:18' | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | 'DocumentDiscount' |
					
	And I close all client application windows

Scenario: _041304 check Sales return movements by the Register  "R2002 Sales returns"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2002 Sales returns"
		And I click "Registrations report" button
		And I select "R2002 Sales returns" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''        | ''         | ''                                     | ''              | ''                     |
			| 'Document registrations records'             | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''        | ''         | ''                                     | ''              | ''                     |
			| 'Register  "R2002 Sales returns"'            | ''                    | ''          | ''       | ''           | ''             | ''                             | ''         | ''        | ''         | ''                                     | ''              | ''                     |
			| ''                                           | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                             | ''         | ''        | ''         | ''                                     | ''              | 'Attributes'           |
			| ''                                           | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Invoice' | 'Item key' | 'Row key'                              | 'Return reason' | 'Deferred calculation' |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '16,26'  | '13,78'      | 'Main Company' | 'Reporting currency'           | 'USD'      | ''        | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '84,57'  | '71,67'      | 'Main Company' | 'Reporting currency'           | 'USD'      | ''        | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Local currency'               | 'TRY'      | ''        | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'TRY'                          | 'TRY'      | ''        | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '95'     | '80,51'      | 'Main Company' | 'en description is empty'      | 'TRY'      | ''        | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Local currency'               | 'TRY'      | ''        | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'TRY'                          | 'TRY'      | ''        | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '1'         | '494'    | '418,64'     | 'Main Company' | 'en description is empty'      | 'TRY'      | ''        | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '113,85' | '96,48'      | 'Main Company' | 'Reporting currency'           | 'USD'      | ''        | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'Local currency'               | 'TRY'      | ''        | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'TRY'                          | 'TRY'      | ''        | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'No'                   |
			| ''                                           | '12.03.2021 08:44:18' | '2'         | '665'    | '563,56'     | 'Main Company' | 'en description is empty'      | 'TRY'      | ''        | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' | ''              | 'No'                   |			
	And I close all client application windows

Scenario: _041305 check Sales return movements by the Register  "R4050 Stock inventory"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4050 Stock inventory"
		And I click "Registrations report" button
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''         |
			| 'Register  "R4050 Stock inventory"'          | ''            | ''                    | ''          | ''             | ''         | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Main Company' | 'Store 02' | 'XS/Blue'  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Main Company' | 'Store 02' | '36/Red'   |			
	And I close all client application windows


Scenario: _041306 check Sales return movements by the Register  "R2021 Customer transactions"
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | ''                     | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''                  | ''          | ''                         | ''                                          | 'Attributes'           | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'        | 'Partner'   | 'Agreement'                | 'Basis'                                     | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-1 254'    | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '-214,68'   | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Ferron BP' | 'Ferron BP' | 'Basic Partner terms, TRY' | 'Sales invoice 1 dated 28.01.2021 18:48:53' | 'No'                   | ''                |
	And I close all client application windows

Scenario: _041307 check Sales return movements by the Register  "R2040 Taxes incoming"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2040 Taxes incoming"
		And I click "Registrations report" button
		And I select "R2040 Taxes incoming" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| 'Register  "R2040 Taxes incoming"'           | ''            | ''                    | ''               | ''           | ''             | ''    | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources'      | ''           | 'Dimensions'   | ''    | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Taxable amount' | 'Tax amount' | 'Company'      | 'Tax' | 'Tax rate' | 'Tax movement type' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '80,51'          | '14,49'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '418,64'         | '75,36'      | 'Main Company' | 'VAT' | '18%'      | ''                  |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '563,56'         | '101,44'     | 'Main Company' | 'VAT' | '18%'      | ''                  |			
	And I close all client application windows

Scenario: _041308 check Sales return movements by the Register  "R4014 Serial lot numbers"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '105' |
	* Check movements by the Register  "R4014 Serial lot numbers"
		And I click "Registrations report" button
		And I select "R4014 Serial lot numbers" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 105 dated 12.03.2021 09:49:05' | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| 'Register  "R4014 Serial lot numbers"'       | ''            | ''                    | ''          | ''             | ''         | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                  |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Item key' | 'Serial lot number' |
			| ''                                           | 'Receipt'     | '12.03.2021 09:49:05' | '10'        | 'Main Company' | '36/Red'   | '0512'              |		
	And I close all client application windows

Scenario: _041309 check Sales return movements by the Register  "R5021 Revenues"
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R5021 Revenues"
		And I click "Registrations report" button
		And I select "R5021 Revenues" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''                    | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| 'Document registrations records'             | ''                    | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| 'Register  "R5021 Revenues"'                 | ''                    | ''          | ''             | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                           | 'Period'              | 'Resources' | 'Dimensions'   | ''                        | ''             | ''         | ''         | ''                    | ''                             |
			| ''                                           | ''                    | 'Amount'    | 'Company'      | 'Profit loss center'           | 'Revenue type' | 'Item key' | 'Currency' | 'Additional analytic' | 'Multi currency movement type' |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | 'Main Company' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | 'Main Company' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-563,56'   | 'Main Company' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | 'Main Company' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | 'Main Company' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-418,64'   | 'Main Company' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-96,48'    | 'Main Company' | 'Distribution department' | 'Revenue'      | '36/Red'   | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | 'Main Company' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'Local currency'               |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | 'Main Company' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'TRY'                          |
			| ''                                           | '12.03.2021 08:44:18' | '-80,51'    | 'Main Company' | 'Distribution department' | 'Revenue'      | 'Interner' | 'TRY'      | ''                    | 'en description is empty'      |
			| ''                                           | '12.03.2021 08:44:18' | '-71,67'    | 'Main Company' | 'Distribution department' | 'Revenue'      | 'XS/Blue'  | 'USD'      | ''                    | 'Reporting currency'           |
			| ''                                           | '12.03.2021 08:44:18' | '-13,78'    | 'Main Company' | 'Distribution department' | 'Revenue'      | 'Interner' | 'USD'      | ''                    | 'Reporting currency'           |
	And I close all client application windows



Scenario: _041310 check Sales return movements by the Register  "R4010 Actual stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4010 Actual stocks"'            | ''            | ''                    | ''          | ''           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Store 02'   | '36/Red'   |
		
	And I close all client application windows


Scenario: _041311 check Sales return movements by the Register  "R4010 Actual stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4010 Actual stocks"
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4010 Actual stocks" |	
	And I close all client application windows

Scenario: _041312 check Sales return movements by the Register  "R4011 Free stocks" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R4011 Free stocks" |	
	And I close all client application windows

Scenario: _041313 check Sales return movements by the Register  "R4011 Free stocks" (not use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''           | ''         |
			| 'Register  "R4011 Free stocks"'              | ''            | ''                    | ''          | ''           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Store'      | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '2'         | 'Store 02'   | '36/Red'   |			
	And I close all client application windows

Scenario: _041314 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18'    | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                           | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                           | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                      | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Store 02'   | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  |
	And I close all client application windows


Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                            | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                       | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:59:52' | '2'         | 'Store 01'   | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |		
	And I close all client application windows

Scenario: _041315 check Sales return movements by the Register  "R4031 Goods in transit (incoming)" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R4031 Goods in transit (incoming)"
		And I click "Registrations report" button
		And I select "R4031 Goods in transit (incoming)" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52'    | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Document registrations records'                | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| 'Register  "R4031 Goods in transit (incoming)"' | ''            | ''                    | ''          | ''           | ''                                            | ''         |
			| ''                                              | 'Record type' | 'Period'              | 'Resources' | 'Dimensions' | ''                                            | ''         |
			| ''                                              | ''            | ''                    | 'Quantity'  | 'Store'      | 'Basis'                                       | 'Item key' |
			| ''                                              | 'Receipt'     | '12.03.2021 08:59:52' | '2'         | 'Store 01'   | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |		
	And I close all client application windows

Scenario: _041316 check Sales return movements by the Register  "R2031 Shipment invoicing" (use GR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '101' |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 101 dated 12.03.2021 08:44:18' | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         |
			| 'Register  "R2031 Shipment invoicing"'       | ''            | ''                    | ''          | ''             | ''         | ''                                           | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                           | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                      | 'Item key' |
			| ''                                           | 'Receipt'     | '12.03.2021 08:44:18' | '1'         | 'Main Company' | 'Store 02' | 'Sales return 101 dated 12.03.2021 08:44:18' | 'XS/Blue'  |
	And I close all client application windows

Scenario: _041317 check Sales return movements by the Register  "R2031 Shipment invoicing" (GR-SR)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R2031 Shipment invoicing""
		And I click "Registrations report" button
		And I select "R2031 Shipment invoicing" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''         |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''         |
			| 'Register  "R2031 Shipment invoicing"'       | ''            | ''                    | ''          | ''             | ''         | ''                                            | ''         |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''         | ''                                            | ''         |
			| ''                                           | ''            | ''                    | 'Quantity'  | 'Company'      | 'Store'    | 'Basis'                                       | 'Item key' |
			| ''                                           | 'Expense'     | '12.03.2021 08:59:52' | '2'         | 'Main Company' | 'Store 01' | 'Goods receipt 125 dated 12.03.2021 08:56:32' | 'XS/Blue'  |			
	And I close all client application windows

Scenario: _041318 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (without SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| Register  "R2012 Invoice closing of sales orders" |	
	And I close all client application windows

Scenario: _041319 check Sales return movements by the Register  "R2012 Invoice closing of sales orders" (with SRO)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '104' |
	* Check movements by the Register  "R2012 Invoice closing of sales orders""
		And I click "Registrations report" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 104 dated 12.03.2021 09:20:35'        | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| 'Document registrations records'                    | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''            | ''                    | ''          | ''       | ''           | ''             | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | 'Record type' | 'Period'              | 'Resources' | ''       | ''           | 'Dimensions'   | ''                                                 | ''         | ''         | ''                                     |
			| ''                                                  | ''            | ''                    | 'Quantity'  | 'Amount' | 'Net amount' | 'Company'      | 'Order'                                            | 'Currency' | 'Item key' | 'Row key'                              |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '1'         | '95'     | '80,51'      | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'Interner' | '835ca87f-804e-4f3b-b02a-7a1f5d49abe0' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '1'         | '494'    | '418,64'     | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'XS/Blue'  | '0cb89084-5857-45fc-b333-4fbec2c2e90a' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '10'        | '3 325'  | '2 817,8'    | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '36/Red'   | '3a8fe357-b7bd-4d83-8816-c8348bbf4595' |
			| ''                                                  | 'Expense'     | '12.03.2021 09:20:35' | '24'        | '15 960' | '13 525,42'  | 'Main Company' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '37/18SD'  | 'f06154aa-5906-4824-9983-19e2bc9ccb96' |
	And I close all client application windows

Scenario: _041321 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - True)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '106' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 106 dated 21.04.2021 14:19:47' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''              | ''        | ''                         | ''                                            | 'Attributes'           | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'    | 'Partner' | 'Agreement'                | 'Basis'                                       | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | 'Receipt'     | '21.04.2021 14:19:47' | '-9 360'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:19:47' | '-9 360'    | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:19:47' | '-9 360'    | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:19:47' | '-1 602,43' | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
	And I close all client application windows



Scenario: _041323 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - False)
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '107' |
	* Check movements by the Register  "R2021 Customer transactions"
		And I click "Registrations report" button
		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 107 dated 21.04.2021 14:24:43' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                            | ''                     | ''                  |
			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''              | ''        | ''                         | ''                                            | 'Attributes'           | ''                  |
			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'    | 'Partner' | 'Agreement'                | 'Basis'                                       | 'Deferred calculation' | 'Customers advances closing' |
			| ''                                           | 'Receipt'     | '21.04.2021 14:24:43' | '-520'      | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:24:43' | '-520'      | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:24:43' | '-520'      | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
			| ''                                           | 'Receipt'     | '21.04.2021 14:24:43' | '-89,02'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Lunch' | 'Lunch'   | 'Basic Partner terms, TRY' | 'Sales invoice 101 dated 21.04.2021 14:10:58' | 'No'                   | ''                |
	And I close all client application windows




// Scenario: _041325 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - False, SI-BR, SR more than due)
// 	And I close all client application windows
// 	* Select Sales return
// 		Given I open hyperlink "e1cib/list/Document.SalesReturn"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '108' |
// 	* Check movements by the Register  "R2021 Customer transactions"
// 		And I click "Registrations report" button
// 		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		And "ResultTable" spreadsheet document does not contain values
// 			| Register  "R2020 Advances from customer" |
// 	And I close all client application windows

// Scenario: _041326 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - False, SI-BR, SR more than due)
// 	And I close all client application windows
// 	* Select Sales return
// 		Given I open hyperlink "e1cib/list/Document.SalesReturn"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '108' |
// 	* Check movements by the Register  "R2021 Customer transactions"
// 		And I click "Registrations report" button
// 		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales return 108 dated 21.04.2021 14:28:53' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''              | ''        | ''                         | ''                                           | 'Attributes'           |
// 			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'    | 'Partner' | 'Agreement'                | 'Basis'                                      | 'Deferred calculation' |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:28:53' | '-1 040'    | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:28:53' | '-1 040'    | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:28:53' | '-1 040'    | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:28:53' | '-178,05'   | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 	And I close all client application windows

// Scenario: _041327 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - True, SI-BR, SR more than due)
// 	And I close all client application windows
// 	* Select Sales return
// 		Given I open hyperlink "e1cib/list/Document.SalesReturn"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '109' |
// 	* Check movements by the Register  "R2021 Customer transactions"
// 		And I click "Registrations report" button
// 		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		And "ResultTable" spreadsheet document does not contain values
// 			| Register  "R2020 Advances from customer" |
// 	And I close all client application windows

// Scenario: _041328 check Sales return movements by the Register  "R2021 Customer transactions" (Due as advance - False, SI-BR, SR more than due)
// 	And I close all client application windows
// 	* Select Sales return
// 		Given I open hyperlink "e1cib/list/Document.SalesReturn"
// 		And I go to line in "List" table
// 			| 'Number'  |
// 			| '109' |
// 	* Check movements by the Register  "R2021 Customer transactions"
// 		And I click "Registrations report" button
// 		And I select "R2021 Customer transactions" exact value from "Register" drop-down list
// 		And I click "Generate report" button
// 		Then "ResultTable" spreadsheet document is equal
// 			| 'Sales return 109 dated 21.04.2021 14:29:22' | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| 'Document registrations records'             | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| 'Register  "R2021 Customer transactions"'    | ''            | ''                    | ''          | ''             | ''                             | ''         | ''              | ''        | ''                         | ''                                           | ''                     |
// 			| ''                                           | 'Record type' | 'Period'              | 'Resources' | 'Dimensions'   | ''                             | ''         | ''              | ''        | ''                         | ''                                           | 'Attributes'           |
// 			| ''                                           | ''            | ''                    | 'Amount'    | 'Company'      | 'Multi currency movement type' | 'Currency' | 'Legal name'    | 'Partner' | 'Agreement'                | 'Basis'                                      | 'Deferred calculation' |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:29:22' | '-520'      | 'Main Company' | 'Local currency'               | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:29:22' | '-520'      | 'Main Company' | 'TRY'                          | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:29:22' | '-520'      | 'Main Company' | 'en description is empty'      | 'TRY'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 			| ''                                           | 'Receipt'     | '21.04.2021 14:29:22' | '-89,02'    | 'Main Company' | 'Reporting currency'           | 'USD'      | 'Company Maxim' | 'Maxim'   | 'Basic Partner terms, TRY' | 'Sales invoice 11 dated 21.04.2021 14:11:32' | 'No'                   |
// 	And I close all client application windows


Scenario: _041330 Sales return clear posting/mark for deletion
	And I close all client application windows
	* Select Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' |
			| 'Document registrations records'                    |
		And I close current window
	* Post Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing' |
			| 'R5010 Reconciliation statement' |
			| 'R2002 Sales returns' |
			| 'R4050 Stock inventory' |
			| 'R2021 Customer transactions' |
			| 'R4031 Goods in transit (incoming)' |
			| 'R2040 Taxes incoming' |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return 103 dated 12.03.2021 08:59:52' |
			| 'Document registrations records'                    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I go to line in "List" table
			| 'Number'  |
			| '103' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2031 Shipment invoicing' |
			| 'R5010 Reconciliation statement' |
			| 'R2002 Sales returns' |
			| 'R4050 Stock inventory' |
			| 'R2021 Customer transactions' |
			| 'R4031 Goods in transit (incoming)' |
			| 'R2040 Taxes incoming' |
		And I close all client application windows