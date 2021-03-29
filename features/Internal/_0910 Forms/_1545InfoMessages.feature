#language: en
@tree
@Positive

@InfoMessages

Feature: information messages


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _154500 preparation (information messages)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
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
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
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
	




# Scenario: _154505 message when trying to create Sales returm order based on Sales invoice when all products have already been returned
# 	* Create Sales invoice
# 		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 		And I click the button named "FormCreate"
# 		* Filling in customer info
# 			And I click Select button of "Partner" field
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Kalipso'     |
# 			And I select current line in "List" table
# 			And I click Select button of "Partner term" field
# 			And I select current line in "List" table
# 		* Select Store
# 			And I click Select button of "Store" field
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Store 01'  |
# 			And I select current line in "List" table
# 			And I click Select button of "Legal name" field
# 			And I select current line in "List" table
# 		* Filling in items tab
# 			And in the table "ItemList" I click the button named "ItemListAdd"
# 			And I click choice button of "Item" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Dress'  |
# 			And I select current line in "List" table
# 			And I activate "Item key" field in "ItemList" table
# 			And I click choice button of "Item key" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Item key' |
# 				| 'L/Green'  |
# 			And I select current line in "List" table
# 			And I activate "Q" field in "ItemList" table
# 			And I input "1,000" text in "Q" field of "ItemList" table
# 			And I finish line editing in "ItemList" table
# 			And I click the button named "FormPost"
# 			And I delete "$$NumberSalesInvoice154501$$" variable
# 			And I delete "$$SalesInvoice154501$$" variable
# 			And I save the value of "Number" field as "$$NumberSalesInvoice154501$$"
# 			And I save the window as "$$SalesInvoice154501$$"
# 	* Create Sales return order based on Sales invoice
# 			And I click the button named "FormDocumentSalesReturnOrderGenerate"
# 			And I click "Ok" button	
# 			And I select "Approved" exact value from "Status" drop-down list
# 			And I click the button named "FormPostAndClose"
# 	* Check the message output when creating Sales return order or Sales return again
# 			And I click the button named "FormDocumentSalesReturnOrderGenerate"
# 			And I click "Ok" button	
# 			Then warning message containing text 'There are no products to return in the "Sales invoice" document. All products are already returned.' appears
# 			And I click "OK" button
# 			// Then "Sales invoice * dated *" window is opened
# 			// And I click the button named "FormDocumentSalesReturnGenerate"
# 			// And I click "Ok" button	
# 			// Then warning message containing text 'There are no products to return in the "Sales invoice" document. All products are already returned.' appears
# 			// And I click "OK" button
# 			And I close all client application windows

