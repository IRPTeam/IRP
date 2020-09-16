#language: en
@tree
@Positive
@Group3

Feature: create document Purchase order

As a procurement manager
I want to create a Purchase order document
For tracking an item that has been ordered from a vendor

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _017000 preparation
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
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
	When Create information register TaxSettings records
	* Add plugin for taxes calculation
		* Opening a form to add Plugin sessing
			Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		* Addition of Plugin sessing for calculating Tax types for Turkey (VAT)
			And I click the button named "FormCreate"
			And I select external file "#workingDir#\DataProcessor\TaxCalculateVAT_TR.epf"
			And I click the button named "FormAddExtDataProc"
			And I input "" text in "Path to plugin for test" field
			And I input "TaxCalculateVAT_TR" text in "Name" field
			And I click Open button of the field named "Description_en"
			And I input "TaxCalculateVAT_TR" text in the field named "Description_en"
			And I input "TaxCalculateVAT_TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
			And I wait "Plugins (create)" window closing in 10 seconds
		* Check added processing
			Then I check for the "ExternalDataProc" catalog element with the "Description_en" "TaxCalculateVAT_TR"
			Given I open hyperlink "e1cib/list/Catalog.Taxes"		
			And I go to line in "List" table
				| 'Description' |
				| 'TaxCalculateVAT_TR'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description' |
				| 'VAT'         |
			And I select current line in "List" table
			And I click "Save and close" button
		And I close all client application windows

Scenario: _017001 create document Purchase order - Goods receipt is not used
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Status filling
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
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
			| Vendor Ferron, TRY |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
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
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "100" text in "Q" field of "ItemList" table
		And I input "200" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "200" text in "Q" field of "ItemList" table
		And I input "210" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "300" text in "Q" field of "ItemList" table
		And I input "250" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
			| 'Item'     | 'Q' | 'Item key'  | 'Store' | 'Unit' |
			| 'Dress'    | '100,000'  | 'M/White'   | 'Store 01'      | 'pcs' |
	* Post document
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder017001$$"
		And I save the window as "$$PurchaseOrder017001$$"
		And I click "Post and close" button

Scenario: _017002 check Purchase Order N2 posting by register Order Balance (+) - Goods receipt is not used
	* Opening register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	* Check the register form
		If "List" table contains columns Then
			| 'Period' |
			| 'Quantity' |
			| 'Recorder' |
			| 'Line number' |
			| 'Store' |
			| 'Order' |
			| 'Item key' |
	* Check Purchase Order N2 posting by register Order Balance
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key'  |
			| '100,000'  | '$$PurchaseOrder017001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | 'M/White'   |
			| '200,000'  | '$$PurchaseOrder017001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | 'L/Green'   |
			| '300,000'  | '$$PurchaseOrder017001$$' | 'Store 01' | '$$PurchaseOrder017001$$' | '36/Yellow' |

Scenario: _017003 create document Purchase order - Goods receipt is used
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description  |
		| Main Company |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	* Filling in vendor information
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
		And I input "500,000" text in "Q" field of "ItemList" table
		And I input "40,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder017003$$"
		And I save the window as "$$PurchaseOrder017003$$"
		And I click "Post and close" button

Scenario: _017004 check Purchase Order N3 posting by register Order Balance (+) - Goods receipt is not used
	* Opening of register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
	* Check Purchase Order N3 posting by register Order Balance
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Line number' | 'Store'    | 'Order'                   | 'Item key' |
			| '500,000'  | '$$PurchaseOrder017003$$' | '1'           | 'Store 02' | '$$PurchaseOrder017003$$' | 'L/Green'  |

