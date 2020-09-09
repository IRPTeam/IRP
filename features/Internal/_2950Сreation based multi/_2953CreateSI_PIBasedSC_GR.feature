#language: en
@tree
@Positive
@Group16
Feature: create Purchase invoices and Sales invoices based on Goods receipt and Shipment confirmation


Background:
	Given I launch TestClient opening script or connect the existing one


# Sales order - Purchase order - Goods reciept - Purchase invoice - Shipment confirmation - Sales invoice
Scenario: _090501 creation of Sales invoice based on Shipment confirmation (one to one)
	* Create test Sales order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click "Post" button
		And I click "Shipment confirmation" button
		And I click "Post" button
	* Create Sales invoice based on Shipment confirmation
		And I click "Sales invoice" button
	* Check filling in Sales invoice
		And "ItemList" table contains lines
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount'  | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Sales order'                   | 'Shipment confirmation'      |
		| '*'          | 'Trousers' | '*'      | '38/Yellow' | '5,000' | ''               | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | '*'                             | '*'                          |
		And I click "Post and close" button
		And I close all client application windows

Scenario: _090502 create a purchase invoice based on Goods reciept (one to one)
	* Create test Purchase order and Goods reciept
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		And I click "Post" button
		And I click "Goods receipt" button
		And I click "Post" button
	* Create Purchase invoice based on Goods receipt
		And I click "Purchase invoice" button
	* Check filling in Purchase invoice
		And "ItemList" table contains lines
		| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      |
		| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | '*'                  |
		And I click "Post and close" button

Scenario: _090503 create Sales invoice based on several Shipment confirmation
	* Create test first order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click "Post" button
		And I click "Shipment confirmation" button
		* Change the document number to 458
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "458" text in "Number" field
		And I click "Post and close" button
	* Create test second order and Shipment confirmation for the same customer and for the same commercial conditions
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click "Post" button
		And I click "Shipment confirmation" button
		* Change the document number to 459
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "459" text in "Number" field
		And I click "Post and close" button
	* Create test third order and Shipment confirmation for another customer
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click "Post" button
		And I click "Shipment confirmation" button
		* Change the document number to 460
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "460" text in "Number" field
		And I click "Post and close" button
	* Create Sales invoice based on created Shipment confirmation (should be created 2)
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
		| 'Number' |
		| '458'    |
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Shipment confirmation'      |
			| '*'          | 'Trousers' | '*'      | '36/Yellow' | '10,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 460*' |
		And I click "Post and close" button
		When I click command interface button "Sales invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Shipment confirmation'      |
			| '*'          | 'Trousers' | '*'      | '38/Yellow' | '5,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 458*' |
			| '*'          | 'Trousers' | '*'      | '36/Yellow' | '5,000' | ''              | '*'          | 'pcs'  | '*'            | 'Store 02' | '*'             | 'Shipment confirmation 459*' |
		And I click "Post and close" button
	And I close all client application windows


Scenario: _090504 create Purchase invoice based on several Goods reciept
	* Create test Purchase order and Goods reciept
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		* Change the document number to 2023
			And I input "2023" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2023" text in "Number" field
		And I click "Post" button
		And I click "Goods receipt" button
		* Change the document number to 471
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "471" text in "Number" field
		And I click "Post and close" button
	* Create test Purchase order and Goods reciept on the same vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		* Change the document number to 2024
			And I input "2024" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2024" text in "Number" field
		And I click "Post" button
		And I click "Goods receipt" button
		* Change the document number to 472
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "472" text in "Number" field
		And I click "Post and close" button
	* Create test Purchase order and Goods reciept on the another vendor
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "350,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		* Change the document number to 2025
			And I input "2025" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2025" text in "Number" field
		And I click "Post" button
		And I click "Goods receipt" button
		* Change the document number to 473
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "473" text in "Number" field
		And I click "Post and close" button
	* Create Purchase invoice based on created Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
		| 'Number' |
		| '471'    |
		And I move one line down in "List" table and select line
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 471*' | ''            |
			| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000' | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 472*' | ''            |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '2 966,10'   | 'Trousers' | '350,00' | '38/Yellow' | '10,000' | ''              | '533,90'     | 'pcs'  | '3 500,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 473*' | ''            |
		And I click "Post and close" button
		When I click command interface button "Purchase invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "LegalName" is equal to "Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 471*' | ''            |
			| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000' | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 472*' | ''            |
		If the field named "LegalName" is equal to "Second Company Ferron BP" Then
			And "ItemList" table contains lines
			| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
			| '2 966,10'   | 'Trousers' | '350,00' | '38/Yellow' | '10,000' | ''              | '533,90'     | 'pcs'  | '3 500,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 473*' | ''            |
		And I click "Post and close" button
		And I close all client application windows

