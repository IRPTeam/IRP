#language: en
@tree
@Positive
@Movements
@MovementsPurchaseOrderClosing

Feature: check Purchase order closing movements

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario: _041158 preparation (Purchase order closing)
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
		When Create information register Taxes records (VAT)
	When Create Document discount
	* Add plugin for discount
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"          |
				| "DocumentDiscount"     |
			When add Plugin for document discount
			When Create catalog CancelReturnReasons objects
	*Load Purchase order and Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		If "List" table does not contain lines Then
				| "Number"     |
				| "37"         |
			When Create document PurchaseOrder objects (for check closing)
			And I execute 1C:Enterprise script at server
				| "Documents.PurchaseOrder.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document PurchaseInvoice objects (movements, purchase order closing)
		And I execute 1C:Enterprise script at server
				| "Documents.PurchaseInvoice.FindByNumber(37).GetObject().Write(DocumentWriteMode.Posting);"     |
		When Create document GoodsReceipt objects (movements, purchase order closing)
		And I execute 1C:Enterprise script at server
				| "Documents.GoodsReceipt.FindByNumber(38).GetObject().Write(DocumentWriteMode.Posting);"     |
		And I close all client application windows
	* Load Purchase order closing document
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '37'        |
		And I click the button named "FormDocumentPurchaseOrderClosingGenerate"
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Shirt'   | '38/Black'    |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'XS/Blue'     |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'      | 'Item key'    |
			| 'Service'   | 'Rent'        |
		And I select current line in "ItemList" table
		And I click choice button of "Cancel reason" attribute in "ItemList" table
		And I select current line in "List" table		
		* Post document
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrderClosing37$$" variable
			And I delete "$$PurchaseOrderClosing37$$" variable
			And I delete "$$DatePurchaseOrderClosing37$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrderClosing37$$"
			And I save the window as "$$PurchaseOrderClosing37$$"
			And I save the value of the field named "Date" as  "$$DatePurchaseOrderClosing37$$"
			And I click the button named "FormPostAndClose"						
		// When Create document PurchaseOrderClosing objects (check movements)
		// And I execute 1C:Enterprise script at server
 		// 	| "Documents.PurchaseOrderClosing.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		// Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		// And I go to line in "List" table
		// 	| 'Number' |
		// 	| '2'      |
		// And in the table "List" I click the button named "ListContextMenuPost"
		And I close all client application windows
		
Scenario: _0411581 check preparation
	When check preparation		
				



Scenario: _041159 check Purchase order closing movements by the Register  "Register  "R1010 Purchase orders""
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R2010 Purchase orders" 
		And I click "Registrations report" button
		And I select "R1010 Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'          | ''                                 | ''            | ''            | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                        |
			| 'Document registrations records'      | ''                                 | ''            | ''            | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                        |
			| 'Register  "R1010 Purchase orders"'   | ''                                 | ''            | ''            | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                        |
			| ''                                    | 'Period'                           | 'Resources'   | ''            | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | 'Attributes'              |
			| ''                                    | ''                                 | 'Quantity'    | 'Amount'      | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Order'                                         | 'Item key'   | 'Row key'                                | 'Deferred calculation'    |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-64'         | '-7 680'      | '-6 508,47'    | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-64'         | '-7 680'      | '-6 508,47'    | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-64'         | '-1 314,82'   | '-1 114,25'    | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-1'          | '-100'        | '-84,75'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-1'          | '-100'        | '-84,75'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '-1'          | '-17,12'      | '-14,51'       | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '1'           | '25,68'       | '21,76'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | '38/Black'   | 'b5d168e5-e60d-44c9-9168-b13a2695077f'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '1'           | '150'         | '127,12'       | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | '38/Black'   | 'b5d168e5-e60d-44c9-9168-b13a2695077f'   | 'No'                      |
			| ''                                    | '$$DatePurchaseOrderClosing37$$'   | '1'           | '150'         | '127,12'       | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | '38/Black'   | 'b5d168e5-e60d-44c9-9168-b13a2695077f'   | 'No'                      |
		
		And I close all client application windows
		
Scenario: _041160 check Purchase order closing movements by the Register  "R2014 Canceled Purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R2014 Canceled Purchase orders" 
		And I click "Registrations report" button
		And I select "R1014 Canceled Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'                   | ''                                 | ''            | ''           | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                | ''                        |
			| 'Document registrations records'               | ''                                 | ''            | ''           | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                | ''                        |
			| 'Register  "R1014 Canceled purchase orders"'   | ''                                 | ''            | ''           | ''             | ''               | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                | ''                        |
			| ''                                             | 'Period'                           | 'Resources'   | ''           | ''             | 'Dimensions'     | ''               | ''                               | ''           | ''                                              | ''           | ''                                       | ''                | 'Attributes'              |
			| ''                                             | ''                                 | 'Quantity'    | 'Amount'     | 'Net amount'   | 'Company'        | 'Branch'         | 'Multi currency movement type'   | 'Currency'   | 'Order'                                         | 'Item key'   | 'Row key'                                | 'Cancel reason'   | 'Deferred calculation'    |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '1'           | '17,12'      | '14,51'        | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'not available'   | 'No'                      |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '1'           | '100'        | '84,75'        | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'not available'   | 'No'                      |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '1'           | '100'        | '84,75'        | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'Rent'       | 'da5e404f-fed0-41c5-81dc-b8eadd89e699'   | 'not available'   | 'No'                      |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '64'          | '1 314,82'   | '1 114,25'     | 'Main Company'   | 'Front office'   | 'Reporting currency'             | 'USD'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'not available'   | 'No'                      |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '64'          | '7 680'      | '6 508,47'     | 'Main Company'   | 'Front office'   | 'Local currency'                 | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'not available'   | 'No'                      |
			| ''                                             | '$$DatePurchaseOrderClosing37$$'   | '64'          | '7 680'      | '6 508,47'     | 'Main Company'   | 'Front office'   | 'en description is empty'        | 'TRY'        | 'Purchase order 37 dated 09.03.2021 14:29:00'   | 'XS/Blue'    | '0e65d648-bd28-47a2-84dc-e260219c1395'   | 'not available'   | 'No'                      |
		And I close all client application windows
		

		