# Scenario: _154507 message when trying to create Purchase return order and Purchase return based on Purchase invoice document if all products have already been returned.
# 	* Create Purchase invoice
# 		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
# 		And I click the button named "FormCreate"
# 		* Filling in the necessary details
# 			And I click Select button of "Company" field
# 			And I go to line in "List" table
# 				| Description  |
# 				| Main Company |
# 			And I select current line in "List" table
# 		* Filling in vendor's info
# 			And I click Select button of "Partner" field
# 			And I go to line in "List" table
# 				| Description |
# 				| Ferron BP   |
# 			And I select current line in "List" table
# 			And I click Select button of "Legal name" field
# 			And I activate "Description" field in "List" table
# 			And I go to line in "List" table
# 				| Description       |
# 				| Company Ferron BP |
# 			And I select current line in "List" table
# 			And I click Select button of "Partner term" field
# 			And I go to line in "List" table
# 				| Description        |
# 				| Vendor Ferron, USD |
# 			And I select current line in "List" table
# 			And I click Select button of "Store" field
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Store 02'  |
# 			And I select current line in "List" table
# 		* Filling in items table
# 			And I click the button named "Add"
# 			And I click choice button of "Item" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Dress'  |
# 			And I select current line in "List" table
# 			And I activate "Item key" field in "ItemList" table
# 			And I click choice button of "Item key" attribute in "ItemList" table
# 			Then "Item keys" window is opened
# 			And I go to line in "List" table
# 				| 'Item key' |
# 				| 'L/Green'  |
# 			And I select current line in "List" table
# 			And I finish line editing in "ItemList" table
# 			And I go to line in "ItemList" table
# 				| '#' | 'Item'  | 'Item key' | 'Unit' |
# 				| '1' | 'Dress' | 'L/Green'  | 'pcs' |
# 			And I select current line in "ItemList" table
# 			And I input "1,000" text in "Q" field of "ItemList" table
# 			And I input "40,00" text in "Price" field of "ItemList" table
# 			And I finish line editing in "ItemList" table
# 			And I click the button named "FormPost"
# 			And I delete "$$NumberPurchaseInvoice154502$$" variable
# 			And I delete "$$PurchaseInvoice154502$$" variable
# 			And I save the value of "Number" field as "$$NumberPurchaseInvoice154502$$"
# 			And I save the window as "$$PurchaseInvoice154502$$"
# 	* Create Purchase return based on Purchase invoice
# 			And I click the button named "FormDocumentPurchaseReturnGenerate"
# 			And I click the button named "FormPostAndClose"
# 	* Check the message output when Purchase return or Purchase return order is created again
# 			And I click the button named "FormDocumentPurchaseReturnOrderGenerate"
# 			Then warning message containing text 'There are no products to return in the "Purchase invoice" document. All products are already returned.' appears
# 			And I click "OK" button
# 			// Then "Purchase invoice * dated *" window is opened
# 			// And I click the button named "FormDocumentPurchaseReturnGenerate"
# 			// Then warning message containing text 'There are no products to return in the "Purchase invoice" document. All products are already returned.' appears
# 			// And I click "OK" button
# 			And I close all client application windows

Scenario: _154509 message when trying to re-create Sales invoice based on Shipment confirmation
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder154503$$" variable
		And I delete "$$SalesOrder154503$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder154503$$"
		And I save the window as "$$SalesOrder154503$$"
	* Create Shipment confirmation based on Sales order
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I save the value of "Number" field as "$$NumberShipmentConfirmation154503$$"
		And I save the window as "$$ShipmentConfirmation154503$$"
	* Create Sales invoice based on Shipment confirmation
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice154503$$" variable
		And I delete "$$SalesInvoice154503$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice154503$$"
		And I save the window as "$$SalesInvoice154503$$"
		And I click the button named "FormPostAndClose"
		And I wait "Sales invoice (create)" window closing in 20 seconds
	* Check message display when trying to re-create Sales invoice
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
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
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
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
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice154504$$" variable
			And I delete "$$SalesInvoice154504$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice154504$$"
			And I save the window as "$$SalesInvoice154504$$"

Scenario: _154510 message when trying to re-create Purchase invoice based on Goods receipt
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
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
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
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Goods receipt before purchase invoice"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder154505$$" variable
		And I delete "$$PurchaseOrder154505$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder154505$$"
		And I save the window as "$$PurchaseOrder154505$$"
	* Create Goods receipt based on urchase order
		And I click the button named "FormDocumentGoodsReceiptGenerate"
		And I click "Ok" button			
		And I click the button named "FormPost"
		And I delete "$$NumberGoodsReceipt154505$$" variable
		And I delete "$$GoodsReceipt154505$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt154505$$"
		And I save the window as "$$GoodsReceipt154505$$"
	* Create Purchase invoice based on Goods receipt
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button		
		And I delete "$$NumberPurchaseInvoice154505$$" variable
		And I delete "$$PurchaseInvoice154505$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice154505$$"
		And I save the window as "$$PurchaseInvoice154505$$"
		And I click the button named "FormPostAndClose"
		And I wait "Purchase invoice (create)" window closing in 20 seconds
	* Check message display when you try to re-create Purchase invoice
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0

		And I close all client application windows

