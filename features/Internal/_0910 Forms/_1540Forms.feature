#language: en
@tree
@Positive
@Forms

Feature: forms

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

	
Scenario: _0154000 preparation
	When set True value to the constant
	When set True value to the constant Use commission trading
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog Countries objects
		When Create catalog Companies objects (second company Ferron BP)
		When Create catalog Companies objects (own Second company)
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create catalog Partners objects
		When Create catalog Partners objects (Kalipso)
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		When Create catalog ObjectStatuses objects
		When Create catalog Units objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog ItemTypes objects
		When Create catalog Items objects
		When Create catalog ItemKeys objects
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
		When Create catalog CashAccounts objects
		When Create catalog SerialLotNumbers objects
		When Create catalog PaymentTerminals objects
		When Create catalog RetailCustomers objects
		When Create catalog SerialLotNumbers objects
		When Create catalog Projects objects
		When Create catalog RetailCustomers objects
		When Create catalog BankTerms objects
		When Create catalog SpecialOfferRules objects (Test)
		When Create catalog SpecialOfferTypes objects (Test)
		When Create catalog SpecialOffers objects (Test)
		When Create catalog CashStatementStatuses objects (Test)
		When Create catalog Hardware objects  (Test)
		When Create catalog Workstations objects  (Test)
		When Create catalog ItemSegments objects
		When Create catalog PaymentTypes objects
		When Create information register Taxes records (VAT)


Scenario: _01540001 check preparation
	When check preparation

Scenario: _0154008 check autofilling the Partner term field in Purchase order
	When create a test partner with one vendor partner term and one customer partner term
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by vendor) in the documents of purchase/returns 
	And I close all client application windows

Scenario: _0154009 check autofilling the Partner term field in Purchase invoice
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by vendor) in the documents of purchase/returns 
	And I close all client application windows

Scenario: _0154010 check autofilling the Partner term field in Purchase return
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by vendor) in the documents of purchase/returns 
	And I close all client application windows

Scenario: _0154011  check autofilling the Partner term field in Purchase return order
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by vendor) in the documents of purchase/returns 
	And I close all client application windows

Scenario: _0154013 check autofilling the Partner term field in Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by customer) in the documents of sales/returns 
	And I close all client application windows

Scenario: _0154014 check autofilling the Partner term field in Sales return order
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by customer) in the documents of sales/returns 
	And I close all client application windows

Scenario: _0154015 check autofilling the Partner term field in Sales return
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by customer) in the documents of sales/returns 
	And I close all client application windows

Scenario: _0154016 check autofilling the Partner term field in Work order
	Given I open hyperlink "e1cib/list/Document.WorkOrder"
	And I click the button named "FormCreate"
	When check the autocompletion of the partner term (by customer) in the documents of sales/returns  
	And I close all client application windows


Scenario: _0154017 check autofilling item key in Sales invoice by item only with one item key
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	When check item key autofilling in sales/returns documents for an item that has only one item key

Scenario: _0154018 check autofilling item key in Sales return order by item only with one item key
	Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
	And I click the button named "FormCreate"
	When check item key autofilling in sales/returns documents for an item that has only one item key

Scenario: _0154019 check autofilling item key in Sales return by item only with one item key
	Given I open hyperlink "e1cib/list/Document.SalesReturn"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154020 check autofilling item key in Shipment Confirmation by item only with one item key
	Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154021 check autofilling item key in GoodsReceipt by item only with one item key
	Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154022 check autofilling item key in Purchase order by item only with one item key
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154023 check autofilling item key in Purchase invoice by item only with one item key
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154024 check autofilling item key in Purchase return by item only with one item key
	Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154025 check autofilling item key in Purchase return order by item only with one item key
	Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key


Scenario: _0154026 check autofilling item key in Bundling by item only with one item key
	Given I open hyperlink "e1cib/list/Document.Bundling"
	And I click the button named "FormCreate"
	When check item key autofilling in bundling/transfer documents for an item that has only one item key

Scenario: _0154027 check autofilling item key in Unbundling by item only with one item key
	Given I open hyperlink "e1cib/list/Document.Unbundling"
	And I click the button named "FormCreate"
	When check item key autofilling in bundling/transfer documents for an item that has only one item key

