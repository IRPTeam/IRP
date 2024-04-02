#language: en
@tree
@Positive
@Movements
@MovementsInventoryTransferOrder


Feature: check Inventory transfer order movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _04027 preparation (Inventory transfer order)
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
		When Create catalog Stores objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
		When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
		When Create document InternalSupplyRequest objects (check movements)
		And I execute 1C:Enterprise script at server
				| "Documents.InternalSupplyRequest.FindByNumber(117).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseOrder objects (check movements, PI before GR, not Use receipt sheduling)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseOrder.FindByNumber(115).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document InventoryTransferOrder objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(201).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransferOrder.FindByNumber(202).GetObject().Write(DocumentWriteMode.Posting);"    |

Scenario: _040271 check preparation
	When check preparation

Scenario: _040322 check Inventory transfer order movements by the Register  "R4011 Free stocks"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''             | ''            |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''             | ''            |
			| 'Register  "R4011 Free stocks"'                           | ''              | ''         | ''            | ''             | ''            |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''            |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Store'        | 'Item key'    |
			| ''                                                        | 'Expense'       | '*'        | '10'          | 'Store 02'     | 'XS/Blue'     |
			| ''                                                        | 'Expense'       | '*'        | '15'          | 'Store 02'     | '36/Red'      |
		And I close all client application windows

		
Scenario: _040332 check Inventory transfer order movements by the Register  "R4035 Incoming stocks" 
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4035 Incoming stocks"
		And I click "Registrations report" button
		And I select "R4035 Incoming stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''             | ''            | ''                                                |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''             | ''            | ''                                                |
			| 'Register  "R4035 Incoming stocks"'                       | ''              | ''         | ''            | ''             | ''            | ''                                                |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''            | ''                                                |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Store'        | 'Item key'    | 'Order'                                           |
			| ''                                                        | 'Expense'       | '*'        | '2'           | 'Store 02'     | '36/Yellow'   | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
			| ''                                                        | 'Expense'       | '*'        | '10'          | 'Store 02'     | 'S/Yellow'    | 'Purchase order 115 dated 12.02.2021 12:44:43'    |
		And I close all client application windows
		


Scenario: _040342 check Inventory transfer order movements by the Register  "R4012 Stock Reservation"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''             | ''           | ''                                                         |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''             | ''           | ''                                                         |
			| 'Register  "R4012 Stock Reservation"'                     | ''              | ''         | ''            | ''             | ''           | ''                                                         |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''           | ''                                                         |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Store'        | 'Item key'   | 'Order'                                                    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 02'     | 'XS/Blue'    | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
			| ''                                                        | 'Receipt'       | '*'        | '15'          | 'Store 02'     | '36/Red'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
		And I close all client application windows



Scenario: _040352 check Inventory transfer order movements by the Register  "R4036 Incoming stock requested"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4036 Incoming stock requested"
		And I click "Registrations report" button
		And I select "R4036 Incoming stock requested" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''                 | ''                  | ''            | ''                                               | ''                                                         |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''                 | ''                  | ''            | ''                                               | ''                                                         |
			| 'Register  "R4036 Incoming stock requested"'              | ''              | ''         | ''            | ''                 | ''                  | ''            | ''                                               | ''                                                         |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'       | ''                  | ''            | ''                                               | ''                                                         |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Incoming store'   | 'Requester store'   | 'Item key'    | 'Order'                                          | 'Requester'                                                |
			| ''                                                        | 'Receipt'       | '*'        | '2'           | 'Store 02'         | 'Store 03'          | '36/Yellow'   | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 02'         | 'Store 03'          | 'S/Yellow'    | 'Purchase order 115 dated 12.02.2021 12:44:43'   | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
		And I close all client application windows


Scenario: _040353 check Inventory transfer order movements by the Register  "R4020 Stock transfer orders"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4036 Incoming stock requested"
		And I click "Registrations report" button
		And I select "R4020 Stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''         | ''            | ''               | ''                 | ''                                                        | ''            | ''                                        |
			| 'Document registrations records'                          | ''         | ''            | ''               | ''                 | ''                                                        | ''            | ''                                        |
			| 'Register  "R4020 Stock transfer orders"'                 | ''         | ''            | ''               | ''                 | ''                                                        | ''            | ''                                        |
			| ''                                                        | 'Period'   | 'Resources'   | 'Dimensions'     | ''                 | ''                                                        | ''            | ''                                        |
			| ''                                                        | ''         | 'Quantity'    | 'Store sender'   | 'Store receiver'   | 'Order'                                                   | 'Item key'    | 'Row key'                                 |
			| ''                                                        | '*'        | '2'           | 'Store 02'       | 'Store 03'         | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Yellow'   | 'df4ec2c2-14c2-4a70-aec1-d27906584614'    |
			| ''                                                        | '*'        | '10'          | 'Store 02'       | 'Store 03'         | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'S/Yellow'    | '3763dcf2-bd05-44d9-9e30-0412d7630470'    |
			| ''                                                        | '*'        | '10'          | 'Store 02'       | 'Store 03'         | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'XS/Blue'     | '1f6222fc-519f-4295-8ab7-e365ba03d652'    |
			| ''                                                        | '*'        | '15'          | 'Store 02'       | 'Store 03'         | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Red'      | 'e36683ed-7c81-4fcd-b5e6-631a57e2305c'    |
		And I close all client application windows