Scenario: _154512 message when trying to re-create Purchase invoice based on Purchase order
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
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
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
			And I input "40,00" text in "Price" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
	* Create Purchase invoice based on Purchase order
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		And I click "Ok" button	
		And Delay 2	
		And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Purchase invoice
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154514 message when trying to re-create Goods receipt based on Purchase order
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
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
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
			And I move to "Other" tab
			And I expand "More" group
			And I set checkbox "Goods receipt before purchase invoice"
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder154506$$" variable
		And I delete "$$PurchaseOrder154506$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder154506$$"
		And I save the window as "$$PurchaseOrder154506$$"
	* Create Goods receipt based on Purchase order
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		And I click "Ok" button
		And Delay 2
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder1545061$$" variable
		And I delete "$$PurchaseOrder1545061$$" variable
		And I save the value of "Number" field as "$$NumberGoodsReceipt1545061$$"
		And I save the window as "$$GoodsReceipt1545061$$"
		And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Goods receipt
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154516 message when trying to re-create Sales invoice based on Sales order (Sales invoice before Shipment confirmation)
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
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder1545061$$" variable
		And I delete "$$PurchaseOrder1545061$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder154507$$"
		And I save the window as "$$SalesOrder154507$$"
	* Create Sales invoice
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice154507$$" variable
		And I delete "$$SalesInvoice154507$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice154507$$"
		And I save the window as "$$SalesInvoice154507$$"
		And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Sales invoice
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows
		
Scenario: _154518 message when trying to re-create Shipment confirmation based on Sales order (Shipment confirmation before Sales invoic)
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder154507$$" variable
		And I delete "$$SalesOrder154507$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder154507$$"
		And I save the window as "$$SalesOrder154507$$"
	* Create Shipment confirmation
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		* Change number Shipment confirmation
			And I move to "Other" tab
			And I click the button named "FormPost"
			And I delete "$$NumberShipmentConfirmation154507$$" variable
			And I delete "$$ShipmentConfirmation154507$$" variable
			And I save the value of "Number" field as "$$NumberShipmentConfirmation154507$$"
			And I save the window as "$$ShipmentConfirmation154507$$"
			And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Shipment confirmation
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154520 message when trying to re-create Shipment confirmation based on Sales invoice
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
		* Filling in items tab
			And in the table "ItemList" I click the button named "ItemListAdd"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Description' |
				| 'Dress'  |
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
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice154508$$" variable
			And I delete "$$SalesInvoice154508$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice154508$$"
			And I save the window as "$$SalesInvoice154508$$"
	* Create Shipment confirmation based on Sales invoice
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		And I click "Ok" button
		And I click the button named "FormPost"
		And I delete "$$NumberShipmentConfirmation154508$$" variable
		And I delete "$$ShipmentConfirmation154508$$" variable
		And I save the value of "Number" field as "$$NumberShipmentConfirmation154508$$"
		And I save the window as "$$ShipmentConfirmation154508$$"
		And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Shipment confirmation
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows


Scenario: _154524 message when trying to create Shipment confirmation based on Sales invoice with Service
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
			And I click the button named "FormPost"
			And I delete "$$NumberSalesInvoice154510$$" variable
			And I delete "$$SalesInvoice154510$$" variable
			And I save the value of "Number" field as "$$NumberSalesInvoice154510$$"
			And I save the window as "$$SalesInvoice154510$$"
	* Check message display when you try to create Shipment confirmation based on Sales invoice with Service
		And I click the button named "FormDocumentShipmentConfirmationGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154526 message when trying to create Goods receipt based on Purchase invoice with Service
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
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseInvoice154511$$" variable
			And I delete "$$PurchaseInvoice154511$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseInvoice154511$$"
			And I save the window as "$$PurchaseInvoice154511$$"
	* Check message display when you try to create Goods receipt based on Purchase invoice with Service
		And I click the button named "FormDocumentGoodsReceiptGenerate"	
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154528 message when trying to create Purchase order based on Sales order with procurement method stock and NoReserve, with Service
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
			And I select "No reserve" exact value from "Procurement method" drop-down list in "ItemList" table
			And I input "2,000" text in "Q" field of "ItemList" table
			And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder154512$$" variable
		And I delete "$$SalesOrder154512$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder154512$$"
		And I save the window as "$$SalesOrder154512$$"
	* Check the message that there are no items to order with the vendor
		And I click "Purchase order" button
		Then the number of "BasisesTree" table lines is "равно" 0
		And I click "OK" button
		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I close all client application windows

