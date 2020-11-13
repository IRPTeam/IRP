#language: en
@ExportScenarios
@IgnoreOnCIMainBuild
@tree

Feature: export scenarios

Background:
	Given I launch TestClient opening script or connect the existing one




Scenario: create discount Message Dialog Box 2 (Message 3)
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click the button named "FormCreate"
	And I click Select button of "Special offer type" field
	And I click the button named "FormCreate"
	And I click Select button of "Plugins" field
	And I go to line in "List" table
			| 'Description'                   |
			| 'ExternalSpecialMessage' |
	And I select current line in "List" table
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And I click "Save" button
	And I click "Set settings" button
	And I select "DialogBox" exact value from "Message type" drop-down list
	And I input "Message 3" text in "Message Description_en" field
	And I input "Message 3" text in "Message Description_tr" field
	And I click "Save settings" button
	And I click "Save and close" button
	And I wait "DialogBox2 (Special offer types) *" window closing in 20 seconds
	And I click the button named "FormChoose"
	And I input "8" text in "Priority" field
	And I input "01.01.2019  0:00:00" text in "Start of" field
	And I select "Sales" exact value from "Document type" drop-down list
	And I change checkbox "Launch"
	And I click Open button of the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_en"
	And I input "DialogBox2" text in the field named "Description_tr"
	And I click "Ok" button
	And in the table "Rules" I click the button named "RulesAdd"
	And I click choice button of "Rule" attribute in "Rules" table
	And I go to line in "List" table
			| 'Description'                                |
			| 'Discount on Basic Partner terms without Vat' |
	And I select current line in "List" table
	And I finish line editing in "Rules" table
	And I click "Save and close" button
	And Delay 2
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 2 without Vat' |
	And I go to line in "List" table
			| 'Description'  |
			| 'DialogBox2' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I click "List" button
	And I go to line in "List" table
			| 'Priority' | 'Special offer type' |
			| '1'        | 'Sum'                |
	And I click the button named "FormChoose"

Scenario: transfer the discount Discount 1 without Vat from Sum to Maximum
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And I expand a line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '1'        | 'Special Offers'     |
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '3'        | 'Maximum'            |
	And I click the button named "FormChoose"



Scenario: changing the auto apply of Discount 1 without Vat
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
			| 'Description'              |
			| 'Discount 1 without Vat' |
	And I select current line in "List" table
	And I remove checkbox "Manually"
	And Delay 2
	And checkbox "Manually" is equal to "No"
	And I click "Save and close" button
	And I close "Special offers" window

Scenario: create an order for MIO Basic Partner terms, without VAT (High shoes and Boots)
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description'             |
			| 'MIO' |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	And I go to line in "List" table
			| 'Description'                     |
			| 'Basic Partner terms, without VAT' |
	And I select current line in "List" table
	* Adding items to sales order
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'High shoes' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/19SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "8,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                     |
			| 'Boots' |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		Then "Item keys" window is opened
		And I go to line in "List" table
			| 'Item key' |
			| '39/18SD'  |
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"



Scenario: transfer the Discount 1 without Vat discount from Maximum to Minimum.
	Given I open hyperlink "e1cib/list/Catalog.SpecialOffers"
	And I click "List" button
	And I go to line in "List" table
		| 'Description'              |
		| 'Discount 1 without Vat' |
	And in the table "List" I click the button named "ListContextMenuMoveItem"
	And in the table "List" I click the button named "ListContextMenuLevelDown"
	And Delay 2
	And I move one level down in "List" table
	And Delay 1
	And I move one level down in "List" table
	And I go to line in "List" table
		| 'Launch' | 'Manually' | 'Priority' | 'Special offer type' |
		| 'No'     | 'No'       | '2'        | 'Minimum'            |
	And I click the button named "FormChoose"







Scenario: filling in Tax settings for company
	Given I open hyperlink "e1cib/list/Catalog.Companies"
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Tax types" tab
	And I go to line in "CompanyTaxes" table
		| 'Period'     | 'Use' | 'Tax' | 'Priority' |
		| '01.01.2020' | 'Yes' | 'VAT' | '5'         |
	And I select current line in "CompanyTaxes" table
	And I click Open button of "Tax" field
	Then "VAT (Tax type)" window is opened
	And I click "Settings" button
	And I click "Ok" button
	And I click "Save and close" button
	And I close all client application windows

