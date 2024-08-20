#language: en
@tree
@Positive
@CreationBasedMulti

Feature: create Purchase invoices and Sales invoices based on Goods receipt and Shipment confirmation

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _090500 preparation (create PI and SI based on Goods receipt and Shipment confirmation)
	When set True value to the constant
	* Load info
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		Given I open hyperlink "e1cib/app/DataProcessor.SystemSettings"
		And I set checkbox "Number editing available"
		And I close "System settings" window



Scenario: _0905001 check preparation
	When check preparation

# Sales order - Purchase order - Goods receipt - Purchase invoice - Shipment confirmation - Sales invoice
Scenario: _090501 creation of Sales invoice based on Shipment confirmation (one to one)
	* Create test Sales order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		And I click the button named "FormPost"
	* Create Sales invoice based on Shipment confirmation
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
	* Check filling in Sales invoice
		And "ItemList" table contains lines
		| 'Net amount'  | 'Item'      | 'Price'  | 'Item key'   | 'Quantity'  | 'Offers amount'  | 'Tax amount'  | 'Unit'  | 'Total amount'  | 'Store'     | 'Delivery date'  | 'Sales order'   |
		| '*'           | 'Trousers'  | '*'      | '38/Yellow'  | '5,000'     | ''               | '*'           | 'pcs'   | '*'             | 'Store 02'  | '*'              | '*'             |
		And I click the button named "FormPostAndClose"
		And I close all client application windows

Scenario: _090502 create a purchase invoice based on Goods receipt (one to one)
	* Create test Purchase order and Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		And I click the button named "FormPost"
	* Create Purchase invoice based on Goods receipt
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
	* Check filling in Purchase invoice
		And "ItemList" table contains lines
		| 'Net amount'  | 'Item'      | 'Price'   | 'Item key'   | 'Quantity'  | 'Tax amount'  | 'Unit'  | 'Total amount'  | 'Store'     | 'Delivery date'  | 'Expense type'  | 'Profit loss center'  | 'Purchase order'   |
		| '847,46'      | 'Trousers'  | '500,00'  | '38/Yellow'  | '2,000'     | '152,54'      | 'pcs'   | '1 000,00'      | 'Store 02'  | '*'              | ''              | ''                    | '*'                |
		And I click the button named "FormPostAndClose"

Scenario: _090503 create Sales invoice based on several Shipment confirmation
	* Create test first order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		* Change the document number to 458
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "458" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test second order and Shipment confirmation for the same customer and for the same commercial conditions
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		* Change the document number to 459
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "459" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test third order and Shipment confirmation for another customer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		* Change the document number to 460
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "460" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create Sales invoice based on created Shipment confirmation (should be created 2)
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
		| 'Number'   |
		| '458'      |
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
				| 'VAT'    | 'Item'        | 'Price'     | 'Item key'     | 'Tax amount'    | 'Quantity'    | 'Price type'           | 'Unit'    | 'Dont calculate row'    | 'Net amount'    | 'Total amount'    | 'Store'       | 'Sales order'     |
				| '18%'    | 'Trousers'    | '400,00'    | '36/Yellow'    | '610,17'        | '10,000'      | 'Basic Price Types'    | 'pcs'     | 'No'                    | '3 389,83'      | '4 000,00'        | 'Store 02'    | '*'               |
		And in the table "ItemList" I click "Shipment confirmations" button
		And "DocumentsTree" table contains lines
			| 'Presentation'                 | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Trousers (36/Yellow)'         | '10,000'    | '10,000'               | '10,000'      |
			| 'Shipment confirmation 460*'   | ''          | '10,000'               | '10,000'      |
		And I close current window
		And I click the button named "FormPostAndClose"
		When I click command interface button "Sales invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Comment" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'   | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'    |
			| '*'            | 'Trousers'   | '*'       | '38/Yellow'   | '5,000'      | ''                | '*'            | 'pcs'    | '*'              | 'Store 02'   | '*'                |
			| '*'            | 'Trousers'   | '*'       | '36/Yellow'   | '5,000'      | ''                | '*'            | 'pcs'    | '*'              | 'Store 02'   | '*'                |
		And in the table "ItemList" I click "Shipment confirmations" button
		And "DocumentsTree" table contains lines
			| 'Presentation'                 | 'Invoice'   | 'QuantityInDocument'   | 'Quantity'    |
			| 'Trousers (38/Yellow)'         | '5,000'     | '5,000'                | '5,000'       |
			| 'Shipment confirmation 458*'   | ''          | '5,000'                | '5,000'       |
			| 'Trousers (36/Yellow)'         | '5,000'     | '5,000'                | '5,000'       |
			| 'Shipment confirmation 459*'   | ''          | '5,000'                | '5,000'       |
		And I close current window
		And I click the button named "FormPostAndClose"
	And I close all client application windows