Scenario: _154530 message when trying to re-create Purchase order/Inventory transfer order based on Internal supply request
	* Create Internal supply request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
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
		And I click the button named "FormPost"
		And I delete "$$NumberInternalSupplyRequest154513$$" variable
		And I delete "$$InternalSupplyRequest154513$$" variable
		And I save the value of "Number" field as "$$NumberInternalSupplyRequest154513$$"
		And I save the window as "$$InternalSupplyRequest154513$$"
	* Create Purchase order based on Internal supply request
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		And I click "OK" button
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
		And I click "OK" button
		And I select current line in "ItemList" table
		And I activate "Price" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click the button named "FormPostAndClose"
	* Check message display when you try to re-create Purchase order/Inventory transfer order		
		And I click the button named "FormDocumentPurchaseOrderGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I click "OK" button
		And I click the button named "FormDocumentInventoryTransferOrderGenerate"
		Then the number of "BasisesTree" table lines is "равно" 0
		And I click "OK" button
		And I close all client application windows


# Scenario: _154532 user notification when create a second partial sales invoice based on sales order
# 	* Create Sales order
# 		Given I open hyperlink "e1cib/list/Document.SalesOrder"
# 		And I click "Create" button
# 		* Filling in customer info
# 			And I click Select button of "Partner" field
# 			And I go to line in "List" table
# 					| 'Description' |
# 					| 'Ferron BP'  |
# 			And I select current line in "List" table
# 			And I click Select button of "Partner term" field
# 			And I go to line in "List" table
# 					| 'Description'       |
# 					| 'Basic Partner terms, without VAT' |
# 			And I select current line in "List" table
# 			And I click Select button of "Legal name" field
# 			And I go to line in "List" table
# 					| 'Description' |
# 					| 'Company Ferron BP'  |
# 			And I select current line in "List" table
# 		* Filling in items table
# 			And in the table "ItemList" I click "Add" button
# 			And I click choice button of "Item" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Trousers'    |
# 			And I select current line in "List" table
# 			And I click choice button of "Item key" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Item'     | 'Item key'  |
# 				| 'Trousers' | '38/Yellow' |
# 			And I select current line in "List" table
# 			And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
# 			And I input "2,000" text in "Q" field of "ItemList" table
# 		And I click the button named "FormPost"
# 		And I delete "$$NumberSalesOrder154514$$" variable
# 		And I delete "$$SalesOrder154514$$" variable
# 		And I save the value of "Number" field as "$$NumberSalesOrder154514$$"
# 		And I save the window as "$$SalesOrder154514$$"
# 	* Create first Sales invoice
# 		And I click the button named "FormDocumentSalesInvoiceGenerate"
# 		And I click "OK" button
# 		And I select current line in "ItemList" table
# 		And I input "1,000" text in "Q" field of "ItemList" table
# 		And I click the button named "FormPostAndClose"
# 	* Create second Sales invoice
# 		And I click the button named "FormDocumentSalesInvoiceGenerate"
# 		And I click "OK" button
# 		When TestClient messages log contains messages from the list only
# 		| 'The "Sales invoice" document does not fully match the "Sales order" document because' |
# 		| 'there is already another "Sales invoice" document that partially covered this "Sales order" document.'|
# 		And I close all client application windows