Scenario: add Plugin for tax calculation
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
				| 'VAT'         |
			And I select current line in "List" table
			And I click Select button of "Plugins" field
			And I go to line in "List" table
				| 'Description' |
				| 'TaxCalculateVAT_TR'         |
			And I select current line in "List" table
			And I click "Save and close" button
		And I close all client application windows

Scenario: create PurchaseOrder017001
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
		And I go to line in "List" table
				| Description |
				| Dress       |
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
		And I go to line in "List" table
				| Description |
				| Dress       |
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
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseOrder017001$$" variable
		And I delete "$$PurchaseOrder017001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseOrder017001$$"
		And I save the window as "$$PurchaseOrder017001$$"
		And I click the button named "FormPostAndClose"

Scenario: create PurchaseOrder017003
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
			And I go to line in "List" table
				| Description |
				| Dress       |
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
			And I click the button named "FormPost"
			And I delete "$$NumberPurchaseOrder017003$$" variable
			And I delete "$$PurchaseOrder017003$$" variable
			And I save the value of "Number" field as "$$NumberPurchaseOrder017003$$"
			And I save the window as "$$PurchaseOrder017003$$"
			And I click the button named "FormPostAndClose"

Scenario: create PurchaseInvoice018001 based on PurchaseOrder017001
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberPurchaseOrder017001$$' |
		And I select current line in "List" table
		* Check filling of elements upon entry based on
			And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
			Then the form attribute named "Store" became equal to "Store 01"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I select current line in "List" table
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'     | 'Purchase order'          | 'Item key'  | 'Unit' | 'Q'       |
			| 'Dress'    | '$$PurchaseOrder017001$$' | 'M/White'   | 'pcs'  | '100,000' |
			| 'Dress'    | '$$PurchaseOrder017001$$' | 'L/Green'   | 'pcs'  | '200,000' |
			| 'Trousers' | '$$PurchaseOrder017001$$' | '36/Yellow' | 'pcs'  | '300,000' |
		* Check filling prices
			And "ItemList" table contains lines
			| 'Price'  | 'Item'     | 'Item key'  | 'Q'       | 'Price type'                         | 'Store'    |
			| '200,00' | 'Dress'    | 'M/White'   | '100,000' | 'en description is empty'           | 'Store 01' |
			| '210,00' | 'Dress'    | 'L/Green'   | '200,000' | 'en description is empty'           | 'Store 01' |
			| '250,00' | 'Trousers' | '36/Yellow' | '300,000' | 'en description is empty'           | 'Store 01' |
		* Check addition of the store in tabular part
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'  | 'Item key' | 'Store'    | 'Unit' | 'Q'       |
			| 'Dress' | 'M/White'  | 'Store 01' | 'pcs'  | '100,000' |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018001$$" variable
		And I delete "$$PurchaseInvoice018001$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018001$$"
		And I save the window as "$$PurchaseInvoice018001$$"
		And I click the button named "FormPostAndClose"

Scenario: create PurchaseInvoice018006 based on PurchaseOrder017003
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'                        |
			| '$$NumberPurchaseOrder017003$$' |
		And I select current line in "List" table
		And I click the button named "FormDocumentPurchaseInvoiceGeneratePurchaseInvoice"
		* Check filling of elements upon entry based on
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
			Then the form attribute named "Store" became equal to "Store 02"
		* Filling in the main details of the document
			And I click Select button of "Company" field
			And I select current line in "List" table
		* Check filling items table
			And I move to "Item list" tab
			And "ItemList" table contains lines
			| 'Item'     | 'Purchase order'    | 'Item key' | 'Unit' | 'Q'       |
			| 'Dress'    | '$$PurchaseOrder017003$$' | 'L/Green'  | 'pcs' | '500,000' |
		* Filling prices
			And "ItemList" table contains lines
			| 'Price' | 'Item'  | 'Item key' | 'Q'       | 'Price type'               | 'Unit' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| '40,00' | 'Dress' | 'L/Green'  | '500,000' | 'en description is empty' | 'pcs'  | '3 050,85'   | '16 949,15'  | '20 000,00'    |
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseInvoice018006$$" variable
		And I delete "$$PurchaseInvoice018006$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseInvoice018006$$"
		And I save the window as "$$PurchaseInvoice018006$$"
		And I click the button named "FormPostAndClose"