Scenario: _090505 creation of Sales invoice based on several Shipment confirmation (different currency)
# should be created 2 Sales invoice
	* Create test first order and Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Personal Partner terms, $' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click "Post" button
		And I click "Shipment confirmation" button
		* Change the document number to 465
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "465" text in "Number" field
		And I click "Post and close" button
	* Create test second order and Shipment confirmation for the same customer and for the same commercial conditions
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '36/Yellow' |
		And I select current line in "List" table
		And I activate "Procurement method" field in "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I input "5,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		Then "Update item list info" window is opened
		And I click "OK" button
		And I click "Post" button
		And I click "Shipment confirmation" button
		* Change the document number to 466
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "466" text in "Number" field
		And I click "Post and close" button
	* Create Sales invoice - should be created 2
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I go to line in "List" table
		| 'Number' |
		| '465'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Personal Partner terms, $" Then
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '38/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 011*' | 'Shipment confirmation 465*' |
		If the field named "Agreement" is equal to "Basic Partner terms, TRY" Then
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 012*' | 'Shipment confirmation 466*' |
		And I click "Post and close" button
		When I click command interface button "Sales invoice (create)"
		And Delay 2
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Personal Partner terms, $" Then
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '38/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 011*' | 'Shipment confirmation 465*' |
		If the field named "Agreement" is equal to "Basic Partner terms, TRY" Then
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'VAT' | 'Item key'  | 'Q'     | 'Tax amount' | 'SalesTax' | 'Price type'        | 'Unit' | 'Net amount' | 'Total amount' | 'Store'    | 'Sales order'        | 'Shipment confirmation'      |
			| '500,00' | 'Trousers' | '18%' | '36/Yellow' | '5,000' | '406,11'     | '1%'       | 'Basic Price Types' | 'pcs'  | '2 093,89'   | '2 500,00'     | 'Store 02' | 'Sales order 9 012*' | 'Shipment confirmation 466*' |
		And I click "Post and close" button
		And I close all client application windows


Scenario: _090506 create Purchase invoice based on several Goods reciept
	* Create test Purchase order and Goods reciept
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, TRY' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "500,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		And I click "Post" button
		And I click "Goods receipt" button
		* Change the document number to 465
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "465" text in "Number" field
		And I click "Post and close" button
	* Create test Purchase order and Goods reciept on the same customer
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'       |
			| 'Company Ferron BP' |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'        |
			| 'Vendor Ferron, USD' |
		And I select current line in "List" table
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'     | 'Item key'  |
			| 'Trousers' | '38/Yellow' |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I click "Post" button
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
		And I click "Post" button
		And I click "Goods receipt" button
		* Change the document number to 466
			And I input "1" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "466" text in "Number" field
		And I click "Post and close" button
	* Create Purchase invoice based on created Goods receipt (should be created 2)
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I go to line in "List" table
		| 'Number' |
		| '465'    |
		And I move one line down in "List" table and select line
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron, USD" Then
			And "ItemList" table contains lines
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000'  | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                    | 'Goods receipt 466*' | ''            |
		If the field named "Agreement" is equal to "Vendor Ferron, TRY" Then
			And "ItemList" table contains lines
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 465*' | ''            |
		And I click "Post and close" button
		When I click command interface button "Purchase invoice (create)"
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		If the field named "Agreement" is equal to "Vendor Ferron, USD" Then
			And "ItemList" table contains lines
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'      | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '677,97'     | 'Trousers' | '400,00' | '38/Yellow' | '2,000'  | ''              | '122,03'     | 'pcs'  | '800,00'       | 'Store 02' | '*'             | ''             | ''              | '*'                    | 'Goods receipt 466*' | ''            |
		If the field named "Agreement" is equal to "Vendor Ferron, TRY" Then
			And "ItemList" table contains lines
				| 'Net amount' | 'Item'     | 'Price'  | 'Item key'  | 'Q'     | 'Offers amount' | 'Tax amount' | 'Unit' | 'Total amount' | 'Store'    | 'Delivery date' | 'Expense type' | 'Business unit' | 'Purchase order'      | 'Goods receipt'      | 'Sales order' |
				| '847,46'     | 'Trousers' | '500,00' | '38/Yellow' | '2,000' | ''              | '152,54'     | 'pcs'  | '1 000,00'     | 'Store 02' | '*'             | ''             | ''              | '*'                   | 'Goods receipt 465*' | ''            |
		And I click "Post and close" button
		And I close all client application windows