Scenario: _0154030 check autofilling item key in Inventory transfer by item only with one item key 
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154031 check autofilling item key in Inventory transfer order by item only with one item key 
	Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
	And I click the button named "FormCreate"
	When check item key autofilling in bundling/transfer documents for an item that has only one item key

Scenario: _0154032 check autofilling item key in Internal Supply Request only with one item key 
	Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _01540321 check autofilling item key in Retail Shipment Confirmation by item only with one item key
	Given I open hyperlink "e1cib/list/Document.RetailShipmentConfirmation"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _01540322 check autofilling item key in Retail Goods Receipt by item only with one item key
	Given I open hyperlink "e1cib/list/Document.RetailGoodsReceipt"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key



Scenario: _0154033 check if the Partner form contains an option to include a partner in the segment
	Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Select partner
		And I click "List" button		
		And I go to line in "List" table
			| Description    |
			| Seven Brand    |
		And I select current line in "List" table
	* Add a test partner to the Dealer segment
		And In this window I click command interface button "Partner segments content"
		And "List" table does not contain lines
		| Segment  | Partner       |
		| Dealer   | Seven Brand   |
		And I click the button named "FormCreate"
		And I click Select button of "Segment" field
		And I go to line in "List" table
			| Description    |
			| Dealer         |
		And I select current line in "List" table
		And I click "Save and close" button
	* Add a test partner to the Retail segment
		And I go to line in "List" table
			| Partner       | Segment    |
			| Seven Brand   | Retail     |
		And I go to line in "List" table
			| Partner       | Segment    |
			| Seven Brand   | Dealer     |
	* Delete added record
		And I delete a line in "List" table
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	And I close all client application windows




Scenario: _0154035 search the item key selection list
	* Open the Sales order creation form
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| "Description" |
			| "Dress"       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
	* General search check including All/Single/Specification switch selection
		And I input "s" text in "SearchString" field
		And "List" table does not contain lines
		| 'Item key'  | 'Item'    |
		| 'M/White'   | 'Dress'   |
		| 'L/Green'   | 'Dress'   |
		| 'XL/Green'  | 'Dress'   |
		| 'XXL/Red'   | 'Dress'   |
		| 'M/Brown'   | 'Dress'   |
		And I click Clear button of "SearchString" field
		And I change "IsSpecificationFilter" radio button value to "Single"
		And I input "gr" text in "SearchString" field
		And "List" table does not contain lines
		| 'Item key'   | 'Item'    |
		| 'S/Yellow'   | 'Dress'   |
		| 'XS/Blue'    | 'Dress'   |
		| 'M/White'    | 'Dress'   |
		| 'Dress/A-8'  | 'Dress'   |
		| 'XXL/Red'    | 'Dress'   |
		| 'M/Brown'    | 'Dress'   |
		And I click Clear button of "SearchString" field
		And I change "IsSpecificationFilter" radio button value to "Specification"
		And "List" table does not contain lines
		| 'Item key'  | 'Item'    |
		| 'S/Yellow'  | 'Dress'   |
		| 'XS/Blue'   | 'Dress'   |
		| 'M/White'   | 'Dress'   |
		| 'L/Green'   | 'Dress'   |
		| 'XL/Green'  | 'Dress'   |
		| 'XXL/Red'   | 'Dress'   |
		| 'M/Brown'   | 'Dress'   |
		And I click Clear button of "SearchString" field
		And I change "IsSpecificationFilter" radio button value to "All"
		And I select from "Size" drop-down list by "s" string
		And "List" table does not contain lines
		| 'Item key'  | 'Item'    |
		| 'XS/Blue'   | 'Dress'   |
		| 'M/White'   | 'Dress'   |
		| 'L/Green'   | 'Dress'   |
		| 'XL/Green'  | 'Dress'   |
		| 'XXL/Red'   | 'Dress'   |
		| 'M/Brown'   | 'Dress'   |
	* Check search by properties
		And I click Clear button of "Size" field
		And I select from "Color" drop-down list by "gr" string
		And "List" table does not contain lines
		| 'Item key'  | 'Item'    |
		| 'S/Yellow'  | 'Dress'   |
		| 'XS/Blue'   | 'Dress'   |
		| 'M/White'   | 'Dress'   |
		| 'XXL/Red'   | 'Dress'   |
		| 'M/Brown'   | 'Dress'   |
		And I change "IsSpecificationFilter" radio button value to "Single"
		And I select from "Color" drop-down list by "gr" string
		And "List" table does not contain lines
		| 'Item key'   | 'Item'    |
		| 'S/Yellow'   | 'Dress'   |
		| 'XS/Blue'    | 'Dress'   |
		| 'M/White'    | 'Dress'   |
		| 'Dress/A-8'  | 'Dress'   |
		| 'XXL/Red'    | 'Dress'   |
		| 'M/Brown'    | 'Dress'   |
		And I change "IsSpecificationFilter" radio button value to "Specification"
		And I select from "Color" drop-down list by "Black" string
		Then the number of "List" table lines is "равно" 0
		And I close all client application windows