Scenario: create PurchaseReturnOrder022001 based on PurchaseInvoice018006 (PurchaseOrder017003)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling in
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "2,000" text in "Q" field of "ItemList" table
	And I input "40,00" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
	* Check the addition of the store to the tabular partner
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'  | 'Item key' | 'Purchase invoice'    | 'Store'    | 'Unit' | 'Q'     |
		| 'Dress' | 'L/Green'  | '$$PurchaseInvoice018006$$' | 'Store 02' | 'pcs' | '2,000' |
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022001$$" variable
	And I delete "$$PurchaseReturnOrder022001$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022001$$"
	And I save the window as "$$PurchaseReturnOrder022001$$"
	And I click the button named "FormPostAndClose"
	
Scenario: create PurchaseReturnOrder022006 based on PurchaseInvoice018001 (PurchaseOrder017001)
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018001$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnOrderGeneratePurchaseReturnOrder"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, TRY"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "Company" became equal to "Main Company"
	* Filling in the main details of the document
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Trousers'    | '36/Yellow'   | 'pcs' |
	And I select current line in "ItemList" table
	And Delay 2
	And I input "3,000" text in "Q" field of "ItemList" table
	And Delay 2
	And I finish line editing in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'L/Green'   | 'pcs' |
	And Delay 2
	And I delete a line in "ItemList" table
	And I go to line in "ItemList" table
		| 'Item'     | 'Item key'  | 'Unit' |
		| 'Dress'    | 'M/White'   | 'pcs' |
	And I delete a line in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturnOrder022006$$" variable
	And I delete "$$PurchaseReturnOrder022006$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturnOrder022006$$"
	And I save the window as "$$PurchaseReturnOrder022006$$"
	And I click the button named "FormPostAndClose"
	And I close current window



Scenario: create InventoryTransferOrder020001
	* Opening a form to create Inventory transfer order
			Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
			And I click the button named "FormCreate"
		* Filling in Store sender and Store receiver
			And I click Select button of "Store sender" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
			And I click Select button of "Store receiver" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 02'  |
			And I select current line in "List" table
			And I select "Approved" exact value from "Status" drop-down list
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
		* Filling in items table
			And I move to "Item list" tab
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I move to the next attribute
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'  |
				| 'M/White' |
			And I select current line in "List" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I move to the next attribute
			And I input "50,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I click the button named "Add"
			And I click choice button of "Item" attribute in "ItemList" table
			And I go to line in "List" table
				| Description |
				| Dress       |
			And I select current line in "List" table
			And I activate "Item key" field in "ItemList" table
			And I click choice button of "Item key" attribute in "ItemList" table
			And I go to line in "List" table
				| 'Item key'  |
				| 'S/Yellow' |
			And I select current line in "List" table
			And I activate "Unit" field in "ItemList" table
			And I click choice button of "Unit" attribute in "ItemList" table
			And I click the button named "FormChoose"
			And I move to the next attribute
			And I input "10,000" text in "Quantity" field of "ItemList" table
			And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberInventoryTransferOrder020001$$" variable
		And I delete "$$InventoryTransferOrder020001$$" variable
		And I save the value of "Number" field as "$$NumberInventoryTransferOrder020001$$"
		And I save the window as "$$InventoryTransferOrder020001$$"
		And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020004
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 03'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'L/Green' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "20,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020004$$" variable
	And I delete "$$InventoryTransferOrder020004$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020004$$"
	And I save the window as "$$InventoryTransferOrder020004$$"
	And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020007
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Dress       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| 'L/Green' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "17,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020007$$" variable
	And I delete "$$InventoryTransferOrder020007$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020007$$"
	And I save the window as "$$InventoryTransferOrder020007$$"
	And I click the button named "FormPostAndClose"