Scenario: _041162 check Purchase order closing movements by the Register  "R1011 Receipt of purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R2011 Shipment of Purchase orders" 
		And I click "Registrations report" button
		And I select "R1011 Receipt of purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'                   | ''            | ''                               | ''          | ''             | ''             | ''                                            | ''         | ''                                     |
			| 'Document registrations records'               | ''            | ''                               | ''          | ''             | ''             | ''                                            | ''         | ''                                     |
			| 'Register  "R1011 Receipt of purchase orders"' | ''            | ''                               | ''          | ''             | ''             | ''                                            | ''         | ''                                     |
			| ''                                             | 'Record type' | 'Period'                         | 'Resources' | 'Dimensions'   | ''             | ''                                            | ''         | ''                                     |
			| ''                                             | ''            | ''                               | 'Quantity'  | 'Company'      | 'Branch'       | 'Order'                                       | 'Item key' | 'Row key'                              |
			| ''                                             | 'Receipt'     | '$$DatePurchaseOrderClosing37$$' | '-64'       | 'Main Company' | 'Front office' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' |
			| ''                                             | 'Receipt'     | '$$DatePurchaseOrderClosing37$$' | '1'         | 'Main Company' | 'Front office' | 'Purchase order 37 dated 09.03.2021 14:29:00' | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' |
		And I close all client application windows
		
		

		
Scenario: _041165 check Purchase order closing movements by the Register  "R2013 Procurement of sales orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R2013 Procurement of sales orders" 
		And I click "Registrations report" button
		And I select "R2013 Procurement of sales orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R2013 Procurement of sales orders"'    |
		And I close all client application windows
		
Scenario: _041166 check Purchase order closing movements by the Register  ""R4033 Scheduled goods receipts""
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R4033 Scheduled goods receipts" 
		And I click "Registrations report" button
		And I select "R4033 Scheduled goods receipts" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Register  "R4033 Scheduled goods receipts"'    |
		And I close all client application windows
		
Scenario: _041167 check Purchase order closing movements by the Register  "R1012 Invoice closing of Purchase orders"
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Check movements by the Register  "R2012 Invoice closing of Purchase orders" 
		And I click "Registrations report info" button
		And I select "R1012 Invoice closing of Purchase orders" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'                           | ''                               | ''           | ''             | ''             | ''                                            | ''         | ''         | ''                                     | ''         | ''       | ''           |
			| 'Register  "R1012 Invoice closing of purchase orders"' | ''                               | ''           | ''             | ''             | ''                                            | ''         | ''         | ''                                     | ''         | ''       | ''           |
			| ''                                                     | 'Period'                         | 'RecordType' | 'Company'      | 'Branch'       | 'Order'                                       | 'Currency' | 'Item key' | 'Row key'                              | 'Quantity' | 'Amount' | 'Net amount' |
			| ''                                                     | '$$DatePurchaseOrderClosing37$$' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'TRY'      | 'XS/Blue'  | '0e65d648-bd28-47a2-84dc-e260219c1395' | '-64'      | '-7 680' | '-6 508,47'  |
			| ''                                                     | '$$DatePurchaseOrderClosing37$$' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'TRY'      | '38/Black' | 'b5d168e5-e60d-44c9-9168-b13a2695077f' | '1'        | '150'    | '127,12'     |
			| ''                                                     | '$$DatePurchaseOrderClosing37$$' | 'Receipt'    | 'Main Company' | 'Front office' | 'Purchase order 37 dated 09.03.2021 14:29:00' | 'TRY'      | 'Rent'     | 'da5e404f-fed0-41c5-81dc-b8eadd89e699' | '-1'       | '-100'   | '-84,75'     |
		And I close all client application windows



Scenario: _041169 Purchase order closing clear posting/mark for deletion
	* Select Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
	* Clear posting
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'        |
			| 'Document registrations records'    |
		And I close current window
	* Post Purchase order closing
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
		And in the table "List" I click the button named "ListContextMenuPost"		
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1010 Purchase orders'                       |
			| 'R4035 Incoming stocks'                       |
			| 'R1011 Receipt of purchase orders'            |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows
	* Mark for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$PurchaseOrderClosing37$$'        |
			| 'Document registrations records'    |
		And I close current window
	* Unmark for deletion and post document
		Given I open hyperlink "e1cib/list/Document.PurchaseOrderClosing"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberPurchaseOrderClosing37$$'    |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button				
		Then user message window does not contain messages
		And in the table "List" I click the button named "ListContextMenuPost"	
		Then user message window does not contain messages
		And I click "Registrations report" button
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document contains values
			| 'R1010 Purchase orders'                       |
			| 'R4035 Incoming stocks'                       |
			| 'R1011 Receipt of purchase orders'            |
			| 'R1012 Invoice closing of purchase orders'    |
		And I close all client application windows