Scenario: _090504 create Purchase invoice based on several Goods receipt
	* Create test Purchase order and Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		* Change the document number to 2023
			And I input "2023" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2023" text in "Number" field
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		* Change the document number to 471
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "471" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test Purchase order and Goods receipt on the same vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		* Change the document number to 2024
			And I input "2024" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2024" text in "Number" field
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		* Change the document number to 472
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "472" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test Purchase order and Goods receipt on the another vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Second Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "350,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		* Change the document number to 2025
			And I input "2025" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2025" text in "Number" field
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		* Change the document number to 473
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "473" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on created Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
		| 'Number'   |
		| '471'      |
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Expense type'   | 'Profit loss center'   | 'Purchase order'   | 'Sales order'    |
			| '847,46'       | 'Trousers'   | '500,00'   | '38/Yellow'   | '2,000'      | ''                | '152,54'       | 'pcs'    | '1 000,00'       | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
			| '677,97'       | 'Trousers'   | '400,00'   | '38/Yellow'   | '2,000'      | ''                | '122,03'       | 'pcs'    | '800,00'         | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Expense type'   | 'Profit loss center'   | 'Purchase order'   | 'Sales order'    |
			| '2 966,10'     | 'Trousers'   | '350,00'   | '38/Yellow'   | '10,000'     | ''                | '533,90'       | 'pcs'    | '3 500,00'       | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Expense type'   | 'Profit loss center'   | 'Purchase order'   | 'Sales order'    |
			| '847,46'       | 'Trousers'   | '500,00'   | '38/Yellow'   | '2,000'      | ''                | '152,54'       | 'pcs'    | '1 000,00'       | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
			| '677,97'       | 'Trousers'   | '400,00'   | '38/Yellow'   | '2,000'      | ''                | '122,03'       | 'pcs'    | '800,00'         | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount'   | 'Item'       | 'Price'    | 'Item key'    | 'Quantity'   | 'Offers amount'   | 'Tax amount'   | 'Unit'   | 'Total amount'   | 'Store'      | 'Delivery date'   | 'Expense type'   | 'Profit loss center'   | 'Purchase order'   | 'Sales order'    |
			| '2 966,10'     | 'Trousers'   | '350,00'   | '38/Yellow'   | '10,000'     | ''                | '533,90'       | 'pcs'    | '3 500,00'       | 'Store 02'   | '*'               | ''               | ''                     | '*'                | ''               |
		And I click the button named "FormPostAndClose"
		And I close all client application windows

Scenario: _090505 creation of Sales invoice based on several Shipment confirmation (different currency)
# should be created 2 Sales invoice
	* Create test first order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                  |
			| 'Personal Partner terms, $'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		* Change the document number to 465
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "465" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test second order and Shipment confirmation for the same customer and for the same commercial conditions
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                 |
			| 'Basic Partner terms, TRY'    |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '36/Yellow'    |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click the button named "FormPost"
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "OK" button
		* Change the document number to 466
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "466" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create Sales invoice - should be created 2
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
		| 'Number'   |
		| '465'      |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Personal Partner terms, $" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Tax amount'   | 'Price type'          | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'   | 'Shipment confirmation'         |
			| '400,00'   | 'Trousers'   | '18%'   | '38/Yellow'   | '5,000'      | '324,88'       | 'Basic Price Types'   | 'pcs'    | '1 675,12'     | '2 000,00'       | 'Store 02'   | '*'             | 'Shipment confirmation 465*'    |
		If the field named "Agreement" is equal to "Basic Partner terms, TRY" Then
			And "ItemList" table contains lines
			| 'Price'    | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Tax amount'   | 'Price type'          | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'    |
			| '400,00'   | 'Trousers'   | '18%'   | '36/Yellow'   | '5,000'      | '305,08'       | 'Basic Price Types'   | 'pcs'    | '1 694,92'     | '2 000,00'       | 'Store 02'   | '*'              |
			And in the table "ItemList" I click "Shipment confirmations" button
			And "DocumentsTree" table contains lines
				| 'Presentation'                  | 'Invoice'    | 'QuantityInDocument'    | 'Quantity'     |
				| 'Trousers (36/Yellow)'          | '5,000'      | '5,000'                 | '5,000'        |
				| 'Shipment confirmation 466*'    | ''           | '5,000'                 | '5,000'        |
			And I close current window			
		And I click the button named "FormPostAndClose"
		When I click command interface button "Sales invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Personal Partner terms, $" Then
			And "ItemList" table contains lines
			| 'Price'   | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Tax amount'   | 'Price type'          | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'    |
			| '68,48'   | 'Trousers'   | '18%'   | '38/Yellow'   | '5,000'      | '52,23'        | 'Basic Price Types'   | 'pcs'    | '290,17'       | '342,40'         | 'Store 02'   | '*'              |
			And in the table "ItemList" I click "Shipment confirmations" button
			And "DocumentsTree" table contains lines
				| 'Presentation'                  | 'Invoice'    | 'QuantityInDocument'    | 'Quantity'     |
				| 'Trousers (38/Yellow)'          | '5,000'      | '5,000'                 | '5,000'        |
				| 'Shipment confirmation 465*'    | ''           | '5,000'                 | '5,000'        |
			And I close current window				
		If the field named "Agreement" is equal to "Basic Partner terms, TRY" Then
			And "ItemList" table contains lines
			| 'Price'   | 'Item'       | 'VAT'   | 'Item key'    | 'Quantity'   | 'Tax amount'   | 'Price type'          | 'Unit'   | 'Net amount'   | 'Total amount'   | 'Store'      | 'Sales order'    |
			| '68,48'   | 'Trousers'   | '18%'   | '36/Yellow'   | '5,000'      | '52,23'        | 'Basic Price Types'   | 'pcs'    | '290,17'       | '342,40'         | 'Store 02'   | '*'              |
			And "ShipmentConfirmationsTree" table contains lines
			| 'Item'       | 'Item key'    | 'Shipment confirmation'        | 'Invoice'   | 'SC'      | 'Quantity'    |
			| 'Trousers'   | '36/Yellow'   | ''                             | '5,000'     | '5,000'   | '5,000'       |
			| ''           | ''            | 'Shipment confirmation 466*'   | ''          | '5,000'   | '5,000'       |
		And I click the button named "FormPostAndClose"
		And I close all client application windows