Scenario: create InventoryTransferOrder020010
	* Opening a form to create Inventory transfer order
		Given I open hyperlink "e1cib/list/Document.InventoryTransferOrder"
		And I click the button named "FormCreate"
	* Filling in Store sender and Store receiver
		And I click Select button of "Store sender" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I click Select button of "Store receiver" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
	* Filling in items table
		And I move to "Item list" tab
		And I click the button named "Add"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item key'  |
			| '36/Yellow' |
		And I select current line in "List" table
		And I activate "Unit" field in "ItemList" table
		And I click choice button of "Unit" attribute in "ItemList" table
		And I click the button named "FormChoose"
		And I move to the next attribute
		And I input "10,000" text in "Quantity" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransferOrder020010$$" variable
	And I delete "$$InventoryTransferOrder020010$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransferOrder020010$$"
	And I save the window as "$$InventoryTransferOrder020010$$"
	And I click the button named "FormPostAndClose"

Scenario: create SalesOrder023001
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	And I click Select button of "Partner" field
	And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'  |
	And I select current line in "List" table
	And I click Select button of "Partner term" field
	Then "Partner terms" window is opened
	And I go to line in "List" table
			| 'Description'       |
			| 'Basic Partner terms, TRY' |
	And I select current line in "List" table
	And I click Select button of "Legal name" field
	And I go to line in "List" table
			| 'Description' |
			| 'Company Ferron BP'  |
	And I select current line in "List" table
	* Filling in items table
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
		And I input "5,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of "Item" attribute in "ItemList" table
		And I go to line in "List" table
			| Description |
			| Trousers       |
		And I select current line in "List" table
		And I move to the next attribute
		And I click choice button of "Item key" attribute in "ItemList" table
		And I select current line in "List" table
		And I activate "Q" field in "ItemList" table
		And I input "4,000" text in "Q" field of "ItemList" table
		And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
		And I finish line editing in "ItemList" table
	* Check store filling in the tabular section
		And "ItemList" table contains lines
		| 'Item'     | 'Price'  | 'Item key'  | 'Store'    |
		| 'Dress'    | '550,00' | 'L/Green'   | 'Store 01' |
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	* Filling Delivery date
		And I input current date in the field named "DeliveryDate"
	And I click the button named "FormPost"
	And I delete "$$SalesOrder023001$$" variable
	And I delete "$$NumberSalesOrder023001$$" variable
	And I save the window as "$$SalesOrder023001$$"
	And I save the value of "Number" field as "$$NumberSalesOrder023001$$"
	And I close current window
	And I display "$$SalesOrder023001$$" variable value



Scenario: create SalesOrder023005
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I click the button named "FormCreate"
	* Filling in customer information
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
	And I input "10,000" text in "Q" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table
	And in the table "ItemList" I click the button named "ItemListAdd"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| Description |
		| Trousers       |
	And I select current line in "List" table
	And I move to the next attribute
	And I click choice button of "Item key" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Q" field in "ItemList" table
	And I input "14,000" text in "Q" field of "ItemList" table
	And I select "Stock" exact value from "Procurement method" drop-down list in "ItemList" table
	And I finish line editing in "ItemList" table
	* Check default sales order status
		And I move to "Other" tab
		Then the form attribute named "Status" became equal to "Approved"
	And I click the button named "FormPost"
	And I delete "$$SalesOrder023005$$" variable
	And I delete "$$NumberSalesOrder023005$$" variable
	And I save the window as "$$SalesOrder023005$$"
	And I save the value of "Number" field as "$$NumberSalesOrder023005$$"
	And I close current window
	And I display "$$SalesOrder023005$$" variable value

