#language: en
@tree
@Positive
@Movements
@MovementsSalesReturnOrder

Feature: check Sales return movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _041200 preparation (Sales return order)
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
		When Create catalog SerialLotNumbers objects
		When Create catalog CashAccounts objects
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	* Load Bank receipt
		When Create document BankReceipt objects (check movements, advance)
		And I execute 1C:Enterprise script at server
				| "Documents.BankReceipt.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);"     |
	* Load SO
			When Create document SalesOrder objects (check movements, SC before SI, Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SC before SI, not Use shipment sheduling)
			When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		When Create document SalesOrder objects (SI more than SO)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server	
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesOrder.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesOrder.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load SC
		When Create document ShipmentConfirmation objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.ShipmentConfirmation.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Sales invoice document
		When Create document SalesInvoice objects (check movements)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(4).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(5).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Write);"      |
			| "Documents.SalesInvoice.FindByNumber(8).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Load Sales return order
		When Create document SalesReturnOrder objects (check movements)
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows

Scenario: _0412001 check preparation
	When check preparation

Scenario: _041201 check Sales return order movements by the Register  "R2010 Sales orders"
	And I close all client application windows
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
	* Check movements by the Register  "R2010 Sales orders"
		And I click "Registrations report" button
		And I select "R2010 Sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54' | ''                    | ''          | ''         | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''             | ''                     |
			| 'Document registrations records'                   | ''                    | ''          | ''         | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''             | ''                     |
			| 'Register  "R2010 Sales orders"'                   | ''                    | ''          | ''         | ''           | ''              | ''             | ''                        | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''             | ''                     |
			| ''                                                 | 'Period'              | 'Resources' | ''         | ''           | ''              | 'Dimensions'   | ''                        | ''                             | ''         | ''                                                 | ''         | ''                                     | ''                   | ''             | 'Attributes'           |
			| ''                                                 | ''                    | 'Quantity'  | 'Amount'   | 'Net amount' | 'Offers amount' | 'Company'      | 'Branch'                  | 'Multi currency movement type' | 'Currency' | 'Order'                                            | 'Item key' | 'Row key'                              | 'Procurement method' | 'Sales person' | 'Deferred calculation' |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '16,26'    | '13,78'      | '0,86'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Internet' | '37e26a55-1218-4af2-a620-5129b5ac46c9' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '84,57'    | '71,67'      | '4,45'          | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '9504489e-16cb-4b67-9691-4fef4a8c41e5' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Internet' | '37e26a55-1218-4af2-a620-5129b5ac46c9' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '95'       | '80,51'      | '5'             | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'Internet' | '37e26a55-1218-4af2-a620-5129b5ac46c9' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '9504489e-16cb-4b67-9691-4fef4a8c41e5' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '1'         | '494'      | '418,64'     | '26'            | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'XS/Blue'  | '9504489e-16cb-4b67-9691-4fef4a8c41e5' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '569,24'   | '482,41'     | '29,96'         | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '51779d1c-2838-4ad7-b00f-42a0f64224ba' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '51779d1c-2838-4ad7-b00f-42a0f64224ba' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '10'        | '3 325'    | '2 817,8'    | '175'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/Red'   | '51779d1c-2838-4ad7-b00f-42a0f64224ba' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '2 732,35' | '2 315,55'   | '143,81'        | 'Main Company' | 'Distribution department' | 'Reporting currency'           | 'USD'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/18SD'  | '77531307-5aaa-44a6-a1df-979318620e56' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Distribution department' | 'Local currency'               | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/18SD'  | '77531307-5aaa-44a6-a1df-979318620e56' | ''                   | ''             | 'No'                   |
			| ''                                                 | '12.03.2021 09:19:54' | '24'        | '15 960'   | '13 525,42'  | '840'           | 'Main Company' | 'Distribution department' | 'en description is empty'      | 'TRY'      | 'Sales return order 102 dated 12.03.2021 09:19:54' | '36/18SD'  | '77531307-5aaa-44a6-a1df-979318620e56' | ''                   | ''             | 'No'                   |		
	And I close all client application windows

Scenario: _041201 check Sales return order movements by the Register  "R2012 Invoice closing of sales orders"
	And I close all client application windows
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
	* Check movements by the Register  "R2012 Invoice closing of sales orders"
		And I click "Registrations report info" button
		And I select "R2012 Invoice closing of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54'  | ''                    | ''           | ''             | ''                        | ''                                                 | ''         | ''         | ''                                     | ''         | ''       | ''           |
			| 'Register  "R2012 Invoice closing of sales orders"' | ''                    | ''           | ''             | ''                        | ''                                                 | ''         | ''         | ''                                     | ''         | ''       | ''           |
			| ''                                                  | 'Period'              | 'RecordType' | 'Company'      | 'Branch'                  | 'Order'                                            | 'Currency' | 'Item key' | 'Row key'                              | 'Quantity' | 'Amount' | 'Net amount' |
			| ''                                                  | '12.03.2021 09:19:54' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'XS/Blue'  | '9504489e-16cb-4b67-9691-4fef4a8c41e5' | '1'        | '494'    | '418,64'     |
			| ''                                                  | '12.03.2021 09:19:54' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '36/Red'   | '51779d1c-2838-4ad7-b00f-42a0f64224ba' | '10'       | '3 325'  | '2 817,8'    |
			| ''                                                  | '12.03.2021 09:19:54' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | '36/18SD'  | '77531307-5aaa-44a6-a1df-979318620e56' | '24'       | '15 960' | '13 525,42'  |
			| ''                                                  | '12.03.2021 09:19:54' | 'Receipt'    | 'Main Company' | 'Distribution department' | 'Sales return order 102 dated 12.03.2021 09:19:54' | 'TRY'      | 'Internet' | '37e26a55-1218-4af2-a620-5129b5ac46c9' | '1'        | '95'     | '80,51'      |
	And I close all client application windows


Scenario: _041220 Sales return order clear posting/mark for deletion
	* Select Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54'    |
			| 'Document registrations records'                      |
		And I close current window
	* Post Sales return order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2012 Invoice closing of sales orders'    |
			| 'R2010 Sales orders'                       |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| 'Sales return order 102 dated 12.03.2021 09:19:54'    |
			| 'Document registrations records'                      |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '102'       |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R2012 Invoice closing of sales orders'    |
			| 'R2010 Sales orders'                       |
		And I close all client application windows