Scenario: _040354 check Inventory transfer order movements by the Register  "R4021 Receipt of stock transfer orders"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4021 Receipt of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4021 Receipt of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| 'Register  "R4021 Receipt of stock transfer orders"'      | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''                                                        | ''            | ''                                        |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Store'        | 'Order'                                                   | 'Item key'    | 'Row key'                                 |
			| ''                                                        | 'Receipt'       | '*'        | '2'           | 'Store 03'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Yellow'   | 'df4ec2c2-14c2-4a70-aec1-d27906584614'    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 03'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'S/Yellow'    | '3763dcf2-bd05-44d9-9e30-0412d7630470'    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 03'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'XS/Blue'     | '1f6222fc-519f-4295-8ab7-e365ba03d652'    |
			| ''                                                        | 'Receipt'       | '*'        | '15'          | 'Store 03'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Red'      | 'e36683ed-7c81-4fcd-b5e6-631a57e2305c'    |
		And I close all client application windows

Scenario: _040355 check Inventory transfer order movements by the Register  "R4022 Shipment of stock transfer orders"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4022 Shipment of stock transfer orders"
		And I click "Registrations report" button
		And I select "R4022 Shipment of stock transfer orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| 'Document registrations records'                          | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| 'Register  "R4022 Shipment of stock transfer orders"'     | ''              | ''         | ''            | ''             | ''                                                        | ''            | ''                                        |
			| ''                                                        | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''                                                        | ''            | ''                                        |
			| ''                                                        | ''              | ''         | 'Quantity'    | 'Store'        | 'Order'                                                   | 'Item key'    | 'Row key'                                 |
			| ''                                                        | 'Receipt'       | '*'        | '2'           | 'Store 02'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Yellow'   | 'df4ec2c2-14c2-4a70-aec1-d27906584614'    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 02'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'S/Yellow'    | '3763dcf2-bd05-44d9-9e30-0412d7630470'    |
			| ''                                                        | 'Receipt'       | '*'        | '10'          | 'Store 02'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | 'XS/Blue'     | '1f6222fc-519f-4295-8ab7-e365ba03d652'    |
			| ''                                                        | 'Receipt'       | '*'        | '15'          | 'Store 02'     | 'Inventory transfer order 21 dated 16.02.2021 16:14:02'   | '36/Red'      | 'e36683ed-7c81-4fcd-b5e6-631a57e2305c'    |
		And I close all client application windows

Scenario: _040356 check Inventory transfer order movements by the Register  "R4016 Ordering of internal supply requests"
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Check movements by the Register  "R4016 Ordering of internal supply requests"
		And I click "Registrations report" button
		And I select "R4016 Ordering of internal supply requests" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Register  "R4016 Ordering of internal supply requests"'    |
		And I close all client application windows

Scenario: _040357 check Inventory transfer order movements by the Register  "R4011 Free stocks" (not use GR and SC)
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4011 Free stocks"
		And I click "Registrations report" button
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 201 dated 28.02.2021 20:17:48'   | ''              | ''         | ''            | ''             | ''             |
			| 'Document registrations records'                           | ''              | ''         | ''            | ''             | ''             |
			| 'Register  "R4011 Free stocks"'                            | ''              | ''         | ''            | ''             | ''             |
			| ''                                                         | 'Record type'   | 'Period'   | 'Resources'   | 'Dimensions'   | ''             |
			| ''                                                         | ''              | ''         | 'Quantity'    | 'Store'        | 'Item key'     |
			| ''                                                         | 'Expense'       | '*'        | '2'           | 'Store 02'     | '36/Yellow'    |
			| ''                                                         | 'Expense'       | '*'        | '10'          | 'Store 02'     | 'S/Yellow'     |
			| ''                                                         | 'Expense'       | '*'        | '10'          | 'Store 02'     | 'XS/Blue'      |
			| ''                                                         | 'Expense'       | '*'        | '15'          | 'Store 02'     | '36/Red'       |
		And I close all client application windows

Scenario: _040358 check Inventory transfer order movements by the Register  "R4012 Stock Reservation" (not use GR and SC)
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '201'       |
	* Check movements by the Register  "R4012 Stock Reservation"
		And I click "Registrations report info" button
		And I select "R4012 Stock Reservation" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | ''                    | ''           | ''         | ''          | ''                                                       | ''         |
			| 'Register  "R4012 Stock Reservation"'                    | ''                    | ''           | ''         | ''          | ''                                                       | ''         |
			| ''                                                       | 'Period'              | 'RecordType' | 'Store'    | 'Item key'  | 'Order'                                                  | 'Quantity' |
			| ''                                                       | '02.04.2024 14:26:09' | 'Receipt'    | 'Store 02' | 'S/Yellow'  | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | '10'       |
			| ''                                                       | '02.04.2024 14:26:09' | 'Receipt'    | 'Store 02' | 'XS/Blue'   | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | '10'       |
			| ''                                                       | '02.04.2024 14:26:09' | 'Receipt'    | 'Store 02' | '36/Yellow' | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | '2'        |
			| ''                                                       | '02.04.2024 14:26:09' | 'Receipt'    | 'Store 02' | '36/Red'    | 'Inventory transfer order 201 dated 28.02.2021 20:17:48' | '15'       |
		And I close all client application windows


Scenario: _0403589 Inventory transfer order clear posting/mark for deletion
	* Select Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
			| 'Document registrations records'                           |
		And I close current window
	* Post Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'              |
			| 'R4012 Stock Reservation'        |
			| 'R4020 Stock transfer orders'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Inventory transfer order 21 dated 16.02.2021 16:14:02'    |
			| 'Document registrations records'                           |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '21'        |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R4011 Free stocks'              |
			| 'R4012 Stock Reservation'        |
			| 'R4020 Stock transfer orders'    |
		And I close all client application windows