# Scenario: _154534 user notification when create a second partial purchase invoice based on purchase order
# 	* Create Purchase order
# 		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
# 		And I click "Create" button
# 		* Filling in customer info
# 			And I click Select button of "Partner" field
# 			And I go to line in "List" table
# 					| 'Description' |
# 					| 'Ferron BP'  |
# 			And I select current line in "List" table
# 			And I click Select button of "Partner term" field
# 			And I go to line in "List" table
# 					| 'Description'       |
# 					| 'Vendor Ferron, TRY' |
# 			And I select current line in "List" table
# 			And I click Select button of "Legal name" field
# 			And I go to line in "List" table
# 					| 'Description' |
# 					| 'Company Ferron BP'  |
# 			And I select current line in "List" table
# 			And I click Select button of "Store" field
# 			And I go to line in "List" table
# 				| Description |
# 				| Store 03  |
# 			And I select current line in "List" table
# 		* Filling in items table
# 			And I click the button named "Add"
# 			And I click choice button of "Item" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Description' |
# 				| 'Trousers'    |
# 			And I select current line in "List" table
# 			And I click choice button of "Item key" attribute in "ItemList" table
# 			And I go to line in "List" table
# 				| 'Item'     | 'Item key'  |
# 				| 'Trousers' | '38/Yellow' |
# 			And I select current line in "List" table
# 			And I input "2,000" text in "Q" field of "ItemList" table
# 			And I input "10,00" text in "Price" field of "ItemList" table
# 			And I select "Approved" exact value from "Status" drop-down list
# 		And I click the button named "FormPost"
# 		And I delete "$$NumberPurchaseOrder154515$$" variable
# 		And I delete "$$PurchaseOrder154515$$" variable
# 		And I save the value of "Number" field as "$$NumberPurchaseOrder154515$$"
# 		And I save the window as "$$PurchaseOrder154515$$"
# 	* Create first Purchase invoice based on Purchase order
# 		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
# 		And I click "OK" button
# 		And I select current line in "ItemList" table
# 		And I input "1,000" text in "Q" field of "ItemList" table
# 		And I click the button named "FormPostAndClose"
# 	* Create second Purchase invoice based on Purchase order
# 		And I click the button named "FormDocumentPurchaseInvoiceGenerate"
# 		When TestClient messages log contains messages from the list only
# 		| 'The "Purchase invoice" document does not fully match the "Purchase order" document because'|
# 		|  'there is already another "Purchase invoice" document that partially covered this "Purchase order" document.'|
# 		And I close all client application windows