Scenario: create SalesInvoice024001
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| Number |
		| $$NumberSalesOrder023001$$       |
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Check that information is filled in when creating based on
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
	* Check adding Store
		And I move to "Item list" tab
		And "ItemList" table contains lines
			| 'Item'     | Price | 'Item key'  | 'Store'    | 'Sales order'          | 'Unit' | 'Q'     | 'Offers amount' | 'Tax amount' | 'Net amount' | 'Total amount' |
			| 'Dress'    | '*'   | 'L/Green'   | 'Store 01' | '$$SalesOrder023001$$' | 'pcs'  | '5,000' | '*'             | '*'          | '*'          | '*'            |
			| 'Trousers' | '*'   | '36/Yellow' | 'Store 01' | '$$SalesOrder023001$$' | 'pcs'  | '4,000' | '*'             | '*'          | '*'          | '*'            |
	* Check prices and type of prices
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'Item key'  | 'Q'     | 'Price type'        |
		| '550,00' | 'Dress'    | 'L/Green'   | '5,000' | 'Basic Price Types' |
		| '400,00' | 'Trousers' | '36/Yellow' | '4,000' | 'Basic Price Types' |	
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024001$$" variable
	And I delete "$$SalesInvoice024001$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024001$$"
	And I save the window as "$$SalesInvoice024001$$"
	And I click the button named "FormPostAndClose"
	And I close current window

Scenario: create SalesInvoice024008
	Given I open hyperlink "e1cib/list/Document.SalesOrder"
	And I go to line in "List" table
		| 'Number'                     | 'Partner'   |
		| '$$NumberSalesOrder023005$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesInvoiceGenerateSalesInvoice"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
	* Check filling prices and type of prices
		And "ItemList" table contains lines
		| 'Price'  | 'Item'     | 'Item key'  | 'Price type'              | 'Q'      |
		| '466,10' | 'Dress'    | 'L/Green'   | 'Basic Price without VAT' | '10,000' |
		| '338,98' | 'Trousers' | '36/Yellow' | 'Basic Price without VAT' | '14,000' |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024008$$" variable
	And I delete "$$SalesInvoice024008$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024008$$"
	And I save the window as "$$SalesInvoice024008$$"
	And I click the button named "FormPostAndClose"
	And I close current window


Scenario: create SalesReturnOrder028004
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' | 'Partner'     |
			| '$$NumberSalesInvoice024001$$'      |  'Ferron BP' |
		And I select current line in "List" table
		And I click the button named "FormDocumentSalesReturnOrderGenerateSalesReturnOrder"
		* Check the details
			Then the form attribute named "Partner" became equal to "Ferron BP"
			Then the form attribute named "LegalName" became equal to "Company Ferron BP"
			Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
			Then the form attribute named "Description" became equal to "Click to enter description"
			Then the form attribute named "Company" became equal to "Main Company"
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'  |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Item list" tab
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' |
			| 'Dress' | 'L/Green'  |
		And I select current line in "ItemList" table
		And I activate "Q" field in "ItemList" table
		And I input "2,000" text in "Q" field of "ItemList" table
		And I input "550,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I go to line in "ItemList" table
			| Item     | Item key  |
			| Trousers | 36/Yellow |
		And I select current line in "ItemList" table
		And I input "400,00" text in "Price" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturnOrder028004$$" variable
		And I delete "$$SalesReturnOrder028004$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturnOrder028004$$"
		And I save the window as "$$SalesReturnOrder028004$$"
		And I click the button named "FormPostAndClose"
		And I close current window

	
Scenario: create SalesReturnOrder028001
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I go to line in "List" table
		| 'Number'                       | 'Partner'   |
		| '$$NumberSalesInvoice024008$$' | 'Ferron BP' |
	And I select current line in "List" table
	And I click the button named "FormDocumentSalesReturnOrderGenerateSalesReturnOrder"
	* Check the details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
	* Select store
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Store 02'  |
		And I select current line in "List" table
	And I select "Approved" exact value from "Status" drop-down list
	And I move to "Item list" tab
	And I go to line in "ItemList" table
		| 'Item'     |
		| 'Trousers' |
	And I delete a line in "ItemList" table
	And I activate "Q" field in "ItemList" table
	And I select current line in "ItemList" table
	And I input "1,000" text in "Q" field of "ItemList" table
	And I input "466,10" text in "Price" field of "ItemList" table
	And I finish line editing in "ItemList" table
		And I move to "Item list" tab
		And "ItemList" table contains lines
		| 'Item'     | 'Item key'  | 'Store'    |
		| 'Dress'    |  'L/Green'  | 'Store 02' |
	And I click the button named "FormPost"
	And I delete "$$NumberSalesReturnOrder028001$$" variable
	And I delete "$$SalesReturnOrder028001$$" variable
	And I save the value of "Number" field as "$$NumberSalesReturnOrder028001$$"
	And I save the window as "$$SalesReturnOrder028001$$"
	And I click the button named "FormPostAndClose"
	And I close all client application windows