Scenario: _017005 check movements by status and status history of a Purchase Order document
	And I close all client application windows
	* Opening a form to create Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in the details
		And I click Select button of "Company" field
		And I go to line in "List" table
		| Description  |
		| Main Company |
		And I select current line in "List" table
	* Filling in vendor information
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
			| Vendor Ferron, TRY |
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Check the default status "Wait"
		Then the form attribute named "Status" became equal to "Wait"
	// * Filling in the document number №101
	// 	And I move to "Other" tab
	// 	And I input "101" text in "Number" field
	// 	Then "1C:Enterprise" window is opened
	// 	And I click "Yes" button
	// 	And I input "101" text in "Number" field
	* Filling in items table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| 'M/White'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
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
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Trousers'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '1' | 'Dress' | 'M/White' | 'pcs' |
		And I activate "Q" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "200,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'  | 'Item key' | 'Unit' |
			| '2' | 'Dress' | 'L/Green'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "20,000" text in "Q" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| '#' | 'Item'     | 'Item key' | 'Unit' |
			| '3' | 'Trousers' | '36/Yellow'   | 'pcs' |
		And I select current line in "ItemList" table
		And I input "30,000" text in "Q" field of "ItemList" table
		And I input "210,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
	* Post document
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder017005$$"
		And I save the window as "$$PurchaseOrder017005$$"
		And I click "Post and close" button
		And I close current window
	* Check the absence of movements Purchase Order N101 by register Order Balance
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'                | 'Store'    | 'Order'                   |
			| '$$PurchaseOrder017005$$' | 'Store 01' | '$$PurchaseOrder017005$$' |
		And I close all client application windows
	* Setting the status by Purchase Order №101 'Approved'
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder017005$$'      |
		And I select current line in "List" table
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I select "Approved" exact value from "Status" drop-down list
		And I click "Post" button
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| 'Object'                  | 'Status'   |
			| '$$PurchaseOrder017005$$' | 'Wait'     |
			| '$$PurchaseOrder017005$$' | 'Approved' |
		And I close current window
		And I click "Post and close" button
		And I close current window
	* Check document movements after the status is set to Approved
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Recorder'                | 'Store'    | 'Order'                   |
			| '$$PurchaseOrder017005$$' | 'Store 01' | '$$PurchaseOrder017005$$' |
		And I close current window
	* Check for cancelled movements when the Approved status is changed to Wait
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number' |
			| '$$NumberPurchaseOrder017005$$'      |
		And I select current line in "List" table
		And I click "Decoration group title collapsed picture" hyperlink
		And I select "Wait" exact value from "Status" drop-down list
		And I click "Post" button
		And I click the hyperlink named "DecorationStatusHistory"
		And "List" table contains lines
			| 'Object'                  | 'Status'   |
			| '$$PurchaseOrder017005$$' | 'Wait'     |
			| '$$PurchaseOrder017005$$' | 'Approved' |
			| '$$PurchaseOrder017005$$' | 'Wait'     |
		And I close current window
		And I click "Post and close" button
		And I close current window
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Recorder'                | 'Store'    | 'Order'                   |
			| '$$PurchaseOrder017005$$' | 'Store 01' | '$$PurchaseOrder017005$$' |
		And I close current window



Scenario: _017011 check totals in the document Purchase Order
	* Opening a list of documents Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	* Selecting PurchaseOrder
		And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseOrder017001$$'      |
		And I select current line in "List" table
	* Check totals in the document
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "116 101,69"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "20 898,31"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "137 000,00"

	


// Scenario: _017003 check the form Pick up items in the document Purchase order
// 	* Opening a form to create Purchase Order
// 		And I close all client application windows
// 		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
// 		And I click the button named "FormCreate"
// 	* Filling in vendor information
// 		And I click Select button of "Partner" field
// 		And I go to line in "List" table
// 			| Description |
// 			| Ferron BP   |
// 		And I select current line in "List" table
// 		And I click Select button of "Legal name" field
// 		And I activate "Description" field in "List" table
// 		And I go to line in "List" table
// 			| Description       |
// 			| Company Ferron BP |
// 		And I select current line in "List" table
// 		And I click Select button of "Partner term" field
// 		And I go to line in "List" table
// 			| Description        |
// 			| Vendor Ferron, TRY |
// 		And I select current line in "List" table
// 		And I click Select button of "Store" field
// 		Then "Stores" window is opened
// 		And I select current line in "List" table
// 	* Check the form Pick up items
// 		When check the product selection form with price information in Purchase order
// 		And I close all client application windows
	