Scenario: _015450 check message output for SO when trying to create a purchase order/SC
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder0154513$$" variable
		And I delete "$$SalesOrder0154513$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder0154513$$"
		And I save the window as "$$SalesOrder0154513$$"
	* Check the message output if the order is unposted
		* Change of document status
			And I select "Wait" exact value from "Status" drop-down list
			And I click the button named "FormPost"
		* Check message output when trying to generate a PO
			And I click "Purchase order" button
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
		* Check message output when trying to generate a PI
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
	* Check the message output when it is impossible to create SC because the goods have not yet come from the vendor provided that the type of supply "through orders" is selected
		* Change of document status
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
		* Check a tick 'Shipment confirmations before sales invoice'
			And I set checkbox "Shipment confirmations before sales invoice"
			And I click the button named "FormPost"
		* Create SC for string with procurement method Stock
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			And I click "Ok" button
			Then "Shipment confirmation (create)" window is opened
			And I click the button named "FormPostAndClose"
			And Delay 2
		* Check message output when trying to generate SC
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
	* Check when trying to create SC when only a PO has been created but the goods have not been delivered
		* Create a partial PO
			And I click the button named "FormDocumentPurchaseOrderGenerate"
			And I click "OK" button
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
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder0154513$$" variable
			And I delete "$$PurchaseOrder0154513$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder0154513$$"
			And I save the window as "$$PurchaseOrder0154513$$"
			And I click the button named "FormPostAndClose"
		* Check message output when trying to create SC
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I close all client application windows
		* Create GR and try to re-create SC
			* Create GR
				Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
				And I go to line in "List" table
				| 'Number' | 'Partner'   |
				| '$$NumberPurchaseOrder0154513$$'  | 'Ferron BP' |
				And I click the button named "FormDocumentGoodsReceiptGenerate"
				And I click "OK" button
				And I click the button named "FormPostAndClose"
			* Create SC
				Given I open hyperlink "e1cib/list/Document.SalesOrder"
				And I go to line in "List" table
				| 'Number' | 'Partner'   |
				| '$$NumberSalesOrder0154513$$'  | 'Kalipso'       |
				And I click the button named "FormDocumentShipmentConfirmationGenerate"
				And I click "Ok" button	
				And "ItemList" table contains lines
				| 'Item'     | 'Quantity' | 'Item key'  | 'Store'    |
				| 'Trousers' | '4,000'    | '38/Yellow' | 'Store 02' |
				| 'Trousers' | '1,000'    | '36/Yellow' | 'Store 02' |
				And I click the button named "FormPostAndClose"
				And I close all client application windows
	* Check the message output when the order is already closed by the purchase order
		* Create a PO for the remaining amount
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
			| 'Number' | 'Partner'   |
			| '$$NumberSalesOrder0154513$$'  | 'Kalipso'       |
			And I select current line in "List" table
			And I click the button named "FormDocumentPurchaseOrderGenerate"
			And I click "Ok" button	
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
			And I click the button named "FormPostAndClose"
			And I close all client application windows
		* Check the message output when the order is already closed by the purchase order
			Given I open hyperlink "e1cib/list/Document.SalesOrder"
			And I go to line in "List" table
			| 'Number' | 'Partner'   |
			| '$$NumberSalesOrder0154513$$'  | 'Kalipso'       |
			And I click the button named "FormDocumentPurchaseOrderGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
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
				And I click the button named "FormPost"
		* Check message output when trying to create a PO
			And I click the button named "FormDocumentPurchaseOrderGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I close all client application windows

Scenario: _015452 check message output when trying to create a subsequent order document with the status without movements
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesOrder0154514$$" variable
		And I delete "$$SalesOrder0154514$$" variable
		And I save the value of "Number" field as "$$NumberSalesOrder0154514$$"
		And I save the window as "$$SalesOrder0154514$$"
		* Check message output when trying to create SalesInvoice
			And I click the button named "FormDocumentSalesInvoiceGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I click the button named "FormDocumentPurchaseOrderGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I click the button named "FormDocumentShipmentConfirmationGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I select "Approved" exact value from "Status" drop-down list
			And I click the button named "FormPost"
	* Check the output of messages when creating documents on PO with the status "without posting"
			And I click "Purchase order" button
			And I click "OK" button
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
			And I select "Wait" exact value from "Status" drop-down list
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder0154514$$" variable
			And I delete "$$PurchaseOrder0154514$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder0154514$$"
			And I save the window as "$$PurchaseOrder0154514$$"
		* Check the message output when trying to create PurchaseInvoice
			And I click the button named "FormDocumentPurchaseInvoiceGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I click "OK" button
			And I click the button named "FormDocumentGoodsReceiptGenerate"
			Then the number of "BasisesTree" table lines is "равно" 0
			And I close all client application windows




Scenario: _015456 notification when trying to post a Sales order without filling procurement method
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
		And I click the button named "FormPost"
		Then I wait that in user messages the "Field [Procurement method] is empty." substring will appear in 10 seconds
		And I close all client application windows

Scenario: _999999 close TestClient session
	And I close TestClient session