Scenario: create SalesInvoice024025
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	And I click the button named "FormCreate"
	* Filling in customer information
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'     |
		And I select current line in "List" table
		And I click Select button of "Legal name" field
		And I activate "Description" field in "List" table
		And I select current line in "List" table
	* Change store to Store 02
		And I click Choice button of the field named "Store"
		And I go to line in "List" table
			| Description |
			| Store 02  |
		And I select current line in "List" table
	* Filling in items table
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
		And I input "20,000" text in "Q" field of "ItemList" table
		And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberSalesInvoice024025$$" variable
	And I delete "$$SalesInvoice024025$$" variable
	And I save the value of "Number" field as "$$NumberSalesInvoice024025$$"
	And I save the window as "$$SalesInvoice024025$$"
	And I click the button named "FormPostAndClose"

Scenario: create PurchaseReturn022314
	Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
	And I go to line in "List" table
		| 'Number' |
		| '$$NumberPurchaseInvoice018006$$'      |
	And I select current line in "List" table
	And I click the button named "FormDocumentPurchaseReturnGeneratePurchaseReturn"
	* Check filling details
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "Agreement" became equal to "Vendor Ferron, USD"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Company" became equal to "Main Company"
	And I click Select button of "Store" field
	And I go to line in "List" table
		| 'Description' |
		| 'Store 02'  |
	And I select current line in "List" table
	And I click the button named "FormPost"
	And I delete "$$NumberPurchaseReturn022314$$" variable
	And I delete "$$PurchaseReturn022314$$" variable
	And I save the value of "Number" field as "$$NumberPurchaseReturn022314$$"
	And I save the window as "$$PurchaseReturn022314$$"
	And I click the button named "FormPostAndClose"
	


Scenario: create InventoryTransfer021030
	Given I open hyperlink "e1cib/list/Document.InventoryTransfer"
	And I click the button named "FormCreate"
	And I click Select button of "Store sender" field
	And I go to line in "List" table
		| Description |
		| Store 02    |
	And I select current line in "List" table
	And I click Select button of "Store receiver" field
	And I go to line in "List" table
		| Description |
		| Store 03    |
	And I select current line in "List" table
	And I click Select button of "Company" field
	And I go to line in "List" table
		| 'Description'  |
		| 'Main Company' |
	And I select current line in "List" table
	And I move to "Items" tab
	And I click the button named "Add"
	And I click choice button of "Item" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Description' |
		| 'Dress'       |
	And I select current line in "List" table
	And I activate "Item key" field in "ItemList" table
	And I click choice button of "Item key" attribute in "ItemList" table
	And I go to line in "List" table
		| 'Item key' |
		| 'L/Green' |
	And I select current line in "List" table
	And I activate "Unit" field in "ItemList" table
	And I click choice button of "Unit" attribute in "ItemList" table
	And I select current line in "List" table
	And I activate "Quantity" field in "ItemList" table
	And I input "3,000" text in "Quantity" field of "ItemList" table
	And I finish line editing in "ItemList" table
	And I click the button named "FormPost"
	And I delete "$$NumberInventoryTransfer021030$$" variable
	And I delete "$$InventoryTransfer021030$$" variable
	And I save the value of "Number" field as "$$NumberInventoryTransfer021030$$"
	And I save the window as "$$InventoryTransfer021030$$"
	And I click the button named "FormPostAndClose"

Scenario: create SalesInvoice024016 (Shipment confirmation does not used)
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click the button named "FormCreate"
		* Filling in customer information
			And I click Select button of "Partner" field
			And I go to line in "List" table
				| 'Description' |
				| 'Kalipso'     |
			And I select current line in "List" table
			And I click Select button of "Partner term" field
			And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, without VAT'     |
			And I select current line in "List" table
		* Select store 
			And I click Select button of "Store" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 01'  |
			And I select current line in "List" table
			And I click Select button of "Legal name" field
			And I activate "Description" field in "List" table
			And I select current line in "List" table
		* Filling in items table
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
		And I click the button named "FormPost"
		And I delete "$$NumberSalesInvoice024016$$" variable
		And I delete "$$SalesInvoice024016$$" variable
		And I delete "$$DateSalesInvoice024016$$" variable
		And I save the value of "Number" field as "$$NumberSalesInvoice024016$$"
		And I save the window as "$$SalesInvoice024016$$"
		And I save the value of the field named "Date" as "$$DateSalesInvoice024016$$"
		And I click the button named "FormPostAndClose"