Scenario: _017101 check input item key by line in the Purchase order
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
	* Check input item key line by line
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I select "s" from "Item key" drop-down list by string in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I finish line editing in "ItemList" table
		And "ItemList" table contains lines
		| Item  | Item key |
		| Dress | S/Yellow |
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017102 check for the creation of the missing item key from the Purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
			| Vendor Ferron, TRY |
		And I select current line in "List" table
	* Creating an item key when filling out the tabular part
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I select from "Size" drop-down list by "XL" string
		And I select from "Color" drop-down list by "red" string
		And I click "Create new" button
		And I click "Save and close" button
		And Delay 2
		And I input "" text in "Size" field
		And I input "" text in "Color" field
		And "List" table became equal
		| Item key  | Item  |
		| S/Yellow  | Dress |
		| XS/Blue   | Dress |
		| M/White   | Dress |
		| L/Green   | Dress |
		| XL/Green  | Dress |
		| Dress/A-8 | Dress |
		| XXL/Red   | Dress |
		| M/Brown   | Dress |
		| XL/Red    | Dress |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button


Scenario: _017105 filter when selecting item key in the purchase order document
	* Opening a form to create a purchase order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I click the button named "FormCreate"
	* Filling in details
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I select current line in "List" table
	* Filling out vendor information
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
	* Filter check on item key when filling out the commodity part
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I select from "Size" drop-down list by "l" string
		And "List" table became equal
		| Item key |
		| L/Green  |
		| Dress/A-8  |
		And I input "" text in "Size" field
		And I select from "Color" drop-down list by "gr" string
		And "List" table became equal
		| Item key |
		| L/Green  |
		| XL/Green |
		| Dress/A-8  |
		And I close current window
		And I close current window
		Then "1C:Enterprise" window is opened
		And I click "No" button



Scenario: _019901 check changes in movements on a Purchase Order document when quantity changes
	When create a Purchase Order document
		And I click "Post" button
		And I save the value of "Number" field as "$$NumberPurchaseOrder019901$$"
		And I save the window as "$$PurchaseOrder019901$$"
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XS/Blue'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'M/White'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XL/Green'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Red'    |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Black'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '37/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'   |
		And I close all client application windows
	* Changing the quantity by Item Dress 'S/Yellow' by 250 pcs
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'    |
			| '103' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'        | 'Unit' |
			| 'Dress' | 'S/Yellow' | '200,000'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "250,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Line number' | 'Store'    | 'Order'                   | 'Item key' |
			| '250,000'  | '$$PurchaseOrder019901$$' | '1'           | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow' |
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                | 'Line number' | 'Store'    | 'Order'                   | 'Item key' |
			| '200,000'  | '$$PurchaseOrder019901$$' | '1'           | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow' |
	
Scenario: _019902 delete line in Purchase order and chek movements changes
	* Delete last line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And Delay 2
		And I go to line in "List" table
			| 'Number'    |
			| '$$PurchaseOrder019901$$' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'  |
	
Scenario: _019903 add line in Purchase order and chek movements changes
	* Add line in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '$$NumberPurchaseOrder019901$$' |
		And Delay 2
		And I select current line in "List" table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Boots'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Unit' |
			| 'Boots' | '39/18SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "100,000" text in "Q" field of "ItemList" table
		And I input "195,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'pcs' |
		And I select current line in "ItemList" table
		And I input "50,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And Delay 2
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key' |
			| '100,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'  |
			| '50,000'   | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/19SD'  |
	