Scenario: _0154036 check autofilling item key in Sales report from trade agent only with one item key 
	Given I open hyperlink "e1cib/list/Document.SalesReportFromTradeAgent"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key

Scenario: _0154037 check autofilling item key in Sales report to consignor only with one item key 
	Given I open hyperlink "e1cib/list/Document.SalesReportToConsignor"
	And I click the button named "FormCreate"
	When check item key autofilling in purchase/returns/goods receipt/shipment confirmation documents for an item that has only one item key



Scenario: _0154039 check impossibility deleting of the store field by line with the product in a Sales invoice
	* Open a creation form Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows
	

Scenario: _0154041 check impossibility deleting of the store field by line with the product in a Purchase Order
	* Open a creation form Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows
		


Scenario: _0154043 check impossibility deleting of the store field by line with the product in a Purchase invoice
	* Open a creation form Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows

Scenario: _0154044 check impossibility deleting of the store field by line with the product in a Sales return order
	* Open a creation form Sales Return Order
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows

Scenario: _0154045 check impossibility deleting of the store field by line with the product in a Sales return
	* Open a creation form Sales Return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows

Scenario: _0154046 check impossibility deleting of the store field by line with the product in a Purchase return
	* Open a creation form Purchase Return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows
	
Scenario: _0154047 check impossibility deleting of the store field by line with the product in a Purchase return order
	* Open a creation form Purchase Return order
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 01'   |
		And I close all client application windows

Scenario: _0154048 check impossibility deleting of the store field by line with the product in a Goods receipt
	* Open a creation form Goods receipt
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And Delay 2
		And I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 02'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 02'   |
		And I close all client application windows

Scenario: _0154049 check impossibility deleting of the store field by line with the product in a  ShipmentConfirmation
	* Open a creation form ShipmentConfirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
	* Add to the table part of the product with the item type - Product
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Dress'   | 'M/White'     |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 02'   |
	* Delete store field by product line 
		And I activate field named "ItemListStore" in "ItemList" table
		And I select current line in "ItemList" table
		And I click Clear button of "Store" attribute in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check that the store field is still filled
		And "ItemList" table contains lines
		| 'Item'   | 'Item key'  | 'Quantity'  | 'Store'      |
		| 'Dress'  | 'M/White'   | '1,000'     | 'Store 02'   |
		And I close all client application windows
			
	




Scenario: _010018 check the display on the Partners Description ENG form after changes (without re-open)
	And I close all client application windows
	* Open catalog Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Select Anna Petrova
		And I go to line in "List" table
			| 'Description'     |
			| 'Anna Petrova'    |
		And I select current line in "List" table
	* Changing Description_en to Anna Petrova1 and display checking
		And I input "Anna Petrova1" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Anna Petrova1"
	* Changing Description_en back and display checking
		And I input "Anna Petrova" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Anna Petrova"
		And I click "Save and close" button

Scenario: _010019 check the display on the Company Description ENG form after changes (without re-open)
	And I close all client application windows
	* Open catalog Companies
		Given I open hyperlink "e1cib/list/Catalog.Companies"
	* Select Company Lomaniti
		And I go to line in "List" table
			| 'Description'         |
			| 'Company Lomaniti'    |
		And I select current line in "List" table
	* Changing Description_en to Company Lomaniti1 and display checking
		And I input "Company Lomaniti1" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Company Lomaniti1"
		And I input "Company Lomaniti" text in the field named "Description_en"
		And I click "Save" button
	* Changing Description_en back and display checking
		Then the form attribute named "Description_en" became equal to "Company Lomaniti"
		And I click "Save and close" button


