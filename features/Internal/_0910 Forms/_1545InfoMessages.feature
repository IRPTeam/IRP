#language: en
@tree
@Positive

Feature: information messages


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: message when trying to create a Sales invoice by Sales order with Shipment confirmation before Sales invoice (Shipment confirmation has not been created yet)
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		When adding the items to the sales order (Dress and Trousers)
	* Click Shipment confirmation before Sales invoice
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
	* Check the information message display when trying to create Sales invoice
		And I move to "Item list" tab
		And I click "Post" button
		And I click "Sales invoice" button
		Then warning message containing text "First, create a Shipment confirmation document or clear the Shipment confirmation before Sales invoice check box on the ""Other"" tab." appears
		And I close all client application windows

Scenario: message when trying to create a Purchase invoice by Purchase order with Goods receipt before Purchase invoice (Goods receipt has not been created yet)
	* Create Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Filling in the necessary details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post" button
	* Click Goods receipt before Purchase invoice
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Goods receipt before purchase invoice"
	* Check the information message display when trying to create Sales invoice
		And I click "Post" button
		And I click "Purchase invoice" button
		Then warning message containing text "First, create a Goods receipt document or clear the Goods receipt before Purchase invoice check box on the ""Other"" tab." appears
		And I close all client application windows

Scenario: message when trying to create Sales returm order based on Sales invoice when all products have already been returned
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to 2000
			And I move to "Other" tab
			And I expand "More" group
			And I input "2000" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2000" text in "Number" field
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
	* Create Sales return order based on Sales invoice
			And I click "Sales return order" button
			And I select "Approved" exact value from "Status" drop-down list
			And I click "Post and close" button
	* Check the message output when creating Sales return order or Sales return again
			And I click "Sales return order" button
			Then warning message containing text "There are no products to return in the Sales invoice document. All products are already returned." appears
			And I click "OK" button
			Then "Sales invoice * dated *" window is opened
			And I click "Sales return" button
			Then warning message containing text "There are no products to return in the Sales invoice document. All products are already returned." appears
			And I click "OK" button
			And I close all client application windows

Scenario: message when trying to create Purchase return order and Purchase return based on Purchase invoice document if all products have already been returned.
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in the necessary details
			And I click Select button of "Company" field
			And I go to line in "List" table
				| Description  |
				| Main Company |
			And I select current line in "List" table
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change the document number to 2000
			And I move to "Other" tab
			And I input "2000" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2000" text in "Number" field
		And I click "Post" button
	* Create Purchase return based on Purchase invoice
			And I click "Purchase return" button
			And I click "Post and close" button
	* Check the message output when Purchase return or Purchase return order is created again
			And I click "Purchase return order" button
			Then warning message containing text "There are no products to return in the Purchase invoice document. All products are already returned." appears
			And I click "OK" button
			Then "Purchase invoice * dated *" window is opened
			And I click "Purchase return" button
			Then warning message containing text "There are no products to return in the Purchase invoice document. All products are already returned." appears
			And I click "OK" button
			And I close all client application windows

Scenario: message when trying to re-create Sales invoice based on Shipment confirmation
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		When adding the items to the sales order (Dress and Trousers)
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		* Change number sales order to 2001
			And I move to "Other" tab
			And I expand "More" group
			And I input "2001" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2001" text in "Number" field
		And I click "Post" button
	* Create Shipment confirmation based on Sales order
		And I click "Shipment confirmation" button
		* Change number
			And I input "2001" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2001" text in "Number" field
		And I click "Post" button
	* Create Sales invoice based on Shipment confirmation
		And I click "Sales invoice" button
		Then "Sales invoice (create)" window is opened
		And I move to "Other" tab
		And I expand "More" group
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2 001" text in "Number" field
		And I click "Post and close" button
		And I wait "Sales invoice (create)" window closing in 20 seconds
	* Check message display when trying to re-create Sales invoice
		And I click "Sales invoice" button
		Then warning message containing text "There are no lines for which you need to create Sales invoice document in the Shipment confirmation document." appears
		And I close all client application windows
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to 2000
			And I move to "Other" tab
			And I expand "More" group
			And I input "2000" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2000" text in "Number" field
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button