Scenario: _019904 add package in Purchase order and chek movements (conversion to storage unit)
	* Add package in the order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'    |
			| '$$NumberPurchaseOrder019901$$' |
		And I select current line in "List" table
		And I move to "Item list" tab
		And I go to the last line in "ItemList" table
		And I delete current line in "ItemList" table
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'    |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Description'               |
			| 'High shoes box (8 pcs)' |
		And I select current line in "List" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| 'Item'       | 'Item key' | 'Unit' |
			| 'High shoes' | '39/19SD'  | 'High shoes box (8 pcs)' |
		And I select current line in "ItemList" table
		And I input "10,000" text in "Q" field of "ItemList" table
		And I input "190,00" text in "Price" field of "ItemList" table
		And I input "Store 03" text in "Store" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Post and close" button
	* Check registry entries (Order Balance)
	# Packages are converted into pcs.
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'          | 'Line number' | 'Store'    | 'Order'             | 'Item key'  |
			| '80,000'   | '$$PurchaseOrder019901$$' | '13'          | 'Store 03' | '$$PurchaseOrder019901$$' | '39/19SD'   |
	
Scenario: _019905 mark for deletion document Purchase Order and check cancellation of movements
	* Mark for deletion document Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '$$NumberPurchaseOrder019901$$' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key'  |
			| '250,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XS/Blue'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'M/White'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XL/Green'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Red'    |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Black'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '37/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/18SD'   |
			| '100,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'   |
			| '80,000'   | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/19SD'   |
 
Scenario: _019906 post a document previously marked for deletion and check of movements
	* Post a document previously marked for deletion
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '$$NumberPurchaseOrder019901$$' |
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key'  |
			| '250,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XS/Blue'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'M/White'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XL/Green'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Red'    |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Black'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '37/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/18SD'   |
			| '100,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'   |
			| '80,000'   | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/19SD'   |
		And I close current window


Scenario: _019907 clear posting document Purchase Order and check cancellation of movements
	* Clear posting document Purchase Order
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '$$NumberPurchaseOrder019901$$' |
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
		And I close current window
	* Check registry entries (Order Balance)
		And Delay 5
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table does not contain lines
			| 'Quantity' | 'Recorder'          |
			| '250,000'  | '$$PurchaseOrder019901$$' |
			| '200,000'  | '$$PurchaseOrder019901$$' |
		And I close current window
	* Post a document with previously cleared movements
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
		| 'Number'    |
		| '$$NumberPurchaseOrder019901$$' |
		And in the table "List" I click the button named "ListContextMenuPost"
		And I close current window
	* Check registry entries (Order Balance)
		Given I open hyperlink "e1cib/list/AccumulationRegister.OrderBalance"
		And "List" table contains lines
			| 'Quantity' | 'Recorder'                | 'Store'    | 'Order'                   | 'Item key'  |
			| '250,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'S/Yellow'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XS/Blue'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'M/White'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | 'XL/Green'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Yellow' |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/Red'    |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/Black'  |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '36/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '37/18SD'   |
			| '200,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '38/18SD'   |
			| '100,000'  | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/18SD'   |
			| '80,000'   | '$$PurchaseOrder019901$$' | 'Store 03' | '$$PurchaseOrder019901$$' | '39/19SD'   |
		And I close current window

Scenario: _019908 create Purchase invoice and Goods receipt based on a Purchase order with that contains packages
	# Packages are converted into pcs.
	Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
	And I go to line in "List" table
		| 'Number'    |
		| '$$NumberPurchaseOrder019901$$' |
	And in the table "List" I click the button named "ListContextMenuPost"
	And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
	And I click Select button of "Company" field
	And I click the button named "FormChoose"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 03'  |
	And I select current line in "List" table
	And I click "Post" button
	* Post Goods receipt
		And I click the button named "FormDocumentGoodsReceiptGenerateGoodsReceipt"
		And I click Select button of "Company" field
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I click "Post and close" button
	And I close current window