Scenario: _090506 create Purchase invoice based on several Goods receipt
	* Create test Purchase order and Goods receipt
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		* Change the document number to 465
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "465" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create test Purchase order and Goods receipt on the same customer
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, USD'    |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPost"
		And I move to "Other" tab
		And I expand "More" group
		And I click the button named "FormPost"
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		* Change the document number to 466
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "466" text in "Number" field
		And I click the button named "FormPostAndClose"
	* Create Purchase invoice based on created Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
		| 'Number'   |
		| '465'      |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron, USD" Then
			And "ItemList" table contains lines
				| 'Net amount'    | 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Offers amount'    | 'Tax amount'    | 'Unit'    | 'Total amount'    | 'Store'       | 'Delivery date'    | 'Expense type'    | 'Profit loss center'    | 'Purchase order'    | 'Sales order'     |
				| '677,97'        | 'Trousers'    | '400,00'    | '38/Yellow'    | '2,000'       | ''                 | '122,03'        | 'pcs'     | '800,00'          | 'Store 02'    | '*'                | ''                | ''                      | '*'                 | ''                |
		If the field named "Agreement" is equal to "Vendor Ferron, TRY" Then
			And "ItemList" table contains lines
				| 'Net amount'    | 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Offers amount'    | 'Tax amount'    | 'Unit'    | 'Total amount'    | 'Store'       | 'Delivery date'    | 'Expense type'    | 'Profit loss center'    | 'Purchase order'    | 'Sales order'     |
				| '847,46'        | 'Trousers'    | '500,00'    | '38/Yellow'    | '2,000'       | ''                 | '152,54'        | 'pcs'     | '1 000,00'        | 'Store 02'    | '*'                | ''                | ''                      | '*'                 | ''                |
		And I click the button named "FormPostAndClose"
		When I click command interface button "Purchase invoice (create)"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron, USD" Then
			And "ItemList" table contains lines
				| 'Net amount'    | 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Offers amount'    | 'Tax amount'    | 'Unit'    | 'Total amount'    | 'Store'       | 'Delivery date'    | 'Expense type'    | 'Profit loss center'    | 'Purchase order'    | 'Sales order'     |
				| '677,97'        | 'Trousers'    | '400,00'    | '38/Yellow'    | '2,000'       | ''                 | '122,03'        | 'pcs'     | '800,00'          | 'Store 02'    | '*'                | ''                | ''                      | '*'                 | ''                |
		If the field named "Agreement" is equal to "Vendor Ferron, TRY" Then
			And "ItemList" table contains lines
				| 'Net amount'    | 'Item'        | 'Price'     | 'Item key'     | 'Quantity'    | 'Offers amount'    | 'Tax amount'    | 'Unit'    | 'Total amount'    | 'Store'       | 'Delivery date'    | 'Expense type'    | 'Profit loss center'    | 'Purchase order'    | 'Sales order'     |
				| '847,46'        | 'Trousers'    | '500,00'    | '38/Yellow'    | '2,000'       | ''                 | '152,54'        | 'pcs'     | '1 000,00'        | 'Store 02'    | '*'                | ''                | ''                      | '*'                 | ''                |
		And I click the button named "FormPostAndClose"
		And I close all client application windows