Scenario: _010017 check the move to the Company tab from the Partner (shows the partner's Legal name)
	And I close all client application windows
	* Open catalog Partners
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Select Ferron BP
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And Delay 2
	* Check the move to the Company tab
		And In this window I click command interface button "Company"
		And "List" table became equal
			| 'Description'                 |
			| 'Company Ferron BP'           |
			| 'Second Company Ferron BP'    |
		And I select current line in "List" table
		* Check the display of Company information
			Then the form attribute named "Country" became equal to "Turkey"
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "Description_en" became equal to "Company Ferron BP"
		And I close current window
		And I close current window

Scenario: _005034 check filling in the required fields in the Items catalog
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Items"
	When create a catalog element with the name Test
	If current window contains user messages Then
	And I close current window
	Then "1C:Enterprise" window is opened
	And I click "No" button


Scenario: _005035 check filling in the required fields in the AddAttributeAndPropertyValues catalog 
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
	When create a catalog element with the name Test
	If current window contains user messages Then
	And I close current window
	Then "1C:Enterprise" window is opened
	And I click "No" button



Scenario: _005037 check filling in the required fields in the Users catalog 
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Users"
	When create a catalog element with the name Test
	And I close current window
	Then "1C:Enterprise" window is opened
	And I click "No" button


Scenario: _005118 check the display on the Items Description ENG form after changes (without re-open)
	And I close all client application windows
	* Open Item Box
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Box'            |
		And I select current line in "List" table
	* Changing Description_en to Box1 and display checking
		And I input "Box1" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Box1"
		And I input "Box" text in the field named "Description_en"
		And I click "Save" button
	* Changing Description_en back
		Then the form attribute named "Description_en" became equal to "Box"
		And I click "Save and close" button

Scenario: _012008 check the display on the Partner term Description ENG form after changes (without re-open)
	And I close all client application windows
	* Open Personal Partner terms, $ (catalog Partner terms)  
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I go to line in "List" table
			| 'Description'                  |
			| 'Personal Partner terms, $'    |
		And I select current line in "List" table
	* Changing Description_en to Personal Partner terms, $ 1 and display checking
		And I input "Personal Partner terms, $ 1" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Personal Partner terms, $ 1"
	* Changing Description_en back
		And I input "Personal Partner terms, $" text in the field named "Description_en"
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "Personal Partner terms, $"
		And I click "Save and close" button

Scenario: _012009 check the move to Partner terms from the Partner card (shows available partner Partner terms)
	And I close all client application windows
	* Open Ferron BP (catalog Partners)
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
				| 'Description'     |
				| 'Ferron BP'       |
		And I select current line in "List" table
		And Delay 2
	* Moving to Partner terms
		And In this window I click command interface button "Partner terms"
	* Check the display of only available Partner terms
		And I save number of "List" table lines as "QS"
		Then "QS" variable is equal to 8
		And "List" table contains lines
			| Description                         |
			| Basic Partner terms, TRY            |
			| Basic Partner terms, $              |
			| Basic Partner terms, without VAT    |
			| Vendor Ferron, TRY                  |
			| Vendor Ferron, USD                  |
			| Vendor Ferron, EUR                  |
			| Sale autum, TRY                     |
			| Ferron, USD                         |
		And I close current window
	

Scenario: _012010 check the filter by Company and Legal name field when creating an Partner term
	And I close all client application windows
	* Open a creation form Partner term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
	* Check the filter by Company
		And I click Select button of "Company" field
		And "List" table became equal
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I select current line in "List" table
	* Check the filter by Legal name
		And I click Select button of "Legal name" field
		And "List" table does not contain lines
			| 'Description'       |
			| 'Main Company'      |
			| 'Second Company'    |
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
	* Check the filter by partners Legal name 
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And "List" table does not contain lines
		| 'Description'                |
		| 'Company Ferron BP'          |
		| 'DFC'                        |
		| 'Big foot'                   |
		| 'Second Company Ferron BP'   |
		And I close all client application windows

Scenario: _012011 filter check by Partner segment when creating an Partner term
	And I close all client application windows
	* Open a creation form Partner term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Customer"
	* Check the filter by Partner segment
		And I click Select button of "Partner segment" field
		And "List" table contains lines
			| 'Description'    |
			| 'Retail'         |
			| 'Dealer'         |
		And "List" table does not contain lines
			| 'Description'    |
			| 'Region 1'       |
			| 'Region 2'       |
		And I close all client application windows
	

Scenario: _012012 inability to create your own company for Partner
	And I close all client application windows
	* Open Partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And In this window I click command interface button "Company"
		And I click the button named "FormCreate"
	* Check that OurCompany checkbox is not available
		And field "Our Company" is not present on the form






Scenario: _012015 check row key when cloning a string in Sales invoice
	And I close all client application windows
	* Filling in the details of the document Sales invoice
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
	* Filling in Sales invoice
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
	* Check that the row keys do not match
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "Rov1"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I save the current field value as "Rov2"		
		And I display "Rov1" variable value
		And I display "Rov2" variable value
		And "ItemList" table does not contain lines
			| 'Key'    | '#'    |
			| 'Rov1'   | '2'    |
		And I close all client application windows
		

Scenario: _012016 check row key when cloning a string in Purchase order
	And I close all client application windows
	* Filling in the details of the document Purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Filling in Purchase order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
	* Check that the row keys do not match
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "Rov1"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I save the current field value as "Rov2"		
		And I display "Rov1" variable value
		And I display "Rov2" variable value
		And "ItemList" table does not contain lines
			| 'Key'    | '#'    |
			| 'Rov1'   | '2'    |
		And I close all client application windows

Scenario: _012017 check row key when cloning a string in Shipment confirmation
	And I close all client application windows
	* Filling in the details of the document Shipment confirmation
		Given I open hyperlink "e1cib/list/Document.ShipmentConfirmation"
		And I click the button named "FormCreate"
		And I select "Sales" exact value from "Transaction type" drop-down list
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
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
	* Filling in Shipment confirmation
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
		And I input "1,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
	* Check that the row keys do not match
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "Rov1"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I save the current field value as "Rov2"		
		And I display "Rov1" variable value
		And I display "Rov2" variable value
		And "ItemList" table does not contain lines
			| 'Key'    | '#'    |
			| 'Rov1'   | '2'    |
		And I close all client application windows


Scenario: _012020 check row key when cloning a string in Internal supply request
	And I close all client application windows
	* Filling in the details of the document Internal supply request
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I click the button named "FormCreate"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
	* Filling in Internal supply request
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Quantity" field in "ItemList" table
		And I input "2,00" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberISR$$" variable
		And I save the value of "Number" field as "$$NumberISR$$"
	* Check that the row keys do not match
		And I delete "$$$$RovISR1$$$$" variable
		And I delete "$$$$RovISR2$$$$" variable
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "$$$$RovISR1$$$$"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I save the current field value as "$$$$RovISR2$$$$"		
		And I display "$$$$RovISR1$$$$" variable value
		And I display "$$$$RovISR2$$$$" variable value
		And "ItemList" table does not contain lines
			| 'Key'               | '#'    |
			| '$$$$RovISR1$$$$'   | '2'    |
		And I close all client application windows
	* Copy ISR and check row key
		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
		And I go to line in "List" table
			| 'Number'           |
			| '$$NumberISR$$'    |
		And in the table "List" I click the button named "ListContextMenuCopy"
		And I click the button named "FormPost"
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document does not contain values
			| '$$$$RovISR1$$$$'    |
			| '$$$$RovISR2$$$$'    |
		And I close all client application windows
				

Scenario: _012021 check row key when cloning a string in Purchase invoice
	And I close all client application windows
	* Filling in the details of the document Purchase invoice
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Vendor Ferron, TRY'    |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I go to line in "List" table
			| 'Description'          |
			| 'Company Ferron BP'    |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 02'       |
		And I select current line in "List" table
	* Filling in Purchase invoice
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I activate "Price" field in "ItemList" table
		And I input "100,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I activate field named "ItemListItem" in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListContextMenuCopy"
		And I finish line editing in "ItemList" table
		And I input end of the current month date in "Delivery date" field
		And I click the button named "FormPost"
	* Check that the row keys do not match
		And I click "Show row key" button
		And I go to line in "ItemList" table
			| '#'    |
			| '1'    |
		And I activate "Key" field in "ItemList" table
		And I save the current field value as "Rov1"
		And I go to line in "ItemList" table
			| '#'    |
			| '2'    |
		And I save the current field value as "Rov2"		
		And I display "Rov1" variable value
		And I display "Rov2" variable value
		And "ItemList" table does not contain lines
			| 'Key'    | '#'    |
			| 'Rov1'   | '2'    |
		And I close all client application windows	






Scenario: _012019 check filling in partner and customer/vendor sign when creating Partner term from partner card
	And I close all client application windows
	* Opening a customer partner card
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
	* Open a creation form Partner term
		And In this window I click command interface button "Partner terms"
		And I click the button named "FormCreate"
	* Check filling in partner and customer sign
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "Type" became equal to "Customer"
	* Open a supplier partner card
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description'    |
			| 'Veritas'        |
		And I select current line in "List" table
	* Open a creation form Partner term
		And In this window I click command interface button "Partner terms"
		And I click the button named "FormCreate"
	* Check filling in Partner and Vendor sign
		Then the form attribute named "Partner" became equal to "Veritas"
		Then the form attribute named "Type" became equal to "Vendor"
	And I close all client application windows


# Scenario: _012020 check sorting of item keys
# 	Given I open hyperlink "e1cib/list/Catalog.Items"
# 	And I go to line in "List" table
# 			| 'Description' |
# 			| 'Dress' |
# 	And I select current line in "List" table
# 	And In this window I click command interface button "Item keys"
# 	And I click "Configure list..." button
# 	And I move to "Order" tab
# 	And I go to line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
# 		| 'Available fields' |
# 		| 'Item key'         |
# 	And I select current line in "SettingsComposerUserSettingsItem1AvailableFieldsTable" table
# 	And I activate "Sort direction" field in "SettingsComposerUserSettingsItem1Order" table
# 	And I select current line in "SettingsComposerUserSettingsItem1Order" table
# 	And I select "Ascending" exact value from "Sort direction" drop-down list in "SettingsComposerUserSettingsItem1Order" table
# 	And I finish line editing in "SettingsComposerUserSettingsItem1Order" table
# 	And I click "Finish editing" button
# 	And "List" table became equal
# 		| 'Item key'  | 'Specification' |
# 		| 'Dress/A-8' | 'A-8'           |
# 		| 'L/Green'   | ''              |
# 		| 'M/Brown'   | ''              |
# 		| 'M/White'   | ''              |
# 		| 'S/Yellow'  | ''              |
# 		| 'XL/Green'  | ''              |
# 		| 'XS/Blue'   | ''              |
# 		| 'XXL/Red'   | ''              |
# 	And I close all client application windows
	

Scenario: _012025 check box Show item in item key it the Registrations report
	And I close all client application windows
	* Filling in the details of the documentsales order
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click the button named "FormCreate"
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description'                         |
			| 'Basic Partner terms, without VAT'    |
		And I select current line in "List" table
	* Filling in Sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And I activate field named "ItemListItemKey" in "ItemList" table
		And I click choice button of the attribute named "ItemListItemKey" in "ItemList" table
		And I go to line in "List" table
			| 'Item'       | 'Item key'     |
			| 'Trousers'   | '38/Yellow'    |
		And I select current line in "List" table
		And I click the button named "FormPost"	
	* Check box Show item in item key
		And I click "Registrations report" button
		And I expand "Filters" group		
		And I set checkbox "Show item in item key"
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Item key'     |
			| '38/Yellow'    |
		And "ResultTable" spreadsheet document contains values
			| 'ItemKeyItem'    |
			| 'Trousers'       |
		And I remove checkbox "Show item in item key"
		And I click "Generate report" button
		And "ResultTable" spreadsheet document contains values
			| 'Item key'     |
			| '38/Yellow'    |
		And "ResultTable" spreadsheet document does not contain values
			| 'ItemKeyItem'    |
			| 'Trousers'       |
	And I close all client application windows
	
		
Scenario: _012026 check Partners selection form (SO)
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button		
	* Open Partner selection form
		And I click Choice button of the field named "Partner"			
	* Create partner
		And I click the button named "FormCreate"
		And I input "Test Partner" text in "ENG" field
		And I click "Save and close" button
		And I wait "Partner (create) *" window closing in 20 seconds
	* Check current position in list
		And the current line of "List" table is equal to
			| 'Description'     |
			| 'Test Partner'    |
		And I close all client application windows
		
Scenario: _012027 try change item from item key
		And I close all client application windows
	* Open item key from item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Trousers'       |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I activate field named "Code" in "List" table
		And I go to line in "List" table
			| 'Item key'     |
			| '38/Yellow'    |
		And I select current line in "List" table
		And "Item" attribute is read-only
		And I close all client application windows
	* Open item key from catalog
		Given I open hyperlink "e1cib/list/Catalog.ItemKeys"
		And I go to line in "List" table
			| 'Item key'     |
			| '38/Yellow'    |
		And I select current line in "List" table
		And "Item" attribute is read-only
		And I close all client application windows
				
Scenario: _012029 search for item key in the selection form
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
	* Add item
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Dress'          |
		And I select current line in "List" table
	* Search for item key
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I input "gre" text in the field named "SearchString"
	* Check
		And "List" table contains lines
			| 'Item key'   | 'Item'    | 'Specification'    |
			| 'L/Green'    | 'Dress'   | ''                 |
			| 'XL/Green'   | 'Dress'   | ''                 |
		Then the number of "List" table lines is "равно" "2"
	* Search another item key
		And I input "bl" text in the field named "SearchString"
		And "List" table became equal
			| 'Item key'   | 'Item'     |
			| 'XS/Blue'    | 'Dress'    |
	* Select item key
		And I select current line in "List" table
		And "ItemList" table became equal
			| 'Item key'   | 'Item'     |
			| 'XS/Blue'    | 'Dress'    |
		And I close all client application windows

Scenario: _012030 clone value in the SO
	And I close all client application windows
	* Open SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Revenue type)
		