Scenario: create SalesReturn30001
	* Open form  Sales return
		Given I open hyperlink "e1cib/list/Document.SalesReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Basic Partner terms, TRY'         |
		And I select current line in "List" table
		* Filling in item and item key
			And I click "Add" button
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
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberSalesReturn30001$$" variable
		And I delete "$$SalesReturn30001$$" variable
		And I save the value of "Number" field as "$$NumberSalesReturn30001$$"
		And I save the window as "$$SalesReturn30001$$"
		And I click the button named "FormPostAndClose"


Scenario: create PurchaseReturn300301
	* Open form  Purchase return
		Given I open hyperlink "e1cib/list/Document.PurchaseReturn"
		And I click the button named "FormCreate"
	* Check filling in legal name if the partner has only one
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'         |
		And I select current line in "List" table
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		And I click Select button of "Partner term" field
		And I go to line in "List" table
			| 'Description' |
			| 'Vendor Ferron, TRY'         |
		And I select current line in "List" table
		And I click Select button of "Store" field
		And I go to line in "List" table
			| 'Description' |
			| 'Store 01'         |
		And I select current line in "List" table
		* Filling in item and item key
			And I click "Add" button
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
			And I input "1,000" text in "Q" field of "ItemList" table
			And I finish line editing in "ItemList" table
			And I input "500,00" text in "Price" field of "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$NumberPurchaseReturn300301$$" variable
		And I delete "$$PurchaseReturn300301$$" variable
		And I save the value of "Number" field as "$$NumberPurchaseReturn300301$$"
		And I save the window as "$$PurchaseReturn300301$$"
		And I click the button named "FormPostAndClose"


Scenario: set True value to the constant
		And I set "True" value to the constant "ShowBetaTesting"
		And I set "True" value to the constant "ShowAlphaTestingSaas"
		And I set "True" value to the constant "UseItemKey"
		And I set "True" value to the constant "UseCompanies"

Scenario: add sales tax settings 
		Given I open hyperlink "e1cib/list/Catalog.Taxes"
		And I go to line in "List" table
				| 'Description' |
				| 'SalesTax'         |
		And I select current line in "List" table
		And I click Select button of "Plugins" field
		And I go to line in "List" table
				| 'Description'        |
				| 'TaxCalculateVAT_TR' |
		And I select current line in "List" table
		And I click "Settings" button
		And I click "Ok" button
		And I click "Save and close" button
		And I close all client application windows
		

Scenario: add test extension
	Given I open hyperlink "e1cib/list/Catalog.Extensions"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#\DataProcessor\IRP_TestExtension.cfe"
	And I click "Add file" button
	And I input "TestExtension" text in "Description" field
	And I click the button named "FormWriteAndClose"
	And I close TestClient session
	And I install the "TestExtension" extension
	Given I open new TestClient session or connect the existing one

Scenario: add Additional Functionality extension
	Given I open hyperlink "e1cib/list/Catalog.Extensions"
	And I click the button named "FormCreate"
	And I select external file "#workingDir#\DataProcessor\IRP_AdditionalFunctionality.cfe"
	And I click "Add file" button
	And Delay 2
	And I input "AdditionalFunctionality" text in "Description" field
	And I click the button named "FormWriteAndClose"
	And I close TestClient session
	And I install the "AdditionalFunctionality" extension
	Given I open new TestClient session or connect the existing one	

Scenario: create Workstation
		Given I open hyperlink "e1cib/list/Catalog.Workstations"
		And I click the button named "FormCreate"
		And I input "Workstation 01" text in "Description" field
		And I click Select button of "Cash account" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Cash desk №2' |
		And I select current line in "List" table
		And I click "Set current" button
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one