Scenario: message when trying to re-create Purchase invoice based on Goods reciept
	* Create Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Filling in the necessary details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change the document number
			And I move to "Other" tab
			And I expand "More" group
			And I input "2001" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2001" text in "Number" field
			And I set checkbox "Goods receipt before purchase invoice"
		And I click "Post" button
	* Create Goods receipt based on urchase order
		And I click "Goods receipt" button
		* Change number
			And I input "2001" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2001" text in "Number" field
		And I click "Post" button
	* Create Purchase invoice based on Goods reciept
		And I click "Purchase invoice" button
		And I move to "Other" tab
		And I input "0" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2 001" text in "Number" field
		And I click "Post and close" button
		And I wait "Purchase invoice (create)" window closing in 20 seconds
	* Check message display when you try to re-create Purchase invoice
		And I click "Purchase invoice" button
		Then warning message containing text "There are no lines for which you need to create Purchase invoice document in the Goods receipt document." appears
		And I close all client application windows

Scenario: message when trying to re-create Purchase invoice based on Purchase order
	* Create Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Filling in the necessary details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change the document number
			And I move to "Other" tab
			And I expand "More" group
			And I input "2006" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2006" text in "Number" field
		And I click "Post" button
	* Create Purchase invoice based on Purchase order
		And I click "Purchase invoice" button
		* Change number
			And I input "2006" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2006" text in "Number" field
		And I click "Post and close" button
	* Check message display when you try to re-create Purchase invoice
		And I click "Purchase invoice" button
		Then warning message containing text "There are no lines for which you need to create Purchase invoice document in the Purchase order document." appears
		And I close all client application windows

Scenario: message when trying to re-create Goods reciept based on Purchase order
	* Create Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		* Filling in the necessary details
			And I click Select button of "Company" field
			And I go to line in "List" table
			| Description  |
			| Main Company |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
		* Filling in vendor's info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| Description |
				| Ferron BP   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description       |
				| Company Ferron BP |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| Description        |
				| Vendor Ferron, USD |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			Then "Items" window is opened
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			Then "Item keys" window is opened
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I finish line editing in "ItemList" table
			And I go to line in "ItemList" table
				| '#' | 'Item'  | 'Item key' | 'Unit' |
				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Change the document number
			And I move to "Other" tab
			And I expand "More" group
			And I input "2007" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2007" text in "Number" field
			And I set checkbox "Goods receipt before purchase invoice"
		And I click "Post" button
	* Create Goods receipt based on Purchase order
		And I click "Goods receipt" button
		* Change number
			And I input "2007" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2007" text in "Number" field
		And I click "Post and close" button
	* Check message display when you try to re-create Goods receipt
		And I click "Goods receipt" button
		Then warning message containing text "All items in the Purchase order document(s) are already received using the Goods receipt document(s)." appears
		And I close all client application windows

Scenario: message when trying to re-create Sales invoice based on Sales order (Sales invoice before Shipment confirmation)
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		When adding the items to the sales order (Dress and Trousers)
		And I click "Save" button
	* Change the document number
		And I move to "Other" tab
		And I expand "More" group
		And I input "2004" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2004" text in "Number" field
		And I click "Post" button
	* Create Sales invoice
		And I click "Sales invoice" button
		* Change number Sales invoice
			And I move to "Other" tab
			And I expand "More" group
			And I input "2004" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2004" text in "Number" field
			And I click "Post and close" button
	* Check message display when you try to re-create Sales invoice
		And I click "Sales invoice" button
		Then warning message containing text "There are no lines for which you need to create Sales invoice document in the Sales order document." appears
		And I close all client application windows
		
Scenario: message when trying to re-create Shipment confirmation based on Sales order (Shipment confirmation before Sales invoic)
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		When adding the items to the sales order (Dress and Trousers)
		And I click "Save" button
	* Change the document number
		And I move to "Other" tab
		And I expand "More" group
		And I set checkbox "Shipment confirmations before sales invoice"
		And I input "2005" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2005" text in "Number" field
		And I click "Post" button
	* Create Shipment confirmation
		And I click "Shipment confirmation" button
		* Change number Shipment confirmation
			And I move to "Other" tab
			And I input "2005" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2005" text in "Number" field
			And I click "Post and close" button
	* Check message display when you try to re-create Shipment confirmation
		And I click "Shipment confirmation" button
		Then warning message containing text "There are no lines for which you need to create Shipment confirmation document in the Sales order document." appears
		And I close all client application windows