Scenario: _012031 clone value in the SI
	And I close all client application windows
	* Open SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Revenue type)

Scenario: _012032 clone value in the SRO
	And I close all client application windows
	* Open SRO
		Given I open hyperlink "e1cib/list/Document.SalesReturnOrder"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Revenue type)

Scenario: _012033 clone value in the SR
	And I close all client application windows
	* Open SR
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Revenue type)

Scenario: _012034 clone value in the PI
	And I close all client application windows
	* Open PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Expense type)

Scenario: _012035 clone value in the PO
	And I close all client application windows
	* Open PO
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Expense type)

Scenario: _012036 clone value in the PR
	And I close all client application windows
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Expense type)

Scenario: _012037 clone value in the PRO
	And I close all client application windows
	* Open PR
		Given I open hyperlink "e1cib/list/Document.PurchaseReturnOrder"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Expense type)

Scenario: _012038 clone value in the StockAdjustmentAsWriteOff
	And I close all client application windows
	* Open StockAdjustmentAsWriteOff
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsWriteOff"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Expense type)

Scenario: _012039 clone value in the StockAdjustmentAsSurplus
	And I close all client application windows
	* Open StockAdjustmentAsSurplus
		Given I open hyperlink "e1cib/list/Document.StockAdjustmentAsSurplus"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Profit loss center, Revenue type)

Scenario: _012040 clone value in the BankPayment
	And I close all client application windows
	* Open BankPayment
		Given I open hyperlink "e1cib/list/Document.BankPayment"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Financial movement type, Cash flow center, Project)

Scenario: _012041 clone value in the CashPayment
	And I close all client application windows
	* Open CashPayment
		Given I open hyperlink "e1cib/list/Document.CashPayment"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Financial movement type, Cash flow center, Project)

Scenario: _012042 clone value in the CashReceipt
	And I close all client application windows
	* Open CashReceipt
		Given I open hyperlink "e1cib/list/Document.CashReceipt"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Financial movement type, Cash flow center, Project)

Scenario: _012043 clone value in the BankReceipt
	And I close all client application windows
	* Open BankReceipt
		Given I open hyperlink "e1cib/list/Document.BankReceipt"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Financial movement type, Cash flow center, Project)

Scenario: _012044 clone value in the CashExpense
	And I close all client application windows
	* Open CashExpense
		Given I open hyperlink "e1cib/list/Document.CashExpense"
		And I click "Create" button
	* Check clone value
		When check clone value in the documents (Financial movement type, Cash flow center, Project, Expense type)

Scenario: _999999 close TestClient session
	And I close TestClient session