Scenario: message when trying to re-create Shipment confirmation based on Sales invoice
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to2000
			And I move to "Other" tab
			And I expand "More" group
			And I input "2008" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2008" text in "Number" field
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
	* Create Shipment confirmation based on Sales invoice
		And I click "Shipment confirmation" button
		* Change number
			And I input "2008" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2008" text in "Number" field
		And I click "Post and close" button
	* Check message display when you try to re-create Shipment confirmation
		And I click "Shipment confirmation" button
		Then warning message containing text "There are no lines for which you need to create Shipment confirmation document in the Sales invoice document." appears
		And I close all client application windows

Scenario: message when trying to create Shipment confirmation based on Sales invoice (Stor doesn't use Shipment confirmation)
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to 2009
			And I move to "Other" tab
			And I expand "More" group
			And I input "2009" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2009" text in "Number" field
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'L/Green'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
	* Check message display when you try to create Shipment confirmation based on Sales invoice (Stor doesn't use Shipment confirmation)
		And I click "Shipment confirmation" button
		Then warning message containing text "There are no lines for which you need to create Shipment confirmation document in the Sales invoice document." appears
		And I close all client application windows

Scenario: message when trying to create Shipment confirmation based on Sales invoice with Service
	* Create Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to 2009
			And I move to "Other" tab
			And I expand "More" group
			And I input "2010" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2010" text in "Number" field
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Service'     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'Rent'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
	* Check message display when you try to create Shipment confirmation based on Sales invoice with Service
		And I click "Shipment confirmation" button
		Then warning message containing text "There are no lines for which you need to create Shipment confirmation document in the Sales invoice document." appears
		And I close all client application windows

Scenario: message when trying to create Goods reciept based on Purchase invoice with Service
	* Create Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
		* Select Store
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
		* Change the document number to 2015
			And I move to "Other" tab
			And I input "2015" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "2015" text in "Number" field
		* Filling in items tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Service'     |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key' |
				| 'Rent'  |
			And I select current line in "List" table
			And I activate "Q" field in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post" button
	* Check message display when you try to create Goods receipt based on Purchase invoice with Service
		And I click "Goods receipt" button
		Then warning message containing text "There are no lines for which you need to create Goods receipt document in the Purchase invoice document." appears
		And I close all client application windows

Scenario: message when trying to create Purchase order based on Sales order with procurement nethod stock and repeal, with Service
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click "Add" button
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
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Service'     |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'    | 'Item key' |
				| 'Service' | 'Rent'     |
			And I select current line in "List" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And in the table "ItemList" I click "Add" button
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Boots'       |
			And I select current line in "List" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item'  | 'Item key' |
				| 'Boots' | '37/18SD'  |
			And I select current line in "List" table
			And I select "Repeal" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I click "Post" button
	* Change the document number
		And I move to "Other" tab
		And I expand "More" group
		And I input "2015" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2015" text in "Number" field
		And I click "Post" button
	* Check the message that there are no items to order with the vendor
		And I click "Purchase order" button
		Then warning message containing text "There are no lines with a correct procurement method." appears
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click "Purchase invoice" button
		Then warning message containing text "There are no lines with a correct procurement method." appears
		And I close all client application windows

Scenario: message when trying to re-create Purchase order/Inventory transfer order based on Internal supply request
	* Create Internal supply request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
		* Change number
			And I input "100" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "100" text in "Number" field
		* Filling in the details of the document
			And I click Select button of "Company" field
			And I activate "Description" field in "List" table
			And I go to line in "List" table
				| Description  |
				| Main Company | 
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 02  |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Trousers    |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| Item     | Item key          |
				| Trousers | 36/Yellow |
			And I select current line in "List" table
			And I activate "Quantity" field in "ItemList" table
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click "Post" button
	* Create Purchase order based on Internal supply request
		And I click "Purchase order" button
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
		And I click the button named "FormChoose"
		Then If dialog box is visible I click "OK"
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post and close" button
	* Check message display when you try to re-create Purchase order/Inventory transfer order
		And I click "Purchase order" button
		Then warning message containing text "There are no more items that you need to order from suppliers in the Internal supply request document." appears
		Then "1C:Enterprise" window is opened
		And I click "OK" button
		And I click "Inventory transfer order" button
		Then warning message containing text "There are no more items that you need to order from suppliers in the Internal supply request document." appears
		And I close all client application windows


Scenario: user notification when create a second partial sales invoice based on sales order
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, without VAT' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
		* Filling in items table
			And in the table "ItemList" I click "Add" button
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
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
	* Change the document number
		And I move to "Other" tab
		And I expand "More" group
		And I input "2020" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2020" text in "Number" field
		And I click "Post" button
	* Create first Sales invoice
		And I click "Sales invoice" button
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click "Post and close" button
	* Create second Sales invoice
		And I click "Sales invoice" button
		Then I wait that in user messages the "Sales invoice document does not fully match the Sales order document because | there is already another Sales invoice document that partially covered this Sales order document." substring will appear in 30 seconds
		And I close all client application windows

Scenario: user notification when create a second partial purchase invoice based on purchase order
	* Create Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click "Create" button
		* Filling in customer info
			And I click Select button of "Partner" field
			And I go to line in "List" table
					| 'Description' |
					| 'Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I go to line in "List" table
					| 'Description' |
					| 'Company Ferron BP'  |
			And I select current line in "List" table
			And I click Select button of "Store" field
			And I go to line in "List" table
				| Description |
				| Store 03  |
			And I select current line in "List" table
		* Filling in items table
			And I click the button named "Add"
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
			And I input "2,000" text in "Q" field of "ItemList" table
			And I input "10,00" text in "Price" field of "ItemList" table
			And I select "Approved" exact value from "Status" drop-down list
	* Change the document number
		And I move to "Other" tab
		And I expand "More" group
		And I input "2020" text in "Number" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2020" text in "Number" field
		And I click "Post" button
	* Create first Purchase invoice based on Purchase order
		And I click "Purchase invoice" button
		And I select current line in "ItemList" table
		And I input "1,000" text in "Q" field of "ItemList" table
		And I click "Post and close" button
	* Create second Purchase invoice based on Purchase order
		And I click "Purchase invoice" button
		Then I wait that in user messages the "Purchase invoice document does not fully match the Purchase order document because | there is already another Purchase invoice document that partially covered this Purchase order document." substring will appear in 5 seconds

Scenario: _0154513 check message output for SO when trying to create a purchase order/SC
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
	* Filling in Sales order
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
				| 'Description'       |
				| 'Basic Partner terms, TRY' |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "4,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '36/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '36/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
		* Filling in Manager segment
			And I move to "Other" tab
			And I click Select button of "Manager segment" field
			And I go to line in "List" table
				| 'Description' |
				| 'Region 2'    |
			And I select current line in "List" table
			And I move to "Other" tab
			And I input "3 024" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3 024" text in "Number" field
		And I click "Post" button
	* Check the message output if the order is unposted
		* Change of document status
			And I select "Wait" exact value from "Status" drop-down list
			And I click "Post" button
		* Check message output when trying to generate a PO
			And I click "Purchase order" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
		* Check message output when trying to generate a PI
			And I click "Purchase invoice" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
	* Check the message output when it is impossible to create SC because the goods have not yet come from the vendor provided that the type of supply "through orders" is selected
		* Change of document status
			And I select "Approved" exact value from "Status" drop-down list
			And I click "Post" button
		* Check a tick 'Shipment confirmations before sales invoice'
			And I set checkbox "Shipment confirmations before sales invoice"
			And I click "Post" button
		* Create SC for string with procurement method Stock
			And I click "Shipment confirmation" button
			Then "Shipment confirmation (create)" window is opened
			And I click "Post and close" button
			And Delay 2
		* Check message output when trying to generate SC
			And I click "Shipment confirmation" button
			Then the form attribute named "Message" became equal to "Items were not received from the supplier according to the procurement method."
			Then "1C:Enterprise" window is opened
			And I click "OK" button
	* Check when trying to create SC when only a PO has been created but the goods have not been delivered
		* Create a partial PO
			And I click "Purchase order" button
			And I click Select button of "Partner" field
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
			And I click "OK" button
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I select "Approved" exact value from "Status" drop-down list
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '36/Yellow' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I move to "Other" tab
			And I set checkbox "Goods receipt before purchase invoice"
			And I input "3 024" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3 024" text in "Number" field
			And I click "Post and close" button
		* Check message output when trying to create SC
			And I click "Shipment confirmation" button
			Then the form attribute named "Message" became equal to "Items were not received from the supplier according to the procurement method."
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I close all client application windows
		* Create GR and try to re-create SC
			* Create GR
				Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
				And I go to line in "List" table
				| 'Number' | 'Partner'   |
				| '3 024'  | 'Ferron BP' |
				And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
				And I click "Post and close" button
			* Create SC
				Given I open hyperlink "e1cib/list/Document.SalesOrder"
				And I go to line in "List" table
				| 'Number' | 'Partner'   |
				| '3 024'  | 'Kalipso'       |
				And I click the button named "FormDocumentShipmentConfirmationGenerateShipmentConfirmation"
				And "ItemList" table contains lines
				| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    |
				| 'Trousers' | '4,000'    | '38/Yellow' | 'Store 02' |
				| 'Trousers' | '1,000'    | '36/Yellow' | 'Store 02' |
				And I click "Post and close" button
				And I close all client application windows
	* Check the message output when the order is already closed by the purchase order
		* Create a PO for the remaining amount
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
			| 'Number' | 'Partner'   |
			| '3 024'  | 'Kalipso'       |
			And I select current line in "List" table
			And I click "Purchase order" button
			And I select "Approved" exact value from "Status" drop-down list
			And I click Select button of "Partner" field
			Then "Partners" window is opened
			And I go to line in "List" table
				| 'Description' |
				| 'Ferron BP'   |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
				| 'Description'        |
				| 'Vendor Ferron, TRY' |
			And I select current line in "List" table
			And I click "OK" button
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "50,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click "Post and close" button
			And I close all client application windows
		* Check the message output when the order is already closed by the purchase order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
			| 'Number' | 'Partner'   |
			| '3 024'  | 'Kalipso'       |
			And I click the button named "FormDocumentPurchaseOrderGeneratePurchaseOrder"
			Then the form attribute named "Message" became equal to "All items in the sales order document are already ordered using the purchase order document(s)."
			And I close all client application windows
	* Check the message when there are no lines in the sales  order with procurement method "purchase"
		* Create SO with procurement method Stock
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I click the button named "FormCreate"
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			* Add a row of items
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I click choice button of the attribute named "ItemListItem" in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Trousers'    |
				And I select current line in "List" table
				And I activate field named "ItemListItemKey" in "ItemList" table
				And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
				And I go to line in "List" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I select current line in "List" table
				And I activate "Procurement method" field in "ItemList" table
				And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
				And I input "4,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I move to "Other" tab
				And I click Select button of "Manager segment" field
				And I go to line in "List" table
					| 'Description' |
					| 'Region 2'    |
				And I select current line in "List" table
				And I click "Post" button
		* Check message output when trying to create a PO
			And I click "Purchase order" button
			Then the form attribute named "Message" became equal to "There are no lines with a correct procurement method."
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I close all client application windows

Scenario: _0154514 check message output when trying to create a subsequent order document with the status without movements
	* Check the output of messages when creating documents based on SO with the status "unposted"
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		* Filling in Sales order
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'         |
			And I select current line in "List" table
			Then the form attribute named "LegalName" became equal to "Company Kalipso"
			And I click Select button of "Partner term" field
			And I go to line in "List" table
					| 'Description'       |
					| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			* Add a row of items
				And in the table "ItemList" I click the button named "ItemListAdd"
				And I click choice button of the attribute named "ItemListItem" in "ItemList" table
				And I go to line in "List" table
					| 'Description' |
					| 'Trousers'    |
				And I select current line in "List" table
				And I activate field named "ItemListItemKey" in "ItemList" table
				And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
				And I go to line in "List" table
					| 'Item'     | 'Item key'  |
					| 'Trousers' | '38/Yellow' |
				And I select current line in "List" table
				And I activate "Procurement method" field in "ItemList" table
				And I select "Purchase" exact value from "Procurement method" drop-down list in "ItemList" table
				And I input "4,000" text in "Q" field of "ItemList" table
				And I finish line editing in "ItemList" table
				And I select "Wait" exact value from "Status" drop-down list
		* Fiiling in manager segment
			And I move to "Other" tab
			And I click Select button of "Manager segment" field
			And I go to line in "List" table
				| 'Description' |
				| 'Region 2'    |
			And I select current line in "List" table
			And I move to "Other" tab
			And I input "3 027" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3 027" text in "Number" field
		And I click "Post" button
		* Check message output when trying to create SalesInvoice
			And I click "Sales invoice" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I click "Purchase invoice" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I click "Purchase order" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I click "Shipment confirmation" button
			Then the form attribute named "Message" became equal to "Cannot continue. The of Sales order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I select "Approved" exact value from "Status" drop-down list
			And I click "Post" button
	* Check the output of messages when creating documents on PO with the status "without posting"
			And I click "Purchase order" button
		* Filling in Purchase order
			And I click Select button of "Partner" field
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I select current line in "List" table
			And I click "OK" button
			And I activate "Price" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "200,00" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "ItemList" table
			And I input "100,00" text in "Price" field of "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I activate "Q" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "1,000" text in "Q" field of "ItemList" table
			And I go to line in "ItemList" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I move to "Other" tab
			And I set checkbox "Goods receipt before purchase invoice"
			And I input "3 027" text in "Number" field
			Then "1C:Enterprise" window is opened
			And I click "Yes" button
			And I input "3 027" text in "Number" field
			And I select "Wait" exact value from "Status" drop-down list
			And I click "Post" button
		* Check the message output when trying to create PurchaseInvoice
			And I click "Purchase invoice" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Purchase order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I click "Goods receipt" button
			Then the form attribute named "Message" became equal to "Cannot continue. The Purchase order* document has an incorrect status." template
			Then "1C:Enterprise" window is opened
			And I click "OK" button
			And I close all client application windows

Scenario: _0154515 check the message output when trying to uncheck a tick for Store "Use shipment confirmation" and "Use Goods receipt" for which there were already Shipment confirmation and  Goods receipt
	* Open Store 02
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Check the message output when trying to uncheck a tick for Store "Use Goods receipt"
		And I remove checkbox "Use goods receipt"
		Then the form attribute named "Message" became equal to "Cannot clear the \"Use goods receipt\" check box. Documents Goods receipts from store Store 02 have already been created previously."
	And I close all client application windows
	* Open Store 02
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'    |
		And I select current line in "List" table
	* Check the message output when trying to uncheck a tick for Store "Use shipment confirmation"
		And I remove checkbox "Use shipment confirmation"
		Then the form attribute named "Message" became equal to "Cannot clear the \"Use shipment confirmation\" check box. Documents Shipment confirmations from store Store 02 have already been created previously."
		And I close all client application windows


Scenario: _0154516 notification when trying to post a Sales order without filling procurement method
	* Create Sales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		* Filling in details
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
				| 'Description'           |
				| 'Basic Partner terms, TRY' |
			And I select current line in "List" table
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Choice button of the field named "Store"
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'    |
			And I select current line in "List" table
		* Filling in the tabular part
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of the attribute named "ItemListItem" in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Trousers'    |
			And I select current line in "List" table
			And I activate field named "ItemListItemKey" in "ItemList" table
			And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
			And I go to line in "List" table
				| 'Item'     | 'Item key'  |
				| 'Trousers' | '38/Yellow' |
			And I select current line in "List" table
			And I activate "Procurement method" field in "ItemList" table
			And I click Clear button of "Procurement method" field
			And I move to the next attribute
			And I input "8,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
	* Check message output
		And I click "Post" button
		Then I wait that in user messages the "Field: [Procurement method] is empty." substring will appear in 10 seconds
		And I close all client application windows
